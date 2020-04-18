// Tests printf implementation
// Format a string

#include <printf.h>

void main() {

    printf_cls();

    struct printf_format_string format;
    format.min_length = 10;
    format.justify_left = 0;
    printf_string( "cml", format);
    printf_ln();
    printf_string( "rules", format);
    printf_ln();
    
    format.justify_left = 1;
    printf_string( "cml", format);
    printf_ln();
    printf_string( "rules", format);
}
