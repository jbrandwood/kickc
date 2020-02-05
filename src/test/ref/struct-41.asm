// Minimal struct with Unwound behavior - struct containing struct copying
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
  .const OFFSET_STRUCT_VECTOR_Q = 2
  .const SIZEOF_STRUCT_VECTOR = 4
  .const SIZEOF_STRUCT_POINT = 2
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
    lda #v1_p_x
    sta.z v2
    lda #v1_p_y
    sta v2+OFFSET_STRUCT_POINT_Y
    lda #v1_q_x
    sta v2+OFFSET_STRUCT_VECTOR_Q
    lda #v1_q_y
    sta v2+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
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
    ldy #SIZEOF_STRUCT_VECTOR
  !:
    lda v3-1,y
    sta v4-1,y
    dey
    bne !-
    ldy.z v4
    ldx v4+OFFSET_STRUCT_POINT_Y
    lda #v1_p_x
    sta SCREEN
    lda #v1_p_y
    sta SCREEN+1
    lda #v1_q_x
    sta SCREEN+2
    lda #v1_q_y
    sta SCREEN+3
    lda.z v2
    sta SCREEN+4
    lda v2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+5
    lda v2+OFFSET_STRUCT_VECTOR_Q
    sta SCREEN+6
    lda v2+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+7
    lda.z v3
    sta SCREEN+8
    lda v3+OFFSET_STRUCT_POINT_Y
    sta SCREEN+9
    lda v3+OFFSET_STRUCT_VECTOR_Q
    sta SCREEN+$a
    lda v3+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+$b
    tya
    sta SCREEN+$c
    txa
    sta SCREEN+$d
    lda v4+OFFSET_STRUCT_VECTOR_Q
    sta SCREEN+$e
    lda v4+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+$f
    sty SCREEN+$10
    stx SCREEN+$11
    lda #v5_q_x
    sta SCREEN+$12
    lda #v5_q_y
    sta SCREEN+$13
    rts
}
  __0: .byte 6, 7
