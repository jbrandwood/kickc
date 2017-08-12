  jsr main
main: {
    ldx #$2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    lda $400,x
    inx
    jmp b1
}
