module Matrix = 
  struct
    type matrix = int list list

    let zeroes n m = List.init n (fun x -> List.init m (fun x -> 0))

    let identity n = (fun x -> List.init n (fun y -> if (x <> y) then 0 else 1))

    let init n = List.init n (fun x -> List.init n (fun y -> x*n+ y+1 )) ;;

    let rec transpose = 
      function 
      []               -> []
      |[] :: xss        -> transpose xss
      |(x :: xs) :: xss -> (x :: List.map List.hd xss) :: transpose (xs :: List.map List.tl xss) ;;


    let rec frequences = 
      function 
      []  -> []
      |x :: xs -> ['b'] :: ['a'] :: [];

  end;;