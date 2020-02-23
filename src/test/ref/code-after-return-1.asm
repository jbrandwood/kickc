// Test code after return in main()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const b = 0
main: {
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // }
    rts
}
