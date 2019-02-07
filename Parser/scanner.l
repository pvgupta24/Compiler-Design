/*
* http://www.quut.com/c/ANSI-C-grammar-l-2011.html#comment
* @author Shashank P, Praveen Gupta, Ashwin Joisa
*/

%{

#define trace(fmt, args...) //fprintf(stderr, fmt, ##args)

#include "y.tab.h"
#include "lib/misc.h"
%}

keyword         char|int|float|short|long|unsigned|signed|main|while|for|break|case|if|else|continue|default|do|return|void|struct|switch
number          [0-9]
letter          [a-zA-Z]


single_operators    [+*/%^&.=-]
function        (_|{letter})({letter}|{number}|_)*"()"

%option yylineno
%option noyywrap


%%
\/\/(.)*[\n]                        {
                                    }

"/*"                                { comment(); }

#                                   {  
                                        trace("%-20s%20s%20d\n","#", yytext, yylineno);
                                        return *yytext;  
                                    }

include                             {  
                                        trace("%-20s%20s%20d\n","INCLUDE", yytext, yylineno);
                                        return INCLUDE;  
                                        
                                    }

[\n]                                {
                                    }

[{]                                 { 
                                        trace("%-20s%20s%20d\n","{", yytext, yylineno);
                                        return *yytext;
                                    }
[}]                                 { 
                                        trace("%-20s%20s%20d\n","}", yytext, yylineno);
                                        return *yytext;
                                    }

\"[^"\n]*["\n]                      { 
                                        if(yytext[yyleng-1]!='"'){
                                            trace(FORE_RED "Error : Quote unbalanced at line number %d\n" RESET,yylineno);
                                        }
                                        trace("%-20s%20s%20d\n", "CONSTANT_STRING", yytext, yylineno);
                                        strcpy(yylval.char_ptr, yytext);
                                        return CONSTANT_STRING;
                                    }

int                                 { 
                                        trace("%-20s%20s%20d\n", "INT", yytext, yylineno);
										strcpy(yylval.char_ptr, yytext);
                                        return INT;
                                    }

float                               { 
                                        trace("%-20s%20s%20d\n", "FLOAT", yytext, yylineno);
										strcpy(yylval.char_ptr, yytext);
                                        return FLOAT;
                                    }
char                                { 
                                        trace("%-20s%20s%20d\n", "CHAR", yytext, yylineno);
										strcpy(yylval.char_ptr, yytext);
                                        return CHAR;
                                    }
double                              { 
                                        trace("%-20s%20s%20d\n", "DOUBLE", yytext, yylineno);
										strcpy(yylval.char_ptr, yytext);
                                        return DOUBLE;
                                    }
void                                { 
                                        trace("%-20s%20s%20d\n", "VOID", yytext, yylineno);
										strcpy(yylval.char_ptr, yytext);
                                        return VOID;
                                    }
signed                              { 
                                        trace("%-20s%20s%20d\n", "SIGNED", yytext, yylineno);
                                        return SIGNED;
                                    }
unsigned                            { 
                                        trace("%-20s%20s%20d\n", "UNSIGNED", yytext, yylineno);
                                        return UNSIGNED;
                                    }
long                                { 
                                        trace("%-20s%20s%20d\n", "LONG", yytext, yylineno);
                                        return LONG;
                                    }
short                               { 
                                        trace("%-20s%20s%20d\n", "SHORT", yytext, yylineno);
                                        return SHORT;
                                      
                                    }
switch                              { 
                                        trace("%-20s%20s%20d\n", "SWITCH", yytext, yylineno);
                                        return SWITCH;
                                    }
break                               { 
                                        trace("%-20s%20s%20d\n", "BREAK", yytext, yylineno);
                                        return BREAK;
                                    }
continue                            { 
                                        trace("%-20s%20s%20d\n", "CONTINUE", yytext, yylineno);
                                        return CONTINUE;
                                    }
case                                { 
                                        trace("%-20s%20s%20d\n", "CASE", yytext, yylineno);
                                        return CASE;
                                    }
default                             { 
                                        trace("%-20s%20s%20d\n", "DEFAULT", yytext, yylineno);
                                        return DEFAULT;
                                    }
for                                 { 
                                        trace("%-20s%20s%20d\n", "FOR", yytext, yylineno);
                                        return FOR;
                                    }
while                               { 
                                        trace("%-20s%20s%20d\n", "WHILE", yytext, yylineno);
                                        return WHILE;
                                    }
do                                  { 
                                        trace("%-20s%20s%20d\n", "DO", yytext, yylineno);
                                        return DO;
                                    }
if                                  { 
                                        trace("%-20s%20s%20d\n", "IF", yytext, yylineno);
                                        return IF;
                                      
                                    }
else                                { 
                                        trace("%-20s%20s%20d\n", "ELSE", yytext, yylineno);
                                        return ELSE;
                                    }

return                              { 
                                        trace("%-20s%20s%20d\n", "RETURN", yytext, yylineno);
                                        return RETURN;
                                    }
                                                                                                            
[(]                                 { 
                                        trace("%-20s%20s%20d\n", "(", yytext, yylineno);
                                        return *yytext;
                                    }
[)]                                 { 
                                        trace("%-20s%20s%20d\n", ")", yytext, yylineno);
                                        return *yytext;
                                    }
[\[]                                { 
                                        trace("%-20s%20s%20d\n", "[", yytext, yylineno);
                                        return *yytext;
                                    }
[\]]                                { 
                                        trace("%-20s%20s%20d\n", "]", yytext, yylineno);
                                        return *yytext;
                                    }
