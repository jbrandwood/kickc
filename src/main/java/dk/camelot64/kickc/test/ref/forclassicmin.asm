  .const SCREEN = $400
  jsr main
main: {
    ldx #0
  b1:
    txa
    sta SCREEN,x
    inx
    cpx #$64
    bne b1
    rts
}
