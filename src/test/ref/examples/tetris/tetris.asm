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
  .label keyboard_events_size = $12
  .label current_ypos = 2
  .label current_piece_orientation = $d
  .label current_piece_gfx = $e
  .label current_xpos = $11
  .label current_piece = $b
  .label current_piece_color = $10
  .label current_movedown_counter = 3
  .label current_ypos_35 = 4
  .label current_piece_gfx_46 = 5
  .label current_piece_gfx_75 = 5
  .label current_xpos_81 = 7
  .label current_piece_color_62 = 8
  .label current_ypos_75 = 4
  .label current_piece_gfx_99 = 5
  .label current_xpos_91 = 7
  .label current_piece_color_69 = 8
  .label current_piece_gfx_108 = 5
  .label current_piece_gfx_109 = 5
  .label current_piece_gfx_110 = 5
  jsr main
main: {
    .label key_event = $a
    .label render = $13
    sei
    jsr init
    jsr spawn_current
    jsr render_playfield
    lda #GREEN
    sta current_piece_color_62
    lda #3
    sta current_xpos_81
    lda #<piece_t
    sta current_piece_gfx_75
    lda #>piece_t
    sta current_piece_gfx_75+1
    lda #0
    sta current_ypos_35
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
    jsr play_movedown
    txa
    clc
    adc #0
    sta render
    ldx key_event
    jsr play_moveother
    clc
    adc render
    cmp #0
    beq b10
    inc BORDERCOL
    jsr render_playfield
    lda current_ypos
    sta current_ypos_75
    lda current_piece_gfx
    sta current_piece_gfx_99
    lda current_piece_gfx+1
    sta current_piece_gfx_99+1
    lda current_xpos
    sta current_xpos_91
    lda current_piece_color
    sta current_piece_color_69
    jsr render_current
    dec BORDERCOL
  b10:
    dec BORDERCOL
    jmp b4
}
render_current: {
    .label l = 9
    .label screen_line = $14
    .label i = $a
    lda #0
    sta i
    sta l
  b1:
    lda current_ypos_35
    clc
    adc l
    cmp #PLAYFIELD_LINES
    bcs b2
    asl
    tay
    lda screen_lines,y
    sta screen_line
    lda screen_lines+1,y
    sta screen_line+1
    ldx #0
  b3:
    ldy i
    lda (current_piece_gfx_75),y
    inc i
    cmp #0
    beq b4
    txa
    clc
    adc current_xpos_81
    cmp #PLAYFIELD_COLS
    bcs b4
    tay
    lda current_piece_color_62
    sta (screen_line),y
  b4:
    inx
    cpx #4
    bne b3
  b2:
    inc l
    lda l
    cmp #4
    bne b1
    rts
}
render_playfield: {
    .label _3 = $14
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
    txa
    clc
    adc line
    sta _3
    lda #0
    adc line+1
    sta _3+1
    ldy i
    lda playfield,y
    ldy #0
    sta (_3),y
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
play_moveother: {
    txa
    and #$80
    cmp #0
    bne b6
    cpx #KEY_COMMA
    beq b2
    cpx #KEY_DOT
    beq b3
    cpx #KEY_Z
    beq b4
    cpx #KEY_X
    bne b6
    lda #$10
    clc
    adc current_piece_orientation
    and #$3f
    sta current_piece_orientation
    clc
    adc current_piece
    sta current_piece_gfx
    lda #0
    adc current_piece+1
    sta current_piece_gfx+1
  b5:
    lda #1
    jmp b1
  b6:
    lda #0
  b1:
    rts
  b4:
    lda current_piece_orientation
    sec
    sbc #$10
    and #$3f
    sta current_piece_orientation
    clc
    adc current_piece
    sta current_piece_gfx
    lda #0
    adc current_piece+1
    sta current_piece_gfx+1
    jmp b5
  b3:
    ldy current_xpos
    iny
    sty collision.xpos
    lda current_ypos
    sta collision.ypos
    lda current_piece_gfx
    sta current_piece_gfx_110
    lda current_piece_gfx+1
    sta current_piece_gfx_110+1
    jsr collision
    cmp #COLLISION_NONE
    bne b6
    inc current_xpos
    jmp b5
  b2:
    ldx current_xpos
    dex
    stx collision.xpos
    lda current_ypos
    sta collision.ypos
    lda current_piece_gfx
    sta current_piece_gfx_109
    lda current_piece_gfx+1
    sta current_piece_gfx_109+1
    jsr collision
    cmp #COLLISION_NONE
    bne b6
    dec current_xpos
    jmp b5
}
collision: {
    .label ypos = 4
    .label xpos = 7
    .label line = $16
    .label playfield_line = $14
    .label i = $17
    .label l = 8
    .label i_2 = 9
    .label i_3 = 9
    .label i_11 = 9
    .label i_13 = 9
    lda #0
    sta i_3
    sta l
  b1:
    lda ypos
    clc
    adc l
    sta line
    asl
    tay
    lda playfield_lines,y
    sta playfield_line
    lda playfield_lines+1,y
    sta playfield_line+1
    ldx #0
  b2:
    ldy i_2
    iny
    sty i
    ldy i_2
    lda (current_piece_gfx_46),y
    cmp #0
    beq b3
    lda line
    cmp #PLAYFIELD_LINES
    bcc b4
    lda #COLLISION_BOTTOM
  breturn:
    rts
  b4:
    txa
    clc
    adc xpos
    tay
    tya
    and #$80
    cmp #0
    beq b5
    lda #COLLISION_LEFT
    jmp breturn
  b5:
    cpy #PLAYFIELD_COLS
    bcc b6
    lda #COLLISION_RIGHT
    jmp breturn
  b6:
    lda (playfield_line),y
    cmp #0
    beq b3
    lda #COLLISION_PLAYFIELD
    jmp breturn
  b3:
    inx
    cpx #4
    bne b21
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
play_movedown: {
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
    sty collision.ypos
    lda current_xpos
    sta collision.xpos
    lda current_piece_gfx
    sta current_piece_gfx_108
    lda current_piece_gfx+1
    sta current_piece_gfx_108+1
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
    .label _13 = $b
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
    .label end = $b
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
