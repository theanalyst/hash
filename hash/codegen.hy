(import ast
        [hash.utils [visit]]
        [hy._compat [str_type]])
(require hash.utils)
(require hash.template)


(visitor str obj obj)

(visitor str_type obj obj) ; Handle unicode for py2

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
         (.join "\n" (genexpr (t-setv target node.value)
                      [target node.targets])))

(visitor ast.AugAssign node
         (t-sexp (aug-op node.op) node.target node.value))

(visitor ast.Import node (t-import node.names))

;; TODO atm relative imports are not supported..add dots for levels
;; once that lands in hy, also this is kind of a hack as
;; from math import floor,sqrt as s has to be translated in hy
;; as "(import [math [floor] [sqrt :as s]])"
;; Also need to figure out not creating spaces when empty item is encounterd
(visitor ast.ImportFrom node
         (let [[module-imports
               (list (filter (fn [it] (nil? it.asname)) node.names))]
              [alias-imports
               (list (filter (fn [it] (not (nil? it.asname))) node.names))]]
           (when node.module
             (t-import
              (hylist node.module (hylist module-imports)
                      alias-imports)))))
