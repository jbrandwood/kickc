// Test of simple enum - two-value enum
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const ON = 1
main: {
    .label SCREEN = $400
    // *SCREEN = state
    lda #ON
    sta SCREEN
    // }
    rts
}
