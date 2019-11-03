// Allows analysis of the CHARGEN ROM font
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The address of the CHARGEN character set
  .label CHARGEN = $d000
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
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
main: {
    .label sc = 6
    .label i = 2
    .label ch = 5
    .label cur_pos = 3
    .label shift = 4
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  // Clear screen
  __b1:
    lda.z sc+1
    cmp #>SCREEN+$3e8
    bcs !__b2+
    jmp __b2
  !__b2:
    bne !+
    lda.z sc
    cmp #<SCREEN+$3e8
    bcs !__b2+
    jmp __b2
  !__b2:
  !:
    lda #<SCREEN+1
    sta.z print_str_at.at
    lda #>SCREEN+1
    sta.z print_str_at.at+1
    lda #<str
    sta.z print_str_at.str
    lda #>str
    sta.z print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+1+$a
    sta.z print_str_at.at
    lda #>SCREEN+1+$a
    sta.z print_str_at.at+1
    lda #<str1
    sta.z print_str_at.str
    lda #>str1
    sta.z print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+1+$14
    sta.z print_str_at.at
    lda #>SCREEN+1+$14
    sta.z print_str_at.at+1
    lda #<str2
    sta.z print_str_at.str
    lda #>str2
    sta.z print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+1+$1e
    sta.z print_str_at.at
    lda #>SCREEN+1+$1e
    sta.z print_str_at.at+1
    lda #<str3
    sta.z print_str_at.str
    lda #>str3
    sta.z print_str_at.str+1
    jsr print_str_at
    lda #0
    sta.z i
  __b4:
    ldy.z i
    ldx #0
    lda #$20
    jsr plot_chargen
    inc.z i
    lda #4
    cmp.z i
    bne __b4
    lda #0
    sta.z cur_pos
  __b5:
    ldx #KEY_F1
    jsr keyboard_key_pressed
    cmp #0
    beq __b6
    lda #0
    sta.z cur_pos
  __b6:
    ldx #KEY_F3
    jsr keyboard_key_pressed
    cmp #0
    beq __b7
    lda #1
    sta.z cur_pos
  __b7:
    ldx #KEY_F5
    jsr keyboard_key_pressed
    cmp #0
    beq __b8
    lda #2
    sta.z cur_pos
  __b8:
    ldx #KEY_F7
    jsr keyboard_key_pressed
    cmp #0
    beq __b9
    lda #3
    sta.z cur_pos
  __b9:
    ldx #KEY_LSHIFT
    jsr keyboard_key_pressed
    cmp #0
    bne __b10
    lda #0
    sta.z shift
    jmp __b11
  __b10:
    lda #1
    sta.z shift
  __b11:
    lda #0
    sta.z ch
  // Check for key presses - and plot char if found
  __b12:
    ldx.z ch
    jsr keyboard_get_keycode
    cmp #$3f
    beq b1
    tax
    jsr keyboard_key_pressed
    jmp __b13
  b1:
    lda #0
  __b13:
    cmp #0
    beq __b14
    ldy.z cur_pos
    lda.z ch
    ldx.z shift
    jsr plot_chargen
  __b14:
    inc.z ch
    lda #$40
    cmp.z ch
    bne __b12
    jmp __b5
  __b2:
    lda #' '
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
    str: .text "f1"
    .byte 0
    str1: .text "f3"
    .byte 0
    str2: .text "f5"
    .byte 0
    str3: .text "f7"
    .byte 0
}
// Render 8x8 char (ch) as pixels on char canvas #pos
// plot_chargen(byte register(Y) pos, byte register(A) ch, byte register(X) shift)
plot_chargen: {
    .label __0 = 6
    .label __1 = 6
    .label __7 = $a
    .label chargen = 6
    .label sc = $a
    .label bits = 9
    .label y = 8
    sei
    sta.z __0
    lda #0
    sta.z __0+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    clc
    lda.z chargen
    adc #<CHARGEN
    sta.z chargen
    lda.z chargen+1
    adc #>CHARGEN
    sta.z chargen+1
    cpx #0
    beq __b1
    clc
    lda.z chargen
    adc #<$800
    sta.z chargen
    lda.z chargen+1
    adc #>$800
    sta.z chargen+1
  __b1:
    lda #$32
    sta PROCPORT
    tya
    tax
    jsr mul8u
    clc
    lda.z sc
    adc #<SCREEN+$28+1
    sta.z sc
    lda.z sc+1
    adc #>SCREEN+$28+1
    sta.z sc+1
    lda #0
    sta.z y
  __b3:
    ldy.z y
    lda (chargen),y
    sta.z bits
    ldx #0
  __b4:
    lda #$80
    and.z bits
    cmp #0
    beq b1
    lda #'*'
    jmp __b5
  b1:
    lda #'.'
  __b5:
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    asl.z bits
    inx
    cpx #8
    bne __b4
    lda #$20
    clc
    adc.z sc
    sta.z sc
    bcc !+
    inc.z sc+1
  !:
    inc.z y
    lda #8
    cmp.z y
    bne __b3
    lda #$37
    sta PROCPORT
    cli
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a)
mul8u: {
    .const b = $a
    .label mb = $c
    .label res = $a
    .label return = $a
    lda #<b
    sta.z mb
    lda #>b
    sta.z mb+1
    lda #<0
    sta.z res
    sta.z res+1
  __b1:
    cpx #0
    bne __b2
    rts
  __b2:
    txa
    and #1
    cmp #0
    beq __b3
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
  __b3:
    txa
    lsr
    tax
    asl.z mb
    rol.z mb+1
    jmp __b1
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
// keyboard_key_pressed(byte register(X) key)
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
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
// keyboard_matrix_read(byte register(X) rowid)
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,x
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
// Get the keycode corresponding to a specific screen code character
// ch is the character to get the key code for ($00-$3f)
// Returns the key code corresponding to the passed character. Only characters with a non-shifted key are handled.
// If there is no non-shifted key representing the char $3f is returned (representing RUN/STOP) .
// keyboard_get_keycode(byte register(X) ch)
keyboard_get_keycode: {
    lda keyboard_char_keycodes,x
    rts
}
// Print a string at a specific screen position
// print_str_at(byte* zeropage($a) str, byte* zeropage($c) at)
print_str_at: {
    .label at = $c
    .label str = $a
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (str),y
    sta (at),y
    inc.z at
    bne !+
    inc.z at+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
  // Keycodes for each screen code character from $00-$3f.
  // Chars that do not have an unmodified keycode return $3f (representing RUN/STOP).
  keyboard_char_keycodes: .byte KEY_AT, KEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J, KEY_K, KEY_L, KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T, KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z, $3f, KEY_POUND, $3f, KEY_ARROW_UP, KEY_ARROW_LEFT, KEY_SPACE, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, KEY_ASTERISK, KEY_PLUS, KEY_COMMA, KEY_MINUS, KEY_DOT, KEY_SLASH, KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_COLON, KEY_SEMICOLON, $3f, KEY_EQUALS, $3f, $3f
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
