(import ast
        [hash.codegen [visit]])

(defn test-assign []
  (assert (= "(setv a 10)" (visit (ast.parse "a=10"))))
  (assert (= "(+= a 10)" (visit (ast.parse "a+=10")))))
