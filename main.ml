open Graphics
open Gui
open Types
open State

(* [turn] holds the int indicating the current turn *)
let turn = ref 0

(* [num_players] holds the int indicating the number of players. *)
let num_players = ref 0

(* [incr_ctr n] increments the turn reference by 1 and goes
 * back to 0 if !turn  = n. *)
let incr_ctr n = turn := (!turn + 1) mod n

(* [player] is an array containing the players *)
let players = ref [||]

(* [human_prompt st pid b_value] updates the state [st] if
 * [pid] is of type Human and [b_value] is true.
 * effects: displays error message if [b_value] is false. *)
let rec human_prompt st pid b_value=
  if not b_value then Gui.displ_error_msg ();
    let command = (Gui.get_cell_from_click (), pid) in
    let bval = (do' st command) in
    if bval then ()
    else human_prompt st pid false

(* [ai_prompt st pid] updates the state [st] if [pid] is of type AI.
 * effects: none *)
let rec ai_prompt st pid =

  Gui.displ_ai ();

  match pid with
  |AI(i,j) -> (match j with
      |Smart -> ();
      |_ -> Unix.sleep (1);
    );
    (let ai_move  = Ai.get_move st pid j in
     if  do' st ai_move then ())
  | _ -> failwith "Implementation error"

(* [get_strategy x] returns the AI strategy specified in [x] *)
let rec get_strategy x =
  match x with
  | "Random" -> Random
  | "Greedy" -> Greedy
  | "Smart"  -> Smart
  | _ -> failwith "Invalid input"

(* [select_players idx num_player] draws the player selection dialogue box
 * for player id [idx]. *)
let rec select_players idx num_players =
  if idx > num_players then ()
  else
     match Gui.draw_player_selection idx num_players with
     | "Human" -> !players.(idx-1) <- Human (idx); select_players (idx+1) num_players
     | x -> !players.(idx-1) <- AI(idx, get_strategy x); select_players (idx+1) num_players

(* [game_play] calls the main game loop after initializing the players and
 * the initial state of the game board. *)
let rec game_play () =
  let n = !num_players in
  players := Array.make n (Human 0);
  select_players 1 n;
  let st = State.init_state n in
  game_loop st

(* [main] handles the start screen and the instructions screen
* before the game starts.*)
and main () =
  try
  Gui.init ();
  Gui.draw_start ();
  Gui.draw_instructions ();
  num_players := Gui.draw_num_players ();
  game_play ()
  with
    e -> ()

(* [game_loop st] is the main loop that updates and draws
 * the state [st] and inputs user commands. *)
and game_loop st =
if not (State.is_full st) then
   (Gui.draw_game st;
    Gui.draw_score_game_screen st !players !num_players;
   let curr_turn = !turn in
   incr_ctr !num_players;
   begin
     match !players.(curr_turn) with
     | Human pid -> Gui.draw_turn pid;
       Gui.draw_possible_moves st (Human pid);
       human_prompt st (Human pid) true
     | AI (i,j) -> Gui.draw_turn i; ai_prompt st (AI(i,j))
   end
   ; game_loop st)
else
  Gui.draw_game st; Gui.draw_score_game_screen st !players !num_players;
  Unix.sleep (3);
  match Gui.draw_end st !players !num_players with
  |(-1) -> Graphics.close_graph ()
  |_ -> Graphics.close_graph(); main ()

let _ = main ()
