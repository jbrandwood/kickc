// Test the preprocessor
// #define and #undef - expected output on screen is xa
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const a = 'a'
    // SCREEN[0] = a
    lda #'x'
    sta SCREEN
    // SCREEN[1] = a
    lda #a
    sta SCREEN+1
    // }
    rts
}
