(import ast
        [hash.utils [visit getop]])
(require hash.utils)
(require hash.template)

(visitor str obj obj) ; When obj is a a str, return it

(visitor ast.Module node
         (.join "" (genexpr (visit stmt) [stmt node.body])))

(visitor ast.Name node node.id)

(visitor ast.Num node (repr node.n))

(visitor ast.Assign node
         (.join "\n" (genexpr (t!setv target node.value)
                      [target node.targets])))

(visitor ast.AugAssign node
         (t!sexp (aug-op node.op) node.target node.value))
