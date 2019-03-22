
#ifndef _STACK
#define _STACK

#define STACK_VAR_LENGTH 100
#define STACK_CAPACITY 100
#define TEMP_VAR "#REG"

typedef struct stack_node stack_node;
typedef struct stack stack;

struct stack_node {
    int temp_num; // -1 if it isn't a temporary variable
    char var_name[STACK_VAR_LENGTH];
};

struct stack {
    int top;
    int temp_count;
    stack_node stack_arr[STACK_CAPACITY];
};

stack *initialize_stack();
void free_stack(stack *st);
stack_node pop_stack(stack *st);
void print_stack_top(stack *st);
void push_stack(stack *st, const char *var_name);

#endif