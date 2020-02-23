// Minimal struct - two instances being copied (using assignment)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    // point1.x = 2
    lda #2
    sta point1
    // point1.y = 3
    lda #3
    sta point1+OFFSET_STRUCT_POINT_Y
    // point2 = point1
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda point1-1,y
    sta point2-1,y
    dey
    bne !-
    // point2.x = 4
    lda #4
    sta point2
    // SCREEN[0] = point1.x
    lda point1
    sta SCREEN
    // SCREEN[1] = point1.y
    lda point1+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // SCREEN[2] = point2.x
    lda point2
    sta SCREEN+2
    // SCREEN[3] = point2.y
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    // }
    rts
}
  point1: .fill SIZEOF_STRUCT_POINT, 0
  point2: .fill SIZEOF_STRUCT_POINT, 0
