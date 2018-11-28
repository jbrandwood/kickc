.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label COLS = $d800
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .const BLACK = 0
  .const DARK_GREY = $b
  .const KEY_Z = $c
  .const KEY_LSHIFT = $f
  .const KEY_X = $17
  .const KEY_DOT = $2c
  .const KEY_COMMA = $2f
  .const KEY_RSHIFT = $34
  .const KEY_CTRL = $3a
  .const KEY_SPACE = $3c
  .const KEY_COMMODORE = $3d
  .label SCREEN = $400
  .const current_movedown_rate = $32
  .const current_movedown_rate_fast = 5
  .label current_movedown_counter = 2
  .label current_xpos = 5
  .label current_piece_orientation = 6
  .label current_ypos = 3
  .label current_ypos_14 = 4
  .label current_xpos_26 = 7
  .label current_ypos_62 = 4
  .label current_xpos_64 = 7
  jsr main
main: {
    .label key_event = 8
    .label movedown = 4
    jsr init
    jsr render_playfield
    lda #3
    sta current_xpos_26
    lda #0
    sta current_ypos_14
    tay
    jsr render_current
    lda #3
    sta current_xpos
    lda #0
    sta current_ypos
    sta current_movedown_counter
    tax
    sta current_piece_orientation
  b4:
    lda RASTER
    cmp #$ff
    bne b4
  b7:
    lda RASTER
    cmp #$fe
    bne b7
    jsr keyboard_event_scan
    jsr keyboard_event_get
    sta key_event
    inc current_movedown_counter
    cmp #KEY_SPACE
    bne b1
    lda #1
    sta movedown
    jmp b10
  b1:
    lda #0
    sta movedown
  b10:
    lda #KEY_SPACE
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b11
    lda current_movedown_counter
    cmp #current_movedown_rate_fast
    bcc b11
    inc movedown
  b11:
    lda current_movedown_counter
    cmp #current_movedown_rate
    bcc b13
    inc movedown
  b13:
    lda movedown
    beq b2
    jsr current_movedown
    lda #0
    sta current_movedown_counter
    ldy #1
    jmp b14
  b2:
    ldy #0
  b14:
    lda #$80
    and key_event
    cmp #0
    bne b15
    lda key_event
    cmp #KEY_COMMA
    bne b16
    dec current_xpos
    iny
  b16:
    lda key_event
    cmp #KEY_DOT
    bne b17
    inc current_xpos
    iny
  b17:
    lda key_event
    cmp #KEY_Z
    bne b18
    lda current_piece_orientation
    sec
    sbc #$10
    and #$3f
    sta current_piece_orientation
    iny
  b18:
    lda key_event
    cmp #KEY_X
    bne b15
    lda #$10
    clc
    adc current_piece_orientation
    and #$3f
    sta current_piece_orientation
    iny
  b15:
    cpy #0
    bne !b4+
    jmp b4
  !b4:
    inc BORDERCOL
    jsr render_playfield
    ldy current_piece_orientation
    lda current_ypos
    sta current_ypos_62
    lda current_xpos
    sta current_xpos_64
    jsr render_current
    dec BORDERCOL
    jmp b4
}
render_current: {
    .label current_piece_gfx = $b
    .label screen_line = $d
    .label current_cell = $f
    .label i = 9
    .label c = $a
    .label l = 8
    tya
    clc
    adc #<piece_t
    sta current_piece_gfx
    lda #>piece_t
    adc #0
    sta current_piece_gfx+1
    lda #0
    sta i
    sta l
  b1:
    lda current_ypos_14
    clc
    adc l
    asl
    tay
    lda screen_lines,y
    sta screen_line
    lda screen_lines+1,y
    sta screen_line+1
    lda #0
    sta c
  b2:
    ldy i
    lda (current_piece_gfx),y
    sta current_cell
    inc i
    beq b3
    lda current_xpos_26
    clc
    adc c
    cmp #$a
    bcs b3
    tay
    lda current_cell
    sta (screen_line),y
  b3:
    inc c
    lda c
    cmp #4
    bne b2
    inc l
    lda l
    cmp #4
    bne b1
    rts
}
render_playfield: {
    .label _1 = $d
    .label line = $b
    .label i = 8
    .label c = 7
    .label l = 4
    lda #0
    sta i
    sta l
  b1:
    lda l
    asl
    tay
    lda screen_lines,y
    sta line
    lda screen_lines+1,y
    sta line+1
    lda #0
    sta c
  b2:
    lda c
    clc
    adc line
    sta _1
    lda #0
    adc line+1
    sta _1+1
    ldy i
    lda playfield,y
    ldy #0
    sta (_1),y
    inc i
    inc c
    lda c
    cmp #$a
    bne b2
    inc l
    lda l
    cmp #$14
    bne b1
    rts
}
current_movedown: {
    inc current_ypos
    rts
}
keyboard_event_pressed: {
    .label row_bits = 9
    .label keycode = 7
    lda keycode
    lsr
    lsr
    lsr
    tay
    lda keyboard_scan_values,y
    sta row_bits
    lda #7
    and keycode
    tay
    lda keyboard_matrix_col_bitmask,y
    and row_bits
    rts
}
keyboard_event_get: {
    cpx #0
    beq b1
    dex
    lda keyboard_events,x
    jmp breturn
  b1:
    lda #$ff
  breturn:
    rts
}
keyboard_event_scan: {
    .label row_scan = 9
    .label keycode = 8
    .label row = 4
    .label col = 7
    lda #0
    sta keycode
    sta row
  b1:
    ldy row
    jsr keyboard_matrix_read
    sta row_scan
    ldy row
    cmp keyboard_scan_values,y
    bne b2
    lda #8
    clc
    adc keycode
    sta keycode
  b3:
    inc row
    lda row
    cmp #8
    bne b1
    lda #KEY_LSHIFT
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    lda #KEY_RSHIFT
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    lda #KEY_CTRL
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    lda #KEY_COMMODORE
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    rts
  b2:
    lda #0
    sta col
  b4:
    lda row_scan
    ldy row
    eor keyboard_scan_values,y
    ldy col
    and keyboard_matrix_col_bitmask,y
    cmp #0
    beq b5
    cpx #8
    beq b5
    lda row_scan
    and keyboard_matrix_col_bitmask,y
    cmp #0
    beq b7
    lda keycode
    sta keyboard_events,x
    inx
  b5:
    inc keycode
    inc col
    lda col
    cmp #8
    bne b4
    lda row_scan
    ldy row
    sta keyboard_scan_values,y
    jmp b3
  b7:
    lda #$40
    ora keycode
    sta keyboard_events,x
    inx
    jmp b5
}
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,y
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
init: {
    .label _7 = $d
    .label li = $b
    .label line = $b
    .label l = 2
    ldx #$a0
    lda #<SCREEN
    sta fill.addr
    lda #>SCREEN
    sta fill.addr+1
    jsr fill
    ldx #BLACK
    lda #<COLS
    sta fill.addr
    lda #>COLS
    sta fill.addr+1
    jsr fill
    lda #<COLS+$28+$f
    sta li
    lda #>COLS+$28+$f
    sta li+1
    ldx #0
  b1:
    txa
    asl
    tay
    lda li
    sta screen_lines,y
    lda li+1
    sta screen_lines+1,y
    lda li
    clc
    adc #$28
    sta li
    bcc !+
    inc li+1
  !:
    inx
    cpx #$14
    bne b1
    lda #0
    sta l
    lda #<COLS+$e
    sta line
    lda #>COLS+$e
    sta line+1
  b2:
    ldx #0
  b3:
    txa
    clc
    adc line
    sta _7
    lda #0
    adc line+1
    sta _7+1
    lda #DARK_GREY
    ldy #0
    sta (_7),y
    inx
    cpx #$c
    bne b3
    lda line
    clc
    adc #$28
    sta line
    bcc !+
    inc line+1
  !:
    inc l
    lda l
    cmp #$16
    bne b2
    rts
}
fill: {
    .label end = $d
    .label addr = $b
    lda addr
    clc
    adc #<$3e8
    sta end
    lda addr+1
    adc #>$3e8
    sta end+1
  b1:
    txa
    ldy #0
    sta (addr),y
    inc addr
    bne !+
    inc addr+1
  !:
    lda addr+1
    cmp end+1
    bne b1
    lda addr
    cmp end
    bne b1
    rts
}
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  keyboard_events: .fill 8, 0
  keyboard_scan_values: .fill 8, 0
  screen_lines: .fill 2*$14, 0
  .align $40
  piece_t: .byte 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
  playfield: .fill $14*$a, 0
