// Tests printf implementation
// Format a string

#include <printf.h>

void main() {

    clrscr();

    printf_string(&cputc, "cml", { 10, 0 } );
    cputln();
    printf_string(&cputc, "rules", { 10, 0 } );
    cputln();
    
    printf_string(&cputc, "cml", { 10, 1 } );
    cputln();
    printf_string(&cputc, "rules", { 10, 1 } );

}
