/*
* Parser for C language
*
* http://www.quut.com/c/ANSI-C-grammar-y.html
*
* @author Shashank P, Praveen Gupta, Ashwin Joisa
*/

%{
#include <stdio.h>
#include <stdlib.h>

#include "lib/symbol_table.h"
#include "lib/misc.h"

// Trace function with variable number of arguement
#define trace(fmt, args...) fprintf(stderr, fmt, ##args)
void yyerror(const char * s);

#define MAX_NODES 1000

symbol_node_t *symbol_table[MAX_NODES];
symbol_node_t *constant_table[MAX_NODES];

extern char *yytext;
extern int yylineno;

char type[100];

%}

// %token INT FLOAT CHAR DOUBLE VOID RETURN
%token SIGNED UNSIGNED LONG SHORT
%token SWITCH BREAK CONTINUE CASE DEFAULT STRUCT RETURN
%token FOR WHILE DO
%token IF ELSE  
%token <id> CONSTANT_INTEGER
%token <id> CONSTANT_FLOAT
%token <id> CONSTANT_STRING
%token <id> CONSTANT_CHAR

%token INCLUDE

%union {
	char id[100];
}

%token <id> IDENTIFIER
%token <id> INT
%token <id> CHAR
%token <id> FLOAT
%token <id> DOUBLE
%token <id> VOID


%right '=' ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN         
%left LOGIC_AND LOGIC_OR NOT INC_OP DEC_OP
%left LE GE EQ NE LT GT             // LE <= GE >= EQ == NE != LT < GT >
%left '+' '-' '*' '/' '%' '^' '&' '.'

%start Begin

%% 
Begin   
	: Function_Definition
	| Declaration
	| Include
	| Function_Definition Begin
	| Declaration Begin
	| Include Begin
	;

Include_Statement
	: '#' INCLUDE LT IDENTIFIER GT
	| '#' INCLUDE LT IDENTIFIER '.' IDENTIFIER GT
	;

Include
	: Include_Statement
	;

Function_Definition
	: Type IDENTIFIER '(' Formal_Param_List ')' Compound_Statement       {                            
                                            char funcType[100] = "Function: ";
                                            strcat(funcType, type);
                                            symbol_table_insert(symbol_table,$2, funcType, yylineno);
                                        }
	;

Formal_Param_List
	: Type IDENTIFIER                                  {symbol_table_insert(symbol_table,$2,type,yylineno);trace("FLIST Call 1\n");}
	| Type '*' IDENTIFIER                              {symbol_table_insert(symbol_table,$3,type,yylineno);trace("FLIST Call 2\n");}
	| Type Array_Notation                              {trace("FLIST Call 3\n");}
	| Type IDENTIFIER ',' Formal_Param_List            {symbol_table_insert(symbol_table,$2,type,yylineno);trace("FLIST Call 4\n");}
	| Type '*' IDENTIFIER ',' Formal_Param_List        {symbol_table_insert(symbol_table,$3,type,yylineno);trace("FLIST Call 5\n");}
	| Type Array_Notation ',' Formal_Param_List        {trace("FLIST Call 6\n");}
	|
	;


Declaration
    :  Type Identifier_List ';'    {;}
    ;

Type
    : INT                       {strcpy(type, $1);}
    | FLOAT                     {strcpy(type, $1);}
    | VOID                      {strcpy(type, $1);}
    | CHAR                      {strcpy(type, $1);}
    | DOUBLE                    {strcpy(type, $1);}
    | Modifiers INT             {strcpy(type, $2);}
    | Modifiers FLOAT           {strcpy(type, $2);}
    | Modifiers DOUBLE          {strcpy(type, $2);}
    | Modifiers CHAR            {strcpy(type, $2);}
    ;

Modifiers
    : SHORT | LONG | UNSIGNED | SIGNED
    ;

Array_Notation
    : IDENTIFIER '[' ']'            {   
                                        char arrayType[100] = "Array: ";
                                        strcat(arrayType, type);
                                        symbol_table_insert(symbol_table, $1, arrayType, yylineno);
                                    }
    | IDENTIFIER '[' Expression ']' {   
                                        char arrayType[100] = "Array: ";strcat(arrayType, type);
                                        symbol_table_insert(symbol_table,$1, arrayType,yylineno);
                                    }
    | '*' IDENTIFIER '[' Expression ']' {   
                                        int len = strlen(type);
                                        type[len] = '*';
                                        type[len +1] = '\0';                                
                                        char arrayType[100] = "Array: ";strcat(arrayType, type);
                                        symbol_table_insert(symbol_table,$2, arrayType,yylineno);
                                        type[len] = '\0';
                                    }
    | '&' IDENTIFIER '[' Expression ']' {
                                        char arrayType[100] = "Array: ";strcat(arrayType, type);
                                        symbol_table_insert(symbol_table,$2, arrayType,yylineno);
                                    }
    ;

Identifier_List
    : Array_Notation
    | IDENTIFIER ',' Identifier_List        {symbol_table_insert(symbol_table,$1,type,yylineno);}
    | '*' IDENTIFIER ',' Identifier_List    {
                                                int len = strlen(type);
                                                type[len] = '*';
                                                type[len +1] = '\0';
                                                symbol_table_insert(symbol_table,$2,type,yylineno);
                                                type[len] = '\0';
                                            }
    | Array_Notation ',' Identifier_List 
    | IDENTIFIER                            {symbol_table_insert(symbol_table,$1,type,yylineno);} 
    | '*' IDENTIFIER                        {
                                                int len = strlen(type);
                                                type[len] = '*';
                                                type[len +1] = '\0';
                                                symbol_table_insert(symbol_table,$2,type,yylineno);
                                                type[len] = '\0';
                                            }
    | Define_Assign ',' Identifier_List
    | Define_Assign 
    ;

