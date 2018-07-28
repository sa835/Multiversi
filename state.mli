open Types

(*[state] represents the current state of the game board.*)
type state =  piece array array

(* [init_state num_player] initializes the game state for a specific number
 * of players
 * requires: [num_player] is 2, 3, or 4. *)
val init_state : int -> state

(* [is_full st] returns true if all the cells in the game state [st] contain
 * a piece *)
val is_full : state -> bool

(*[piece_at c] returns the peice stored at cell [c].*)
val piece_at : state -> cell -> piece

(*[player_score s p] returns the score of the player [p] with the current
  state of the board [s]*)
val player_score : state -> player -> int

(* [poss_moves s p] returns the list of possible cell moves for
   player [p] for the current state of the board [s]*)
val poss_moves : state -> player -> (int * int) list

(* [poss_moves s p] returns the list of possible cell moves for
   player [p] along with their scores for the current state
   of the board [s].*)
val poss_moves_with_scores : state -> player -> (int*int*int) list

(*[do' c s] updates the mutable state [s] with command [c].
  requires: [s] is a state and [c] is a command.
  effects: upadates [s] depending on [c].
*)
val do' : state -> command -> bool

(*[copy_state st] returns another copy of the
  state [st].*)
val copy_state : state -> state
