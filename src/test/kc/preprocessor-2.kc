// Test the preprocessor
// #define and #undef - expected output on screen is xa

char * SCREEN = 0x0400;

void main() {
    char a = 'a';
    #define a 'x'
    SCREEN[0] = a;
    #undef a
    SCREEN[1] = a;
}