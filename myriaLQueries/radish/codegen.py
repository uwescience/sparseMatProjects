from raco.catalog import FromFileCatalog
import raco.myrial.parser as parser
import raco.myrial.interpreter as interpreter
from raco.backends.radish import GrappaAlgebra
from raco.compile import compile
import raco.algebra as algebra
import sys
import os

import logging
#logging.basicConfig(level=logging.DEBUG)

def print_pretty_plan(plan, indent=0):
    if isinstance(plan, algebra.DoWhile):
        children = plan.children()
        body = children[:-1]
        term = children[-1]

        spc = ' ' * indent
        print '%sDO' % spc
        for op in body:
            print_pretty_plan(op, indent + 4)
        print '%sWHILE' % spc
        print_pretty_plan(term, indent + 4)
    elif isinstance(plan, algebra.Sequence):
        print '%s%s' % (' ' * indent, plan.shortStr())
        for child in plan.children():
            print_pretty_plan(child, indent + 4)
    else:
        print '%s%s' % (' ' * indent, plan)


catalog = FromFileCatalog.load_from_file("../../matrices/catalogs/catalog.py")
_parser = parser.Parser()

query = ""
with open(sys.argv[1], 'r') as f:
    query = f.read()

statement_list = _parser.parse(query)

processor = interpreter.StatementProcessor(catalog, True)
processor.evaluate(statement_list)

# we will add the shuffle into the logical plan
print "LOGICAL"
p = processor.get_logical_plan()
print_pretty_plan(p)
print "PHYSICAL"
#p = processor.get_physical_plan(push_sql=True)
p = processor.get_physical_plan(target_alg=GrappaAlgebra(), groupby_semantics='partition')
print_pretty_plan(p)
print p
with open('grappa_{}.cpp'.format(os.path.splitext(os.path.basename(sys.argv[1]))[0]), 'w') as f:
    f.write(compile(p))
