import ast
from functools import partial, wraps

DEFAULT_INDENTATION = 2

def enclose(parens,newline=False):

    def decorate(func):
        @wraps(func)
        def wrapper(self,*args,**kwargs):
            self.write(parens[0])
            func(self,*args,**kwargs)
            self.write(parens[1])
            if newline: self.newline() 
        return wrapper
    return decorate

binop = {type(ast.Add()) : "+",
         type(ast.Div()) : "/",
         type(ast.FloorDiv()):"//",
         type(ast.Mult()) : "*",
         type(ast.Sub()):"-",
         type(ast.Mod()): "%",
         type(ast.Pow()): "**",
         type(ast.LShift()):"<<",
         type(ast.RShift()):">>",
         type(ast.BitOr()):"|",
         type(ast.BitXor()):"^",
         type(ast.BitAnd()):"&"}


class HyCodeGenerator(ast.NodeVisitor):

    def __init__(self,indent=DEFAULT_INDENTATION):
        self.result = []
        self._indentation = indent
        self._blocklevel = 0
        
    def write(self, *params):
        for item in params:
            if isinstance(item,ast.AST):
                self.visit(item)
            elif hasattr(item,'__call__'):
                item()
            else:
                self.result.append(item)

    def render_source(self):
        return "".join(self.result)

    def newline(self):
        self.write("\n")

    def generic_list(self, items):
        for idx,item in enumerate(items):
            if idx:
                self.write(" ")
            self.write(item)  # hack, we assume this will call visit instead

    @enclose(parens="()",newline=True)
    def s_expression(self, *items):
        self.generic_list(list(items))

    @enclose(parens="[]")
    def hy_list(self,items):
        self.generic_list(items)

    def visit_Module(self,node):
        for stmt in node.body:
            self.visit(stmt)
        
    def visit_Assign(self,node):
        '''We don't do expressions like a=b=1 yet, so creating multiple
        assignments'''
        for target in node.targets:
            self.s_expression('setv',target,node.value)

    def visit_AugAssign(self, node):
        self.s_expression("%s=" %(binop[type(node.op)]),node.target,node.value)

    def visit_Name(self, node):
        self.write(node.id)

    def visit_Num(self,node):
        self.write(repr(node.n))
