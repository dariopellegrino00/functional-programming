open Algeb_structs

module BoolMonoid = Monoid( 
  struct 
    type t = bool 
    let is_in_set p = true
    let id = false
    let op = (||)
    let checkingSet = [false;true]
  end 
);;

Printf.printf "**log: %s\n" "Boolmonoid with || is a monoid!";;

module IntMonoid = Monoid( 
    struct 
      type t = int 
      let is_in_set p = p >= 0
      let id = 0
      let op = ( * )
      let checkingSet = [1;2;3;4;5]
    end 
  );;

Printf.printf "**log: %s\n" "IntMonoid with * is a monoid!"; false;;

let not_monoid =
try (
  let module NotIntMonoid = Monoid( 
    struct 
      type t = int 
      let is_in_set p = true
      let id = 0
      let op = ( / )
      let checkingSet = [1;2;3;4;5]
    end 
  ) in true)
with e ->
  Printf.printf "**log: %s %s\n" "IntMonoid with / is not a monoid!" (Printexc.to_string e); false;;


module IntGroup = Group(
  struct 
      type t = int 
      let is_in_set p = true
      let id = 0
      let op = ( + )
      let checkingSet = [-1;-2;-3;1;2;3]
  end 
);;

Printf.printf "**log: %s\n" "IntGroup with + and id = 0 is a group";;

let not_group =
try (
  let module NotIntGroup = Group( 
    struct 
      type t = int 
      let is_in_set p = true
      let id = 1
      let op = ( * )
      let checkingSet = [-1;-2;-3;1;2;3]
    end 
  ) in true)
with e ->
  Printf.printf "**log: %s %s\n" "NotIntGroup with * and id = 1 is not a group!" (Printexc.to_string e); false;;

module IntRing = Ring(IntGroup)(
  struct
    type t = int
    let is_in_set p = true
    let id = 1
    let op = ( * )
  end) ;;

try
let module NotIntRing = Ring(IntGroup)(
  struct
    type t = int
    let is_in_set p = true
    let id = 0
    let op = ( + )
  end) in true 
with e-> 
  Printf.printf "**log: %s %s\n" "NotIntGroup with * and id = 1 is not a group!" (Printexc.to_string e); false;;

