.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label CIA1_PORT_A = $dc00
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
  b2:
    jsr menu
    jmp b2
}
menu: {
  b2:
    ldx #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq b4
    jsr pressed
  breturn:
    rts
  b4:
    ldx #KEY_I
    jsr keyboard_key_pressed
    cmp #0
    beq b5
    lda #RED
    sta BORDERCOL
    sei
    jmp breturn
  b5:
    ldx #KEY_E
    jsr keyboard_key_pressed
    cmp #0
    beq b6
    lda #GREEN
    sta BORDERCOL
    cli
    jmp breturn
  b6:
    inc SCREEN
    jmp b2
}
//  Determines whether a specific key is currently pressed by accessing the matrix directly
//  The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
//  All keys exist as as KEY_XXX constants.
//  Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
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
//  Read a single row of the keyboard matrix
//  The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
//  Returns the keys pressed on the row as bits according to the C64 key matrix.
//  Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
//  leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,x
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
pressed: {
    inc BGCOL
  b2:
    ldx #KEY_SPACE
    jsr keyboard_key_pressed
    cmp #0
    beq b2
    rts
}
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
