// Tests using integer conditions in ternary operator
// This should produce '++0++' at the top of the screen
  // Commodore 64 PRG executable file
.file [name="condition-integer-3.prg", type="prg", segments="Program"]
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
    ldy #-2
  __b1:
    // i?'+':'0'
    cpy #0
    bne __b2
    lda #'0'
    jmp __b3
  __b2:
    // i?'+':'0'
    lda #'+'
  __b3:
    // SCREEN[idx++] = j
    sta SCREEN,x
    // SCREEN[idx++] = j;
    inx
    // for( signed byte i: -2..2)
    iny
    cpy #3
    bne __b1
    // }
    rts
}
