module type MonoidADT = 
sig 
  type t 
  val is_in_set : t -> bool
  val id : t 
  val op : t -> t -> t 

  val checkingSet: t list 
end;;

module Monoid(M : MonoidADT) = 
struct
  include M
  exception NotAssociative;;
  let is_associative (a, b, c) =
      if M.is_in_set a && 
        M.is_in_set b && 
        M.is_in_set c && (
          let res1 = M.op a (M.op b c) in
          let res2 = M.op (M.op a b) c in 
          M.is_in_set res1 && M.is_in_set res2 && res1 = res2 
      ) then true else raise NotAssociative
  
  let get_triples list = 
    let rec get_couples list1 list2 acc = 
      match list1 with
      | [] -> acc
      | x :: xs -> get_couples xs list2 ((List.map (fun e -> (x, e)) list2) @ acc) in 
      let triples_unformat = get_couples (get_couples list list []) list [] in
      List.map (fun ((a, b), c) -> (a, b, c)) triples_unformat 

  let check_associative =  
      List.for_all is_associative (get_triples M.checkingSet)
end;;

module Group(G: MonoidADT) = 
  struct 
    include Monoid(G)  

    exception NotIdentity
    exception NotInverse
    let has_identity = 
      if List.for_all (fun x -> (G.op G.id x) = x && (G.op x G.id) == x ) G.checkingSet 
        then true 
        else raise NotIdentity
    let has_invert = 
      if List.for_all (
      fun x -> List.exists (fun y -> x <> y && G.op x y = G.id && G.op y x = G.id) G.checkingSet
      ) G.checkingSet 
        then true 
        else raise NotInverse
  end;;

module type UnckeckedMonoidADT = 
  sig 
    type t 
    val is_in_set : t -> bool 
    val id : t
    val op : t -> t -> t
  end;;

module Ring(G: MonoidADT)(M : UnckeckedMonoidADT with type t = G.t) = 
  struct 
    include Group(G)
    include Monoid(struct
      include M
      let checkingSet = G.checkingSet
    end) 
    
    exception NotCommutative
    exception NotDistributive
    let add_is_commutative = 
      if List.for_all (
      fun x -> List.exists (fun y ->  G.op x y = G.op y x) G.checkingSet
      ) G.checkingSet 
        then true 
        else raise NotCommutative 

    let add_is_dstributive =  
      let left_distributive (a, b, c) = M.op a (G.op b c) = G.op (M.op a b)(M.op a c) in 
      let right_distributive (a, b, c) = M.op (G.op a b) c = G.op (M.op a c) (M.op b c) in 
      let triples = get_triples G.checkingSet in
      if List.for_all (fun e -> left_distributive e && right_distributive e) triples 
      then true 
      else raise NotDistributive
      
  end;;