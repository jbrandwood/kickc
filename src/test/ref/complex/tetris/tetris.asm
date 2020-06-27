// Tetris Game for the Commodore 64
// The tetris game tries to match NES tetris gameplay pretty closely
// Source: https://meatfighter.com/nintendotetrisai/
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The offset of the sprite pointers from the screen start address
  .const SPRITE_PTRS = $3f8
  .const VIC_ECM = $40
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // SID Channel Control Register Noise Waveform
  .const SID_CONTROL_NOISE = $80
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
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
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6581_SID_CH3_FREQ = $e
  .const OFFSET_STRUCT_MOS6581_SID_CH3_CONTROL = $12
  .const OFFSET_STRUCT_MOS6581_SID_CH3_OSC = $1b
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_COLOR = $d027
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_MC = $d01c
  .label SPRITES_EXPAND_X = $d01d
  .label RASTER = $d012
  .label BORDER_COLOR = $d020
  .label BG_COLOR = $d021
  .label BG_COLOR1 = $d022
  .label BG_COLOR2 = $d023
  .label BG_COLOR3 = $d024
  .label VIC_CONTROL = $d011
  .label D011 = $d011
  .label D018 = $d018
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The SID MOS 6581/8580
  .label SID = $d400
  // Color Ram
  .label COLS = $d800
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  // CIA#1 Interrupt for reading in ASM
  .label CIA1_INTERRUPT = $dc0d
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  // Address of the first screen
  .label PLAYFIELD_SCREEN_1 = $400
  // Address of the second screen
  .label PLAYFIELD_SCREEN_2 = $2c00
  // Screen Sprite pointers on screen 1
  .label PLAYFIELD_SPRITE_PTRS_1 = PLAYFIELD_SCREEN_1+SPRITE_PTRS
  // Screen Sprite pointers on screen 2
  .label PLAYFIELD_SPRITE_PTRS_2 = PLAYFIELD_SCREEN_2+SPRITE_PTRS
  // The screen currently being showed to the user. 0x00 for screen 1 / 0x20 for screen 2.
  .label render_screen_showing = $24
  // Current score in BCD-format
  .label score_bcd = $25
  // The raster line of the next IRQ
  .label irq_raster_next = $29
  // Y-pos of the sprites on the next IRQ
  .label irq_sprite_ypos = $2a
  // Index of the sprites to show on the next IRQ
  .label irq_sprite_ptr = $2b
  // Counting the 10 IRQs
  .label irq_cnt = $2c
  // Keyboard event buffer size. The number of events currently in the event buffer
  .label keyboard_events_size = $a
  // The rate of moving down the current piece (number of frames between moves if movedown is  not forced)
  .label current_movedown_slow = $15
  // Position of top left corner of current moving piece on the playfield
  .label current_xpos = $1d
  .label current_ypos = $11
  // The curent piece orientation - each piece have 4 orientations (00/0x10/0x20/0x30).
  // The orientation chooses one of the 4 sub-graphics of the piece.
  .label current_orientation = $1a
  // Pointer to the current piece in the current orientation. Updated each time current_orientation is updated.
  .label current_piece_gfx = $1b
  // The char of the current piece
  .label current_piece_char = $19
  // Current level BCD-format
  .label level_bcd = $16
  // The screen currently being rendered to. 0x00 for screen 1 / 0x20 for screen 2.
  .label render_screen_render = 3
  // The screen currently to show next to the user. 0x00 for screen 1 / 0x20 for screen 2.
  // Show showing screen 1 and rendering to screen 2
  .label render_screen_show = 2
  // Counts up to the next movedown of current piece
  .label current_movedown_counter = 4
  // Current number of cleared lines in BCD-format
  .label lines_bcd = $12
  // Current level in normal (non-BCD) format
  .label level = $14
  // The current moving piece. Points to the start of the piece definition.
  .label current_piece = $17
  // Is the game over?
  .label game_over = $1e
  // The index of the next moving piece. (0-6)
  .label next_piece_idx = $1f
  // The current moving piece. Points to the start of the piece definition.
  .label current_piece_1 = $e
  // The screen currently being rendered to. 0x00 for screen 1 / 0x20 for screen 2.
  .label render_screen_render_1 = 5
  // Position of top left corner of current moving piece on the playfield
  .label current_xpos_1 = 6
  // Pointer to the current piece in the current orientation. Updated each time current_orientation is updated.
  .label current_piece_gfx_1 = 7
  // The char of the current piece
  .label current_piece_char_1 = 9
