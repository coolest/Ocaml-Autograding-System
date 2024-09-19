open Random
open Hw2types

let () = Random.self_init()

let generate_random_char() =
  if Random.bool()
    then Char.chr (65 + Random.int 25)
    else Char.chr (97 + (Random.int 26))

let generate_random_string_of_size size = 
  String.make (Random.int size) 'x' |> 
  String.map (fun _ -> generate_random_char())

let generate_random_string() = generate_random_string_of_size 25

let string_generator () = 
  List.init 50 (fun _ -> generate_random_string())

let string_list_generator() = 
  List.init 50 (fun _ -> string_generator())

let boolean_generator() =
  List.init 25 (fun _ -> Random.int 10 != 9)

let boolean_list_generator() = 
  List.init 50 (fun _ -> boolean_generator())

let rec generate_pattern() =
  match (Random.int 6) with
  | 0 -> WildcardP
  | 1 -> VariableP (generate_random_string_of_size 1)
  | 2 -> UnitP
  | 3 -> ConstantP (Random.int 10)
  | 4 -> ConstructorP ((generate_random_string_of_size 1), generate_pattern())
  | 5 -> TupleP (List.init (Random.int 5) (fun _ -> generate_pattern()))
  | _ -> failwith "Impossible number generated"

let pattern_generator() =
  List.init 100 (fun _ -> generate_pattern())

let count_a_var_input_generator() =
  List.init 100 (fun _ -> (generate_random_string_of_size 1, generate_pattern()))

let rec generate_valu() =
  match (Random.int 3) with
  | 0 -> Constant (Random.int 10)
  | 1 -> Unit
  | 2 -> Constructor ((generate_random_string_of_size 1), generate_valu())
  | 3 -> Tuple (List.init (Random.int 3) (fun _ -> generate_valu()))
  | _ -> failwith "Impossible number generated"

let matches_input_generator() =
  List.init 250 (fun _ -> (generate_valu(), generate_pattern()))

let first_match_input_generator() =
  List.init 100 (fun _ -> (generate_valu(), pattern_generator()))

let rec generate_typ() = 
  match (Random.int 5) with
  | 0 -> AnythingT
  | 1 -> IntT
  | 2 -> UnitT
  | 3 -> VariantT (generate_random_string_of_size 1)
  | 4 -> TupleT (List.init (Random.int 5) (fun _ -> generate_typ()))
  | _ -> failwith "Impossible number generated"

let typecheck_patterns_input_generator() =
  List.init 50 (fun _ -> (List.init 100 (fun _ -> (generate_random_string_of_size 1, generate_random_string_of_size 1, generate_typ())), pattern_generator()))