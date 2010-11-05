open Versioned

include PartiallyOrdered
type version_vector
val empty : t
val incremented : int -> int64 -> int64 -> t -> t
val less_than : version_vector -> version_vector -> bool
val ts : t -> int64

