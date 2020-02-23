// Fill a square on the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label __0 = 3
    .label __1 = 3
    .label line = 3
    .label y = 2
    .label __6 = 5
    .label __7 = 3
    lda #5
    sta.z y
  __b1:
    // (word)y
    lda.z y
    sta.z __0
    lda #0
    sta.z __0+1
    // (word)y*40
    lda.z __0
    asl
    sta.z __6
    lda.z __0+1
    rol
    sta.z __6+1
    asl.z __6
    rol.z __6+1
    lda.z __7
    clc
    adc.z __6
    sta.z __7
    lda.z __7+1
    adc.z __6+1
    sta.z __7+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    // line = SCREEN+(word)y*40
    clc
    lda.z line
    adc #<SCREEN
    sta.z line
    lda.z line+1
    adc #>SCREEN
    sta.z line+1
    ldy #5
  __b2:
    // x+y
    tya
    clc
    adc.z y
    // line[x] = x+y
    sta (line),y
    // for( byte x: 5..15)
    iny
    cpy #$10
    bne __b2
    // for( byte y: 5..15)
    inc.z y
    lda #$10
    cmp.z y
    bne __b1
    // }
    rts
}
