// Test removal of empty function
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[0] = 'x'
    lda #'x'
    sta SCREEN
    // }
    rts
}
