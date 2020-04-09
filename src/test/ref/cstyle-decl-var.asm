// Test declarations of variables without definition
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The actual declarations
  .label SCREEN = $400
// And a little code using them
main: {
    // SCREEN[idx++] = 'c'
    lda #'c'
    sta SCREEN
    // SCREEN[idx++] = 'm'
    lda #'m'
    sta SCREEN+1
    // SCREEN[idx++] = 'l'
    lda #'l'
    sta SCREEN+2
    // }
    rts
}
