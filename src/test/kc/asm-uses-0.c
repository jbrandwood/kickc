// Tests that inline asm uses clause makes the compiler not cull a procedure referenced

void main() {
    asm {
        jsr init
    }
}

char* const BG_COLOR = 0xd020;

// Function only used inside the inline asm
void init() {
    *BG_COLOR = 0;
}
