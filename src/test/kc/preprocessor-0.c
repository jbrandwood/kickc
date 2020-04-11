// Test the preprocessor
// A simple #define

#define A 'a'

char * const SCREEN = 0x0400;

void main() {
    *SCREEN = A;
}
