open Graphics
open Types
open State

exception End

(* COLORS *)
let black = rgb 00 00 00
let white = rgb 255 255 255
let blue  = rgb 30 25 255
let green = rgb 00 94 42
let panel_color = rgb 234 234 234

let light_cyan = rgb 198 236 245
let light_pink = rgb 238 198 245
let light_orange = rgb 245 225 198
let light_red = rgb 245 298 200

let cyan = rgb 00 255 255
let pink = rgb 255 51 255
let orange = rgb 255 128 0
let red = rgb 255 51 51

(* PLAYER COLORS *)
(* dummy color at zero index, to make indexing convenient *)
let player_colors = [|white; cyan; pink; orange; red|]
let player_strings = [|"white";"blue";"pink";"orange";"red"|]

(* GRAPH ELEMENTS *)
let line_width = 3
let square_side = 60
let circle_radius = 14

let graph_width = 9 * line_width + 8 * square_side
let panel_height = square_side
let graph_height = graph_width + (3 * line_width) + (1*panel_height)
let dimensions = " " ^ string_of_int graph_width ^ "x" ^ string_of_int graph_width

let score_x_coord_screen1 = (graph_width)/2 + square_side/2
let score_y_coord_screen1 = (graph_height - (square_side)/2)

(* https://discuss.ocaml.org/t/more-natural-preferred-way-to-shuffle-an-array/217 *)
(* Simple O(n) method for shuffling an array *)
let knuth_shuffle a =
  let n = Array.length a in
  let a = Array.copy a in
  for i = n - 1 downto 1 do
    let k = Random.int (i+1) in
    let x = a.(k) in
    a.(k) <- a.(i);
    a.(i) <- x
  done;
  a

(* Gets the player color associated with the [pid] *)
let get_player_color pid =
  player_colors.(pid)

(* Creates a list from 0 to n inclusive*)
let create_list (n : int) =
  let rec loop (acc : int list) n' =
    if n' = 0 then (0::acc)
    else loop (n'::acc) (n'-1)
  in loop [] n

(* Clears the canvas and sets its color to [color] *)
let clear_window color =
  let fg = foreground
  in
  set_color color;
  fill_rect 0 0 (size_x ()) (size_y ());
  set_color fg

let init () =
  open_graph dimensions;
  set_window_title "MULTIVERSI";
  clear_window black

type filetype = PNG | JPG

(* [get_rgb_array dimx dimy filename file_type] reads in a file of [filename],
 * which contains RGB picture data in each line, and stores the integer in
 * each line in a created array, which is then returned. *)
let get_rgb_array dimx dimy filename file_type: int array =
  let num_indices = dimx * dimy * (match file_type with | JPG -> 3 | PNG -> 4) in
  let rgb_array = Array.make num_indices 0 in
  let inc = open_in filename in
  for i = 0 to (num_indices - 1) do
    rgb_array.(i) <- (inc |> input_line |> int_of_string)
  done; close_in inc; rgb_array

(* [draw_image startx starty dimx dimy filename file_type] draws an image of
 * [file_type] (with its RGB data stored in [filename]) of width [dimx] and
 * height [dimy] and onto the GUI window. The top left corner of the image begins
 * at ([startx], [starty]) *)
let draw_image startx starty dimx dimy filename file_type =
  let arr : int array = get_rgb_array dimx dimy filename file_type in
  let num_pts = (dimx * dimy) in
  for i = 0 to (num_pts - 1) do
    let idx = i in
    let y = idx / dimx in
    let x = idx mod dimx in
    match file_type with
    | PNG -> begin let c = idx * 4 in
        let trans = arr.(c+3) in
        if trans = 0 then ()
        else (let color = (rgb (arr.(c)) (arr.(c+1)) (arr.(c+2))) in
              set_color color; plot (startx + x) (starty + dimy - 1 - y)) end
    | JPG -> begin
        let c = idx * 3 in
        let color = (rgb (arr.(c)) (arr.(c+1)) (arr.(c+2))) in
        set_color color; plot (startx + x) (starty + dimy - 1 - y) end
  done

(* [default_screen] draws the basic screen layout with a green background
 * and a black border *)
let default_screen () =
  clear_window green;
  fill_rect (0 * (line_width + square_side)) 0 line_width graph_width;
  fill_rect 0 (0 * (line_width + square_side)) graph_width line_width;
  fill_rect (8 * (line_width + square_side)) 0 line_width graph_width;
  fill_rect 0 (8 * (line_width + square_side)) graph_width line_width

(* [wait_for_click] waits for a mouse click before completing *)
let wait_for_click () =
  try let s = Graphics.wait_next_event [Graphics.Button_down]
    in ignore(s); ()
  with
  | End -> raise End
  | e -> raise e

let draw_start () =
  let arr = get_rgb_array graph_width graph_width "images/start_screen.txt" JPG in
  let num_pts = (graph_width * graph_width) in
  let pts = create_list (num_pts - 1) |> Array.of_list |> knuth_shuffle in
  for i = 0 to (num_pts - 1) do
    let idx = pts.(i) in
    let y = idx / graph_width in
    let x = idx mod graph_width in
    let c = idx * 3 in
    let color = (rgb (arr.(c)) (arr.(c+1)) (arr.(c+2))) in
    set_color color; plot x (graph_width - 1 - y)
  done; wait_for_click ()

let draw_instructions () =
  default_screen ();
  let kx = 0.01 in
  let ky = 0.10 in
  let width = float_of_int (graph_width - 1) in
  draw_image
    (int_of_float (kx *. width))
    (int_of_float (ky *. width))
    502 407 "images/instructions.txt" PNG;
  wait_for_click ()

(* [get_player_type_click1] returns the string of the text clicked on in the
 * player type selection screen. For 2-player games only (includes smart AI) *)
let get_player_type_click1 () : string =
  let sel_width = 90 in
  let sel_height = 30 in
  let y = 160 in
  let x1 = 38 in
  let x2 = 198 in
  let x3 = 296 in
  let x4 = 404 in
  let rec loop () : string =
    try
      let s = Graphics.wait_next_event [Graphics.Button_down]
      in (if s.Graphics.button then
            let my = s.Graphics.mouse_y in
            if my >= y && my <= y + sel_height then
              let mx = s.Graphics.mouse_x in begin
                match mx with
                | x when x >= x1 && x <= x1 + sel_width -> "Human"
                | x when x >= x2 && x <= x2 + sel_width -> "Random"
                | x when x >= x3 && x <= x3 + sel_width -> "Greedy"
                | x when x >= x4 && x <= x4 + sel_width -> "Smart"
                | _ -> loop ()
              end
            else loop ()
          else loop ())
    with
    | End -> raise End
    |  e  -> raise e
  in loop ()

(* [get_player_type_click2] returns the string of the text clicked on in the
 * player type selection screen. For 3/4-player games only (no smart AI) *)
let get_player_type_click2 () : string =
  let sel_width = 90 in
  let sel_height = 30 in
  let y = 160 in
  let x1 = 72 in
  let x2 = 220 in
  let x3 = 332 in
  let rec loop () : string =
    try
      let s = Graphics.wait_next_event [Graphics.Button_down]
      in (if s.Graphics.button then
            let my = s.Graphics.mouse_y in
            if my >= y && my <= y + sel_height then
              let mx = s.Graphics.mouse_x in begin
                match mx with
                | x when x >= x1 && x <= x1 + sel_width -> "Human"
                | x when x >= x2 && x <= x2 + sel_width -> "Random"
                | x when x >= x3 && x <= x3 + sel_width -> "Greedy"
                | _ -> loop ()
              end
            else loop ()
          else loop ())
    with
    | End -> raise End
    |  e  -> raise e
  in loop ()


let draw_player_selection (i : int) (n : int): string =
  default_screen ();
  let kx1_1 = 0.05 in
  let kx1_2 = 0.13 in
  let ky1 = 0.30 in
  let width = float_of_int (graph_width - 1) in
  let starty = (int_of_float (ky1 *. width)) in
  begin
  match n with
    | 2 -> draw_image (int_of_float (kx1_1 *. width)) starty 473 118 "images/player_select.txt" PNG
    | _ -> draw_image (int_of_float (kx1_2 *. width)) starty 375 119 "images/player_select2.txt" PNG
  end;
  let kx2 = 0.30 in
  let ky2 = 0.60 in
  let x_coord = int_of_float (kx2 *. width) in
  let y_coord = int_of_float (ky2 *. width) in
  draw_image x_coord y_coord 216 74
  (match i with
    | 1 -> "images/player1.txt"
    | 2 -> "images/player2.txt"
    | 3 -> "images/player3.txt"
    | 4 -> "images/player4.txt"
    | _ -> failwith "Invalid input") PNG;
  match n with
  | 2 -> get_player_type_click1 ()
  | _ -> get_player_type_click2 ()

(* [get_num_players_click] gets the number clicked on in the screen
 * for selecting the number of players *)
let get_num_players_click () : int =
  let sq = 38 in
  let y = 218 in
  let x1 = 66 in
  let x2 = 234 in
  let x3 = 402 in
  let rec loop () : int =
    try
      let s = Graphics.wait_next_event [Graphics.Button_down]
      in (if s.Graphics.button then
            let my = s.Graphics.mouse_y in
            if my >= y && my <= y + sq then
              let mx = s.Graphics.mouse_x in begin
                match mx with
                | x when x >= x1 && x <= x1 + sq -> 2
                | x when x >= x2 && x <= x2 + sq -> 3
                | x when x >= x3 && x <= x3 + sq -> 4
                | _ -> loop ()
              end
            else loop ()
          else loop ())
    with
    | End -> raise End
  in loop ()

let draw_num_players () : int =
  default_screen ();
  let kx = 0.05 in
  let ky = 0.40 in
  let width = float_of_int (graph_width - 1) in
  draw_image
    (int_of_float (kx *. width))
    (int_of_float (ky *. width))
    456 133 "images/players.txt" PNG;
  get_num_players_click ()

(* Draws panel at the top of the game screen *)
let draw_panel_lines () =
  let fg = foreground in
  set_color panel_color;
  fill_rect 0 (graph_height - 1*panel_height - 3*line_width)
            (graph_width) (2*panel_height + 2*line_width);
  set_color fg;
  fill_rect 0 (graph_height - line_width) graph_width line_width;
  fill_rect 0 (graph_width) line_width (panel_height + 3*line_width);
  fill_rect (graph_width - line_width) (graph_width) line_width (panel_height + 3*line_width)

(* Draws the black lines forming the board *)
let draw_grid_lines () =
  for i = 0 to 8 do
    fill_rect (i * (line_width + square_side)) 0 line_width graph_width;
    fill_rect 0 (i * (line_width + square_side)) graph_width line_width;
  done

(* Draws a circle at cell ([row_idx], [col_idx]) on the board with the
 * color associated with the player id in [piece] *)
let draw_circle row_idx col_idx piece =
  let dist = square_side + 3 in
  let base_xy = (3+(square_side / 2)) in
  let x_coord = base_xy + (col_idx) * dist in
  let y_coord = base_xy + (7-row_idx) * dist in
  match piece with
  | None -> ()
  | Some pid -> let color = get_player_color pid in
    set_color color; fill_circle x_coord y_coord circle_radius

(* Draws all the pieces currently on the board according to [st] *)
let draw_pieces (st: state) =
  for x = 0 to 7 do
    for y = 0 to 7 do
      draw_circle x y (State.piece_at st (x,y))
    done
  done

let draw_game (st : state) =
  resize_window graph_width graph_height;
  clear_window green;
  draw_panel_lines ();
  draw_grid_lines ();
  draw_pieces st

(* [get_cell x y] gets the coordinate of the cell containing GUI window
 * coordinates ([x], [y]) *)
let get_cell x y =
  let x' =  (x + line_width) / (line_width + square_side) in
  let y' =  (y + line_width) / (line_width + square_side) in
  let i_th_square = (7 - y') in
  let j_th_square = x' in
  (i_th_square, j_th_square)

let get_cell_from_click () =
  try
    let s = Graphics.wait_next_event [Graphics.Button_down]
    in if s.Graphics.button
    then get_cell s.Graphics.mouse_x s.Graphics.mouse_y
    else (-1,-1)
  with
    End -> raise End

let displ_error_msg () =
  let kx1 = 0.01 in
  let ky1 = 0.94 in
  draw_image
    (int_of_float (kx1*. float_of_int graph_width))
    (int_of_float (ky1*. float_of_int graph_width))
    507 75 "images/invalid.txt" PNG


let displ_ai ()=
  let kx1 = 0.05 in
  let ky1 = 0.94 in
  draw_image
    (int_of_float (kx1*. float_of_int graph_width))
    (int_of_float (ky1*. float_of_int graph_width))
    507 75 "images/aiprompt.txt" PNG

(*draw_score_image x y] draws the image for text "Score:" onto
  GUI window beginning at position ([x],[y]).*)
let draw_score_image x y  =
  let kx1 = x in
  let ky1 = y in
  draw_image
    (int_of_float (kx1*. float_of_int graph_width))
    (int_of_float (ky1*. float_of_int graph_width))
    150 75 "images/score1.txt" PNG

(*[draw_score x y st player_ar i] draws the score for
  all the [i] players in [player_ar] according to the current
  state [st] beginning at position ([x],[y]) on the GUI window.*)
let draw_score x y st player_array n=
  let start_x_coord = x in
  let start_y_coord = y in
  moveto start_x_coord start_y_coord;draw_score_image 0.32 1.02;
  for i = 1 to n do
    set_color (get_player_color i);
    fill_circle (current_x () + 10) (current_y () + 5) circle_radius;
    set_color black; moveto (current_x () + 7) (current_y ());
    draw_string (string_of_int (State.player_score st player_array.(i-1)));
    moveto (current_x () + 30) (current_y ());
  done


let draw_score_game_screen st player_array n=
  draw_score (score_x_coord_screen1) (score_y_coord_screen1) st player_array n


(*[draw_turn_image] draws the image for text "TURN:" onto GUI window.*)
let draw_turn_image () =
  let kx1 = 0.04 in
  let ky1 = 1.02 in
  draw_image
    (int_of_float (kx1*. float_of_int graph_width))
    (int_of_float (ky1*. float_of_int graph_width))
    150 75 "images/turn.txt" PNG


let draw_turn pid =
  let y_coord = (graph_height - (square_side)/2) in
  let x_coord = (square_side/2) in
  moveto x_coord y_coord;
  draw_turn_image (); moveto (x_coord + 90) (y_coord);
  set_color (get_player_color pid);
  fill_circle (current_x () + 10) (current_y () + 5) circle_radius;
  set_color black;
  moveto (current_x () + 7) (current_y ());
  draw_string (string_of_int pid)


(*[draw_possible row col pid] draws the possible move at the cell
  given by [row] and [col] for the player with id [pid].*)
let draw_possible row_idx col_idx pid =
    let dist = square_side + 3 in
    let base_xy = (3+(square_side / 2)) in
    let x_coord = base_xy + (col_idx) * dist in
    let y_coord = base_xy + (7-row_idx) * dist in
    draw_image (x_coord - base_xy) (y_coord - base_xy)
      60 60 ("images/pin_"^(player_strings.(pid))^".txt") PNG


let draw_possible_moves st pid =
  let possible_move_list = State.poss_moves st pid in
  let pl_num =
    begin
      match pid with
      | Human i -> i
      | AI(i,j) -> i
    end
in
  let rec draw_moves lst =
    match lst with
    |(i,j)::t -> draw_possible i j pl_num; draw_moves t
    |_ -> ()
  in
  draw_moves possible_move_list

(*[find_winner st player_ar n] returns an array
  with all the winners, even if more than 1 in case of a tie,
  and their scores.*)
let find_winner st player_ar n =
    let max_score = ref (-1) in
    let winner_arr = Array.make 5 (-1) in
    for i = 1 to n do
      let s = State.player_score st player_ar.(i-1) in
      if s > (!max_score) then
         (max_score := s;
         Array.fill winner_arr 0 5 (-1);
         winner_arr.(i) <- s)
     else if s = !max_score
     then winner_arr.(i) <- State.player_score st player_ar.(i-1);
    done; winner_arr

(* [get_final_choice] returns 1 if player chooses "Play Agin"
 * or -1 if player chooses "Quit". *)
let get_final_choice ()  =
  let yp1 = 126 in
  let yp2 = 164 in
  let yq1 = 59 in
  let yq2 = 113 in

  let xp1 = 167 in
  let xp2 = 347 in
  let xq1 = 186 in
  let xq2 = 315 in

  let rec loop ()  =
    try
      let s = Graphics.wait_next_event [Graphics.Button_down]
      in (if s.Graphics.button then
            let my = s.Graphics.mouse_y in
            let mx = s.Graphics.mouse_x in
                if my >= yp1 && my <= yp2 && mx>=xp1 && mx <= xp2
                then 1
                else if my >= yq1 && my <= yq2 && mx >=xq1 && mx <= xq2
                then (-1)
            else loop ()
          else loop ())
    with
    | End -> raise End
    |  e  -> raise e
  in loop ()


let draw_end st player_array n =
  resize_window graph_width graph_width;
  default_screen();
  let winner_arr = find_winner st player_array n in
  draw_score_image 0.32 0.86;
  draw_score (score_x_coord_screen1) (score_y_coord_screen1 - 80) st player_array n;
  let kx1 = ref 0.3 in
  let ky1 = ref 0.5 in
  let width = float_of_int (graph_width - 1) in
  for i = 1 to n do
    if winner_arr.(i) != (-1) then
      (draw_image
         (int_of_float (!kx1 *. width))
         (int_of_float (!ky1 *. width))
         216 75 ("images/win"^(string_of_int i)^".txt") PNG;
       ky1 := !ky1 -. 0.1;)
  done;
  ky1:= 0.2;
  draw_image
    (int_of_float (!kx1 *. width))
    (int_of_float (!ky1 *. width))
    216 75 "images/playagain.txt" PNG;
  ky1:= 0.1;
  draw_image
    (int_of_float (!kx1 *. width))
    (int_of_float (!ky1 *. width))
    216 75 "images/quit.txt" PNG;
  get_final_choice ()
