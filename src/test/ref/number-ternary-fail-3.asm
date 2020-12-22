// Failing number type resolving in ternary operator
// Currently fails in the ternary operator with number-issues if integer literal is not specified!
  // Commodore 64 PRG executable file
.file [name="number-ternary-fail-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label BASIC = $a000
    .label SCREEN = $400
    ldx #0
  __b1:
    // glyph_bits = BASIC[i]
    lda BASIC,x
    // glyph_bits&0x80
    and #$80
    // (glyph_bits&0x80)?1:0
    cmp #0
    bne __b2
    lda #0
    jmp __b3
  __b2:
    // (glyph_bits&0x80)?1:0
    lda #1
  __b3:
    // SCREEN[i] = glyph_bit
    sta SCREEN,x
    // for( char i: 0..7 )
    inx
    cpx #8
    bne __b1
    // }
    rts
}
