make:
	bison -d syntax.y
	flex lex.l
	g++ -std=c++11 lex.yy.c syntax.tab.c main.cpp -o pasto3ac

clean:
	rm -f lex.yy.c syntax.tab.c syntax.tab.h pasto3ac

