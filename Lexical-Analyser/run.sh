lex -l scanner.l && gcc lex.yy.c lib/symbol_table.c -lfl -o scanner.out
if [ $1 ]; then
    ./scanner.out < $1
else
    ./scanner.out
fi