%{
#include "classes.h"
%}

%union{
    int number;
    char variable_name[256];

    Var * var;
    Var_list * var_list;
    int sign;
}

%token T_PROGRAM T_BEGIN T_END T_VAR T_INTEGER T_IF T_THEN T_ELSE T_WHILE T_DO T_NOT T_OR T_AND T_WRITE T_SEMICOLON T_COLON T_ASSIGN T_PLUS T_MINUS T_MULTIPLICATION T_DIVISION T_DIV T_MOD T_BRACKET_OPEN T_BRACKET_CLOSE T_EQUAL T_NONEQUAL T_GREATER T_GREATER_OR_EQUAL T_LESS T_LESS_OR_EQUAL T_DOT T_COMMA

%token <number> T_NUMBER 
%token <variable_name> T_VARIABLE

%type <var> compound_statement optional_statements statement_list statement logical_expression logical_term logical_factor comparison expression term factor
%type <var_list> expression_list
%type <sign> sign

%%

program
    : T_PROGRAM T_VARIABLE T_BRACKET_OPEN identifier_list T_BRACKET_CLOSE T_SEMICOLON declarations compound_statement T_DOT { $8->print(); }
    |                                                                                                                       {}
    ;

identifier_list
    : T_VARIABLE                         {}
    | identifier_list T_COMMA T_VARIABLE {}
    ;

declarations
    : declarations T_VAR identifier_list T_COLON T_INTEGER T_SEMICOLON {}
    |                                                                  {}
    ;

compound_statement
    : T_BEGIN optional_statements T_END { $$ = $2; }
    ;

optional_statements
    : statement_list { $$ = $1; }
    |                { $$ = variables.get_new(); }
    ;

statement_list
    : statement_list T_SEMICOLON statement { $$ = variables.get_new($1, $3); }
    | statement                            { $$ = $1; }
    ;

statement
    : compound_statement                                        { $$ = $1; }
    | T_IF logical_expression T_THEN statement T_ELSE statement { $4->add("jmp", $6->length() + 2); $2->set_shift_if_true(1); $2->set_shift_if_false($4->length() + 1); $$ = variables.get_new($2, $4, $6); }
    | T_WHILE logical_expression T_DO statement                 { $4->add("jmp", -($4->length())); $2->set_shift_if_true(1); $2->set_shift_if_false($4->length() + 1); $$ = variables.get_new($2, $4); }
    | T_WRITE T_BRACKET_OPEN expression_list T_BRACKET_CLOSE    { $$ = $3->get_list_for_printing(); }
    | T_VARIABLE T_ASSIGN expression                            { $3->add("mov " + $3->name() + " " + $1); $$ = $3; }
    ;

logical_expression
    : logical_term                         { $$ = $1; }
    | logical_expression T_OR logical_term { $1->set_shift_if_false(1); $$ = variables.get_new($1, $3); }
    ;

logical_term
    : logical_factor                    { $$ = $1; }
    | logical_term T_AND logical_factor { $1->set_shift_if_true(1); $$ = variables.get_new($1, $3); }
    ;

logical_factor
    : comparison                                        { $$ = $1; }
    | T_BRACKET_OPEN logical_expression T_BRACKET_CLOSE { $$ = $2; }
    | T_NOT logical_factor                              { $2->reverse(); $$ = $2; }
    ;

comparison
    : expression T_EQUAL            expression { Var * v = variables.get_new($1, $3); v->add("cmp " + $1->name() + " " + $3->name(), 0, 1, 0); $$ = v; }
    | expression T_NONEQUAL         expression { Var * v = variables.get_new($1, $3); v->add("cmp " + $1->name() + " " + $3->name(), 1, 0, 1); $$ = v; }
    | expression T_GREATER          expression { Var * v = variables.get_new($1, $3); v->add("cmp " + $1->name() + " " + $3->name(), 0, 0, 1); $$ = v; }
    | expression T_GREATER_OR_EQUAL expression { Var * v = variables.get_new($1, $3); v->add("cmp " + $1->name() + " " + $3->name(), 0, 1, 1); $$ = v; }
    | expression T_LESS             expression { Var * v = variables.get_new($1, $3); v->add("cmp " + $1->name() + " " + $3->name(), 1, 0, 0); $$ = v; }
    | expression T_LESS_OR_EQUAL    expression { Var * v = variables.get_new($1, $3); v->add("cmp " + $1->name() + " " + $3->name(), 1, 1, 0); $$ = v; }
    ;

expression_list
    : expression_list T_COMMA expression { $1->add($3); $$ = $1; }
    | expression                         { Var_list * args = new Var_list; args->add($1); $$ = args; }
    ;

expression
    : term                    { $$ = $1; }
    | sign term               { Var * v = variables.get_new($2);     v->add("mul " + get_str($1) + " " + $2->name() + " " + v->name()); $$ = v; }
    | expression T_PLUS  term { Var * v = variables.get_new($1, $3); v->add("add " + $1->name()  + " " + $3->name() + " " + v->name()); $$ = v; }
    | expression T_MINUS term { Var * v = variables.get_new($1, $3); v->add("sub " + $1->name()  + " " + $3->name() + " " + v->name()); $$ = v; }
    ;

term
    : factor                       { $$ = $1; }
    | term T_MULTIPLICATION factor { Var * v  = variables.get_new($1, $3);  v->add("mul " + $1->name() + " " + $3->name() + " " +  v->name()); $$ = v;  }
    | term T_DIVISION       factor { Var * v  = variables.get_new($1, $3);  v->add("div " + $1->name() + " " + $3->name() + " " +  v->name()); $$ = v;  }
    | term T_DIV            factor { Var * v  = variables.get_new($1, $3);  v->add("div " + $1->name() + " " + $3->name() + " " +  v->name()); $$ = v;  }
    | term T_MOD            factor { Var * v1 = variables.get_new($1, $3); v1->add("div " + $1->name() + " " + $3->name() + " " + v1->name());
                                     Var * v2 = variables.get_new(v1);     v2->add("mul " + v1->name() + " " + $3->name() + " " + v2->name());
                                     Var * v3 = variables.get_new(v2);     v3->add("sub " + $1->name() + " " + v2->name() + " " + v3->name()); $$ = v3; }
    ;

factor
    : T_NUMBER                                  { Var * v = variables.get_new(); v->add("let " + v->name() + " " + get_str($1)); $$ = v; }
    | T_BRACKET_OPEN expression T_BRACKET_CLOSE { $$ = $2; }
    | T_VARIABLE                                { $$ = new Var($1); }
    ;

sign
    : T_PLUS  { $$ = 1; }
    | T_MINUS { $$ = -1; }
    ;
