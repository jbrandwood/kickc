// Demonstrates an array with a trailing comma

unsigned char chars[] = { 1, 2, 3, };

void main() {
    char* const SCREEN = 0x0400;
    char idx = 0;
    for( char i: 0..2) {
        SCREEN[idx++] = chars[i];
    }
}