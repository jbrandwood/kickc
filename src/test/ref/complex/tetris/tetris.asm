// Tetris Game for the Commodore 64
// The tetris game tries to match NES tetris gameplay pretty closely
// Source: https://meatfighter.com/nintendotetrisai/
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = 5
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
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
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
  // SID registers for random number generation
  .label SID_VOICE3_FREQ = $d40e
  .label SID_VOICE3_CONTROL = $d412
  .const SID_CONTROL_NOISE = $80
  .label SID_VOICE3_OSC = $d41b
  // Address of the first screen
  .label PLAYFIELD_SCREEN_1 = $400
  // Address of the second screen
  .label PLAYFIELD_SCREEN_2 = $2c00
  // Screen Sprite pointers on screen 1
  .label PLAYFIELD_SPRITE_PTRS_1 = PLAYFIELD_SCREEN_1+SPRITE_PTRS
  // Screen Sprite pointers on screen 2
  .label PLAYFIELD_SPRITE_PTRS_2 = PLAYFIELD_SCREEN_2+SPRITE_PTRS
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
  // The line of the first IRQ
  .const IRQ_RASTER_FIRST = SPRITES_FIRST_YPOS+$13
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
  .const toSpritePtr1_return = PLAYFIELD_SPRITES/$40
  .label keyboard_events_size = $13
  .label render_screen_showing = 2
  .label score_bcd = 3
  .label irq_raster_next = $1c
  .label irq_sprite_ypos = $1d
  .label irq_sprite_ptr = $1e
  .label irq_cnt = $1f
  .label current_movedown_slow = 8
  .label current_ypos = $18
  .label current_xpos = $2b
  .label current_orientation = $11
  .label current_piece_gfx = $19
  .label current_piece_char = $26
  .label level_bcd = 9
  .label current_piece = $2c
  .label game_over = $b
  .label next_piece_idx = $a
  .label level = 7
  .label render_screen_render = $15
  .label render_screen_show = $14
  .label current_movedown_counter = $c
  .label lines_bcd = $16
  .label current_piece_1 = $22
  .label render_screen_render_1 = $d
  .label current_xpos_1 = $e
  .label current_piece_gfx_1 = $24
  .label current_piece_char_1 = $f
__b1:
  // The screen currently being showed to the user. 0x00 for screen 1 / 0x20 for screen 2.
  lda #0
  sta.z render_screen_showing
  // Current score in BCD-format
  sta.z score_bcd
  sta.z score_bcd+1
  sta.z score_bcd+2
  sta.z score_bcd+3
