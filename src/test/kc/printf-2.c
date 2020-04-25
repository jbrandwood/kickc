// Tests printf implementation
// Format a number

#include <printf.h>

void main() {

    printf_cls();

    printf_schar(-77, { 6, 0, 0, 0, 0, DECIMAL});
    printf_ln();

    printf_schar(99, {6, 0, 1, 1, 0, OCTAL});
    printf_ln();

    printf_uint(3456, {10, 1, 0, 0, 1, HEXADECIMAL});
    printf_ln();

}
