#ifndef MEMOIRE_H_INCLUDED
#define MEMOIRE_H_INCLUDED
struct LigneM
{
char inst[16];
int p0;
int p1;
int p2;
}
;

struct MemoireInstructions
{
struct LigneM data[1024];
int size;
}
;

void mem_init(struct MemoireInstructions* memoire);

void mem_add(struct MemoireInstructions* memoire, char* inst, int p0, int p1);

void mem_add_2(struct MemoireInstructions* memoire, char* inst, int p0, int p1, int p2);

void mem_jmp(struct MemoireInstructions* memoire, char* inst, int p0);

#endif
