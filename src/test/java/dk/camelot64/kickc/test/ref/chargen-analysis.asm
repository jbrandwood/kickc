.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PROCPORT = 1
  .label CHARGEN = $d000
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .const KEY_F7 = 3
  .const KEY_F1 = 4
  .const KEY_F3 = 5
  .const KEY_F5 = 6
  .const KEY_3 = 8
  .const KEY_W = 9
  .const KEY_A = $a
  .const KEY_4 = $b
  .const KEY_Z = $c
  .const KEY_S = $d
  .const KEY_E = $e
  .const KEY_LSHIFT = $f
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
  .label SCREEN = $400
  jsr main
main: {
    .label sc = 2
    .label i = 4
    .label ch = 6
    .label cur_pos = 4
    .label shift = 5
    lda #<SCREEN
    sta sc
    lda #>SCREEN
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
    cmp #>SCREEN+$3e8
    bcc b1
    bne !+
    lda sc
    cmp #<SCREEN+$3e8
    bcc b1
  !:
    lda #<SCREEN+1
    sta print_str_at.at
    lda #>SCREEN+1
    sta print_str_at.at+1
    lda #<str
    sta print_str_at.str
    lda #>str
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+1+$a
    sta print_str_at.at
    lda #>SCREEN+1+$a
    sta print_str_at.at+1
    lda #<str1
    sta print_str_at.str
    lda #>str1
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+1+$14
    sta print_str_at.at
    lda #>SCREEN+1+$14
    sta print_str_at.at+1
    lda #<str2
    sta print_str_at.str
    lda #>str2
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+1+$1e
    sta print_str_at.at
    lda #>SCREEN+1+$1e
    sta print_str_at.at+1
    lda #<str3
    sta print_str_at.str
    lda #>str3
    sta print_str_at.str+1
    jsr print_str_at
    lda #0
    sta i
  b2:
    ldx i
    ldy #0
    lda #$20
    jsr plot_chargen
    inc i
    lda i
    cmp #4
    bne b2
    lda #0
    sta cur_pos
  b3:
    ldx #KEY_F1
    jsr keyboard_key_pressed
    cmp #0
    beq b4
    lda #0
    sta cur_pos
  b4:
    ldx #KEY_F3
    jsr keyboard_key_pressed
    cmp #0
    beq b5
    lda #1
    sta cur_pos
  b5:
    ldx #KEY_F5
    jsr keyboard_key_pressed
    cmp #0
    beq b6
    lda #2
    sta cur_pos
  b6:
    ldx #KEY_F7
    jsr keyboard_key_pressed
    cmp #0
    beq b7
    lda #3
    sta cur_pos
  b7:
    ldx #KEY_LSHIFT
    jsr keyboard_key_pressed
    cmp #0
    beq b8
    lda #1
    sta shift
    jmp b9
  b8:
    lda #0
    sta shift
  b9:
    lda #0
    sta ch
  b10:
    ldx ch
    jsr keyboard_get_keycode
    cmp #$3f
    beq b13
    tax
    jsr keyboard_key_pressed
    jmp b11
  b13:
    lda #0
  b11:
    cmp #0
    beq b12
    ldx cur_pos
    lda ch
    ldy shift
    jsr plot_chargen
  b12:
    inc ch
    lda ch
    cmp #$40
    bne b10
    jmp b3
    str: .text "f1@"
    str1: .text "f3@"
    str2: .text "f5@"
    str3: .text "f7@"
}
plot_chargen: {
    .label _0 = 2
    .label _1 = 2
    .label _8 = 9
    .label chargen = 2
    .label sc = 9
    .label bits = 8
    .label y = 7
    sei
    sta _0
    lda #0
    sta _0+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    clc
    lda chargen
    adc #<CHARGEN
    sta chargen
    lda chargen+1
    adc #>CHARGEN
    sta chargen+1
    cpy #0
    beq b1
    clc
    lda chargen
    adc #<$800
    sta chargen
    lda chargen+1
    adc #>$800
    sta chargen+1
  b1:
    lda #$32
    sta PROCPORT
    jsr mul8u
    clc
    lda sc
    adc #<SCREEN+$28+1
    sta sc
    lda sc+1
    adc #>SCREEN+$28+1
    sta sc+1
    lda #0
    sta y
  b2:
    ldy y
    lda (chargen),y
    sta bits
    ldx #0
  b3:
    lda #$80
    and bits
    cmp #0
    beq b5
    lda #'*'
    jmp b4
  b5:
    lda #'.'
  b4:
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    asl bits
    inx
    cpx #8
    bne b3
    lda sc
    clc
    adc #$20
    sta sc
    bcc !+
    inc sc+1
  !:
    inc y
    lda y
    cmp #8
    bne b2
    lda #$37
    sta PROCPORT
    cli
    rts
}
mul8u: {
    .const b = $a
    .label mb = $b
    .label res = 9
    .label return = 9
    lda #<b
    sta mb
    lda #>b
    sta mb+1
    lda #<0
    sta res
    sta res+1
  b1:
    cpx #0
    bne b2
    rts
  b2:
    txa
    and #1
    cmp #0
    beq b4
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
  b4:
    txa
    lsr
    tax
    asl mb
    rol mb+1
    jmp b1
}
keyboard_key_pressed: {
    txa
    and #7
    tay
    txa
    lsr
    lsr
    lsr
    tax
    jsr keyboard_matrix_read
    and keyboard_matrix_col_bitmask,y
    rts
}
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,x
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
keyboard_get_keycode: {
    lda keyboard_char_keycodes,x
    rts
}
print_str_at: {
    .label at = 9
    .label str = 2
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (at),y
    inc at
    bne !+
    inc at+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  keyboard_char_keycodes: .byte KEY_AT, KEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J, KEY_K, KEY_L, KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T, KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z, $3f, KEY_POUND, $3f, KEY_ARROW_UP, KEY_ARROW_LEFT, KEY_SPACE, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, KEY_ASTERISK, KEY_PLUS, KEY_COMMA, KEY_MINUS, KEY_DOT, KEY_SLASH, KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_COLON, KEY_SEMICOLON, $3f, KEY_EQUALS, $3f, $3f
