#include "stack.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>

stack *initialize_stack(){
    stack *st = (stack *)malloc(sizeof(stack));
    assert(st != NULL);

    st->top = -1;
    st->temp_count = 0;

    return st;
}

void free_stack(stack *st){
    free(st);
}

stack_node pop_stack(stack *st) {
    
    if(st->top == -1){
        printf("Tried popping from Empty Stack\n");
        exit(-2);
    }

    if(st->stack_arr[st->top].temp_num != -1)
        st->temp_count--;
    return st->stack_arr[st->top--];
}

void push_stack(stack *st, const char *var_name){

    if(st->top >= STACK_CAPACITY){
        printf("Stack Overflow");
        exit(-2);
    }
    
    st->top++;
    strcpy(st->stack_arr[st->top].var_name, var_name);
    st->stack_arr[st->top].temp_num = 0;

    if(!strcmp(var_name, TEMP_VAR)){
        st->stack_arr[st->top].temp_num = st->temp_count;
        st->temp_count++;
        char buff[STACK_VAR_LENGTH];
        sprintf(buff, "%d", st->stack_arr[st->top].temp_num);
        strcat(st->stack_arr[st->top].var_name, buff);
    }
    else
        st->stack_arr[st->top].temp_num = -1;
}

void print_stack_top(stack *st){

    if(st->top == -1) {
        printf("Stack is Empty");
        exit(-2);
    }
    printf("%s", st->stack_arr[st->top].var_name);
}

