import Std
import Std.Data.HashMap
import Toy.Tree

abbrev TreeRepr := Int
abbrev TreeTable := Array TreeRepr
abbrev TreeLookup := Std.HashMap (TreeRepr × TreeRepr) TreeRepr


structure TreeReprState : Type where
  store : TreeTable
  map : TreeLookup

def getTreeRepr (t: Tree) : StateM TreeReprState TreeRepr := do
   match t with
   | .node t1 t2 =>
     let repr1 ← getTreeRepr t1
     let repr2 ← getTreeRepr t2
     match Std.HashMap.get? (← get).map (repr1, repr2) with
     | .some repr => pure repr
     | .none =>
       -- Create new binding
       let newRepr := Array.size (← get).store |> Int.ofNat
       modify (fun st => {st with
          store := Array.append st.store #[repr1, repr2]
          map := Std.HashMap.insert (st.map) (repr1, repr2) newRepr
       })
       pure newRepr
   | .leaf elem => pure (-(Int.ofNat (elem + 1)))

def compressTree (t: Tree): TreeTable × TreeRepr :=
   let (repr, s) := getTreeRepr t |>.run { store := #[], map := Std.HashMap.emptyWithCapacity }
   (s.store, repr)

-- Note: this decompression will not result in efficient in-memory representations
partial def decompressTree (store: TreeTable) (repr: TreeRepr): Tree :=
  match Int.toNat? (-(repr + 1)) with
  | .some elem => .leaf elem
  | _ =>
    match Int.toNat? repr with
    | .none => panic! s!"invalid repr {repr}"
    | .some idx =>
      .node
        (decompressTree store (store[idx]!))
        (decompressTree store (store[idx + 1]!))

#eval compressTree (.node
  (.node
    (.node (.node (.leaf 3) (.leaf 3)) (.node (.leaf 3) (.leaf 3)))
    (.node (.node (.leaf 3) (.leaf 3)) (.node (.leaf 3) (.leaf 0))))
  (.node (.leaf 3) (.leaf 0)))
