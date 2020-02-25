// Minimal struct with Unwound behavior - struct containing struct copying
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
  .const OFFSET_STRUCT_VECTOR_Q = 2
  .const SIZEOF_STRUCT_POINT = 2
  .const SIZEOF_STRUCT_VECTOR = 4
main: {
    .const v1_p_x = 2
    .const v1_p_y = 3
    .const v1_q_x = 4
    .const v1_q_y = 5
    .const v5_q_x = 8
    .const v5_q_y = 9
    .label v2 = 2
    .label v3 = 6
    .label v4 = $a
    // v2 = v1
    lda #v1_p_x
    sta.z v2
    lda #v1_p_y
    sta v2+OFFSET_STRUCT_POINT_Y
    lda #v1_q_x
    sta v2+OFFSET_STRUCT_VECTOR_Q
    lda #v1_q_y
    sta v2+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    // v3 = { v2.p, {6, 7} }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda v2-1,y
    sta v3-1,y
    dey
    bne !-
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta v3+OFFSET_STRUCT_VECTOR_Q-1,y
    dey
    bne !-
    // v4 = v3
    ldy #SIZEOF_STRUCT_VECTOR
  !:
    lda v3-1,y
    sta v4-1,y
    dey
    bne !-
    // v5 = { {v4.p.x, v4.p.y }, {8, 9} }
    ldy.z v4
    ldx v4+OFFSET_STRUCT_POINT_Y
    // SCREEN[idx++] = v1.p.x
    lda #v1_p_x
    sta SCREEN
    // SCREEN[idx++] = v1.p.y
    lda #v1_p_y
    sta SCREEN+1
    // SCREEN[idx++] = v1.q.x
    lda #v1_q_x
    sta SCREEN+2
    // SCREEN[idx++] = v1.q.y
    lda #v1_q_y
    sta SCREEN+3
    // SCREEN[idx++] = v2.p.x
    lda.z v2
    sta SCREEN+4
    // SCREEN[idx++] = v2.p.y
    lda v2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+5
    // SCREEN[idx++] = v2.q.x
    lda v2+OFFSET_STRUCT_VECTOR_Q
    sta SCREEN+6
    // SCREEN[idx++] = v2.q.y
    lda v2+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+7
    // SCREEN[idx++] = v3.p.x
    lda.z v3
    sta SCREEN+8
    // SCREEN[idx++] = v3.p.y
    lda v3+OFFSET_STRUCT_POINT_Y
    sta SCREEN+9
    // SCREEN[idx++] = v3.q.x
    lda v3+OFFSET_STRUCT_VECTOR_Q
    sta SCREEN+$a
    // SCREEN[idx++] = v3.q.y
    lda v3+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+$b
    // SCREEN[idx++] = v4.p.x
    tya
    sta SCREEN+$c
    // SCREEN[idx++] = v4.p.y
    txa
    sta SCREEN+$d
    // SCREEN[idx++] = v4.q.x
    lda v4+OFFSET_STRUCT_VECTOR_Q
    sta SCREEN+$e
    // SCREEN[idx++] = v4.q.y
    lda v4+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+$f
    // SCREEN[idx++] = v5.p.x
    sty SCREEN+$10
    // SCREEN[idx++] = v5.p.y
    stx SCREEN+$11
    // SCREEN[idx++] = v5.q.x
    lda #v5_q_x
    sta SCREEN+$12
    // SCREEN[idx++] = v5.q.y
    lda #v5_q_y
    sta SCREEN+$13
    // }
    rts
}
  __0: .byte 6, 7
