// Test that void-parameter works top specify function takes no parameters
// Output is "..." in the top left corner of the screen

void main(void) {
    print();
    print();
    print();
}

byte* const SCREEN = 0x400;
byte idx = 0;

void print(void) {
    SCREEN[idx++] = '.';
}