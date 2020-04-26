// Test keyboard input - in the keyboard matrix and mapping screen codes to key codes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
  .label RASTER = $d012
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B_DDR = 3
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
main: {
    .label sc = 2
    .label screen = 5
    .label row = 4
    .label ch = 7
    // Checks all specific chars $00-$3f
    .label i = 8
    lda #<$400
    sta.z sc
    lda #>$400
    sta.z sc+1
  // Clear screen
  __b1:
    // for(byte* sc = $400; sc<$400+1000;sc++)
    lda.z sc+1
    cmp #>$400+$3e8
    bcs !__b2+
    jmp __b2
  !__b2:
    bne !+
    lda.z sc
    cmp #<$400+$3e8
    bcs !__b2+
    jmp __b2
  !__b2:
  !:
    // keyboard_init()
    // Init keyboard
    jsr keyboard_init
  __b4:
    // while (*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b4
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #0
    sta.z row
  // Read & print keyboard matrix
  __b5:
    // keyboard_matrix_read(row)
    ldx.z row
    jsr keyboard_matrix_read
    // keyboard_matrix_read(row)
    // row_pressed_bits = keyboard_matrix_read(row)
    tax
    ldy #0
  __b6:
    // row_pressed_bits & $80
    txa
    and #$80
    // if( (row_pressed_bits & $80) != 0)
    cmp #0
    bne __b7
    // screen[col] = '0'
    lda #'0'
    sta (screen),y
  __b8:
    // row_pressed_bits = row_pressed_bits * 2
    txa
    asl
    tax
    // for(byte col : 0..7)
    iny
    cpy #8
    bne __b6
    // screen = screen + 40
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // for(byte row : 0..7)
    inc.z row
    lda #8
    cmp.z row
    bne __b5
    // screen = screen + 40
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    lda #0
    sta.z i
    sta.z ch
  __b12:
    // keyboard_get_keycode(ch)
    ldx.z ch
    jsr keyboard_get_keycode
    // key = keyboard_get_keycode(ch)
    // if(key!=$3f)
    cmp #$3f
    beq __b13
    // keyboard_key_pressed(key)
    tax
    jsr keyboard_key_pressed
    // if(keyboard_key_pressed(key)!=0)
    cmp #0
    beq __b13
    // screen[i++] = ch
    lda.z ch
    ldy.z i
    sta (screen),y
    // screen[i++] = ch;
    inc.z i
  __b13:
    // for( byte ch : 0..$3f )
    inc.z ch
    lda #$40
    cmp.z ch
    bne __b12
  __b3:
  // Add some spaces
    // screen[i++] = ' '
    lda #' '
    ldy.z i
    sta (screen),y
    // screen[i++] = ' ';
    inc.z i
    // while (i<5)
    lda.z i
    cmp #5
    bcc __b3
    jmp __b4
  __b7:
    // screen[col] = '1'
    lda #'1'
    sta (screen),y
    jmp __b8
  __b2:
    // *sc = ' '
    lda #' '
    ldy #0
    sta (sc),y
    // for(byte* sc = $400; sc<$400+1000;sc++)
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
// keyboard_key_pressed(byte register(X) key)
keyboard_key_pressed: {
    // colidx = key&7
    txa
    and #7
    tay
    // rowidx = key>>3
    txa
    lsr
    lsr
    lsr
    // keyboard_matrix_read(rowidx)
    tax
    jsr keyboard_matrix_read
    // keyboard_matrix_read(rowidx)
    // keyboard_matrix_read(rowidx) & keyboard_matrix_col_bitmask[colidx]
    and keyboard_matrix_col_bitmask,y
    // }
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
// keyboard_matrix_read(byte register(X) rowid)
keyboard_matrix_read: {
    // CIA1->PORT_A = keyboard_matrix_row_bitmask[rowid]
    lda keyboard_matrix_row_bitmask,x
    sta CIA1
    // ~CIA1->PORT_B
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    eor #$ff
    // }
    rts
}
// Get the keycode corresponding to a specific screen code character
// ch is the character to get the key code for ($00-$3f)
// Returns the key code corresponding to the passed character. Only characters with a non-shifted key are handled.
// If there is no non-shifted key representing the char $3f is returned (representing RUN/STOP) .
// keyboard_get_keycode(byte register(X) ch)
keyboard_get_keycode: {
    // return keyboard_char_keycodes[ch];
    lda keyboard_char_keycodes,x
    // }
    rts
}
// Initialize keyboard reading by setting CIA#$ Data Direction Registers
keyboard_init: {
    // CIA1->PORT_A_DDR = $ff
    // Keyboard Matrix Columns Write Mode
    lda #$ff
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA1->PORT_B_DDR = $00
    // Keyboard Matrix Columns Read Mode
    lda #0
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B_DDR
    // }
    rts
}
  // Keycodes for each screen code character from $00-$3f.
  // Chars that do not have an unmodified keycode return $3f (representing RUN/STOP).
  keyboard_char_keycodes: .byte KEY_AT, KEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J, KEY_K, KEY_L, KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T, KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z, $3f, KEY_POUND, $3f, KEY_ARROW_UP, KEY_ARROW_LEFT, KEY_SPACE, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, KEY_ASTERISK, KEY_PLUS, KEY_COMMA, KEY_MINUS, KEY_DOT, KEY_SLASH, KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_COLON, KEY_SEMICOLON, $3f, KEY_EQUALS, $3f, $3f
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
