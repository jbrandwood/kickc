// Tests printf function call rewriting
// Print a char using %u

#include <printf.h>

void main() {
    printf_cls();

    char c = 7;
    printf("%u", c);

}

