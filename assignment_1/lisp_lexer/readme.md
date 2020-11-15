You can run the code in two ways:
- clisp gpp_lexer.lisp
- clisp gpp_lexer.lisp filename

The first one, reads a line from the terminal. Then it tokenizes and writes to terminal and the file.
To exit, just press enter while it is waiting for an input. It terminates immidiately.

The second one, reads from given file. The it tokenizes and writes to terminal and the file.
When it reaches end of the file, it terminates.

Note:
Some tokens cannot follow each other. For example, *123 cannot tokenize according to rules in the pdf.
I tried to handle these kind of details.