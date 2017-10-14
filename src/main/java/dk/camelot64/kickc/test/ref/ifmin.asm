  .const SCREEN = $400
  jsr main
main: {
    ldx #$0
  b1:
    cpx #$32
    bcs b2
    stx SCREEN
  b2:
    inx
    cpx #$64
    bcc b1
    rts
}
