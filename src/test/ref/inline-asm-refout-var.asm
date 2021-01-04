// Illustrates how inline assembler referencing variables is automatically converted to __ma
  // Commodore 64 PRG executable file
.file [name="inline-asm-refout-var.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label i = 2
    // for(byte i: 0..10)
    lda #0
    sta.z i
  __b1:
    // asm
    lda #'a'
    ldx i
    sta SCREEN,x
    // for(byte i: 0..10)
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    // }
    rts
}
