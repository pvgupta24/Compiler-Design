/* 
* Lexical Analyser for C language
* @author Shashank P, Praveen Gupta, Ashwin Joisa
*
* Usage: ./run.sh or ./runtests.sh
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
alphanum            {letter}|{digit}
keyword             char|int|main|float|double|short|long|unsigned|signed|main|while|for|break|if|else|continue|return|void|struct
operator            "+"|"-"|"++"|"--"|"!"|"~"|"*"|"/"|"%"|">>"|"<<"|"&"|"^"|\||\|\||"="|">"|"<"|">="|"<="|"=="|"!="
function            ((_|{letter})({alphanum}|_)*)/[ ]*[(]
escape_sequences    0|a|b|f|n|r|t|v|"\\"|"\""|"\'"

/* Pattern Matching Rules */
%%
\n                                           {}
" "                                          {}
"#include"[ ]*"<"{letter}({alphanum})*".h>"   { print_token("PREPROCESSOR DIRECTIVE", yytext, yylineno); }
"#define"[ ]+(_|{letter})({alphanum})*[ ]*(.)+   { print_token("PREPROCESSOR DIRECTIVE", yytext, yylineno); }

"//".*                                       { print_token("SINGLE LINE COMMENT", yytext, yylineno); }
("/*")(([^*]*[*]+[^*/])*([^*]*[*]+[/]))      { print_token("MULTI LINE COMMENT", yytext, yylineno); }

("/*")(([^*]*([*]+[^/])*)*)*                 { print_token(FORE_RED "ERROR: MULTI LINE COMMENT NOT CLOSED", yytext, yylineno); }

("\"")[^\n\"]*("\"")                         { 
                                                print_token("STRING", yytext, yylineno); 
                                                symbol_table_insert(constant_table, yytext, "String", yylineno);
                                             }
("\"")[^\n\"]*                               { print_token(FORE_RED "ERROR: UNCLOSED STRING", yytext, yylineno); }

("\'")(("\\"({escape_sequences}))|.)("\'")   { 
                                                print_token("CHARACTER", yytext, yylineno); 
                                                symbol_table_insert(constant_table, yytext, "Character", yylineno);
                                             }

("\'")(((("\\")[^0abfnrtv\\\"\'][^\n\']*))|[^\n\''][^\n\'']+)("\'") { 
                                               print_token(FORE_RED "ERROR: NOT A CHARACTER", yytext, yylineno); }

{keyword}/[ ]*[(]?                           { 
                                                print_token("KEYWORD", yytext, yylineno); 
                                             }

#include[/"<][ ]*{letter}{letter}*\.h[/">]   {
                                                print_token("HEADER", yytext, yylineno);                                                 
                                             }

{operator}                                   { print_token("OPERATOR", yytext, yylineno); }


{function}                                   { 
                                                print_token("FUNCTION", yytext, yylineno);
                                                // int i=0;
                                                // for(i=0; yytext[i]!='\0' && yytext[i] !='('; ++i);
                                                // yytext[i] ='\0';
                                                symbol_table_insert(symbol_table, yytext, "Function", yylineno);
                                             }

(_|{letter})({alphanum}|_)*                  { 
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

%%

void print_token(char *info, char *token, int line_number){
   printf(FORE_CYN "%-30s%-30s%-30d\n" RESET, info, token, line_number);
}

/* User SubRoutines */
int main()
{
   
   printf(FORE_MAG "\n" DASHES RESET);
   printf(FORE_CYN "\t\t\tLexical Analyser for C language\n" RESET);
   printf(FORE_MAG DASHES "\n" RESET);

   printf(FORE_GRN "%-30s%-30s%-30s\n", "TOKEN TYPE", "TOKEN VALUE", "LINE NUMBER" RESET);

   yylex();

   symbol_table_print(symbol_table, "Symbol Table");
   symbol_table_print(constant_table, "Constant Table");

   return 0;
}
