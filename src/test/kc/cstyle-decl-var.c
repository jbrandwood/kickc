// Test declarations of variables without definition

// A few externs
extern char * const SCREEN;
extern char idx;

// The actual declarations
char * const SCREEN = 0x0400;
char idx;

// And a little code using them
void main() {
    SCREEN[idx++] = 'c';
    SCREEN[idx++] = 'm';
    SCREEN[idx++] = 'l';
}







