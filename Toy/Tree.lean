inductive Tree where
 | leaf : Nat → Tree
 | node : Tree → Tree → Tree
deriving Repr, Inhabited
