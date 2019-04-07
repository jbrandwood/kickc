// Tetris Game for the Commodore 64
// The tetris game tries to match NES tetris gameplay pretty closely
// Source: https://meatfighter.com/nintendotetrisai/
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = $35
  // The offset of the sprite pointers from the screen start address
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
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // Color Ram
  .label COLS = $d800
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CIA1_PORT_B = $dc01
  // CIA#1 Interrupt Status & Control Register
  .label CIA1_INTERRUPT = $dc0d
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  // The colors of the C64
  .const BLACK = 0
  .const RED = 2
  .const CYAN = 3
  .const PURPLE = 4
  .const GREEN = 5
  .const BLUE = 6
  .const ORANGE = 8
  .const PINK = $a
  .const DARK_GREY = $b
  .const GREY = $c
  .const LIGHT_GREEN = $d
  .const LIGHT_BLUE = $e
  .const KEY_Z = $c
  .const KEY_LSHIFT = $f
  .const KEY_X = $17
  .const KEY_DOT = $2c
  .const KEY_COMMA = $2f
  .const KEY_RSHIFT = $34
  .const KEY_CTRL = $3a
  .const KEY_SPACE = $3c
  .const KEY_COMMODORE = $3d
  // Left shift is pressed
  .const KEY_MODIFIER_LSHIFT = 1
  // Right shift is pressed
  .const KEY_MODIFIER_RSHIFT = 2
  // CTRL is pressed
  .const KEY_MODIFIER_CTRL = 4
  // Commodore is pressed
  .const KEY_MODIFIER_COMMODORE = 8
  // SID registers for random number generation
  .label SID_VOICE3_FREQ = $d40e
  .label SID_VOICE3_CONTROL = $d412
  .const SID_CONTROL_NOISE = $80
  .label SID_VOICE3_OSC = $d41b
  // Address of the first screen
  .label PLAYFIELD_SCREEN_1 = $400
  // Address of the second screen
  .label PLAYFIELD_SCREEN_2 = $2c00
  // Address of the original playscreen chars
  .label PLAYFIELD_SCREEN_ORIGINAL = $1800
  // Address of the original playscreen colors
  .label PLAYFIELD_COLORS_ORIGINAL = $1c00
  // Address of the sprites covering the playfield
  .label PLAYFIELD_SPRITES = $2000
  // Address of the charset
  .label PLAYFIELD_CHARSET = $2800
  // The size of the playfield
  .const PLAYFIELD_LINES = $16
  .const PLAYFIELD_COLS = $a
  // The Y-position of the first sprite row
  .const SPRITES_FIRST_YPOS = $31
  // The rate of moving down the current piece fast (number of frames between moves if movedown is not forced)
  .const current_movedown_fast = $a
  // No collision
  .const COLLISION_NONE = 0
  // Playfield piece collision (cell on top of other cell on the playfield)
  .const COLLISION_PLAYFIELD = 1
  // Bottom collision (cell below bottom of the playfield)
  .const COLLISION_BOTTOM = 2
  // Left side collision (cell beyond the left side of the playfield)
  .const COLLISION_LEFT = 4
  // Right side collision (cell beyond the right side of the playfield)
  .const COLLISION_RIGHT = 8
  // Screen Sprite pointers on screen 1
  .label PLAYFIELD_SPRITE_PTRS_1 = PLAYFIELD_SCREEN_1+SPRITE_PTRS
  // Screen Sprite pointers on screen 2
  .label PLAYFIELD_SPRITE_PTRS_2 = PLAYFIELD_SCREEN_2+SPRITE_PTRS
  // The line of the first IRQ
  .const IRQ_RASTER_FIRST = SPRITES_FIRST_YPOS+$13
  .const toSpritePtr1_return = PLAYFIELD_SPRITES>>6
  .label keyboard_events_size = $23
  .label render_screen_showing = $25
  .label irq_raster_next = $26
  .label irq_sprite_ypos = $27
  .label irq_sprite_ptr = $28
  .label irq_cnt = $29
  .label current_movedown_slow = $18
  .label current_ypos = $10
  .label current_xpos = $20
  .label current_orientation = $1d
  .label current_piece_gfx = $1e
  .label current_piece_char = $1c
  .label level_bcd = $19
  .label current_piece = $1a
  .label game_over = $22
  .label next_piece_idx = $21
  .label level = $17
  .label render_screen_render = 3
  .label render_screen_show = 2
  .label current_movedown_counter = 4
  .label lines_bcd = $11
  .label score_bcd = $13
  .label current_piece_17 = 5
  .label render_screen_render_33 = 9
  .label current_xpos_59 = $a
  .label current_piece_gfx_64 = 5
  .label current_piece_char_68 = $b
  .label render_screen_render_69 = 9
  .label current_xpos_128 = $a
  .label current_xpos_129 = $a
  .label current_piece_gfx_118 = 5
  .label current_piece_gfx_119 = 5
  .label current_piece_char_106 = $b
  .label current_piece_char_107 = $b
  .label current_piece_98 = 5
  .label current_piece_99 = 5
  .label current_piece_100 = 5
  .label current_piece_101 = 5
  .label current_piece_102 = 5
