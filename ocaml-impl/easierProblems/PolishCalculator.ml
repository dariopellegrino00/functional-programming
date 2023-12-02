module type SStack =
sig
  type 'a stack 
  exception EmptyStackException
  val empty : 'a stack 
  val push : 'a stack -> 'a -> unit 
  val pop : 'a stack -> unit
  val top : 'a stack -> 'a
  val is_empty : 'a stack -> bool
end;;

  
module SStack =
struct
  type 'a stack = {mutable c : 'a list}

  exception EmptyStackException

  let empty () = {c = []}

  let push s e = s.c <- e :: s.c; s

  let pop s = 
    match s.c with
      x :: xs -> s.c <- xs ; x
    | []      -> raise EmptyStackException

  let top s = 
    match s.c with 
      x :: _ -> x
    | []     -> raise EmptyStackException    

  let is_empty s = (s.c = [])
end;;

module PolishCalculator =
  struct

    type op = Plus | Minus | Times | Divide | Power 
    type expr =
    | Value of int 
    | Operator of op * expr * expr 

    let is_operator = function 
      | "+" | "-" | "*" | "/" | "**" -> true 
      | _ -> false

    let to_operator = function 
      | "+" -> Plus
      | "-" -> Minus
      | "*" -> Times
      | "/" -> Divide
      | "**" -> Power
      | _ -> failwith "Invalid operator" 

    let rec expr_to_stack tokens stack = 
          match tokens with
          | [] -> stack
          | t :: ts -> if (is_operator t) 
                        then expr_to_stack ts (SStack.push stack (Operator (to_operator t, SStack.pop stack, SStack.pop stack)))  
                        else expr_to_stack ts (SStack.push stack (Value (int_of_string t)))
    
    let expr_of_string str = expr_to_stack (String.split_on_char ' ' str) (SStack.empty())  |> SStack.pop                                    
  
    let rec eval exp =    
      match exp with
      | Value v               -> v 
      | Operator(o, op1, op2) -> let e1 = eval op1 and e2 = eval op2 in 
                                 match o with 
                                 | Plus   -> e1 + e2 
                                 | Minus  -> e1 - e2 
                                 | Times  -> e1 * e2 
                                 | Divide -> e1 / e2 
                                 | Power  -> int_of_float(float_of_int(e1) ** float_of_int(e2))
    
    let e1 = eval (expr_of_string "1 2 - 5 *")    
    let e2 = eval (expr_of_string "3 4 + 5 *")
        
  end;;