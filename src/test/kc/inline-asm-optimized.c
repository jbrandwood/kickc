// Tests that inline assembler is optimized

byte* const SCREEN = $400;

void main() {

    *SCREEN = 0;
    asm {
        lda #0
        sta SCREEN+1
        lda #0
        sta SCREEN+2
    }
    SCREEN[3] = 0;
    asm {
        lda #0
        sta SCREEN+4
    }


}
