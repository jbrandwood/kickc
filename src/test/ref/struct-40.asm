// Minimal struct with Unwound behavior - struct containing struct copying
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const v1_p_x = 2
    .const v1_p_y = 3
    .const v1_q_x = 4
    .const v1_q_y = 5
    .const v3_q_x = 6
    .const v3_q_y = 7
    .const v4_q_x = 8
    .const v4_q_y = 9
    lda #v1_p_x
    sta SCREEN
    lda #v1_p_y
    sta SCREEN+1
    lda #v1_q_x
    sta SCREEN+2
    lda #v1_q_y
    sta SCREEN+3
    lda #v1_p_x
    sta SCREEN+4
    lda #v1_p_y
    sta SCREEN+5
    lda #v1_q_x
    sta SCREEN+6
    lda #v1_q_y
    sta SCREEN+7
    lda #v1_p_x
    sta SCREEN+8
    lda #v1_p_y
    sta SCREEN+9
    lda #v3_q_x
    sta SCREEN+$a
    lda #v3_q_y
    sta SCREEN+$b
    lda #v1_p_x
    sta SCREEN+$c
    lda #v1_p_y
    sta SCREEN+$d
    lda #v4_q_x
    sta SCREEN+$e
    lda #v4_q_y
    sta SCREEN+$f
    rts
}
