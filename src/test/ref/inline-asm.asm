  // Commodore 64 PRG executable file
.file [name="inline-asm.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // asm
    lda #'a'
    ldx #$ff
  !:
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    dex
    bne !-
    // }
    rts
}
