// Test the preprocessor
// Test macro recursion

char A = 'a';

#define A A+1

char * SCREEN = (char*)0x0400;
char idx = 0;

void main() {
    SCREEN[idx++] = A;
}