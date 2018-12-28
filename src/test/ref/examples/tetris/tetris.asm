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
  .const WHITE = 1
  .const CYAN = 3
  .const BLUE = 6
  .const DARK_GREY = $b
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
  .label PLAYFIELD_SCREEN = $400
  .label PLAYFIELD_SPRITES = $2000
  .label PLAYFIELD_CHARSET = $2800
  .const PLAYFIELD_LINES = $16
  .const PLAYFIELD_COLS = $a
  .label PLAYFIELD_SCREEN_ORIGINAL = $2c00
  .const IRQ_RASTER_FIRST = $31
  .const current_movedown_slow = $32
  .const current_movedown_fast = 5
  .const COLLISION_NONE = 0
  .const COLLISION_PLAYFIELD = 1
  .const COLLISION_BOTTOM = 2
  .const COLLISION_LEFT = 4
  .const COLLISION_RIGHT = 8
  .label PLAYFIELD_SPRITE_PTRS = PLAYFIELD_SCREEN+SPRITE_PTRS
  .const toSpritePtr1_return = PLAYFIELD_SPRITES>>6
  .label keyboard_events_size = $13
  .label irq_raster_next = $14
  .label irq_sprite_ypos = $15
  .label irq_sprite_ptr = $16
  .label irq_cnt = $17
  .label current_movedown_counter = 2
  .label current_ypos = $b
  .label current_xpos = $11
  .label current_orientation = $e
  .label current_piece_gfx = $f
  .label current_piece = $c
  .label current_piece_char = $12
  .label current_piece_12 = 4
  .label current_xpos_48 = 3
  .label current_piece_gfx_53 = 4
  .label current_piece_char_63 = 6
  .label current_xpos_105 = 3
  .label current_xpos_106 = 3
  .label current_piece_gfx_95 = 4
  .label current_piece_gfx_96 = 4
  .label current_piece_char_83 = 6
  .label current_piece_char_84 = 6
  .label current_piece_73 = 4
  .label current_piece_74 = 4
  .label current_piece_75 = 4
  .label current_piece_76 = 4
