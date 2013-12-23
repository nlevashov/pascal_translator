%{
#include <stdio.h> /* for printf() */
#include <stdlib.h>
#include "3ac.h"
%}

%union{
	int value;
	char name[256];

	Expr* expr;
	Stmt* stmt;
}

%token LET MOV ADD SUB MUL DIV JMP CMP OUT SEPARATOR
%token <value> CONSTANT
%token <name> VARIABLE

%type <expr> expr
%type <stmt> stmt

%%

program
	: program stmt SEPARATOR { TheProgram.push_back($2); }
	| 
	;

stmt
	: LET VARIABLE CONSTANT { $$ = new StmtAssign($2, new ExprConst($3)); } 
	| MOV expr VARIABLE { $$ = new StmtAssign($3, $2); } /* $2 -> $3 */
	| ADD expr expr VARIABLE { $$ = new StmtArith(ADD, $4, $2, $3); } /* $4 := $2 + $3 */
 	| SUB expr expr VARIABLE { $$ = new StmtArith(SUB, $4, $2, $3); }
	| MUL expr expr VARIABLE { $$ = new StmtArith(MUL, $4, $2, $3); }
	| DIV expr expr VARIABLE { $$ = new StmtArith(DIV, $4, $2, $3); }
	| JMP CONSTANT { $$ = new StmtJump($2); }
	| CMP expr expr CONSTANT CONSTANT CONSTANT { $$ = new StmtCondJump($2, $3, $4, $5, $6); }
	| OUT expr { $$ = new StmtOutput($2); }
	;

expr
	: VARIABLE { $$ = new ExprVar($1); }
	| CONSTANT { $$ = new ExprConst($1); }
	;

				 
	

