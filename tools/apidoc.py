import re

__doc__ = """
Extends the Texto parser to support JavaDoc/JSDoc style documentation tags
in the form of `@tag value`
"""
RE_DOCTAG  = "@(\w+)\s+[\w\d.-_]+"
RE_PARAM   = "@param\s+({.+})?"
RE_RETURNS = "@returns\s+({.+})?"

def on_texto_parser(parser):
	return parser

# EOF
