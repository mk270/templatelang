#ifndef NODE_H
#define NODE_H

#include <stdint.h>

struct node {
    struct node *next;
    struct node *prev;
    char *text;
    int text_size; /* to avoid quadratically calling strlen(this->text) */
    uint32_t repetitions;
};

struct node *new_node(struct node *prev);
void delete_node(struct node *n);
void append(struct node *n, char *s);

#endif /* NODE_H */