bbegin:
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
    .label key_event = $18
    .label render = $19
    jsr sid_rnd_init
    sei
    jsr render_init
    jsr sprites_init
    jsr sprites_irq_init
    jsr play_init
    jsr play_spawn_current
    jsr render_playfield
    ldx current_ypos
    lda current_xpos
    sta current_xpos_105
    lda current_piece_gfx
    sta current_piece_gfx_95
    lda current_piece_gfx+1
    sta current_piece_gfx_95+1
    lda current_piece_char
    sta current_piece_char_83
    jsr render_current
    ldy play_spawn_current._3
    lda PIECES,y
    sta current_piece
    lda PIECES+1,y
    sta current_piece+1
    lda #0
    sta current_movedown_counter
    sta keyboard_events_size
    sta current_orientation
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
    jsr render_playfield
    ldx current_ypos
    lda current_xpos
    sta current_xpos_106
    lda current_piece_gfx
    sta current_piece_gfx_96
    lda current_piece_gfx+1
    sta current_piece_gfx_96+1
    lda current_piece_char
    sta current_piece_char_84
    jsr render_current
  b10:
    dec BORDERCOL
    jmp b4
}
render_current: {
    .label ypos2 = 7
    .label screen_line = $1a
    .label xpos = $a
    .label i = 9
    .label l = 8
    txa
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
    ldy ypos2
    lda screen_lines,y
    sta screen_line
    lda screen_lines+1,y
    sta screen_line+1
    lda current_xpos_48
    sta xpos
    ldx #0
  b4:
    ldy i
    lda (current_piece_gfx_53),y
    inc i
    cmp #0
    beq b5
    lda xpos
    cmp #PLAYFIELD_COLS
    bcs b5
    lda current_piece_char_63
    ldy xpos
    sta (screen_line),y
  b5:
    inc xpos
    inx
    cpx #4
    bne b4
    jmp b3
}
render_playfield: {
    .label screen_line = 4
    .label i = 6
    .label l = 3
    lda #PLAYFIELD_COLS*2
    sta i
    lda #2
    sta l
  b1:
    lda l
    asl
    tay
    lda screen_lines,y
    sta screen_line
    lda screen_lines+1,y
    sta screen_line+1
    ldx #0
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
    .label orientation = 3
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
    sta current_piece_76
    lda current_piece+1
    sta current_piece_76+1
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
    .label xpos = 6
    .label piece_gfx = 4
    .label ypos2 = 7
    .label playfield_line = $1a
    .label i = $1c
    .label col = $a
    .label l = 8
    .label i_2 = 9
    .label i_3 = 9
    .label i_11 = 9
    .label i_13 = 9
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
    sta current_piece_75
    lda current_piece+1
    sta current_piece_75+1
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
    sta current_piece_74
    lda current_piece+1
    sta current_piece_74+1
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
    cmp #current_movedown_slow
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
    sta current_piece_73
    lda current_piece+1
    sta current_piece_73+1
    jsr play_collision
    cmp #COLLISION_NONE
    beq b6
    jsr play_lock_current
    jsr play_remove_lines
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
    .label _3 = 2
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
play_remove_lines: {
    .label c = 7
    .label x = 3
    .label y = 2
    .label full = 6
    lda #0
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
    .label ypos2 = $b
    .label playfield_line = 4
    .label col = 6
    .label i = 7
    .label l = 2
    .label i_2 = 3
    .label i_3 = 3
    .label i_7 = 3
    .label i_9 = 3
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
    .label row_bits = 6
    .label keycode = 3
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
    .label row_scan = 7
    .label keycode = 6
    .label row = 3
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
play_init: {
    .label pli = 4
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
    lda #<irq
    sta HARDWARE_IRQ
    lda #>irq
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
    .const vicSelectGfxBank1_toDd001_return = 3^(>PLAYFIELD_SCREEN)>>6
    .const toD0181_return = (>(PLAYFIELD_SCREEN&$3fff)<<2)|(>PLAYFIELD_CHARSET)>>2&$f
    .label _18 = $c
    .label li = 4
    .label line = 4
    .label l = 2
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #BLACK
    sta BGCOL1
    lda #BLUE
    sta BGCOL2
    lda #CYAN
    sta BGCOL3
    lda #GREY
    sta BGCOL4
    jsr fill
    jsr render_screen_original
    lda #<PLAYFIELD_SCREEN+2*$28+$10
    sta li
    lda #>PLAYFIELD_SCREEN+2*$28+$10
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
    cpx #PLAYFIELD_LINES-1+1
    bne b1
    lda #2
    sta l
    lda #<COLS+4*$28+$10
    sta line
    lda #>COLS+4*$28+$10
    sta line+1
  b2:
    ldx #0
  b3:
    txa
    clc
    adc line
    sta _18
    lda #0
    adc line+1
    sta _18+1
    lda #WHITE
    ldy #0
    sta (_18),y
    inx
    cpx #PLAYFIELD_COLS-1+1
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
    cmp #PLAYFIELD_LINES-1+1
    bne b2
    rts
}
render_screen_original: {
    .const SPACE = 0
    .label screen = $c
    .label orig = 4
    .label y = 2
    lda #0
    sta y
    lda #<PLAYFIELD_SCREEN_ORIGINAL+$20*2
    sta orig
    lda #>PLAYFIELD_SCREEN_ORIGINAL+$20*2
    sta orig+1
    lda #<PLAYFIELD_SCREEN
    sta screen
    lda #>PLAYFIELD_SCREEN
    sta screen+1
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
    inx
    cpx #4
    bne b2
  b3:
    ldy #0
    lda (orig),y
    clc
    adc #1
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc orig
    bne !+
    inc orig+1
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
    inx
    cpx #$28
    bne b4
    inc y
    lda y
    cmp #$19
    bne b1
    rts
}
fill: {
    .const size = $3e8
    .label end = COLS+size
    .label addr = 4
    lda #<COLS
    sta addr
    lda #>COLS
    sta addr+1
  b1:
    lda #DARK_GREY
    ldy #0
    sta (addr),y
    inc addr
    bne !+
    inc addr+1
  !:
    lda addr+1
    cmp #>end
    bne b1
    lda addr
    cmp #<end
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
irq: {
    .const toSpritePtr2_return = PLAYFIELD_SPRITES>>6
    sta rega+1
    stx regx+1
    lda #DARK_GREY
    sta BORDERCOL
    lda irq_sprite_ypos
    sta SPRITES_YPOS
    sta SPRITES_YPOS+2
    sta SPRITES_YPOS+4
    sta SPRITES_YPOS+6
  b1:
    lda RASTER
    cmp irq_sprite_ypos
    bne b1
    lda irq_sprite_ptr
    sta PLAYFIELD_SPRITE_PTRS
    tax
    inx
    stx PLAYFIELD_SPRITE_PTRS+1
    stx PLAYFIELD_SPRITE_PTRS+2
    inx
    stx PLAYFIELD_SPRITE_PTRS+3
    inc irq_cnt
    lda irq_cnt
    cmp #$a
    beq b2
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
  b3:
    ldx irq_raster_next
    txa
    and #7
    cmp #3
    bne b4
    dex
  b4:
    stx RASTER
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda #BLACK
    sta BORDERCOL
  rega:
    lda #00
  regx:
    ldx #00
    rti
  b2:
    lda #0
    sta irq_cnt
    lda #IRQ_RASTER_FIRST
    sta irq_raster_next
    lda #$32
    sta irq_sprite_ypos
    lda #toSpritePtr2_return
    sta irq_sprite_ptr
    jmp b3
}
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  keyboard_events: .fill 8, 0
  keyboard_scan_values: .fill 8, 0
  .align $40
  PIECE_T: .byte 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
  .align $40
  PIECE_S: .byte 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
  .align $40
  PIECE_Z: .byte 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
  .align $40
  PIECE_L: .byte 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0
  .align $40
  PIECE_J: .byte 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
  .align $40
  PIECE_O: .byte 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  .align $40
  PIECE_I: .byte 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0
  PIECES_CHARS: .byte $57, $58, $98, $58, $57, $57, $98
  PIECES_START_X: .byte 4, 4, 4, 4, 4, 3, 4
  PIECES_START_Y: .byte 2, 1, 1, 1, 2, 0, 1
  screen_lines: .fill 2*PLAYFIELD_LINES, 0
  playfield_lines: .fill 2*PLAYFIELD_LINES, 0
  playfield: .fill PLAYFIELD_LINES*PLAYFIELD_COLS, 0
  PIECES: .word PIECE_T, PIECE_S, PIECE_Z, PIECE_J, PIECE_O, PIECE_I, PIECE_L
  playfield_lines_idx: .fill PLAYFIELD_LINES+1, 0
.pc = PLAYFIELD_CHARSET "Inline"
  .fill 8,$00 // Place a filled char at the start of the charset
    .import binary "nes-screen.imap"

.pc = PLAYFIELD_SCREEN_ORIGINAL "Inline"
  .import binary "nes-screen.iscr"

.pc = PLAYFIELD_SPRITES "Inline"
  .var sprites = LoadPicture("nes-playfield.png", List().add($010101, $000000))
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

