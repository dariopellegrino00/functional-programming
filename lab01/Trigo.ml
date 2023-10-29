module Trigo =
  struct 
    (*This module implement math functions in f x n using the Taylor's series 
    (where n is the level of approximation, i.e., 1 only one item, 2 two items, 3 three items and so on). 
    cosine, tangent, logarithm and so on*)

    let rec fact n = if (n = 0) then 1 else n * fact (n - 1) ;;

    (* power operator for int*)
    let (+**) x n = 
      let rec f a = 
        match a with
        0 -> 1
        |_ -> x * (f (a-1)) in  
      f n;;  
    
    (*sin x using the taylor formula, approximated to the n = pr term of the series pr = [0, max integer] *)
    let rec taylor_sin y pr = 
      let f x n = (x ** float_of_int(n)) /. (float_of_int(fact n)) in
      match pr with
         0 -> y
        |_ -> (float_of_int(-1 +** pr) *. ((f y (pr * 2 + 1))) +. (taylor_sin  y (pr - 1)));;
        
    taylor_sin Float.pi 3 -. (Float.sin Float.pi);; (*error: 0.08 *) 
    taylor_sin Float.pi 10 -. (Float.sin Float.pi);; (*error: -7 * 10^(-9) *) 
    taylor_sin 1. 3 -. (Float.sin 1.);;  (*error: 0.0000027 *) 
    taylor_sin 1. 10 -. (Float.sin 1.);;  (*error: 0 *) 

     (*cos x using the taylor formula, approximated to the n = pr term of the series pr = [0, max integer] *)
    let rec taylor_cos y pr = 
      let f x n = (x ** float_of_int(n)) /. (float_of_int(fact n)) in
      match pr with
         0 -> 1.
        |_ -> (float_of_int(-1 +** pr) *. ((f y (pr * 2))) +. (taylor_cos  y (pr - 1)));;

    taylor_cos Float.pi 3 -. (Float.cos Float.pi);; (*error: 0.21 *) 
    taylor_cos Float.pi 10 -. (Float.cos Float.pi);; (*error: -7 * 10^(-9) *) 
    taylor_cos 1. 3 -. (Float.cos 1.);;  (*error: 0.000024 *) 
    taylor_cos 1. 10 -. (Float.cos 1.);;  (*error: -1.11 * 10^(-16) *) 

    (*e^x using the taylor formula with pr precision, pr = [0, max integer]*)
    let rec taylor_exp x pr =
      let term t n = float_of_int(t +** n) /. float_of_int(fact n) in 
      match pr with
       0 -> 1.
      |_ -> term x pr +. (taylor_exp x (pr-1));;


    (taylor_exp 2 6) -. (2.71 ** 2.);;  (*error: 0.12 *)
    (taylor_exp 2 20) -. (2.71 ** 2.);; (*error: 0.04 *)
    (taylor_exp 2 50) -. (2.71 ** 2.);; (*error: 0.04 *) 
    (*the max error is : 0.04 *) 

    (*tan of x using the taylor formula with pr precision, pr [0, max integer]*)
    let rec taylor_tan x pr = 0;;
      

        

  end;;