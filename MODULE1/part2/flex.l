%{
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()
#include "flex.tab.h"
%}
%%
[ \t\n]					;
class					{ return CLASS; }
callout					{ return CALLOUT; }
"true"					{ yylval.bval = 1; return BOOLEAN; }
"false"					{ yylval.bval = 0; return BOOLEAN; }
int						{ return INT_DECLARATION; }
boolean 				{ return BOOLEAN_DECLARATION; }
[a-zA-Z][a-zA-Z0-9]*	{ yylval.sval = strdup(yytext); return ID; }
"!"						{ return '!'; }
"=="|"!="				{ return yytext[0]; }
"*"|"/"|"%"|"+"|"-"		{ return yytext[0]; }
"="|"+="|"-="			{ return ASSIGN_OP; }
"<"|">"|"<="|">="		{ return yytext[0]; }
"&&"|"||"				{ return yytext[0]; }
"("|")"|"{"|"}"|"["|"]"|","|";"		{ return yytext[0]; }
"\""([^\n\"\\]*(\\[.\n])*)*"\"" 			{ yylval.sval = strdup(yytext); return STRING; }
"\""('[.|\n]')"\""				{ yylval.cval = atoi(yytext); return CHARACTER; }
[0-9]+					{ yylval.ival = atoi(yytext); return INT; }
0x[0-9a-fA-F]+ 			{ yylval.ival = atoi(yytext); return INT; }
%%