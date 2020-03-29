// Test declaring a variable as at a hard-coded address
// zero-page hard-coded address parameter

void main() {
    print('c');
    print('m');
    print('l');
}

char* const SCREEN = 0x0400;

volatile char __address(0x03) idx;

void print(char __address(0x02) ch) {
    asm {
        ldx idx
        lda ch
        sta SCREEN,x
        inc idx
    }
}
