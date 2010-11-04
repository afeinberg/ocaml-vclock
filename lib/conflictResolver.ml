open VectorClock

type order = Before | After
type 'a versioned = 'a Versioned.Make(VectorClock).t

module V = Versioned.Make(VectorClock) 

let vector_clock_resolver a b =
  let a' = V.version a in
  let b' = V.version b in
  let comparison = 
    match (V.maybe_compare a b) with 
        Some(x) -> x
      | None -> compare (VectorClock.ts a') (VectorClock.ts b')
  in
  match comparison with
      x when x = 0 or x = 1 -> After
    | (-1) -> Before
    | _ -> raise (Invalid_argument "invalid value from compare")

let resolve_conflict resolver lst =
  match lst with
      x :: xs -> 
  		V.value (List.fold_left 
                   (fun a b ->
                     match (resolver a b) with
                         Before -> b
                       | After-> a)
                   x xs)
    | [] -> raise (Invalid_argument "empty")
      
let resolve_conflict_vc lst = resolve_conflict vector_clock_resolver lst
              