[,]                                 { 
                                        trace("%-20s%20s%20d\n", ",", yytext, yylineno);
                                        return *yytext;
                                    } 

[\t ]                               {}

[;]                                 { 
                                        trace("%-20s%20s%20d\n", ";", yytext, yylineno);
                                        return *yytext;
                                    }

\'.\'                               { 
                                        trace("%-20s%20s%20d\n", "CONSTANT_CHAR", yytext, yylineno); 
                                        strcpy(yylval.char_ptr, yytext);
                                        return CONSTANT_CHAR;
                                    }

{number}+(\.{number}+)?e{number}+   { 
                                        trace("%-20s%20s%20d\n", "CONSTANT_FLOAT", yytext, yylineno); 
                                        strcpy(yylval.char_ptr, yytext);
                                        return CONSTANT_FLOAT;
                                    } 

{number}+\.{number}+                { 
                                        trace("%-20s%20s%20d\n", "CONSTANT_FLOAT", yytext, yylineno); 
                                        strcpy(yylval.char_ptr, yytext);
                                        return CONSTANT_FLOAT;
                                    }                                             

{number}+                           { 
                                        trace("%-20s%20s%20d\n", "CONSTANT_INTEGER", yytext, yylineno); 
                                        strcpy(yylval.char_ptr, yytext);
                                        return CONSTANT_INTEGER;
                                    }    

(_|{letter})({letter}|{number}|_)*  { 
                                        trace("%-20s%20s%20d\n", "IDENTIFIER", yytext, yylineno);
                                        strcpy(yylval.char_ptr, yytext);
                                        return IDENTIFIER;
                                    }

{single_operators}        { 
                                        trace("%-20s%20s%20d\n", "UNARY OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }
          
"=="                                { 
                                        trace("%-20s%20s%20d\n", "==", yytext, yylineno); 
                                        return DOUBLE_EQUAL;
                                    }
"!="                                { 
                                        trace("%-20s%20s%20d\n", "!=", yytext, yylineno); 
                                        return NOT_EQUAL;
                                    }
"<"                                 { 
                                        trace("%-20s%20s%20d\n", "<", yytext, yylineno); 
                                        return LESSER_THAN;
                                    }
">"                                 { 
                                        trace("%-20s%20s%20d\n", ">", yytext, yylineno); 
                                        return GREATER_THAN;
                                    }
"<="                                 { 
                                        trace("%-20s%20s%20d\n", "<=", yytext, yylineno); 
                                        return LESSER_EQUAL;
                                    }

"+="                                { 
                                        trace("%-20s%20s%20d\n", "+=", yytext, yylineno); 
                                        return ADD_ASSIGN;
                                    }

"-="                                { 
                                        trace("%-20s%20s%20d\n", "-=", yytext, yylineno); 
                                        return SUB_ASSIGN;
                                    }

"*="                                { 
                                        trace("%-20s%20s%20d\n", "*=", yytext, yylineno); 
                                        return MUL_ASSIGN;
                                    }
                                    
"/="                                { 
                                        trace("%-20s%20s%20d\n", "/=", yytext, yylineno); 
                                        return DIV_ASSIGN;
                                    }
"%="					            { 
                                        trace("%-20s%20s%20d\n", "%=", yytext, yylineno); 
                                        return MOD_ASSIGN;
                                    }

">>="					            { 
                                        trace("%-20s%20s%20d\n", ">>=", yytext, yylineno); 
                                        return RIGHT_ASSIGN;
                                    }
"<<="					            { 
                                        trace("%-20s%20s%20d\n", "<<=", yytext, yylineno); 
                                        return LEFT_ASSIGN;
                                    }

"&="					            { 
                                        trace("%-20s%20s%20d\n", "&=", yytext, yylineno); 
                                        return AND_ASSIGN;
                                    }
"^="					            { 
                                        trace("%-20s%20s%20d\n", "^=", yytext, yylineno); 
                                        return XOR_ASSIGN;
                                    }
"|="					            { 
                                        trace("%-20s%20s%20d\n", "|=", yytext, yylineno); 
                                        return OR_ASSIGN;
                                    }

">="                                { 
                                        trace("%-20s%20s%20d\n", ">=", yytext, yylineno); 
                                        return GREATER_EQUAL;
                                    }
"&&"                                { 
                                        trace("%-20s%20s%20d\n", "&&", yytext, yylineno); 
                                        return LOGIC_AND;
                                    }
"||"                                { 
                                        trace("%-20s%20s%20d\n", "||", yytext, yylineno); 
                                        return LOGIC_OR;
                                    }
"!"                                 { 
                                        trace("%-20s%20s%20d\n", "!", yytext, yylineno); 
                                        return NOT;
                                    }
  
"++"                                { 
                                        trace("%-20s%20s%20d\n", "+=", yytext, yylineno); 
                                        return INC_OP;
                                    }  
"--"                                { 
                                        trace("%-20s%20s%20d\n", "--", yytext, yylineno); 
                                        return DEC_OP;
                                    }  
                                                                      

{number}({letter}|{number}|_)+      { trace(FORE_RED "Error : Invalid Token %s at Line %d\n" RESET, yytext, yylineno); }

.                                   { trace(FORE_RED "Error : Invalid Token %s at Line %d\n" RESET, yytext, yylineno); }

%%

// void trace(char *s){
//     // fprintf(stderr, fmt, ##args);
// }

void comment()
{
    int c;
    while ((c = input()) != 0){
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
                return;

            if (c == 0)
                break;
        }
    }
    yyerror("Unterminated comment");
}
