(import ast
        [hash.codegen [visit]])

(defmacro hyc [e] `(visit (ast.parse ~e)))

(defn test-assign []
  (assert (= "(setv a 10)" (hyc "a=10")))
  (assert (= "(+= a 10)" (hyc"a+=10"))))

(defn test-imports []
  (assert (= "(import foo)" (hyc "import foo")))
  (assert (= "(import [foo :as bar])" (hyc "import foo as bar")))
  (assert (= "(import [math [sqrt] [floor :as f]])"
             (hyc "from math import sqrt, floor as f"))))
