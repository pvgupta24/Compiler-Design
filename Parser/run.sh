yacc -d parser.y
# yacc -d parser.y -Wnone
lex scanner.l
# gcc -Wall lex.yy.c y.tab.c lib/symbol_table.c -w -lm -o parser.out
gcc lex.yy.c y.tab.c lib/symbol_table.c -w -lm -o parser.out 