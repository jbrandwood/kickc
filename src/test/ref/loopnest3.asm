.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
  b1:
    jsr b
    iny
    cpy #$65
    bne b1
    rts
}
b: {
    tya
    jsr c
    rts
}
c: {
    ldx #0
  b1:
    sta SCREEN,x
    inx
    cpx #$65
    bne b1
    rts
}
