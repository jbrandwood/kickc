.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label PROCPORT_DDR = 0
  .const PROCPORT_DDR_MEMORY_MASK = 7
  .label PROCPORT = 1
  .const PROCPORT_RAM_IO = $35
  .const SPRITE_PTRS = $3f8
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_MC = $d01c
  .label SPRITES_EXPAND_X = $d01d
  .label BORDERCOL = $d020
  .label BGCOL1 = $d021
  .label BGCOL2 = $d022
  .label BGCOL3 = $d023
  .label BGCOL4 = $d024
  .label SPRITES_COLS = $d027
  .label VIC_CONTROL = $d011
  .label D011 = $d011
  .const VIC_ECM = $40
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D018 = $d018
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .const IRQ_RASTER = 1
  .label COLS = $d800
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .label CIA1_INTERRUPT = $dc0d
  .const CIA_INTERRUPT_CLEAR = $7f
  .label CIA2_PORT_A = $dd00
  .label CIA2_PORT_A_DDR = $dd02
  .label HARDWARE_IRQ = $fffe
  .const BLACK = 0
  .const CYAN = 3
  .const BLUE = 6
  .const GREY = $c
  .const KEY_Z = $c
  .const KEY_LSHIFT = $f
  .const KEY_X = $17
  .const KEY_DOT = $2c
  .const KEY_COMMA = $2f
  .const KEY_RSHIFT = $34
  .const KEY_CTRL = $3a
  .const KEY_SPACE = $3c
  .const KEY_COMMODORE = $3d
  .const KEY_MODIFIER_LSHIFT = 1
  .const KEY_MODIFIER_RSHIFT = 2
  .const KEY_MODIFIER_CTRL = 4
  .const KEY_MODIFIER_COMMODORE = 8
  .label SID_VOICE3_FREQ = $d40e
  .label SID_VOICE3_CONTROL = $d412
  .const SID_CONTROL_NOISE = $80
  .label SID_VOICE3_OSC = $d41b
  .label PLAYFIELD_SCREEN_1 = $400
  .label PLAYFIELD_SCREEN_2 = $2c00
  .label PLAYFIELD_SCREEN_ORIGINAL = $1800
  .label PLAYFIELD_COLORS_ORIGINAL = $1c00
  .label PLAYFIELD_SPRITES = $2000
  .label PLAYFIELD_CHARSET = $2800
  .const PLAYFIELD_LINES = $16
  .const PLAYFIELD_COLS = $a
  .const IRQ_RASTER_FIRST = $31
  .const current_movedown_fast = 2
  .const COLLISION_NONE = 0
  .const COLLISION_PLAYFIELD = 1
  .const COLLISION_BOTTOM = 2
  .const COLLISION_LEFT = 4
  .const COLLISION_RIGHT = 8
  .label PLAYFIELD_SPRITE_PTRS_1 = PLAYFIELD_SCREEN_1+SPRITE_PTRS
  .label PLAYFIELD_SPRITE_PTRS_2 = PLAYFIELD_SCREEN_2+SPRITE_PTRS
  .const toSpritePtr1_return = PLAYFIELD_SPRITES>>6
  .label keyboard_events_size = $21
  .label render_screen_showing = $23
  .label irq_raster_next = $22
  .label irq_sprite_ypos = $24
  .label irq_sprite_ptr = $25
  .label irq_cnt = $26
  .label current_movedown_slow = $18
  .label current_movedown_counter = 4
  .label current_ypos = $10
  .label current_piece_gfx = $1d
  .label current_xpos = $1f
  .label current_piece_char = $20
  .label current_orientation = $1c
  .label level_bcd = $19
  .label render_screen_render = 3
  .label render_screen_show = 2
  .label lines_bcd = $11
  .label score_bcd = $13
  .label level = $17
  .label current_piece = $1a
  .label current_piece_12 = 5
  .label render_screen_render_30 = 9
  .label current_xpos_47 = $a
  .label current_piece_gfx_53 = 5
  .label render_screen_render_64 = 9
  .label current_xpos_112 = $a
  .label current_xpos_113 = $a
  .label current_piece_gfx_102 = 5
  .label current_piece_gfx_103 = 5
  .label current_piece_76 = 5
  .label current_piece_77 = 5
  .label current_piece_78 = 5
  .label current_piece_79 = 5
