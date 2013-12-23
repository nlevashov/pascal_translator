%{
#include <stdlib.h> /* for atoi() */
#include <string.h> /* for strcpy() and exit() */
#include <stdio.h> /* for printf() */
#include "3ac.h"
%}

IDENT [A-Za-z][A-Za-z0-9]*
NUMERAL ([1-9][0-9]*)|0

%option noyywrap

%%

"let" { return LET; }
"mov" { return MOV; }
"add" { return ADD; }
"sub" { return SUB; }
"mul" { return MUL; }
"div" { return DIV; }
"jmp" { return JMP; }
"cmp" { return CMP; }
"out" { return OUT; }
{IDENT} { strcpy(yylval.name, yytext);  return VARIABLE; }
{NUMERAL} { yylval.value = atoi(yytext); return CONSTANT; }
"\n" { return SEPARATOR; }
" " {}

