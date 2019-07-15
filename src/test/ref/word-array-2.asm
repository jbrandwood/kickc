// Tests a word-array with 128+ elements
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label SCREEN = $400
    .label _1 = 2
    .label _2 = 4
    .label _3 = 4
    .label _4 = 4
    .label _6 = 2
    .label _9 = 2
    ldx #0
  b1:
    txa
    sta _1
    lda #0
    sta _1+1
    txa
    sta _2
    lda #0
    sta _2+1
    lda _3
    sta _3+1
    lda #0
    sta _3
    txa
    clc
    adc _4
    sta _4
    bcc !+
    inc _4+1
  !:
    asl _6
    rol _6+1
    clc
    lda _9
    adc #<words
    sta _9
    lda _9+1
    adc #>words
    sta _9+1
    ldy #0
    lda _4
    sta (_9),y
    iny
    lda _4+1
    sta (_9),y
    inx
    cpx #0
    bne b1
    lda words+$ff*SIZEOF_WORD
    sta SCREEN
    lda words+$ff*SIZEOF_WORD+1
    sta SCREEN+1
    rts
}
  words: .fill 2*$100, 0
