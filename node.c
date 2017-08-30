#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include "node.h"


/* 
 * linked list functions
 */

void out_of_memory(void) {
    fprintf(stderr, "malloc() failed!\n");
    exit(1);
}

struct node *new_node(struct node *prev) {
    struct node *t;
    char *s;

    if(!(t = malloc(sizeof(struct node)))) {
        out_of_memory();
    }

    if(!(s = malloc(128))) {
        out_of_memory();
    }

    t->repetitions = 0;
    t->text_size = 1;
    t->text = s;
    *s = '\0';

    t->next = NULL;
    t->prev = prev;

    if(prev) {
        prev->next = t;
    }
    return t;
}

void delete_node(struct node *n) {
    free(n->text);
    if(n->prev) {
        n->prev->next = n->next;
    }
    if(n->next) {
        n->next->prev = n->prev;
    }
    free(n);
}

/* add some text (s) to node n->text and update size cache */
void append(struct node *n, char *s) {
    int len = strlen(s);
    if(!(n->text = realloc(n->text, n->text_size + len))) {
        exit(3);
    }
    strcat(n->text, s);
    n->text_size += len;
}
