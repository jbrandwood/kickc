// Test compile-time and run-time multiplication
// Compile-time multiplication
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const c1 = 4
    .const c3 = c1*(c1*2+1)
    // SCREEN[0] = c3
    lda #c3
    sta SCREEN
    // }
    rts
}
