// Illustrates how inline assembler can reference data from the outside program

byte table[] = "cml!"z;

void main() {
    byte* const SCREEN = $400;
    *(SCREEN+40) = table[0];

    asm {
        ldx #0
        !:
        lda table,x
        sta SCREEN+1,x
        inx
        cpx #4
        bne !-
    }

}