// Tests the ternary operator - complex nested conditional operators
  // Commodore 64 PRG executable file
.file [name="ternary-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label b = 2
    ldy #0
    tya
    sta.z b
  __b1:
    ldx #0
  __b2:
    // (b) ? 24 + (v & 2 ? 8 : 13) * 8 : 0
    lda.z b
    cmp #0
    bne __b3
    lda #0
  __b4:
    // SCREEN[i++] = x
    sta SCREEN,y
    // SCREEN[i++] = x;
    iny
    // for( char v: 0..3)
    inx
    cpx #4
    bne __b2
    // for(char b: 0..3)
    inc.z b
    lda #4
    cmp.z b
    bne __b1
    // }
    rts
  __b3:
    // v & 2
    txa
    and #2
    // v & 2 ? 8 : 13
    cmp #0
    bne __b5
    lda #$d
    jmp __b6
  __b5:
    // v & 2 ? 8 : 13
    lda #8
  __b6:
    // (v & 2 ? 8 : 13) * 8
    asl
    asl
    asl
    // (b) ? 24 + (v & 2 ? 8 : 13) * 8 : 0
    clc
    adc #$18
    jmp __b4
}
