// Tests printf implementation
// Format a string

#include <printf.h>

void main() {

    clrscr();

    printf_string( "cml", { 10, 0 } );
    cputln();
    printf_string( "rules", { 10, 0 } );
    cputln();
    
    printf_string( "cml", { 10, 1 } );
    cputln();
    printf_string( "rules", { 10, 1 } );
}
