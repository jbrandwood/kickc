// Demonstrates initializing an object using = { ... } syntax
// Array of words

unsigned int words[] = { 1, 2, 3 };

void main() {
    char* const SCREEN = (char*)0x0400;
    char idx = 0;
    for( char i: 0..2) {
        SCREEN[idx++] = BYTE0(words[i]);
        SCREEN[idx++] = BYTE1(words[i]);

    }
}