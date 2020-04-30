// Exploring keyboard glitch that finds "C" press when pressing space
// The glitch is caused by the "normal" C64 interrupt occuring just as the keyboard is read.
// Press "I" to disable interrupts (red border)
// Press "E" to enable interrupts (green border)
// Press "C" to enter pressed state (increaded bgcol) - and "SPACE" to leave presssed state again.
// Holding SPACE will sometimes trigger the pressed state when normal interrupts are enabled (green border)
// but never when they are disabled (red border)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const KEY_E = $e
  .const KEY_C = $14
  .const KEY_I = $21
  .const KEY_SPACE = $3c
  .const RED = 2
  .const GREEN = 5
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  .label SCREEN = $400
main: {
    // *BORDERCOL = GREEN
    lda #GREEN
    sta BORDERCOL
  __b1:
    // menu()
    jsr menu
    jmp __b1
}
menu: {
  __b1:
    // keyboard_key_pressed(KEY_C)
    ldx #KEY_C
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_C)
    // if(keyboard_key_pressed(KEY_C)!=0)
    cmp #0
    beq __b2
    // pressed()
    jsr pressed
    // }
    rts
  __b2:
    // keyboard_key_pressed(KEY_I)
    ldx #KEY_I
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_I)
    // if(keyboard_key_pressed(KEY_I)!=0)
    cmp #0
    beq __b3
    // *BORDERCOL = RED
    lda #RED
    sta BORDERCOL
    // asm
    sei
    rts
  __b3:
    // keyboard_key_pressed(KEY_E)
    ldx #KEY_E
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_E)
    // if(keyboard_key_pressed(KEY_E)!=0)
    cmp #0
    beq __b4
    // *BORDERCOL = GREEN
    lda #GREEN
    sta BORDERCOL
    // asm
    cli
    rts
  __b4:
    // (*SCREEN)++;
    inc SCREEN
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
pressed: {
    // (*BGCOL)++;
    inc BGCOL
  __b1:
    // keyboard_key_pressed(KEY_SPACE)
    ldx #KEY_SPACE
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // if(keyboard_key_pressed(KEY_SPACE)!=0)
    cmp #0
    bne __breturn
    jmp __b1
  __breturn:
    // }
    rts
}
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
