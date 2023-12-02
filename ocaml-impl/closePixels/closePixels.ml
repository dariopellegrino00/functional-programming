(*first ocaml midterm *)
module Exam =
  struct
    let rec find_first_uccurences x lst = 
      match lst with
       x' :: xs when x = x' -> 1 + (find_first_uccurences x xs) 
      |_ -> 0
      
    let rec remove_n n lst = 
      match n with 
       0 -> lst
      |_ -> match lst with 
             x :: xs -> remove_n (n-1) xs 
            |_ -> []
    
    let rec forgot_func_name lst = 
      match lst with 
      |x :: xs -> let flt = find_first_uccurences x lst in 
                            (flt) :: (forgot_func_name (remove_n flt lst))
      |_ -> []

  end;;
 
  
Exam.forgot_func_name [1; 2; 2; 3; 3; 3;3; 3] ;;
Exam.forgot_func_name [1; 2; 3] ;;
Exam.forgot_func_name [4; 4; 4; 4; 2; 3] ;;
Exam.forgot_func_name [];