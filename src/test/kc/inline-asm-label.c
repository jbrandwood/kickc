// Illustrates how inline assembler use internal labels and external references

char* const SCREEN = (char*)0x400;
char table[] = "cml!";
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

