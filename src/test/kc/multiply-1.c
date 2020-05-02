// Test compile-time and run-time multiplication
// Compile-time multiplication

char * const SCREEN = 0x0400;

void main() {
    char c1 = 4;
    char c2 = c1*2;
    c2++;
    char c3 = c1*c2;
    SCREEN[0] = c3;
}