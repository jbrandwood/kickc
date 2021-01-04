// Tests that references to labels in other scopes is possible from inline ASM
  // Commodore 64 PRG executable file
.file [name="inline-asm-ref-scoped.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // asm
    lda #'c'
    sta sub.ll+1
    // sub()
    jsr sub
    // }
    rts
}
sub: {
    // asm
  ll:
    lda #0
    sta $400
    // }
    rts
}
