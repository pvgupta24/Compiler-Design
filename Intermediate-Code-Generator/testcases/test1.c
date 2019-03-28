#include <stdio.h>

int main() {

    int a;
    int x =1;
    
    for(a=1; a<5; a=a+1) {

        if(x>1)
            break;
        else
            continue;
    }
    a=0;

    return 0;
}