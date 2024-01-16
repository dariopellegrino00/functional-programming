
let is_prime = function
    | n when n > 1 -> 
      let rec f d = if (n mod d) = 0 && d > 1 then false else if (d < 2) then true else f (d-1) in
      f (n-1)
    | _            -> false;; 

let solut_is_prime n =
  let n = abs n in
  let rec is_not_divisor d =
    d * d > n || (n mod d <> 0 && is_not_divisor (d + 1)) in
  n <> 1 && is_not_divisor 2;;
let goldbach n =
    let rec aux d =
      if is_prime d && is_prime (n - d) then (d, n - d)
      else aux (d + 1)
    in
      aux 2;;
   
let goldbach_list n m =
  let rec range s e acc = 
    if s > e then acc else range (s+1) e (s :: acc) in 
  let even_range = List.filter (fun x -> (x mod 2) = 0) (range n m []) in
  let rec f acc = function 
    | []      -> acc
    | h :: t  -> 
      let gb = goldbach h in 
      f (gb :: acc) t in 
  f [] even_range;;


