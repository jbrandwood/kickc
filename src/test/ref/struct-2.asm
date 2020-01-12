// Minimal struct - two instances being copied (using assignment)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    lda #2
    sta point1
    lda #3
    sta point1+OFFSET_STRUCT_POINT_Y
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda point1-1,y
    sta point2-1,y
    dey
    bne !-
    lda #4
    sta point2
    lda point1
    sta SCREEN
    lda point1+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    lda point2
    sta SCREEN+2
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    rts
}
  point1: .fill SIZEOF_STRUCT_POINT, 0
  point2: .fill SIZEOF_STRUCT_POINT, 0
