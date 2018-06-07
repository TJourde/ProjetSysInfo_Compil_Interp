#include "ts.h"
#include "string.h"
#include <stdio.h>
#include <stdlib.h>

//initialisation table des symboles
void ts_init(struct Table *table) {
//table=malloc(sizeof(struct Ligne)*256);
table->size=0;
}

//ajout d'une variable/constante
void ts_add_symbole(struct Table *table, char* v, int depth)
{

struct Ligne l;
strcpy( l.id, v);
strcpy( l.type, "int");
l.depth=depth;


table->data[table->size]=l;
table->size++;
printf("add symbole %s, size %d\n", v, table->size);
}

//ajout d'une variable temporaire (utlisée par les expressions)
int ts_new_tmp(struct Table *table, int depth)
{
struct Ligne l;
strcpy( l.id, "???");
strcpy( l.type, "int");
l.depth=depth;

table->data[table->size]=l;
table->size++;
printf("add symbole tmp, size %d\n", table->size);
return ((table->size)-1);
}

//retourner entier du symbole v dans la table
int ts_find(struct Table *table, char* v)
{
	int i = 0;
	int trouve = 0;
	while(i<table->size && trouve==0)
	{
printf("search %s  => %s ???  @ %d\n", v, table->data[i].id, i);
		if(strcmp(table->data[i].id,v)==0)
        {
			trouve=1;
		}
		else
		{
			i++;
		}
	}
	if(trouve==0)
		i=-1;

printf("search %s  => %s !!!  @ %d\n", v, table->data[i].id, i);
	return i;


}

//retrait de la dernière variable temporaire
int ts_last_tmp(struct Table *table, int depth)
{
struct Ligne l;
char * s = (table->data[table->size-1]).id ;
int d = (table->data[table->size-1]).depth;
printf("%s %d",s,d);
if(strcmp(s,"???")==0 && d==depth)
{
table->size --;
printf("del symbole, size %d\n",table->size);
}
else
{
	printf("no tmp found\n");
	return -1;
}
return table->size;
}


