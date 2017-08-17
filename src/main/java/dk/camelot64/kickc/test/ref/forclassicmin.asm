  jsr main
main: {
    ldx #$0
  b1:
    txa
    sta $400,x
    inx
    cpx #$64
    bne b1
    rts
}
