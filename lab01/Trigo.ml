module Trigo =
  struct 
    (*a module that implement sin x n by using the Taylor's series 
    (where n is the level of approximation, i.e., 1 only one item, 2 two items, 3 three items and so on). 
    cosine, tangent, logarithm and so on*)

    let rec fact n = if (n = 0) then 1 else n * fact (n - 1) ;;
    
    (*x is the argument of sin, n is the approx level*)
  
    let rec taylor_sin y n = 
      let f x n = (x ** float_of_int(n)) /. (float_of_int(fact n)) in
      match n with
         0 -> 0.
        |1 -> y
        |_ -> (f y (n * 2 + 1)) +. taylor_sin  y (n - 1);;
    
    (*range r to -r, r is float, precision pr float*)
    let float_range r pr =
      let rec f r pr = 
        match Float.abs(r -. pr) with
       ende when (ende < pr) -> [0.]
      |e                     -> (Float.one *. e) :: e :: (f e pr) in  
      List.sort (Float.compare) (f r pr) |> List.rev;;
      
    float_range Float.one 0.0001;;
    

    (*max error from -r to r as range for sin, with n taylor terms*)
    let rec tsyn_max_error_range r n =
      match r with 
       []      -> 0.
      |x :: xs -> max (Float.abs(taylor_sin x n -. sin x)) (tsyn_max_error_range xs n);;
   
    tsyn_max_error_range (float_range Float.one 0.0001) 5;
    
  end;;