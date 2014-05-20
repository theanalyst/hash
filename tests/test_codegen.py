import unittest
import ast
 
from hash.codegen import HyCodeGenerator
 
class TestHyCodeGenerator(unittest.TestCase):
 
    def setUp(self):
        self.codegen = HyCodeGenerator()
        
    def test_Assign(self):
        self.codegen.write(ast.parse("a=10"))
        self.assertEqual(self.codegen.render_source(),
                        "(setv a 10)\n")
 
    def test_AugAssign(self):
        self.codegen.write(ast.parse("a+=10"))
        self.assertEqual(self.codegen.render_source(),
                        "(+= a 10)\n")
 
    def test_Import(self):
        py = '''import foo\nimport foo, bar'''
        hy = '''(import foo)\n(import foo bar)\n'''
        self.codegen.write(ast.parse(py))
        self.assertEqual(self.codegen.render_source(), hy)
