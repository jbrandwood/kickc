// Test of simple enum - char values with increment
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const B = 'b'
main: {
    .label SCREEN = $400
    // *SCREEN = letter
    lda #B
    sta SCREEN
    // }
    rts
}
