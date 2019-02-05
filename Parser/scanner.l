/* 
* Lexical Analyser for C language
* @author Shashank P, Praveen Gupta, Ashwin Joisa
*
*/

/* Declaration section */
%option noyywrap
%option yylineno

/* Auxiliary declarations*/
%{  
   #include "lib/misc.h"
   #include "y.tab.h"

   // extern int yylval;
   // extern char *yytext;
   // extern int yylineno;

   void print_token(char *info, char *token, int line_number);
%}

/* Regular definitions */
digit               [0-9]
letter              [a-zA-Z]
alphanum            {letter}|{digit}
keyword             char|int|main|float|double|short|long|unsigned|signed|main|while|for|break|if|else|continue|return|void|struct
operator            "+"|"-"|"++"|"--"|"!"|"~"|"*"|"/"|"%"|">>"|"<<"|"&"|"^"|\||\|\||"="|">"|"<"|">="|"<="|"=="|"!="    
function            ((_|{letter})({alphanum}|_)*)[ ]*[(][ ]*[)]
escape_sequences    0|a|b|f|n|r|t|v|"\\"|"\""|"\'"

/* Pattern Matching Rules */
%%
" "                                                {}
"#include"[ ]*"<"{letter}({alphanum})*".h>"        {}
"#define"[ ]+(_|{letter})({alphanum})*[ ]*(.)+     {}

"char"			   {  yylval = yytext; return CHAR; }
"short"			   {  yylval = yytext; return SHORT; }
"int"			      {  yylval = yytext; return INT; }
"long"			   {  yylval = yytext; return LONG; }
"signed"		      {  yylval = yytext; return SIGNED; }
"unsigned"		   {  yylval = yytext; return UNSIGNED; }
"void"			   {  yylval = yytext; return VOID; }
"if"			      {  return IF; }
"else"			   {  return ELSE; }
"while"			   {  return WHILE; }
"break"			   {  return BREAK; }
"return"          { return RETURN; }
"sizeof"          { return SIZEOF; }

"//".*                                       { /* Single line comments */ }
("/*")(([^*]*[*]+[^*/])*([^*]*[*]+[/]))      { /* Multi line comments */ }

("/*")(([^*]*([*]+[^/])*)*)*                 { /* Comment not closed => Error */ 
                                                print_token(FORE_RED "ERROR: MULTI LINE COMMENT NOT CLOSED", yytext, yylineno); 
                                                exit(1);
                                             }

("\'")(("\\"({escape_sequences}))|.)("\'")   { yylval = yytext; return CHAR_CONSTANT; }          

("\'")(((("\\")[^0abfnrtv\\\"\'][^\n\']*))|[^\n\''][^\n\'']+)("\'")     { 
                                                                           print_token(FORE_RED "ERROR: NOT A CHARACTER", yytext, yylineno); 
                                                                           exit(1);
                                                                        }

("\"")[^\n\"]*("\"")                         { yylval = yytext; return STRING_CONSTANT; }

("\"")[^\n\"]*                               { 
                                                print_token(FORE_RED "ERROR: UNCLOSED STRING", yytext, yylineno); 
                                                exit(1);
                                             }


{digit}+                                     { 
                                                yylval = yytext; return INT_CONSTANT;
                                                // Do we need the below? 
                                                // symbol_table_insert(constant_table, yytext, "Integer", yylineno);
                                             }

"-"?{digit}+\.({digit}+)?                    { 
                                                yylval = yytext; return FLOAT_CONSTANT;
                                                // Do we need the below?
                                                // symbol_table_insert(constant_table, yytext, "Floating point", yylineno);
                                             }

(_|{letter})({alphanum}|_)*                  { yylval = yytext; return IDENTIFIER; }

{digit}?({letter}|_)({alphanum}|_)*          {
                                                // Error
                                                print_token(FORE_RED "ERROR: Invalid Identifier", yytext, yylineno); 
                                                exit(1);
                                             }

"++"			{  return INC_OP; }
"--"			{  return DEC_OP; }
"<<"			{  return LEFT_OP; }
">>"			{  return RIGHT_OP; }
"<="			{  return LE_OP; }
">="			{  return GE_OP; }
"=="			{  return EQ_OP; }
"!="			{  return NE_OP; }
"&&"			{  return AND_OP; }
"||"			{  return OR_OP; }
"*="			{  return MUL_ASSIGN; }
"/="			{  return DIV_ASSIGN; }
"%="			{  return MOD_ASSIGN; }
"+="			{  return ADD_ASSIGN; }
"-="			{  return SUB_ASSIGN; }
"<<="			{  return LEFT_ASSIGN; }
">>="			{  return RIGHT_ASSIGN; }
"&="			{  return AND_ASSIGN; }
"^="			{  return XOR_ASSIGN; }
"|="        {  return OR_ASSIGN; }

"."|"&"|"!"|"~"|"-"|"+"|"*"|"/"|"%"|"<"|">"|"^"|"|"|"?"            { return *yytext; }

{function}                                   { 
                                                // print_token("FUNCTION", yytext, yylineno);
                                                // int i=0;
                                                // for(i=0; yytext[i]!='\0' && yytext[i] !='('; ++i);
                                                // yytext[i] ='\0';
                                                // symbol_table_insert(symbol_table, yytext, "Function", yylineno);
                                             }

"["|"]"|"("|")"|"{"|"}"|","|";"              { return *yytext; }


.  { /* ignore everything else */ }

%%

void print_token(char *info, char *token, int line_number){
   printf(FORE_CYN "%-30s%-30s%-30d\n" RESET, info, token, line_number);
}