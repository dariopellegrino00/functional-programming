module type OpVarADT =
sig
  type a and b and c
  val op: a -> b -> c
  val init : c
end;;

module VarArgs (OP : OpVarADT) =
  struct
  let arg x = fun y rest -> rest (OP.op x y) ;;
  let stop x = x;;
  let f g = g OP.init;;
end;;

module Sum = struct
  type a=int and b=int and c=int
  let op = fun x y -> x+y ;;
  let init = 0 ;;
end;;

module StringConcat = struct
  type a=string and b=string list and c=string list
  let op = fun (x: string) y -> y @ [x] ;;
  let init = [] ;;
end;;

module M0 = VarArgs(Sum);;
module M1 = VarArgs(StringConcat);;