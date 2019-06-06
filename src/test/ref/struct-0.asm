// Minimal struct - declaration, instantiation and usage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const point_x = 2
  .const point_y = 3
main: {
    .label SCREEN = $400
    lda #point_x
    sta SCREEN
    lda #point_y
    sta SCREEN+1
    rts
}
