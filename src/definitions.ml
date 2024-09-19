open Generator
open Solution
open Hw2types
open Hw2

module Hw = Hw2
module Sol = Solution

type test = Test : {
  apply_hw_fn: unit -> 'output;
  apply_sol_fn: unit -> 'output;
} -> test

type test_suite = {
  suite_name: string;
  max_points: int;
  suite: test list;
}

let safe_call thunk = 
  fun () -> 
    try 
      Some ( thunk() )
    with 
      exn -> None

let create_test_fn_arity1 hw_fn sol_fn (arg1) = Test {
  apply_hw_fn = safe_call (fun () -> hw_fn arg1);
  apply_sol_fn = safe_call (fun () -> sol_fn arg1);
}

let create_test_fn_arity2 hw_fn sol_fn (arg1, arg2) = Test {
  apply_hw_fn = safe_call (fun () -> hw_fn arg1 arg2);
  apply_sol_fn = safe_call (fun () -> sol_fn arg1 arg2);
}

let test_suites = 
  [
    {
      suite_name = "only_lowercase";
      max_points = 5;
      suite = string_list_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.only_lowercase Sol.only_lowercase input);
    };
    {
      suite_name = "longest_string1";
      max_points = 5;
      suite = string_list_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.longest_string1 Sol.longest_string1 input);
    };
    {
      suite_name = "longest_string2";
      max_points = 5;
      suite = string_list_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.longest_string2 Sol.longest_string2 input);
    };
    {
      suite_name = "longest_string_helper";
      max_points = 3;
      suite = string_list_generator()
              |> List.map (fun input -> create_test_fn_arity2 Hw.longest_string_helper Sol.longest_string_helper ((fun x y -> x > y), input));
    };
    {
      suite_name = "longest_string3";
      max_points = 1;
      suite = string_list_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.longest_string3 Sol.longest_string3 input);
    };
    {
      suite_name = "longest_string4";
      max_points = 1;
      suite = string_list_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.longest_string4 Sol.longest_string4 input);
    };
    {
      suite_name = "longest_lowercase";
      max_points = 5;
      suite = string_list_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.longest_lowercase Sol.longest_lowercase input);
    };
    {
      suite_name = "caps_no_X_string";
      max_points = 5;
      suite = string_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.caps_no_X_string Sol.caps_no_X_string input);
    };
    {
      suite_name = "first_answer [EXPECT EXCEPTION]";
      max_points = 3;
      suite = string_list_generator()
              |> List.map (fun input -> create_test_fn_arity2 Hw.first_answer Sol.first_answer ((fun _ -> None), input));
    };
    {
      suite_name = "first_answer [NO EXCEPTION]";
      max_points = 4;
      suite = string_list_generator()
              |> List.map (fun input -> create_test_fn_arity2 Hw.first_answer Sol.first_answer ((fun _ -> Some 42), input));
    };
    {
      suite_name = "all_answers";
      max_points = 7;
      suite = boolean_list_generator()
              |> List.map (fun input -> create_test_fn_arity2 Hw.all_answers Sol.all_answers ((fun b -> if b then Some [b] else None), input));
    };
    {
      suite_name = "count_wildcards";
      max_points = 3;
      suite = pattern_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.count_wildcards Sol.count_wildcards input);
    };
    {
      suite_name = "count_wild_and_variable_lengths";
      max_points = 2;
      suite = pattern_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.count_wild_and_variable_lengths Sol.count_wild_and_variable_lengths input);
    };
    {
      suite_name = "count_a_var";
      max_points = 2;
      suite = count_a_var_input_generator()
              |> List.map (fun input -> create_test_fn_arity2 Hw.count_a_var Sol.count_a_var input);
    };
    {
      suite_name = "check_pat";
      max_points = 8;
      suite = pattern_generator()
              |> List.map (fun input -> create_test_fn_arity1 Hw.check_pat Sol.check_pat input);
    };
    {
      suite_name = "matches";
      max_points = 8;
      suite = matches_input_generator()
              |> List.map (fun input -> create_test_fn_arity2 Hw.matches Sol.matches input);
    };
    {
      suite_name = "first_match";
      max_points = 8;
      suite = first_match_input_generator()
              |> List.map (fun input -> create_test_fn_arity2 Hw.first_match Sol.first_match input);
    };
    {
      suite_name = "typecheck_patterns";
      max_points = 5;
      suite = typecheck_patterns_input_generator()
              |> List.map (fun input -> create_test_fn_arity2 Hw.typecheck_patterns Sol.typecheck_patterns input);
    }
  ]
