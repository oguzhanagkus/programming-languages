I have a makefile, you can use it or compile and run manually.

When you run executable, it means you have started the interpretter.
You have two choice:
1- read from terminal
2- read from file

To choose first one, just write "g++" with no additonal characters, whitespace, or etc.
Then enter a line, it will tokenize it and write to terminal and file.
To exit, just press enter while it is waiting for an input. It terminates immidiately.

To choose second one, just write "g++ <filename>". There should be one whitespace between "g++" and <filename>.
Extension of file is not important. It start to read your file and write to terminal and file.
When it reached the end of file, it immidiately terminates.

Note:
Some tokens cannot follow each other. For example, *123 cannot tokenize according to rules in the pdf.
I tried to handle these kind of details. 