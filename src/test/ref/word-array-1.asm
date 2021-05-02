// Tests a simple word array
  // Commodore 64 PRG executable file
.file [name="word-array-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label w = 3
    .label idx = 2
    lda #0
    sta.z idx
    tax
  __b1:
    // word w = words[i]
    txa
    asl
    tay
    lda words,y
    sta.z w
    lda words+1,y
    sta.z w+1
    // >w
    // SCREEN[idx++] = >w
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = >w;
    iny
    // <w
    lda.z w
    // SCREEN[idx++] = <w
    sta SCREEN,y
    // SCREEN[idx++] = <w;
    iny
    tya
    // idx++;
    clc
    adc #1
    sta.z idx
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
  .segment Data
    // Clever word array that represents C64 numbers 0-7
    words: .word $3031, $3233, $3435, $3637
}
