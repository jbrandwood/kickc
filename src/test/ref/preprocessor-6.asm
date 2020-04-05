// Test the preprocessor
// Test macro recursion
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const A = 'a'
  .label SCREEN = $400
main: {
    // SCREEN[idx++] = A
    lda #A+1
    sta SCREEN
    // }
    rts
}
