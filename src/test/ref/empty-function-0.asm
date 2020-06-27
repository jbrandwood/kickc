// Test removal of empty function
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const v = 7
  .label SCREEN = $400
main: {
    // SCREEN[0] = v
    lda #v
    sta SCREEN
    // }
    rts
}
