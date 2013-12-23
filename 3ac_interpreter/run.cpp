#include <stdlib.h>
#include <stdio.h>
#include "3ac.h"

int IP; /* instruction pointer */
int IP_change_flag = 0;
map<string,int> Tab; /* nametable */
vector<Stmt*> TheProgram;

int ExprVar::eval()
{
	if (Tab.find(name) != Tab.end()) {
		return Tab.find(name)->second;
	} else {
		cerr << "'" << name << "' undefined" << endl;
		exit(1);
	}
}

void StmtArith::run()
{
	int r;
	switch(op) {
		case ADD: r = (arg1->eval() + arg2->eval()); break;
		case SUB: r = (arg1->eval() - arg2->eval()); break;
		case MUL: r = (arg1->eval() * arg2->eval()); break;
		case DIV:
			  if (arg2->eval() == 0) {
				  cerr << "Division by zero" << endl;
				  exit(1);
			  } else {
				  r = (arg1->eval() / arg2->eval());
			  }
			  break;
	}

	Tab[res] = r;
}

void StmtAssign::run()
{
	Tab[dest] = src->eval();
}

void StmtJump::run()
{
	IP_change_flag = 1;
	IP = N;
}

void StmtCondJump::run()
{
	int x, y;
	x = arg1->eval(); y = arg2->eval();
	IP_change_flag = 1;
	if (x < y) IP = Nl;
	else if (x == y) IP = Ne;
	else IP = Ng;
}

void StmtOutput::run()
{
	cout << arg->eval() << endl;
}

extern FILE* yyin;
int yyparse();

int main(int argc, char **argv)
{
        FILE *handle;
        if (argc != 2) {
                cerr << "Usage: " << argv[0] << " program\n";
                exit(1);
        }
        if (!(handle = fopen(argv[1], "r"))) {
                cerr << "Error: cannot open file\n";
                exit(1);
        }
        yyin = handle;
        yyparse();

        IP = 0; IP_change_flag = 0;

	while(1) {
	        TheProgram[IP]->run();
		if (!IP_change_flag) {
			IP++;
			if (IP == TheProgram.size()) {
				return 0;
			}
		} else {
			if (IP >= TheProgram.size()) {
				cout << "Out of program. Exiting" << endl;
				return 0;
			}
			IP_change_flag = 0;
		}
	}
}

void yyerror(string s)
{
        cerr << "Parser error: " << s << "\n";
        exit(1);
}

