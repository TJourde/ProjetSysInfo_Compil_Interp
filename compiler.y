%{
#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "ts.h"
#include "memoire.h"
#define YYDEBUG 0
int yylex();
int yyerror(const char *s);

int is_const = 0;
int depth=0;

//numero groupe 27

struct Table table;
   FILE * fp;
struct MemoireInstructions memoire;
%}

%union {char str[80]; int nb;}

%token tMAIN tINT tBEGPAR tENDPAR tBEGACC tENDACC tCONST tCOM tADD tSUB tMUL tDIV tEQ tVIR tPVIR tPRINT tENT tWARNING tVAR tIF tELSE tEQQ tINF
 tSUP tINFEQQ tSUPEQQ tDIFF 

%type <str> tVAR


%left tADD tSUB
%left tMUL tDIV

%%

Program :
	| Main Program
	| Fonction Program
	| Constante Program
	;

Constante : 
	tCONST { is_const = 1; } Decl { is_const = 0; } 
	;


Decl :
	tINT DeclVar Decls
	| tINT AffectationVar
	;

DeclVar : tVAR 
		{
			//if(is_const==0) {
				ts_add_symbole(&table,$<str>1,depth);
			//} else {
			//	ts_add_symbole(&table,$<str>1,depth);
			//} 
		}
		;

Decls:
	tPVIR
	|tVIR DeclVar Decls
;


Main : 	
	tMAIN tBEGPAR tENDPAR tBEGACC {depth+=1;} Body 	{depth-=1;} tENDACC 
;
Fonction : 	
	 tVAR tBEGPAR Arg tENDPAR tBEGACC {depth+=1;} Body {depth-=1;} tENDACC 	
	| tINT tVAR tBEGPAR Arg tENDPAR tBEGACC {depth+=1;} Body tENDACC {depth-=1;}
;

Invocation : tVAR tBEGPAR Argp tENDPAR tPVIR
;


Printf : tPRINT tBEGPAR Expression tENDPAR tPVIR {while(ts_last_tmp(&table,depth) != -1){} } 
;

If : 	
	tIF tBEGPAR Cond tENDPAR
  		{
			mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth)); 
			mem_add(&memoire, "JMPC",-1,1);
			$<nb>1 = memoire.size - 1;
		}

	Instruction
		{
			mem_add(&memoire, "JMP",-1,1);
			memoire.data[$<nb>1].p0=memoire.size;
			$<nb>1 = memoire.size - 1;
		}
	Else
		{
			memoire.data[$<nb>1].p0=memoire.size;
		};

Else :
	| tELSE Instruction
;

Cond: Expression tEQQ Expression 
	{
	 mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"EQQ",0,1);
	 mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);				
	}
	|Expression tSUP Expression 
	{
	 mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"SUP",0,1);
	 mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);				
	}

	|Expression tSUPEQQ Expression 
	{
	 mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"SUPE",0,1);
	 mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);				
	}

	| Expression tINF Expression 
	{
	 mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"INF",0,1);
	 mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);				
	}

	| Expression tINFEQQ Expression
	{
	 mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"INFE",0,1);
	 mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);				
	}

	| Expression tDIFF Expression
	{
	 mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
	 mem_add(&memoire,"DIFF",0,1);
	 mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);				
	} 

;


Instruction : tBEGACC {depth+=1;} Body 
			tENDACC 
;

Arg:
	
	| tINT tVAR Args
;

Args:
	
	| tVIR tINT tVAR Args
;

Argp:
	
	| tVAR Argps 
;

Argps :
	
	| tVIR tVAR Argps
;

Affectation: tVAR Affec {
							mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
							mem_add(&memoire,"STORE",ts_find(&table,$<str>1),0);
							while(ts_last_tmp(&table,depth) != -1){}
						}
;

AffectationVar: tVAR {
							ts_add_symbole(&table,$<str>1,depth);
					 }
			    Affec {

						mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
						mem_add(&memoire,"STORE",ts_find(&table,$<str>1),0);
						while(ts_last_tmp(&table,depth) != -1){}
					  
					  }
;

Affec:
	tEQ Expression tPVIR 
;


Expression :
	  Expression tADD Expression {
									mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
									mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
									mem_add(&memoire,"ADD",0,1);
									mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);									
								 }
	| Expression tSUB Expression {
									mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
									mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
									mem_add(&memoire,"SUB",0,1);
									mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);
								}
	| Expression tMUL Expression {
									mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
									mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
									mem_add(&memoire,"MUL",0,1);
									mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);
								}
	| Expression tDIV Expression {
									mem_add(&memoire,"LOAD",1,ts_last_tmp(&table,depth));
									mem_add(&memoire,"LOAD",0,ts_last_tmp(&table,depth));
									mem_add(&memoire,"DIV",0,1);
									mem_add(&memoire,"STORE",ts_new_tmp(&table,depth),0);
								}
	| tBEGPAR Expression tENDPAR
	| tVAR { int adr_tmp=ts_new_tmp(&table,depth);
				mem_add(&memoire,"LOAD",0,ts_find(&table,$<str>1));
				mem_add(&memoire,"STORE",adr_tmp,0);
			}
	| tENT { int adr_tmp=ts_new_tmp(&table,depth);
				mem_add(&memoire,"AFC",0,$<nb>1);
				mem_add(&memoire,"STORE",adr_tmp,0);
			}
;

Body :

	| Decl Body
	| Affectation Body
	| Printf Body
	| Invocation Body
	| If Body

	
%%

#include <stdio.h>

int yyerror(const char *str)
{
extern int yylineno;
    fprintf(stderr,"Error | Line: %d\n%s\n",yylineno,str);
return 0;
}

int main(void)
{
#if YYDEBUG
	yydebug=1;
#endif
ts_init(&table);
mem_init(&memoire);
printf("init %d\n",table.size);
	yyparse();
printf("Compilation terminée\n");
printf("Ecriture instructions\n");
int i = 0;
fp = fopen("compiler.s","a");
struct LigneM l;
for(i;i<memoire.size;i++)
{
	l=memoire.data[i];
		fprintf(fp,"%s %d %d\n",l.inst,l.p0,l.p1);

}
fclose(fp);
printf("FIN\n");

	return 0;
}
