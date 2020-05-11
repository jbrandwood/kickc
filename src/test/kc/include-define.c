// Test including a files with a #define and using it

#include "include-define-sub.h"
DEFX;
char * const SCREEN = 0x0400;
void main() {
    SCREEN[0] = x;
}