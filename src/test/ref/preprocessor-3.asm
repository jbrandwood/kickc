// Test the preprocessor
// #define inside an imported file
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Test the preprocessor
  // #define inside an imported file
  .label SCREEN = $400
main: {
    // SCREEN[0] = STAR
    lda #'*'
    sta SCREEN
    // }
    rts
}