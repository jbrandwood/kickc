bbegin:
  jsr main
bend:
main: {
  inccnt_from_main:
    ldy #$0
    ldx #$0
    jsr inccnt
  b1:
    sta $400
    inx
  inccnt_from_b1:
    jsr inccnt
  b2:
    sta $401
  breturn:
    rts
}
inccnt: {
    inx
    iny
    txa
  breturn:
    rts
}
