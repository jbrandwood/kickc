// Struct - forced __ssa
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const point_x = 2
  .const point_y = 3
main: {
    lda #point_x
    sta SCREEN
    lda #point_y
    sta SCREEN+1
    rts
}
