// Test the preprocessor
// A simple #define
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // *SCREEN = A
    lda #'a'
    sta SCREEN
    // }
    rts
}
