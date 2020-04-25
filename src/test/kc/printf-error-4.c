// Tests printf function call rewriting
// Non-constant format parameter

#include <printf.h>

void main() {
    char* fmt = "%d";
    printf(fmt, 1);
    fmt = "%hhx";
    printf(fmt, 1);
}

