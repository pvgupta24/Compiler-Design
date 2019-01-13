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
    #include "lib.h"
%}

/* Regular definitions */
digit       [0-9]
letter      [a-zA-Z]

/* Pattern Matching Rules */
%%
%%

/* User SubRoutines */
int main() {
    printf(FORE_MAG "\n=====================================\n" RESET);
    printf(FORE_CYN "   Lexical Analyser for C language\n" RESET);
    printf(FORE_MAG "=====================================\n\n" RESET);

    yylex();

    return 0;
}
