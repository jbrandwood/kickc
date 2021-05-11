// Test the preprocessor
// #include that is not used

#ifdef ERR
#include "qwe.h"
#endif

char * const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = 'a';
}