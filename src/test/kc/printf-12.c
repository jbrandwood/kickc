// Tests printf function call rewriting
// Print a bunch of different stuff using printf

#include <printf.h>

void main() {
    printf_cls();
    char c = 'x';
    signed char sc = -12;
    unsigned char uc = 34;
    signed int si = -1234;
    unsigned int ui = 5678;
    signed long sl = -123456;
    unsigned long ul = 567890;

    // char
    printf("A char: %c\n", c);
    // pointer
    printf("A pointer: %p\n", &c);
    // percent sign
    printf("A percent: %%\n");
    // signed char
    printf("A signed char: %hhd\n", sc);
    // unsigned char
    printf("An unsigned char: %hhu\n", uc);
    // signed int
    printf("A signed int: %d\n", si);
    // unsigned int
    printf("An unsigned int: %u\n", ui);
    // signed long
    printf("A signed long: %ld\n", sl);
    // unsigned long
    printf("An unsigned long: %lu\n", ul);
    
}

