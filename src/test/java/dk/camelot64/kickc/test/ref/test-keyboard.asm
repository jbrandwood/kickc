.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .label CIA1_PORT_A_DDR = $dc02
  .label CIA1_PORT_B_DDR = $dc03
  .const KEY_3 = 8
  .const KEY_W = 9
  .const KEY_A = $a
  .const KEY_4 = $b
  .const KEY_Z = $c
  .const KEY_S = $d
  .const KEY_E = $e
  .const KEY_5 = $10
  .const KEY_R = $11
  .const KEY_D = $12
  .const KEY_6 = $13
  .const KEY_C = $14
  .const KEY_F = $15
  .const KEY_T = $16
  .const KEY_X = $17
  .const KEY_7 = $18
  .const KEY_Y = $19
  .const KEY_G = $1a
  .const KEY_8 = $1b
  .const KEY_B = $1c
  .const KEY_H = $1d
  .const KEY_U = $1e
  .const KEY_V = $1f
  .const KEY_9 = $20
  .const KEY_I = $21
  .const KEY_J = $22
  .const KEY_0 = $23
  .const KEY_M = $24
  .const KEY_K = $25
  .const KEY_O = $26
  .const KEY_N = $27
  .const KEY_PLUS = $28
  .const KEY_P = $29
  .const KEY_L = $2a
  .const KEY_MINUS = $2b
  .const KEY_DOT = $2c
  .const KEY_COLON = $2d
  .const KEY_AT = $2e
  .const KEY_COMMA = $2f
  .const KEY_POUND = $30
  .const KEY_ASTERISK = $31
  .const KEY_SEMICOLON = $32
  .const KEY_EQUALS = $35
  .const KEY_ARROW_UP = $36
  .const KEY_SLASH = $37
  .const KEY_1 = $38
  .const KEY_ARROW_LEFT = $39
  .const KEY_2 = $3b
  .const KEY_SPACE = $3c
  .const KEY_Q = $3e
  jsr main
main: {
    .label sc = 2
    .label row_pressed_bits = 4
    .label screen = 2
    .label i = 4
    lda #<$400
    sta sc
    lda #>$400
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>$400+$3e8
    bcc b1
    bne !+
    lda sc
    cmp #<$400+$3e8
    bcc b1
  !:
    jsr keyboard_init
  b5:
    lda RASTER
    cmp #$ff
    bne b5
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #0
  b6:
    txa
    jsr keyboard_matrix_read
    sta row_pressed_bits
    ldy #0
  b7:
    lda #$80
    and row_pressed_bits
    cmp #0
    beq b8
    lda #'1'
    sta (screen),y
  b9:
    asl row_pressed_bits
    iny
    cpy #8
    bne b7
    lda screen
    clc
    adc #$28
    sta screen
    bcc !+
    inc screen+1
  !:
    inx
    cpx #8
    bne b6
    lda screen
    clc
    adc #$28
    sta screen
    bcc !+
    inc screen+1
  !:
    lda #0
    sta i
    tax
  b10:
    jsr keyboard_get_keycode
    cmp #$3f
    beq b11
    sta keyboard_key_pressed.key
    jsr keyboard_key_pressed
    cmp #0
    beq b11
    ldy i
    txa
    sta (screen),y
    inc i
  b11:
    inx
    cpx #$40
    bne b10
  b13:
    lda #' '
    ldy i
    sta (screen),y
    inc i
    lda i
    cmp #5
    bcc b13
    jmp b5
  b8:
    lda #'0'
    sta (screen),y
    jmp b9
}
keyboard_key_pressed: {
    .label _1 = 6
    .label key = 5
    lda key
    lsr
    lsr
    lsr
    jsr keyboard_matrix_read
    sta _1
    lda #7
    and key
    tay
    lda keyboard_matrix_col_bitmask,y
    and _1
    rts
}
keyboard_matrix_read: {
    tay
    lda keyboard_matrix_row_bitmask,y
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
keyboard_get_keycode: {
    lda keyboard_char_keycodes,x
    rts
}
keyboard_init: {
    lda #$ff
    sta CIA1_PORT_A_DDR
    lda #0
    sta CIA1_PORT_B_DDR
    rts
}
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  keyboard_char_keycodes: .byte KEY_AT, KEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J, KEY_K, KEY_L, KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T, KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z, $3f, KEY_POUND, $3f, KEY_ARROW_UP, KEY_ARROW_LEFT, KEY_SPACE, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, KEY_ASTERISK, KEY_PLUS, KEY_COMMA, KEY_MINUS, KEY_DOT, KEY_SLASH, KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_COLON, KEY_SEMICOLON, $3f, KEY_EQUALS, $3f, $3f