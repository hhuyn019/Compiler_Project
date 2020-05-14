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
		| program function {printf("program -> program function\n");};

function:	FUNCTION IDENT SEMICOLON 

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
