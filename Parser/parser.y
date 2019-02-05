/*
* @author Shashank P, Praveen Gupta, Ashwin Joisa
* Ref: http://cse.iitkgp.ac.in/~bivasm/notes/LexAndYaccTutorial.pdf
*/


/* Auxiliary declarations*/
%{
    #include <stdio.h>
    #include <stdbool.h>
    #include <math.h>
    #include <string.h>
    
    // #define YYSTYPE char*

    extern char yytext[];
    extern int yylineno;

    /* ***Symbol Table*** */
    #include "lib/misc.h"
    #include "lib/symbol_table.h"

    #define MAX_SYMBOLS_COUNT 1000

    symbol_node_t *symbol_table[MAX_SYMBOLS_COUNT];
    symbol_node_t *constant_table[MAX_SYMBOLS_COUNT];

    bool isValid = true;
    char type[100];
    char temp[100];

%}

/* ****Tokens**** */
%token IDENTIFIER STRING_CONSTANT CHAR_CONSTANT INT_CONSTANT FLOAT_CONSTANT SIZEOF
%token INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME DEF
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOID
%token IF ELSE WHILE CONTINUE BREAK RETURN

// Declare the start grammer rule for the program to be parsed
%start start_state

%union {
	char id[100];
}
%nonassoc NO_ELSE
%nonassoc ELSE
%left '<' '>' '=' GE_OP LE_OP EQ_OP NE_OP
%left  '+'  '-'
%left  '*'  '/' '%'
%left  '|'
%left  '&'

%nonassoc UNARY

// Use extension of LR parser algorithm to handle nondeterministic and ambigous grammers
%glr-parser

/* ******* Grammer Rules for parsing ******** */
%%
// Start State
start_state
	: global_declaration
	| start_state global_declaration
	;

global_declaration
	: function_definition
	| declaration
	;

function_definition
	: declaration_specifiers declarator compound_statement
	| declarator compound_statement
	;

fundamental_exp
	: IDENTIFIER { printf("yay3\n"); }
	| STRING_CONSTANT		{   symbol_table_insert(constant_table, $1, "string", yylineno); }
	| CHAR_CONSTANT         {   symbol_table_insert(constant_table, $1, "char", yylineno); }
	| FLOAT_CONSTANT	    {   symbol_table_insert(constant_table, $1, "float", yylineno); }
	| INT_CONSTANT			{   symbol_table_insert(constant_table, $1, "int", yylineno); }
	| '(' expression ')'
	;


secondary_exp
	: fundamental_exp
	| secondary_exp '[' expression ']'
	| secondary_exp '(' ')'
	| secondary_exp '(' arg_list ')'
	| secondary_exp '.' IDENTIFIER
	| secondary_exp INC_OP
	| secondary_exp DEC_OP
	;

arg_list
	: assignment_expression
	| arg_list ',' assignment_expression
	;

unary_expression
	: secondary_exp
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator typecast_exp
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

typecast_exp
	: unary_expression
	| '(' type_name ')' typecast_exp
	;

multdivmod_exp
	: typecast_exp
	| multdivmod_exp '*' typecast_exp
	| multdivmod_exp '/' typecast_exp
	| multdivmod_exp '%' typecast_exp
	;

addsub_exp
	: multdivmod_exp
	| addsub_exp '+' multdivmod_exp
	| addsub_exp '-' multdivmod_exp
	;

shift_exp
	: addsub_exp
	| shift_exp LEFT_OP addsub_exp
	| shift_exp RIGHT_OP addsub_exp
	;

relational_expression
	: shift_exp
	| relational_expression '<' shift_exp
	| relational_expression '>' shift_exp
	| relational_expression LE_OP shift_exp
	| relational_expression GE_OP shift_exp
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression
	;

exor_expression
	: and_expression
	| exor_expression '^' and_expression
	;

unary_or_expression
	: exor_expression
	| unary_or_expression '|' exor_expression
	;

logical_and_expression
	: unary_or_expression
	| logical_and_expression AND_OP unary_or_expression
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers init_declarator_list ';'
	| error
	;

declaration_specifiers
	: type_specifier	{ printf("noooo\n"); strcpy(type, $1); printf("nope\n");}
	| type_specifier declaration_specifiers	{ strcpy(temp, $1); strcat(temp, " "); strcat(temp, type); strcpy(type, temp); }
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator
	| declarator '=' init
	;

type_specifier
	: VOID			{ $$ = "void"; }
	| CHAR			{ $$ = "char"; }
	| SHORT			{ $$ = "short"; }
	| INT			{ printf("Trying INT\n"); $$ = "int"; ;printf("YO INT\n");}
	| LONG			{ $$ = "long"; }
	| SIGNED		{ $$ = "signed"; }
	| UNSIGNED	    { $$ = "unsigned"; }
	;

type_specifier_list
	: type_specifier type_specifier_list
	| type_specifier
	;

declarator
	: direct_declarator
	;

direct_declarator
	: IDENTIFIER		    {   printf("yay\n"); printf("yay %d\n", yylineno); symbol_table_insert(symbol_table, $1, type, yylineno); printf("KK\n"); printf("%s\n", $1); }
	| '(' declarator ')'
	| direct_declarator '[' constant_expression ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;


parameter_type_list
	: parameter_list
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER { printf("yay2\n"); }
	| identifier_list ',' IDENTIFIER
	;

type_name
	: type_specifier_list
	| type_specifier_list abstract_declarator
	;

abstract_declarator
	: direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

init
	: assignment_expression
	| '{' init_list '}'
	| '{' init_list ',' '}'
	;

init_list
	: init
	| init_list ',' init
	;

statement
	: compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

compound_statement
	: '{' '}'
	| '{' statement_list '}'
	| '{' declaration_list '}'
	| '{' declaration_list statement_list '}'
	| '{' declaration_list statement_list declaration_list statement_list '}'
	| '{' declaration_list statement_list declaration_list '}'
	| '{' statement_list declaration_list statement_list '}'
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

statement_list
	: statement
	| statement_list statement
	;

expression_statement
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement %prec NO_ELSE
	| IF '(' expression ')' statement ELSE statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	;

jump_statement
	: CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;
%%

#include "y.tab.h"

/* User SubRoutines */
int main(){

    yyparse();

    if(!isValid){
        printf(FORE_RED SYMBOL_CROSS "  Invalid Expression\n\n" RESET);

        return -1;
    }

    printf(FORE_GRN SYMBOL_TICK "  Valid Expression\n\n" RESET);

    symbol_table_print(symbol_table, "Symbol Table");
    symbol_table_print(constant_table, "Constant Table");
    
    return 0;
}

void yyerror(char *s){
    isValid = false;
    fprintf(stderr, FORE_RED "===== Line %d ======\n%s\n" RESET, yylineno, s); 
}
