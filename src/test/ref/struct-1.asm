// Minimal struct - two instances being used.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const point1_x = 2
  .const point1_y = 3
main: {
    .label SCREEN = $400
    lda #point1_y
    sta SCREEN
    lda #point1_x
    sta SCREEN+1
    rts
}
