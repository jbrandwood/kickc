// Test the #define for the plus4 target platform
#pragma target(plus4)

char * const SCREEN = 0x0c00;

void main() {
    #ifdef __PLUS4__
    SCREEN[0] = 'a';
    #else
    SCREEN[0] = 'b';
    #endif
}
