// Tests a cast that is not needed
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label DSP = $400
    .label spritePtr1__0 = 2
    .label getScreen1_return = 2
    lda screens
    sta.z getScreen1_return
    lda screens+1
    sta.z getScreen1_return+1
    clc
    lda.z spritePtr1__0
    adc #<$378
    sta.z spritePtr1__0
    lda.z spritePtr1__0+1
    adc #>$378
    sta.z spritePtr1__0+1
    ldy #0
    lda (spritePtr1__0),y
    sta DSP
    rts
}
  screens: .word $400, $1400
