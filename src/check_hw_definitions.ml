open Hw2types
open Hw2

(*
  Since it is impossible to verify whether a file has expected signature/defintions during runtime,
  we will need to run this and check for any errors.
  
  If errors --> tell student to complete definitions
  otherwise --> run autograder

  Does rely on submission to not throw an error, but no error is expected from any of these inputs
*)

let () = 
  (* #1 *)
  let _ = only_lowercase ["hi"] in

  (* #2 *)
  let _ = longest_string1 ["hi"] in

  (* #3 *)
  let _ = longest_string2 ["hi"] in

  (* #4 *)
  let _ = longest_string_helper (fun x y -> true) ["hi"] in
  let _ = longest_string3 ["hi"] in
  let _ = longest_string4 ["hi"] in

  (* #5 *)
  let _ = longest_lowercase ["hi"] in
   
  (* #6 *)
  let _ = caps_no_X_string "hi" in

  (* #7 *)
  let _ = first_answer (fun x -> Some 42) ["hi"] in

  (* #8 *)
  let _ = all_answers (fun x -> None) ["hi"] in

  (* #9 *)
  let _ = count_wildcards WildcardP in
  let _ = count_wild_and_variable_lengths WildcardP in
  let _ = count_a_var "x" WildcardP in

  (* #10 *)
  let _ = check_pat WildcardP in

  (* #11 *)
  let _ = matches Unit WildcardP in

  (* #12 *)
  let _ = first_match Unit [WildcardP; WildcardP; WildcardP] in

  (* #13 *)
  let _ = typecheck_patterns [("var1", "var2", UnitT)] [WildcardP; WildcardP] in
  
  ()
