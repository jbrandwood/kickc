// Test of simple enum - three-value enum with specified integer values and increment
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BROKEN = 9
main: {
    .label SCREEN = $400
    lda #BROKEN
    sta SCREEN
    rts
}
