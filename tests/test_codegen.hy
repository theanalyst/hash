(import ast
        [hash.codegen [visit]])

(defn test-assign []
  (assert (= "(setv a 10)" (visit (ast.parse "a=10"))))
  (assert (= "(+= a 10)" (visit (ast.parse "a+=10")))))

(defn test-imports []
  (assert (= "(import foo)" (visit (ast.parse "import foo"))))
  (assert (= "(import [foo :as bar])" (visit (ast.parse "import foo as bar")))))