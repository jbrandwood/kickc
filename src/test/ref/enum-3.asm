// Test of simple enum - value with complex calculation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BROKEN = 4*4+2+1
main: {
    .label SCREEN = $400
    lda #BROKEN
    sta SCREEN
    rts
}
