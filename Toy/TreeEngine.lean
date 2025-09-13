import Lean
import Toy.Tree
open Lean

deriving instance ToJson, FromJson for Enum, Tree

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

def exprToEnumElem (e: Expr) : Enum :=
  match e with
  | Expr.const ``Enum.a _ => .a
  | Expr.const ``Enum.b _ => .b
  | Expr.const ``Enum.c _ => .c
  | Expr.const ``Enum.d _ => .d
  | Expr.const ``Enum.e _ => .e
  | _ => panic! s!"Expr not an Enum: {e}"

def exprToTree (e: Expr) : Tree :=
  match e with
  | Expr.app (Expr.const ``Tree.leaf _) enumElem => .leaf (exprToEnumElem enumElem)
  | Expr.app (Expr.app (Expr.const ``Tree.node _) el) er => .node (exprToTree el) (exprToTree er)
  | _ => panic! s!"Expr not a Tree: {e}"

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
    let serializedTree := exprToTree expr |> treeToExport
    let value ← Meta.mkAppM ``treeFromExport #[ToExpr.toExpr serializedTree]
    addAndCompile <| .defnDecl {
        name, value,
        type := .const ``Tree [],
        levelParams := []
        hints := .regular 0
        safety := .safe
      }
    return .const (name) []
