(defmacro t!sexp [fn &rest body]
  `(+ "("  ~fn " " (.join " " [~@body]) ")"))

(defmacro t!setv [&rest body]
  `(t!sexp "setv" ~@body))
