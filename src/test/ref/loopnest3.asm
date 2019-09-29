.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
  __b1:
    jsr b
    iny
    cpy #$65
    bne __b1
    rts
}
// b(byte register(Y) i)
b: {
    tya
    jsr c
    rts
}
// c(byte register(A) i)
c: {
    ldx #0
  __b1:
    sta SCREEN,x
    inx
    cpx #$65
    bne __b1
    rts
}
