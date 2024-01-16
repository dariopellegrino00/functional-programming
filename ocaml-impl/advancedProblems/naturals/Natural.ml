module Natural = 
  struct
    type natural = Zero | Succ of natural

    exception NegativeNumber
    exception DivisionByZero

    let rec ( + ) n = function
        Zero    -> n
      | Succ(m) -> (+) (Succ(n)) m

    let rec (>) n m = 
      match n, m with 
        Succ(_), Zero    -> true
      | Zero, Succ(_)    -> false
      | Zero, Zero       -> false
      | Succ(a), Succ(b) -> (>) a b 

    let rec ( - ) n m = 
      if not (m > n) then 
        match n, m with 
          n', Zero           -> n'
        | Succ(n'), Succ(m') -> (-) n' m'
        | Zero, _            -> raise NegativeNumber (** only to remvoe the matching case warning*)
      else 
        raise NegativeNumber
    
    let ( * ) n m =
      let rec ( * ) n' m' =
        if n' > Zero then 
          match n', m' with 
            _, Zero       -> Zero 
          | _, Succ(Zero) -> n'
          | _, Succ(m'')  -> ( * ) ((+) n' n) m''  
        else 
          Zero in 
      ( * ) n m 

      let ( / ) n m =
      if n > Zero then (
        if not (m > Zero) then raise DivisionByZero
        else
          let rec ( / ) r n m =
          if not (m > n) then ( / ) (Succ r) ((-) n m) m
          else r
          in ( / ) Zero n m )
      else Zero
      
    
    let ( ** ) n e = 
      let rec ( ** ) n' e' = 
        match n', e' with 
          _, Zero       -> Succ(Zero)
        | _, Succ(Zero) -> n'
        | _, Succ(e'')  -> ( ** ) (( * ) n' n') e''
      in ( ** ) n e
      
    let rec eval = function
      Zero    -> 0
    | Succ(n) -> succ (eval n)

    let convert n =
      let rec convert r n =
      if (0 < n ) then convert (Succ(r)) ( pred n )
      else r
      in convert Zero n
  end;; 

module N = (Natural: NaturalI.NaturalI);;