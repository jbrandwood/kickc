bbegin:
  jsr main
bend:
main: {
  b1_from_main:
    ldx #$2
  b1:
    cpx #$a
    bcc b2
  breturn:
    rts
}
b2:
  lda $400,x
  inx
b1_from_b2:
  jmp b1
