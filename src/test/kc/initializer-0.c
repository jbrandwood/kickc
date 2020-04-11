// Demonstrates initializing an object using = { ... } syntax
// Array of chars

unsigned char chars[] = { 1, 2, 3 };

void main() {
    char* const SCREEN = 0x0400;
    char idx = 0;
    for( char i: 0..2) {
        SCREEN[idx++] = chars[i];
    }
}