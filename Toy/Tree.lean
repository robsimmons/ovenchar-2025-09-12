inductive Enum where
 | a
 | b
 | c
 | d
 | e
deriving Repr

inductive Tree where
 | leaf : Enum → Tree
 | node : Tree → Tree → Tree
deriving Repr
