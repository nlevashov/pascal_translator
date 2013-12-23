%{
    #include <stdio.h>
    #include "classes.h"
%}

%option noyywrap

%%

"{"(\\.|[^"}"])*"}"     /* comment */
[ \t\n]                 /* whitespace */

"program"               { return T_PROGRAM; }
"begin"                 { return T_BEGIN; }
"end"                   { return T_END; }
"var"                   { return T_VAR; }
"integer"               { return T_INTEGER; }

"if"                    { return T_IF; }
"then"                  { return T_THEN; }
"else"                  { return T_ELSE; }
"while"                 { return T_WHILE; }
"do"                    { return T_DO; }

"not"                   { return T_NOT; }
"or"                    { return T_OR; }
"and"                   { return T_AND; }

"write"                 { return T_WRITE; }

";"                     { return T_SEMICOLON; }
":"                     { return T_COLON; }
":="                    { return T_ASSIGN; }
"+"                     { return T_PLUS; }
"-"                     { return T_MINUS; }
"*"                     { return T_MULTIPLICATION; }
"/"                     { return T_DIVISION; }
"div"                   { return T_DIV; }
"mod"                   { return T_MOD; }
"("                     { return T_BRACKET_OPEN; }
")"                     { return T_BRACKET_CLOSE; }
"="                     { return T_EQUAL; }
"<>"                    { return T_NONEQUAL; }
">"                     { return T_GREATER; }
">="                    { return T_GREATER_OR_EQUAL; }
"<"                     { return T_LESS; }
"<="                    { return T_LESS_OR_EQUAL; }
"."                     { return T_DOT; }
","                     { return T_COMMA; }

[0-9]+                  { yylval.number = atoi(yytext); return T_NUMBER; }
[a-zA-Z_][a-zA-Z_0-9]*  { strcpy(yylval.variable_name, yytext); return T_VARIABLE; }

.                       { fprintf(stderr, "Unknown token: %s\n", yytext); exit(EXIT_FAILURE); }

%%
