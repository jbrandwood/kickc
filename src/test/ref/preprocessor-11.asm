// Test the preprocessor
// #error that is not used
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[0] = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
