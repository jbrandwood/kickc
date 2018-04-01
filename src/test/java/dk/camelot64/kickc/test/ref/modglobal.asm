.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label cnt = 2
  jsr main
main: {
    ldx #0
    ldy #0
    txa
    jsr inccnt
    sta SCREEN+0
    lda cnt
    clc
    adc #1
    jsr inccnt
    sta SCREEN+1
    rts
}
inccnt: {
    clc
    adc #1
    sta cnt
    iny
    inx
    rts
}
