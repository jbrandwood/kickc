// Tests printf implementation
// Format a string

#include <printf.h>

void main() {

    printf_cls();

    printf_string( "cml", { 10, 0 } );
    printf_ln();
    printf_string( "rules", { 10, 0 } );
    printf_ln();
    
    printf_string( "cml", { 10, 1 } );
    printf_ln();
    printf_string( "rules", { 10, 1 } );
}
