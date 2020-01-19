// Minimal struct with C-Standard behavior - copy assignment through struct pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label p2 = point2
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda point1-1,y
    sta p2-1,y
    dey
    bne !-
    lda point2
    sta SCREEN
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
  point1: .byte 2, 3
  point2: .fill SIZEOF_STRUCT_POINT, 0
