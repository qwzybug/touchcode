%option noyywrap
%option outfile="jsonpath_lex.m" header-file="jsonpath_lex.h"

%top	{
		/* This code goes at the "top" of the generated file. */
		#include "jsonpath.h"

		extern void *ParseAlloc(void *(*mallocProc)(size_t));
		extern void Parse(void *yyp, int yymajor, int yyminor);
		
		extern void *gParser;
		}


INTEGER				-[0-9]+
QUOTED_STRING		'.+'
LPAREN				(
RPAREN				)
LBRACKET			\[
RBRACKET			\]
DOT					\.
COMMA				,
COLON				:
WILCARD				\*

%%

INTEGER				{
					Parse(gParser, INTEGER, yytext);
					}
