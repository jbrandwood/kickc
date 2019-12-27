// Minimal struct with C-Standard behavior - struct containing struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_VECTOR_Q = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label v = 2
    lda #0
    sta.z v
    sta v+OFFSET_STRUCT_POINT_Y
    sta v+OFFSET_STRUCT_VECTOR_Q
    sta v+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    lda #2
    sta.z v
    lda #3
    sta v+OFFSET_STRUCT_POINT_Y
    lda #4
    sta v+OFFSET_STRUCT_VECTOR_Q
    lda #5
    sta v+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    lda.z v
    sta SCREEN
    lda v+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    lda v+OFFSET_STRUCT_VECTOR_Q
    sta SCREEN+2
    lda v+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    rts
}
