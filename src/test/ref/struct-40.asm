// Minimal struct with Unwound behavior - struct containing struct copying
  // Commodore 64 PRG executable file
.file [name="struct-40.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .const v1_p_x = 2
    .const v1_p_y = 3
    .const v1_q_x = 4
    .const v1_q_y = 5
    .const v3_q_x = 6
    .const v3_q_y = 7
    .const v4_q_x = 8
    .const v4_q_y = 9
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
    lda #v1_p_x
    sta SCREEN+4
    // SCREEN[idx++] = v2.p.y
    lda #v1_p_y
    sta SCREEN+5
    // SCREEN[idx++] = v2.q.x
    lda #v1_q_x
    sta SCREEN+6
    // SCREEN[idx++] = v2.q.y
    lda #v1_q_y
    sta SCREEN+7
    // SCREEN[idx++] = v3.p.x
    lda #v1_p_x
    sta SCREEN+8
    // SCREEN[idx++] = v3.p.y
    lda #v1_p_y
    sta SCREEN+9
    // SCREEN[idx++] = v3.q.x
    lda #v3_q_x
    sta SCREEN+$a
    // SCREEN[idx++] = v3.q.y
    lda #v3_q_y
    sta SCREEN+$b
    // SCREEN[idx++] = v4.p.x
    lda #v1_p_x
    sta SCREEN+$c
    // SCREEN[idx++] = v4.p.y
    lda #v1_p_y
    sta SCREEN+$d
    // SCREEN[idx++] = v4.q.x
    lda #v4_q_x
    sta SCREEN+$e
    // SCREEN[idx++] = v4.q.y
    lda #v4_q_y
    sta SCREEN+$f
    // }
    rts
}
