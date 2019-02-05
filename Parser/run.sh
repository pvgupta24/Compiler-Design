#!/bin/bash

yacc -d parser.y
lex -l scanner.l

gcc -Wall lex.yy.c y.tab.c lib/symbol_table.c -w -lm -o parser.out

./parser.out