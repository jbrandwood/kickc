.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label COLS = $d800
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .const BLACK = 0
  .const GREEN = 5
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
  .const PLAYFIELD_LINES = $16
  .const PLAYFIELD_COLS = $a
  .const current_movedown_rate = $32
  .const current_movedown_rate_fast = 5
  .const COLLISION_NONE = 0
  .const COLLISION_PLAYFIELD = 1
  .const COLLISION_BOTTOM = 2
  .const COLLISION_LEFT = 4
  .const COLLISION_RIGHT = 8
  .label keyboard_events_size = $13
  .label current_ypos = 2
  .label current_xpos = $12
  .label current_piece_orientation = $e
  .label current_piece_gfx = $f
  .label current_piece = $c
  .label current_piece_color = $11
  .label current_movedown_counter = 3
  .label current_piece_15 = 5
  .label current_xpos_62 = 4
  .label current_piece_gfx_61 = 5
  .label current_piece_color_63 = 7
  .label current_xpos_92 = 4
  .label current_piece_gfx_82 = 5
  .label current_piece_color_70 = 7
  .label current_piece_67 = 5
  .label current_piece_68 = 5
  .label current_piece_69 = 5
  .label current_piece_70 = 5
  jsr main
main: {
    .label key_event = $14
    .label render = $15
    sei
    jsr init
    jsr spawn_current
    jsr render_playfield
    lda #GREEN
    sta current_piece_color_63
    lda #<piece_t
    sta current_piece_gfx_61
    lda #>piece_t
    sta current_piece_gfx_61+1
    lda #3
    sta current_xpos_62
    ldx #0
    jsr render_current
    lda #0
    sta current_movedown_counter
    sta keyboard_events_size
    sta current_ypos
    lda #3
    sta current_xpos
    lda #GREEN
    sta current_piece_color
    lda #<piece_t
    sta current_piece_gfx
    lda #>piece_t
    sta current_piece_gfx+1
    lda #0
    sta current_piece_orientation
    lda #<piece_t
    sta current_piece
    lda #>piece_t
    sta current_piece+1
  b4:
    lda RASTER
    cmp #$ff
    bne b4
  b7:
    lda RASTER
    cmp #$fe
    bne b7
    inc BORDERCOL
    jsr keyboard_event_scan
    jsr keyboard_event_get
    sta key_event
    jsr play_move_down
    txa
    clc
    adc #0
    sta render
    lda key_event
    jsr play_move_leftright
    clc
    adc render
    sta render
    lda key_event
    jsr play_move_rotate
    clc
    adc render
    cmp #0
    beq b10
    inc BORDERCOL
    jsr render_playfield
    ldx current_ypos
    lda current_xpos
    sta current_xpos_92
    lda current_piece_gfx
    sta current_piece_gfx_82
    lda current_piece_gfx+1
    sta current_piece_gfx_82+1
    lda current_piece_color
    sta current_piece_color_70
    jsr render_current
    dec BORDERCOL
  b10:
    dec BORDERCOL
    jmp b4
}
render_current: {
    .label ypos2 = 8
    .label l = 9
    .label screen_line = $16
    .label xpos = $b
    .label i = $a
    txa
    asl
    sta ypos2
    lda #0
    sta i
    sta l
  b1:
    lda ypos2
    cmp #2*PLAYFIELD_LINES
    bcs b2
    tay
    lda screen_lines,y
    sta screen_line
    lda screen_lines+1,y
    sta screen_line+1
    lda current_xpos_62
    sta xpos
    ldx #0
  b3:
    ldy i
    lda (current_piece_gfx_61),y
    inc i
    cmp #0
    beq b4
    lda xpos
    cmp #PLAYFIELD_COLS
    bcs b4
    lda current_piece_color_63
    ldy xpos
    sta (screen_line),y
  b4:
    inc xpos
    inx
    cpx #4
    bne b3
  b2:
    lda ypos2
    clc
    adc #2
    sta ypos2
    inc l
    lda l
    cmp #4
    bne b1
    rts
}
render_playfield: {
    .label line = 5
    .label i = 7
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
    ldx #0
  b2:
    ldy i
    lda playfield,y
    ldy #0
    sta (line),y
    inc line
    bne !+
    inc line+1
  !:
    inc i
    inx
    cpx #PLAYFIELD_COLS-1+1
    bne b2
    inc l
    lda l
    cmp #PLAYFIELD_LINES-1+1
    bne b1
    rts
}
play_move_rotate: {
    .label orientation = 4
    cmp #KEY_Z
    beq b1
    cmp #KEY_X
    beq b2
  b3:
    lda #0
  breturn:
    rts
  b2:
    lda #$10
    clc
    adc current_piece_orientation
    and #$3f
    sta orientation
  b4:
    lda current_xpos
    sta collision.xpos
    ldy current_ypos
    ldx orientation
    lda current_piece
    sta current_piece_70
    lda current_piece+1
    sta current_piece_70+1
    jsr collision
    and #COLLISION_LEFT|COLLISION_RIGHT
    cmp #0
    bne b3
    lda orientation
    sta current_piece_orientation
    clc
    adc current_piece
    sta current_piece_gfx
    lda #0
    adc current_piece+1
    sta current_piece_gfx+1
    lda #1
    jmp breturn
  b1:
    lda current_piece_orientation
    sec
    sbc #$10
    and #$3f
    sta orientation
    jmp b4
}
collision: {
    .label xpos = 7
    .label piece_gfx = 5
    .label ypos2 = 8
    .label playfield_line = $16
    .label i = $18
    .label col = $b
    .label l = 9
    .label i_2 = $a
    .label i_3 = $a
    .label i_11 = $a
    .label i_13 = $a
    txa
    clc
    adc piece_gfx
    sta piece_gfx
    lda #0
    adc piece_gfx+1
    sta piece_gfx+1
    tya
    asl
    sta ypos2
    lda #0
    sta l
    sta i_3
  b1:
    ldy ypos2
    lda playfield_lines,y
    sta playfield_line
    lda playfield_lines+1,y
    sta playfield_line+1
    lda xpos
    sta col
    ldx #0
  b2:
    ldy i_2
    iny
    sty i
    ldy i_2
    lda (piece_gfx),y
    cmp #0
    beq b3
    lda ypos2
    cmp #2*PLAYFIELD_LINES
    bcc b4
    lda #COLLISION_BOTTOM
  breturn:
    rts
  b4:
    lda #$80
    and col
    cmp #0
    beq b5
    lda #COLLISION_LEFT
    jmp breturn
  b5:
    lda col
    cmp #PLAYFIELD_COLS
    bcc b6
    lda #COLLISION_RIGHT
    jmp breturn
  b6:
    ldy col
    lda (playfield_line),y
    cmp #0
    beq b3
    lda #COLLISION_PLAYFIELD
    jmp breturn
  b3:
    inc col
    inx
    cpx #4
    bne b21
    lda ypos2
    clc
    adc #2
    sta ypos2
    inc l
    lda l
    cmp #4
    bne b20
    lda #COLLISION_NONE
    jmp breturn
  b20:
    lda i
    sta i_11
    jmp b1
  b21:
    lda i
    sta i_13
    jmp b2
}
play_move_leftright: {
    cmp #KEY_COMMA
    beq b1
    cmp #KEY_DOT
    bne b3
    ldy current_xpos
    iny
    sty collision.xpos
    ldy current_ypos
    ldx current_piece_orientation
    lda current_piece
    sta current_piece_69
    lda current_piece+1
    sta current_piece_69+1
    jsr collision
    cmp #COLLISION_NONE
    bne b3
    inc current_xpos
  b2:
    lda #1
    jmp breturn
  b3:
    lda #0
  breturn:
    rts
  b1:
    ldx current_xpos
    dex
    stx collision.xpos
    ldy current_ypos
    ldx current_piece_orientation
    lda current_piece
    sta current_piece_68
    lda current_piece+1
    sta current_piece_68+1
    jsr collision
    cmp #COLLISION_NONE
    bne b3
    dec current_xpos
    jmp b2
}
play_move_down: {
    inc current_movedown_counter
    cmp #KEY_SPACE
    bne b3
    ldx #1
    jmp b1
  b3:
    ldx #0
  b1:
    lda #KEY_SPACE
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b2
    lda current_movedown_counter
    cmp #current_movedown_rate_fast
    bcc b2
    inx
  b2:
    lda current_movedown_counter
    cmp #current_movedown_rate
    bcc b4
    inx
  b4:
    cpx #0
    beq b5
    ldy current_ypos
    iny
    lda current_xpos
    sta collision.xpos
    ldx current_piece_orientation
    lda current_piece
    sta current_piece_67
    lda current_piece+1
    sta current_piece_67+1
    jsr collision
    cmp #COLLISION_NONE
    beq b6
    jsr lock_current
    jsr spawn_current
    lda #3
    sta current_xpos
    lda #GREEN
    sta current_piece_color
    lda #<piece_t
    sta current_piece_gfx
    lda #>piece_t
    sta current_piece_gfx+1
    lda #0
    sta current_piece_orientation
    lda #<piece_t
    sta current_piece
    lda #>piece_t
    sta current_piece+1
    lda #0
    sta current_ypos
  b7:
    lda #0
    sta current_movedown_counter
    ldx #1
    jmp breturn
  b5:
    ldx #0
  breturn:
    rts
  b6:
    inc current_ypos
    jmp b7
}
spawn_current: {
    rts
}
lock_current: {
    .label playfield_line = 5
    .label i = 4
    .label l = 3
    lda #0
    sta i
    sta l
  b1:
    lda current_ypos
    clc
    adc l
    asl
    tay
    lda playfield_lines,y
    sta playfield_line
    lda playfield_lines+1,y
    sta playfield_line+1
    ldx #0
  b2:
    ldy i
    lda (current_piece_gfx),y
    inc i
    cmp #0
    beq b3
    txa
    clc
    adc current_xpos
    tay
    lda current_piece_color
    sta (playfield_line),y
  b3:
    inx
    cpx #4
    bne b2
    inc l
    lda l
    cmp #4
    bne b1
    rts
}
keyboard_event_pressed: {
    .label row_bits = 7
    .label keycode = 4
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
    lda keyboard_events_size
    cmp #0
    beq b1
    dec keyboard_events_size
    ldy keyboard_events_size
    lda keyboard_events,y
    jmp breturn
  b1:
    lda #$ff
  breturn:
    rts
}
keyboard_event_scan: {
    .label row_scan = 8
    .label keycode = 7
    .label row = 4
    lda #0
    sta keycode
    sta row
  b1:
    ldx row
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
    ldx #0
  b4:
    lda row_scan
    ldy row
    eor keyboard_scan_values,y
    and keyboard_matrix_col_bitmask,x
    cmp #0
    beq b5
    lda keyboard_events_size
    cmp #8
    beq b5
    lda keyboard_matrix_col_bitmask,x
    and row_scan
    cmp #0
    beq b7
    lda keycode
    ldy keyboard_events_size
    sta keyboard_events,y
    inc keyboard_events_size
  b5:
    inc keycode
    inx
    cpx #8
    bne b4
    lda row_scan
    ldy row
    sta keyboard_scan_values,y
    jmp b3
  b7:
    lda #$40
    ora keycode
    ldy keyboard_events_size
    sta keyboard_events,y
    inc keyboard_events_size
    jmp b5
}
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,x
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
init: {
    .label _13 = $c
    .label li = 5
    .label pli = 5
    .label line = 5
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
    cpx #PLAYFIELD_LINES+2+1
    bne b1
    lda #<playfield
    sta pli
    lda #>playfield
    sta pli+1
    ldx #0
  b2:
    txa
    asl
    tay
    lda pli
    sta playfield_lines,y
    lda pli+1
    sta playfield_lines+1,y
    lda pli
    clc
    adc #$a
    sta pli
    bcc !+
    inc pli+1
  !:
    inx
    cpx #PLAYFIELD_LINES-1+1
    bne b2
    lda #0
    sta l
    lda #<COLS+$e
    sta line
    lda #>COLS+$e
    sta line+1
  b3:
    ldx #0
  b4:
    txa
    clc
    adc line
    sta _13
    lda #0
    adc line+1
    sta _13+1
    lda #DARK_GREY
    ldy #0
    sta (_13),y
    inx
    cpx #PLAYFIELD_COLS+1+1
    bne b4
    lda line
    clc
    adc #$28
    sta line
    bcc !+
    inc line+1
  !:
    inc l
    lda l
    cmp #PLAYFIELD_LINES+1+1
    bne b3
    rts
}
fill: {
    .label end = $c
    .label addr = 5
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
  .align $40
  piece_t: .byte 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
  playfield_lines: .fill 2*PLAYFIELD_LINES, 0
  playfield: .fill PLAYFIELD_LINES*PLAYFIELD_COLS, 0
  screen_lines: .fill 2*(PLAYFIELD_LINES+3), 0
