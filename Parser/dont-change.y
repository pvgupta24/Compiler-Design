%{
#include <stdio.h>
#include <stdlib.h>

#include "lib/symbol_table.h"

#define DEBUGY 0

#if defined(DEBUGY) && DEBUGY > 0
        #define DEBUGY_PRINT(fmt, args...) fprintf(stderr, fmt, ##args)
#else
        #define DEBUGY_PRINT(fmt, args...) /* Don't do anything in release builds */
#endif


#define RED   "\x1B[31m"
#define RESET "\x1B[0m"
#define GRN   "\x1B[32m"
#define BLU   "\x1B[34m"


int yyparse (void);
int yylex();
void yyerror(const char * s);

#define MAX_NODES 1000

   symbol_node_t *symbol_table[MAX_NODES];
   symbol_node_t *constant_table[MAX_NODES];



extern FILE *yyin, *yyout;

extern char *yytext;

extern int lineNo;

char type[100];

%}


// %token INT FLOAT CHAR DOUBLE VOID RETURN
%token SIGNED UNSIGNED LONG SHORT
%token SWITCH BREAK CONTINUE CASE DEFAULT STRUCT RETURN
%token FOR WHILE DO
%token IF ELSE  
%token NUM FLOATNUM STRING CHARCONST
%token INCLUDE
%token OPEN_PAR CLOSE_PAR

%union {
	char id[100];
}
%token <id> ID
%token <id> INT
%token <id> CHAR
%token <id> FLOAT
%token <id> DOUBLE
%token <id> VOID


%right '=' PAS MAS DAS SAS           
%left AND OR NOT PP MM
%left LE GE EQ NE LT GT                        // LE <= GE >= EQ == NE != LT < GT >
%left '+' '-' '*' '/' '%' '^' '&' '.'  
%start start

%% 
start:	FunctionDef
	| Declaration
        | Include
        | FunctionDef start
        | Declaration start
        | Include start
	;

IncludeStatement: '#' INCLUDE LT ID GT
                  | '#' INCLUDE LT ID '.' ID GT
                  ;
Include:   IncludeStatement
           ;

FunctionDef: Type ID OPEN_PAR FormalParamList CLOSE_PAR CompoundStatement       {symbol_table_insert(symbol_table,$2,"function",lineNo);}
             ;
FormalParamList: Type ID                                        {symbol_table_insert(symbol_table,$2,type,lineNo);DEBUGY_PRINT("FLIST Call 1\n");}
                | Type '*' ID                                   {symbol_table_insert(symbol_table,$3,type,lineNo);DEBUGY_PRINT("FLIST Call 2\n");}
                | Type ArrayNotation                            {DEBUGY_PRINT("FLIST Call 3\n");}
                | Type ID ',' FormalParamList                   {symbol_table_insert(symbol_table,$2,type,lineNo);DEBUGY_PRINT("FLIST Call 4\n");}
                | Type '*' ID ',' FormalParamList               {symbol_table_insert(symbol_table,$3,type,lineNo);DEBUGY_PRINT("FLIST Call 5\n");}
                | Type ArrayNotation ',' FormalParamList        {DEBUGY_PRINT("FLIST Call 6\n");}
                |
                ;


Declaration:  Type IDList ';'    {;}
        ;

Type: INT {strcpy(type,$1);}| FLOAT {strcpy(type,$1);}| VOID {strcpy(type,$1);}| CHAR {strcpy(type,$1);}| DOUBLE {strcpy(type,$1);}| 
        Modifiers INT {strcpy(type,$2);}| Modifiers FLOAT {strcpy(type,$2);}| Modifiers DOUBLE {strcpy(type,$2);}| Modifiers CHAR {strcpy(type,$2);}
        ;
Modifiers: SHORT | LONG | UNSIGNED | SIGNED
        ;

ArrayNotation: ID '[' ']' {char ar[] = "arr - "; symbol_table_insert(symbol_table,$1,strcat(ar, type),lineNo);}
            | ID '[' Expr ']' {char ar[] = "arr - "; symbol_table_insert(symbol_table,$1,strcat(ar, type),lineNo);}
            ;

IDList: ArrayNotation
        | ID ',' IDList {symbol_table_insert(symbol_table,$1,type,lineNo);}
        | '*' ID ',' IDList {symbol_table_insert(symbol_table,$2,type,lineNo);}
        | ArrayNotation ',' IDList 
        | ID {symbol_table_insert(symbol_table,$1,type,lineNo);} 
        | '*' ID {symbol_table_insert(symbol_table,$2,type,lineNo);}
        | DefineAssign ',' IDList
        | DefineAssign 
        ;

