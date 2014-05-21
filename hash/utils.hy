(import [singledispatch [singledispatch]])

(with-decorator singledispatch
  (defn visit [ast-node]
    (raise (NotImplementedError
            (.format  "No handler implemented for type {0}"
                      (. ast-node --class-- --name--))))))

(defmacro visitor [klass args &rest body]
  "A bit gross that this macro hardcodes visit"
  `(with-decorator
     (.register visit ~klass)
     (fn [~args] ~@body)))
