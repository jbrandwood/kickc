// Test variable declarations
// Declaration type mismatch

// An extern with one type
extern unsigned int SCREEN;

// The actual declaration with another
char * const SCREEN = 0x0400;
char idx;

// And a little code using them
void main() {
    SCREEN[idx++] = 'c';
    SCREEN[idx++] = 'm';
    SCREEN[idx++] = 'l';
}












