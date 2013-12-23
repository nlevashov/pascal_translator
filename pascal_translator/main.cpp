#include <stdlib.h>
#include <stdio.h>
#include "classes.h"

extern FILE* yyin;
int yyparse();

Variables variables;

string get_str(int number) {
    char buf[256];
    sprintf(buf, "%d", number);
    return string(buf);
}

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
}

void yyerror(string s)
{
        cerr << "Parser error: " << s << "\n";
        exit(1);
}
