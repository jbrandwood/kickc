// Test the preprocessor
// Test multi-line macro
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[idx++] = '-'
    lda #'-'
    sta SCREEN
    // PRINTXX
    lda #'x'
    sta SCREEN+1
    sta SCREEN+2
    // SCREEN[idx++] = '-'
    lda #'-'
    sta SCREEN+3
    // }
    rts
}
