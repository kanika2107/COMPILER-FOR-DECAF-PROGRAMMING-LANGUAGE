%{
#include <cstdio>
#include <iostream>
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
 
void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	int ival;
	bool bval;
	char cval;
	char *sval;
}

// define the constant-string tokens:
%token CLASS CALLOUT INT_DECLARATION BOOLEAN_DECLARATION ID ASSIGN_OP

// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token <ival> INT
%token <bval> BOOLEAN
%token <sval> STRING
%token <cval> CHARACTER

%type<sval> ID

%%

// the first rule defined is the highest-level rule, which in our
// case is just the concept of a whole "snazzle file":
program:
	CLASS ID '{' field_block statement_block '}' { cout << "PROGRAM ENCOUNTERED" << endl; }
	;
field_block:
	field_block field_decl
        | empty
	;

statement_block:
	 statement_decl statement_block
	| empty
	;
field_decl:
	type parameters ';'
	;
parameters:
	parameters ',' parameter
	| parameter
	;
parameter:	
	ID  {cout << "ID=" << $1 << endl;}
	| ID '[' INT ']' {cout << "ID=" << $1 << " " << "SIZE=" << $3 << endl;}
	;
type:
	INT_DECLARATION {cout << "INT DECLARATION ENCOUNTERED. ";}
	| BOOLEAN_DECLARATION {cout << "BOOLEAN DECLARATION ENCOUNTERED. ";}
	;
statement_decl:
	location ASSIGN_OP expr ';' {cout << "ASSIGNMENT OPERATION ENCOUNTERED" << endl;}
	| CALLOUT '(' STRING ',' args ')' ';' {cout << "CALLOUT TO " << $3 << " ENCOUNTERED" << endl;}
	;

args:
	arg
	| args ',' arg
	;
arg:
	expr
	| STRING
	| '&' ID
	;
location: 
	ID {cout << "LOCATION ENCOUNTERED=" << $1 << endl;}
	| ID '[' expr']' {cout << "LOCATION ENCOUNTERED=" << $1 << endl;}
	;
literal:
	INT {cout << "INT ENCOUNTERED=" << $1 << endl;}
	| CHARACTER {cout << "CHARACTER ENCOUNTERED=" << $1 << endl;}
	| BOOLEAN {cout << "BOOLEAN ENCOUNTERED=" << $1 << endl;}
	| STRING {cout << "STRING ENCOUNTERED=" << $1 << endl;}
	;
expr:
 	expr "&&" expr2
	| expr "||" expr2
	| expr2
	;
expr2:
	expr2 "==" expr1 {cout << "EQUAL TO ENCOUNTERED" << endl;}
	| expr2 "!=" expr1 {cout << "NOT EQUAL TO ENCOUNTERED" << endl;}
	| expr1
	;
expr1:
	expr1 '>' expr3 {cout << "GREATER THAN ENCOUNTERED" << endl;}
	| expr1 '<' expr3 {cout << "LESS THAN ENCOUNTERED" << endl;}
	| expr1 ">=" expr3 {cout << "GREATER THAN EQUAL TO ENCOUNTERED" << endl;}
	| expr1 "<=" expr3 {cout << "LESS THAN EQUAL TO ENCOUNTERED" << endl;}
	| expr3
	;
expr3:
	expr3 '+' expr4 {cout << "ADDITION ENCOUNTERED" << endl;}
	| expr3 '-' expr4 {cout << "SUBTRACTION ENCOUNTERED" << endl;}
	| expr4
	;
expr4:
	expr4 '*' expr5 {cout << "MULTIPLICATION ENCOUNTERED" << endl;}
	| expr4 '/' expr5 {cout << "DIVISION ENCOUNTERED" << endl;}
	| expr4 '%' expr5 {cout << "MOD ENCOUNTERED" << endl;}
	| expr5
	;
expr5: 
	'!' expr5
	| expr6
	;
expr6:
	'(' expr ')'
	| expr7
	;
expr7:
	literal
	| location
	;
empty:

%%

int main(int, char**) {
	// open a file handle to a particular file:
	FILE *myfile = fopen("test_program", "r");
	// make sure it's valid:
	if (!myfile) {
		cout << "I can't open test_program!" << endl;
		return -1;
	}
	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
	
}

void yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << endl;
	// might as well halt now:
	exit(-1);
}
