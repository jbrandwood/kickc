//  Tests that a procedure that is never called, but requires static analysis is correctly eliminated
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    lda #'a'
    sta screen
    rts
}
