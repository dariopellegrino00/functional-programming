module Freq =
  struct
    (*current workin directory*)
    Sys.getcwd();;

    (*read file into a string list (every element of the list is a row) given an existing directory and file*)
    let read_file filename = 
      let lines = ref [] in
      let chan = open_in filename in
      try
        while true; do
          lines := input_line chan :: !lines
        done; !lines
      with End_of_file ->
        close_in chan;
        List.rev !lines ;;

     (*concat each element of the string list read from the file into one string*)
    let str1 = List.fold_left (fun acc x -> x ^ acc) "" (List.rev (read_file "lab01/text.txt"));; 
     
    (*test string*)  
    let str2 = String.lowercase_ascii "Kattarak dei kattarak el Babun el sief babun lollo babbo lollo";;

    (*check if a character c is a lettee*)
    let is_letter c = 
      let f c = List.exists (fun x -> x = (Char.code c)) [192; 193; 194; 195; 199; 201; 202; 205; 211; 212; 218; 213; 224; 225; 226; 227; 231; 233; 234; 237; 243; 245; 244; 250] in
      if (((Char.code c) >= 97) && (Char.code c) <= 122) || f c then true else false;;

    (*create a list of words with special characters from a string*)
    let lst_ofwords string = string |> String.lowercase_ascii |>  String.split_on_char ' ';;

    (*remove special characters, not included in words*)
    let rec filter_string_list str_list = 
      let filter_string string = 
        String.fold_left (fun acc x -> if (is_letter x) then (acc^(String.make 1 x) ) else acc) "" string in
      match str_list with
      | l :: ls -> filter_string l :: (filter_string_list ls) 
      | _       -> [];; 
    
    (*create a pair int (initialized to zero) * 'a (element of list) to be used as frequency counter*) 
    let rec str_list_counter str_lst =
      match str_lst with
      |x :: xs -> ((List.fold_left (fun acc y -> if (x = y) then acc + 1 else acc) 1 xs), x) :: str_list_counter xs
      |[]      -> [];;
      
    (*remove_duplicates of second elements of a pair list *)   
    let rec rem__duplicates pairs = 
      let f xs x = if (List.exists (fun y -> snd y = snd x)) xs then xs else x :: xs in 
      List.fold_left f [] pairs;;

    (*count the occurrence of each word in to a pair int * list (counter, word)) with count aduplicates*)
    let count_str str str_lst = List.fold_left (fun acc x -> if ((snd x) = str) then ((fst x) + 1, snd x) :: acc else x :: acc) [] str_lst |> List.rev ;;
      

    (*count the occurrence of each word in a string*)
    let rec words_frequencies string =
      string |> lst_ofwords |> filter_string_list |> str_list_counter |> rem__duplicates |> List.rev;;
    
    (*final result*)
    words_frequencies str1;;
    words_frequencies str2;;
   
  end;;