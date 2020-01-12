// Minimal struct - two instances being used.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
  .const SIZEOF_STRUCT_POINT = 2
main: {
    .label SCREEN = $400
    lda #2
    sta point1
    lda #3
    sta point1+OFFSET_STRUCT_POINT_Y
    sta point2
    lda point1
    sta point2+OFFSET_STRUCT_POINT_Y
    lda point2
    sta SCREEN
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
  point1: .fill SIZEOF_STRUCT_POINT, 0
  point2: .fill SIZEOF_STRUCT_POINT, 0
