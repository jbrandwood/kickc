// Test declaring an integer array variable as at a hard-coded address
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The screen
  .label SCREEN = $400
main: {
    // SCREEN[0] = DATA[0]
    lda DATA
    sta SCREEN
    lda DATA+1
    sta SCREEN+1
    // }
    rts
}
.pc = $1000 "DATA"
  // Data to be put on the screen
  DATA: .fill 2*$3e8, 0
