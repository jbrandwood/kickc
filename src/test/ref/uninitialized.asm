// Tests uninitialized values of variables.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const b = 0
  .label SCREEN = $400
main: {
    lda #b
    sta SCREEN
    lda #0
    sta SCREEN+2
    sta SCREEN+3
    sta SCREEN+5
    sta SCREEN+5
    rts
}
