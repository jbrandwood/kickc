  jsr main
main: {
    ldx #$0
  b1:
    txa
    sta $400,x
    inx
    cpx #$0
    bne b1
    ldx #$64
  b2:
    txa
    sta $500,x
    dex
    cpx #$ff
    bne b2
    rts
}
