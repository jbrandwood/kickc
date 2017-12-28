.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  jsr main
main: {
    ldy #0
  b1:
    jsr line
    iny
    cpy #9
    bne b1
    ldy #$a
  b2:
    jsr line
    iny
    cpy #$13
    bne b2
    rts
}
line: {
    tya
    jsr plot
    tya
    clc
    adc #$14
    jsr plot
    rts
}
plot: {
    tax
    lda #'*'
    sta SCREEN,x
    rts
}
