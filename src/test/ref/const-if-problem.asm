// Constant if() contains call to (unused) function - should be optimized away
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #'a'
    sta SCREEN
    rts
}
