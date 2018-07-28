(* A type for the contents of a cell: either Some x where 1 <= x <= 4 representing
 * a piece placed by [Player] x or None (i.e. the cell is empty) *)
type piece = int option

(* A variant type for the strategies an AI player can employ *)
type strategy =
  | Random
  | Greedy
  | Smart

(* A 2-tuple representing the row/column of a cell on the board *)
type cell = int * int

(* [id] is an int identifying the player between 1 and 4 inclusive. *)
type id = int

(* [player] represents the types of players that
 * can play the game. It can be either a Human or an AI.
 * We associate an id with each player to identify them. *)
type player =
  | Human of id
  | AI of id * strategy

(* [command] represents a move by a player, and consists of a [cell] (on which
 * the move is made and the [player] who made it. *)
type command =
  cell * player
