// Illustrates how inline assembler can reference data from the outside program without the data being optimized away as unused

byte* const SCREEN = (char*)$400;
byte table[] = "cml!"z;
void main() {
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