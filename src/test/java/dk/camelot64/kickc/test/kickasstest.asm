// Minimal if() test
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    lda #'a'
  b1:
    sta SCREEN,x
    inx
    cpx #40
    bcc b1
    rts
}
