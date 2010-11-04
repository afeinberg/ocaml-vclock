open Printf
open OUnit
open VectorClock

module V = Versioned.Make(VectorClock)

let assert_clock m a b c = assert_equal ~msg:m (V.maybe_compare a b) c

let assert_equiv a b = assert_clock "clocks are equal" a b (Some 0)

let assert_before a b = assert_clock "clocks a is before clock b" a b (Some (-1))

let assert_after a b = assert_clock "clock a is after clock b" a b (Some 1)

let assert_concurrent a b =
  assert_clock "clock a is concurrent to clock b" a b None

let test_maybe_compare _ =
  let a = V.create "a" VectorClock.empty in
  let b = V.create "b" (VectorClock.incremented 0 1L 123L VectorClock.empty) in
  let c = V.create "c" (VectorClock.incremented 1 1L 123L VectorClock.empty) in
  let d = V.create "d" (VectorClock.incremented 0 2L 123L VectorClock.empty) in 
  assert_equiv a a ;
  assert_before a b ;
  assert_after d b ;
  assert_concurrent b c

let test_conflict_resolver _ =
  let a = VectorClock.incremented 0 1L 123L VectorClock.empty in
  let b = VectorClock.incremented 1 2L 123L a in
  let lst = [ V.create "a" a ; V.create "b" b ] in
  let lst' = [ V.create "a" b ; V.create "b" a ] in
  let resolved = ConflictResolver.resolve_conflict_vc lst in
  let resolved' = ConflictResolver.resolve_conflict_vc lst' in
  assert_equal ~msg:"conflict resolver #1" resolved "b" ;
  assert_equal ~msg:"conflict resolve #2" resolved' "a"
    
let suite = "VectorClock" >::: [
  "maybe_compare" >:: test_maybe_compare ;
  "conflict_resolver" >:: test_conflict_resolver
]

let _ = run_test_tt_main suite
