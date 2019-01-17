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

    void print_token(char *info, char *token, int line_number);
%}

/* Regular definitions */
digit               [0-9]
letter              [a-zA-Z]
keyword             char|int|main|float|double|short|long|unsigned|signed|main|while|for|break|if|else|continue|return|void|struct|"long long"
operator            "+"|"-"|"++"|"--"|"!"|"~"|"*"|"/"|"%"|">>"|"<<"|"&"|"^"|\||\|\||"="|">"|"<"|">="|"<="|"=="|"!="
function            (_|{letter})({letter}|{digit}|_)*[ ]*[(][ ]*[])]
escape_sequences    0|a|b|f|n|r|t|v|"\\"|"\""|"\'"

/* Pattern Matching Rules */
%%
\n                                           {}
" "                                          {}
"#include"[ ]*"<"[a-zA-Z][0-9a-zA-z]*".h>" { printf("%-20s%20s%20d\n","HEADER FILE", yytext, yylineno); }

"//".*                                       { print_token("SINGLE LINE COMMENT", yytext, yylineno); }
("/*")(([^*]*[*]+[^*/])*([^*]*[*]+[/]))      { print_token("MULTI LINE COMMENT", yytext, yylineno); }

("/*")(([^*]*([*]+[^/])*)*)*                 { print_token("ERROR: MULTI LINE COMMENT NOT CLOSED", yytext, yylineno); }

("\"")[^\n\"]*("\"")                         { 
                                                print_token("STRING", yytext, yylineno); 
                                                symbol_table_insert(constant_table, yytext, "String", yylineno);
                                             }
("\"")[^\n\"]*                               { print_token("ERROR: UNCLOSED STRING", yytext, yylineno); }

("\'")(("\\"({escape_sequences}))|.)("\'")   { 
                                                print_token("CHARACTER", yytext, yylineno); 
                                                symbol_table_insert(constant_table, yytext, "Character", yylineno);
                                             }
("\'")(((("\\")[^0abfnrtv\\\"\'][^\n\']*))|[^\n\''][^\n\'']+)("\'") { 
                                               print_token("ERROR: NOT A CHARACTER", yytext, yylineno); }

{keyword}                                    { 
                                                print_token("KEYWORD", yytext, yylineno); 
                                             }

#include[/"<][ ]*{letter}{letter}*\.h[/">]   {
                                                print_token("HEADER", yytext, yylineno);                                                 
                                             }

{operator}                                   { print_token("OPERATOR", yytext, yylineno); }

(_|{letter})({letter}|{digit}|_)*            { 
                                                print_token("IDENTIFIER", yytext, yylineno);
                                                symbol_table_insert(symbol_table, yytext, "Identfier", yylineno);
                                             }

"-"?{digit}+                                 { 
                                                print_token("INTEGER", yytext, yylineno);
                                                symbol_table_insert(constant_table, yytext, "Integer", yylineno);
                                             }

"-"?{digit}+\.({digit}+)?                    { 
                                                print_token("FLOATING POINT", yytext, yylineno); 
                                                symbol_table_insert(constant_table, yytext, "Floating point", yylineno);
                                             }

"["                                          { print_token("LEFT BRACKET", yytext, yylineno); }
"]"                                          { print_token("RIGHT BRACKET", yytext, yylineno); }
"("                                          { print_token("LEFT PARENTHESIS", yytext, yylineno); }
")"                                          { print_token("RIGHT PARENTHESIS", yytext, yylineno); }
"{"                                          { print_token("LEFT BRACE", yytext, yylineno); }
"}"                                          { print_token("RIGHT BRACE", yytext, yylineno); }
","                                          { print_token("COMMA", yytext, yylineno); }
";"                                          { print_token("SEMICOLON", yytext, yylineno); }

{function}                                   { print_token("FUNCTION", yytext, yylineno); }

%%

void print_token(char *info, char *token, int line_number){
   printf(FORE_CYN "%-20s%-20s%-20d\n" RESET, info, token, line_number);
}


/* User SubRoutines */
int main() {
    printf(FORE_MAG "\n" DASHES RESET);
    printf(FORE_CYN "\t\t\tLexical Analyser for C language\n" RESET);
    printf(FORE_MAG DASHES "\n" RESET);

    printf(FORE_GRN "%-20s%-20s%-20s\n", "TOKEN TYPE", "TOKEN VALUE", "LINE NUMBER" RESET);

    yylex();

    symbol_table_print(symbol_table, "Symbol Table");
    symbol_table_print(constant_table, "Constant Table");

    return 0;
}
