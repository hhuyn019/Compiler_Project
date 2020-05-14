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
		{printf("function -> FUNCTION IDENT %s SEMICOLON 
		BEGINPARAMS multi_declaration ENDPARAMS 
		BEGINLOCALS multi_declaration ENDLOCALS 
		BEGINBODY multi_statement ENDBODY\n", $2);}
		;

declaration:	multi_id COLON INTEGER {printf("declaration -> multi_id COLON INTEGER\n");}
		| multi_id COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
		{printf("declaration -> multi_id COLON ARRAY L_SQUARE_BRACKET NUMBER %d
		R_SQUARE_BRACKET OF INTEGER\n", $5);}
		;

statement:	var ASSIGN exp {printf("statement -> var ASSIGN exp\n");}
		| IF bool_exp THEN multi_statement ENDIF 
		{printf("statement -> IF bool_exp THEN multi_statement ENDIF\n");}
		| IF bool_exp THEN

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