Define_Assign
    : IDENTIFIER Assignment_Operator Expression          {symbol_table_insert(symbol_table,$1,type,yylineno);trace("Assignment Rule 1 called\n");}  
    | '*' IDENTIFIER Assignment_Operator Expression      {symbol_table_insert(symbol_table,$2,type,yylineno);}
    | Array_Notation Assignment_Operator Expression                   
    ;

Param_List
    : Expression
    | Expression ',' Param_List
    | 
    ;

Assignment
    : IDENTIFIER Assignment_Operator Expression           {trace("Assignment Rule 1 called\n");}
    | '*' IDENTIFIER Assignment_Operator Expression         
    | Array_Notation Assignment_Operator Expression
    | Primary
    ;

Assignment_Operator
	: '='
    | ADD_ASSIGN
    | SUB_ASSIGN
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;


Expression
    : Logical_Expr
    ;


Logical_Expr
    : Relational_Expr
    | Logical_Expr LOGIC_AND Relational_Expr
    | Logical_Expr LOGIC_OR Relational_Expr
    | NOT Relational_Expr 
    ;

Relational_Expr
    : Additive_Expr
    | Relational_Expr GT Additive_Expr
    | Relational_Expr LT Additive_Expr
    | Relational_Expr GE Additive_Expr
    | Relational_Expr LE Additive_Expr
    | Relational_Expr EQ Additive_Expr
    | Relational_Expr NE Additive_Expr
    ;

Additive_Expr
    : Multiplicative_Expr
    | Additive_Expr '+' Multiplicative_Expr
    | Additive_Expr '-' Multiplicative_Expr
    ;

Multiplicative_Expr
    : Primary
    | Multiplicative_Expr '*' Primary
    | Multiplicative_Expr '/' Primary
    | Multiplicative_Expr '%' Primary
    ;

Primary
    : '(' Expression ')'
    | CONSTANT_INTEGER     {symbol_table_insert(constant_table, $1, "int", yylineno); trace("CONSTANT_INTEGER\n");}
    | CONSTANT_FLOAT       {symbol_table_insert(constant_table, $1, "float", yylineno); trace("CONSTANT_FLOAT\n");}
    | CONSTANT_CHAR        {symbol_table_insert(constant_table, $1, "char", yylineno); trace("CONSTANT_CHAR\n");}
    | CONSTANT_STRING      {symbol_table_insert(constant_table, $1, "string", yylineno); trace("CONSTANT_STRING\n");}
    | IDENTIFIER           {trace("Primary Identifier\n");}
    | '*' IDENTIFIER       {trace("Pointer Identifier\n");}
    | '&' IDENTIFIER       {trace("Address of Identifier\n");}
    | '-' Primary
    | '+' Primary
    | Array_Notation
    | Function_Call
    | INC_OP IDENTIFIER
    | IDENTIFIER INC_OP
    | DEC_OP IDENTIFIER
    | IDENTIFIER DEC_OP
    ;

Compound_Statement
    : '{' Statement_List '}'
	;

Statement_List
    : Statement Statement_List
    |
    ;

Statement
    : While_Statement 
    | Declaration   
    | For_Statement  
    | If_Statement  
    | Assignment    ';'
    | Return_Statement    
    | Do_While_Statement      
    | BREAK ';'
    | CONTINUE ';'                    
	| ';'
    ; 

Return_Statement
    : RETURN Expression ';'   {trace("Return Statement Call\n");}
    ;

While_Statement
    : WHILE '(' Expression ')' Statement                                                        
    | WHILE '(' Expression ')' Compound_Statement
    ;

Do_While_Statement
    : DO Compound_Statement WHILE '(' Expression ')' ';'
    ;


For_Statement
    : FOR '(' Assignment ';' Expression ';' Assignment ')' Statement 
    | FOR '(' Assignment ';' Expression ';' Assignment ')' Compound_Statement 
    ;

If_Statement
    : IF '(' Expression ')' Statement Else_Statement     
    | IF '(' Expression ')' Compound_Statement Else_Statement
    ;

Else_Statement
    : ELSE Compound_Statement
    | ELSE Statement
    |
    ;

Function_Call
    : IDENTIFIER '(' Param_List ')'     {symbol_table_insert(symbol_table, $1, "Function", yylineno);trace("Function Call\n");} 
    ;

%%


int main()
{
    symbol_table_initialize(symbol_table);
    symbol_table_initialize(constant_table);

    if(!yyparse())
        printf("\nParsing complete\n");
    else
        printf(FORE_RED "\nParsing failed\n" RESET);

    symbol_table_print(symbol_table, "Symbol Table");
    symbol_table_print(constant_table, "Constant Table");
    
    symbol_table_free(symbol_table);
    symbol_table_free(constant_table);

    return 0;
}
         
void yyerror(const char *s) {
	printf(FORE_RED "%d : %s %s\n" RESET, yylineno, s, yytext );
}
