// Test declaring a variable as at a hard-coded register
// hard-coded register parameter

void main() {
    print('c');
    print('m');
    print('l');
}

char* const SCREEN = (char*)0x0400;

volatile char __address(0x03) idx;

void print(char register(A) ch) {
    // Force usage of ch
    kickasm(uses ch) {{ }}
    asm {
        ldx idx
        sta SCREEN,x
        inc idx
    }
}
