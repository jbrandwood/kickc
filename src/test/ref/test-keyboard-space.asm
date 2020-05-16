// Test keyboard input - test the space bar
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const KEY_SPACE = $3c
  .const GREEN = 5
  .const BLUE = 6
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B_DDR = 3
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  .label RASTER = $d012
  .label BG_COLOR = $d021
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
main: {
    // keyboard_init()
    jsr keyboard_init
  __b1:
    // while (*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b1
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // if(keyboard_key_pressed(KEY_SPACE)!=0)
    cmp #0
    bne __b4
    // *BG_COLOR = BLUE
    lda #BLUE
    sta BG_COLOR
    jmp __b1
  __b4:
    // *BG_COLOR = GREEN
    lda #GREEN
    sta BG_COLOR
    jmp __b1
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
keyboard_key_pressed: {
    .const colidx = KEY_SPACE&7
    .label rowidx = KEY_SPACE>>3
    // keyboard_matrix_read(rowidx)
    jsr keyboard_matrix_read
    // keyboard_matrix_read(rowidx) & keyboard_matrix_col_bitmask[colidx]
    and keyboard_matrix_col_bitmask+colidx
    // }
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable the normal interrupt or sei/cli around calls to the keyboard matrix reader.
keyboard_matrix_read: {
    // CIA1->PORT_A = keyboard_matrix_row_bitmask[rowid]
    lda keyboard_matrix_row_bitmask+keyboard_key_pressed.rowidx
    sta CIA1
    // ~CIA1->PORT_B
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    eor #$ff
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
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
