.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  jsr main
main: {
    ldx #0
  b1:
    jsr line
    inx
    cpx #9
    bne b1
    ldx #$a
  b2:
    jsr line
    inx
    cpx #$13
    bne b2
    rts
}
line: {
    txa
    jsr plot
    txa
    clc
    adc #$14
    jsr plot
    rts
}
plot: {
    tay
    lda #'*'
    sta SCREEN,y
    rts
}
