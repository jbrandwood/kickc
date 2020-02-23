// Minimal struct with C-Standard behavior - address-of
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label ptr = point1
    .label point1 = 2
    // point1 = { 2, 3 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta point1-1,y
    dey
    bne !-
    // SCREEN[0] = ptr->x
    lda.z ptr
    sta SCREEN
    // SCREEN[1] = ptr->y
    lda ptr+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
  __0: .byte 2, 3
