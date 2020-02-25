// Minimal struct - direct (constant) array access
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    // points[0].x = 2
    lda #2
    sta points
    // points[0].y = 3
    lda #3
    sta points+OFFSET_STRUCT_POINT_Y
    // points[1].x = 5
    lda #5
    sta points+1*SIZEOF_STRUCT_POINT
    // points[1].y = 6
    lda #6
    sta points+OFFSET_STRUCT_POINT_Y+1*SIZEOF_STRUCT_POINT
    // SCREEN[0] = points[0].x
    lda points
    sta SCREEN
    // SCREEN[1] = points[0].y
    lda points+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // SCREEN[3] = points[1].x
    lda points+1*SIZEOF_STRUCT_POINT
    sta SCREEN+3
    // SCREEN[4] = points[1].y
    lda points+OFFSET_STRUCT_POINT_Y+1*SIZEOF_STRUCT_POINT
    sta SCREEN+4
    // }
    rts
}
  points: .fill 2*2, 0
