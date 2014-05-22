(import ast
        [hash.utils [visit]])
(require hash.utils)
(require hash.template)

(visitor str obj obj) ; When obj is a a str, return it

(visitor list node-list ; Returns list of space seperated items
         (.join " " (genexpr (visit item) [item node-list])))

(visitor ast.Module node
         (.join "" (genexpr (visit stmt) [stmt node.body])))

(visitor ast.Name node node.id)

(visitor ast.Num node (repr node.n))

(visitor ast.alias node
	 (if node.asname
	   (.format "[{0} :as {1}]" node.name node.asname)
	   node.name))

(visitor ast.Assign node
         (.join "\n" (genexpr (t!setv target node.value)
                      [target node.targets])))

(visitor ast.AugAssign node
         (t!sexp (aug-op node.op) node.target node.value))

(visitor ast.Import node (t!import node.names))
