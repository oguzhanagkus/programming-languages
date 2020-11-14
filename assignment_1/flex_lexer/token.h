#ifndef _TOKEN_H_
#define _TOKEN_H_

// Others
#define END_OF_FILE 0
#define UNDEFINED   1
#define WHITESPACE  2
#define NEWLINE     3

// Keywords
#define KW_AND      4
#define KW_OR       5
#define KW_NOT      6
#define KW_EQUAL    7
#define KW_LESS     8
#define KW_NIL      9
#define KW_LIST     10
#define KW_APPEND   11
#define KW_CONCAT   12
#define KW_SET      13
#define KW_DEFFUN   14
#define KW_FOR      15
#define KW_IF       16
#define KW_EXIT     17
#define KW_LOAD     18
#define KW_DISP     19
#define KW_TRUE     20
#define KW_FALSE    21

// Operators
#define OP_PLUS     22
#define OP_MINUS    23
#define OP_DIV      24
#define OP_MULT     25
#define OP_DBLMULT  26
#define OP_COMMA    27
#define OP_OP       28
#define OP_CP       29
#define OP_OC       30
#define OP_CC       31

// Comments, values, and identifiers
#define COMMENT     32
#define VALUE       33
#define IDENTIFIER  34

#endif // _TOKEN_H_