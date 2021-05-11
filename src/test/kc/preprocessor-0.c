// Test the preprocessor
// A simple #define

#define A 'a'

char * const SCREEN = (char*)0x0400;

void main() {
    *SCREEN = A;
}
