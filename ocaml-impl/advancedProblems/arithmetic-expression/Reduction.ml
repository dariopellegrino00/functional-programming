module ArithExpr = 
  struct 
    type expr = Number of (float) | SUM of expr * expr | SUB of expr * expr | MUL of expr * expr | DIV of expr * expr

    exception NotAnExpressionException

    let rec reduce expr = 
      match expr with 
        SUM(Number(a), Number(b)) -> Number(a +. b)
      | SUM(a, b)                 -> SUM(reduce a, reduce b)
      | SUB(Number(a), Number(b)) -> Number(a -. b)
      | SUB(a, b)                 -> SUB(reduce a, reduce b)
      | MUL(Number(a), Number(b)) -> Number(a *. b)
      | MUL(a, b)                 -> MUL(reduce a, reduce b)
      | DIV(Number(a), Number(b)) -> Number(a /. b)
      | DIV(a, b)                 -> DIV(reduce a, reduce b)
      | Number(a)                  -> Number(a)

    let rec print_expr expr = 
      match expr with 
        SUM(a, b) -> "(" ^ print_expr a ^ " + " ^ print_expr b ^ ")"
      | SUB(a, b) -> "(" ^ print_expr a ^ " - " ^ print_expr b ^ ")"
      | MUL(a, b) -> "(" ^ print_expr a ^ " * " ^ print_expr b ^ ")"
      | DIV(a, b) -> "(" ^ print_expr a ^ " / " ^ print_expr b ^ ")"
      | Number(a) -> string_of_float a

    let parse_expr str = 
      let rec parse_expr str n =  
        match str.[n] with 
          '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' ->
          Number(float_of_string ((String.make 1 str.[n]) ^".")), n
        | '+'     -> let op1, n1 = parse_expr str (n + 1) in let op2, n2 = parse_expr str (n1 + 1) in SUM(op1, op2), n2
        | '-'     -> let op1, n1 = parse_expr str (n + 1) in let op2, n2 = parse_expr str (n1 + 1) in SUB(op1, op2), n2
        | '*'     -> let op1, n1 = parse_expr str (n + 1) in let op2, n2 = parse_expr str (n1 + 1) in MUL(op1, op2), n2
        | '/'     -> let op1, n1 = parse_expr str (n + 1) in let op2, n2 = parse_expr str (n1 + 1) in DIV(op1, op2), n2
        |  _      -> raise NotAnExpressionException
        in fst (parse_expr str 0)


    let print_evaluation expr = 
      let rec print_evaluation expr = 
        match expr with 
         Number _ -> print_string (print_expr expr ^ "\n")
        | _       -> 
          print_string (print_expr expr ^ "\n");
          let e = reduce expr in 
          print_evaluation e 
      in print_evaluation (parse_expr expr)
  end;;