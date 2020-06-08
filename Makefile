# Makefile

all:
	flex mini_l.lex
	gcc lex.yy.c -lfl -o lexer

mac:
	flex mini_l.lex
	gcc lex.yy.c -ll -o lexer

test:	all
	cat test.txt | ./lexer

test_mac:	mac
	cat test.txt | ./lexer

clean:
	rm -f lex.yy.c parser.tab.* parser.output *.o parser location.hh position.hh stack.hh 
	
parse: mini_l.lex mini_l.y
	bison -v -d --file-prefix=y mini_l.y
	flex mini_l.lex
	gcc -o parser y.tab.c lex.yy.c -ll

parser: mini_l.lex mini_l.yy
	bison -v -d --file-prefix=parser mini_l.yy
	flex mini_l.lex
	g++ -std=c++11 -o parser parser.tab.cc lex.yy.c -lfl


