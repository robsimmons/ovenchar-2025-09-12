import Lean
import Toy.Tree
import Toy.HashCons
import Std.Data.TreeMap
open Lean

deriving instance ToJson, FromJson for Tree

-- Serialization
def treeToExport (t: Tree) : String :=
  t |> ToJson.toJson |> Json.compress -- Why do both .toJson and .compress fail in this context?

-- Deserialization
def treeFromExport (s: String) : Tree :=
  match Json.parse s with
  | .error e => panic! s!"String not JSON: {e}"
  | .ok v =>
    match FromJson.fromJson? v with
    | .error e => panic! s!"JSON not tree: {e}"
    | .ok v' => v'

def exprToTree (e: Expr) : Tree :=
  match e with
  | -- Not sure this case is possible
    Expr.app (Expr.const ``Tree.leaf _) (.lit (.natVal elem)) => .leaf elem
  | -- This seems to be what comes up in practice
    Expr.app (Expr.const ``Tree.leaf _) (.app (.app (.app (.const ``OfNat.ofNat _) _) (.lit (.natVal elem))) _) => .leaf elem
  | Expr.app (Expr.app (Expr.const ``Tree.node _) el) er => .node (exprToTree el) (exprToTree er)
  | _ => panic! s!"Expr not a Tree: {e}"

def treeToCompressedExport (t: Tree) : String :=
  let (store, repr) := compressTree t
  (Json.mkObj [("key", ToJson.toJson repr), ("table", ToJson.toJson store)]) |> Json.compress

def treeFromCompressedExport (s: String) : Tree :=
  let tree : Except String Tree := do
    let v ← Json.parse s |> .mapError (s!"String not JSON: {·}")
    let vstore ← Json.getObjVal? v "table" |> .mapError (s!"No table in JSON: {·}")
    let vkey ← Json.getObjVal? v "key" |> .mapError (s!"No key in JSON: {·}")
    let store ← FromJson.fromJson? vstore |> .mapError (s!"Store not array: {·}")
    let key ← FromJson.fromJson? vkey |> .mapError (s!"Store not array: {·}")
    return decompressTree store key
  match tree with
  | .ok t => t
  | .error s => panic! s

elab "#tree" syn:term : term =>
  -- David said to add this `withOptions` modifier: it is supposed to ensure that the defnDecl that
  -- we addAndCompile will not, under any circumstanses, be partially evaluated at compile time;
  -- this would of course defeat the purpose of doing a serialization step and make the whole thing
  -- just a complex let-hoisting. We were not able to trigger a case where this option changed
  -- anything, so this could be somewhat defensive.
  withOptions (·.setBool `compiler.extract_closed false) do
    -- Generate a symbol to connect definition and mention
    let name ← Lean.mkFreshUserName `hash_tree
    let expr ← Elab.Term.elabTerm syn (some <| Expr.const ``Tree [])
    let serializedTree := exprToTree expr |> treeToCompressedExport
    let value ← Meta.mkAppM ``treeFromCompressedExport #[ToExpr.toExpr serializedTree]
    addAndCompile <| .defnDecl {
        name, value,
        type := .const ``Tree [],
        levelParams := []
        hints := .regular 0
        safety := .safe
      }
    return .const (name) []
