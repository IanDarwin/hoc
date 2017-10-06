#include <stdlib.h>
#include "hoc.h"
#include "y.tab.h"

static Symbol *symlist = 0;  /* symbol table: linked list */

Symbol*
lookup(char* s)	/* find s in symbol table */
{
	Symbol *sp;

	for (sp = symlist; sp != (Symbol *) 0; sp = sp->next)
		if (strcmp(sp->name, s) == 0)
			return sp;
	return 0;	/* 0 ==> not found */	
}

Symbol*
install(char* s, int t, double d)  /* install s in symbol table */
{
	Symbol *sp;

	sp = emalloc(sizeof(Symbol));
	size_t len = strlen(s) + 1;
	sp->name = emalloc(len); /* +1 for '\0' */
	strlcpy(sp->name, s, len);
	sp->type = t;
	sp->u.val = d;
	sp->next = symlist; /* put at front of list */
	symlist = sp;
	return sp;
}

void*
emalloc(unsigned n)	/* check return from malloc */
{
	char *p;

	p = malloc(n);
	if (p == 0)
		execerror("out of memory", (char *) 0);
	return p;
}
