bbegin:
  jsr main
bend:
main: {
  inccnt_from_main:
    ldx #$0
    jsr inccnt
  b1:
    stx $400
    inx
  inccnt_from_b1:
    jsr inccnt
  b2:
    inx
    stx $401
  breturn:
    rts
}
inccnt: {
    inx
  breturn:
    rts
}
