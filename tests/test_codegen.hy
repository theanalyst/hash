(import ast
        [hash.codegen [visit]])

(defn test-setv []
  (assert (= "(setv a 10)" (visit (ast.parse "a=10")))))
