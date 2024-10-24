open Goldbach

let print_couple c = match c with (a, b) -> Printf.printf "(%d, %d) " a b

let print_couple_ln c = match c with (a, b) -> Printf.printf "(%d, %d) \n" a b

let print_pair_string pair_list =
  print_string "[";
  List.iter (
    print_couple
  ) pair_list;
  print_string "]\n"

let () =
  print_string "goldbach of 8:\n";
  print_couple_ln (goldbach 8);

  print_string "First list:\n";
  print_pair_string (goldbach_list 2 23);

  print_string "Second list with also negatives:\n";
  print_pair_string (goldbach_list (-10) 5)