// Tests a word-array with 128+ elements
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label SCREEN = $400
    .label __1 = 2
    .label __2 = 4
    .label __3 = 4
    .label __4 = 4
    .label __6 = 2
    .label __9 = 2
    ldx #0
  __b1:
    txa
    sta.z __1
    lda #0
    sta.z __1+1
    txa
    sta.z __2
    lda #0
    sta.z __2+1
    lda.z __3
    sta.z __3+1
    lda #0
    sta.z __3
    txa
    clc
    adc.z __4
    sta.z __4
    bcc !+
    inc.z __4+1
  !:
    asl.z __6
    rol.z __6+1
    clc
    lda.z __9
    adc #<words
    sta.z __9
    lda.z __9+1
    adc #>words
    sta.z __9+1
    ldy #0
    lda.z __4
    sta (__9),y
    iny
    lda.z __4+1
    sta (__9),y
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
