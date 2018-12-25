.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BGCOL = $d021
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .label CIA1_PORT_A_DDR = $dc02
  .label CIA1_PORT_B_DDR = $dc03
  .const GREEN = 5
  .const BLUE = 6
  .const KEY_SPACE = $3c
main: {
    jsr keyboard_init
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    jsr keyboard_key_pressed
    cmp #0
    bne b5
    lda #BLUE
    sta BGCOL
    jmp b4
  b5:
    lda #GREEN
    sta BGCOL
    jmp b4
}
keyboard_key_pressed: {
    .const colidx = KEY_SPACE&7
    .label rowidx = KEY_SPACE>>3
    jsr keyboard_matrix_read
    and keyboard_matrix_col_bitmask+colidx
    rts
}
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask+keyboard_key_pressed.rowidx
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
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
