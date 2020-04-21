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
	rm -f lex.yy.c lexer