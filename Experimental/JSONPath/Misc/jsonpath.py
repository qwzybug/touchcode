#!/usr/bin/python

import json
from pyparsing import *

theJSON = '''{ "store": {
    "book": [
      { "category": "reference",
        "author": "Nigel Rees",
        "title": "Sayings of the Century",
        "price": 8.95
      },
      { "category": "fiction",
        "author": "Evelyn Waugh",
        "title": "Sword of Honour",
        "price": 12.99
      },
      { "category": "fiction",
        "author": "Herman Melville",
        "title": "Moby Dick",
        "isbn": "0-553-21311-3",
        "price": 8.99
      },
      { "category": "fiction",
        "author": "J. R. R. Tolkien",
        "title": "The Lord of the Rings",
        "isbn": "0-395-19395-8",
        "price": 22.99
      }
    ],
    "bicycle": {
      "color": "red",
      "price": 19.95
    }
  }
}'''

def join(*args):
	return ''.join(args[2][0])

theDictionary =  json.loads(theJSON)

dblQuotedString.setParseAction(removeQuotes)

LPAREN = Suppress("(")
RPAREN = Suppress(")")

LBRACKET = Suppress("[")
RBRACKET = Suppress("]")

DOT = Suppress('.')
COMMA = Suppress(',')
COMMA_ = Literal(',')
COLON = Suppress(':')

INTEGER = Regex(r'-?[0-9]+')

WILDCARD_OP = Literal('*')

SUBSCRIPT = INTEGER
SUBSCRIPT_LIST = Group(INTEGER + COMMA_ + INTEGER + ZeroOrMore(COMMA_ + INTEGER)).setResultsName('LIST').setParseAction(join)
SLICE = Group(Optional(INTEGER) + COLON + Optional(INTEGER) + Optional(COLON + Optional(INTEGER))).setResultsName('SLICE')
SELECTION = Group(LBRACKET + ( SUBSCRIPT_LIST | SLICE | SUBSCRIPT | WILDCARD_OP ) + RBRACKET).setResultsName('SELECTOR')

ROOT_OP = Literal('$').setResultsName('PATH_COMPONENT')
RECURSIVE_OP = Literal('..').setResultsName('PATH_COMPONENT')

DOT_PATH_COMPONENT = Group(Word(alphas) + Optional(SELECTION)).setResultsName('PATH_COMPONENT')
BRACKET_PATH_COMPONENT = Group((LBRACKET + quotedString + RBRACKET) + Optional(SELECTION)).setResultsName('PATH_COMPONENT')

PATH_COMPONENT = DOT_PATH_COMPONENT | BRACKET_PATH_COMPONENT | WILDCARD_OP
RELATIVE_PATH_OP = (DOT + DOT_PATH_COMPONENT) | BRACKET_PATH_COMPONENT | WILDCARD_OP

PATH = ROOT_OP + OneOrMore(RELATIVE_PATH_OP | (RECURSIVE_OP + PATH_COMPONENT))

parser = PATH

# print parser.parseString("$.book")
# print parser.parseString("$..book[*]")
# print parser.parseString("$..book[2]")
print parser.parseString("$..book[0,1]").asXML()
# print parser.parseString("$..book[0:1]")
# print parser.parseString("$..book[:1]")
# print parser.parseString('$.store..price')
# print parser.parseString("$.store.*")
# print parser.parseString("$.store.book[*].author")
# print parser.parseString("$['store']['book'][*]['author']")
