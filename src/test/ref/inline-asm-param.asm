  // Commodore 64 PRG executable file
.file [name="inline-asm-param.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // asm
    lda #'a'
    sta SCREEN
    // for( byte i:0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
}
