// Minimal struct with C-Standard behavior - declaration, instantiation and usage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
  .const SIZEOF_STRUCT_POINT = 2
main: {
    // point.x = 2
    lda #2
    sta point
    // point.y = 3
    lda #3
    sta point+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = point.x
    lda point
    sta SCREEN
    // SCREEN[1] = point.y
    lda point+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
  point: .fill SIZEOF_STRUCT_POINT, 0
