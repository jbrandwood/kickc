  jsr main
main: {
    ldx #$0
  b1:
    cpx #$32
    bcc b2
  b3:
    inx
    cpx #$64
    bcc b1
    rts
  b2:
    stx $400
    jmp b3
}
