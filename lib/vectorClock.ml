open Versioned
module type VectorClockSig = 
sig
  include PartiallyOrdered
  type version_vector
  val empty : t
  val incremented : int -> int64 -> int64 -> t -> t
  val less_than : version_vector -> version_vector -> bool
  val ts : t -> int64
end

module IntOrdered =
struct
  type t = int
  let compare = compare
end
  
module IntMap = Map.Make(IntOrdered)         

module OptionMap(Underlying: Map.S) =
struct
  include Underlying
    
  let find k m = 
    try Some (Underlying.find k m)
    with Not_found -> None
      
  let put k v m =
    Underlying.add k v 
      (match (find k m) with
          Some(_) -> Underlying.remove k m
        | None -> m)
end
  
module IntOptionMap = OptionMap(IntMap)
  
module VectorClock : VectorClockSig =
struct
  type version_vector = int64 IntOptionMap.t
  type t = VectorClock of int64 * version_vector
      
  let empty =
    VectorClock(0L, IntOptionMap.empty)
      
  let ts v = 
    match v with 
        VectorClock(t, _) -> t
          
  let incremented n t ts v =
    match v with
        VectorClock(_, versions) ->
          VectorClock(ts, IntOptionMap.put n t versions)
            
  let less_than a b = 
    (IntMap.for_all (fun n t ->
      t <= (match IntOptionMap.find n b with
          Some(x) -> x
        | None -> 0L)) a) 
    &&
      (IntMap.exists (fun n t ->
        t < (match IntOptionMap.find n b with
            Some(x) -> x
          | None -> 0L)) a)
    ||
      (IntMap.cardinal a < IntMap.cardinal b)
      
  let maybe_compare c1 c2 = 
    match c1, c2 with 
        VectorClock(_, versions), VectorClock(_, that) ->
          if (less_than versions that) then
            Some (-1)
          else if (less_than that versions) then
            Some 1
          else if (compare versions that) == 0 then 
            Some 0
          else
            None
end


          
        

       
