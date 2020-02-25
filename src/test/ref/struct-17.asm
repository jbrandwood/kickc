// Minimal struct with C-Standard behavior - struct containing struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_VECTOR = 4
  .const OFFSET_STRUCT_POINT_Y = 1
  .const OFFSET_STRUCT_VECTOR_Q = 2
main: {
    .label v = 2
    // v
    ldy #SIZEOF_STRUCT_VECTOR
    lda #0
  !:
    dey
    sta v,y
    bne !-
    // v.p.x = 2
    lda #2
    sta.z v
    // v.p.y = 3
    lda #3
    sta v+OFFSET_STRUCT_POINT_Y
    // v.q.x = 4
    lda #4
    sta v+OFFSET_STRUCT_VECTOR_Q
    // v.q.y = 5
    lda #5
    sta v+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = v.p.x
    lda.z v
    sta SCREEN
    // SCREEN[1] = v.p.y
    lda v+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // SCREEN[2] = v.q.x
    lda v+OFFSET_STRUCT_VECTOR_Q
    sta SCREEN+2
    // SCREEN[3] = v.q.y
    lda v+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    // }
    rts
}
