// Failing number type resolving in ternary operator
// Currently fails in the ternary operator with number-issues if integer literal is not specified!
  // Commodore 64 PRG executable file
.file [name="number-ternary-fail.prg", type="prg", segments="Program"]
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
    // i&1
    txa
    and #1
    // (i&1)?0:0x80
    cmp #0
    bne __b2
    lda #$80
    jmp __b3
  __b2:
    // (i&1)?0:0x80
    lda #0
  __b3:
    // SCREEN[i] = (i&1)?0:0x80
    sta SCREEN,x
    // for( byte i: 0..40)
    inx
    cpx #$29
    bne __b1
    // }
    rts
}
