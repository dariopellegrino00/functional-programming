
open Set ;;
let main () =
  let set = IntSet.add (IntSet.add IntSet.create_empty 1) 2 in 
  print_string (IntSet.tostring set);;
let() = main() ;;