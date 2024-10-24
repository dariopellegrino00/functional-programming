module ArithExpr = 
  struct
    exception InvalidToken

    type expr = 
        Sum of expr * expr 
      | Minus of expr * expr 
      | Mul of expr * expr 
      | Div of expr *expr 
      | Number of (float) ;;
    
    let parse_expr str =  
      let rec parse_expr i str = 
        match str.[i] with
        | '0' .. '9' as n -> (i, Number (float_of_string (String.make 1 n)))
        | c ->  let (newi, parsed1) = parse_expr (i+1) str in 
                let (newi, parsed2) = parse_expr (newi+1) str in 
                match c with 
                | '+' -> (newi , Sum (parsed1, parsed2))
                | '-' -> (newi , Minus (parsed1, parsed2))
                | '*' -> (newi , Mul (parsed1, parsed2))
                | '/' -> (newi , Div (parsed1, parsed2))
                | _   -> raise InvalidToken
      in let (_, parsed) = parse_expr 0 str in parsed

    let rec step_eval = function 
        Number n -> Number n    
      | Sum (Number n1, Number n2) -> Number (n1 +. n2)
      | Sum (expr1 , expr2) -> Sum (step_eval expr1, step_eval expr2)
      | Mul (Number n1, Number n2) -> Number (n1 *. n2)
      | Mul (expr1 , expr2) -> Mul (step_eval expr1, step_eval expr2)
      | Minus (Number n1, Number n2) -> Number (n1 -. n2)
      | Minus (expr1 , expr2) -> Minus (step_eval expr1, step_eval expr2)
      | Div (Number n1, Number n2) -> Number (n1 /. n2)
      | Div (expr1 , expr2) -> Div (step_eval expr1, step_eval expr2)

    let print_expr e =
      let rec print_expr = function 
        Number n -> string_of_float n
      | Sum (a, b) -> Printf.sprintf "(%s + %s)" (print_expr a) (print_expr b)
      | Mul (a, b) -> Printf.sprintf "(%s * %s)" (print_expr a) (print_expr b)
      | Minus (a, b) -> Printf.sprintf "(%s - %s)" (print_expr a) (print_expr b)
      | Div (a, b) -> Printf.sprintf "(%s / %s)" (print_expr a) (print_expr b)
      in print_string (print_expr e)

    let print_evaluation str = 
      let parsed = parse_expr str in 
      let rec eval = function 
          Number n -> print_float n; print_endline "";
        | _ as ex  -> (print_expr ex; print_endline ""; eval (step_eval ex))
      in eval parsed 
    
  end
;;

