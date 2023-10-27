module StringsPlay = 
  
  struct

    (*check id char c is any letter*)
    let is_lowercase_letter c = 
      let f c = List.exists (fun x -> x = (Char.code c)) [192; 193; 194; 195; 199; 201; 202; 205; 211; 212; 218; 213; 224; 225; 226; 227; 231; 233; 234; 237; 243; 245; 244; 250] in
      if (((Char.code c) >= 97) && (Char.code c) <= 122) || (f c) then true else false;;

    (*check if a string is palindrome, string can be read the same way 
       in either directions in spite of spaces, punctual and letter cases, e.g., detartrated *)
    let is_palindrome str = 
      let filtered = str |> String.lowercase_ascii |> String.fold_left (fun acc x -> if (is_lowercase_letter x) then ((String.make 1 x) ^ acc) else acc) "" in 
      let rec f n = if (filtered.[(String.length filtered) - n - 1 ] = filtered.[n]) && not(n < (String.length filtered) - n - 1) then f (n-1) else if (n < (String.length filtered) - n - 1) then true else false in 
      f (String.length filtered - 1);;

    is_palindrome "Do geese see God?";; (* true*)
    is_palindrome "Do    OD";; (* true*)
    is_palindrome "Do !geese see !God?";; (* true*)
    is_palindrome "Rise to vote, sir.";; (* true*)
    is_palindrome "Do    DO";; (* false*)
    is_palindrome "cassasa aagafa";; (* false*)

    
        
        
        

  end;;