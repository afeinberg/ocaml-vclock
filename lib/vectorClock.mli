open Versioned
module type VectorClockSig =
sig
    include PartiallyOrdered
    type version_vector
    val empty : t
    val incremented : int -> int64 -> t -> t
    val less_than : version_vector -> version_vector -> bool
    val ts : t -> int64
end

module VectorClock : VectorClockSig


