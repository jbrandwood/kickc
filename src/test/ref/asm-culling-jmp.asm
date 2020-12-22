// Example of inline ASM where a JMP is erronously culled during compilation
// https://gitlab.com/camelot/kickc/issues/302
  // Commodore 64 PRG executable file
.file [name="asm-culling-jmp.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // asm
    jmp qwe
    .byte 0, 25, 51, 76, 102, 128, 153, 179, 204, 230
  qwe:
    lda #$32
    // *((char*)0x0400) = 'c'
    lda #'c'
    sta $400
    // }
    rts
}
