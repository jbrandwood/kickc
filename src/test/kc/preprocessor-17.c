// Demonstrates a problem where a preprocessor macro with parameters name is used without any call parenthesis.

#define CLEAR(x) x=0

void main() {
    char * const SCREEN = (char*)0x0400;
    char CLEAR=127;
    SCREEN[0] = CLEAR;
    CLEAR(CLEAR);
    SCREEN[1] = CLEAR;
}