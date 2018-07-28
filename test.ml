open OUnit2
open State
open Types


let ini_2 = [|[|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; Some 1; Some 2; None; None; None|];
              [|None; None; None; Some 2; Some 1; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|]|]

let ini_3 = [|[|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; Some 1; Some 2; None; None; None|];
              [|None; None; None; Some 3; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|]|]


let ini_4 = [|[|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; Some 1; Some 4; None; None; None|];
              [|None; None; None; Some 3; Some 2; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|]|]


let random_board = [|[|None; None; None; None; None; None; None; None|];
                     [|None; None; None; None; None; Some 1; Some 2; None|];
                     [|None; Some 1; None; None; None; Some 2; None; None|];
                     [|None; None; None; Some 1; Some 2; Some 1; None; None|];
                     [|None; None; None; Some 2; Some 1; None; None; None|];
                     [|None; None; Some 2; Some 1; None; None; None; None|];
                     [|None; Some 1; None; None; None; None; None; None|];
                     [|None; None; None; None; None; None; None; None|]|]

let random_board_2 = [|[|Some 1; Some 3; None; None; None; None; None; Some 1|];
                       [|None; None; None; None; Some 4; Some 1; Some 2; Some 1|];
                       [|Some 3; Some 1; None; Some 4; None; Some 2; None; Some 3|];
                       [|None; None; Some 4; Some 1; Some 2; Some 1; None; None|];
                       [|None; None; None; Some 2; Some 1; None; None; None|];
                       [|Some 3; None; Some 2; Some 1; None; None; Some 3; None|];
                       [|None; Some 1; None; Some 3; Some 3; None; None; None|];
                       [|Some 1; None; None; Some 3; None; None; None; Some 3|]|]

let full_board = [|[|Some 1; Some 3; Some 2; Some 2; Some 2; Some 2; Some 4; Some 1|];
                   [|Some 4; Some 3; Some 4; Some 1; Some 4; Some 1; Some 2; Some 1|];
                   [|Some 1; Some 3; Some 2; Some 2; Some 2; Some 2; Some 4; Some 1|];
                   [|Some 4; Some 3; Some 4; Some 1; Some 4; Some 1; Some 2; Some 1|];
                   [|Some 1; Some 3; Some 2; Some 2; Some 2; Some 2; Some 4; Some 1|];
                   [|Some 4; Some 3; Some 4; Some 1; Some 4; Some 1; Some 2; Some 1|];
                   [|Some 1; Some 3; Some 2; Some 2; Some 2; Some 2; Some 4; Some 1|];
                   [|Some 4; Some 3; Some 4; Some 1; Some 4; Some 1; Some 2; Some 1|]|]

let l1 = [|[|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; Some 1; Some 2; None; None; None|];
           [|None; None; None; Some 2; Some 1; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|]|]

let l2 = [|[|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; Some 1; Some 2; None; None; None|];
           [|None; None; None; Some 1; Some 1; None; None; None|];
           [|None; None; None; Some 1; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|]|]

let l3 = [|[|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; Some 1; Some 2; None; None; None|];
           [|None; None; None; Some 2; Some 1; None; None; None|];
           [|None; None; Some 2; Some 1; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|]|]


let l4 = [|[|None; None; None; None; None; None; None; None|];
           [|None; None; Some 4; Some 1; None; None; None; None|];
           [|None; None; None; Some 3; Some 2; None; None; None|];
           [|None; None; None; Some 1; Some 2; None; None; None|];
           [|None; None; None; Some 2; Some 1; None; None; None|];
           [|None; None; Some 2; Some 1; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|]|]

let l5 = [|[|None; Some 2; None; None; None; None; None; None|];
           [|None; None; Some 2; Some 1; None; None; None; None|];
           [|None; None; None; Some 2; Some 2; None; None; None|];
           [|None; None; None; Some 1; Some 2; None; None; None|];
           [|None; None; None; Some 2; Some 1; None; None; None|];
           [|None; None; Some 2; Some 1; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|];
           [|None; None; None; None; None; None; None; None|]|]

let empty = [|[|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|];
              [|None; None; None; None; None; None; None; None|]|]

