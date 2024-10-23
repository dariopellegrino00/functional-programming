
let alkaline_earth_metals = 
  ("beryllium", 4) :: ("magnesium", 12) :: ("calcium", 20) :: ("strontium", 38) ::  ("barium", 56) :: ("radium", 88) :: [];;

let max_metal l =
  let rec aux_max acc = function
    | (e, n) :: elems -> if n > acc then aux_max n elems else aux_max acc elems
    | [] -> acc
in aux_max 0 l;;

max_metal alkaline_earth_metals;;

let sort_metals = 
  let rec insert e = 
    function 
    
    | x :: xs when 
  let rec sraux acc = function
    | (n, e) :: l -> 
    | [] -> acc
  