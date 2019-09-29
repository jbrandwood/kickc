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
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CIA1_PORT_B = $dc01
  .const RED = 2
  .const GREEN = 5
  .const KEY_E = $e
  .const KEY_C = $14
  .const KEY_I = $21
  .const KEY_SPACE = $3c
  .label SCREEN = $400
main: {
    lda #GREEN
    sta BORDERCOL
  __b1:
    jsr menu
    jmp __b1
}
menu: {
  __b1:
    ldx #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq __b2
    jsr pressed
    rts
  __b2:
    ldx #KEY_I
    jsr keyboard_key_pressed
    cmp #0
    beq __b3
    lda #RED
    sta BORDERCOL
    sei
    rts
  __b3:
    ldx #KEY_E
    jsr keyboard_key_pressed
    cmp #0
    beq __b4
    lda #GREEN
    sta BORDERCOL
    cli
    rts
  __b4:
    inc SCREEN
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
pressed: {
    inc BGCOL
  __b1:
    ldx #KEY_SPACE
    jsr keyboard_key_pressed
    cmp #0
    bne __breturn
    jmp __b1
  __breturn:
    rts
}
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
