%{

    #define DEBUG 0

    #if defined(DEBUG) && DEBUG > 0
        #define DEBUG_PRINT(fmt, args...) fprintf(stderr, fmt, ##args)
    #else
        #define DEBUG_PRINT(fmt, args...) /* Don't do anything in release builds */
    #endif

    #define RED   "\x1B[31m"
    #define RESET "\x1B[0m"
    #define GRN   "\x1B[32m"
    #define BLU   "\x1B[34m"

    #include "y.tab.h"

    int scope = 0;
    // int yylineno = 1;
    int comment = 0;
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

[/][*]                              { DEBUG_PRINT("%-20s%20s%20d\n", "OPEN COMMENT",yytext, yylineno); comment++; }
[*][/]                              { DEBUG_PRINT("%-20s%20s%20d\n", "CLOSE COMMENT",yytext, yylineno); comment--; }


#                                   { if(!comment){ 
                                            DEBUG_PRINT("%-20s%20s%20d\n","PREPROCESSOR", yytext, yylineno);
                                            return *yytext;  
                                        }
                                    }

include                             { if(!comment){ 
                                            DEBUG_PRINT("%-20s%20s%20d\n","PREPROCESSOR", yytext, yylineno);
                                            return INCLUDE;  
                                        }
                                    }

[\n]                                { //yylineno++; 
                                    }

[{]                                 { if(!comment){
                                            DEBUG_PRINT("%-20s%20s%20d\n","LEFT BRACE", yytext, yylineno);
                                            scope++;
                                            return *yytext;
                                        }  
                                    }
[}]                                 { if(!comment){
                                            DEBUG_PRINT("%-20s%20s%20d\n","RIGHT BRACE", yytext, yylineno);
                                            scope--;
                                            return *yytext;
                                        }  
                                    }

\"[^"\n]*["\n]                      { if(!comment) {
                                        if(yytext[yyleng-1]!='"'){
                                            DEBUG_PRINT(RED "Error : Quote unbalanced at line number %d\n" RESET,yylineno);
                                            //yylineno++;
                                        }
                                        DEBUG_PRINT("%-20s%20s%20d\n", "CONSTANT_STRING", yytext, yylineno);
                                        // strcpy(yylval, yytext);
                                        //insertSymbolItem(yytext, "CONSTANT_STRING", yylineno, 1);
                                        return CONSTANT_STRING;
                                      }
                                    }

int                                 { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return INT;
                                      }
                                    }

float                              { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return FLOAT;
                                      }
                                    }
char                               { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return CHAR;
                                      }
                                    }
double                             { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return DOUBLE;
                                      }
                                    }
void                               { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
										strcpy(yylval.id, yytext);
                                        return VOID;
                                      }
                                    }
signed                             { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return SIGNED;
                                      }
                                    }
unsigned                           { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return UNSIGNED;
                                      }
                                    }
long                               { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return LONG;
                                      }
                                    }
short                              { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return SHORT;
                                      }
                                    }
switch                             { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return SWITCH;
                                      }
                                    }
break                              { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return BREAK;
                                      }
                                    }
continue                           { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return CONTINUE;
                                      }
                                    }
case                               { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return CASE;
                                      }
                                    }
default                           { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return DEFAULT;
                                      }
                                    }
for                                { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return FOR;
                                      }
                                    }
while                              { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return WHILE;
                                      }
                                    }
do                                 { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return DO;
                                      }
                                    }
if                                 { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return IF;
                                      }
                                    }
else                               { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return ELSE;
                                      }
                                    }
struct                             { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return STRUCT;
                                      }
                                    }
return                             { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "KEYWORD", yytext, yylineno);
                                        return RETURN;
                                      }
                                    }
                                                                                                            

[(]                                 { if(!comment) {
                                            DEBUG_PRINT("%-20s%20s%20d\n", "OPEN PARANTHESIS", yytext, yylineno);
                                            return *yytext;
                                            // return OPEN_PAR;
                                        }
                                    }

[)]                                 { if(!comment) {
                                            DEBUG_PRINT("%-20s%20s%20d\n", "CLOSE PARANTHESIS", yytext, yylineno);
                                            return *yytext;
                                            // return CLOSE_PAR;
                                        }
                                    }
[\[]                                { if(!comment) {
                                            DEBUG_PRINT("%-20s%20s%20d\n", "SQUARE BRACKETS", yytext, yylineno);
                                            return *yytext;
                                        } 
                                    }

[\]]                                { if(!comment) {
                                            DEBUG_PRINT("%-20s%20s%20d\n", "SQUARE BRACKETS", yytext, yylineno);
                                            return *yytext;
                                        } 
                                    }

[,]                                 { if(!comment) {
                                            DEBUG_PRINT("%-20s%20s%20d\n", "COMMA", yytext, yylineno);
                                            return *yytext;
                                        } 
                                    } 


[\t ]                               { ; }

[;]                                 { if(!comment) {
                                            DEBUG_PRINT("%-20s%20s%20d\n", "SEMI COLON", yytext, yylineno);
                                            return *yytext;
                                        } 
                                    }

