%{
#include "interpreter.tab.h"

//extern YYSTYPE yylval;
//"r"[0-9]+ {yylval.nb = (int) atof(yytext+strlen("r")); return tR;}
%}


%option yylineno

%%
"AFC" { strcpy(yylval.str,yytext) ; return tAFC; }
"STORE" {strcpy(yylval.str,yytext) ;return tSTORE;}
"LOAD" {strcpy(yylval.str,yytext) ;return tLOAD;}
"ADD" {strcpy(yylval.str,yytext) ;return tADD;}
"SUB" {strcpy(yylval.str,yytext); return tSUB;}
"MUL" {strcpy(yylval.str,yytext); return tMUL;}
"DIV" {strcpy(yylval.str,yytext) ;return tDIV;}
"JMPC" {strcpy(yylval.str,yytext) ;return tJMPC;}
"JMP" {strcpy(yylval.str,yytext) ;return tJMP;}
"EQQ" {strcpy(yylval.str,yytext) ;return tEQQ;}
"INF" {strcpy(yylval.str,yytext) ;return tINF;}
"INFE" {strcpy(yylval.str,yytext) ;return tINFE;}
"SUP" {strcpy(yylval.str,yytext) ;return tSUP;}
"SUPE" {strcpy(yylval.str,yytext) ;return tSUPE;}
"DIFF" {strcpy(yylval.str,yytext) ;return tDIFF;}
[0-9]+ { yylval.nb = (int) atof(yytext); return tENT ; }

[ \t\n]		{}

