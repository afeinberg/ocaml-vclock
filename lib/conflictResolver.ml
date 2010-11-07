exception Empty

module V = Versioned.Make(VectorClock) 

type order = Before | After
type 'a versioned = 'a V.t



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
    | _ -> raise (Invalid_argument "Invalid value from compare")

let resolve_conflict resolver = function 
x :: xs -> V.value (List.fold_left 
                      (fun a b -> 
                        match (resolver a b) with
                            Before -> b
                          | After-> a)
                      x xs)
  | [] -> raise Empty
    
let resolve_conflict_vc lst = resolve_conflict vector_clock_resolver lst
              
