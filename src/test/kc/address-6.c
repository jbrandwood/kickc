// Test declaring a variable as at a hard-coded address
// mainmem-page hard-coded address parameter

void main() {
    print('c');
    print('m');
    print('l');
}

char* const SCREEN = 0x0400;

volatile char __address(0x3000) idx;

void print(char __address(0x3001) ch) {
    asm {
        ldx idx
        lda ch
        sta SCREEN,x
        inc idx
    }
}