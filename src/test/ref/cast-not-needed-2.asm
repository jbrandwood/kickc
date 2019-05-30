// Tests a cast that is not needed
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label getScreen1_return = 2
    .label spritePtr1_return = 2
    lda screens
    sta getScreen1_return
    lda screens+1
    sta getScreen1_return+1
    clc
    lda spritePtr1_return
    adc #<$378
    sta spritePtr1_return
    lda spritePtr1_return+1
    adc #>$378
    sta spritePtr1_return+1
    lda #$22
    ldy #0
    sta (spritePtr1_return),y
    rts
}
  screens: .word $400, $1400
