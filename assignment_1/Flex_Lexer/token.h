#ifndef _TOKEN_H_
#define _TOKEN_H_

// Keywords
#define KW_AND      0
#define KW_OR       1
#define KW_NOT      2
#define KW_EQUAL    3
#define KW_LESS     4
#define KW_NIL      5
#define KW_LIST     6
#define KW_APPEND   7
#define KW_CONCAT   8
#define KW_SET      9
#define KW_DEFFUN   10
#define KW_FOR      11
#define KW_IF       12
#define KW_EXIT     13
#define KW_LOAD     14
#define KW_DISP     15
#define KW_TRUE     16
#define KW_FALSE    17

// Operators
#define OP_PLUS     18
#define OP_MINUS    19
#define OP_DIV      20
#define OP_MULT     21
#define OP_DBLMULT  22
#define OP_COMMA    23
#define OP_OP       24
#define OP_CP       25
#define OP_OC       26
#define OP_CC       27

// Comments, values, and identifiers
#define COMMENT     28
#define VALUE       29
#define IDENTIFIER  30

// Others
#define NEWLINE     31
#define WHITESPACE  32
#define UNDEFINED   33

#endif // _TOKEN_H_