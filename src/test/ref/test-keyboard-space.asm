// Test keyboard input - test the space bar
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BGCOL = $d021
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CIA1_PORT_B = $dc01
  // CIA #1 Port A data direction register.
  .label CIA1_PORT_A_DDR = $dc02
  // CIA #1 Port B data direction register.
  .label CIA1_PORT_B_DDR = $dc03
  .const GREEN = 5
  .const BLUE = 6
  .const KEY_SPACE = $3c
main: {
    jsr keyboard_init
  b6:
    lda #$ff
    cmp RASTER
    bne b6
    jsr keyboard_key_pressed
    cmp #0
    bne b10
    lda #BLUE
    sta BGCOL
    jmp b6
  b10:
    lda #GREEN
    sta BGCOL
    jmp b6
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
keyboard_key_pressed: {
    .const colidx = KEY_SPACE&7
    .label rowidx = KEY_SPACE>>3
    jsr keyboard_matrix_read
    and keyboard_matrix_col_bitmask+colidx
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask+keyboard_key_pressed.rowidx
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
// Initialize keyboard reading by setting CIA#$ Data Direction Registers
keyboard_init: {
    // Keyboard Matrix Columns Write Mode
    lda #$ff
    sta CIA1_PORT_A_DDR
    // Keyboard Matrix Columns Read Mode
    lda #0
    sta CIA1_PORT_B_DDR
    rts
}
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
