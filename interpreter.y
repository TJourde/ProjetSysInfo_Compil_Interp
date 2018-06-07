%{
#include <stdio.h>
#include <stdlib.h>
#include "memoire.h"
#include <string.h>

#define YYDEBUG 0
int yylex();
int yyerror(const char *s);

//numero groupe 27
//todo if else fonctions déclaration et invocations boucles(while) en bonus synatxe et interpreteur
int reg[3];
int mem[1024]; //faire une stuct pour la memoire : ajout int size;
struct MemoireInstructions memoire;
   FILE * fp;
%}

%union {char str[80]; int nb;}

%token tAFC tSTORE tLOAD tADD tSUB tMUL tDIV tENT tJMP tJMPC tINF tINFE tSUP tSUPE tEQQ tDIFF

%%
Principale:
  tAFC tENT tENT { mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);} Suites
  |tSTORE tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);} Suites 
  |tLOAD tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);} Suites 
  |tADD tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tSUB tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tMUL tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tDIV tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tJMP tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tJMPC tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tINF tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tINFE tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tSUP tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tSUPE tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
  |tEQQ tENT tENT {mem_add(&memoire, $<str>1, $<nb>2, $<nb>3);}Suites 
;
Suites:

 | Principale
;


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
mem_init(&memoire);
	yyparse();
printf("Interprétation terminée\n");
printf("Exécutions instructions\n");
int i = 0;
int j = 0;
struct LigneM l;
fp = fopen("instruct.hex","a");
for(i;i<memoire.size;i++)
{//%02x pour registre %04x pour valeur
	l=memoire.data[i];
printf("i %d s %d\n",i,memoire.size);
	if(strcmp(l.inst,"AFC")==0) {reg[l.p0]=l.p1; fprintf(fp,"0x06%02x%04x\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"STORE")==0) {mem[l.p0]=reg[l.p1];fprintf(fp,"0x08%04x%02x\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"LOAD")==0) {reg[l.p0]=mem[l.p1];fprintf(fp,"0x07%02x%04x\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"ADD")==0) {reg[l.p0]=reg[l.p0]+reg[l.p1];fprintf(fp,"0x01%02x%02x00\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"SUB")==0) {reg[l.p0]=reg[l.p0]-reg[l.p1];fprintf(fp,"0x03%02x%02x00\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"MUL")==0) {reg[l.p0]=reg[l.p0]*reg[l.p1];fprintf(fp,"0x02%02x%02x00\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"DIV")==0) {reg[l.p0]=reg[l.p0]/reg[l.p1];fprintf(fp,"0x04%02x%02x00\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"JMPC")==0) { if(l.p1==0){i=mem[l.p0];} fprintf(fp,"0x0F%04x%02x\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"JMP")==0) {/*i=mem[l.p0]; mauvaise valeur renvoyée, on ne peut pas imuler JMP*/fprintf(fp,"0x0E%04x00\n",l.p0);}
	else if (strcmp(l.inst,"INF")==0) {if(reg[l.p1]<reg[l.p2]){reg[l.p0]=1;}else{reg[l.p0]=0;}fprintf(fp,"0x0A%02x%02x00\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"INFE")==0) {if(reg[l.p1]<=reg[l.p2]){reg[l.p0]=1;}else{reg[l.p0]=0;}fprintf(fp,"0x0B%02x%02x00\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"SUP")==0) {if(reg[l.p1]>reg[l.p2]){reg[l.p0]=1;}else{reg[l.p0]=0;}fprintf(fp,"0x0C%02x%02x00\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"SUPE")==0) {if(reg[l.p1]>=reg[l.p2]){reg[l.p0]=1;}else{reg[l.p0]=0;}fprintf(fp,"0x0D%02x%02x00\n",l.p0,l.p1);}
	else if (strcmp(l.inst,"EQQ")==0) {if(reg[l.p1]==reg[l.p2]){reg[l.p0]=1;}else{reg[l.p0]=0;}fprintf(fp,"0x09%02x%02x00\n",l.p0,l.p1);}
	/*else if (strcmp(l.inst,"DIFF")==0) {if(reg[l.p1]!=reg[l.p2]){reg[l.p0]=1;}else{reg[l.p0]=0;}fprintf(fp,"0x0A%02x%02x00x\n",l.p0,l.p1);}*/
	else {printf("error : instruction inconnue %s %d...\n", l.inst, l.p0); return -1;}
	


	printf("l : %s %d %d\n",l.inst,l.p0,l.p1);
	for(j=0;j<3;j++){printf("%d ",reg[j]);}
	printf("\n");


}
fclose(fp);

printf("FIN\n");
return 0;
}
