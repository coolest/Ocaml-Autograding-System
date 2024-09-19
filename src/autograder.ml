open Definitions
open Config

open Yojson.Basic
open Yojson.Basic.Util

type test_result = {
  name : string;
  score : int;
  maxscore : int;
  output : string;
}

type results = {
  tests : (string * test_result) list;
}

let grade_question question_num test_suite = 
  let tests_amt = List.length test_suite.suite in
  let correct_amt = List.fold_left (fun correct (Test test) -> if test.apply_hw_fn() = test.apply_sol_fn() then correct + 1 else correct) 0 test_suite.suite in
  let fraction_correct = float_of_int correct_amt /. float_of_int tests_amt in
  let question_points = int_of_float (float_of_int test_suite.max_points *. fraction_correct) in
  {
    name = test_suite.suite_name;
    score = question_points;
    maxscore = test_suite.max_points;
    output = Printf.sprintf "You got %d out of %d questions correct." correct_amt tests_amt;
  }

let perform_grade() = 
  let test_suites = Definitions.test_suites in
  let test_results = List.mapi grade_question test_suites  in
  let response_json = 
    let test_results_json = List.map (fun test_result -> 
      `Assoc [
        ("name", `String test_result.name);
        ("score", `Float (float_of_int test_result.score));
        ("max_score", `Float (float_of_int test_result.maxscore));
        ("output", `String test_result.output)
        ]) test_results 
    in `Assoc [
      ("tests", `List test_results_json); 
      ("output", `String (Printf.sprintf "You have %d submissions left!" (5-Config.user_submission_count)))
    ] 
  in to_file Config.results_file response_json

let () = 
  if Config.user_submission_count <= 5
    then perform_grade()
    else to_file Config.results_file (`Assoc [
        ("score", `Float 0.);
        ("output", `String "Too many submissions!")
      ])