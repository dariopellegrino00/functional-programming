module StringsPlay = 
  
  struct

    (*check id char c is any letter*)
    let is_lowercase_letter c = 
      let f c = List.exists (fun x -> x = (Char.code c)) [192; 193; 194; 195; 199; 201; 202; 205; 211; 212; 218; 213; 224; 225; 226; 227; 231; 233; 234; 237; 243; 245; 244; 250] in
      if (((Char.code c) >= 97) && (Char.code c) <= 122) || (f c) then true else false;;

    (*check if a string is palindrome, string can be read the same way 
       in either directions in spite of spaces, punctual and letter cases, e.g., detartrated *)
    let is_palindrome str = 
      let filtered = str |> String.lowercase_ascii |> String.fold_left (fun acc x -> if (is_lowercase_letter x) 
        then ((String.make 1 x) ^ acc) else acc) "" in 
      let rec f n = if (filtered.[(String.length filtered) - n - 1 ] = filtered.[n]) && not(n < (String.length filtered) - n - 1) 
        then f (n-1) else if (n < (String.length filtered) - n - 1) then true else false in 
      f (String.length filtered - 1);;

    is_palindrome "Do geese see God?";; (* true*)
    is_palindrome "Do    OD";; (* true*)
    is_palindrome "Do !geese see !God?";; (* true*)
    is_palindrome "Rise to vote, sir.";; (* true*)
    is_palindrome "Do    DO";; (* false*)
    is_palindrome "cassasa aagafa";; (* false*)

    (* operator less for strings it remove all the character in the first String str1 
       that matches any of the characters in the second string, the operator is case sensitive*)
    let (-^) str1 str2 =    
      let filter c str = String.fold_right (fun i acc -> if (c <> i) then (String.make 1 i) ^ acc else acc) str "" in 
      let rec f n = 
        match n with
         0 -> filter str2.[0] str1
        |_ -> filter str2.[n] (f (n-1)) in
      f ((String.length str2) - 1);;

    "AbCbEfG" -^ "abcdefg";; (*ACEG*)
    "Dario Pellegrino" -^ "abcdewxyz";; (*Drio Pllgrino*)
    "KkattArAkK bel Babun" -^ "Kba";; (*kttArAk el Bun*)

    (* remove all blank spaces from a String *)
    let strip str = String.fold_right (fun i acc -> if (i <> ' ') then (String.make 1 i) ^ acc else acc) str "";;
    strip "aaa aa";;

    (* check if the String str is anagram of one or more String contained in str_list *)
    let rec anagram str str_lst =
      let sort_string str = str |> String.to_seq |> List.of_seq |> List.sort Char.compare |> List.to_seq |> String.of_seq in
      let sorted = str |> strip |> String.lowercase_ascii |> sort_string in
      match str_lst with 
       []      -> false
      |s :: sl -> if (String.equal (s |> strip |> String.lowercase_ascii |> sort_string) sorted) 
                      then true else anagram str sl;;

    let s1 = "kattarak el babun";; 
    let s2 = "casa";;
    let s3 = "abba";;
    let sl1 = ["kattabun el  barak"; "kattabun el    tarak"; "kbatatunk le  bara"];; 
    let sl2 = ["casa"; "saca" ; "saac"; "sasa"; "caas"];;
    let sl3 = ["aba"; "bab" ; "aaba"];;
    anagram s1 sl1;; (* true *)
    anagram s2 sl2;; (* true *)
    anagram s3 sl3;; (* false *)

    let rec anagramv2 str str_lst =
      let sort_string s = s |> String.to_seq |> List.of_seq |> List.sort Char.compare |> List.to_seq |> String.of_seq in
      let sorted = str |> strip |> String.lowercase_ascii |> sort_string in
      match str_lst with 
       []      -> []
      |s :: sl -> if (String.equal (s |> strip |> String.lowercase_ascii |> sort_string) sorted)
                      then (true, s) :: (anagramv2 str sl) else (false, s) :: (anagramv2 str sl);;

    anagramv2 s1 sl1;; (* [(true, "kattabun el  barak"); (false, "kattabun el    tarak"); (true, "kbatatunk le  bara")]*)
    anagramv2 s2 sl2;; (* [(true, "casa"); (true, "saca"); (true, "saac"); (false, "sasa"); (true, "caas")]*)
    anagramv2 s3 sl3;; (* [(false, "aba"); (false, "bab"); (false, "aaba")]*)
      
  end;;