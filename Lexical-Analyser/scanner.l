/* 
* Lexical Analyser for C language
* @author Shashank P, Praveen Gupta, Ashwin Joisa
*
* Usage: lex scanner.l && gcc lex.yy.c -lfl && ./a.out
*/

/* Declaration section */
%option noyywrap
%option yylineno

/* Auxiliary declarations*/
%{
    #include "lib/misc.h"
    #include "lib/symbol_table.h"
    
    #define MAX_NODES 1000

    symbol_node_t *symbol_table[MAX_NODES];
    symbol_node_t *constant_table[MAX_NODES];
%}

/* Regular definitions */
digit               [0-9]
letter              [a-zA-Z]
keyword             char|int|main|float|double|short|long|unsigned|signed|main|while|for|break|if|else|continue|return|void|struct
operator            "+"|"-"|"++"|"--"|"!"|"~"|"*"|"/"|"%"|">>"|"<<"|"&"|"^"|\||\|\||"="|">"|"<"|">="|"<="|"=="|"!="
function            (_|{letter})({letter}|{digit}|_)*[ ]*[(][ ]*[])]
escape_sequences    0|a|b|f|n|r|t|v|"\\"|"\""|"\'"

/* Pattern Matching Rules */
%%
\n                                           {}
" "                                          {}
"#include"[ ]*"<"[a-zA-Z][0-9a-zA-z]*".h>" { printf("%-20s%20s%20d\n","HEADER FILE", yytext, yylineno); }

"//".*                                       { printf("%-20s%20s%20d\n","SINGLE LINE COMMENT", yytext, yylineno); }
("/*")(([^*]*[*]+[^*/])*([^*]*[*]+[/]))      { printf("%-20s%20s%20d\n","MULTI LINE COMMENT", yytext, yylineno); }

("/*")(([^*]*([*]+[^/])*)*)*                 { printf("%-20s%20s%20d\n","ERROR: MULTI LINE COMMENT NOT CLOSED", yytext, yylineno); }

("\"")[^\n\"]*("\"")                         { 
                                                printf("%-20s%20s%20d\n","STRING", yytext, yylineno); 
                                                symbol_table_insert(constant_table, yytext, "String", yylineno);
                                             }
("\"")[^\n\"]*                               { printf("%-20s%20s%20d\n","ERROR: UNCLOSED STRING", yytext, yylineno); }

("\'")(("\\"({escape_sequences}))|.)("\'")   { 
                                                printf("%-20s%20s%20d\n","CHARACTER", yytext, yylineno); 
                                                symbol_table_insert(constant_table, yytext, "Character", yylineno);
                                             }
("\'")(((("\\")[^0abfnrtv\\\"\'][^\n\']*))|[^\n\''][^\n\'']+)("\'") { 
                                               printf("%-20s%20s%20d\n","ERROR: NOT A CHARACTER", yytext, yylineno); }

{keyword}                                    { 
                                                symbol_table_insert(symbol_table, yytext, "Keyword", yylineno);
                                                printf("%-20s%20s%20d\n","KEYWORD", yytext, yylineno); 
                                             }
"long long"                                  { 
                                                printf("%-20s%20s%20d\n","DATATYPE", yytext, yylineno); 
                                                symbol_table_insert(symbol_table, "long long", "Keyword", yylineno);
                                             }

{operator}                                   { printf("%-20s%20s%20d\n","OPERATOR", yytext, yylineno); }

(_|{letter})({letter}|{digit}|_)*            { 
                                                printf("%-20s%20s%20d\n","IDENTIFIER", yytext, yylineno); 
                                                symbol_table_insert(symbol_table, yytext, "Identfier", yylineno);
                                             }

"-"?{digit}+                                 { 
                                                printf("%-20s%20s%20d\n","INTEGER", yytext, yylineno); 
                                                symbol_table_insert(constant_table, yytext, "Integer", yylineno);
                                             }

"-"?{digit}+\.({digit}+)?                    { 
                                                printf("%-20s%20s%20d\n","FLOATING POINT", yytext, yylineno); 
                                                symbol_table_insert(constant_table, yytext, "Floating point", yylineno);
                                             }

"["                                          { printf("%-20s%20s%20d\n","LEFT BRACKET", yytext, yylineno); }
"]"                                          { printf("%-20s%20s%20d\n","RIGHT BRACKET", yytext, yylineno); }
"("                                          { printf("%-20s%20s%20d\n","LEFT PARENTHESIS", yytext, yylineno); }
")"                                          { printf("%-20s%20s%20d\n","RIGHT PARENTHESIS", yytext, yylineno); }
"{"                                          { printf("%-20s%20s%20d\n","LEFT BRACE", yytext, yylineno); }
"}"                                          { printf("%-20s%20s%20d\n","RIGHT BRACE", yytext, yylineno); }
","                                          { printf("%-20s%20s%20d\n","COMMA", yytext, yylineno); }
";"                                          { printf("%-20s%20s%20d\n","SEMICOLON", yytext, yylineno); }

{function}                                   { printf("%-20s%20s%20d\n","FUNCTION", yytext, yylineno); }

%%

/* User SubRoutines */
int main() {
    printf(FORE_MAG "\n" DASHES RESET);
    printf(FORE_CYN "\t\t\tLexical Analyser for C language\n" RESET);
    printf(FORE_MAG DASHES "\n" RESET);

    printf(FORE_GRN "%-20s%20s%24s\n", "TOKEN TYPE", "TOKEN VALUE", "LINE NUMBER" RESET);

    yylex();

    symbol_table_print(symbol_table, "Symbol Table");
    symbol_table_print(constant_table, "Constant Table");

    return 0;
}
