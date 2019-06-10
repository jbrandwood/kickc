// Minimal struct - direct (constant) array access
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    lda #2
    sta points
    lda #3
    sta points+OFFSET_STRUCT_POINT_Y
    lda #5
    sta points+1*SIZEOF_STRUCT_POINT
    lda #6
    sta points+OFFSET_STRUCT_POINT_Y+1*SIZEOF_STRUCT_POINT
    lda points
    sta SCREEN
    lda points+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    lda points+1*SIZEOF_STRUCT_POINT
    sta SCREEN+3
    lda points+OFFSET_STRUCT_POINT_Y+1*SIZEOF_STRUCT_POINT
    sta SCREEN+4
    rts
}
  points: .fill 2*2, 0
