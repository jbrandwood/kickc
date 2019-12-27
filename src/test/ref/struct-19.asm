// Minimal struct with C-Standard behavior - struct containing struct with assignment of sub-struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_VECTOR_Q = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label v = 2
    .label p1 = 6
    .label p2 = 8
    lda #0
    sta.z v
    sta v+OFFSET_STRUCT_POINT_Y
    sta v+OFFSET_STRUCT_VECTOR_Q
    sta v+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    lda #2
    sta.z p1
    lda #3
    sta p1+OFFSET_STRUCT_POINT_Y
    lda #4
    sta.z p2
    lda #5
    sta p2+OFFSET_STRUCT_POINT_Y
    lda.z p1
    sta.z v
    lda p1+OFFSET_STRUCT_POINT_Y
    sta v+OFFSET_STRUCT_POINT_Y
    lda.z p2
    sta v+OFFSET_STRUCT_VECTOR_Q
    lda p2+OFFSET_STRUCT_POINT_Y
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
