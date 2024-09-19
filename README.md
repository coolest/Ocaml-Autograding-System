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
TODO

