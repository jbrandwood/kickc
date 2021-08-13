// Tests printf implementation
// Format a number

#include <printf.h>

void main() {

    clrscr();

    printf_schar(cputc, -77, { 6, 0, 0, 0, 0, DECIMAL});
    cputln();

    printf_schar(cputc, 99, {6, 0, 1, 1, 0, OCTAL});
    cputln();

    printf_uint(cputc, 3456, {10, 1, 0, 0, 1, HEXADECIMAL});
    cputln();

}