// Original Color Data
  // The raster line of the next IRQ
  lda #IRQ_RASTER_FIRST
  sta.z irq_raster_next
  // Y-pos of the sprites on the next IRQ
  lda #SPRITES_FIRST_YPOS+$15
  sta.z irq_sprite_ypos
  // Index of the sprites to show on the next IRQ
  lda #toSpritePtr1_return+3
  sta.z irq_sprite_ptr
  // Counting the 10 IRQs
  lda #0
  sta.z irq_cnt
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
    sta.z game_over
    sta.z next_piece_idx
    jsr play_spawn_current
    jsr play_spawn_current
    ldx #$20
    jsr render_playfield
    ldx.z current_ypos
    lda.z current_xpos
    sta.z current_xpos_1
    ldy.z play_spawn_current.__7
    lda PIECES,y
    sta.z current_piece_gfx_1
    lda PIECES+1,y
    sta.z current_piece_gfx_1+1
    lda.z current_piece_char
    sta.z current_piece_char_1
    lda #$20
    sta.z render_screen_render_1
    jsr render_moving
    ldx.z play_spawn_current.piece_idx
    lda #$20
    jsr render_next
    ldy.z play_spawn_current.__7
    lda PIECES,y
    sta.z current_piece
    lda PIECES+1,y
    sta.z current_piece+1
    lda PIECES,y
    sta.z current_piece_gfx
    lda PIECES+1,y
    sta.z current_piece_gfx+1
    lda #0
    sta.z level_bcd
    sta.z level
    sta.z lines_bcd
    sta.z lines_bcd+1
    sta.z current_movedown_counter
    sta.z keyboard_events_size
    sta.z current_orientation
    lda #$20
    sta.z render_screen_render
    lda #0
    sta.z render_screen_show
  __b1:
  // Wait for a frame to pass
  __b2:
    lda #$ff
    cmp RASTER
    bne __b2
    jsr render_show
    jsr keyboard_event_scan
    jsr keyboard_event_get
    lda.z game_over
    cmp #0
    beq __b4
  __b5:
    inc BORDERCOL
    jmp __b5
  __b4:
    stx.z play_movement.key_event
    jsr play_movement
    lda.z play_movement.return
    cmp #0
    beq __b1
    ldx.z render_screen_render
    jsr render_playfield
    ldx.z current_ypos
    lda.z render_screen_render
    sta.z render_screen_render_1
    lda.z current_xpos
    sta.z current_xpos_1
    lda.z current_piece_gfx
    sta.z current_piece_gfx_1
    lda.z current_piece_gfx+1
    sta.z current_piece_gfx_1+1
    lda.z current_piece_char
    sta.z current_piece_char_1
    jsr render_moving
    lda.z render_screen_render
    ldx.z next_piece_idx
    jsr render_next
    jsr render_score
    jsr render_screen_swap
    jmp __b1
}
// Swap rendering to the other screen (used for double buffering)
render_screen_swap: {
    lda #$20
    eor.z render_screen_render
    sta.z render_screen_render
    lda #$20
    eor.z render_screen_show
    sta.z render_screen_show
    rts
}
// Show the current score
render_score: {
    .const score_offset = $28*5+$1c
    .const lines_offset = $28*1+$16
    .const level_offset = $28*$13+$1f
    .label score_bytes = score_bcd
    .label screen = $24
    lda.z render_screen_render
    cmp #0
    beq __b1
    lda #<PLAYFIELD_SCREEN_2
    sta.z screen
    lda #>PLAYFIELD_SCREEN_2
    sta.z screen+1
    jmp __b2
  __b1:
    lda #<PLAYFIELD_SCREEN_1
    sta.z screen
    lda #>PLAYFIELD_SCREEN_1
    sta.z screen+1
  __b2:
    ldx score_bytes+2
    ldy #0
    lda #<score_offset
    sta.z render_bcd.offset
    lda #>score_offset
    sta.z render_bcd.offset+1
    jsr render_bcd
    ldx score_bytes+1
    ldy #0
    lda #<score_offset+2
    sta.z render_bcd.offset
    lda #>score_offset+2
    sta.z render_bcd.offset+1
    jsr render_bcd
    ldx.z score_bytes
    ldy #0
    lda #<score_offset+4
    sta.z render_bcd.offset
    lda #>score_offset+4
    sta.z render_bcd.offset+1
    jsr render_bcd
    lda.z lines_bcd+1
    tax
    ldy #1
    lda #<lines_offset
    sta.z render_bcd.offset
    lda #>lines_offset
    sta.z render_bcd.offset+1
    jsr render_bcd
    lda.z lines_bcd
    tax
    ldy #0
    lda #<lines_offset+1
    sta.z render_bcd.offset
    lda #>lines_offset+1
    sta.z render_bcd.offset+1
    jsr render_bcd
    ldx.z level_bcd
    ldy #0
    lda #<level_offset
    sta.z render_bcd.offset
    lda #>level_offset
    sta.z render_bcd.offset+1
    jsr render_bcd
    rts
}
// Render BCD digits on a screen.
// - screen: pointer to the screen to render on
// - offset: offset on the screen
// - bcd: The BCD-value to render
// - only_low: if non-zero only renders the low digit
// render_bcd(byte* zeropage($24) screen, word zeropage($22) offset, byte register(X) bcd, byte register(Y) only_low)
render_bcd: {
    .const ZERO_CHAR = $35
    .label screen = $24
    .label screen_pos = $22
    .label offset = $22
    lda.z screen_pos
    clc
    adc.z screen
    sta.z screen_pos
    lda.z screen_pos+1
    adc.z screen+1
    sta.z screen_pos+1
    cpy #0
    bne __b1
    txa
    lsr
    lsr
    lsr
    lsr
    clc
    adc #ZERO_CHAR
    ldy #0
    sta (screen_pos),y
    inc.z screen_pos
    bne !+
    inc.z screen_pos+1
  !:
  __b1:
    txa
    and #$f
    clc
    adc #ZERO_CHAR
    ldy #0
    sta (screen_pos),y
    rts
}
// Render the next tetromino in the "next" area
render_next: {
    // Find the screen area
    .const next_area_offset = $28*$c+$18+4
    .label next_piece_char = $21
    .label next_piece_gfx = $24
    .label screen_next_area = $22
    .label l = $d
    cmp #0
    beq __b1
    lda #<PLAYFIELD_SCREEN_2+next_area_offset
    sta.z screen_next_area
    lda #>PLAYFIELD_SCREEN_2+next_area_offset
    sta.z screen_next_area+1
    jmp __b2
  __b1:
    lda #<PLAYFIELD_SCREEN_1+next_area_offset
    sta.z screen_next_area
    lda #>PLAYFIELD_SCREEN_1+next_area_offset
    sta.z screen_next_area+1
  __b2:
    txa
    asl
    tay
    lda PIECES_NEXT_CHARS,x
    sta.z next_piece_char
    lda PIECES,y
    sta.z next_piece_gfx
    lda PIECES+1,y
    sta.z next_piece_gfx+1
    lda #0
    sta.z l
  __b3:
    ldx #0
  __b4:
    ldy #0
    lda (next_piece_gfx),y
    inc.z next_piece_gfx
    bne !+
    inc.z next_piece_gfx+1
  !:
    cmp #0
    bne __b5
    lda #0
    tay
    sta (screen_next_area),y
  __b6:
    inc.z screen_next_area
    bne !+
    inc.z screen_next_area+1
  !:
    inx
    cpx #4
    bne __b4
    lda #$24
    clc
    adc.z screen_next_area
    sta.z screen_next_area
    bcc !+
    inc.z screen_next_area+1
  !:
    inc.z l
    lda #4
    cmp.z l
    bne __b3
    rts
  __b5:
    lda.z next_piece_char
    ldy #0
    sta (screen_next_area),y
    jmp __b6
}
// Render the current moving piece at position (current_xpos, current_ypos)
// Ignores cases where parts of the tetromino is outside the playfield (sides/bottom) since the movement collision routine prevents this.
render_moving: {
    .label ypos = $10
    .label screen_line = $22
    .label xpos = $21
    .label i = $20
    .label l = $12
    stx.z ypos
    lda #0
    sta.z l
    sta.z i
  __b1:
    lda.z ypos
    cmp #1+1
    bcs __b2
    lax.z i
    axs #-[4]
    stx.z i
  __b3:
    inc.z ypos
    inc.z l
    lda #4
    cmp.z l
    bne __b1
    rts
  __b2:
    lda.z render_screen_render_1
    clc
    adc.z ypos
    asl
    tay
    lda screen_lines_1,y
    sta.z screen_line
    lda screen_lines_1+1,y
    sta.z screen_line+1
    lda.z current_xpos_1
    sta.z xpos
    ldx #0
  __b4:
    ldy.z i
    lda (current_piece_gfx_1),y
    inc.z i
    cmp #0
    beq __b5
    lda.z current_piece_char_1
    ldy.z xpos
    sta (screen_line),y
  __b5:
    inc.z xpos
    inx
    cpx #4
    bne __b4
    jmp __b3
}
// Render the static playfield on the screen (all pieces already locked into place)
render_playfield: {
    .label screen_line = $24
    .label i = $f
    .label c = $10
    .label l = $e
    lda #PLAYFIELD_COLS*2
    sta.z i
    lda #2
    sta.z l
  __b1:
    txa
    clc
    adc.z l
    asl
    tay
    lda screen_lines_1,y
    sta.z screen_line
    lda screen_lines_1+1,y
    sta.z screen_line+1
    lda #0
    sta.z c
  __b2:
    ldy.z i
    lda playfield,y
    ldy #0
    sta (screen_line),y
    inc.z screen_line
    bne !+
    inc.z screen_line+1
  !:
    inc.z i
    inc.z c
    lda #PLAYFIELD_COLS-1+1
    cmp.z c
    bne __b2
    inc.z l
    lda #PLAYFIELD_LINES-1+1
    cmp.z l
    bne __b1
    rts
}
// Perform any movement of the current piece
// key_event is the next keyboard_event() og 0xff if no keyboard event is pending
// Returns a byte signaling whether rendering is needed. (0 no render, >0 render needed)
// play_movement(byte zeropage($20) key_event)
play_movement: {
    .label render = $12
    .label return = $12
    .label key_event = $20
    lda.z key_event
    jsr play_move_down
    txa
    sta.z render
    lda.z game_over
    cmp #0
    beq __b1
    rts
  __b1:
    lda.z key_event
    jsr play_move_leftright
    clc
    adc.z render
    sta.z render
    lda.z key_event
    jsr play_move_rotate
    clc
    adc.z return
    sta.z return
    rts
}
// Rotate the current piece  based on key-presses
// Return non-zero if a render is needed
// play_move_rotate(byte register(A) key_event)
play_move_rotate: {
    .label orientation = $20
    cmp #KEY_Z
    beq __b1
    cmp #KEY_X
    beq __b2
  b1:
    lda #0
    rts
  __b2:
    lax.z current_orientation
    axs #-[$10]
    lda #$3f
    sax.z orientation
  __b3:
    lda.z current_xpos
    sta.z play_collision.xpos
    lda.z current_ypos
    sta.z play_collision.ypos
    ldx.z orientation
    lda.z current_piece
    sta.z current_piece_1
    lda.z current_piece+1
    sta.z current_piece_1+1
    jsr play_collision
    cmp #COLLISION_NONE
    bne b1
    lda.z orientation
    sta.z current_orientation
    clc
    adc.z current_piece
    sta.z current_piece_gfx
    lda #0
    adc.z current_piece+1
    sta.z current_piece_gfx+1
    lda #1
    rts
  __b1:
    lax.z current_orientation
    axs #$10
    lda #$3f
    sax.z orientation
    jmp __b3
}
// Test if there is a collision between the current piece moved to (x, y) and anything on the playfield or the playfield boundaries
// Returns information about the type of the collision detected
// play_collision(byte zeropage($21) xpos, byte zeropage($d) ypos, byte register(X) orientation)
play_collision: {
    .label xpos = $21
    .label ypos = $d
    .label piece_gfx = $22
    .label yp = $d
    .label playfield_line = $24
    .label i = $2f
    .label xp = $10
    .label l = $e
    .label i_1 = $f
    txa
    clc
    adc.z piece_gfx
    sta.z piece_gfx
    bcc !+
    inc.z piece_gfx+1
  !:
    lda #0
    sta.z l
    sta.z i_1
  __b1:
    lda.z yp
    asl
    tay
    lda playfield_lines,y
    sta.z playfield_line
    lda playfield_lines+1,y
    sta.z playfield_line+1
    lda.z xpos
    sta.z xp
    ldx #0
  __b2:
    ldy.z i_1
    iny
    sty.z i
    ldy.z i_1
    lda (piece_gfx),y
    cmp #0
    beq __b3
    lda.z yp
    cmp #PLAYFIELD_LINES
    bcc __b4
    lda #COLLISION_BOTTOM
    rts
  __b4:
    lda #$80
    and.z xp
    cmp #0
    beq __b5
    lda #COLLISION_LEFT
    rts
  __b5:
    lda.z xp
    cmp #PLAYFIELD_COLS
    bcc __b6
    lda #COLLISION_RIGHT
    rts
  __b6:
    ldy.z xp
    lda (playfield_line),y
    cmp #0
    beq __b3
    lda #COLLISION_PLAYFIELD
    rts
  __b3:
    inc.z xp
    inx
    cpx #4
    bne __b10
    inc.z yp
    inc.z l
    lda #4
    cmp.z l
    bne __b9
    lda #COLLISION_NONE
    rts
  __b9:
    lda.z i
    sta.z i_1
    jmp __b1
  __b10:
    lda.z i
    sta.z i_1
    jmp __b2
}
// Move left/right or rotate the current piece
// Return non-zero if a render is needed
// play_move_leftright(byte register(A) key_event)
play_move_leftright: {
    // Handle keyboard events
    cmp #KEY_COMMA
    beq __b1
    cmp #KEY_DOT
    bne b2
    ldy.z current_xpos
    iny
    sty.z play_collision.xpos
    lda.z current_ypos
    sta.z play_collision.ypos
    ldx.z current_orientation
    lda.z current_piece
    sta.z current_piece_1
    lda.z current_piece+1
    sta.z current_piece_1+1
    jsr play_collision
    cmp #COLLISION_NONE
    bne b2
    inc.z current_xpos
  b1:
    lda #1
    rts
  b2:
    lda #0
    rts
  __b1:
    ldx.z current_xpos
    dex
    stx.z play_collision.xpos
    lda.z current_ypos
    sta.z play_collision.ypos
    ldx.z current_orientation
    lda.z current_piece
    sta.z current_piece_1
    lda.z current_piece+1
    sta.z current_piece_1+1
    jsr play_collision
    cmp #COLLISION_NONE
    bne b2
    dec.z current_xpos
    jmp b1
}
// Move down the current piece
// Return non-zero if a render is needed
// play_move_down(byte register(A) key_event)
play_move_down: {
    inc.z current_movedown_counter
    cmp #KEY_SPACE
    bne b1
    ldx #1
    jmp __b1
  b1:
    ldx #0
  __b1:
    lda #KEY_SPACE
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq __b2
    lda.z current_movedown_counter
    cmp #current_movedown_fast
    bcc __b2
    inx
  __b2:
    lda.z current_movedown_counter
    cmp.z current_movedown_slow
    bcc __b3
    inx
  __b3:
    cpx #0
    beq b2
    ldy.z current_ypos
    iny
    sty.z play_collision.ypos
    lda.z current_xpos
    sta.z play_collision.xpos
    ldx.z current_orientation
    lda.z current_piece
    sta.z current_piece_1
    lda.z current_piece+1
    sta.z current_piece_1+1
    jsr play_collision
    cmp #COLLISION_NONE
    beq __b10
    jsr play_lock_current
    jsr play_remove_lines
    lda.z play_remove_lines.removed
    tax
    jsr play_update_score
    jsr play_spawn_current
    ldy.z play_spawn_current.__7
    lda PIECES,y
    sta.z current_piece
    lda PIECES+1,y
    sta.z current_piece+1
    lda PIECES,y
    sta.z current_piece_gfx
    lda PIECES+1,y
    sta.z current_piece_gfx+1
    lda #0
    sta.z current_orientation
  __b11:
    lda #0
    sta.z current_movedown_counter
    ldx #1
    rts
  b2:
    ldx #0
    rts
  __b10:
    inc.z current_ypos
    jmp __b11
}
// Spawn a new piece
// Moves the next piece into the current and spawns a new next piece
play_spawn_current: {
    .label __7 = $2e
    .label piece_idx = $a
    // Move next piece into current
    ldx.z next_piece_idx
    txa
    asl
    sta.z __7
    lda PIECES_CHARS,x
    sta.z current_piece_char
    lda PIECES_START_X,x
    sta.z current_xpos
    lda PIECES_START_Y,x
    sta.z current_ypos
    lda.z current_xpos
    sta.z play_collision.xpos
    lda.z current_ypos
    sta.z play_collision.ypos
    ldy.z __7
    lda PIECES,y
    sta.z current_piece_1
    lda PIECES+1,y
    sta.z current_piece_1+1
    ldx #0
    jsr play_collision
    cmp #COLLISION_PLAYFIELD
    bne __b1
    lda #1
    sta.z game_over
  __b1:
    lda #7
    sta.z piece_idx
  __b2:
    lda #7
    cmp.z piece_idx
    beq sid_rnd1
    rts
  sid_rnd1:
    lda SID_VOICE3_OSC
    and #7
    sta.z piece_idx
    jmp __b2
}
// Update the score based on the number of lines removed
// play_update_score(byte register(X) removed)
play_update_score: {
    .label lines_before = $26
    .label add_bcd = $27
    cpx #0
    beq __breturn
    lda.z lines_bcd
    and #$f0
    sta.z lines_before
    txa
    asl
    asl
    tay
    lda score_add_bcd,y
    sta.z add_bcd
    lda score_add_bcd+1,y
    sta.z add_bcd+1
    lda score_add_bcd+2,y
    sta.z add_bcd+2
    lda score_add_bcd+3,y
    sta.z add_bcd+3
    sed
    txa
    clc
    adc.z lines_bcd
    sta.z lines_bcd
    bcc !+
    inc.z lines_bcd+1
  !:
    lda.z score_bcd
    clc
    adc.z add_bcd
    sta.z score_bcd
    lda.z score_bcd+1
    adc.z add_bcd+1
    sta.z score_bcd+1
    lda.z score_bcd+2
    adc.z add_bcd+2
    sta.z score_bcd+2
    lda.z score_bcd+3
    adc.z add_bcd+3
    sta.z score_bcd+3
    cld
    lda.z lines_bcd
    and #$f0
    cmp.z lines_before
    beq __breturn
    jsr play_increase_level
  __breturn:
    rts
}
// Increase the level
play_increase_level: {
    inc.z level
    // Update speed of moving tetrominos down
    lda.z level
    cmp #$1d+1
    bcs b1
    tay
    lda MOVEDOWN_SLOW_SPEEDS,y
    sta.z current_movedown_slow
    jmp __b1
  b1:
    lda #1
    sta.z current_movedown_slow
  __b1:
    inc.z level_bcd
    lda #$f
    and.z level_bcd
    cmp #$a
    bne __b2
    // If level low nybble hits 0xa change to 0x10
    lax.z level_bcd
    axs #-[6]
    stx.z level_bcd
  __b2:
    // Increase the score values gained
    sed
    ldx #0
  __b5:
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
    bne __b5
    cld
    rts
}
// Look through the playfield for lines - and remove any lines found
// Utilizes two cursors on the playfield - one reading cells and one writing cells
// Whenever a full line is detected the writing cursor is instructed to write to the same line once more.
// Returns the number of lines removed
play_remove_lines: {
    .label c = $2b
    .label x = $e
    .label y = $c
    .label removed = $d
    .label full = $f
    lda #0
    sta.z removed
    sta.z y
    ldx #PLAYFIELD_LINES*PLAYFIELD_COLS-1
    ldy #PLAYFIELD_LINES*PLAYFIELD_COLS-1
  // Read all lines and rewrite them
  __b1:
    lda #1
    sta.z full
    lda #0
    sta.z x
  __b2:
    lda playfield,y
    sta.z c
    dey
    cmp #0
    bne __b3
    lda #0
    sta.z full
  __b3:
    lda.z c
    sta playfield,x
    dex
    inc.z x
    lda #PLAYFIELD_COLS-1+1
    cmp.z x
    bne __b2
    lda #1
    cmp.z full
    bne __b6
    txa
    axs #-[PLAYFIELD_COLS]
    inc.z removed
  __b6:
    inc.z y
    lda #PLAYFIELD_LINES-1+1
    cmp.z y
    bne __b1
  b1:
  // Write zeros in the rest of the lines
    cpx #$ff
    bne __b8
    rts
  __b8:
    lda #0
    sta playfield,x
    dex
    jmp b1
}
// Lock the current piece onto the playfield
play_lock_current: {
    .label yp = $18
    .label playfield_line = $2c
    .label xp = $12
    .label i = $2f
    .label l = $10
    .label i_1 = $11
    lda #0
    sta.z l
    sta.z i_1
  __b1:
    lda.z yp
    asl
    tay
    lda playfield_lines,y
    sta.z playfield_line
    lda playfield_lines+1,y
    sta.z playfield_line+1
    lda.z current_xpos
    sta.z xp
    ldx #0
  __b2:
    ldy.z i_1
    iny
    sty.z i
    ldy.z i_1
    lda (current_piece_gfx),y
    cmp #0
    beq __b3
    lda.z current_piece_char
    ldy.z xp
    sta (playfield_line),y
  __b3:
    inc.z xp
    inx
    cpx #4
    bne __b7
    inc.z yp
    inc.z l
    lda #4
    cmp.z l
    bne __b6
    rts
  __b6:
    lda.z i
    sta.z i_1
    jmp __b1
  __b7:
    lda.z i
    sta.z i_1
    jmp __b2
}
// Determine if a specific key is currently pressed based on the last keyboard_event_scan()
// Returns 0 is not pressed and non-0 if pressed
// keyboard_event_pressed(byte zeropage($12) keycode)
keyboard_event_pressed: {
    .label row_bits = $2e
    .label keycode = $12
    lda.z keycode
    lsr
    lsr
    lsr
    tay
    lda keyboard_scan_values,y
    sta.z row_bits
    lda #7
    and.z keycode
    tay
    lda keyboard_matrix_col_bitmask,y
    and.z row_bits
    rts
}
// Get the next event from the keyboard event buffer.
// Returns $ff if there is no event waiting. As all events are <$7f it is enough to examine bit 7 when determining if there is any event to process.
// The buffer is filled by keyboard_event_scan()
keyboard_event_get: {
    lda.z keyboard_events_size
    cmp #0
    beq b1
    dec.z keyboard_events_size
    ldy.z keyboard_events_size
    ldx keyboard_events,y
    rts
  b1:
    ldx #$ff
    rts
}
// Scans the entire matrix to determine which keys have been pressed/depressed.
// Generates keyboard events into the event buffer. Events can be read using keyboard_event_get().
// Handles debounce and only generates events when the status of a key changes.
// Also stores current status of modifiers in keyboard_modifiers.
keyboard_event_scan: {
    .label row_scan = $2f
    .label keycode = $21
    .label row = $20
    lda #0
    sta.z keycode
    sta.z row
  __b7:
    ldx.z row
    jsr keyboard_matrix_read
    sta.z row_scan
    ldy.z row
    cmp keyboard_scan_values,y
    bne b2
    lax.z keycode
    axs #-[8]
    stx.z keycode
  __b8:
    inc.z row
    lda #8
    cmp.z row
    bne __b7
    lda #KEY_LSHIFT
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    lda #KEY_RSHIFT
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    lda #KEY_CTRL
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    lda #KEY_COMMODORE
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    rts
  // Something has changed on the keyboard row - check each column
  b2:
    ldx #0
  __b9:
    lda.z row_scan
    ldy.z row
    eor keyboard_scan_values,y
    and keyboard_matrix_col_bitmask,x
    cmp #0
    beq __b10
    lda #8
    cmp.z keyboard_events_size
    beq __b10
    lda keyboard_matrix_col_bitmask,x
    and.z row_scan
    cmp #0
    beq __b11
    // Key pressed
    lda.z keycode
    ldy.z keyboard_events_size
    sta keyboard_events,y
    inc.z keyboard_events_size
  __b10:
    inc.z keycode
    inx
    cpx #8
    bne __b9
    // Store the current keyboard status for the row to debounce
    lda.z row_scan
    ldy.z row
    sta keyboard_scan_values,y
    jmp __b8
  __b11:
    lda #$40
    ora.z keycode
    // Key released
    ldy.z keyboard_events_size
    sta keyboard_events,y
    inc.z keyboard_events_size
    jmp __b10
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
// Update 0xD018 to show the current screen (used for double buffering)
render_show: {
    .const toD0181_return = (>(PLAYFIELD_SCREEN_1&$3fff)*4)|(>PLAYFIELD_CHARSET)/4&$f
    .const toD0182_return = (>(PLAYFIELD_SCREEN_2&$3fff)*4)|(>PLAYFIELD_CHARSET)/4&$f
    lda.z render_screen_show
    cmp #0
    beq toD0181
    lda #toD0182_return
  __b1:
    sta D018
    ldy.z level
    lda PIECES_COLORS_1,y
    sta BGCOL2
    lda PIECES_COLORS_2,y
    sta BGCOL3
    lda.z render_screen_show
    sta.z render_screen_showing
    rts
  toD0181:
    lda #toD0181_return
    jmp __b1
}
// Initialize play data tables
play_init: {
    .label pli = $22
    .label idx = $14
    lda #0
    sta.z idx
    lda #<playfield
    sta.z pli
    lda #>playfield
    sta.z pli+1
    ldy #0
  __b1:
    tya
    asl
    tax
    lda.z pli
    sta playfield_lines,x
    lda.z pli+1
    sta playfield_lines+1,x
    lda.z idx
    sta playfield_lines_idx,y
    lda #PLAYFIELD_COLS
    clc
    adc.z pli
    sta.z pli
    bcc !+
    inc.z pli+1
  !:
    lax.z idx
    axs #-[PLAYFIELD_COLS]
    stx.z idx
    iny
    cpy #PLAYFIELD_LINES-1+1
    bne __b1
    lda #PLAYFIELD_COLS*PLAYFIELD_LINES
    sta playfield_lines_idx+PLAYFIELD_LINES
    // Set initial speed of moving down a tetromino
    lda MOVEDOWN_SLOW_SPEEDS
    sta.z current_movedown_slow
    ldx #0
  // Set the initial score add values
  __b3:
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
    bne __b3
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
    .label xpos = $15
    lda #$f
    sta SPRITES_ENABLE
    lda #0
    sta SPRITES_MC
    sta SPRITES_EXPAND_Y
    sta SPRITES_EXPAND_X
    lda #$18+$f*8
    sta.z xpos
    ldy #0
  __b1:
    tya
    asl
    tax
    lda.z xpos
    sta SPRITES_XPOS,x
    lda #BLACK
    sta SPRITES_COLS,y
    lax.z xpos
    axs #-[$18]
    stx.z xpos
    iny
    cpy #4
    bne __b1
    rts
}
// Initialize rendering
render_init: {
    .const vicSelectGfxBank1_toDd001_return = 3
    .label li_1 = $16
    .label li_2 = $2c
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
    sta.z render_screen_original.screen
    lda #>PLAYFIELD_SCREEN_1
    sta.z render_screen_original.screen+1
    jsr render_screen_original
    lda #<PLAYFIELD_SCREEN_2
    sta.z render_screen_original.screen
    lda #>PLAYFIELD_SCREEN_2
    sta.z render_screen_original.screen+1
    jsr render_screen_original
    lda #<PLAYFIELD_SCREEN_2+2*$28+$10
    sta.z li_2
    lda #>PLAYFIELD_SCREEN_2+2*$28+$10
    sta.z li_2+1
    lda #<PLAYFIELD_SCREEN_1+2*$28+$10
    sta.z li_1
    lda #>PLAYFIELD_SCREEN_1+2*$28+$10
    sta.z li_1+1
    ldy #0
  __b1:
    tya
    asl
    tax
    lda.z li_1
    sta screen_lines_1,x
    lda.z li_1+1
    sta screen_lines_1+1,x
    lda.z li_2
    sta screen_lines_2,x
    lda.z li_2+1
    sta screen_lines_2+1,x
    lda #$28
    clc
    adc.z li_1
    sta.z li_1
    bcc !+
    inc.z li_1+1
  !:
    lda #$28
    clc
    adc.z li_2
    sta.z li_2
    bcc !+
    inc.z li_2+1
  !:
    iny
    cpy #PLAYFIELD_LINES-1+1
    bne __b1
    rts
}
// Copy the original screen data to the passed screen
// Also copies colors to 0xd800
// render_screen_original(byte* zeropage($24) screen)
render_screen_original: {
    .const SPACE = 0
    .label screen = $24
    .label cols = $2c
    .label oscr = $19
    .label ocols = $22
    .label y = $18
    lda #0
    sta.z y
    lda #<PLAYFIELD_COLORS_ORIGINAL+$20*2
    sta.z ocols
    lda #>PLAYFIELD_COLORS_ORIGINAL+$20*2
    sta.z ocols+1
    lda #<PLAYFIELD_SCREEN_ORIGINAL+$20*2
    sta.z oscr
    lda #>PLAYFIELD_SCREEN_ORIGINAL+$20*2
    sta.z oscr+1
    lda #<COLS
    sta.z cols
    lda #>COLS
    sta.z cols+1
  __b1:
    ldx #0
  __b2:
    lda #SPACE
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    lda #BLACK
    ldy #0
    sta (cols),y
    inc.z cols
    bne !+
    inc.z cols+1
  !:
    inx
    cpx #4
    bne __b2
  __b3:
    ldy #0
    lda (oscr),y
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z oscr
    bne !+
    inc.z oscr+1
  !:
    ldy #0
    lda (ocols),y
    sta (cols),y
    inc.z cols
    bne !+
    inc.z cols+1
  !:
    inc.z ocols
    bne !+
    inc.z ocols+1
  !:
    inx
    cpx #$24
    bne __b3
  __b4:
    lda #SPACE
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    lda #BLACK
    ldy #0
    sta (cols),y
    inc.z cols
    bne !+
    inc.z cols+1
  !:
    inx
    cpx #$28
    bne __b4
    inc.z y
    lda #$19
    cmp.z y
    bne __b1
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
    .const toSpritePtr2_return = PLAYFIELD_SPRITES/$40
    .label raster_sprite_gfx_modify = $1b
    sta rega+1
    stx regx+1
    //(*BGCOL)++;
    // Clear decimal flag (because it is used by the score algorithm)
    cld
    // Place the sprites
    lda.z irq_sprite_ypos
    sta SPRITES_YPOS
    sta SPRITES_YPOS+2
    sta SPRITES_YPOS+4
    sta SPRITES_YPOS+6
    ldx.z irq_raster_next
    inx
    // Wait for the y-position before changing sprite pointers
    stx.z raster_sprite_gfx_modify
  __b8:
    lda RASTER
    cmp.z raster_sprite_gfx_modify
    bcc __b8
    ldx.z irq_sprite_ptr
    lda.z render_screen_showing
    cmp #0
    beq __b1
    stx PLAYFIELD_SPRITE_PTRS_2
    inx
    txa
    sta PLAYFIELD_SPRITE_PTRS_2+1
    sta PLAYFIELD_SPRITE_PTRS_2+2
    clc
    adc #1
    sta PLAYFIELD_SPRITE_PTRS_2+3
  __b2:
    inc.z irq_cnt
    lda #9
    cmp.z irq_cnt
    beq __b3
    lda #$a
    cmp.z irq_cnt
    beq __b4
    lax.z irq_raster_next
    axs #-[$14]
    stx.z irq_raster_next
    lax.z irq_sprite_ypos
    axs #-[$15]
    stx.z irq_sprite_ypos
    lax.z irq_sprite_ptr
    axs #-[3]
    stx.z irq_sprite_ptr
  __b5:
    // Setup next interrupt
    lda.z irq_raster_next
    sta RASTER
    // Acknowledge the IRQ and setup the next one
    lda #IRQ_RASTER
    sta IRQ_STATUS
  rega:
    lda #00
  regx:
    ldx #00
    rti
  __b4:
    lda #0
    sta.z irq_cnt
    lda #IRQ_RASTER_FIRST
    sta.z irq_raster_next
    lax.z irq_sprite_ypos
    axs #-[$15]
    stx.z irq_sprite_ypos
    lax.z irq_sprite_ptr
    axs #-[3]
    stx.z irq_sprite_ptr
    jmp __b5
  __b3:
    lax.z irq_raster_next
    axs #-[$15]
    stx.z irq_raster_next
    lda #SPRITES_FIRST_YPOS
    sta.z irq_sprite_ypos
    lda #toSpritePtr2_return
    sta.z irq_sprite_ptr
    jmp __b5
  __b1:
    stx PLAYFIELD_SPRITE_PTRS_1
    inx
    stx PLAYFIELD_SPRITE_PTRS_1+1
    stx PLAYFIELD_SPRITE_PTRS_1+2
    inx
    txa
    sta PLAYFIELD_SPRITE_PTRS_1+3
    jmp __b2
}
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  // The color #1 to use for the pieces for each level
  PIECES_COLORS_1: .byte BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED, BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED, BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED
  // The color #2 to use for the pieces for each level
  PIECES_COLORS_2: .byte CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE, CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE, CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE
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
  // The different pieces
  PIECES: .word PIECE_T, PIECE_S, PIECE_Z, PIECE_J, PIECE_O, PIECE_I, PIECE_L
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
  // Keyboard event buffer. Contains keycodes for key presses/releases. Presses are represented by the keycode. Releases by keycode | $40. The buffer is filled by keyboard_scan()
  keyboard_events: .fill 8, 0
  // The values scanned values for each row. Set by keyboard_scan() and used by keyboard_get_event()
  keyboard_scan_values: .fill 8, 0
  // The playfield.  0 is empty non-zero is color.
  // The playfield is layed out line by line, meaning the first 10 bytes are line 1, the next 10 line 2 and so forth,
  playfield: .fill PLAYFIELD_LINES*PLAYFIELD_COLS, 0
  // Pointers to the screen address for rendering each playfield line
  // The lines for screen 1 is aligned with 0x80 and screen 2 with 0x40 - so XOR'ing with 0x40 gives screen 2 lines.
  .align $80
  screen_lines_1: .fill 2*PLAYFIELD_LINES, 0
  .align $40
  screen_lines_2: .fill 2*PLAYFIELD_LINES, 0
  // Pointers to the playfield address for each playfield line
  playfield_lines: .fill 2*PLAYFIELD_LINES, 0
  // Indixes into the playfield  for each playfield line
  playfield_lines_idx: .fill PLAYFIELD_LINES+1, 0
  // Score values for removing 0-4 lines (in BCD)
  // These values are updated based on the players level and the base values from SCORE_BASE_BCD
  score_add_bcd: .fill 4*5, 0
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

