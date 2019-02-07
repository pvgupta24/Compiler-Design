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
#define trace(fmt, args...) //fprintf(stderr, fmt, ##args)
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
%token SWITCH BREAK CONTINUE CASE DEFAULT RETURN
%token FOR WHILE DO
%token IF ELSE  
%token <char_ptr> CONSTANT_INTEGER
%token <char_ptr> CONSTANT_FLOAT
%token <char_ptr> CONSTANT_STRING
%token <char_ptr> CONSTANT_CHAR

%token INCLUDE

%union {
	char char_ptr[100];
}

%token <char_ptr> IDENTIFIER
%token <char_ptr> INT
%token <char_ptr> CHAR
%token <char_ptr> FLOAT
%token <char_ptr> DOUBLE
%token <char_ptr> VOID


%right '=' ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN         
%left LOGIC_AND LOGIC_OR NOT INC_OP DEC_OP
%left LESSER_EQUAL GREATER_EQUAL DOUBLE_EQUAL NOT_EQUAL LESSER_THAN GREATER_THAN             
%left '+' '-' '*' '/' '%' '^' '&' 

%start Begin

%% 
Begin   
    : Include
    | Include Begin
    | Declaration
    | Declaration Begin
	| Function_Definition
    | Function_Definition Begin
	;

Declaration
    :  Type Identifier_List ';'    
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

Function_Definition
	: Type IDENTIFIER '(' Formal_Param_List ')' Compound_Statement      {                            
                                                                            char funcType[100] = "Function: ";
                                                                            strcat(funcType, type);
                                                                            symbol_table_insert(symbol_table,$2, funcType, yylineno);
                                                                        }
	;

Formal_Param_List
	: Type IDENTIFIER                                  {symbol_table_insert(symbol_table,$2,type,yylineno);trace("Formal_Param_List Rule 1\n");}
	| Type '*' IDENTIFIER                              {symbol_table_insert(symbol_table,$3,type,yylineno);trace("Formal_Param_List Rule 2\n");}
	| Type Array_Notation                              {trace("Formal_Param_List Rule 3\n");}
	| Type IDENTIFIER ',' Formal_Param_List            {symbol_table_insert(symbol_table,$2,type,yylineno);trace("Formal_Param_List Rule 4\n");}
	| Type '*' IDENTIFIER ',' Formal_Param_List        {symbol_table_insert(symbol_table,$3,type,yylineno);trace("Formal_Param_List Rule 5\n");}
	| Type Array_Notation ',' Formal_Param_List        {trace("Formal_Param_List Rule 6\n");}
	|
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



Define_Assign
    : IDENTIFIER Assignment_Operator Expression          {symbol_table_insert(symbol_table,$1,type,yylineno);trace("Define_Assign Rule 1\n");}  
    | '*' IDENTIFIER Assignment_Operator Expression      {symbol_table_insert(symbol_table,$2,type,yylineno);}
    | Array_Notation Assignment_Operator Expression                   
    ;

Param_List
    : Expression
    | Expression ',' Param_List
    | 
    ;

Assignment
    : IDENTIFIER Assignment_Operator Expression           {trace("Assignment Rule 1\n");}
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
    : Logical_Expression
    ;

Logical_Expression
    : Relational_Expression
    | Logical_Expression LOGIC_AND Relational_Expression
    | Logical_Expression LOGIC_OR Relational_Expression
    | NOT Relational_Expression 
    ;

Relational_Expression
    : Additive_Expression
    | Relational_Expression GREATER_THAN Additive_Expression
    | Relational_Expression LESSER_THAN Additive_Expression
    | Relational_Expression GREATER_EQUAL Additive_Expression
    | Relational_Expression LESSER_EQUAL Additive_Expression
    | Relational_Expression DOUBLE_EQUAL Additive_Expression
    | Relational_Expression NOT_EQUAL Additive_Expression
    ;

Additive_Expression
    : Multiplicative_Expression
    | Additive_Expression '+' Multiplicative_Expression
    | Additive_Expression '-' Multiplicative_Expression
    ;

Multiplicative_Expression
    : Primary
    | Multiplicative_Expression '*' Primary
    | Multiplicative_Expression '/' Primary
    | Multiplicative_Expression '%' Primary
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
    : RETURN Expression ';'   {trace("Return_Statement Call\n");}
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

Include_Statement
	: '#' INCLUDE LESSER_THAN IDENTIFIER GREATER_THAN
	| '#' INCLUDE LESSER_THAN IDENTIFIER '.' IDENTIFIER GREATER_THAN
	;

Include
	: Include_Statement
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
