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
	rm -f lex.yy.c lexer y.tab.* y.output *.o parser
	
parse: mini_l.lex mini_l.y
	bison -v -d --file-prefix=y mini_l.y
	flex mini_l.lex
	gcc -o parser y.tab.c lex.yy.c -ll

parser: mini_l.lex mini_l.y
	bison -v -d --file-prefix=y mini_l.y
	flex mini_l.lex
	gcc -o parser y.tab.c lex.yy.c -lfl

