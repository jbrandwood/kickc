// Test using an ASM mnemonic as a C symbol names
// Works if the C-lexer and the ASM-lexer are separated properly
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label lda = $400
main: {
    .label jmp = 1
    // *lda = jmp
    lda #jmp
    sta lda
    // bne(jmp)
    jsr bne
    // asm
    // Inline asm using the mnemonics
    lda a
    rts
  a:
    // }
    rts
}
bne: {
    // lda[1] = jsr
    lda #main.jmp
    sta lda+1
    // }
    rts
}
