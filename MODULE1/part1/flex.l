%{
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()
%}
%%
[ \t\n]          ;
class             { cout << "CLASS" << endl; }
callout           { cout << "CALLOUT" <<  endl; }
boolean           { cout << "BOOLEAN_DECLARATION" << endl; }
"true" | "false" {cout << "BOOLEAN: " << yytext << endl;}
int              {cout << "INT_DECLARATION" << endl;}
[a-zA-Z][a-zA-Z0-9]*  {cout << "ID: " << yytext << endl;}
[0-9]+				{cout << "INT: " << yytext << endl;}
0x[a-fA-F0-9]+	{cout << "INT: " << yytext << endl;}
"\""('[. | \n]')"\""          {cout << "CHARACTER: " << yytext << endl;}
\"(\\.|[^"])*\"			{cout << "STRING: " << yytext << endl;}
[\(\)\{\};,\[\]]    ;
"+" | "-" | "*" | "/" | "%" | "||" | "&&" | "==" | "!=" | "<" | ">" | ">=" | "<=" | "+=" | "-=" | "!"    ;
.                ;
%%
int main(int, char**) {
	
	// open a file handle to a particular file:
	FILE *myfile = fopen("test_program", "r");
	// make sure it's valid:
	if (!myfile) {
		cout << "I can't open test_program!" << endl;
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// lex through the input:
	yylex();
}
