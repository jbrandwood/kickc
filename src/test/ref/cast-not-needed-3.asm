// Tests a cast that is not needed
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_POINTER = 2
main: {
    .label DSP = $400
    .const getScreen1_id = 0
    .label getScreen1_return = 2
    .label spritePtr1__0 = 2
    lda screens+getScreen1_id*SIZEOF_POINTER
    sta getScreen1_return
    lda screens+getScreen1_id*SIZEOF_POINTER+1
    sta getScreen1_return+1
    clc
    lda spritePtr1__0
    adc #<$378
    sta spritePtr1__0
    lda spritePtr1__0+1
    adc #>$378
    sta spritePtr1__0+1
    ldy #0
    lda (spritePtr1__0),y
    sta DSP
    rts
}
  screens: .word $400, $1400