bbegin:
  lda #0
  sta render_screen_showing
  lda #IRQ_RASTER_FIRST
  sta irq_raster_next
  lda #$32
  sta irq_sprite_ypos
  lda #toSpritePtr1_return
  sta irq_sprite_ptr
  lda #0
  sta irq_cnt
  jsr main
main: {
    .label key_event = $f
    .label render = $27
    jsr sid_rnd_init
    sei
    jsr render_init
    jsr sprites_init
    jsr sprites_irq_init
    jsr play_init
    jsr play_spawn_current
    ldx #$40
    jsr render_playfield
    ldy current_ypos
    lda current_xpos
    sta current_xpos_112
    lda current_piece_gfx
    sta current_piece_gfx_102
    lda current_piece_gfx+1
    sta current_piece_gfx_102+1
    ldx current_piece_char
    lda #$40
    sta render_screen_render_30
    jsr render_moving
    ldy play_spawn_current._3
    lda PIECES,y
    sta current_piece
    lda PIECES+1,y
    sta current_piece+1
    lda #0
    sta level_bcd
    sta level
    sta score_bcd
    sta score_bcd+1
    sta score_bcd+2
    sta score_bcd+3
    sta lines_bcd
    sta lines_bcd+1
    sta current_movedown_counter
    sta keyboard_events_size
    sta current_orientation
    lda #$40
    sta render_screen_render
    lda #0
    sta render_screen_show
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    jsr render_show
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
    beq b4
    ldx render_screen_render
    jsr render_playfield
    ldy current_ypos
    lda render_screen_render
    sta render_screen_render_64
    lda current_xpos
    sta current_xpos_113
    lda current_piece_gfx
    sta current_piece_gfx_103
    lda current_piece_gfx+1
    sta current_piece_gfx_103+1
    ldx current_piece_char
    jsr render_moving
    jsr render_score
    jsr render_screen_swap
    jmp b4
}
render_screen_swap: {
    lda render_screen_render
    eor #$40
    sta render_screen_render
    lda render_screen_show
    eor #$40
    sta render_screen_show
    rts
}
render_score: {
    .label score_bytes = score_bcd
    .const score_offset = $28*5+$1c
    .const lines_offset = $28*1+$16
    .const level_offset = $28*$13+$1f
    .label screen = 5
    lda render_screen_render
    cmp #0
    beq b1
    lda #<PLAYFIELD_SCREEN_2
    sta screen
    lda #>PLAYFIELD_SCREEN_2
    sta screen+1
    jmp b2
  b1:
    lda #<PLAYFIELD_SCREEN_1
    sta screen
    lda #>PLAYFIELD_SCREEN_1
    sta screen+1
  b2:
    ldx score_bytes+2
    ldy #0
    lda #<score_offset
    sta render_bcd.offset
    lda #>score_offset
    sta render_bcd.offset+1
    jsr render_bcd
    ldx score_bytes+1
    ldy #0
    lda #<score_offset+2
    sta render_bcd.offset
    lda #>score_offset+2
    sta render_bcd.offset+1
    jsr render_bcd
    ldx score_bytes
    ldy #0
    lda #<score_offset+4
    sta render_bcd.offset
    lda #>score_offset+4
    sta render_bcd.offset+1
    jsr render_bcd
    lda lines_bcd+1
    tax
    ldy #1
    lda #<lines_offset
    sta render_bcd.offset
    lda #>lines_offset
    sta render_bcd.offset+1
    jsr render_bcd
    lda lines_bcd
    tax
    ldy #0
    lda #<lines_offset+1
    sta render_bcd.offset
    lda #>lines_offset+1
    sta render_bcd.offset+1
    jsr render_bcd
    ldx level_bcd
    ldy #0
    lda #<level_offset
    sta render_bcd.offset
    lda #>level_offset
    sta render_bcd.offset+1
    jsr render_bcd
    rts
}
render_bcd: {
    .const ZERO_CHAR = $33
    .label screen = 5
    .label screen_pos = 7
    .label offset = 7
    lda screen_pos
    clc
    adc screen
    sta screen_pos
    lda screen_pos+1
    adc screen+1
    sta screen_pos+1
    cpy #0
    bne b1
    txa
    lsr
    lsr
    lsr
    lsr
    clc
    adc #ZERO_CHAR
    ldy #0
    sta (screen_pos),y
    inc screen_pos
    bne !+
    inc screen_pos+1
  !:
  b1:
    txa
    and #$f
    clc
    adc #ZERO_CHAR
    ldy #0
    sta (screen_pos),y
    inc screen_pos
    bne !+
    inc screen_pos+1
  !:
    rts
}
render_moving: {
    .label ypos2 = $b
    .label screen_line = 7
    .label xpos = $e
    .label i = $d
    .label l = $c
    .label c = $f
    tya
    asl
    sta ypos2
    lda #0
    sta l
    sta i
  b1:
    lda ypos2
    cmp #2
    beq !+
    bcs b13
  !:
  b7:
    lda #4
    clc
    adc i
    sta i
  b3:
    lda ypos2
    clc
    adc #2
    sta ypos2
    inc l
    lda l
    cmp #4
    bne b1
    rts
  b13:
    lda ypos2
    cmp #2*PLAYFIELD_LINES
    bcc b2
    jmp b7
  b2:
    lda render_screen_render_30
    clc
    adc ypos2
    tay
    lda screen_lines_1,y
    sta screen_line
    lda screen_lines_1+1,y
    sta screen_line+1
    lda current_xpos_47
    sta xpos
    lda #0
    sta c
  b4:
    ldy i
    lda (current_piece_gfx_53),y
    inc i
    cmp #0
    beq b5
    lda xpos
    cmp #PLAYFIELD_COLS
    bcs b5
    tay
    txa
    sta (screen_line),y
  b5:
    inc xpos
    inc c
    lda c
    cmp #4
    bne b4
    jmp b3
}
render_playfield: {
    .label screen_line = 5
    .label i = $a
    .label c = $b
    .label l = 9
    lda #PLAYFIELD_COLS*2
    sta i
    lda #2
    sta l
  b1:
    lda l
    asl
    stx $ff
    clc
    adc $ff
    tay
    lda screen_lines_1,y
    sta screen_line
    lda screen_lines_1+1,y
    sta screen_line+1
    lda #0
    sta c
  b2:
    ldy i
    lda playfield,y
    ldy #0
    sta (screen_line),y
    inc screen_line
    bne !+
    inc screen_line+1
  !:
    inc i
    inc c
    lda c
    cmp #PLAYFIELD_COLS-1+1
    bne b2
    inc l
    lda l
    cmp #PLAYFIELD_LINES-1+1
    bne b1
    rts
}
play_move_rotate: {
    .label orientation = 9
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
    adc current_orientation
    and #$3f
    sta orientation
  b4:
    lda current_xpos
    sta play_collision.xpos
    ldy current_ypos
    ldx orientation
    lda current_piece
    sta current_piece_79
    lda current_piece+1
    sta current_piece_79+1
    jsr play_collision
    cmp #COLLISION_NONE
    bne b3
    lda orientation
    sta current_orientation
    clc
    adc current_piece
    sta current_piece_gfx
    lda #0
    adc current_piece+1
    sta current_piece_gfx+1
    lda #1
    jmp breturn
  b1:
    lda current_orientation
    sec
    sbc #$10
    and #$3f
    sta orientation
    jmp b4
}
play_collision: {
    .label xpos = $a
    .label piece_gfx = 5
    .label ypos2 = $b
    .label playfield_line = 7
    .label i = $28
    .label col = $e
    .label l = $c
    .label i_2 = $d
    .label i_3 = $d
    .label i_11 = $d
    .label i_13 = $d
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
    sty play_collision.xpos
    ldy current_ypos
    ldx current_orientation
    lda current_piece
    sta current_piece_78
    lda current_piece+1
    sta current_piece_78+1
    jsr play_collision
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
    stx play_collision.xpos
    ldy current_ypos
    ldx current_orientation
    lda current_piece
    sta current_piece_77
    lda current_piece+1
    sta current_piece_77+1
    jsr play_collision
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
    cmp #current_movedown_fast
    bcc b2
    inx
  b2:
    lda current_movedown_counter
    cmp current_movedown_slow
    bcc b4
    inx
  b4:
    cpx #0
    beq b5
    ldy current_ypos
    iny
    lda current_xpos
    sta play_collision.xpos
    ldx current_orientation
    lda current_piece
    sta current_piece_76
    lda current_piece+1
    sta current_piece_76+1
    jsr play_collision
    cmp #COLLISION_NONE
    beq b6
    jsr play_lock_current
    jsr play_remove_lines
    lda play_remove_lines.removed
    tax
    jsr play_update_score
    jsr play_spawn_current
    ldy play_spawn_current._3
    lda PIECES,y
    sta current_piece
    lda PIECES+1,y
    sta current_piece+1
    lda #0
    sta current_orientation
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
play_spawn_current: {
    .label _3 = 4
    ldx #7
  b1:
    cpx #7
    beq b2
    txa
    asl
    sta _3
    tay
    lda PIECES,y
    sta current_piece_gfx
    lda PIECES+1,y
    sta current_piece_gfx+1
    lda PIECES_START_X,x
    sta current_xpos
    lda PIECES_START_Y,x
    sta current_ypos
    lda PIECES_CHARS,x
    sta current_piece_char
    rts
  b2:
    jsr sid_rnd
    and #7
    tax
    jmp b1
}
sid_rnd: {
    lda SID_VOICE3_OSC
    rts
}
play_update_score: {
    .label lines_before = 4
    .label add_bcd = $29
    cpx #0
    beq breturn
    lda lines_bcd
    and #$f0
    sta lines_before
    txa
    asl
    asl
    tay
    lda score_add_bcd,y
    sta add_bcd
    lda score_add_bcd+1,y
    sta add_bcd+1
    lda score_add_bcd+2,y
    sta add_bcd+2
    lda score_add_bcd+3,y
    sta add_bcd+3
    sed
    txa
    clc
    adc lines_bcd
    sta lines_bcd
    lda #0
    adc lines_bcd+1
    sta lines_bcd+1
    lda score_bcd
    clc
    adc add_bcd
    sta score_bcd
    lda score_bcd+1
    adc add_bcd+1
    sta score_bcd+1
    lda score_bcd+2
    adc add_bcd+2
    sta score_bcd+2
    lda score_bcd+3
    adc add_bcd+3
    sta score_bcd+3
    cld
    lda lines_bcd
    and #$f0
    cmp lines_before
    beq breturn
    jsr play_increase_level
  breturn:
    rts
}
play_increase_level: {
    inc level
    lda level
    cmp #$1d
    beq !+
    bcs b1
  !:
    ldy level
    lda MOVEDOWN_SLOW_SPEEDS,y
    sta current_movedown_slow
    jmp b2
  b1:
    lda #1
    sta current_movedown_slow
  b2:
    inc level_bcd
    lda #$f
    and level_bcd
    cmp #$a
    bne b3
    lda #6
    clc
    adc level_bcd
    sta level_bcd
  b3:
    sed
    ldx #0
  b4:
    txa
    asl
    asl
    tay
    clc
    lda score_add_bcd,y
    adc SCORE_BASE_BCD,y
    sta score_add_bcd,y
    lda score_add_bcd+1,y
    adc SCORE_BASE_BCD+1,y
    sta score_add_bcd+1,y
    lda score_add_bcd+2,y
    adc SCORE_BASE_BCD+2,y
    sta score_add_bcd+2,y
    lda score_add_bcd+3,y
    adc SCORE_BASE_BCD+3,y
    sta score_add_bcd+3,y
    inx
    cpx #5
    bne b4
    cld
    rts
}
play_remove_lines: {
    .label c = $c
    .label x = $a
    .label y = 4
    .label removed = 9
    .label full = $b
    lda #0
    sta removed
    sta y
    ldx #PLAYFIELD_LINES*PLAYFIELD_COLS-1
    ldy #PLAYFIELD_LINES*PLAYFIELD_COLS-1
  b1:
    lda #1
    sta full
    lda #0
    sta x
  b2:
    lda playfield,y
    sta c
    dey
    cmp #0
    bne b3
    lda #0
    sta full
  b3:
    lda c
    sta playfield,x
    dex
    inc x
    lda x
    cmp #PLAYFIELD_COLS-1+1
    bne b2
    lda full
    cmp #1
    bne b4
    txa
    clc
    adc #PLAYFIELD_COLS
    tax
    inc removed
  b4:
    inc y
    lda y
    cmp #PLAYFIELD_LINES-1+1
    bne b1
  b5:
    cpx #$ff
    bne b6
    rts
  b6:
    lda #0
    sta playfield,x
    dex
    jmp b5
}
play_lock_current: {
    .label ypos2 = $10
    .label playfield_line = 5
    .label col = $a
    .label i = $b
    .label l = 4
    .label i_2 = 9
    .label i_3 = 9
    .label i_7 = 9
    .label i_9 = 9
    asl ypos2
    lda #0
    sta l
    sta i_3
  b1:
    ldy ypos2
    lda playfield_lines,y
    sta playfield_line
    lda playfield_lines+1,y
    sta playfield_line+1
    lda current_xpos
    sta col
    ldx #0
  b2:
    ldy i_2
    iny
    sty i
    ldy i_2
    lda (current_piece_gfx),y
    cmp #0
    beq b3
    lda current_piece_char
    ldy col
    sta (playfield_line),y
  b3:
    inc col
    inx
    cpx #4
    bne b8
    lda ypos2
    clc
    adc #2
    sta ypos2
    inc l
    lda l
    cmp #4
    bne b7
    rts
  b7:
    lda i
    sta i_7
    jmp b1
  b8:
    lda i
    sta i_9
    jmp b2
}
keyboard_event_pressed: {
    .label row_bits = $a
    .label keycode = 9
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
    .label row_scan = $b
    .label keycode = $a
    .label row = 9
    lda #0
    sta keycode
    sta row
  b1:
    ldx row
    jsr keyboard_matrix_read
    sta row_scan
    ldy row
    cmp keyboard_scan_values,y
    bne b6
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
    beq b2
    ldx #0|KEY_MODIFIER_LSHIFT
    jmp b9
  b2:
    ldx #0
  b9:
    lda #KEY_RSHIFT
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b10
    txa
    ora #KEY_MODIFIER_RSHIFT
    tax
  b10:
    lda #KEY_CTRL
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b11
    txa
    ora #KEY_MODIFIER_CTRL
    tax
  b11:
    lda #KEY_COMMODORE
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq breturn
    txa
    ora #KEY_MODIFIER_COMMODORE
  breturn:
    rts
  b6:
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
render_show: {
    .const toD0181_return = (>(PLAYFIELD_SCREEN_1&$3fff)<<2)|(>PLAYFIELD_CHARSET)>>2&$f
    .const toD0182_return = (>(PLAYFIELD_SCREEN_2&$3fff)<<2)|(>PLAYFIELD_CHARSET)>>2&$f
    lda render_screen_show
    cmp #0
    beq toD0181
    lda #toD0182_return
  b2:
    sta D018
    lda render_screen_show
    sta render_screen_showing
    rts
  toD0181:
    lda #toD0181_return
    jmp b2
}
play_init: {
    .label pli = 5
    .label idx = 2
    lda #0
    sta idx
    lda #<playfield
    sta pli
    lda #>playfield
    sta pli+1
    ldx #0
  b1:
    txa
    asl
    tay
    lda pli
    sta playfield_lines,y
    lda pli+1
    sta playfield_lines+1,y
    lda idx
    sta playfield_lines_idx,x
    lda pli
    clc
    adc #PLAYFIELD_COLS
    sta pli
    bcc !+
    inc pli+1
  !:
    lda #PLAYFIELD_COLS
    clc
    adc idx
    sta idx
    inx
    cpx #PLAYFIELD_LINES-1+1
    bne b1
    lda #PLAYFIELD_COLS*PLAYFIELD_LINES
    sta playfield_lines_idx+PLAYFIELD_LINES
    lda MOVEDOWN_SLOW_SPEEDS
    sta current_movedown_slow
    ldx #0
  b2:
    txa
    asl
    asl
    tay
    lda SCORE_BASE_BCD,y
    sta score_add_bcd,y
    lda SCORE_BASE_BCD+1,y
    sta score_add_bcd+1,y
    lda SCORE_BASE_BCD+2,y
    sta score_add_bcd+2,y
    lda SCORE_BASE_BCD+3,y
    sta score_add_bcd+3,y
    inx
    cpx #5
    bne b2
    rts
}
sprites_irq_init: {
    sei
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda CIA1_INTERRUPT
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    lda VIC_CONTROL
    and #$7f
    sta VIC_CONTROL
    lda #IRQ_RASTER_FIRST
    sta RASTER
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    lda #<sprites_irq
    sta HARDWARE_IRQ
    lda #>sprites_irq
    sta HARDWARE_IRQ+1
    cli
    rts
}
sprites_init: {
    .label xpos = 2
    lda #$f
    sta SPRITES_ENABLE
    lda #0
    sta SPRITES_MC
    sta SPRITES_EXPAND_Y
    sta SPRITES_EXPAND_X
    lda #$18+$f*8
    sta xpos
    ldx #0
  b1:
    txa
    asl
    tay
    lda xpos
    sta SPRITES_XPOS,y
    lda #BLACK
    sta SPRITES_COLS,x
    lda #$18
    clc
    adc xpos
    sta xpos
    inx
    cpx #4
    bne b1
    rts
}
render_init: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>PLAYFIELD_CHARSET)>>6
    .label li_1 = 5
    .label li_2 = 7
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #BLACK
    sta BORDERCOL
    sta BGCOL1
    lda #BLUE
    sta BGCOL2
    lda #CYAN
    sta BGCOL3
    lda #GREY
    sta BGCOL4
    lda #<PLAYFIELD_SCREEN_1
    sta render_screen_original.screen
    lda #>PLAYFIELD_SCREEN_1
    sta render_screen_original.screen+1
    jsr render_screen_original
    lda #<PLAYFIELD_SCREEN_2
    sta render_screen_original.screen
    lda #>PLAYFIELD_SCREEN_2
    sta render_screen_original.screen+1
    jsr render_screen_original
    lda #<PLAYFIELD_SCREEN_2+2*$28+$10
    sta li_2
    lda #>PLAYFIELD_SCREEN_2+2*$28+$10
    sta li_2+1
    lda #<PLAYFIELD_SCREEN_1+2*$28+$10
    sta li_1
    lda #>PLAYFIELD_SCREEN_1+2*$28+$10
    sta li_1+1
    ldx #0
  b1:
    txa
    asl
    tay
    lda li_1
    sta screen_lines_1,y
    lda li_1+1
    sta screen_lines_1+1,y
    txa
    asl
    tay
    lda li_2
    sta screen_lines_2,y
    lda li_2+1
    sta screen_lines_2+1,y
    lda li_1
    clc
    adc #$28
    sta li_1
    bcc !+
    inc li_1+1
  !:
    lda li_2
    clc
    adc #$28
    sta li_2
    bcc !+
    inc li_2+1
  !:
    inx
    cpx #PLAYFIELD_LINES-1+1
    bne b1
    rts
}
render_screen_original: {
    .const SPACE = 0
    .label screen = $11
    .label cols = $1a
    .label oscr = 5
    .label ocols = 7
    .label y = 2
    lda #0
    sta y
    lda #<PLAYFIELD_COLORS_ORIGINAL+$20*2
    sta ocols
    lda #>PLAYFIELD_COLORS_ORIGINAL+$20*2
    sta ocols+1
    lda #<PLAYFIELD_SCREEN_ORIGINAL+$20*2
    sta oscr
    lda #>PLAYFIELD_SCREEN_ORIGINAL+$20*2
    sta oscr+1
    lda #<COLS
    sta cols
    lda #>COLS
    sta cols+1
  b1:
    ldx #0
  b2:
    lda #SPACE
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    lda #BLACK
    ldy #0
    sta (cols),y
    inc cols
    bne !+
    inc cols+1
  !:
    inx
    cpx #4
    bne b2
  b3:
    ldy #0
    lda (oscr),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc oscr
    bne !+
    inc oscr+1
  !:
    ldy #0
    lda (ocols),y
    sta (cols),y
    inc cols
    bne !+
    inc cols+1
  !:
    inc ocols
    bne !+
    inc ocols+1
  !:
    inx
    cpx #$24
    bne b3
  b4:
    lda #SPACE
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    lda #BLACK
    ldy #0
    sta (cols),y
    inc cols
    bne !+
    inc cols+1
  !:
    inx
    cpx #$28
    bne b4
    inc y
    lda y
    cmp #$19
    bne b1
    rts
}
sid_rnd_init: {
    lda #<$ffff
    sta SID_VOICE3_FREQ
    lda #>$ffff
    sta SID_VOICE3_FREQ+1
    lda #SID_CONTROL_NOISE
    sta SID_VOICE3_CONTROL
    rts
}
sprites_irq: {
    .const toSpritePtr2_return = PLAYFIELD_SPRITES>>6
    sta rega+1
    stx regx+1
    cld
    lda irq_sprite_ypos
    sta SPRITES_YPOS
    sta SPRITES_YPOS+2
    sta SPRITES_YPOS+4
    sta SPRITES_YPOS+6
  b1:
    lda RASTER
    cmp irq_sprite_ypos
    bcc b1
    ldx irq_sprite_ptr
    lda render_screen_showing
    cmp #0
    beq b2
    stx PLAYFIELD_SPRITE_PTRS_2
    inx
    stx PLAYFIELD_SPRITE_PTRS_2+1
    stx PLAYFIELD_SPRITE_PTRS_2+2
    inx
    stx PLAYFIELD_SPRITE_PTRS_2+3
  b3:
    inc irq_cnt
    lda irq_cnt
    cmp #$a
    beq b4
    lda #$15
    clc
    adc irq_raster_next
    sta irq_raster_next
    lda #$15
    clc
    adc irq_sprite_ypos
    sta irq_sprite_ypos
    lda #3
    clc
    adc irq_sprite_ptr
    sta irq_sprite_ptr
  b5:
    ldx irq_raster_next
    txa
    and #7
    cmp #3
    bne b6
    dex
  b6:
    stx RASTER
    lda #IRQ_RASTER
    sta IRQ_STATUS
  rega:
    lda #00
  regx:
    ldx #00
    rti
  b4:
    lda #0
    sta irq_cnt
    lda #IRQ_RASTER_FIRST
    sta irq_raster_next
    lda #$32
    sta irq_sprite_ypos
    lda #toSpritePtr2_return
    sta irq_sprite_ptr
    jmp b5
  b2:
    stx PLAYFIELD_SPRITE_PTRS_1
    txa
    clc
    adc #1
    sta PLAYFIELD_SPRITE_PTRS_1+1
    sta PLAYFIELD_SPRITE_PTRS_1+2
    clc
    adc #1
    sta PLAYFIELD_SPRITE_PTRS_1+3
    jmp b3
}
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  keyboard_events: .fill 8, 0
  keyboard_scan_values: .fill 8, 0
  .align $40
  PIECE_T: .byte 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0
  .align $40
  PIECE_S: .byte 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0
  .align $40
  PIECE_Z: .byte 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0
  .align $40
  PIECE_L: .byte 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0
  .align $40
  PIECE_J: .byte 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
  .align $40
  PIECE_O: .byte 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0
  .align $40
  PIECE_I: .byte 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0
  PIECES_CHARS: .byte $64, $65, $a5, $65, $64, $64, $a5
  PIECES_START_X: .byte 4, 4, 4, 4, 4, 4, 4
  PIECES_START_Y: .byte 1, 1, 1, 1, 1, 0, 1
  SCORE_BASE_BCD: .dword 0, $40, $100, $300, $1200
  score_add_bcd: .fill 4*5, 0
  MOVEDOWN_SLOW_SPEEDS: .byte $30, $2b, $26, $21, $1c, $17, $12, $d, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1
  .align $80
  screen_lines_1: .fill 2*PLAYFIELD_LINES, 0
  .align $40
  screen_lines_2: .fill 2*PLAYFIELD_LINES, 0
  playfield_lines: .fill 2*PLAYFIELD_LINES, 0
  playfield: .fill PLAYFIELD_LINES*PLAYFIELD_COLS, 0
  PIECES: .word PIECE_T, PIECE_S, PIECE_Z, PIECE_J, PIECE_O, PIECE_I, PIECE_L
  playfield_lines_idx: .fill PLAYFIELD_LINES+1, 0
