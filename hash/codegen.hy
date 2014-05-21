(import ast)
(import [utils [visit]])
(require utils)
(require template)

(visitor ast.Module node
         (.join "" (genexpr (visit stmt) [stmt node.body])))

(visitor ast.Name node node.id)

(visitor ast.Num node (repr node.n))

(visitor ast.Assign node
         (.join "\n" (genexpr
                      (t!setv (visit target) (visit node.value))
                      [target node.targets])))

