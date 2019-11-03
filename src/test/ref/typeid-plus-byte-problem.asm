// Test that byte+byte creates a byte - even when there is a value overflow
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const ubc1 = $27
    .const ubc2 = $fa
    lda #ubc1+ubc2
    sta SCREEN
    rts
}
