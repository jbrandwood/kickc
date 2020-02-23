// Minimal struct with C-Standard behavior - struct containing struct with initializer using sub-struct value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_VECTOR_Q = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label p1 = 2
    .label p2 = 4
    .label v = 6
    // p1 = { 2, 3 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta p1-1,y
    dey
    bne !-
    // p2 = { 4, 5 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __1-1,y
    sta p2-1,y
    dey
    bne !-
    // v = { p1, p2 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda p1-1,y
    sta v-1,y
    dey
    bne !-
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda p2-1,y
    sta v+OFFSET_STRUCT_VECTOR_Q-1,y
    dey
    bne !-
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
  __0: .byte 2, 3
  __1: .byte 4, 5
