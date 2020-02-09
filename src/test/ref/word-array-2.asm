// Tests a word-array with 128+ elements
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label SCREEN = $400
    .label __0 = 2
    .label __1 = 4
    .label __2 = 4
    .label __3 = 4
    .label __5 = 2
    .label __8 = 2
    ldx #0
  __b1:
    txa
    sta.z __0
    lda #0
    sta.z __0+1
    txa
    sta.z __1
    lda #0
    sta.z __1+1
    lda.z __2
    sta.z __2+1
    lda #0
    sta.z __2
    txa
    clc
    adc.z __3
    sta.z __3
    bcc !+
    inc.z __3+1
  !:
    asl.z __5
    rol.z __5+1
    clc
    lda.z __8
    adc #<words
    sta.z __8
    lda.z __8+1
    adc #>words
    sta.z __8+1
    ldy #0
    lda.z __3
    sta (__8),y
    iny
    lda.z __3+1
    sta (__8),y
    inx
    cpx #0
    bne __b1
    lda words+$ff*SIZEOF_WORD
    sta SCREEN
    lda words+$ff*SIZEOF_WORD+1
    sta SCREEN+1
    rts
}
  words: .fill 2*$100, 0
