#ifndef TS_H_INCLUDED
#define TS_H_INCLUDED
struct Ligne
{
char id[16];
char type[16];
int depth;

}
;

struct Table
{
struct Ligne data[256];
int size;
}
;

void ts_init(struct Table *table);
void ts_add_symbole(struct Table *table, char* v, int depth);
int ts_new_tmp(struct Table *table, int depth);
int ts_last_tmp(struct Table *table, int depth);
int ts_find(struct Table *table, char* v);
#endif
