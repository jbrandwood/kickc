// Test the preprocessor
// Test #ifdef

#define A

char * SCREEN = (char*)0x0400;
char idx = 0;

void main() {
    SCREEN[idx++] = '-';
    #ifdef A
        SCREEN[idx++] = 'a';
    #else
        SCREEN[idx++] = 'b';
    #endif
    SCREEN[idx++] = '-';

}