open Types

type state =  piece array array


let init_state num_player =
  let st =  Array.make_matrix 8 8 None in
  if num_player = 2
  then (st.(3).(3) <- Some 1; st.(4).(4) <- Some 1; st.(4).(3) <- Some 2; st.(3).(4) <- Some 2; st)
  else if num_player = 3 then
  (st.(3).(3) <- Some 1; st.(3).(4) <- Some 2; st.(4).(3) <- Some 3; st)
  else (st.(3).(3) <- Some 1; st.(4).(4) <- Some 2; st.(4).(3) <- Some 3; st.(3).(4) <- Some 4; st)

let is_full st =
  let full = ref true in
  for row = 0 to 7 do
    for col = 0 to 7 do
      match st.(row).(col) with
      |None -> full := false
      | _ -> ()
    done;
  done;
  !full

let piece_at st c =
  st.(fst c).(snd c)

let player_score st player =
  let player_id =
    match player with
    | Human i -> i
    | AI (i, _) -> i
  in
  let score = ref 0 in
  for row = 0 to 7 do
    for col = 0 to 7 do
      match st.(row).(col) with
      |None -> ()
      |Some id -> if id = player_id then score := !score + 1 else ()
    done;
  done;
  !score

(*[on_board row col] returns true if [row] and [col] are
within the bounds of the board.*)
let on_board row col = -1 < row && row < 8 && -1 < col && col < 8

(*[is_empty st row col] returns true if the cell at ([row],[col]) is
  vacant for current state of the board [st].*)
let is_empty st row col =
match piece_at st (row, col) with
  |None -> true
  |_ -> false

(*[id_at st row col] reurns the if the player whose piece is stored
  at the cell ([row],[col]) for the current state [st]. Returns 0 if
  the cell is vacant.*)
let id_at st row col =
  match piece_at st (row, col) with
  |None -> 0
  |Some i -> i

(* [probe st player_id drow dcol] returns a tuple containing the score
   of the move and a boolean representing if the move was successful
   the method takes in a state and player who is making the move, as
   well as a starting position (irow, icol) and then a direction which is
   an integer tuple of (drow, dcol) where both numbers are between -1 and 1.
   This tuple defines the "direction of probing" 9 possible directions *)
let probe st player_id (irow, icol) (drow, dcol) =
  let completed = ref false in
  let success = ref false in
  let score = ref 0 in
  let row = ref (irow + drow) in
  let col = ref (icol + dcol) in
  if (not (on_board !row !col)) || ((id_at st !row !col) = player_id) then 0, false
  else
  (while (not !completed) do
     if (not (on_board !row !col)) || (is_empty st !row !col) then completed := true
     else if ((id_at st !row !col) = player_id) then (completed := true; success := true;)
     else (row := !row + drow; col := !col + dcol; score := !score + 1)
done;
!score, !success)


(* Will return an (int * int) list option representing the direction(s) of the move*)
let is_valid_move st row col player_id =
  let dir_list = ref [] in
  match piece_at st (row, col) with
  |Some _ -> None
  |None -> begin
      for i = -1 to 1 do
        for j = -1 to 1 do
          if (i = 0 && j = 0) then () else
            let (sc, bo) = (probe st player_id (row, col) (i, j)) in
          if bo then dir_list := ((i,j, sc)::!dir_list)
          else ()
        done;
      done;
      if (List.length !dir_list) > 0 then (Some !dir_list) else None end

(*[num_neighbors st row col] returns the number of neighboring occupied
  cells for the cell ([row],[col]) in the current state [st].*)
let num_neighbors st row col =
  let num = ref (0) in
  for i = -1 to 1 do
    for j = -1 to 1 do
      if on_board (row + i) (col + j) && not (is_empty st (row+i) (col+j)) then num := !num + 1
    done;
  done;
  if is_empty st row col then !num else !num - 1

(* [adjacent_moves st] returns the list of pairs (cell,0) where
 * cell is adjacent to one of the player pieces on the board for the
 * current state [st]. *)
let adjacent_moves st =
  let moves = ref [] in
  for row = 0 to 7 do
    for col = 0 to 7 do
      if ((is_empty st row col) && (num_neighbors st row col) > 0) then moves := (row,col,0)::!moves else ()
    done;
  done;
  !moves

(* Sums up the scores of flips in each direction that gains points.
Takes in a list of 3-tuples where the final element in the tuple is the score*)
let sum_dirs dirs =
  List.fold_left (+) 0 (List.map (fun (a,b,c) -> c) dirs)

let poss_moves_with_scores st player =
let player_id = match player with | Human i -> i | AI (i, _) -> i in
let move_list = ref [] in
for row = 0 to 7 do
  for col = 0 to 7 do
    match (is_valid_move st row col player_id) with
    | None -> ()
    | Some dirs -> move_list := (row, col, sum_dirs dirs)::!move_list
  done;
done;
if (List.length (!move_list) = 0) then adjacent_moves st else !move_list


let poss_moves st player =
  List.map (fun (a,b,c) -> (a,b)) (poss_moves_with_scores st player)

(* flips all the necessary tiles to make a move at the given irow and icol *)
let rec flip_all st player_id irow icol dirs =
    st.(irow).(icol) <- Some player_id;
  match dirs with
  | [] -> ()
  | (drow, dcol, _ )::t -> begin
  let row = ref (irow + drow) in let col = ref (icol +dcol) in
  while id_at st !row !col != player_id do
    st.(!row).(!col) <- Some player_id; row := !row + drow; col := !col + dcol
  done;  flip_all st player_id irow icol t
end

(*[contains_move (row,col) moves] returns true if [(row,col)]
  is present in the list [moves].*)
let contains_move (row, col) moves =
  List.mem (row,col) (List.map (fun (a,b,c) -> (a,b)) moves)

let do' st com =
  let row = fst (fst com) in let col = snd (fst com) in
  let player_id = match snd com with |Human i -> i | AI (i, _) -> i in
  let p_moves = poss_moves_with_scores st (snd com) in if (contains_move (row,col) p_moves) then
  match (is_valid_move st row col player_id) with
  | None -> st.(row).(col) <- Some player_id; true
  | Some dirs -> flip_all st player_id row col dirs; true
  else false

let copy_state st =
  let new_st = Array.make_matrix 8 8 None in
  for  i = 0 to 7 do
      for j = 0 to 7 do
        new_st.(i).(j) <- st.(i).(j) done;done; new_st
