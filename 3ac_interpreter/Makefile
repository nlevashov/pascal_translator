BISON=bison
FLEX=flex
CXX=g++

all: 3ac

3ac_syntax.tab.c 3ac_syntax.tab.h: 3ac_syntax.y
	$(BISON) -d $<

lex.yy.c: 3ac_lex.l
	$(FLEX) $<

3ac: lex.yy.c 3ac_syntax.tab.c run.cpp
	$(CXX) $^ -o $@

clean:
	rm -f lex.yy.c 3ac_syntax.tab.c 3ac_syntax.tab.h 3ac
