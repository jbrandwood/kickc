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
    sta.z _1
    lda #0
    sta.z _1+1
    txa
    sta.z _2
    lda #0
    sta.z _2+1
    lda.z _3
    sta.z _3+1
    lda #0
    sta.z _3
    txa
    clc
    adc.z _4
    sta.z _4
    bcc !+
    inc.z _4+1
  !:
    asl.z _6
    rol.z _6+1
    clc
    lda.z _9
    adc #<words
    sta.z _9
    lda.z _9+1
    adc #>words
    sta.z _9+1
    ldy #0
    lda.z _4
    sta (_9),y
    iny
    lda.z _4+1
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