.pc = PLAYFIELD_CHARSET "PLAYFIELD_CHARSET"
  .fill 8,$00 // Place a filled char at the start of the charset
    .import binary "playfield-screen.imap"

.pc = PLAYFIELD_SCREEN_ORIGINAL "PLAYFIELD_SCREEN_ORIGINAL"
  // Load chars for the screen
  .var screen = LoadBinary("playfield-screen.iscr")
   // Load extended colors for the screen
  .var extended = LoadBinary("playfield-extended.col")
  // screen.get(i)+1 because the charset is loaded into PLAYFIELD_CHARSET+8
  // extended.get(i)-1 because the extended colors are 1-based (1/2/3/4)
  // <<6 to move extended colors to the upper 2 bits
  .fill screen.getSize(), ( (screen.get(i)+1) | (extended.get(i)-1)<<6 )

.pc = PLAYFIELD_COLORS_ORIGINAL "PLAYFIELD_COLORS_ORIGINAL"
  .import binary "playfield-screen.col"

.pc = PLAYFIELD_SPRITES "PLAYFIELD_SPRITES"
  .var sprites = LoadPicture("playfield-sprites.png", List().add($010101, $000000))
	.for(var sy=0;sy<10;sy++) {
		.for(var sx=0;sx<3;sx++) {
	    	.for (var y=0;y<21; y++) {
		    	.for (var c=0; c<3; c++) {
	            	.byte sprites.getSinglecolorByte(sx*3+c,sy*21+y)
	            }
	        }
	    	.byte 0
	  	}
	}