DefineAssign: ID '=' Expr                   {DEBUGY_PRINT("Assignment Rule 1 called\n");}
            | ID PAS Expr  
            | ID SAS Expr  
            | ID MAS Expr  
            | ID DAS Expr  
            | '*' ID '=' Expr           
            | '*' ID PAS Expr  
            | '*' ID SAS Expr  
            | '*' ID MAS Expr  
            | '*' ID DAS Expr
            | ArrayNotation '=' Expr                   
            | ArrayNotation PAS Expr  
            | ArrayNotation SAS Expr  
            | ArrayNotation MAS Expr  
            | ArrayNotation DAS Expr
            ;


ParamList: Expr
        | Expr ',' ParamList
        | 
        ;

Assignment: ID '=' Expr                   {DEBUGY_PRINT("Assignment Rule 1 called\n");}
            | ID PAS Expr  
            | ID SAS Expr  
            | ID MAS Expr  
            | ID DAS Expr  
            | '*' ID '=' Expr           
            | '*' ID PAS Expr  
            | '*' ID SAS Expr  
            | '*' ID MAS Expr  
            | '*' ID DAS Expr
            | ArrayNotation '=' Expr                   
            | ArrayNotation PAS Expr  
            | ArrayNotation SAS Expr  
            | ArrayNotation MAS Expr  
            | ArrayNotation DAS Expr
            | Primary   
            ;

Expr: Logical_Expr
      ;


Logical_Expr: Relational_Expr
              | Logical_Expr AND Relational_Expr
              | Logical_Expr OR Relational_Expr
              | NOT Relational_Expr 
              ;

Relational_Expr: Additive_Expr
                 | Relational_Expr GT Additive_Expr
                 | Relational_Expr LT Additive_Expr
                 | Relational_Expr GE Additive_Expr
                 | Relational_Expr LE Additive_Expr
                 | Relational_Expr EQ Additive_Expr
                 | Relational_Expr NE Additive_Expr
                 ;


Additive_Expr: Multiplicative_Expr
               | Additive_Expr '+' Multiplicative_Expr
               | Additive_Expr '-' Multiplicative_Expr
               ;
Multiplicative_Expr: Primary
                     | Multiplicative_Expr '*' Primary
                     | Multiplicative_Expr '/' Primary
                     | Multiplicative_Expr '%' Primary
                     ;
Primary: OPEN_PAR Expr CLOSE_PAR
         | NUM | FLOATNUM | CHARCONST | STRING 
         | ID                           {DEBUGY_PRINT("Primary Identifier\n");}
         | '*' ID                       {DEBUGY_PRINT("Pointer Identifier\n");}
         | '&' ID                       {DEBUGY_PRINT("Address of Identifier\n");}
         | '-' Primary
         | '+' Primary
         | ArrayNotation
         | FunctionCall
         | PP ID
         | ID PP
         | MM ID
         | ID MM
         ;

CompoundStatement: '{' StatementList '}'
	;
StatementList: Statement StatementList
               |
               ;

Statement: WhileStatement 
	| Declaration   
	| ForStatement  
	| IfStatement  
        | Assignment    ';'
        | ReturnStatement    
        | DoWhileStatement      
        | BREAK ';'
        | CONTINUE ';'                    
	| ';'
        ; 
ReturnStatement: RETURN Expr ';'   {DEBUGY_PRINT("Return Statement Call\n");}
                 ;

WhileStatement: WHILE OPEN_PAR Expr CLOSE_PAR Statement                                                        
                | WHILE OPEN_PAR Expr CLOSE_PAR CompoundStatement
                ;

DoWhileStatement: DO CompoundStatement WHILE OPEN_PAR Expr CLOSE_PAR ';'
                  ;


ForStatement: FOR OPEN_PAR Assignment ';' Expr ';' Assignment CLOSE_PAR Statement 
              | FOR OPEN_PAR Assignment ';' Expr ';' Assignment CLOSE_PAR CompoundStatement 
              ;

IfStatement: IF OPEN_PAR Expr CLOSE_PAR Statement ElseStatement
             | IF OPEN_PAR Expr CLOSE_PAR CompoundStatement ElseStatement
             ;

ElseStatement: ELSE CompoundStatement
               | ELSE Statement
               |
               ;

FunctionCall: ID OPEN_PAR ParamList CLOSE_PAR           {DEBUGY_PRINT("Function Call\n");} 
                ;

%%
#include<ctype.h>
int count=0;

int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	
   if(!yyparse())
		printf("\nParsing complete\n");
	else
		printf(RED "\nParsing failed\n" RESET);
	
	fclose(yyin);

	symbol_table_print(symbol_table, "Symbol Table");
    symbol_table_print(constant_table, "Constant Table");
    return 0;
}
         
void yyerror(const char *s) {
	printf(RED "%d : %s %s\n" RESET, lineNo, s, yytext );
}