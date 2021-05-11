// Test the #define for the default platform

char* const SCREEN = (char*)0x0400;

void main() {
    #ifdef __C64__
    SCREEN[0] = 'a';
    #else
    SCREEN[0] = 'b';
    #endif
}
