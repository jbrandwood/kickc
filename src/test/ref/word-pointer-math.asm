// Tests simple word pointer math
  // Commodore 64 PRG executable file
.file [name="word-pointer-math.prg", type="prg", segments="Program"]
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
    // words+i
    txa
    asl
    // word w = *(words+i)
    tay
    lda words,y
    sta.z w
    lda words+1,y
    sta.z w+1
    // BYTE0(w)
    lda.z w
    // SCREEN[idx++] = BYTE0(w)
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = BYTE0(w);
    iny
    // BYTE1(w)
    lda.z w+1
    // SCREEN[idx++] = BYTE1(w)
    sta SCREEN,y
    // SCREEN[idx++] = BYTE1(w);
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
    words: .word $3130, $3332, $3534, $3736
}
