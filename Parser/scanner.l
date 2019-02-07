/*
* http://www.quut.com/c/ANSI-C-grammar-l-2011.html#comment
* @author Shashank P, Praveen Gupta, Ashwin Joisa
*/

%{

#define trace(fmt, args...) //fprintf(stderr, fmt, ##args)

#include "y.tab.h"
#include "lib/misc.h"

int scope = 0;
%}

keyword         char|int|float|short|long|unsigned|signed|main|while|for|break|case|if|else|continue|default|do|return|void|struct|switch
number          [0-9]
letter          [a-zA-Z]
operator        [+-<>*=/!%^&.]
function        (_|{letter})({letter}|{number}|_)*"()"

%option yylineno


%%
\/\/(.)*[\n]                        {
                                    //yylineno++;
                                    }

"/*"                                { comment(); }

#                                   {  
                                        trace("%-20s%20s%20d\n","PREPROCESSOR", yytext, yylineno);
                                        return *yytext;  
                                        
                                    }

include                             {  
                                        trace("%-20s%20s%20d\n","PREPROCESSOR", yytext, yylineno);
                                        return INCLUDE;  
                                        
                                    }

[\n]                                {
                                        //yylineno++; 
                                    }

[{]                                 { 
                                            trace("%-20s%20s%20d\n","LEFT BRACE", yytext, yylineno);
                                            scope++;
                                            return *yytext;
                                        
                                    }
[}]                                 { 
                                            trace("%-20s%20s%20d\n","RIGHT BRACE", yytext, yylineno);
                                            scope--;
                                            return *yytext;
                                        
                                    }

\"[^"\n]*["\n]                      { 
                                        if(yytext[yyleng-1]!='"'){
                                            trace(FORE_RED "Error : Quote unbalanced at line number %d\n" RESET,yylineno);
                                            //yylineno++;
                                        }
                                        trace("%-20s%20s%20d\n", "CONSTANT_STRING", yytext, yylineno);
                                        strcpy(yylval.id, yytext);
                                        return CONSTANT_STRING;
                                      
                                    }

int                                 { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return INT;
                                      
                                    }

float                               { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return FLOAT;
                                      
                                    }
char                                { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return CHAR;
                                      
                                    }
double                              { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return DOUBLE;
                                      
                                    }
void                                { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return VOID;
                                      
                                    }
signed                              { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return SIGNED;
                                      
                                    }
unsigned                            { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return UNSIGNED;
                                      
                                    }
long                                { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return LONG;
                                      
                                    }
short                               { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return SHORT;
                                      
                                    }
switch                              { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return SWITCH;
                                      
                                    }
break                               { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return BREAK;
                                      
                                    }
continue                            { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return CONTINUE;
                                    }
case                                { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return CASE;
                                    }
default                             { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return DEFAULT;
                                      
                                    }
for                                 { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return FOR;
                                      
                                    }
while                               { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return WHILE;
                                      
                                    }
do                                  { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return DO;
                                      
                                    }
if                                  { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return IF;
                                      
                                    }
else                                { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return ELSE;
                                    }
struct                              { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return STRUCT;
                                    }
return                              { 
                                        trace("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return RETURN;
                                    }
                                                                                                            

[(]                                 { 
                                        trace("%-20s%20s%20d\n", "OPEN PARANTHESIS", yytext, yylineno);
                                        return *yytext;
                                    }

[)]                                 { 
                                        trace("%-20s%20s%20d\n", "CLOSE PARANTHESIS", yytext, yylineno);
                                        return *yytext;
                                    }
[\[]                                { 
                                        trace("%-20s%20s%20d\n", "SQUARE BRACKETS", yytext, yylineno);
                                        return *yytext;
                                    }

[\]]                                { 
                                        trace("%-20s%20s%20d\n", "SQUARE BRACKETS", yytext, yylineno);
                                        return *yytext;
                                    }

[,]                                 { 
                                        trace("%-20s%20s%20d\n", "COMMA", yytext, yylineno);
                                        return *yytext;
                                    } 


[\t ]                               { ; }

[;]                                 { 
                                        trace("%-20s%20s%20d\n", "SEMI COLON", yytext, yylineno);
                                        return *yytext;
                                    }

\'.\'                               { 
                                        trace("%-20s%20s%20d\n", "CHARACTER", yytext, yylineno); 
                                        // strcpy(yylval, yytext);
                                        strcpy(yylval.id, yytext);
                                        return CONSTANT_CHAR;
                                    }

{number}+(\.{number}+)?e{number}+    { 
                                        trace("%-20s%20s%20d\n", "FLOAT EXP FORM", yytext, yylineno); 
                                        // yylval = atof(yytext);
                                        strcpy(yylval.id, yytext);
                                        return CONSTANT_FLOAT;
                                    } 

{number}+\.{number}+                { 
                                        trace("%-20s%20s%20d\n", "FLOAT NUMBER", yytext, yylineno); 
                                        //yylval = atof(yytext);
                                        strcpy(yylval.id, yytext);
                                        return CONSTANT_FLOAT;
                                    } 


{number}+                           { 
                                        trace("%-20s%20s%20d\n", "NUMBER", yytext, yylineno); 
                                       // yylval = atoi(yytext);
                                        strcpy(yylval.id, yytext);
                                        return CONSTANT_INTEGER;
                                    }    

(_|{letter})({letter}|{number}|_)*  { 
                                        trace("%-20s%20s%20d\n", "IDENTIFIER", yytext, yylineno);
                                        strcpy(yylval.id, yytext);
                                        return IDENTIFIER;
                                    }

"+"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }
"-"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }
"*"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }
"/"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }

"%"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }

"^"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }

"&"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }
"."                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }                   
"=="                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return EQ;
                                    }
"="                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                    }
"!="                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return NE;
                                    }
"<"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LT;
                                    }
">"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return GT;
                                    }
"<="                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LE;
                                    }

"+="                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return ADD_ASSIGN;
                                    }

"-="                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return SUB_ASSIGN;
                                    }

"*="                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return MUL_ASSIGN;
                                    }
                                    
"/="                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return DIV_ASSIGN;
                                    }
"%="					            { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return MOD_ASSIGN;
                                    }

">>="					            { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return RIGHT_ASSIGN;
                                    }
"<<="					            { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LEFT_ASSIGN;
                                    }

"&="					            { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return AND_ASSIGN;
                                    }
"^="					            { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return XOR_ASSIGN;
                                    }
"|="					            { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return OR_ASSIGN;
                                    }

">="                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return GE;
                                    }
"&&"                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LOGIC_AND;
                                    }
"||"                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LOGIC_OR;
                                    }
"!"                                 { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return NOT;
                                    }
  
"++"                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return INC_OP;
                                    }  
"--"                                { 
                                        trace("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return DEC_OP;
                                    }  
                                                                      



{number}({letter}|{number}|_)+      { trace(FORE_RED "Error : Invalid Token %s at Line %d\n" RESET, yytext, yylineno); }

.                                   { trace(FORE_RED "Error : Invalid Token %s at Line %d\n" RESET, yytext, yylineno); }

%%


int yywrap(){
  return 1;
}


void comment()
{
    int c;

    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
                return;

            if (c == 0)
                break;
        }
    yyerror("Unterminated comment");
}
