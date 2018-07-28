open Types
open State

(*The depth searched by the minimax algorithm *)
let max_depth = 2

(* a random move produced by the ai for the given [st] and [player] *)
let random_move st player =
  let moves = State.poss_moves_with_scores st player
  in let n = Random.int (List.length(moves))
  in let (row,col,sc) = List.nth moves n in ((row,col), player)

(* [get_top_moves] is the list of top scoring moves in [moves] *)
let get_top_moves moves =
  let rec top_moves_help acc start_top = function
    | [] -> acc
    | (r,c,sc)::t -> if sc > start_top then top_moves_help ((r,c,sc)::[]) sc t
      else if sc = start_top then top_moves_help ((r,c,sc)::acc) sc t
      else top_moves_help acc start_top t
  in top_moves_help [] 0 moves

(* [greedy_move] is the move by [player] in [st] that gains the most pieces*)
let greedy_move st player =
  let poss_moves = State.poss_moves_with_scores st player
  in let moves = get_top_moves poss_moves
  in let n = Random.int (List.length(moves))
  in let (row,col,sc) = List.nth moves n in ((row,col), player)

(* [is_mine] returns +1000 if the ai owns the location, -1000 if opponent does,
   and 0 otherwise. *)
let is_mine st (row,col) ai_id=
  match State.piece_at st (row,col) with
  | None -> 0
  | Some i -> if i = ai_id then 1000 else -1000

(* [heuristic] evaluations the board from the perspective of the AI, with
   high values corresponding to good position for the ai *)
let heuristic st ai_id moves_num =
  let score = player_score st (AI (ai_id, Smart)) + (moves_num * 10) in
  score + (is_mine st (0,0) ai_id) + (is_mine st (0,7) ai_id)
  + (is_mine st (7,0) ai_id) + (is_mine st (7,7) ai_id)


(* the minimax function *)
let rec minimax st depth ( ai_id :int ) (whose_turn : int) min_lim max_lim =
  let moves = poss_moves st (AI (whose_turn, Smart)) in
  let value = heuristic st ai_id (List.length moves) in
  if depth > max_depth  || State.is_full st then value else
  if whose_turn == ai_id then (*maximize*)
  let count = ref (-1) in let best_val = ref (min_lim)
  in while !count + 1 < List.length moves do count := !count+1;
    let copy = State.copy_state st in let move = (List.nth moves !count)
    in let _ = do' copy (move,  (AI (whose_turn, Smart))) in
    let calc_value =
      minimax copy (depth+1) ai_id (((whose_turn) mod 2) + 1) !best_val max_lim
    in (if calc_value > !best_val then (best_val := calc_value)
        else ()); (* update max value found*)
    if  !best_val > max_lim (*quit out if above the max_limit*)
      then (count := (List.length moves + 10);
          best_val := max_lim) else ()
    done;
    !best_val

  else (*minimize*)
  let count = ref (-1) in let best_val = ref (max_lim)
  in while !count + 1 < List.length moves do count := !count+1;
    let copy = State.copy_state st in let move = (List.nth moves !count)
    in let _ = State.do' copy (move,  (AI (whose_turn, Smart)))
    in let calc_value =
      minimax copy (depth+1) ai_id (((whose_turn) mod 2) + 1) min_lim !best_val
    in (if calc_value < !best_val then (best_val := calc_value)
        else ());  (*update min value found *)
    if  !best_val < min_lim
    then (count := (List.length moves + 10); (*quit if below the min limit *)
               (best_val := min_lim)) else ()
    done;
       !best_val

(* [smart_move] is the ai's smart move based on minimax *)
let smart_move st (player_id : int) =
    let moves = poss_moves st (AI (player_id, Smart)) in
    let count = ref (-1) in
    let best_val = ref (min_int) in
    let best_move = ref ((-1,-1)) in
    (*want the maximum result of the children*)
(while (!count + 1 < List.length moves) do ( count := !count+1;
  let copy = State.copy_state st in let move = (List.nth moves !count)
  in let _ = do' copy (move, AI (player_id, Smart)) in
  let calc_value
    = minimax copy 0 player_id (((player_id) mod 2) + 1) min_int max_int
  in if calc_value > !best_val
  then (best_val := calc_value; best_move := move)
  else ()) done);
(!best_move, AI (player_id, Smart))

let get_move st player strat =
  match strat, player  with
  |Random, _ ->  random_move st player
  |Greedy, _ -> greedy_move st player
  |Smart, (AI (i, _)) -> smart_move st i
  | _ -> failwith "Impossible"
