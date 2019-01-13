/* 
* Lexical Analyser for C language
* @author Shashank P, Praveen Gupta, Ashwin Joisa
*
* Usage: lex scanner.l && gcc lex.yy.c -lfl && ./a.out
*/

/* Declaration section */
%option noyywrap

/* Auxiliary declarations*/
%{
    #include "lib/misc.h"
    #include "lib/symbol_table.h"
    
    #define MAX_NODES 1000

    symbol_node_t *symbol_table[MAX_NODES];
    symbol_node_t *constant_table[MAX_NODES];
%}

/* Regular definitions */
digit       [0-9]
letter      [a-zA-Z]

/* Pattern Matching Rules */
%%
%%

/* User SubRoutines */
int main() {
    printf(FORE_MAG "\n" DASHES RESET);
    printf(FORE_CYN "\t\t\tLexical Analyser for C language\n" RESET);
    printf(FORE_MAG DASHES "\n" RESET);

    yylex();

    symbol_table_insert(symbol_table, "x", "int", 23);
    symbol_table_insert(symbol_table, "y", "char", 28);
    symbol_table_insert(symbol_table, "z", "int", 23);

    symbol_table_print(symbol_table, "Symbol Table");
    symbol_table_print(constant_table, "Constant Table");

    return 0;
}
