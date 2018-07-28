open State
open Types

(* Initializes the GUI window *)
val init : unit -> unit

(* Draws the introduction / start screen *)
val draw_start : unit -> unit

(* Draws the instructions screen *)
val draw_instructions : unit -> unit

(* Draws the screen for selecting the number of players
 * and returns the number chosen *)
val draw_num_players : unit -> int

(* [draw_player_selection i n] draws the player type selection screen for
 * Player i for a game with [n] players and returns the string of the type
 * selected. Only games with n = 2 will allow for the Smart AI type to be
 * selected. *)
val draw_player_selection : int -> int -> string

(* [draw_game st] draws the current board state [st] *)
val draw_game : state -> unit

(* Returns the game cell clicked on *)
val get_cell_from_click : unit -> int * int

(*[draw_turn i] draws the turn for player with id [i].*)
val draw_turn : int -> unit

(*[draw_score_game_screen st player_ar i] draws the score for
  all the [i] players in [player_ar] according to the current
  state [st].*)
val draw_score_game_screen : state -> player array -> int -> unit

(* Draws the error message for invalid moves *)
val displ_error_msg : unit -> unit

(* Draws the message indicating the AI is thinking *)
val displ_ai : unit -> unit

(*[draw_possible_moves st pid] draws the possible moves for the player
  with id [pid] for the current state [st].*)
val draw_possible_moves : state -> player -> unit

(* [draw_end st player_array n] draws the end of game screen
   and returns [1] if player chooses the option "Play Again"
   or [-1] if player chooses "Quit".*)
val draw_end : state -> player array -> int -> int
