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
  jsr main
main: {
    lda #GREEN
    sta BORDERCOL
  b2:
    jsr menu
    jmp b2
}
menu: {
    jmp b2
  breturn:
    rts
  b2:
    ldx #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq b4
    jsr pressed
    jmp breturn
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
pressed: {
    inc BGCOL
    jmp b2
  breturn:
    rts
  b2:
    ldx #KEY_SPACE
    jsr keyboard_key_pressed
    cmp #0
    beq b2
    jmp breturn
}
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
