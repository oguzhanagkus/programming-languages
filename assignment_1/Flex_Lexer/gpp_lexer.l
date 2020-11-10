%{
#include "token.h"
#include <stdio.h>

// Running modes
#define ERROR     0
#define TERM_MODE 1
#define FILE_MODE 2

// Output file
#define OUTPUT_FILE "./lexer_output"

int check_running_mode(char *command, char *filename);

int running_mode, quote_count;
FILE *input_file, *output_file;

const char token_list[][16] = { "KW_AND", "KW_OR", "KW_NOT", "KW_EQUAL", "KW_LESS", "KW_NIL", 
                                "KW_LIST", "KW_APPEND", "KW_CONCAT", "KW_SET", "KW_DEFFUN", "KW_FOR", 
                                "KW_IF", "KW_EXIT", "KW_LOAD", "KW_DISP", "KW_TRUE", "KW_FALSE", 
                                "OP_PLUS", "OP_MINUS", "OP_DIV", "OP_MULT", "OP_DBLMULT", "OP_COMMA", 
                                "OP_OP", "OP_CP", "OP_OC", "OP_CC", "COMMENT", "VALUE", "IDENTIFIER", 
                                "NEWLINE", "WHITESPACE", "UNDEFINED" };
%}

/* -------------------------------------------------- */

%%
"and"     return KW_AND;
"or"      return KW_OR;
"not"     return KW_NOT;
"equal"   return KW_EQUAL;
"less"    return KW_LESS;
"nil"     return KW_NIL;
"list"    return KW_LIST;
"append"  return KW_APPEND;
"concat"  return KW_CONCAT;
"set"     return KW_SET;
"deffun"  return KW_DEFFUN;
"for"     return KW_FOR;
"if"      return KW_IF;
"exit"    return KW_EXIT;
"load"    return KW_LOAD;
"disp"    return KW_DISP;
"true"    return KW_TRUE;
"false"   return KW_FALSE;

"+"       return OP_PLUS;
"-"       return OP_MINUS;
"/"       return OP_DIV;
"*"       return OP_MULT;
"**"      return OP_DBLMULT;
","       return OP_COMMA;
"("       return OP_OP;
")"       return OP_CP;
"\""      { 
            quote_count += 1;
            if (quote_count % 2 == 0)
              return OP_OC;
            else
              return OP_CC; 
          }

";;"      {
            int token_id;

            do {
              token_id = yylex();              
            } while (token_id != NEWLINE);

            return COMMENT;
          }

[0]|[1-9][0-9]*       return VALUE;
[a-zA-Z][a-zA-Z0-9]*  return IDENTIFIER;

"\n"      return NEWLINE;
"\t"      return WHITESPACE;
" "       return WHITESPACE;
.         return UNDEFINED;
%%

/* -------------------------------------------------- */

int yywrap() {} // Wraps rule section above

int main() {
  char command[128], filename[121];

  printf("$ ");
  scanf("%[^\n]s", command);
  
  running_mode = check_running_mode(command, filename);
  if (running_mode == ERROR) {
    printf("G++ interpretter cannot be started.\nAcceptable inputs: \"g++\" or \"g++ filename\"\n");
    return -1;
  }
  else if (running_mode == FILE_MODE){
    input_file = fopen(filename, "r");
    if (input_file == NULL) {
      printf("Error occured with input file!\n");
      return -1;
    }
    else {
      yyin = input_file; // Read from this file pointer
    }
  }

  output_file = fopen(OUTPUT_FILE, "w+");
  if (output_file == NULL)
    return -1;

  quote_count = 0;

/* ------------------------- */

  while (1)
    yylex();
  
  return 0;
}

/* -------------------------------------------------- */

int check_running_mode(char *command, char *filename) {
  int i = 0, j = 0;

  while (command[i] != ' ' && command[i] != '\0')
    i++;

  if (command[i] == '\0') {
    if (command[0] == 'g' && command[1] == '+' && command[2] == '+')
      return 1;
    else
      return 0;
  }

  i++;
  while (command[i] != '\0' && j < 120)
    filename[j++] = command[i++];

  filename[j] = '\0';

  if (command[i] != '\0' && j == 120) // Too long filename
    return 0;

  return 2;
}

/* -------------------------------------------------- */