let sparse = [|[|None; None; None; None; None; None; None; None|];
               [|None; None; Some 4; Some 1; None; None; None; None|];
               [|None; None; None; Some 3; Some 2; None; None; None|];
               [|None; None; None; Some 1; Some 2; None; None; None|];
               [|None; None; None; Some 2; Some 1; None; None; None|];
               [|None; None; Some 2; Some 1; None; None; None; None|];
               [|None; None; None; None; None; None; None; None|];
               [|None; None; None; None; None; None; None; None|]|]

let greedy_1 = [|[|None; None; None; None; None; None; None; None|];
               [|None; None; None; None; None; None; None; None|];
               [|None; None; None; None; None; None; None; None|];
               [|None; None; Some 2; None; None; None; None; None|];
               [|None; Some 2; Some 1; Some 1; Some 1; Some 1; None; None|];
               [|None; None; None; None; None; None; None; None|];
               [|None; None; None; None; None; None; None; None|];
               [|None; None; None; None; None; None; None; None|]|]


let greedy_2 = [|[|None; None; None; None; None; None; None; None|];
                 [|None; Some 3; None; None; None; None; None; None|];
                 [|Some 3; Some 2; None; None; None; None; None; None|];
                 [|None; Some 1; Some 1; Some 2; Some 3; None; None; None|];
                 [|None; Some 1; None; None; None; None; None; None|];
                 [|None; Some 2; None; None; None; None; None; None|];
                 [|None; None; None; None; None; None; None; None|];
                 [|None; None; None; None; None; None; None; None|]|]

let greedy_3 = [|[|None; None; None; None; None; None; None; None|];
                 [|None; None; None; None; None; None; None; None|];
                 [|None; None; None; None; None; None; None; None|];
                 [|None; None; Some 3; None; None; None; None; None|];
                 [|None; None; Some 1; Some 2; None; None; None; None|];
                 [|None; None; Some 1; Some 2; None; None; None; None|];
                 [|None; Some 3; Some 1; None; Some 2; None; None; None|];
                 [|Some 3; None; Some 1; None; None; Some 3; None; None|]|]

let greedy_4 = [|[|None; None; None; None; None; None; None; None|];
                 [|None; None; None; None; None; None; None; None|];
                 [|Some 2; Some 1; Some 1; Some 2; Some 1; Some 1; Some 1; None|];
                 [|None; Some 1; Some 1; Some 1; Some 1; None; None; None|];
                 [|None; None; Some 1; Some 1; None; Some 1; None; None|];
                 [|None; None; None; None; None; None; None; Some 1|];
                 [|None; None; None; None; None; None; None; None|];
                 [|None; None; None; None; None; None; None; None|]|]





