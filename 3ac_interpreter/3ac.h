#ifndef __HEADER
#define __HEADER

#include <string>
#include <map>
#include <vector>
#include <iostream>

using namespace std;

//extern map<string,int> Tab;

class Expr {
    public:
	virtual int eval() = 0;
};

class ExprConst : public Expr {
    public:
	ExprConst(int val_) : val(val_) { }
	int eval() { return val; }
    
    private:
	int val;
};

class ExprVar : public Expr {
    public:
	ExprVar(char name_[256]) : name(name_) { }
	int eval();

    private:
	string name;
};	

class Stmt {
    public:
	virtual void run() = 0;
};

class StmtArith : public Stmt {
    public:
	StmtArith(int op_, char res_[256], Expr* arg1_, Expr* arg2_) : op(op_), arg1(arg1_), arg2(arg2_),
		res(res_) { }
		
	void run();

    private:
	Expr* arg1;
	Expr* arg2;
	int op;
	string res;
};

class StmtAssign : public Stmt { /* LET & MOV */
    public:
	StmtAssign(char dest_[256], Expr* src_) : dest(dest_), src(src_) { }
	void run();

    private:
	Expr* src;
	string dest;
};
	 
class StmtJump : public Stmt {
    public:
	StmtJump(int N_) : N(N_) { }
	void run(); /* modify global instruction pointer - int IP; check when it is after the last */


    private:
	int N;
};

class StmtCondJump : public Stmt {
    public:
	StmtCondJump(Expr* arg1_, Expr* arg2_, int Nl_, int Ne_, int Ng_) :
		arg1(arg1_), arg2(arg2_), Nl(Nl_), Ne(Ne_), Ng(Ng_) { }

	void run();

    private:
	Expr* arg1;
	Expr* arg2;
	int Nl, Ne, Ng;
}; 

class StmtOutput : public Stmt {
    public:
	StmtOutput(Expr *arg_) : arg(arg_) { }
	void run();

    private:
	Expr* arg;
};

extern vector<Stmt*> TheProgram;

int yylex();
void yyerror(string s);

#include "3ac_syntax.tab.h"
#endif
