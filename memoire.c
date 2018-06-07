#include "memoire.h"
#include "string.h"
#include <stdio.h>
#include <stdlib.h>

//init registre memoire
void mem_init(struct MemoireInstructions* memoire)
{
	memoire -> size = 0;
    
}
void mem_add(struct MemoireInstructions* memoire, char* inst, int p0, int p1)
{
	struct LigneM l;
	strcpy(l.inst,inst);
	l.p0 = p0;
	l.p1 = p1;
    memoire->data[memoire->size++] = l;

}
void mem_add_2(struct MemoireInstructions* memoire, char* inst, int p0, int p1, int p2)
{
	struct LigneM l;
	strcpy(l.inst,inst);
	l.p0 = p0;
	l.p1 = p1;
	l.p2 = p2;
    memoire->data[memoire->size++] = l;

}
void mem_jmp(struct MemoireInstructions* memoire, char* inst, int p0)
{
	struct LigneM l;
	strcpy(l.inst,inst);
	l.p0 = p0;
    memoire->data[memoire->size++] = l;

}
