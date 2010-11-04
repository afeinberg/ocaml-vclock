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

module Make(PartOrd: PartiallyOrdered): V with type version = PartOrd.t

