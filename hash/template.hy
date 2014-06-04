(defmacro t-sexp [fn &rest body]
  `(+ "("  ~fn " " (.join " " (list (map visit [~@body]))) ")"))

(defmacro t-dict [&rest body]
  `(+ "{"  (.join " " (list (map visit [~@body]))) "}"))

(defmacro t-setv [&rest body]
  `(t-sexp "setv" ~@body))

(defmacro t-import [&rest body]
  `(t-sexp "import" ~@body))

(defmacro hylist [&rest items]
  `(let [[l (list (map visit [~@items]))]]
     (unless (or (empty? l) (= l ""))
       (+ "[" (.join " " l) "]"))))
