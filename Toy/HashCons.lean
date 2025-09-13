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

def getTreeRepr (t: Tree) (store: TreeTable) (map: TreeLookup): TreeRepr × TreeTable × TreeLookup :=
   match t with
   | .node t1 t2 =>
     let (repr1, store1, map1) := getTreeRepr t1 store map
     let (repr2, store2, map2) := getTreeRepr t2 store1 map1
     match Std.HashMap.get? map2 (repr1, repr2) with
     | .some repr => (repr, store2, map2)
     | .none =>
       -- Create new binding
       let newRepr := Array.size store2 |> Int.ofNat
       let newStore := Array.append store2 #[repr1, repr2]
       let newMap := Std.HashMap.insert map2 (repr1, repr2) newRepr
       (newRepr, newStore, newMap)
   | .leaf elem =>
     (getEnumRepr elem, store, map)

def compressTree (t: Tree): TreeTable × TreeRepr :=
   let (repr, table, _) := getTreeRepr t #[] Std.HashMap.emptyWithCapacity
   (table, repr)

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
