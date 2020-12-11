// Test declaring an address as expression
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const var1 = $800
  .const var2 = $900
  // The screen
  .label SCREEN = $400
main: {
    // SCREEN[0] = DATA[0]
    lda DATA
    sta SCREEN
    // }
    rts
}
.pc = var1+var2 "DATA"
  // Data to be put on the screen
  DATA: .fill $3e8, 0
