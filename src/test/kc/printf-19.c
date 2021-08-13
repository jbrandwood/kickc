// Tests sprintf function call rewriting
// Test simple formats

#include <sprintf.h>

char BUF[20];

char * screen = (char*)0x0400;

void print(char* msg) {
    while(*msg)
        *(screen++) = *(msg++);
}

void main() {
    // String - no format
    sprintf(BUF, "hello world! ");
    print(BUF);
    // String & char format
    sprintf(BUF, "hello %s%c ", "world", '!');
    print(BUF);
    // Number format
    sprintf(BUF, "hello %d+%x! ", 3,11);
    print(BUF);
    // Long
    sprintf(BUF, "hi %ld! ", 22222222l);
    print(BUF);
}



