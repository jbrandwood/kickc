bbegin:
  jsr main
bend:
main: {
  b1_from_main:
    ldy #$64
  b1_from_b3:
  b1:
    jsr nest
  b3:
    dey
    cpy #$0
    bne b1_from_b3
  breturn:
    rts
}
nest: {
  b1_from_nest:
    ldx #$64
  b1_from_b1:
  b1:
    stx $400
    dex
    cpx #$0
    bne b1_from_b1
  breturn:
    rts
}
