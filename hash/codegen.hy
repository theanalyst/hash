;; -*- lexical-binding: t; eval: (font-lock-add-keywords nil '(("defvisitor\\| => " (0 'font-lock-keyword-face)))); -*-

(import ast
        sys
        [itertools [chain]]
        [hash.utils [visit]]
        [hy._compat [str_type PY34]])
(require hash.utils)
(require hash.template)

(defvisitor str [obj] obj)

(defvisitor str_type [obj] obj)   ; Handle unicode for py2

(defvisitor list [node-list]     ; Returns list of space seperated items
  (.join " " (genexpr (visit item) [item node-list])))

(defvisitor ast.Module [node]
  (.join "" (genexpr (visit stmt) [stmt node.body])))

(defvisitor ast.Name [node] node.id)

(when PY34 (defvisitor ast.NameConstant [node] (str node.value)))

;; Ideally we should use repr(node.n) for ast.Num..but this breaks in PY26
;; as repr of floating numbers are represented as an approximation
;; The repr representation of float 3.xx was backported back to 2.7
(defvisitor ast.Num [node] (str node.n))

(defvisitor ast.Str [node] (repr node.s))

(defvisitor ast.alias [node]
  (if node.asname
    (.format "[{0} :as {1}]" node.name node.asname)
    node.name))

(defvisitor ast.Assign [node]
  (.join "\n" (genexpr (t-setv target node.value)
                       [target node.targets])))

(defvisitor ast.AugAssign [node]
  (t-sexp (aug-op node.op) node.target node.value))

(defvisitor ast.Import [node] (t-import node.names))

;; TODO atm relative imports are not supported..add dots for levels
;; once that lands in hy, also this is kind of a hack as
;; from math import floor,sqrt as s has to be translated in hy
;; as "(import [math [floor] [sqrt :as s]])"
;; Also need to figure out not creating spaces when empty item is encounterd
(defvisitor ast.ImportFrom [node]
  (let [[module-imports
         (list (filter (fn [it] (nil? it.asname)) node.names))]
        [alias-imports
         (list (filter (fn [it] (not (nil? it.asname))) node.names))]]
    (when node.module
      (t-import
       (hylist node.module (hylist module-imports)
               alias-imports)))))

(defvisitor ast.Assert [node]
  (if node.msg
    (t-sexp "assert" node.test node.msg)
    (t-sexp "assert" node.test)))

(defvisitor ast.Expr [node]
  (visit node.value))

(defvisitor ast.List [node]
  (hylist node.elts))

(defvisitor ast.Tuple [node]
  (t-sexp "," (list node.elts)))

(defvisitor ast.Dict [node]
  (t-dict (list (.from-iterable chain (zip node.keys node.values)))))
