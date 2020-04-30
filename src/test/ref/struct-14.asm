// Minimal struct with C-Standard behavior - declaration, instantiation and usage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
main: {
    // points[0].x = 2
    lda #2
    sta points
    // points[0].y = 3
    lda #3
    sta points+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = points[0].x
    lda points
    sta SCREEN
    // SCREEN[1] = points[0].y
    lda points+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
  points: .fill 2*1, 0
