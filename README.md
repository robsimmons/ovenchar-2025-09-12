# Jason and Rob's mid-September adventure

What's going on:

- Toy.TreeEngine is defining a simple binary tree structure (two-bit data stored at leaves)
- The `#tree <term>` term macro requires `<term>` to be a _literal, full-evaluated-to-data_
  elemnt of type Tree.
- Possible TODO exercise: make the error messages if `<term>` has the wrong form be nice.
- For a literal tree `T`, the `#tree T` expression has the same denotation as `T`, but is
  elaborated quite differently: the tree structure is serialized to JSON and then, at execution
  time, that tree is deserialized to the same tree that `T` described.
- TODO exercise: have hash-consing running within a single `#tree <term>` evaluation so that the
  shared tree structure is locally captured 
- TODO exercise: have hash-consing running across a file so that shared tree structure is fully
  captured across multiple trees
- Possible TODO exercise: allow for "example" trees that don't use the global state, or something
  that similarly represents what we hope to do with the Verso improvements that need to handle 
  tree-shaped signature structures for examples.

This is an interesting exercise in metaprogramming because `treeFromExport` is being used as a
partial inverse of `treeToExport`, but `treeToExport` runs exclusively at compile time,
and `treeFromExport` runs exclusively at execution time.
