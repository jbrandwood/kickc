  jsr main
main: {
    .const SCREEN = $400
    ldx #$2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    lda SCREEN,x
    inx
    jmp b1
}
