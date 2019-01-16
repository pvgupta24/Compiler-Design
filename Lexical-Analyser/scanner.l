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

    int lineNum = 1;
%}

/* Regular definitions */
digit       [0-9]
letter      [a-zA-Z]
keyword     char|int|main|float|double|short|long|unsigned|signed|main|while|for|break|if|else|continue|return|void|struct
operator    "+"|"-"|"++"|"--"|"!"|"~"|"*"|"/"|"%"|">>"|"<<"|"&"|"^"|\||\|\||"="|">"|"<"|">="|"<="|"=="|"!="
function    (_|{letter})({letter}|{digit}|_)*"()"

/* Pattern Matching Rules */
%%
[\n]                                         { lineNum++; }
" "                                          {}

"//".*                                       { printf("%-20s%20s%20d\n","SINGLE LINE COMMENT", yytext, lineNum); }
("/*")(([^*]*[*]+[^*/])*([^*]*[*]+[/]))      { printf("%-20s%20s%20d\n","MULTI LINE COMMENT", yytext, lineNum); }

("/*")(([^*]*([*]+[^/])*)*)*                 { printf("%-20s%20s%20d\n","ERROR: MULTI LINE COMMENT NOT CLOSED", yytext, lineNum); }

("\"")[^\n\"]*("\"")                         { printf("%-20s%20s%20d\n","STRING", yytext, lineNum); }
("\"")[^\n\"]*                               { printf("%-20s%20s%20d\n","ERROR: UNCLOSED STRING", yytext, lineNum); }

{keyword}                                    { printf("%-20s%20s%20d\n","KEYWORD", yytext, lineNum); }
"long long"                                  { printf("%-20s%20s%20d\n","DATATYPE", yytext, lineNum); }

{operator}                                   { printf("%-20s%20s%20d\n","OPERATOR", yytext, lineNum); }

(_|{letter})({letter}|{digit}|_)*            { printf("%-20s%20s%20d\n","IDENTIFIER", yytext, lineNum); }

"-"?{digit}+                                 { printf("%-20s%20s%20d\n","INTEGER", yytext, lineNum); }

"-"?{digit}+\.({digit}+)?                    { printf("%-20s%20s%20d\n","FLOATING POINT", yytext, lineNum); }

"["                                          { printf("%-20s%20s%20d\n","LEFT BRACKET", yytext, lineNum); }
"]"                                          { printf("%-20s%20s%20d\n","RIGHT BRACKET", yytext, lineNum); }
"("                                          { printf("%-20s%20s%20d\n","LEFT PARENTHESIS", yytext, lineNum); }
")"                                          { printf("%-20s%20s%20d\n","RIGHT PARENTHESIS", yytext, lineNum); }
"{"                                          { printf("%-20s%20s%20d\n","LEFT BRACE", yytext, lineNum); }
"}"                                          { printf("%-20s%20s%20d\n","RIGHT BRACE", yytext, lineNum); }
","                                          { printf("%-20s%20s%20d\n","COMMA", yytext, lineNum); }
";"                                          { printf("%-20s%20s%20d\n","SEMICOLON", yytext, lineNum); }

{function}                                   { printf("%-20s%20s%20d\n","FUNCTION", yytext, lineNum); }

%%

/* User SubRoutines */
int main() {
    printf(FORE_MAG "\n" DASHES RESET);
    printf(FORE_CYN "\t\t\tLexical Analyser for C language\n" RESET);
    printf(FORE_MAG DASHES "\n" RESET);

    printf(FORE_GRN "%-20s%20s%24s\n", "TOKEN TYPE", "TOKEN VALUE", "LINE NUMBER" RESET);

    yylex();

    // symbol_table_insert(symbol_table, "x", "int", 23);
    // symbol_table_insert(symbol_table, "y", "char", 28);
    // symbol_table_insert(symbol_table, "z", "int", 23);

    // symbol_table_print(symbol_table, "Symbol Table");
    // symbol_table_print(constant_table, "Constant Table");

    return 0;
}
