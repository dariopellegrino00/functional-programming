
let is_prime n = 
  let num = abs n in 
  let rec is_prime c = 
    if c = num then true 
    else if n mod c = 0 then false 
    else is_prime (c+1) in
  if num = 1 then true 
  else if num = 2 then false else is_prime 2


let test_ip = List.map (fun x -> (x, is_prime x)) [(-10);(-7);(-1);0;1;2;3;4;5;6;7;8;9;10;11;12;13]

exception NotEvenNumber

let goldbach num =
  let absnum = abs num in 
  let rec goldbach c acc = 
    if (is_prime c) then 
      match List.find_opt (fun x -> x + c = absnum) acc with 
      | Some e -> if num < 0 then ((-e), (-c)) else (e,c)
      | None   -> goldbach (c+1) (c :: acc)
      else goldbach (c+1) acc in 
  if absnum mod 2 <> 0 then raise NotEvenNumber
  else goldbach 1 [1]

let test_gb = List.map (fun x -> (x, goldbach x)) [2;4;6;8;10;12;24]

(** 
Retuns the even intereger in the range n to m.
if n <= m goes ascending from n to m, viceversa from m to n 
*)
let rec range n m  =
  let rec range n m acc = 
    if m < n then acc
    else if m mod 2 = 0 && m <> 0 then range n (m-1) (m :: acc)
    else range n (m-1) acc in 
  if n <= m then range n m [] else List.rev (range m n [])

(** 
Retuns the goldbach sum of the even intereger in the range n to m.
if n <= m goes ascending from n to m, viceversa from m to n 
*)
let goldbach_list n m = List.map (fun x -> goldbach x) (range n m) 