\'.\'                               { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "CHARACTER", yytext, yylineno); 
                                        //insertSymbolItem(yytext, "CHARACTER", yylineno, 1);
                                        // strcpy(yylval, yytext);
                                        return CONSTANT_CHAR;
                                        }
                                    }

{number}+(\.{number}+)?e{number}+    { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "FLOAT EXP FORM", yytext, yylineno); 
                                        //insertSymbolItem(yytext, "FLOAT", yylineno, 1);
                                        // yylval = atof(yytext);
                                        return CONSTANT_FLOAT;
                                        }
                                    } 

{number}+\.{number}+                { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "FLOAT NUMBER", yytext, yylineno); 
                                        //insertSymbolItem(yytext, "FLOAT", yylineno, 1);
                                        //yylval = atof(yytext);
                                        return CONSTANT_FLOAT;
                                        }
                                    } 


{number}+                           { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "NUMBER", yytext, yylineno); 
                                        //insertSymbolItem(yytext, "INTEGER", yylineno, 1);
                                       // yylval = atoi(yytext);
                                        return INTEGER_FLOAT;
                                        }
                                    }    

(_|{letter})({letter}|{number}|_)*  { if(!comment){
                                        DEBUG_PRINT("%-20s%20s%20d\n", "IDENTIFIER", yytext, yylineno);
                                        /*if(!lookUpSymbolItem(yytext))
                                            insertSymbolItem(yytext, "IDENTIFIER", yylineno, 0);*/
									
                                        strcpy(yylval.id, yytext);
                                        return IDENTIFIER;
                                      }
                                    }

"+"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                        }                   
                                    }
"-"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                        }                   
                                    }
"*"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                        }                   
                                    }
"/"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                        }                   
                                    }

"%"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                        }                   
                                    }

"^"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                        }                   
                                    }

"&"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                        }                   
                                    }
"."                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                        }                   
                                    }
"=="                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return EQ;
                                        }                   
                                    }
"="                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return *yytext;
                                        }                   
                                    }
"!="                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return NE;
                                        }                   
                                    }
"<"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LT;
                                        }                   
                                    }
">"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return GT;
                                        }                   
                                    }
"<="                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LE;
                                        }                   
                                    }

"+="                                { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return ADD_ASSIGN;
                                        }                   
                                    }

"-="                                { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return SUB_ASSIGN;
                                        }                   
                                    }

"*="                                { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return MUL_ASSIGN;
                                        }                   
                                    }
                                    
"/="                                { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return DIV_ASSIGN;
                                        }                   
                                    }
"%="					            { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return MOD_ASSIGN;
                                        }  
                                    }

">>="					            { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return RIGHT_ASSIGN;
                                        }  
                                    }
"<<="					            { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LEFT_ASSIGN;
                                        }  
                                    }

"&="					            { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return AND_ASSIGN;
                                        }  
                                    }
"^="					            { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return XOR_ASSIGN;
                                        }  
                                    }
"|="					            { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return OR_ASSIGN;
                                        }  
                                    }

">="                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return GE;
                                        }                   
                                    }
"&&"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LOGIC_AND;
                                        }                   
                                    }
"||"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return LOGIC_OR;
                                        }                   
                                    }
"!"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return NOT;
                                        }                   
                                    }
  
"++"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return INC_OP;
                                        }                   
                                    }  
"--"                                 { if(!comment) {
                                        DEBUG_PRINT("%-20s%20s%20d\n", "OPERATOR", yytext, yylineno); 
                                        return DEC_OP;
                                        }                   
                                    }  
                                                                      



{number}({letter}|{number}|_)+      { if(!comment) DEBUG_PRINT(RED "Error : Invalid Token %s at Line %d\n" RESET, yytext, yylineno); }

.                                   { if(!comment) DEBUG_PRINT(RED "Error : Invalid Token %s at Line %d\n" RESET, yytext, yylineno); }

%%


int yywrap(){
  return 1;
}
/*
int main(int argc, char** argv){
    if(argc < 2){
        DEBUG_PRINT(RED "Pass input file as command line argument\n" RESET);
        exit(0);
    }
    initSymbolTable();
    yyin = fopen(argv[1], "r");
    DEBUG_PRINT("\n\n-----------------------------------------------------------------\n");
    DEBUG_PRINT(BLU "%-20s%20s%24s\n", "TOKEN VALUE", "TOKEN TYPE", "LINE NUMBER" RESET);
    DEBUG_PRINT("-----------------------------------------------------------------\n");
    yylex();

    if(comment)
        DEBUG_PRINT(RED "Error : Error in parsing comments" RESET);

    DEBUG_PRINT(GRN "\n\nSYMBOL TABLE" RESET);
    showSymbolTable();
    DEBUG_PRINT(GRN "\n\nCONSTANT TABLE" RESET);
    showConstantTable();
    DEBUG_PRINT("\n\n");
}
*/

