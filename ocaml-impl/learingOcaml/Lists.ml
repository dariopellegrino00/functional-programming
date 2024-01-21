module Lists =
    struct 
    let rlencode list =
      let rec aux count acc = function
        | [] -> [] (* Can only be reached if original list is empty *)
        | [x] -> (count + 1, x) :: acc
        | a :: (b :: _ as t) -> if a = b then aux (count + 1) acc t
                                else aux 0 ((count + 1, a) :: acc) t in
      List.rev (aux 0 [] list);;

    let rec duplicate_elements = function (** NOT tail recursive*)
      | []      -> []
      | x :: xs -> x :: x :: duplicate_elements xs;;

    let rec take n = function
      | [] -> []
      | h :: t -> if n = 0 then [] else h :: take (n - 1) t;;
    
    let rec drop n = function
      | [] -> []
      | h :: t as l -> if n = 0 then l else drop (n - 1) t;;
    
    let slice list i k = take (k - i + 1) (drop i list);;
    
    let rotate_n list n = drop n list @ take n list;;

    let rec remove_at i = function (** NOT tail recursive*)
        | [] -> []
        | h :: t -> if i = 0 then t else h :: remove_at (i-1) t;;   
    
    let rec insert_at i x = function (** NOT tail recursive*)
      | [] -> []
      | h :: t as l -> if i = 0 then x :: l else h :: insert_at (i-1) x t;;   
    
    let range start endr = 
      let rec range_h s e acc = 
        if s > e then acc 
        else range_h s (e-1) (e :: acc)
      in range_h start endr [];;


    let drop_nth n list = 
      let rec droph i acc = function
        | []      -> acc
        | x :: xs -> if  ((i+1) mod (abs n)) = 0 then droph (i+1) acc xs else droph (i+1) (x :: acc) xs
      in droph 0 [] (List.rev list);;

      
      
  end;;

module Main = 
  struct
    if Lists.duplicate_elements [1;2;3;4] = [1;1;2;2;3;3;4;4] then print_string "true\n" else print_string "false\n";;
    if Lists.duplicate_elements [1;2;3;4] = [1;2;3;4] then print_string "true\n" else print_string "false\n";;
    if Lists.slice [1;2;3;4] 1 2 = [2;3] then print_string "true\n" else print_string "false\n";;

    Lists.slice [1;3;2;3;1] 1 2;;

    Lists.rotate_n [1;2;3;4;5] 2;;

    Lists.remove_at 2 [1;2;3;4;5];;

    Lists.insert_at 2 1 [1;2;3;4;5];;
    
    Lists.range 1 13;;
    Lists.range 15 13;;

    Lists.drop_nth 3 [1;2;3;4;5;6;7;8];;
  end;;