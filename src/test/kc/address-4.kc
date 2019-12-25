// Test declaring a variable as at a hard-coded address
// Incrementing a load/store variable will result in cause two *SIZEOF's

unsigned int* SCREEN = 0x0400;

void main() {
    __address(0x2) char i=0;
    const unsigned int ch = 0x0102;
    while(i<8) {
        SCREEN[i++] = ch;
        SCREEN[i++] = ch;
    }
}
