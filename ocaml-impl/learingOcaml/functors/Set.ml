module type Comparable = 
  sig 
    type t
    val compare : t -> t -> int

    val tostring : t -> string
  end;;


module type SetADT =
  sig 
    type element
    type set
    val create_empty: set
    val contains: set -> element -> bool
    val add: set -> element -> set
    val is_empty: set -> bool
    val remove: set -> element -> set
    val union: set -> set -> set
    val intersect: set -> set -> set
    val tostring : set -> string
  end;;

module Set(Element: Comparable) :
  (SetADT with type element = Element.t) =
  struct 
    type element = Element.t
    type set = Empty | Set of element list
    
    let create_empty = Empty

    let contains s e = match s with
      Empty  -> false
    | Set s' -> if List.exists (fun x -> x = e) s' then true else false 

    let add s e = 
      if not (contains s e) then 
        match s with
          Empty  -> Set [e]
        | Set s' -> Set (e :: s') 
      else s
    
    let is_empty s =  match s with 
      Empty -> true
    | _     -> false 

    let remove s e = 
      match s with
        Empty  -> Empty
      | Set s' -> Set(List.filter (fun x -> x != e) s') 

    let union set1 set2 = 
      match set1, set2 with
        _, Empty       -> set1
      | Empty, _       -> set2
      | Set s1, _ -> 
          let rec union acc = function
            []      -> acc
          | x :: xs -> union (add acc x) xs in 
      union set2 s1   
    
    let intersect set1 set2 = 
      match set1, set2 with
        _, Empty       -> Empty
      | Empty, _       -> Empty
      | Set s1, _ -> 
          let rec inters acc = function
            []      -> acc
          | x :: xs -> 
            if contains set2 x then 
              inters (add acc x) xs
            else
              inters acc xs in 
      inters Empty s1  
    
    let tostring s = 
      match s with 
        Empty   -> "[ ]"
      | _  -> "Set"

  end;;

module IntSet = Set(
  struct 
    type t = int
    let compare a b = a - b
    let tostring = string_of_int
  end
);;


module StringSet = Set(
  struct 
    type t = string
    let compare a b = String.compare a b
    let tostring s = s 
  end
);;

