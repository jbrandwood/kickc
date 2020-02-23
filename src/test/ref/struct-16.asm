// Minimal struct with C-Standard behavior - initializer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label point1 = 2
    // point1 = { 2, 3 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta point1-1,y
    dey
    bne !-
    // SCREEN[0] = point1.x
    lda.z point1
    sta SCREEN
    // SCREEN[1] = point1.y
    lda point1+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
  __0: .byte 2, 3
