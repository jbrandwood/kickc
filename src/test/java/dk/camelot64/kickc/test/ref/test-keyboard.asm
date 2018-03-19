.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .label CIA1_PORT_A_DDR = $dc02
  .label CIA1_PORT_B_DDR = $dc03
  jsr main
main: {
    .label sc = 2
    .label row_pressed_bits = 4
    .label screen = 2
    .label ch = 4
    lda #<$400
    sta sc
    lda #>$400
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
    cmp #>$400+$3e8
    bcc b1
    bne !+
    lda sc
    cmp #<$400+$3e8
    bcc b1
  !:
    jsr keyboard_init
  b5:
    lda RASTER
    cmp #$ff
    bne b5
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #0
  b6:
    txa
    jsr keyboard_matrix_read
    sta row_pressed_bits
    ldy #0
  b7:
    lda #$80
    and row_pressed_bits
    cmp #0
    beq b8
    lda #'1'
    sta (screen),y
  b9:
    asl row_pressed_bits
    iny
    cpy #8
    bne b7
    lda screen
    clc
    adc #$28
    sta screen
    bcc !+
    inc screen+1
  !:
    inx
    cpx #8
    bne b6
    lda screen
    clc
    adc #$28
    sta screen
    bcc !+
    inc screen+1
  !:
    ldx #0
  b10:
    lda chars,x
    sta ch
    jsr keyboard_char_pressed
    cmp #0
    beq b11
    txa
    tay
    lda ch
    sta (screen),y
  b12:
    inx
    cpx #6
    bne b10
    jmp b5
  b11:
    txa
    tay
    lda #' '
    sta (screen),y
    jmp b12
  b8:
    lda #'0'
    sta (screen),y
    jmp b9
    chars: .byte '@', 'a', 'b', 'c', 'd', 'e'
}
keyboard_char_pressed: {
    .label _1 = 5
    .label ch = 4
    ldy ch
    jsr keyboard_matrix_row
    jsr keyboard_matrix_read
    sta _1
    ldy ch
    jsr keyboard_matrix_col
    and _1
    rts
}
keyboard_matrix_col: {
    lda keyboard_matrix_chars,y
    lsr
    lsr
    lsr
    lsr
    tay
    lda keyboard_matrix_col_bitmask,y
    rts
}
keyboard_matrix_read: {
    tay
    lda keyboard_row_bits,y
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
keyboard_matrix_row: {
    lda keyboard_matrix_chars,y
    and #$f
    rts
}
keyboard_init: {
    lda #$ff
    sta CIA1_PORT_A_DDR
    lda #0
    sta CIA1_PORT_B_DDR
    rts
}
  keyboard_row_bits: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  keyboard_matrix_chars: .byte $65, $21, $43, $42, $22, $61
