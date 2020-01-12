// Minimal struct - declaration, instantiation and usage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
  .const SIZEOF_STRUCT_POINT = 2
main: {
    .label SCREEN = $400
    lda #2
    sta point
    lda #3
    sta point+OFFSET_STRUCT_POINT_Y
    lda point
    sta SCREEN
    lda point+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
  point: .fill SIZEOF_STRUCT_POINT, 0
