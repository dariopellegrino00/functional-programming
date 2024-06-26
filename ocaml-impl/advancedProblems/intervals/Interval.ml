module type Comparable = sig
  type t
  val compare : t -> t -> int
  val tostring : t -> string
end ;;


module type IntervalI =
 sig
    type interval
    type endpoint
    val create : endpoint -> endpoint -> interval
    val is_empty : interval -> bool
    val contains : interval -> endpoint -> bool
    val intersect : interval -> interval -> interval
    val tostring : interval -> string
    exception WrongInterval
 end;;

module Interval(Endpoint: Comparable):
 (IntervalI with type endpoint = Endpoint.t) =
  struct
    type endpoint = Endpoint.t
    type interval = Interval of Endpoint.t * Endpoint.t | Empty
    exception WrongInterval

    (** [create low high] creates a new interval from [low] to
    [high]. If [low > high], then the interval is empty *)
    let create low high =
    if Endpoint.compare low high > 0 then raise WrongInterval
    else if Endpoint.compare low high == 0 then Empty
    else Interval (low,high)
    (** Returns true iff the interval is empty *)
    let is_empty = function
    | Empty -> true
    | Interval _ -> false
    (** [contains t x] returns true iff [x] is contained in the
    interval [t] *)
    let contains t x =
    match t with
    | Empty -> false
    | Interval (l,h) ->
    Endpoint.compare x l >= 0 && Endpoint.compare x h <= 0
    (** [intersect t1 t2] returns the intersection of the two input
    intervals *)
    let intersect t1 t2 =
    let min x y = if Endpoint.compare x y <= 0 then x else y in
    let max x y = if Endpoint.compare x y >= 0 then x else y in
    match t1,t2 with
    | Empty, _ | _, Empty -> Empty
    | Interval (l1,h1), Interval (l2,h2) ->
    create (max l1 l2) (min h1 h2)

    let tostring = function
    | Empty -> "[]"
    | Interval(l,h) -> "["^(Endpoint.tostring l)^", "^(Endpoint.tostring h)^"]"
  end ;;


  module IntInterval = Interval(
    struct
      type t = int
      let compare = compare
      and tostring = string_of_int
  end);;

module StringInterval = Interval(
 struct
 type t = string
 let compare = String.compare
 and tostring = fun x -> x
 end);;