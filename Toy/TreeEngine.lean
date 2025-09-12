import Lean
open Lean

inductive Enum where
 | a
 | b
 | c
 | d
deriving Repr, ToJson, FromJson, Inhabited

inductive Tree where
 | leaf : Enum → Tree
 | node : Tree → Tree → Tree
deriving Repr, ToJson, FromJson, Inhabited

def treeFromExport (s: String) : Tree :=
  match Json.parse s with
  | .error e => panic! s!"String not JSON: {e}"
  | .ok v =>
    match FromJson.fromJson? v with
    | .error e => panic! s!"JSON not tree: {e}"
    | .ok v' => v'

def treeToExport (t: Tree) : String :=
  t |> ToJson.toJson |> Json.compress -- Why does .compress fail in this context?

def exprToEnumElem (e: Expr) : Enum :=
  match e with
  | Expr.const ``Enum.a _ => .a
  | Expr.const ``Enum.b _ => .b
  | Expr.const ``Enum.c _ => .c
  | Expr.const ``Enum.d _ => .d
  | _ => panic! s!"Expr not an Enum: {e}"

def exprToTree (e: Expr) : Tree :=
  match e with
  | Expr.app (Expr.const ``Tree.leaf _) enumElem => .leaf (exprToEnumElem enumElem)
  | Expr.app (Expr.app (Expr.const ``Tree.node _) el) er => .node (exprToTree el) (exprToTree er)
  | _ => panic! s!"Expr not a Tree: {e}"

elab "#tree" syn:term : term =>
  withOptions (·.setBool `compiler.extract_closed false) do
    let expr ← Elab.Term.elabTerm syn (some <| Expr.const ``Tree [])
    let serializedTree := exprToTree expr |> treeToExport
    let name ← Lean.mkFreshUserName `hash_tree
    let value ← Meta.mkAppM ``treeFromExport #[ToExpr.toExpr serializedTree]
    addAndCompile <| .defnDecl {
        name, value,
        type := .const ``Tree [],
        levelParams := []
        hints := .regular 0
        safety := .safe
      }
    return .const (name) []
