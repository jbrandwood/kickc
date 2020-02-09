// Minimal struct with C-Standard behavior - struct containing struct with initializer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_VECTOR = 4
  .const OFFSET_STRUCT_POINT_Y = 1
  .const OFFSET_STRUCT_VECTOR_Q = 2
main: {
    .label v = 2
    ldy #SIZEOF_STRUCT_VECTOR
  !:
    lda __0-1,y
    sta v-1,y
    dey
    bne !-
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
  __0: .byte 2, 3, 4, 5
