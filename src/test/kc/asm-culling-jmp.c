// Example of inline ASM where a JMP is erronously culled during compilation
// https://gitlab.com/camelot/kickc/issues/302

void main() {
    asm {
	    jmp qwe
        .byte 0,25,51,76,102,128,153,179,204,230
        qwe:  lda #50
    }
    *((char*)0x0400) = 'c';

}