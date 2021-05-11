// Illustrates how inline assembler use internal labels and external references

byte* const SCREEN = (char*)$400;
byte table[] = "cml!"z;
void main() {
    asm {
        ldx #0
        nxt:
        lda table,x
        sta SCREEN+1,x
        inx
        cpx #4
        bne nxt
    }

}