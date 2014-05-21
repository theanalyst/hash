(import [singledispatch [singledispatch]])

(with-decorator singledispatch
  (defn visit [ast-node]
    (raise (NotImplementedError
            (.format  "No handler implemented for type {0}"
                      (. ast-node --class-- --name--))))))

;; A bit gross, we hardcode this macro to register all visit types
(defmacro visitor [klass args &rest body]
  `(with-decorator
     (.register visit ~klass)
     (fn [~args] ~@body)))

(def *ops*
  {"Add" "+"
   "Mult" "*"
   "Sub"  "-"
   "Div"  "/"
   "Mod"  "%"
   "FloorDiv" "//"
   "Pow" "**"
   "LShift" "<<"
   "RShift" ">>"
   "BitAnd" "&"
   "BitOr" "|"
   "BitXor" "^" })

(defn getop [op]
  (get *ops* op))

(defmacro aug-op [obj]
  `(+ (getop (. ~obj  --class-- --name--)) "="))
