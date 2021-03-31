// Test standard library <string.h> memchr()

#include <string.h>
#include <stdio.h>
#include <conio.h>

void main() {

    clrscr();

    char* str = "this is a test";
    char* ptr = memchr( str, 'a', 14);
    assert_uint(8, (ptr-str), "finding a");

    char* ptr2 = memchr( str, 'a', 7);
    assert_ptr((void*)0, ptr2, "not finding a");

}

void assert_char(char expect, char actual, char* message) {
    if(expect!=actual) {
        textcolor(RED);
        printf("Assert failed. expected:'%x' actual:'%c'. %s\n", expect, actual, message);
    } else {
        textcolor(GREEN);
        printf("ok! %s\n", message);
    }
}

void assert_uint(unsigned int expect, unsigned int actual, char* message) {
    if(expect!=actual) {
        textcolor(RED);
        printf("Assert failed. expected:%u actual:%u. %s\n", expect, actual, message);
    } else {
        textcolor(GREEN);
        printf("ok! %s\n", message);
    }
}

void assert_ptr(void* expect, void* actual, char* message) {
    if(expect!=actual) {
        textcolor(RED);
        printf("Assert failed. expected:0x%x actual:0x%x. %s\n", (unsigned int)expect, (unsigned int)actual, message);
    } else {
        textcolor(GREEN);
        printf("ok! %s\n", message);
    }

}
