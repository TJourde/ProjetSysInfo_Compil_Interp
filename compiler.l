%{
#include "compiler.tab.h"
%}

extern YYSTYPE yylval;

%option yylineno

%%

"main" 		return tMAIN ;

"(" return tBEGPAR ;
")" return tENDPAR ;

"{" return tBEGACC ;
"}" return tENDACC ;


"printf" return tPRINT ;

"if" return tIF ;

"else" return tELSE;

const return tCONST ;
int return tINT ;
[a-z][a-zA-Z0-9_]* { strcpy(yylval.str,yytext) ; return tVAR ; }
[0-9]+(e[0-9]+)? { yylval.nb = (int) atof(yytext); return tENT ; }

"//" return tCOM ;


"+" return tADD ;
"-" return tSUB ;
"*" return tMUL ;
"/" return tDIV ;
"=" return tEQ ;
"==" return tEQQ ;
"<" return tINF ;
">" return tSUP ;
"<=" return tINFEQQ ;
">=" return tSUPEQQ ;
"!=" return tDIFF ;


";" return tPVIR ;

"," return tVIR ;



[ \t\n]	{}

"!!!!" printf("Bravo !\n");

. return tWARNING ;
