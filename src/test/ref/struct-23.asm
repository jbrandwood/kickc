// Minimal struct with C-Standard behavior - call return value (not supported yet)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label point1 = 2
    .label point2 = 4
    // getPoint(2, 3)
    lda #3
    ldx #2
    jsr getPoint
    // getPoint(2, 3)
    // point1 = getPoint(2, 3)
    stx.z point1
    sta point1+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = point1.x
    txa
    sta SCREEN
    // SCREEN[1] = point1.y
    lda point1+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // getPoint(4, 5)
    lda #5
    ldx #4
    jsr getPoint
    // getPoint(4, 5)
    // point2 = getPoint(4, 5)
    stx.z point2
    sta point2+OFFSET_STRUCT_POINT_Y
    // SCREEN[2] = point2.x
    txa
    sta SCREEN+2
    // SCREEN[3] = point2.y
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    // }
    rts
}
getPoint: {
    rts
}