__start: {
    .const __init1_toSpritePtr1_return = $ff&PLAYFIELD_SPRITES/$40
    // render_screen_showing = 0
    lda #0
    sta.z render_screen_showing
    // score_bcd = 0
    sta.z score_bcd
    sta.z score_bcd+1
    lda #<0>>$10
    sta.z score_bcd+2
    lda #>0>>$10
    sta.z score_bcd+3
    // irq_raster_next = IRQ_RASTER_FIRST
    lda #IRQ_RASTER_FIRST
    sta.z irq_raster_next
    // irq_sprite_ypos = SPRITES_FIRST_YPOS + 21
    lda #SPRITES_FIRST_YPOS+$15
    sta.z irq_sprite_ypos
    // irq_sprite_ptr = toSpritePtr(PLAYFIELD_SPRITES) + 3
    lda #__init1_toSpritePtr1_return+3
    sta.z irq_sprite_ptr
    // irq_cnt = 0
    lda #0
    sta.z irq_cnt
    jsr main
    rts
}
// Raster Interrupt Routine - sets up the sprites covering the playfield
// Repeats 10 timers every 2 lines from line IRQ_RASTER_FIRST
// Utilizes duplicated gfx in the sprites to allow for some leeway in updating the sprite pointers
sprites_irq: {
    .const toSpritePtr1_return = $ff&PLAYFIELD_SPRITES/$40
    .label raster_sprite_gfx_modify = $2d
    sta rega+1
    stx regx+1
    // asm
    //(*BG_COLOR)++;
    // Clear decimal flag (because it is used by the score algorithm)
    cld
    // ypos = irq_sprite_ypos
    // Place the sprites
    lda.z irq_sprite_ypos
    // SPRITES_YPOS[0] = ypos
    sta SPRITES_YPOS
    // SPRITES_YPOS[2] = ypos
    sta SPRITES_YPOS+2
    // SPRITES_YPOS[4] = ypos
    sta SPRITES_YPOS+4
    // SPRITES_YPOS[6] = ypos
    sta SPRITES_YPOS+6
    // irq_raster_next+1
    ldx.z irq_raster_next
    inx
    // raster_sprite_gfx_modify = irq_raster_next+1
    // Wait for the y-position before changing sprite pointers
    stx.z raster_sprite_gfx_modify
  __b8:
    // while(*RASTER<raster_sprite_gfx_modify)
    lda RASTER
    cmp.z raster_sprite_gfx_modify
    bcc __b8
    // ptr = irq_sprite_ptr
    ldx.z irq_sprite_ptr
    // if(render_screen_showing==0)
    lda.z render_screen_showing
    cmp #0
    beq __b1
    // PLAYFIELD_SPRITE_PTRS_2[0] = ptr++
    stx PLAYFIELD_SPRITE_PTRS_2
    // PLAYFIELD_SPRITE_PTRS_2[0] = ptr++;
    inx
    txa
    // PLAYFIELD_SPRITE_PTRS_2[1] = ptr
    sta PLAYFIELD_SPRITE_PTRS_2+1
    // PLAYFIELD_SPRITE_PTRS_2[2] = ptr++
    sta PLAYFIELD_SPRITE_PTRS_2+2
    // PLAYFIELD_SPRITE_PTRS_2[2] = ptr++;
    clc
    adc #1
    // PLAYFIELD_SPRITE_PTRS_2[3] = ptr
    sta PLAYFIELD_SPRITE_PTRS_2+3
  __b2:
    // ++irq_cnt;
    inc.z irq_cnt
    // if(irq_cnt==9)
    lda #9
    cmp.z irq_cnt
    beq __b3
    // if(irq_cnt==10)
    lda #$a
    cmp.z irq_cnt
    beq __b4
    // irq_raster_next += 20
    lax.z irq_raster_next
    axs #-[$14]
    stx.z irq_raster_next
    // irq_sprite_ypos += 21
    lax.z irq_sprite_ypos
    axs #-[$15]
    stx.z irq_sprite_ypos
    // irq_sprite_ptr += 3
    lax.z irq_sprite_ptr
    axs #-[3]
    stx.z irq_sprite_ptr
  __b5:
    // *RASTER = irq_raster_next
    // Setup next interrupt
    lda.z irq_raster_next
    sta RASTER
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ and setup the next one
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #00
  regx:
    ldx #00
    rti
  __b4:
    // irq_cnt = 0
    lda #0
    sta.z irq_cnt
    // irq_raster_next = IRQ_RASTER_FIRST
    lda #IRQ_RASTER_FIRST
    sta.z irq_raster_next
    // irq_sprite_ypos += 21
    lax.z irq_sprite_ypos
    axs #-[$15]
    stx.z irq_sprite_ypos
    // irq_sprite_ptr += 3
    lax.z irq_sprite_ptr
    axs #-[3]
    stx.z irq_sprite_ptr
    jmp __b5
  __b3:
    // irq_raster_next += 21
    lax.z irq_raster_next
    axs #-[$15]
    stx.z irq_raster_next
    // irq_sprite_ypos = SPRITES_FIRST_YPOS
    lda #SPRITES_FIRST_YPOS
    sta.z irq_sprite_ypos
    // irq_sprite_ptr = toSpritePtr(PLAYFIELD_SPRITES)
    lda #toSpritePtr1_return
    sta.z irq_sprite_ptr
    jmp __b5
  __b1:
    // PLAYFIELD_SPRITE_PTRS_1[0] = ptr++
    stx PLAYFIELD_SPRITE_PTRS_1
    // PLAYFIELD_SPRITE_PTRS_1[0] = ptr++;
    inx
    // PLAYFIELD_SPRITE_PTRS_1[1] = ptr
    stx PLAYFIELD_SPRITE_PTRS_1+1
    // PLAYFIELD_SPRITE_PTRS_1[2] = ptr++
    stx PLAYFIELD_SPRITE_PTRS_1+2
    // PLAYFIELD_SPRITE_PTRS_1[2] = ptr++;
    inx
    txa
    // PLAYFIELD_SPRITE_PTRS_1[3] = ptr
    sta PLAYFIELD_SPRITE_PTRS_1+3
    jmp __b2
}
main: {
    // SID->CH3_FREQ = 0xffff
    lda #<$ffff
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH3_FREQ
    lda #>$ffff
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH3_FREQ+1
    // SID->CH3_CONTROL = SID_CONTROL_NOISE
    lda #SID_CONTROL_NOISE
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH3_CONTROL
    // asm
    sei
    // render_init()
    jsr render_init
    // sprites_init()
    jsr sprites_init
    // sprites_irq_init()
    jsr sprites_irq_init
    // play_init()
    jsr play_init
    // play_spawn_current()
  // Spawn twice to spawn both current & next
    lda #0
    sta.z game_over
    sta.z next_piece_idx
    jsr play_spawn_current
    // play_spawn_current()
    jsr play_spawn_current
    // render_playfield()
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
    // render_moving()
    lda #$20
    sta.z render_screen_render_1
    jsr render_moving
    ldy.z play_spawn_current.piece_idx
    // render_next()
    ldx #$20
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
    // while(*RASTER!=0xff)
    lda #$ff
    cmp RASTER
    bne __b2
    // render_show()
    //*BORDER_COLOR = render_screen_show/0x10;
    // Update D018 to show the selected screen
    jsr render_show
    // keyboard_event_scan()
  // Scan keyboard events
    jsr keyboard_event_scan
    // keyboard_event_get()
    jsr keyboard_event_get
    // key_event = keyboard_event_get()
    tax
    // if(game_over==0)
    lda.z game_over
    cmp #0
    beq __b4
  __b5:
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    jmp __b5
  __b4:
    // play_movement(key_event)
    stx.z play_movement.key_event
    jsr play_movement
    lda.z play_movement.return
    // render = play_movement(key_event)
    // if(render!=0)
    cmp #0
    beq __b1
    ldx.z render_screen_render
    // render_playfield()
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
    // render_moving()
    jsr render_moving
    ldx.z render_screen_render
    ldy.z next_piece_idx
    // render_next()
    jsr render_next
    // render_score()
    jsr render_score
    // render_screen_swap()
    jsr render_screen_swap
    jmp __b1
}
// Initialize rendering
render_init: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>PLAYFIELD_CHARSET)/$40
    // Initialize the screen line pointers;
    .label li_1 = $c
    .label li_2 = $36
    // CIA2->PORT_A_DDR = %00000011
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2
    // *D011 = VIC_ECM | VIC_DEN | VIC_RSEL | 3
    // Enable Extended Background Color Mode
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta D011
    // *BORDER_COLOR = BLACK
    lda #BLACK
    sta BORDER_COLOR
    // *BG_COLOR = BLACK
    sta BG_COLOR
    // *BG_COLOR1 = PIECES_COLORS_1[0]
    lda PIECES_COLORS_1
    sta BG_COLOR1
    // *BG_COLOR2 = PIECES_COLORS_2[0]
    lda PIECES_COLORS_2
    sta BG_COLOR2
    // *BG_COLOR3 = GREY
    lda #GREY
    sta BG_COLOR3
    // render_screen_original(PLAYFIELD_SCREEN_1)
  // Setup chars on the screens
    lda #<PLAYFIELD_SCREEN_1
    sta.z render_screen_original.screen
    lda #>PLAYFIELD_SCREEN_1
    sta.z render_screen_original.screen+1
    jsr render_screen_original
    // render_screen_original(PLAYFIELD_SCREEN_2)
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
    // screen_lines_1[i] = li_1
    tya
    asl
    tax
    lda.z li_1
    sta screen_lines_1,x
    lda.z li_1+1
    sta screen_lines_1+1,x
    // screen_lines_2[i] = li_2
    lda.z li_2
    sta screen_lines_2,x
    lda.z li_2+1
    sta screen_lines_2+1,x
    // li_1 += 40
    lda #$28
    clc
    adc.z li_1
    sta.z li_1
    bcc !+
    inc.z li_1+1
  !:
    // li_2 += 40
    lda #$28
    clc
    adc.z li_2
    sta.z li_2
    bcc !+
    inc.z li_2+1
  !:
    // for(char i:0..PLAYFIELD_LINES-1)
    iny
    cpy #PLAYFIELD_LINES-1+1
    bne __b1
    // }
    rts
}
// Setup the sprites
sprites_init: {
    .label xpos = $22
    // *SPRITES_ENABLE = %00001111
    lda #$f
    sta SPRITES_ENABLE
    // *SPRITES_MC = 0
    lda #0
    sta SPRITES_MC
    // *SPRITES_EXPAND_Y = *SPRITES_MC = 0
    sta SPRITES_EXPAND_Y
    // *SPRITES_EXPAND_X = *SPRITES_EXPAND_Y = *SPRITES_MC = 0
    sta SPRITES_EXPAND_X
    lda #$18+$f*8
    sta.z xpos
    ldy #0
  __b1:
    // s2 = s*2
    tya
    asl
    tax
    // SPRITES_XPOS[s2] = xpos
    lda.z xpos
    sta SPRITES_XPOS,x
    // SPRITES_COLOR[s] = BLACK
    lda #BLACK
    sta SPRITES_COLOR,y
    // xpos = xpos+24
    lax.z xpos
    axs #-[$18]
    stx.z xpos
    // for(char s:0..3)
    iny
    cpy #4
    bne __b1
    // }
    rts
}
// Setup the IRQ
sprites_irq_init: {
    // asm
    sei
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge any IRQ and setup the next one
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // asm
    lda CIA1_INTERRUPT
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *VIC_CONTROL &=0x7f
    // Set raster line
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = IRQ_RASTER_FIRST
    lda #IRQ_RASTER_FIRST
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *HARDWARE_IRQ = &sprites_irq
    // Set the IRQ routine
    lda #<sprites_irq
    sta HARDWARE_IRQ
    lda #>sprites_irq
    sta HARDWARE_IRQ+1
    // asm
    cli
    // }
    rts
}
// Initialize play data tables
play_init: {
    .label pli = $c
    // Initialize the playfield line pointers;
    .label idx = $22
    lda #0
    sta.z idx
    lda #<playfield
    sta.z pli
    lda #>playfield
    sta.z pli+1
    ldy #0
  __b1:
    // playfield_lines[j] = pli
    tya
    asl
    tax
    lda.z pli
    sta playfield_lines,x
    lda.z pli+1
    sta playfield_lines+1,x
    // playfield_lines_idx[j] = idx
    lda.z idx
    sta playfield_lines_idx,y
    // pli += PLAYFIELD_COLS
    lda #PLAYFIELD_COLS
    clc
    adc.z pli
    sta.z pli
    bcc !+
    inc.z pli+1
  !:
    // idx += PLAYFIELD_COLS
    lax.z idx
    axs #-[PLAYFIELD_COLS]
    stx.z idx
    // for(char j:0..PLAYFIELD_LINES-1)
    iny
    cpy #PLAYFIELD_LINES-1+1
    bne __b1
    // playfield_lines_idx[PLAYFIELD_LINES] = PLAYFIELD_COLS*PLAYFIELD_LINES
    lda #PLAYFIELD_COLS*PLAYFIELD_LINES
    sta playfield_lines_idx+PLAYFIELD_LINES
    // current_movedown_slow = MOVEDOWN_SLOW_SPEEDS[level]
    // Set initial speed of moving down a tetromino
    lda MOVEDOWN_SLOW_SPEEDS
    sta.z current_movedown_slow
    ldx #0
  // Set the initial score add values
  __b3:
    // score_add_bcd[b] = SCORE_BASE_BCD[b]
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
    // for(char b: 0..4)
    inx
    cpx #5
    bne __b3
    // }
    rts
}
// Spawn a new piece
// Moves the next piece into the current and spawns a new next piece
play_spawn_current: {
    .label __7 = $2f
    // Spawn a new next piece
    // Pick a random piece (0-6)
    .label piece_idx = $1f
    // current_piece_idx = next_piece_idx
    // Move next piece into current
    ldx.z next_piece_idx
    // current_piece = PIECES[current_piece_idx]
    txa
    asl
    sta.z __7
    // current_piece_char = PIECES_CHARS[current_piece_idx]
    lda PIECES_CHARS,x
    sta.z current_piece_char
    // current_xpos = PIECES_START_X[current_piece_idx]
    lda PIECES_START_X,x
    sta.z current_xpos
    // current_ypos = PIECES_START_Y[current_piece_idx]
    lda PIECES_START_Y,x
    sta.z current_ypos
    // play_collision(current_xpos,current_ypos,current_orientation)
    lda.z current_xpos
    sta.z play_collision.xpos
    lda.z current_ypos
    sta.z play_collision.ypos
    ldy.z __7
    lda PIECES,y
    sta.z current_piece_1
    lda PIECES+1,y
    sta.z current_piece_1+1
    // play_collision(current_xpos,current_ypos,current_orientation)
    ldx #0
    jsr play_collision
    // play_collision(current_xpos,current_ypos,current_orientation)
    // if(play_collision(current_xpos,current_ypos,current_orientation)==COLLISION_PLAYFIELD)
    cmp #COLLISION_PLAYFIELD
    bne __b1
    lda #1
    sta.z game_over
  __b1:
    lda #7
    sta.z piece_idx
  __b2:
    // while(piece_idx==7)
    lda #7
    cmp.z piece_idx
    beq sid_rnd1
    // }
    rts
  sid_rnd1:
    // return SID->CH3_OSC;
    lda SID+OFFSET_STRUCT_MOS6581_SID_CH3_OSC
    // piece_idx = sid_rnd()&7
    and #7
    sta.z piece_idx
    jmp __b2
}
// Render the static playfield on the screen (all pieces already locked into place)
render_playfield: {
    .label screen_line = $36
    // Do not render the top 2 lines.
    .label i = $b
    .label c = $23
    .label l = $22
    lda #PLAYFIELD_COLS*2
    sta.z i
    lda #2
    sta.z l
  __b1:
    // render_screen_render+l
    txa
    clc
    adc.z l
    // screen_line = screen_lines_1[render_screen_render+l]
    asl
    tay
    lda screen_lines_1,y
    sta.z screen_line
    lda screen_lines_1+1,y
    sta.z screen_line+1
    lda #0
    sta.z c
  __b2:
    // *(screen_line++) = playfield[i++]
    ldy.z i
    lda playfield,y
    ldy #0
    sta (screen_line),y
    // *(screen_line++) = playfield[i++];
    inc.z screen_line
    bne !+
    inc.z screen_line+1
  !:
    inc.z i
    // for(char c:0..PLAYFIELD_COLS-1)
    inc.z c
    lda #PLAYFIELD_COLS-1+1
    cmp.z c
    bne __b2
    // for(char l:2..PLAYFIELD_LINES-1)
    inc.z l
    lda #PLAYFIELD_LINES-1+1
    cmp.z l
    bne __b1
    // }
    rts
}
// Render the current moving piece at position (current_xpos, current_ypos)
// Ignores cases where parts of the tetromino is outside the playfield (sides/bottom) since the movement collision routine prevents this.
render_moving: {
    .label ypos = $22
    .label screen_line = $30
    .label xpos = $10
    .label i = $23
    .label l = $b
    // ypos = current_ypos
    stx.z ypos
    lda #0
    sta.z l
    sta.z i
  __b1:
    // if(ypos>1)
    lda.z ypos
    cmp #1+1
    bcs __b2
    // i += 4
    lax.z i
    axs #-[4]
    stx.z i
  __b3:
    // ypos++;
    inc.z ypos
    // for(char l:0..3)
    inc.z l
    lda #4
    cmp.z l
    bne __b1
    // }
    rts
  __b2:
    // render_screen_render+ypos
    lda.z render_screen_render_1
    clc
    adc.z ypos
    // screen_line = screen_lines_1[render_screen_render+ypos]
    asl
    tay
    lda screen_lines_1,y
    sta.z screen_line
    lda screen_lines_1+1,y
    sta.z screen_line+1
    // xpos = current_xpos
    lda.z current_xpos_1
    sta.z xpos
    ldx #0
  __b4:
    // current_cell = current_piece_gfx[i++]
    ldy.z i
    lda (current_piece_gfx_1),y
    inc.z i
    // if(current_cell!=0)
    cmp #0
    beq __b5
    // screen_line[xpos] = current_piece_char
    lda.z current_piece_char_1
    ldy.z xpos
    sta (screen_line),y
  __b5:
    // xpos++;
    inc.z xpos
    // for(char c:0..3)
    inx
    cpx #4
    bne __b4
    jmp __b3
}
// Render the next tetromino in the "next" area
render_next: {
    // Find the screen area
    .const next_area_offset = $28*$c+$18+4
    .label next_piece_char = $32
    .label next_piece_gfx = $c
    .label screen_next_area = $36
    .label l = $10
    // if(render_screen_render==0)
    cpx #0
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
    // next_piece_gfx = PIECES[next_piece_idx]
    tya
    asl
    tax
    // next_piece_char = PIECES_NEXT_CHARS[next_piece_idx]
    lda PIECES_NEXT_CHARS,y
    sta.z next_piece_char
    lda PIECES,x
    sta.z next_piece_gfx
    lda PIECES+1,x
    sta.z next_piece_gfx+1
    lda #0
    sta.z l
  __b3:
    ldx #0
  __b4:
    // cell = *next_piece_gfx++
    ldy #0
    lda (next_piece_gfx),y
    inc.z next_piece_gfx
    bne !+
    inc.z next_piece_gfx+1
  !:
    // if(cell!=0)
    cmp #0
    bne __b5
    // *screen_next_area = 0
    lda #0
    tay
    sta (screen_next_area),y
  __b6:
    // screen_next_area++;
    inc.z screen_next_area
    bne !+
    inc.z screen_next_area+1
  !:
    // for(char c:0..3)
    inx
    cpx #4
    bne __b4
    // screen_next_area += 36
    lda #$24
    clc
    adc.z screen_next_area
    sta.z screen_next_area
    bcc !+
    inc.z screen_next_area+1
  !:
    // for(char l:0..3)
    inc.z l
    lda #4
    cmp.z l
    bne __b3
    // }
    rts
  __b5:
    // *screen_next_area = next_piece_char
    lda.z next_piece_char
    ldy #0
    sta (screen_next_area),y
    jmp __b6
}
// Update 0xD018 to show the current screen (used for double buffering)
render_show: {
    .const toD0181_return = (>(PLAYFIELD_SCREEN_1&$3fff)*4)|(>PLAYFIELD_CHARSET)/4&$f
    .const toD0182_return = (>(PLAYFIELD_SCREEN_2&$3fff)*4)|(>PLAYFIELD_CHARSET)/4&$f
    // if(render_screen_show==0)
    lda.z render_screen_show
    cmp #0
    beq toD0181
    lda #toD0182_return
  __b1:
    // *D018 = d018val
    sta D018
    // *BG_COLOR1 = PIECES_COLORS_1[level]
    ldy.z level
    lda PIECES_COLORS_1,y
    sta BG_COLOR1
    // *BG_COLOR2 = PIECES_COLORS_2[level]
    lda PIECES_COLORS_2,y
    sta BG_COLOR2
    // render_screen_showing = render_screen_show
    lda.z render_screen_show
    sta.z render_screen_showing
    // }
    rts
  toD0181:
    lda #toD0181_return
    jmp __b1
}
// Scans the entire matrix to determine which keys have been pressed/depressed.
// Generates keyboard events into the event buffer. Events can be read using keyboard_event_get().
// Handles debounce and only generates events when the status of a key changes.
// Also stores current status of modifiers in keyboard_modifiers.
keyboard_event_scan: {
    .label row_scan = $33
    .label keycode = $23
    .label row = $b
    lda #0
    sta.z keycode
    sta.z row
  __b7:
    // keyboard_matrix_read(row)
    ldx.z row
    jsr keyboard_matrix_read
    // row_scan = keyboard_matrix_read(row)
    sta.z row_scan
    // if(row_scan!=keyboard_scan_values[row])
    ldy.z row
    cmp keyboard_scan_values,y
    bne __b5
    // keycode = keycode + 8
    lax.z keycode
    axs #-[8]
    stx.z keycode
  __b8:
    // for(char row : 0..7)
    inc.z row
    lda #8
    cmp.z row
    bne __b7
    // keyboard_event_pressed(KEY_LSHIFT)
    ldx #KEY_LSHIFT
    jsr keyboard_event_pressed
    // keyboard_event_pressed(KEY_LSHIFT)
    // if(keyboard_event_pressed(KEY_LSHIFT)!= 0)
    cmp #0
    // keyboard_event_pressed(KEY_RSHIFT)
    ldx #KEY_RSHIFT
    jsr keyboard_event_pressed
    // keyboard_event_pressed(KEY_RSHIFT)
    // if(keyboard_event_pressed(KEY_RSHIFT)!= 0)
    cmp #0
    // keyboard_event_pressed(KEY_CTRL)
    ldx #KEY_CTRL
    jsr keyboard_event_pressed
    // keyboard_event_pressed(KEY_CTRL)
    // if(keyboard_event_pressed(KEY_CTRL)!= 0)
    cmp #0
    // keyboard_event_pressed(KEY_COMMODORE)
    ldx #KEY_COMMODORE
    jsr keyboard_event_pressed
    // keyboard_event_pressed(KEY_COMMODORE)
    // if(keyboard_event_pressed(KEY_COMMODORE)!= 0)
    cmp #0
    // }
    rts
  // Something has changed on the keyboard row - check each column
  __b5:
    ldx #0
  __b9:
    // row_scan^keyboard_scan_values[row]
    lda.z row_scan
    ldy.z row
    eor keyboard_scan_values,y
    // (row_scan^keyboard_scan_values[row])&keyboard_matrix_col_bitmask[col]
    and keyboard_matrix_col_bitmask,x
    // if(((row_scan^keyboard_scan_values[row])&keyboard_matrix_col_bitmask[col])!=0)
    cmp #0
    beq __b10
    // if(keyboard_events_size!=8)
    lda #8
    cmp.z keyboard_events_size
    beq __b10
    // event_type = row_scan&keyboard_matrix_col_bitmask[col]
    lda keyboard_matrix_col_bitmask,x
    and.z row_scan
    // if(event_type==0)
    cmp #0
    beq __b11
    // keyboard_events[keyboard_events_size++] = keycode
    // Key pressed
    lda.z keycode
    ldy.z keyboard_events_size
    sta keyboard_events,y
    // keyboard_events[keyboard_events_size++] = keycode;
    inc.z keyboard_events_size
  __b10:
    // keycode++;
    inc.z keycode
    // for(char col : 0..7)
    inx
    cpx #8
    bne __b9
    // keyboard_scan_values[row] = row_scan
    // Store the current keyboard status for the row to debounce
    lda.z row_scan
    ldy.z row
    sta keyboard_scan_values,y
    jmp __b8
  __b11:
    // keycode|$40
    lda #$40
    ora.z keycode
    // keyboard_events[keyboard_events_size++] = keycode|$40
    // Key released
    ldy.z keyboard_events_size
    sta keyboard_events,y
    // keyboard_events[keyboard_events_size++] = keycode|$40;
    inc.z keyboard_events_size
    jmp __b10
}
// Get the next event from the keyboard event buffer.
// Returns $ff if there is no event waiting. As all events are <$7f it is enough to examine bit 7 when determining if there is any event to process.
// The buffer is filled by keyboard_event_scan()
keyboard_event_get: {
    // if(keyboard_events_size==0)
    lda.z keyboard_events_size
    cmp #0
    beq __b1
    // return keyboard_events[--keyboard_events_size];
    dec.z keyboard_events_size
    ldy.z keyboard_events_size
    lda keyboard_events,y
    rts
  __b1:
    lda #$ff
    // }
    rts
}
// Perform any movement of the current piece
// key_event is the next keyboard_event() og 0xff if no keyboard event is pending
// Returns a byte signaling whether rendering is needed. (0 no render, >0 render needed)
// play_movement(byte zp($2e) key_event)
play_movement: {
    .label render = $b
    .label return = $b
    .label key_event = $2e
    // play_move_down(key_event)
    lda.z key_event
    jsr play_move_down
    txa
    // render += play_move_down(key_event)
    sta.z render
    // if(game_over!=0)
    lda.z game_over
    cmp #0
    beq __b1
    // }
    rts
  __b1:
    // play_move_leftright(key_event)
    lda.z key_event
    jsr play_move_leftright
    // render += play_move_leftright(key_event)
    clc
    adc.z render
    sta.z render
    // play_move_rotate(key_event)
    lda.z key_event
    jsr play_move_rotate
    // render += play_move_rotate(key_event)
    clc
    adc.z return
    sta.z return
    rts
}
// Show the current score
render_score: {
    .const score_offset = $28*5+$1c
    .const lines_offset = $28*1+$16
    .const level_offset = $28*$13+$1f
    .label score_bytes = score_bcd
    .label screen = $c
    // if(render_screen_render==0)
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
    // render_bcd( screen, score_offset, score_bytes[2], 0)
    ldx score_bytes+2
    ldy #0
    lda #<score_offset
    sta.z render_bcd.offset
    lda #>score_offset
    sta.z render_bcd.offset+1
    jsr render_bcd
    // render_bcd( screen, score_offset+2, score_bytes[1], 0)
    ldx score_bytes+1
    ldy #0
    lda #<score_offset+2
    sta.z render_bcd.offset
    lda #>score_offset+2
    sta.z render_bcd.offset+1
    jsr render_bcd
    // render_bcd( screen, score_offset+4, score_bytes[0], 0)
    ldx.z score_bytes
    ldy #0
    lda #<score_offset+4
    sta.z render_bcd.offset
    lda #>score_offset+4
    sta.z render_bcd.offset+1
    jsr render_bcd
    // render_bcd( screen, lines_offset, >lines_bcd, 1)
    ldx.z lines_bcd+1
    ldy #1
    lda #<lines_offset
    sta.z render_bcd.offset
    lda #>lines_offset
    sta.z render_bcd.offset+1
    jsr render_bcd
    // render_bcd( screen, lines_offset+1, <lines_bcd, 0)
    ldx.z lines_bcd
    ldy #0
    lda #<lines_offset+1
    sta.z render_bcd.offset
    lda #>lines_offset+1
    sta.z render_bcd.offset+1
    jsr render_bcd
    // render_bcd( screen, level_offset, level_bcd, 0)
    ldx.z level_bcd
    ldy #0
    lda #<level_offset
    sta.z render_bcd.offset
    lda #>level_offset
    sta.z render_bcd.offset+1
    jsr render_bcd
    // }
    rts
}
// Swap rendering to the other screen (used for double buffering)
render_screen_swap: {
    // render_screen_render ^= 0x20
    lda #$20
    eor.z render_screen_render
    sta.z render_screen_render
    // render_screen_show ^= 0x20
    lda #$20
    eor.z render_screen_show
    sta.z render_screen_show
    // }
    rts
}
// Copy the original screen data to the passed screen
// Also copies colors to 0xd800
// render_screen_original(byte* zp($30) screen)
render_screen_original: {
    .const SPACE = 0
    .label screen = $30
    .label cols = $34
    .label oscr = $36
    .label ocols = $20
    .label y = $23
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
    // *screen++ = SPACE
    lda #SPACE
    ldy #0
    sta (screen),y
    // *screen++ = SPACE;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *cols++ = BLACK
    lda #BLACK
    ldy #0
    sta (cols),y
    // *cols++ = BLACK;
    inc.z cols
    bne !+
    inc.z cols+1
  !:
    // while(++x!=4)
    inx
    cpx #4
    bne __b2
  __b3:
    // *screen++ = *oscr++
    ldy #0
    lda (oscr),y
    sta (screen),y
    // *screen++ = *oscr++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z oscr
    bne !+
    inc.z oscr+1
  !:
    // *cols++ = *ocols++
    ldy #0
    lda (ocols),y
    sta (cols),y
    // *cols++ = *ocols++;
    inc.z cols
    bne !+
    inc.z cols+1
  !:
    inc.z ocols
    bne !+
    inc.z ocols+1
  !:
    // while(++x!=36)
    inx
    cpx #$24
    bne __b3
  __b4:
    // *screen++ = SPACE
    lda #SPACE
    ldy #0
    sta (screen),y
    // *screen++ = SPACE;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *cols++ = BLACK
    lda #BLACK
    ldy #0
    sta (cols),y
    // *cols++ = BLACK;
    inc.z cols
    bne !+
    inc.z cols+1
  !:
    // while(++x!=40)
    inx
    cpx #$28
    bne __b4
    // for(char y:0..24)
    inc.z y
    lda #$19
    cmp.z y
    bne __b1
    // }
    rts
}
// Test if there is a collision between the current piece moved to (x, y) and anything on the playfield or the playfield boundaries
// Returns information about the type of the collision detected
// play_collision(byte zp($10) xpos, byte zp($32) ypos, byte register(X) orientation)
play_collision: {
    .label xpos = $10
    .label ypos = $32
    .label piece_gfx = $34
    .label yp = $32
    .label playfield_line = $36
    .label i = $38
    .label xp = $22
    .label l = $33
    .label i_1 = $39
    // piece_gfx = current_piece + orientation
    txa
    clc
    adc.z current_piece_1
    sta.z piece_gfx
    lda #0
    adc.z current_piece_1+1
    sta.z piece_gfx+1
    lda #0
    sta.z l
    sta.z i_1
  __b1:
    // playfield_line = playfield_lines[yp]
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
    // if(piece_gfx[i++]!=0)
    ldy.z i_1
    iny
    sty.z i
    ldy.z i_1
    lda (piece_gfx),y
    cmp #0
    beq __b3
    // if(yp>=PLAYFIELD_LINES)
    lda.z yp
    cmp #PLAYFIELD_LINES
    bcc __b4
    lda #COLLISION_BOTTOM
    rts
  __b4:
    // xp&0x80
    lda #$80
    and.z xp
    // if((xp&0x80)!=0)
    cmp #0
    beq __b5
    lda #COLLISION_LEFT
    rts
  __b5:
    // if(xp>=PLAYFIELD_COLS)
    lda.z xp
    cmp #PLAYFIELD_COLS
    bcc __b6
    lda #COLLISION_RIGHT
    rts
  __b6:
    // if(playfield_line[xp]!=0)
    ldy.z xp
    lda (playfield_line),y
    cmp #0
    beq __b3
    lda #COLLISION_PLAYFIELD
    // }
    rts
  __b3:
    // xp++;
    inc.z xp
    // for(char c:0..3)
    inx
    cpx #4
    bne __b10
    // yp++;
    inc.z yp
    // for(char l:0..3)
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
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable the normal interrupt or sei/cli around calls to the keyboard matrix reader.
// keyboard_matrix_read(byte register(X) rowid)
keyboard_matrix_read: {
    // CIA1->PORT_A = keyboard_matrix_row_bitmask[rowid]
    lda keyboard_matrix_row_bitmask,x
    sta CIA1
    // ~CIA1->PORT_B
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    eor #$ff
    // }
    rts
}
// Determine if a specific key is currently pressed based on the last keyboard_event_scan()
// Returns 0 is not pressed and non-0 if pressed
// keyboard_event_pressed(byte register(X) keycode)
keyboard_event_pressed: {
    // keycode>>3
    txa
    lsr
    lsr
    lsr
    tay
    // row_bits = keyboard_scan_values[keycode>>3]
    lda keyboard_scan_values,y
    tay
    // keycode&7
    lda #7
    axs #0
    // row_bits & keyboard_matrix_col_bitmask[keycode&7]
    tya
    and keyboard_matrix_col_bitmask,x
    // }
    rts
}
// Move down the current piece
// Return non-zero if a render is needed
// play_move_down(byte register(A) key_event)
play_move_down: {
    .label movedown = $10
    // ++current_movedown_counter;
    inc.z current_movedown_counter
    // if(key_event==KEY_SPACE)
    cmp #KEY_SPACE
    bne __b4
    lda #1
    sta.z movedown
    jmp __b1
  __b4:
    lda #0
    sta.z movedown
  __b1:
    // keyboard_event_pressed(KEY_SPACE)
    ldx #KEY_SPACE
    jsr keyboard_event_pressed
    // keyboard_event_pressed(KEY_SPACE)
    // if(keyboard_event_pressed(KEY_SPACE)!=0)
    cmp #0
    beq __b2
    // if(current_movedown_counter>=current_movedown_fast)
    lda.z current_movedown_counter
    cmp #current_movedown_fast
    bcc __b2
    // movedown++;
    inc.z movedown
  __b2:
    // if(current_movedown_counter>=current_movedown_slow)
    lda.z current_movedown_counter
    cmp.z current_movedown_slow
    bcc __b3
    // movedown++;
    inc.z movedown
  __b3:
    // if(movedown!=0)
    lda.z movedown
    cmp #0
    beq __b5
    // play_collision(current_xpos,current_ypos+1,current_orientation)
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
    // play_collision(current_xpos,current_ypos+1,current_orientation)
    jsr play_collision
    // play_collision(current_xpos,current_ypos+1,current_orientation)
    // if(play_collision(current_xpos,current_ypos+1,current_orientation)==COLLISION_NONE)
    cmp #COLLISION_NONE
    beq __b10
    // play_lock_current()
    // Lock current piece
    jsr play_lock_current
    // play_remove_lines()
    jsr play_remove_lines
    // play_remove_lines()
    lda.z play_remove_lines.removed
    // removed = play_remove_lines()
    // play_update_score(removed)
    tax
    // Tally up the score
    jsr play_update_score
    // play_spawn_current()
  // Spawn a new piece
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
  __b5:
    ldx #0
    // }
    rts
  __b10:
    // current_ypos++;
    inc.z current_ypos
    jmp __b11
}
// Move left/right or rotate the current piece
// Return non-zero if a render is needed
// play_move_leftright(byte register(A) key_event)
play_move_leftright: {
    // if(key_event==KEY_COMMA)
    // Handle keyboard events
    cmp #KEY_COMMA
    beq __b1
    // if(key_event==KEY_DOT)
    cmp #KEY_DOT
    bne __b3
    // play_collision(current_xpos+1,current_ypos,current_orientation)
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
    // play_collision(current_xpos+1,current_ypos,current_orientation)
    jsr play_collision
    // play_collision(current_xpos+1,current_ypos,current_orientation)
    // if(play_collision(current_xpos+1,current_ypos,current_orientation)==COLLISION_NONE)
    cmp #COLLISION_NONE
    bne __b3
    // current_xpos++;
    inc.z current_xpos
  __b2:
    lda #1
    rts
  __b3:
    lda #0
    // }
    rts
  __b1:
    // play_collision(current_xpos-1,current_ypos,current_orientation)
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
    // play_collision(current_xpos-1,current_ypos,current_orientation)
    jsr play_collision
    // play_collision(current_xpos-1,current_ypos,current_orientation)
    // if(play_collision(current_xpos-1,current_ypos,current_orientation)==COLLISION_NONE)
    cmp #COLLISION_NONE
    bne __b3
    // current_xpos--;
    dec.z current_xpos
    jmp __b2
}
// Rotate the current piece  based on key-presses
// Return non-zero if a render is needed
// play_move_rotate(byte register(A) key_event)
play_move_rotate: {
    // Handle keyboard events
    .label orientation = $23
    // if(key_event==KEY_Z)
    cmp #KEY_Z
    beq __b1
    // if(key_event==KEY_X)
    cmp #KEY_X
    beq __b2
  __b4:
    lda #0
    // }
    rts
  __b2:
    // current_orientation+0x10
    lax.z current_orientation
    axs #-[$10]
    // orientation = (current_orientation+0x10)&0x3f
    lda #$3f
    sax.z orientation
  __b3:
    // play_collision(current_xpos, current_ypos, orientation)
    lda.z current_xpos
    sta.z play_collision.xpos
    lda.z current_ypos
    sta.z play_collision.ypos
    ldx.z orientation
    lda.z current_piece
    sta.z current_piece_1
    lda.z current_piece+1
    sta.z current_piece_1+1
    // play_collision(current_xpos, current_ypos, orientation)
    jsr play_collision
    // play_collision(current_xpos, current_ypos, orientation)
    // if(play_collision(current_xpos, current_ypos, orientation) == COLLISION_NONE)
    cmp #COLLISION_NONE
    bne __b4
    // current_orientation = orientation
    lda.z orientation
    sta.z current_orientation
    // current_piece_gfx = current_piece + current_orientation
    clc
    adc.z current_piece
    sta.z current_piece_gfx
    lda #0
    adc.z current_piece+1
    sta.z current_piece_gfx+1
    lda #1
    rts
  __b1:
    // current_orientation-0x10
    lda.z current_orientation
    sec
    sbc #$10
    // orientation = (current_orientation-0x10)&0x3f
    and #$3f
    sta.z orientation
    jmp __b3
}
// Render BCD digits on a screen.
// - screen: pointer to the screen to render on
// - offset: offset on the screen
// - bcd: The BCD-value to render
// - only_low: if non-zero only renders the low digit
// render_bcd(byte* zp($c) screen, word zp($20) offset, byte register(X) bcd, byte register(Y) only_low)
render_bcd: {
    .const ZERO_CHAR = $35
    .label screen = $c
    .label screen_pos = $20
    .label offset = $20
    // screen_pos = screen+offset
    lda.z screen_pos
    clc
    adc.z screen
    sta.z screen_pos
    lda.z screen_pos+1
    adc.z screen+1
    sta.z screen_pos+1
    // if(only_low==0)
    cpy #0
    bne __b1
    // bcd >> 4
    txa
    lsr
    lsr
    lsr
    lsr
    // ZERO_CHAR + (bcd >> 4)
    clc
    adc #ZERO_CHAR
    // *screen_pos++ = ZERO_CHAR + (bcd >> 4)
    ldy #0
    sta (screen_pos),y
    // *screen_pos++ = ZERO_CHAR + (bcd >> 4);
    inc.z screen_pos
    bne !+
    inc.z screen_pos+1
  !:
  __b1:
    // bcd & 0x0f
    txa
    and #$f
    // ZERO_CHAR + (bcd & 0x0f)
    clc
    adc #ZERO_CHAR
    // *screen_pos++ = ZERO_CHAR + (bcd & 0x0f)
    ldy #0
    sta (screen_pos),y
    // }
    rts
}
// Lock the current piece onto the playfield
play_lock_current: {
    .label yp = $32
    .label playfield_line = $36
    .label xp = $22
    .label i = $38
    .label l = $33
    .label i_1 = $39
    // yp = current_ypos
    lda.z current_ypos
    sta.z yp
    lda #0
    sta.z l
    sta.z i_1
  __b1:
    // playfield_line = playfield_lines[yp]
    lda.z yp
    asl
    tay
    lda playfield_lines,y
    sta.z playfield_line
    lda playfield_lines+1,y
    sta.z playfield_line+1
    // xp = current_xpos
    lda.z current_xpos
    sta.z xp
    ldx #0
  __b2:
    // if(current_piece_gfx[i++]!=0)
    ldy.z i_1
    iny
    sty.z i
    ldy.z i_1
    lda (current_piece_gfx),y
    cmp #0
    beq __b3
    // playfield_line[xp] = current_piece_char
    lda.z current_piece_char
    ldy.z xp
    sta (playfield_line),y
  __b3:
    // xp++;
    inc.z xp
    // for(char c:0..3)
    inx
    cpx #4
    bne __b7
    // yp++;
    inc.z yp
    // for(char l:0..3)
    inc.z l
    lda #4
    cmp.z l
    bne __b6
    // }
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
// Look through the playfield for lines - and remove any lines found
// Utilizes two cursors on the playfield - one reading cells and one writing cells
// Whenever a full line is detected the writing cursor is instructed to write to the same line once more.
// Returns the number of lines removed
play_remove_lines: {
    .label c = $39
    .label x = $32
    .label y = $23
    .label removed = $2f
    .label full = $33
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
    // c = playfield[r--]
    lda playfield,y
    sta.z c
    dey
    // if(c==0)
    cmp #0
    bne __b3
    lda #0
    sta.z full
  __b3:
    // playfield[w--] = c
    lda.z c
    sta playfield,x
    // playfield[w--] = c;
    dex
    // for(char x:0..PLAYFIELD_COLS-1)
    inc.z x
    lda #PLAYFIELD_COLS-1+1
    cmp.z x
    bne __b2
    // if(full==1)
    lda #1
    cmp.z full
    bne __b6
    // w = w + PLAYFIELD_COLS
    txa
    axs #-[PLAYFIELD_COLS]
    // removed++;
    inc.z removed
  __b6:
    // for(char y:0..PLAYFIELD_LINES-1)
    inc.z y
    lda #PLAYFIELD_LINES-1+1
    cmp.z y
    bne __b1
  __b4:
  // Write zeros in the rest of the lines
    // while(w!=0xff)
    cpx #$ff
    bne __b8
    // }
    rts
  __b8:
    // playfield[w--] = 0
    lda #0
    sta playfield,x
    // playfield[w--] = 0;
    dex
    jmp __b4
}
// Update the score based on the number of lines removed
// play_update_score(byte register(X) removed)
play_update_score: {
    .label lines_before = $39
    .label add_bcd = $3a
    // if(removed!=0)
    cpx #0
    beq __breturn
    // <lines_bcd
    lda.z lines_bcd
    // lines_before = <lines_bcd&0xf0
    and #$f0
    sta.z lines_before
    // add_bcd = score_add_bcd[removed]
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
    // asm
    sed
    // lines_bcd += removed
    txa
    clc
    adc.z lines_bcd
    sta.z lines_bcd
    bcc !+
    inc.z lines_bcd+1
  !:
    // score_bcd += add_bcd
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
    // asm
    cld
    // <lines_bcd
    lda.z lines_bcd
    // lines_after = <lines_bcd&0xf0
    and #$f0
    // if(lines_before!=lines_after)
    cmp.z lines_before
    beq __breturn
    // play_increase_level()
    jsr play_increase_level
  __breturn:
    // }
    rts
}
// Increase the level
play_increase_level: {
    // level++;
    inc.z level
    // if(level>29)
    // Update speed of moving tetrominos down
    lda.z level
    cmp #$1d+1
    bcs __b3
    // current_movedown_slow = MOVEDOWN_SLOW_SPEEDS[level]
    tay
    lda MOVEDOWN_SLOW_SPEEDS,y
    sta.z current_movedown_slow
    jmp __b1
  __b3:
    lda #1
    sta.z current_movedown_slow
  __b1:
    // level_bcd++;
    inc.z level_bcd
    // level_bcd&0xf
    lda #$f
    and.z level_bcd
    // if((level_bcd&0xf)==0xa)
    cmp #$a
    bne __b2
    // level_bcd += 6
    // If level low nybble hits 0xa change to 0x10
    lax.z level_bcd
    axs #-[6]
    stx.z level_bcd
  __b2:
    // asm
    // Increase the score values gained
    sed
    ldx #0
  __b5:
    // score_add_bcd[b] += SCORE_BASE_BCD[b]
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
    // for(char b: 0..4)
    inx
    cpx #5
    bne __b5
    // asm
    cld
    // }
    rts
}
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  // Keyboard event buffer. Contains keycodes for key presses/releases. Presses are represented by the keycode. Releases by keycode | $40. The buffer is filled by keyboard_scan()
  keyboard_events: .fill 8, 0
  // The values scanned values for each row. Set by keyboard_scan() and used by keyboard_get_event()
  keyboard_scan_values: .fill 8, 0
  // The playfield.  0 is empty non-zero is color.
  // The playfield is layed out line by line, meaning the first 10 bytes are line 1, the next 10 line 2 and so forth,
  playfield: .fill PLAYFIELD_LINES*PLAYFIELD_COLS, 0
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
PLAYFIELD_SCREEN_ORIGINAL:
// Load chars for the screen
  .var screen = LoadBinary("playfield-screen.iscr")
   // Load extended colors for the screen
  .var extended = LoadBinary("playfield-extended.col")
  // screen.get(i)+1 because the charset is loaded into PLAYFIELD_CHARSET+8
  // extended.get(i)-1 because the extended colors are 1-based (1/2/3/4)
  // <<6 to move extended colors to the upper 2 bits
  .fill screen.getSize(), ( (screen.get(i)+1) | (extended.get(i)-1)<<6 )

  // Original Color Data
PLAYFIELD_COLORS_ORIGINAL:
.import binary "playfield-screen.col"

  // The color #1 to use for the pieces for each level
  PIECES_COLORS_1: .byte BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED, BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED, BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED
  // The color #2 to use for the pieces for each level
  PIECES_COLORS_2: .byte CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE, CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE, CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE
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
  // The speed of moving down the piece when soft-drop is not activated
  // This array holds the number of frames per move by level (0-29). For all levels 29+ the value is 1.
  MOVEDOWN_SLOW_SPEEDS: .byte $30, $2b, $26, $21, $1c, $17, $12, $d, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1
  // Base Score values for removing 0-4 lines (in BCD)
  // These values are added to score_add_bcd for each level gained.
  SCORE_BASE_BCD: .dword 0, $40, $100, $300, $1200
  // Score values for removing 0-4 lines (in BCD)
  // These values are updated based on the players level and the base values from SCORE_BASE_BCD
  score_add_bcd: .fill 4*5, 0
.pc = $3000 "PLAYFIELD_SPRITES"
// Sprites covering the playfield
PLAYFIELD_SPRITES:
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

.pc = $2800 "PLAYFIELD_CHARSET"
// Address of the charset
PLAYFIELD_CHARSET:
.fill 8,$00 // Place a filled char at the start of the charset
    .import binary "playfield-screen.imap"

