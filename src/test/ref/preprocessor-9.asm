// Test the preprocessor
// Macro with parameters
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[idx++] = SUM
    lda #'0'+4
    sta SCREEN
    // SCREEN[idx++] = DOUBLE
    lda #'b'+'b'
    sta SCREEN+1
    // SCREEN[idx++] = SQUARE
    lda #'c'*'c'
    sta SCREEN+2
    // }
    rts
}
