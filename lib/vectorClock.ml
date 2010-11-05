open Versioned

module IntOrdered =
struct
  type t = int
  let compare = compare
end
  
module IntMap = Map.Make(IntOrdered)         

module IntDefaultMap =
struct
  type t = int64 IntMap.t

  open IntMap 

  let empty = empty
    
  let put k v m =
    add k v m

  let find k m = 
    try 
      find k m
    with Not_found -> 
      0L
end
  
type version_vector = IntDefaultMap.t

type t = int64 * version_vector
    
let empty = (0L, IntDefaultMap.empty)
    
let ts = fst 
        
let incremented n t ts (_, versions) =
  (ts, IntDefaultMap.put n t versions)
          
let less_than a b = 
  (IntMap.for_all 
     (fun n t -> t <= IntDefaultMap.find n b) 
     a) 
  &&
  (IntMap.exists 
     (fun n t -> t < IntDefaultMap.find n b) 
     a)
  ||
  (IntMap.cardinal a < IntMap.cardinal b)
    
let maybe_compare (_, versions) (_, that) = 
  if (less_than versions that) then
    Some (-1)
  else if (less_than that versions) then
    Some 1
  else if (compare versions that) == 0 then 
    Some 0
  else
    None
