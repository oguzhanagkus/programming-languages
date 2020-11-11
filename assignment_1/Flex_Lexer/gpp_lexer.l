%{
#include "token.h"
#include <stdio.h>
#include <string.h>

// Running modes
#define ERROR     0
#define TERM_MODE 1
#define FILE_MODE 2

// Output file
#define OUTPUT_FILE "./lexer_output"

// Helper functions
void print(int token_id, char *backup);
int check_running_mode(char *command, char *filename);

// Global variables
int running_mode, quote_count;
FILE *input_file, *output_file;

const char token_list[][16] = { "", "", "", "", 
                                "KW_AND", "KW_OR", "KW_NOT", "KW_EQUAL", "KW_LESS", "KW_NIL", 
                                "KW_LIST", "KW_APPEND", "KW_CONCAT", "KW_SET", "KW_DEFFUN", "KW_FOR", 
                                "KW_IF", "KW_EXIT", "KW_LOAD", "KW_DISP", "KW_TRUE", "KW_FALSE", 
                                "OP_PLUS", "OP_MINUS", "OP_DIV", "OP_MULT", "OP_DBLMULT", "OP_COMMA", 
                                "OP_OP", "OP_CP", "OP_OC", "OP_CC", "COMMENT", "VALUE", "IDENTIFIER" };
%}

/* -------------------------------------------------- */
// Rule section
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
            if (quote_count % 2 == 1)
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
  int previous_id, token_id, temp_id, exit_flag;
  char command[128], filename[121], backup[128];

  printf("$ ");
  scanf("%[^\n]s", command); // Read without whitespaces
  
  // Check running mode, read from terminal or file
  running_mode = check_running_mode(command, filename);
  if (running_mode == ERROR) {
    printf("G++ interpretter cannot be started!\nAcceptable inputs: \"g++\" or \"g++ filename\"\n");
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

  /* ------------------------- */

  previous_id = 0;
  token_id = 0;
  temp_id = 0;
  exit_flag = 0;
  quote_count = 0;

  do
  {
    if (running_mode == TERM_MODE && (token_id == NEWLINE || token_id == COMMENT)) {
      quote_count = 0;
      printf("> ");
    }
    
    token_id = yylex();

    if (token_id == END_OF_FILE) {
      exit_flag = 1;
    }
    else if (token_id == UNDEFINED) {
      print(token_id, NULL);
    }
    else if (token_id > NEWLINE) {
      if ((token_id  < OP_PLUS || token_id == OP_CC || token_id == VALUE || token_id == IDENTIFIER) ||
          (token_id > KW_FALSE && token_id < OP_COMMA)) {
        strcpy(backup, yytext);
        temp_id = yylex();

        if (temp_id != WHITESPACE && temp_id != NEWLINE && temp_id != OP_OP && temp_id != OP_CP && temp_id != OP_CC) {
          print(UNDEFINED, backup);
          previous_id = token_id;
          token_id = UNDEFINED;
        }
        else {
          print(token_id, NULL);
          previous_id = token_id;
          token_id = temp_id;
          
          if (temp_id == OP_OP || temp_id == OP_CP || temp_id == OP_CC)
            print(token_id, NULL);
        }
      }
      else {
        print(token_id, NULL);
      }
    }

    // Exit when empty string entered
    if (running_mode == TERM_MODE && (previous_id == NEWLINE || previous_id == COMMENT) && token_id == NEWLINE) {
      exit_flag = 1;
    }
   
    previous_id = token_id;
  } while (exit_flag == 0);
  
  fclose(output_file);
  return 0;
}

/* -------------------------------------------------- */

// Wraps printf and fprintf
void print(int token_id, char *backup) {
  if (token_id != UNDEFINED) {
    printf("%s\n", token_list[token_id]);
    fprintf(output_file, "%s\n", token_list[token_id]);
  }
  else {
    if (backup == NULL) {
      printf("Error! %s cannot be tokenized!\n", yytext);
      fprintf(output_file, "Error! %s cannot be tokenized!\n", yytext);
    }
    else {
      printf("Error! %s%s cannot be tokenized!\n", backup, yytext);
      fprintf(output_file, "Error! %s%s cannot be tokenized!\n", backup, yytext);
    }
  }
}

/* -------------------------------------------------- */

// Parses first command and detects running mode
int check_running_mode(char *command, char *filename) {
  int i = 4, j = 0;

  if (!(command[0] == 'g' && command[1] == '+' && command[2] == '+'))
    return 0;

  if (command[3] == '\0')
    return 1;
  else if (command[3] != ' ')
    return 0;

  while (command[i] != '\0' && j < 120)
    filename[j++] = command[i++];

  filename[j] = '\0';

  if (command[i] != '\0' && j == 120) // Too long filename
    return 0;

  return 2;
}
