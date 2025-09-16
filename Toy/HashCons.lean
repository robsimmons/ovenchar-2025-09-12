import Std
import Std.Data.HashMap
import Toy.Tree


abbrev TreeRepr := Int
abbrev TreeTable := Array TreeRepr
abbrev TreeLookup := Std.HashMap (TreeRepr × TreeRepr) TreeRepr

def getEnumRepr (elem: Enum): Int :=
   match elem with
   | .a => -1
   | .b => -2
   | .c => -3
   | .d => -4
   | .e => -5

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
   | .leaf elem => pure (getEnumRepr elem)

def compressTree (t: Tree): TreeTable × TreeRepr :=
   let (repr, s) := getTreeRepr t |>.run { store := #[], map := Std.HashMap.emptyWithCapacity }
   (s.store, repr)

-- Note: this decompression will not result in efficient in-memory representations
partial def decompressTree (store: TreeTable) (repr: TreeRepr): Tree :=
  match repr with
  | -1 => .leaf .a
  | -2 => .leaf .b
  | -3 => .leaf .c
  | -4 => .leaf .d
  | -5 => .leaf .e
  | _ =>
    match Int.toNat? repr with
    | .none => panic! s!"invalid repr {repr}"
    | .some idx =>
      .node
        (decompressTree store (store[idx]!))
        (decompressTree store (store[idx + 1]!))

#eval compressTree (.node
  (.node
    (.node (.node (.leaf .d) (.leaf .d)) (.node (.leaf .d) (.leaf .d)))
    (.node (.node (.leaf .d) (.leaf .d)) (.node (.leaf .d) (.leaf .a))))
  (.node (.leaf .d) (.leaf .a)))
