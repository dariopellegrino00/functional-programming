
let pow a b = 
  let rec f acc e = if (e < 1) then acc else f (acc * a) (e-1) 
  in
  if b < 0 then 0 else f 1 b


let trialdivision n =
  let num = abs n in 
  let rec tdfun d = 
    if (num mod d) = 0 then 
      if (d > 1) then false 
      else true
    else tdfun (d-1) 
  in if num < 2 then false else tdfun (num / 2 + 1)
  


let lucaslehmer p = 
    let rec rnd n = (** cant be zero*)
      let a = Random.full_int (n-1) in 
      if (a > 0) then a else rnd n in 
    let rec f i = 
      if i < 100 then 
        if ((pow (rnd p-1) p) mod p) = 1 then 
          f (i+1)
        else 
          false
      else 
        true 
    in f 0 


let littlefermat n = false

  let is_prime n = 
    match abs n with 
      td when n <= 10000  -> trialdivision td
    | ll when n <= 524287 -> lucaslehmer ll
    | lf                  -> littlefermat lf


