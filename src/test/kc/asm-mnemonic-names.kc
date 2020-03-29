// Test using an ASM mnemonic as a C symbol names
// Works if the C-lexer and the ASM-lexer are separated properly

char* const lda = 0x0400;

void main() {
    char jmp = 1;
    *lda = jmp;
    bne(jmp);
    // Inline asm using the mnemonics
    asm {
        lda a
        jmp a
        bne a
        a:
    }
}

void bne(char jsr) {
    lda[1] = jsr;
}