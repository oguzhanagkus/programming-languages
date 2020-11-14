main:
	flex -o gpp_lexer.c gpp_lexer.l
	gcc -o gpp_lexer gpp_lexer.c
	
run_terminal:
	./gpp_lexer

run_file:
	./gpp_lexer input_1.gpp

clean:
	rm gpp_lexer.c gpp_lexer output