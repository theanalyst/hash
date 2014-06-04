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

;; TODO write more assert tests once conditionals are implemented
(defn test-assert []
  (assert (= "(assert True)" (hyc "assert True"))))

(defn test-list []
  (assert (= "[1 2 3]" (hyc "[1,2,3]")))
  (assert (= "[]" (hyc "[]"))))

(defn test-tuple []
  (assert (= "(, 1 2)" (hyc "(1,2)")))
  (assert (= "(, )" (hyc "()"))))

(defn test-dicts []
  (assert (= "{'one' 1 'two' 2}" (hyc "{'one':1,'two':2}")))
  (assert (= "{}" (hyc "{}"))))