let basic_test = [
  (* Testing state initialization *)
  "initial_state_2" >:: (fun _ -> assert_equal ini_2  (init_state 2));
  "initial_state_3" >:: (fun _ -> assert_equal ini_3  (init_state 3));
  "initial_state_4" >:: (fun _ -> assert_equal ini_4  (init_state 4));

  (* Testing do' for valid moves*)
  "do1" >:: (fun _ -> assert_equal true (do' ini_2 ((3,5),(Human 1))));
  "do2" >:: (fun _ -> assert_equal true (do' ini_2 ((2,5),(Human 2))));
  "do3" >:: (fun _ -> assert_equal true (do' ini_2 ((1,5),(Human 1))));
  "do4" >:: (fun _ -> assert_equal true (do' ini_2 ((1,6),(Human 2))));

  (* Testing do' for invalid moves (within bounds) *)
  "illegal_move1" >:: (fun _ -> assert_equal false (do' ini_2 ((7,5), (Human 1))));
  "illegal_move2" >:: (fun _ -> assert_equal false (do' ini_2 ((7,7), (Human 2))));
  "illegal_move3" >:: (fun _ -> assert_equal false (do' ini_2 ((0,0), (Human 1))));
  "illegal_move4" >:: (fun _ -> assert_equal false (do' ini_2 ((7,0), (Human 1))));

  (* Testing do' for out-of-bounds moves *)
  "bounds1" >:: (fun _ -> assert_equal false (do' ini_2 ((-1,-1), (Human 1))));
  "bounds2" >:: (fun _ -> assert_equal false (do' ini_2 ((99,99), (Human 1))));
  "bounds3" >:: (fun _ -> assert_equal false (do' ini_2 ((0,8), (Human 1))));
  "bounds4" >:: (fun _ -> assert_equal false (do' ini_2 ((8,8), (Human 1))));
  "bounds5" >:: (fun _ -> assert_equal false (do' ini_2 ((-1,5), (Human 1))));

  (* Testing do' for adding pieces to already filled spot*)
  "filled1" >:: (fun _ -> assert_equal false (do' ini_2 ((1,6), (Human 1))));
  "filled2" >:: (fun _ -> assert_equal false (do' ini_2 ((1,6), (Human 2))));
  "filled3" >:: (fun _ -> assert_equal false (do' ini_2 ((3,3), (Human 1))));
  "filled4" >:: (fun _ -> assert_equal false (do' ini_2 ((3,3), (Human 2))));

]

let score_test = [
  (* Empty board *)
  "empty1" >:: (fun _ -> assert_equal 0 (player_score empty (Human 1)));
  "empty2" >:: (fun _ -> assert_equal 0 (player_score empty (Human 4)));

  (* Random board *)
  "random1" >:: (fun _ -> assert_equal 7 (player_score random_board (Human 1)));
  "random2" >:: (fun _ -> assert_equal 5 (player_score random_board (Human 2)));

  "random3" >:: (fun _ -> assert_equal 11 (player_score random_board_2 (Human 1)));
  "random4" >:: (fun _ -> assert_equal 5 (player_score random_board_2 (Human 2)));
  "random5" >:: (fun _ -> assert_equal 9 (player_score random_board_2 (Human 3)));
  "random6" >:: (fun _ -> assert_equal 3 (player_score random_board_2 (Human 4)));

  (* Full board *)
  "full1" >:: (fun _ -> assert_equal 20 (player_score full_board (Human 1)));
  "full2" >:: (fun _ -> assert_equal 20 (player_score full_board (Human 2)));
  "full3" >:: (fun _ -> assert_equal 8 (player_score full_board (Human 3)));
  "full4" >:: (fun _ -> assert_equal 16 (player_score full_board (Human 4)));
]



let func_test = [

  (* Comparing boards after legal moves are done to ensure tiles were flipped *)
  "compare_board1" >:: (fun _ -> assert_equal l2 (ignore(do' l1 ((5,3), (Human 1))); l1) );
  "compare_board2" >:: (fun _ -> assert_equal l3 (ignore(do' l1 ((5,2), (Human 2))); l1) );
  "compare_board3" >:: (fun _ -> assert_equal l5 (ignore(do' l4 ((0,1), (Human 2))); l4) );

  (* Testing is_full () function *)
  "is_full_empty" >:: (fun _ -> assert_equal false (is_full empty));
  "is_full_spare" >:: (fun _ -> assert_equal false (is_full l5));
  "is_full_full" >:: (fun _ -> assert_equal true (is_full full_board));

  (* Possible moves + possible moves with scores functions *)
  "poss_moves1" >:: (fun _ -> assert_equal [(5,1); (4,2); (3,5); (2,4)] (poss_moves l3 (Human 1)));
  "poss_moves_scores_1" >:: (fun _ -> assert_equal
                                [(5,1,1); (4,2,1); (3,5,1); (2,4,1)]
                                (poss_moves_with_scores l3 (Human 1)));
  "poss_moves2" >:: (fun _ -> assert_equal
                        [(6,3);(5,4); (4,5); (2,5); (2,3)]
                        (poss_moves (ignore(do' l3 ((2,4), (Human 1))); l3) (Human 2)));
  "poss_moves_scores_2" >:: (fun _ -> assert_equal
                                [(6,3,1);(5,4,1); (4,5,1); (2,5,1); (2,3,1)]
                                (poss_moves_with_scores l3 (Human 2)));
]


let greedy_test = [
  "greedy_1" >:: (fun _ -> assert_equal ((4,6),AI(2,Greedy)) (Ai.get_move greedy_1 (AI(2,Greedy)) Greedy));
  "greedy_2" >:: (fun _ -> assert_equal ((6,1),AI(3,Greedy)) (Ai.get_move greedy_2 (AI(3,Greedy)) Greedy));
  "greedy_3" >:: (fun _ -> assert_equal ((3,1),AI(3,Greedy)) (Ai.get_move greedy_3 (AI(3,Greedy)) Greedy));
  "greedy_4" >:: (fun _ -> assert_equal ((5,3),AI(2,Greedy)) (Ai.get_move greedy_4 (AI(2,Greedy)) Greedy));
]

let tests =
  "test suite for Final Project"  >::: List.flatten [
    basic_test; score_test; func_test;greedy_test
  ]

let _ = run_test_tt_main tests
