// Minimal struct - two instances being copied (using assignment)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const point1_x = 2
  .const point1_y = 3
  .const point2_x = 4
main: {
    .label SCREEN = $400
    lda #point1_x
    sta SCREEN
    lda #point1_y
    sta SCREEN+1
    lda #point2_x
    sta SCREEN+2
    lda #point1_y
    sta SCREEN+3
    rts
}