bbegin:
  // The screen currently being showed to the user. $00 for screen 1 / $40 for screen 2.
  lda #0
  sta render_screen_showing
// Original Color Data
  // The raster line of the next IRQ
  lda #IRQ_RASTER_FIRST
  sta irq_raster_next
  // Y-pos of the sprites on the next IRQ
  lda #SPRITES_FIRST_YPOS+$15
  sta irq_sprite_ypos
  // Index of the sprites to show on the next IRQ
  lda #toSpritePtr1_return+3
  sta irq_sprite_ptr
  // Counting the 10 IRQs
  lda #0
  sta irq_cnt
  jsr main
  rts
main: {
    jsr sid_rnd_init
    sei
    jsr render_init
    jsr sprites_init
    jsr sprites_irq_init
    jsr play_init
    lda #0
    sta game_over
    sta next_piece_idx
    jsr play_spawn_current
    jsr play_spawn_current
    ldx #$40
    jsr render_playfield
    ldx current_ypos
    lda current_xpos
    sta current_xpos_128
    lda current_piece_gfx
    sta current_piece_gfx_118
    lda current_piece_gfx+1
    sta current_piece_gfx_118+1
    lda current_piece_char
    sta current_piece_char_106
    lda #$40
    sta render_screen_render_33
    jsr render_moving
    ldx play_spawn_current.piece_idx
    lda #$40
    jsr render_next
    ldy play_spawn_current._0
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
  b1:
  // Wait for a frame to pass
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    jsr render_show
    jsr keyboard_event_scan
    jsr keyboard_event_get
    lda game_over
    cmp #0
    beq b4
  b5:
    inc BORDERCOL
    jmp b5
  b4:
    stx play_movement.key_event
    jsr play_movement
    lda play_movement.return
    cmp #0
    beq b1
    ldx render_screen_render
    jsr render_playfield
    ldx current_ypos
    lda render_screen_render
    sta render_screen_render_69
    lda current_xpos
    sta current_xpos_129
    lda current_piece_gfx
    sta current_piece_gfx_119
    lda current_piece_gfx+1
    sta current_piece_gfx_119+1
    lda current_piece_char
    sta current_piece_char_107
    jsr render_moving
    lda render_screen_render
    ldx next_piece_idx
    jsr render_next
    jsr render_score
    jsr render_screen_swap
    jmp b1
}
// Swap rendering to the other screen (used for double buffering)
render_screen_swap: {
    lda render_screen_render
    eor #$40
    sta render_screen_render
    lda render_screen_show
    eor #$40
    sta render_screen_show
    rts
}
// Show the current score
render_score: {
    .label score_bytes = score_bcd
    .const score_offset = $28*5+$1c
    .const lines_offset = $28*1+$16
    .const level_offset = $28*$13+$1f
    .label screen = 5
    lda render_screen_render
    cmp #0
    beq b2
    lda #<PLAYFIELD_SCREEN_2
    sta screen
    lda #>PLAYFIELD_SCREEN_2
    sta screen+1
    jmp b1
  b2:
    lda #<PLAYFIELD_SCREEN_1
    sta screen
    lda #>PLAYFIELD_SCREEN_1
    sta screen+1
  b1:
    ldx score_bytes+2
    ldy #0
    lda #<score_offset
    sta render_bcd.offset
    lda #>score_offset
    sta render_bcd.offset+1
    jsr render_bcd
    ldx score_bytes+1
    ldy #0
    lda #score_offset+2
    sta render_bcd.offset
    tya
    sta render_bcd.offset+1
    jsr render_bcd
    ldx score_bytes
    ldy #0
    lda #score_offset+4
    sta render_bcd.offset
    tya
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
    lda #lines_offset+1
    sta render_bcd.offset
    tya
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
// Render BCD digits on a screen.
// - screen: pointer to the screen to render on
// - offset: offset on the screen
// - bcd: The BCD-value to render
// - only_low: if non-zero only renders the low digit
// render_bcd(byte* zeropage(5) screen, word zeropage(7) offset, byte register(X) bcd, byte register(Y) only_low)
render_bcd: {
    .const ZERO_CHAR = $35
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
// Render the next tetromino in the "next" area
render_next: {
    .const next_area_offset = $28*$c+$18+4
    .label next_piece_char = $a
    .label next_piece_gfx = 5
    .label screen_next_area = 7
    .label l = 9
    cmp #0
    beq b2
    lda #<PLAYFIELD_SCREEN_2+next_area_offset
    sta screen_next_area
    lda #>PLAYFIELD_SCREEN_2+next_area_offset
    sta screen_next_area+1
    jmp b1
  b2:
    lda #<PLAYFIELD_SCREEN_1+next_area_offset
    sta screen_next_area
    lda #>PLAYFIELD_SCREEN_1+next_area_offset
    sta screen_next_area+1
  b1:
    txa
    asl
    tay
    lda PIECES_NEXT_CHARS,x
    sta next_piece_char
    lda PIECES,y
    sta next_piece_gfx
    lda PIECES+1,y
    sta next_piece_gfx+1
    lda #0
    sta l
  b3:
    ldx #0
  b4:
    ldy #0
    lda (next_piece_gfx),y
    inc next_piece_gfx
    bne !+
    inc next_piece_gfx+1
  !:
    cmp #0
    bne b5
    lda #0
    tay
    sta (screen_next_area),y
  b6:
    inc screen_next_area
    bne !+
    inc screen_next_area+1
  !:
    inx
    cpx #4
    bne b4
    lda #$24
    clc
    adc screen_next_area
    sta screen_next_area
    bcc !+
    inc screen_next_area+1
  !:
    inc l
    lda #4
    cmp l
    bne b3
    rts
  b5:
    lda next_piece_char
    ldy #0
    sta (screen_next_area),y
    jmp b6
}
// Render the current moving piece at position (current_xpos, current_ypos)
// Ignores cases where parts of the tetromino is outside the playfield (sides/bottom) since the movement collision routine prevents this.
render_moving: {
    .label ypos2 = $c
    .label screen_line = 7
    .label xpos = $f
    .label i = $e
    .label l = $d
    txa
    asl
    sta ypos2
    lda #0
    sta l
    sta i
  b1:
    lda #2
    cmp ypos2
    bcc b2
    lax i
    axs #-[4]
    stx i
  b3:
    lda ypos2
    clc
    adc #2
    sta ypos2
    inc l
    lda #4
    cmp l
    bne b1
    rts
  b2:
    lda render_screen_render_33
    clc
    adc ypos2
    tay
    lda screen_lines_1,y
    sta screen_line
    lda screen_lines_1+1,y
    sta screen_line+1
    lda current_xpos_59
    sta xpos
    ldx #0
  b4:
    ldy i
    lda (current_piece_gfx_64),y
    inc i
    cmp #0
    beq b5
    lda current_piece_char_68
    ldy xpos
    sta (screen_line),y
  b5:
    inc xpos
    inx
    cpx #4
    bne b4
    jmp b3
}
// Render the static playfield on the screen (all pieces already locked into place)
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
    lda #PLAYFIELD_COLS-1+1
    cmp c
    bne b2
    inc l
    lda #PLAYFIELD_LINES-1+1
    cmp l
    bne b1
    rts
}
// Perform any movement of the current piece
// key_event is the next keyboard_event() og $ff if no keyboard event is pending
// Returns a byte signaling whether rendering is needed. (0 no render, >0 render needed)
// play_movement(byte zeropage($2a) key_event)
play_movement: {
    .label render = 9
    .label return = 9
    .label key_event = $2a
    lda key_event
    jsr play_move_down
    txa
    clc
    adc #0
    sta render
    lda game_over
    cmp #0
    beq b1
  breturn:
    rts
  b1:
    lda key_event
    jsr play_move_leftright
    clc
    adc render
    sta render
    lda key_event
    jsr play_move_rotate
    clc
    adc return
    sta return
    jmp breturn
}
// Rotate the current piece  based on key-presses
// Return non-zero if a render is needed
// play_move_rotate(byte register(A) key_event)
play_move_rotate: {
    .label orientation = $a
    cmp #KEY_Z
    beq b1
    cmp #KEY_X
    beq b2
  b4:
    lda #0
  breturn:
    rts
  b2:
    lax current_orientation
    axs #-[$10]
    lda #$3f
    sax orientation
  b3:
    lda current_xpos
    sta play_collision.xpos
    lda current_ypos
    sta play_collision.ypos
    ldx orientation
    lda current_piece
    sta current_piece_101
    lda current_piece+1
    sta current_piece_101+1
    jsr play_collision
    cmp #COLLISION_NONE
    bne b4
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
    lax current_orientation
    axs #$10
    lda #$3f
    sax orientation
    jmp b3
}
// Test if there is a collision between the current piece moved to (x, y) and anything on the playfield or the playfield boundaries
// Returns information about the type of the collision detected
// play_collision(byte zeropage($c) xpos, byte zeropage($b) ypos, byte register(X) orientation)
play_collision: {
    .label xpos = $c
    .label ypos = $b
    .label piece_gfx = 5
    .label ypos2 = $b
    .label playfield_line = 7
    .label i = $2b
    .label col = $f
    .label l = $d
    .label i_2 = $e
    .label i_3 = $e
    .label i_11 = $e
    .label i_13 = $e
    txa
    clc
    adc piece_gfx
    sta piece_gfx
    bcc !+
    inc piece_gfx+1
  !:
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
    bne b10
    lda ypos2
    clc
    adc #2
    sta ypos2
    inc l
    lda #4
    cmp l
    bne b9
    lda #COLLISION_NONE
    jmp breturn
  b9:
    lda i
    sta i_11
    jmp b1
  b10:
    lda i
    sta i_13
    jmp b2
}
// Move left/right or rotate the current piece
// Return non-zero if a render is needed
// play_move_leftright(byte register(A) key_event)
play_move_leftright: {
    // Handle keyboard events
    cmp #KEY_COMMA
    beq b1
    cmp #KEY_DOT
    bne b3
    ldy current_xpos
    iny
    sty play_collision.xpos
    lda current_ypos
    sta play_collision.ypos
    ldx current_orientation
    lda current_piece
    sta current_piece_100
    lda current_piece+1
    sta current_piece_100+1
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
    lda current_ypos
    sta play_collision.ypos
    ldx current_orientation
    lda current_piece
    sta current_piece_99
    lda current_piece+1
    sta current_piece_99+1
    jsr play_collision
    cmp #COLLISION_NONE
    bne b3
    dec current_xpos
    jmp b2
}
// Move down the current piece
// Return non-zero if a render is needed
// play_move_down(byte register(A) key_event)
play_move_down: {
    inc current_movedown_counter
    cmp #KEY_SPACE
    bne b4
    ldx #1
    jmp b1
  b4:
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
    bcc b3
    inx
  b3:
    cpx #0
    beq b5
    ldy current_ypos
    iny
    sty play_collision.ypos
    lda current_xpos
    sta play_collision.xpos
    ldx current_orientation
    lda current_piece
    sta current_piece_98
    lda current_piece+1
    sta current_piece_98+1
    jsr play_collision
    cmp #COLLISION_NONE
    beq b10
    jsr play_lock_current
    jsr play_remove_lines
    lda play_remove_lines.removed
    tax
    jsr play_update_score
    jsr play_spawn_current
    ldy play_spawn_current._0
    lda PIECES,y
    sta current_piece
    lda PIECES+1,y
    sta current_piece+1
    lda #0
    sta current_orientation
  b11:
    lda #0
    sta current_movedown_counter
    ldx #1
    jmp breturn
  b5:
    ldx #0
  breturn:
    rts
  b10:
    inc current_ypos
    jmp b11
}
// Spawn a new piece
// Moves the next piece into the current and spawns a new next piece
play_spawn_current: {
    .label _0 = 4
    .label piece_idx = $21
    // Move next piece into current
    ldx next_piece_idx
    txa
    asl
    sta _0
    lda PIECES_CHARS,x
    sta current_piece_char
    ldy _0
    lda PIECES,y
    sta current_piece_gfx
    lda PIECES+1,y
    sta current_piece_gfx+1
    lda PIECES_START_X,x
    sta current_xpos
    lda PIECES_START_Y,x
    sta current_ypos
    lda current_xpos
    sta play_collision.xpos
    lda current_ypos
    sta play_collision.ypos
    lda PIECES,y
    sta current_piece_102
    lda PIECES+1,y
    sta current_piece_102+1
    ldx #0
    jsr play_collision
    cmp #COLLISION_PLAYFIELD
    bne b1
    lda #1
    sta game_over
  b1:
    lda #7
    sta piece_idx
  b2:
    lda #7
    cmp piece_idx
    beq b3
    rts
  b3:
    jsr sid_rnd
    and #7
    sta piece_idx
    jmp b2
}
// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
sid_rnd: {
    lda SID_VOICE3_OSC
    rts
}
// Update the score based on the number of lines removed
// play_update_score(byte register(X) removed)
play_update_score: {
    .label lines_before = 4
    .label add_bcd = $2c
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
    bcc !+
    inc lines_bcd+1
  !:
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
// Increase the level
play_increase_level: {
    inc level
    // Update speed of moving tetrominos down
    lda #$1d
    cmp level
    bcc b3
    ldy level
    lda MOVEDOWN_SLOW_SPEEDS,y
    sta current_movedown_slow
    jmp b1
  b3:
    lda #1
    sta current_movedown_slow
  b1:
    inc level_bcd
    lda #$f
    and level_bcd
    cmp #$a
    bne b2
    // If level low nybble hits $a change to $10
    lax level_bcd
    axs #-[6]
    stx level_bcd
  b2:
    // Increase the score values gained
    sed
    ldx #0
  b5:
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
    bne b5
    cld
    rts
}
// Look through the playfield for lines - and remove any lines found
// Utilizes two cursors on the playfield - one reading cells and one writing cells
// Whenever a full line is detected the writing cursor is instructed to write to the same line once more.
// Returns the number of lines removed
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
  // Read all lines and rewrite them
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
    lda #PLAYFIELD_COLS-1+1
    cmp x
    bne b2
    lda #1
    cmp full
    bne b6
    txa
    axs #-[PLAYFIELD_COLS]
    inc removed
  b6:
    inc y
    lda #PLAYFIELD_LINES-1+1
    cmp y
    bne b1
  b4:
  // Write zeros in the rest of the lines
    cpx #$ff
    bne b8
    rts
  b8:
    lda #0
    sta playfield,x
    dex
    jmp b4
}
// Lock the current piece onto the playfield
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
    bne b7
    lda ypos2
    clc
    adc #2
    sta ypos2
    inc l
    lda #4
    cmp l
    bne b6
    rts
  b6:
    lda i
    sta i_7
    jmp b1
  b7:
    lda i
    sta i_9
    jmp b2
}
// Determine if a specific key is currently pressed based on the last keyboard_event_scan()
// Returns 0 is not pressed and non-0 if pressed
// keyboard_event_pressed(byte zeropage(9) keycode)
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
// Get the next event from the keyboard event buffer.
// Returns $ff if there is no event waiting. As all events are <$7f it is enough to examine bit 7 when determining if there is any event to process.
// The buffer is filled by keyboard_event_scan()
keyboard_event_get: {
    lda keyboard_events_size
    cmp #0
    beq b1
    dec keyboard_events_size
    ldy keyboard_events_size
    ldx keyboard_events,y
    jmp breturn
  b1:
    ldx #$ff
  breturn:
    rts
}
// Scans the entire matrix to determine which keys have been pressed/depressed.
// Generates keyboard events into the event buffer. Events can be read using keyboard_event_get().
// Handles debounce and only generates events when the status of a key changes.
// Also stores current status of modifiers in keyboard_modifiers.
keyboard_event_scan: {
    .label row_scan = $b
    .label keycode = $a
    .label row = 9
    lda #0
    sta keycode
    sta row
  b7:
    ldx row
    jsr keyboard_matrix_read
    sta row_scan
    ldy row
    cmp keyboard_scan_values,y
    bne b6
    lax keycode
    axs #-[8]
    stx keycode
  b8:
    inc row
    lda #8
    cmp row
    bne b7
    lda #KEY_LSHIFT
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b4
    ldx #0|KEY_MODIFIER_LSHIFT
    jmp b1
  b4:
    ldx #0
  b1:
    lda #KEY_RSHIFT
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b2
    txa
    ora #KEY_MODIFIER_RSHIFT
    tax
  b2:
    lda #KEY_CTRL
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b3
    txa
    ora #KEY_MODIFIER_CTRL
    tax
  b3:
    lda #KEY_COMMODORE
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq breturn
    txa
    ora #KEY_MODIFIER_COMMODORE
  breturn:
    rts
  // Something has changed on the keyboard row - check each column
  b6:
    ldx #0
  b9:
    lda row_scan
    ldy row
    eor keyboard_scan_values,y
    and keyboard_matrix_col_bitmask,x
    cmp #0
    beq b10
    lda #8
    cmp keyboard_events_size
    beq b10
    lda keyboard_matrix_col_bitmask,x
    and row_scan
    cmp #0
    beq b11
    // Key pressed
    lda keycode
    ldy keyboard_events_size
    sta keyboard_events,y
    inc keyboard_events_size
  b10:
    inc keycode
    inx
    cpx #8
    bne b9
    // Store the current keyboard status for the row to debounce
    lda row_scan
    ldy row
    sta keyboard_scan_values,y
    jmp b8
  b11:
    lda #$40
    ora keycode
    // Key released
    ldy keyboard_events_size
    sta keyboard_events,y
    inc keyboard_events_size
    jmp b10
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
// Update $D018 to show the current screen (used for double buffering)
render_show: {
    .const toD0181_return = (>(PLAYFIELD_SCREEN_1&$3fff)<<2)|(>PLAYFIELD_CHARSET)>>2&$f
    .const toD0182_return = (>(PLAYFIELD_SCREEN_2&$3fff)<<2)|(>PLAYFIELD_CHARSET)>>2&$f
    lda render_screen_show
    cmp #0
    beq toD0181
    lda #toD0182_return
  b1:
    sta D018
    ldy level
    lda PIECES_COLORS_1,y
    sta BGCOL2
    lda PIECES_COLORS_2,y
    sta BGCOL3
    lda render_screen_show
    sta render_screen_showing
    rts
  toD0181:
    lda #toD0181_return
    jmp b1
}
// Initialize play data tables
play_init: {
    .label pli = 5
    .label idx = 2
    lda #0
    sta idx
    lda #<playfield
    sta pli
    lda #>playfield
    sta pli+1
    ldy #0
  b1:
    tya
    asl
    tax
    lda pli
    sta playfield_lines,x
    lda pli+1
    sta playfield_lines+1,x
    lda idx
    sta playfield_lines_idx,y
    lda #PLAYFIELD_COLS
    clc
    adc pli
    sta pli
    bcc !+
    inc pli+1
  !:
    lax idx
    axs #-[PLAYFIELD_COLS]
    stx idx
    iny
    cpy #PLAYFIELD_LINES-1+1
    bne b1
    lda #PLAYFIELD_COLS*PLAYFIELD_LINES
    sta playfield_lines_idx+PLAYFIELD_LINES
    // Set initial speed of moving down a tetromino
    lda MOVEDOWN_SLOW_SPEEDS
    sta current_movedown_slow
    ldx #0
  // Set the initial score add values
  b3:
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
    bne b3
    rts
}
// Setup the IRQ
sprites_irq_init: {
    sei
    // Acknowledge any IRQ and setup the next one
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda CIA1_INTERRUPT
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // Set raster line
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    lda #IRQ_RASTER_FIRST
    sta RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // Set the IRQ routine
    lda #<sprites_irq
    sta HARDWARE_IRQ
    lda #>sprites_irq
    sta HARDWARE_IRQ+1
    cli
    rts
}
// Setup the sprites
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
    ldy #0
  b1:
    tya
    asl
    tax
    lda xpos
    sta SPRITES_XPOS,x
    lda #BLACK
    sta SPRITES_COLS,y
    lax xpos
    axs #-[$18]
    stx xpos
    iny
    cpy #4
    bne b1
    rts
}
// Initialize rendering
render_init: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>PLAYFIELD_CHARSET)>>6
    .label li_1 = 5
    .label li_2 = 7
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    // Enable Extended Background Color Mode
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #BLACK
    sta BORDERCOL
    sta BGCOL1
    lda PIECES_COLORS_1
    sta BGCOL2
    lda PIECES_COLORS_2
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
    lda #$28
    clc
    adc li_1
    sta li_1
    bcc !+
    inc li_1+1
  !:
    lda #$28
    clc
    adc li_2
    sta li_2
    bcc !+
    inc li_2+1
  !:
    inx
    cpx #PLAYFIELD_LINES-1+1
    bne b1
    rts
}
// Copy the original screen data to the passed screen
// Also copies colors to $d800
// render_screen_original(byte* zeropage($11) screen)
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
    lda #$19
    cmp y
    bne b1
    rts
}
// Initialize SID voice 3 for random number generation
sid_rnd_init: {
    lda #<$ffff
    sta SID_VOICE3_FREQ
    lda #>$ffff
    sta SID_VOICE3_FREQ+1
    lda #SID_CONTROL_NOISE
    sta SID_VOICE3_CONTROL
    rts
}
// Raster Interrupt Routine - sets up the sprites covering the playfield
// Repeats 10 timers every 2 lines from line IRQ_RASTER_FIRST
// Utilizes duplicated gfx in the sprites to allow for some leeway in updating the sprite pointers
sprites_irq: {
    .const toSpritePtr2_return = PLAYFIELD_SPRITES>>6
    .label raster_sprite_gfx_modify = $24
    sta rega+1
    stx regx+1
    //(*BGCOL)++;
    // Clear decimal flag (because it is used by the score algorithm)
    cld
    // Place the sprites
    lda irq_sprite_ypos
    sta SPRITES_YPOS
    sta SPRITES_YPOS+2
    sta SPRITES_YPOS+4
    sta SPRITES_YPOS+6
    ldx irq_raster_next
    inx
    // Wait for the y-position before changing sprite pointers
    stx raster_sprite_gfx_modify
  b8:
    lda RASTER
    cmp raster_sprite_gfx_modify
    bcc b8
    ldx irq_sprite_ptr
    lda render_screen_showing
    cmp #0
    beq b1
    stx PLAYFIELD_SPRITE_PTRS_2
    inx
    txa
    sta PLAYFIELD_SPRITE_PTRS_2+1
    sta PLAYFIELD_SPRITE_PTRS_2+2
    clc
    adc #1
    sta PLAYFIELD_SPRITE_PTRS_2+3
  b2:
    inc irq_cnt
    lda #9
    cmp irq_cnt
    beq b3
    lda #$a
    cmp irq_cnt
    beq b4
    lax irq_raster_next
    axs #-[$14]
    stx irq_raster_next
    lax irq_sprite_ypos
    axs #-[$15]
    stx irq_sprite_ypos
    lax irq_sprite_ptr
    axs #-[3]
    stx irq_sprite_ptr
  b5:
    // Setup next interrupt
    lda irq_raster_next
    sta RASTER
    // Acknowledge the IRQ and setup the next one
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
    lax irq_sprite_ypos
    axs #-[$15]
    stx irq_sprite_ypos
    lax irq_sprite_ptr
    axs #-[3]
    stx irq_sprite_ptr
    jmp b5
  b3:
    lax irq_raster_next
    axs #-[$15]
    stx irq_raster_next
    lda #SPRITES_FIRST_YPOS
    sta irq_sprite_ypos
    lda #toSpritePtr2_return
    sta irq_sprite_ptr
    jmp b5
  b1:
    stx PLAYFIELD_SPRITE_PTRS_1
    inx
    stx PLAYFIELD_SPRITE_PTRS_1+1
    stx PLAYFIELD_SPRITE_PTRS_1+2
    inx
    txa
    sta PLAYFIELD_SPRITE_PTRS_1+3
    jmp b2
}
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  // Keyboard event buffer. Contains keycodes for key presses/releases. Presses are represented by the keycode. Releases by keycode | $40. The buffer is filled by keyboard_scan()
  keyboard_events: .fill 8, 0
  // The values scanned values for each row. Set by keyboard_scan() and used by keyboard_get_event()
  keyboard_scan_values: .fill 8, 0
  // The T-piece
  .align $40
  PIECE_T: .byte 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0
  // The S-piece
  .align $40
  PIECE_S: .byte 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0
  // The Z-piece
  .align $40
  PIECE_Z: .byte 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0
  // The L-piece
  .align $40
  PIECE_L: .byte 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0
  // The J-piece
  .align $40
  PIECE_J: .byte 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
  // The O-piece
  .align $40
  PIECE_O: .byte 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0
  // The I-piece
  .align $40
  PIECE_I: .byte 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0
  // The chars to use for the different pieces - when inside the playing area
  PIECES_CHARS: .byte $65, $66, $a6, $66, $65, $65, $a6
  // The chars to use for the different pieces - when outside the playing area (eg. the next area).
  PIECES_NEXT_CHARS: .byte $63, $64, $a4, $64, $63, $63, $a4
  // The initial X/Y for each piece
  PIECES_START_X: .byte 4, 4, 4, 4, 4, 4, 4
  PIECES_START_Y: .byte 1, 1, 1, 1, 1, 0, 1
  // The speed of moving down the piece when soft-drop is not activated
  // This array holds the number of frames per move by level (0-29). For all levels 29+ the value is 1.
  MOVEDOWN_SLOW_SPEEDS: .byte $30, $2b, $26, $21, $1c, $17, $12, $d, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1
  // Base Score values for removing 0-4 lines (in BCD)
  // These values are added to score_add_bcd for each level gained.
  SCORE_BASE_BCD: .dword 0, $40, $100, $300, $1200
  // Score values for removing 0-4 lines (in BCD)
  // These values are updated based on the players level and the base values from SCORE_BASE_BCD
  score_add_bcd: .fill 4*5, 0
  // The color #1 to use for the pieces for each level
  PIECES_COLORS_1: .byte BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED, BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED, BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED
  // The color #2 to use for the pieces for each level
  PIECES_COLORS_2: .byte CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE, CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE, CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE
  // Pointers to the screen address for rendering each playfield line
  // The lines for screen 1 is aligned with $80 and screen 2 with $40 - so XOR'ing with $40 gives screen 2 lines.
  .align $80
  screen_lines_1: .fill 2*PLAYFIELD_LINES, 0
  .align $40
  screen_lines_2: .fill 2*PLAYFIELD_LINES, 0
  // Pointers to the playfield address for each playfield line
  playfield_lines: .fill 2*PLAYFIELD_LINES, 0
  // The playfield.  0 is empty non-zero is color.
  // The playfield is layed out line by line, meaning the first 10 bytes are line 1, the next 10 line 2 and so forth,
  playfield: .fill PLAYFIELD_LINES*PLAYFIELD_COLS, 0
  // The different pieces
  PIECES: .word PIECE_T, PIECE_S, PIECE_Z, PIECE_J, PIECE_O, PIECE_I, PIECE_L
  // Indixes into the playfield  for each playfield line
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
	// Put the sprites into memory 
	.for(var sy=0;sy<10;sy++) {
	    .var sprite_gfx_y = sy*20
		.for(var sx=0;sx<3;sx++) {
	    	.for (var y=0;y<21; y++) {
	    	    .var gfx_y =  sprite_gfx_y + mod(2100+y-sprite_gfx_y,21)
		    	.for (var c=0; c<3; c++) {
	            	.byte sprites.getSinglecolorByte(sx*3+c,gfx_y)
	            }
	        }
	    	.byte 0
	  	}
	}

