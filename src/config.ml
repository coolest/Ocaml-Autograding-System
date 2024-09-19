open Yojson.Basic
open Yojson.Basic.Util

let results_file = "/autograder/results/results.json"
let user_submission_count =
  let should_count_submission submission =
    match (member "score" submission) with
    | `Int i when i = 0 -> false
    | _ -> true
  in
  let metadata =
    try
      from_file "../submission_metadata.json"
    with
      exn -> `Assoc [("previous_submissions", `List [])] in
  let submissions = member "previous_submissions" metadata in
  match submissions with
  | `List prev_submissions ->
      List.filter should_count_submission prev_submissions |> List.length
  | _ -> 0
