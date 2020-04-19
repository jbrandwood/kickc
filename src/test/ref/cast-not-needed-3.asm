// Tests a cast that is not needed
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label DSP = $400
    .label spritePtr1___0 = 2
    .label getScreen1_return = 2
    // return screens[id];
    lda screens
    sta.z getScreen1_return
    lda screens+1
    sta.z getScreen1_return+1
    // screen+$378
    clc
    lda.z spritePtr1___0
    adc #<$378
    sta.z spritePtr1___0
    lda.z spritePtr1___0+1
    adc #>$378
    sta.z spritePtr1___0+1
    // return (byte)*(screen+$378);
    ldy #0
    lda (spritePtr1___0),y
    // DSP[0] = spritePtr(getScreen(0))
    sta DSP
    // }
    rts
}
  screens: .word $400, $1400
