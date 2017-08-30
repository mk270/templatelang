%{                                                              /* -*-c-*- */

/* templatelang

   Read from stdin; when we encounter a token like LOOP_10 (for any positive
   integer suffix), cache the following text, until an ENDLOOP, in a node
   in a linked list, for later output; on output, repeat the text 10 times
   (or however many times were specified in LOOP_n).

   Loops may be nested. The nesting is reflected in a doubly linked list,
   each node representing a further layer of nesting in the input stream.
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "node.h"

struct node *head = NULL;
struct node *tail = NULL;

void start_loop(char *);
void end_loop(void);
void store_text(char *);

/* lex grammar: use regular expressions to match LOOP_n, ENDLOOP, and
   everything else, represented by ".|\n" in the last pattern

   "yytext" represents the text matched, e.g. "LOOP_3" or "repeat this line"
*/

%}

%%

LOOP_([0-9]+) {
    /* magic number 5 below is length of the string "LOOP_" */
    char *offset = yytext + 5;
    start_loop(offset); 
}

ENDLOOP {
    end_loop();
}

.|\n {
    store_text(yytext);
}

%%

/*
 * callback functions for the three types of input tokens:
 *   LOOP_n
 *   ENDLOOP
 *   normal text
 */

void start_loop(char *s) {
    int reps = atoi(s);

    tail = new_node(tail);
    tail->repetitions = reps;
}

void store_text(char *s) {
    append(tail, s);
}

void end_loop(void) {
    int i;
    int repetitions = tail->repetitions;

    for(i = 0; i < repetitions; i++) {
        append(tail->prev, tail->text);
    }
    tail = tail->prev;
    delete_node(tail->next);
    if(tail == head) {
        printf("%s", tail->text);
    }
}

/* specify our own main() function so we can do our linked list housekeeping
   before we start; yylex() runs the grammar against stdin */
int main(int argc, char *argv[]) {
    head = new_node(NULL);
    tail = head;
    yylex();
}

