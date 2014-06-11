(defmacro hy-sexp [fn &rest body]
  `(+ "("  ~fn " " (.join " " (list (map visit [~@body]))) ")"))

(defmacro hy-dict [&rest body]
  `(+ "{"  (.join " " (list (map visit [~@body]))) "}"))

(defmacro hy-setv [&rest body]
  `(hy-sexp "setv" ~@body))

(defmacro hy-import [&rest body]
  `(hy-sexp "import" ~@body))

(defmacro hy-list [&rest items]
  `(let [[l (list (map visit [~@items]))]]
     (unless (or (empty? l) (= l ""))
       (+ "[" (.join " " l) "]"))))
