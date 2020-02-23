// Struct - forced __ssa
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const point_x = 2
  .const point_y = 3
main: {
    // SCREEN[0] = point.x
    lda #point_x
    sta SCREEN
    // SCREEN[1] = point.y
    lda #point_y
    sta SCREEN+1
    // }
    rts
}
