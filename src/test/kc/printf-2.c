// Tests printf implementation
// Format a number

#include <printf.h>

void main() {

    printf_cls();

    struct printf_format_number format;
    format.min_length = 6;
    format.justify_left = 0;
    format.sign_always = 0;
    format.zero_padding = 0;
    format.radix = DECIMAL;
    printf_schar(-77, format);
    printf_ln();

    format.radix = OCTAL;
    format.zero_padding = 1;
    format.sign_always = 1;
    printf_schar(99, format);
    printf_ln();

    format.min_length = 10;
    format.justify_left = 1;
    format.sign_always = 0;
    format.zero_padding = 0;
    format.radix = HEXADECIMAL;
    printf_uint(3456, format);
    printf_ln();

}
