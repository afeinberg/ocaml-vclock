module type PartiallyOrdered =
sig
  type t
  val maybe_compare: t -> t -> int option
end

module type V = 
sig
  type version 
  type 'a t
  val maybe_compare: 'a t -> 'a t -> int option
  val value: 'a t -> 'a
  val version: 'a t -> version
  val create: 'a -> version -> 'a t
end

module Make(PartOrd: PartiallyOrdered) =
struct
  type version = PartOrd.t
  type 'a t = 'a * version
      
  let maybe_compare (_, v1) (_, v2) = 
    PartOrd.maybe_compare v1 v2
            
  let value (v, _) = v
          
  let version (_, ver) = ver
          
  let create v ver = v, ver
end  

       
