%{
#include <stdio.h>
extern FILE * yyin;
extern int currLine;
extern int currPos;
void yyerror(const char * msg);
 // valid c code
%}

%union{
	char* cVal;
	int iVal;
}

%token <cVal> IDENT
%token <iVal> NUMBER
%token FUNCTION SEMICOLON
%token BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY
%token ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR
%token BEGINLOOP ENDLOOP CONTINUE READ WRITE
%token AND OR NOT TRUE FALSE RETURN
%token SUB ADD MULT DIV MOD
%token EQ NEQ LT GT LTE GTE
%token COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN

%start program 

%%

program: 	/*epsilon*/ {printf("program -> epsilon\n");}
		| program function {printf("program -> program function\n");}
		;

function:	FUNCTION IDENT SEMICOLON 
		BEGINPARAMS multi_declaration ENDPARAMS
		BEGINLOCALS multi_declaration ENDLOCALS
		BEGINBODY multi_statement ENDBODY
		{printf("function -> FUNCTION IDENT %s SEMICOLON BEGINPARAMS multi_declaration ENDPARAMS BEGINLOCALS multi_declaration ENDLOCALS BEGINBODY multi_statement ENDBODY\n", $2);}
		;

declaration:	multi_id COLON INTEGER {printf("declaration -> multi_id COLON INTEGER\n");}
		| multi_id COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
		{printf("declaration -> multi_id COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
		;

statement:	var ASSIGN exp {printf("statement -> var ASSIGN exp\n");}
		| IF bool_exp THEN multi_statement ENDIF 
		{printf("statement -> IF bool_exp THEN multi_statement ENDIF\n");}
		| IF bool_exp THEN multi_statement ELSE multi_statement ENDIF 
		{printf("statement -> IF bool_exp THEN multi_statement ELSE multi_statement ENDIF\n");}
		| WHILE bool_exp BEGINLOOP multi_statement ENDLOOP 
		{printf("statement -> WHILE bool_exp BEGINLOOP multi_statement ENDLOOP\n");}
		| DO BEGINLOOP multi_statement ENDLOOP WHILE bool_exp 
		{printf("statement -> DO BEGINLOOP multi_statement ENDLOOP WHILE bool_exp\n");}
		| FOR var ASSIGN NUMBER SEMICOLON bool_exp SEMICOLON var ASSIGN exp BEGINLOOP multi_statement SEMICOLON ENDLOOP
		{printf("statement -> FOR var ASSIGN NUMBER %d SEMICOLON bool_exp SEMICOLON var ASSIGN exp BEGINLOOP multi_statement SEMICOLON ENDLOOP\n", $4);}
		| READ multi_var {printf("statement -> READ multi_var\n");}
		| WRITE multi_var {printf("statement -> WRITE multi_var\n");}
		| CONTINUE {printf("statement -> CONTINUE\n");}
		| RETURN exp {printf("statement -> RETURN exp\n");}
		;

bool_exp:	relation_and_exp {printf("bool_exp -> relation_and_exp\n");}
		| bool_exp OR relation_and_exp {printf("bool_exp -> bool_exp OR relation_and_exp\n");}
		;

relation_and_exp:	relation_exp {printf("relation_and_exp -> relation_exp\n");}
			| relation_and_exp AND relation_exp {printf("relation_and_exp -> relation_and_exp AND relation_exp\n");}
			;

relation_exp:	exp comp exp {printf("relation_exp -> exp comp exp\n");}
		| TRUE {printf("relation_exp -> TRUE\n");}
		| FALSE {printf("relation_exp -> FALSE\n");}
		| L_PAREN bool_exp R_PAREN {printf("relation_exp -> L_PAREN bool_exp R_PAREN\n");}
		| NOT exp comp exp {printf("relation_exp -> NOT exp comp exp\n");}
		| NOT TRUE {printf("relation_exp -> NOT TRUE\n");}
		| NOT FALSE {printf("relation_exp -> NOT FALSE\n");}
		| NOT L_PAREN bool_exp R_PAREN {printf("relation_exp -> NOT L_PAREN bool_exp R_PAREN\n");}
		;

comp:	EQ {printf("comp -> EQ\n");}
	| NEQ {printf("comp -> NEQ\n");}
	| LT {printf("comp -> LT\n");}
	| GT {printf("comp -> GT\n");}
	| LTE {printf("comp -> LTE\n");}
	| GTE {printf("comp -> GTE\n");}
	;

exp:	mult_exp {printf("exp -> mult_exp\n");}
	| exp ADD mult_exp {printf("exp -> exp ADD mult_exp\n");}
	| exp SUB mult_exp {printf("exp -> exp SUB mult_exp\n");}
	;

mult_exp:	term {printf("mult_exp -> term\n");}
		| mult_exp MULT term {printf("mult_exp -> mult_exp MULT term\n");}
		| mult_exp DIV term {printf("mult_exp -> mult_exp DIV term\n");}
		| mult_exp MOD term {printf("mult_exp -> mult_exp MOD term\n");}
		;

term:	var {printf("term -> var\n");}
	| SUB var {printf("term -> SUB var\n");}
	| NUMBER {printf("term -> NUMBER %d\n", $1);}
	| SUB NUMBER {printf("term -> SUB NUMBER %d\n", $2);}
	| L_PAREN exp R_PAREN {printf("term -> L_PAREN exp R_PAREN\n");}
	| SUB L_PAREN exp R_PAREN {printf("term -> SUB L_PAREN exp R_PAREN\n");}
	| IDENT L_PAREN multi_exp R_PAREN {printf("term -> IDENT L_PAREN multi_exp R_PAREN\n");}
	| IDENT L_PAREN R_PAREN {printf("term -> IDENT L_PAREN R_PAREN\n");}
	;

var:	IDENT {printf("var -> IDENT\n");}
	| IDENT L_SQUARE_BRACKET exp R_SQUARE_BRACKET 
	{printf("var -> IDENT L_SQUARE_BRACKET exp R_SQUARE_BRACKET\n");}
	| IDENT L_SQUARE_BRACKET exp R_SQUARE_BRACKET L_SQUARE_BRACKET exp R_SQUARE_BRACKET
	{printf("var -> IDENT L_SQUARE_BRACKET exp R_SQUARE_BRACKET L_SQUARE_BRACKET exp R_SQUARE_BRACKET\n");}
	;

%%

int main(int argc, char ** argv)
{
	if(argc >= 2)
	{
		yyin = fopen(argv[1], "r");
		if(yyin == NULL)
		{
			yyin = stdin;
		}
	}
	else
	{
		yyin = stdin;
	}

	yyparse(); // calls yylex()

	return 1;
}

void yyerror(const char * msg) {
	printf("Error in line %d: %s\n", currLine, msg);
}
