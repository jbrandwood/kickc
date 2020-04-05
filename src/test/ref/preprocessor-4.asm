// Test the preprocessor
// Test #ifdef
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[idx++] = '-'
    lda #'-'
    sta SCREEN
    // SCREEN[idx++] = 'a'
    lda #'a'
    sta SCREEN+1
    // SCREEN[idx++] = '-'
    lda #'-'
    sta SCREEN+2
    // }
    rts
}
