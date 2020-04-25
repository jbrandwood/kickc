// Tests printf function call rewriting
// Print using different formats

#include <printf.h>

void main() {
    printf_cls();

    // fixed width - right justify
    printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx");
    // fixed width - left justify
    printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx");
    // fixed width - right justify
    printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111);
    // fixed width - left justify
    printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222);
    // fixed width - right justify - always sign
    printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666);
    // fixed width - zero-pad
    printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111);
    // octal
    printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111);
    // hexadecimal
    printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111);
    // hexadecimal upper-case
    printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111);
    
}

