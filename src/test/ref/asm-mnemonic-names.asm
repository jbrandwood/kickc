// Test using an ASM mnemonic as a C symbol names
// Works if the C-lexer and the ASM-lexer are separated properly
  // Commodore 64 PRG executable file
.file [name="asm-mnemonic-names.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label lda = $400
.segment Code
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
// void bne(char jsr)
bne: {
    // lda[1] = jsr
    lda #main.jmp
    sta lda+1
    // }
    rts
}
