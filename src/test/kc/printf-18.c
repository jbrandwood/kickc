// Tests snprintf function call rewriting
// Test snprintf() and printf() in the same file

#include <stdio.h>

char BUF1[20];
char BUF2[20];
char * screen = (char*)0x0400;

void main() {
    snprintf(BUF1, 20, "hello world!");
    snprintf(BUF2, 20, "hello %s%c", "world", '!');
    printf("-%s- -%s-", BUF1, BUF2);
}



