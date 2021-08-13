// Tests snprintf function call rewriting
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
    snprintf(BUF, 20, "hello world! ");
    print(BUF);
    // String & char format
    snprintf(BUF, 20, "hello %s%c ", "world", '!');
    print(BUF);
    // Number format
    snprintf(BUF, 20, "hello %d+%x! ", 3,11);
    print(BUF);
    // Shortened
    snprintf(BUF, 6, "hi %d! ", 22222);
    print(BUF);
}



