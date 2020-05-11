// Test including a files with a #define and using it
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const x = 'a'
  .label SCREEN = $400
main: {
    // SCREEN[0] = x
    lda #x
    sta SCREEN
    // }
    rts
}
