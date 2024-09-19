# Ocaml-Autograding-System
 Autograding assignments in Ocaml for gradescope submissions.

# Low-level prerequisites
A setup.sh file will be called automatically and this script will set up things needed to perform the autograde. This includes OPAM, Dune, Yojson, as well as other quality of life commands such as jq. Once these tools are installed, we initialize OPAM and create the dune project in this script. After that is done, we have everything setup for the autograde.

The run_autograder script is then called, and we on a high level:
+ Verify the student's submission has the correct signature. The homework submission itself is an Ocaml Module, and we need to verify that this module has the *bare minimum* function definitions, so our autograder does not error on us.
+ Run the autograding ocaml project

There are more caveats but this is essentially the purpose of the run_autograder script.

Finally the autograder will grade the student's submission.

# Autograder prerequisite(s) & adding a test suite!
+ A solution.ml file
+ The homework.ml file (a given)

The autograder "grades" the homework on a Monte Carlo based algorithm. It will generate random inputs for the current function it is grading, and iterate on that. An example of this is lets say we have an add function
```ocaml
let add x y = x + y
```
Within definitions.ml we would add to the test-suite something like this:
```ocaml
let test_suites = [
 ...tests;

 {
   suite_name = "add";
   max_points = 100;
   suite = int_pair_generator()
           |> List.map (fun input -> create_test_fn_arity2 Hw.add Sol.add input);
 };
]
```
Then in our generator.ml we would add this:
```ocaml
let int_pair_generator() =
 List.init 100 (fun _ -> (Random.int 100, Random.int 100))
```

That is all we would need to do to grade the homework.add function:
* Have a solution.add function
* Add the suite in definitions.test_suites
* [maybe] add the input generator in generators.ml

# How it works:

There are a couple layers of abstraction for the main grading logic:

```ocaml
type test = Test : {
  apply_hw_fn: unit -> 'output;
  apply_sol_fn: unit -> 'output;
} -> test
```
This GADT is the first layer of abstraction, it represents a singular test case for a problem. These thunks, are wrapper functions for the homework & solution function and when the thunk is invoked it will invoke the functions with pre-given input.

The main way to create the test case is with these helper functions:
*abstract: We supply the hw & sol function, and input for these functions when the test suite is called upon*
```ocaml
let create_test_fn_arity1 hw_fn sol_fn (arg1) = Test {
  apply_hw_fn = safe_call (fun () -> hw_fn arg1);
  apply_sol_fn = safe_call (fun () -> sol_fn arg1);
}

let create_test_fn_arity2 hw_fn sol_fn (arg1, arg2) = Test {
  apply_hw_fn = safe_call (fun () -> hw_fn arg1 arg2);
  apply_sol_fn = safe_call (fun () -> sol_fn arg1 arg2);
}
```

Using the test GADT we can now create a test-suite for a given problem we want to create:
*abstract: For a given function/problem we now have a list of tests for that particular function/problem*
```ocaml
type test_suite = {
  suite_name: string;
  max_points: int;
  suite: test list;
}
```

Now we can use these abstractions to easily perform the grading with this short function:
```ocaml
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
```

Basically we fold over the test cases, see if the homework function's output is equal to the solution function's ouput, and handle accordingly. After this folding we return the results of the suite (how many homework function output's are equal to the solution).
