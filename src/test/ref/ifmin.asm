// Minimal if() test
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    cpx #$32
    bcs __b2
    stx SCREEN
  __b2:
    inx
    cpx #$64
    bcc __b1
    rts
}
