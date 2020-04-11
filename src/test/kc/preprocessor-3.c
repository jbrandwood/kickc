// Test the preprocessor
// #define inside an #included file

#include "preprocessor-3b.c"

char * SCREEN = 0x0400;

void main() {
    SCREEN[0] = STAR;
}