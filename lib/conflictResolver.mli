open VectorClock

type order
type 'a versioned = 'a Versioned.Make(VectorClock).t

val vector_clock_resolver : 'a versioned -> 'a versioned -> order
val resolve_conflict : ('a versioned -> 'a versioned -> order) -> 'a versioned list -> 'a
val resolve_conflict_vc : 'a versioned list -> 'a
