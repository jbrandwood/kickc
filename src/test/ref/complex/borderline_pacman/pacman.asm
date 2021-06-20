// Camelot Borderline Entry
// Pacman made with 9 sprites in in the borders
  // Commodore 64 PRG executable file
.plugin "se.triad.kickass.CruncherPlugins"
.file [name="pacman.prg", type="prg", segments="Program", modify="B2exe", _jmpAdress=__start]
.segmentdef Program [segments="Code, Data, Init"]
.segmentdef Code [start=$810]
.segmentdef Data [startAfter="Code"]
.segmentdef Init [startAfter="Data"]
  /// Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  /// The offset of the sprite pointers from the screen start address
  .const OFFSET_SPRITE_PTRS = $3f8
  /// $D011 Control Register #1 Bit#7: RST8 9th Bit for $D012 Rasterline counter
  .const VICII_RST8 = $80
  /// $D011 Control Register #1 Bit#6: ECM Turn Extended Color Mode on/off
  .const VICII_ECM = $40
  /// $D011 Control Register #1  Bit#5: BMM Turn Bitmap Mode on/off
  .const VICII_BMM = $20
  /// $D011 Control Register #1  Bit#4: DEN Switch VIC-II output on/off
  .const VICII_DEN = $10
  /// $D011 Control Register #1  Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  .const VICII_RSEL = 8
  /// VICII IRQ Status/Enable Raster
  // @see #IRQ_ENABLE #IRQ_STATUS
  ///  0 | RST| Reaching a certain raster line. The line is specified by writing
  ///    |    | to register 0xd012 and bit 7 of $d011 and internally stored by
  ///    |    | the VIC for the raster compare. The test for reaching the
  ///    |    | interrupt raster line is done in cycle 0 of every line (for line
  ///    |    | 0, in cycle 1).
  .const IRQ_RASTER = 1
  /// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  /// RAM in all three areas 0xA000, 0xD000, 0xE000
  .const PROCPORT_RAM_ALL = 0
  /// RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  /// The colors of the C64
  .const BLACK = 0
  .const RED = 2
  .const BLUE = 6
  .const YELLOW = 7
  .const EMPTY = 0
  .const PILL = 1
  .const POWERUP = 2
  .const WALL = 4
  // Address of the (decrunched) splash screen
  .const BOB_ROW_SIZE = $80
  .const RENDER_OFFSET_CANVAS_LO = 0
  .const RENDER_OFFSET_CANVAS_HI = $50
  .const RENDER_OFFSET_YPOS_INC = $a0
  // The number of bobs rendered
  .const NUM_BOBS = 5
  // The size of the BOB restore structure
  .const SIZE_BOB_RESTORE = $12
  // Size of the crunched music
  .const INTRO_MUSIC_CRUNCHED_SIZE = $600
  // The raster line for irq_screen_top()
  .const IRQ_SCREEN_TOP_LINE = 5
  .const STOP = 0
  .const UP = 4
  .const DOWN = 8
  .const LEFT = $10
  .const RIGHT = $20
  .const CHASE = 0
  .const SCATTER = 1
  .const FRIGHTENED = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6581_SID_VOLUME_FILTER_MODE = $18
  .const OFFSET_STRUCT_MOS6581_SID_CH1_PULSE_WIDTH = 2
  .const OFFSET_STRUCT_MOS6581_SID_CH1_CONTROL = 4
  .const OFFSET_STRUCT_MOS6581_SID_CH1_ATTACK_DECAY = 5
  .const OFFSET_STRUCT_MOS6581_SID_CH1_SUSTAIN_RELEASE = 6
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6569_VICII_MEMORY = $18
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_XMSB = $10
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE = $15
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_EXPAND_X = $1d
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR1 = $25
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR2 = $26
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_MC = $1c
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL2 = $16
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL1 = $11
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE = $1a
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE0_Y = 1
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE1_Y = 3
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE2_Y = 5
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE3_Y = 7
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE4_Y = 9
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE5_Y = $b
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE6_Y = $d
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE7_Y = $f
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE0_COLOR = $27
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE1_COLOR = $28
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS = $19
  .const SIZEOF_BYTE = 1
  /// Sprite X position register for sprite #0
  .label SPRITES_XPOS = $d000
  /// Sprite Y position register for sprite #0
  .label SPRITES_YPOS = $d001
  /// Sprite colors register for sprite #0
  .label SPRITES_COLOR = $d027
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
  /// $D020 Border Color
  .label BORDER_COLOR = $d020
  /// $D011 Control Register #1
  /// - Bit#0-#2: YSCROLL Screen Soft Scroll Vertical
  /// - Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  /// - Bit#4: DEN Switch VIC-II output on/off
  /// - Bit#5: BMM Turn Bitmap Mode on/off
  /// - Bit#6: ECM Turn Extended Color Mode on/off
  /// - Bit#7: RST8 9th Bit for $D012 Rasterline counter
  /// Initial Value: %10011011
  .label VICII_CONTROL1 = $d011
  /// $D016 Control register 2
  /// -  Bit#0-#2: XSCROLL Screen Soft Scroll Horizontal
  /// -  Bit#3: CSEL Switch betweem 40 or 38 visible columns
  ///           CSEL|   Display window width   | First X coo. | Last X coo.
  ///           ----+--------------------------+--------------+------------
  ///             0 | 38 characters/304 pixels |   31 ($1f)   |  334 ($14e)
  ///             1 | 40 characters/320 pixels |   24 ($18)   |  343 ($157)
  /// -  Bit#4: MCM Turn Multicolor Mode on/off
  /// -  Bit#5-#7: not used
  /// Initial Value: %00001000
  .label VICII_CONTROL2 = $d016
  /// $D018 VIC-II base addresses
  /// - Bit#0: not used
  /// - Bit#1-#3: CB Address Bits 11-13 of the Character Set (*2048)
  /// - Bit#4-#7: VM Address Bits 10-13 of the Screen RAM (*1024)
  /// Initial Value: %00010100
  .label VICII_MEMORY = $d018
  /// VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  /// Channel 1 Frequency High byte
  .label SID_CH1_FREQ_HI = $d401
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The SID MOS 6581/8580
  .label SID = $d400
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  /// The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  /// CIA#1 Interrupt for reading in ASM
  .label CIA1_INTERRUPT = $dc0d
  /// The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  // Graphics Bank 1
  // Address of the sprites
  .label BANK_1 = $4000
  // Address of the sprites
  .label SPRITES_1 = $6000
  // Use sprite pointers on all screens (0x43f8, 0x47f8, ...)
  .label SCREENS_1 = $4000
  // Graphics Bank 2
  // Address of the sprites
  .label BANK_2 = $c000
  // Address of the sprites
  .label SPRITES_2 = $e000
  // Use sprite pointers on all screens (0x43f8, 0x47f8, ...)
  .label SCREENS_2 = $c000
  // The location where the logic code will be located before merging
  .label LOGIC_CODE_UNMERGED = $e000
  // The location where the screen raster code will be located before merging
  .label RASTER_CODE_UNMERGED = $6000
  // The location where the screen raster code will be located when running
  .label RASTER_CODE = $8000
  // Address of the (decrunched) splash screen
  .label SPLASH = $4000
  // Address for the victory graphics
  .label WIN_GFX = $a700
  // Address for the gameover graphics
  .label GAMEOVER_GFX = $a700
  // Address used by (decrunched) tiles
  .label LEVEL_TILES = $4800
  .label TILES_LEFT = LEVEL_TILES+$a00
  .label TILES_RIGHT = LEVEL_TILES+$a80
  .label TILES_TYPE = LEVEL_TILES+$b00
  // Address used for table containing available directions for all tiles
  // TABLE LEVEL_TILES_DIRECTIONS[64*37]
  // The level data is organized as 37 rows of 64 bytes. Each row is 50 bytes containing DIRECTION bits plus 14 unused bytes to achieve 64-byte alignment.
  .label LEVEL_TILES_DIRECTIONS = $3e00
  .label BOB_MASK_LEFT = $5400
  .label BOB_MASK_RIGT = BOB_MASK_LEFT+BOB_ROW_SIZE*6
  .label BOB_PIXEL_LEFT = BOB_MASK_LEFT+BOB_ROW_SIZE*$c
  .label BOB_PIXEL_RIGT = BOB_MASK_LEFT+BOB_ROW_SIZE*$12
  // Tables pointing to the graphics.
  // Each page represents one X column (1 byte wide, 4 MC pixels)
  // On each page:
  // - 0xNN00-0xNN4A : low-byte of the graphics for (X-column, Y-fine)
  // - 0xNN50-0xNN9A : high-byte of the graphics for (X-column, Y-fine)
  // - 0xNNA0-0xNNEA : index into RENDER_YPOS_INC for incrementing the y-pos.
  .label RENDER_INDEX = $b600
  // Upper memory location used during decrunching
  .label INTRO_MUSIC_CRUNCHED_UPPER = $a700
  // Address of the music during run-time
  .label INTRO_MUSIC = $3000
  // Pointer to the music init routine
  .label musicInit = INTRO_MUSIC
  // Pointer to the music play routine
  .label musicPlay = INTRO_MUSIC+6
  // Is the pacman eating sound enabled
  .label pacman_ch1_enabled = $d
  // Index into the eating sound
  .label pacman_ch1_idx = $e
  // Pointer to the tile to render in the logic code
  .label logic_tile_ptr = $f
  // The x-column of the tile to render
  .label logic_tile_xcol = $11
  // The y-fine of the tile to render
  .label logic_tile_yfine = $12
  // The ID*4 of the left tile to render
  .label logic_tile_left_idx = $13
  // The ID*4 of the right tile to render
  .label logic_tile_right_idx = $14
  // Variables used by the logic-code renderer and restorer
  .label left_render_index_xcol = $15
  .label left_canvas = $17
  .label left_ypos_inc_offset = $19
  .label rigt_render_index_xcol = $1a
  .label rigt_canvas = $1c
  .label rigt_ypos_inc_offset = $1e
  // The high-byte of the start-address of the canvas currently being rendered to
  .label canvas_base_hi = $1f
  // The offset used for bobs_restore - used to achieve double buffering
  .label bobs_restore_base = $20
  // Sprite settings used for the top/side/bottom sprites. 
  // Used for achieving single-color sprites on the splash and multi-color sprites in the game
  .label top_sprites_color = $21
  .label top_sprites_mc = $22
  .label side_sprites_color = $23
  .label side_sprites_mc = $24
  .label bottom_sprites_color = $25
  .label bottom_sprites_mc = $26
  // The number of pills left
  .label pill_count = $27
  // 1 When pacman wins
  .label pacman_wins = $29
  // The number of pacman lives left
  .label pacman_lives = $2a
  // Signal for playing th next music frame during the intro
  .label music_play_next = $2b
  // 0: intro, 1: game
  .label phase = $2c
  // The double buffer frame (0=BANK_1, 1=BANK_2)
  .label frame = $2d
  // The animation frame IDX (within the current direction) [0-3] 
  .label anim_frame_idx = $2e
  // Pacman x fine position (0-99). 
  .label pacman_xfine = $2f
  // Pacman y fine position (0-70). 
  .label pacman_yfine = $30
  // The pacman movement current direction 
  .label pacman_direction = $31
  // Pacman movement substep (0: on tile, 1: between tiles). 
  .label pacman_substep = $32
  // Mode determining ghost target mode. 0: chase, 1: scatter
  .label ghosts_mode = $33
  // Counts frames to change ghost mode (7 seconds scatter, 20 seconds chase )
  .label ghosts_mode_count = $34
  // Ghost 1 x fine position (0-99). 
  .label ghost1_xfine = $35
  // Ghost 1 y fine position (0-70). 
  .label ghost1_yfine = $36
  // Ghost 1 movement current direction 
  .label ghost1_direction = $37
  // Ghost 1 movement substep (0: on tile, 1: between tiles). 
  .label ghost1_substep = $38
  // Ghost 1 movement should be reversed  (0: normal, 1: reverse direction)
  .label ghost1_reverse = $39
  // Ghost 1 respawn timer
  .label ghost1_respawn = $3a
  // Ghost 2 x fine position (0-99). 
  .label ghost2_xfine = $3b
  // Ghost 2 y fine position (0-70). 
  .label ghost2_yfine = $3c
  // Ghost 2 movement current direction 
  .label ghost2_direction = $3d
  // Ghost 2 movement substep (0: on tile, 1: between tiles). 
  .label ghost2_substep = $3e
  // Ghost 2 movement should be reversed  (0: normal, 1: reverse direction)
  .label ghost2_reverse = $3f
  // Ghost 2 respawn timer
  .label ghost2_respawn = $40
  // Ghost 3 x fine position (0-99). 
  .label ghost3_xfine = $41
  // Ghost 3 y fine position (0-70). 
  .label ghost3_yfine = $42
  // Ghost 3 movement current direction 
  .label ghost3_direction = $43
  // Ghost 3 movement substep (0: on tile, 1: between tiles). 
  .label ghost3_substep = $44
  // Ghost 3 movement should be reversed  (0: normal, 1: reverse direction)
  .label ghost3_reverse = $45
  // Ghost 3 respawn timer
  .label ghost3_respawn = $46
  // Ghost 4 x fine position (0-99). 
  .label ghost4_xfine = $47
  // Ghost 4 y fine position (0-70). 
  .label ghost4_yfine = $48
  // Ghost 4 movement current direction 
  .label ghost4_direction = $49
  // Ghost 4 movement substep (0: on tile, 1: between tiles). 
  .label ghost4_substep = $4a
  // Ghost 4 movement should be reversed  (0: normal, 1: reverse direction)
  .label ghost4_reverse = $4b
  // Ghost 4 respawn timer
  .label ghost4_respawn = $4c
  // Game logic sub-step [0-7]. Each frame a different sub-step is animated
  .label game_logic_substep = $4d
  // 1 when the game is playable and characters should move around
  .label game_playable = $4e
.segment Code
__start: {
    // volatile char pacman_ch1_enabled = 0
    lda #0
    sta.z pacman_ch1_enabled
    // volatile char pacman_ch1_idx = 0
    sta.z pacman_ch1_idx
    // volatile char* logic_tile_ptr
    sta.z logic_tile_ptr
    sta.z logic_tile_ptr+1
    // volatile char logic_tile_xcol
    sta.z logic_tile_xcol
    // volatile char logic_tile_yfine
    sta.z logic_tile_yfine
    // volatile char logic_tile_left_idx
    sta.z logic_tile_left_idx
    // volatile char logic_tile_right_idx
    sta.z logic_tile_right_idx
    // char * volatile left_render_index_xcol
    sta.z left_render_index_xcol
    sta.z left_render_index_xcol+1
    // char * volatile left_canvas
    sta.z left_canvas
    sta.z left_canvas+1
    // volatile char left_ypos_inc_offset
    sta.z left_ypos_inc_offset
    // char * volatile rigt_render_index_xcol
    sta.z rigt_render_index_xcol
    sta.z rigt_render_index_xcol+1
    // char * volatile rigt_canvas
    sta.z rigt_canvas
    sta.z rigt_canvas+1
    // volatile char rigt_ypos_inc_offset
    sta.z rigt_ypos_inc_offset
    // volatile char canvas_base_hi
    sta.z canvas_base_hi
    // volatile char bobs_restore_base
    sta.z bobs_restore_base
    // volatile char top_sprites_color
    sta.z top_sprites_color
    // volatile char top_sprites_mc
    sta.z top_sprites_mc
    // volatile char side_sprites_color
    sta.z side_sprites_color
    // volatile char side_sprites_mc
    sta.z side_sprites_mc
    // volatile char bottom_sprites_color
    sta.z bottom_sprites_color
    // volatile char bottom_sprites_mc
    sta.z bottom_sprites_mc
    // volatile unsigned int pill_count
    sta.z pill_count
    sta.z pill_count+1
    // volatile char pacman_wins = 0
    sta.z pacman_wins
    // volatile char pacman_lives = 3
    lda #3
    sta.z pacman_lives
    // volatile char music_play_next = 0
    lda #0
    sta.z music_play_next
    // volatile char phase = 0
    sta.z phase
    // volatile char frame = 0
    sta.z frame
    // volatile char anim_frame_idx = 0
    sta.z anim_frame_idx
    // volatile char pacman_xfine = 45
    lda #$2d
    sta.z pacman_xfine
    // volatile char pacman_yfine = 35
    lda #$23
    sta.z pacman_yfine
    // volatile enum DIRECTION pacman_direction = STOP
    lda #STOP
    sta.z pacman_direction
    // volatile char pacman_substep = 0
    lda #0
    sta.z pacman_substep
    // volatile enum GHOSTS_MODE ghosts_mode = 1
    lda #1
    sta.z ghosts_mode
    // volatile char ghosts_mode_count = 0
    lda #0
    sta.z ghosts_mode_count
    // volatile char ghost1_xfine = 45
    lda #$2d
    sta.z ghost1_xfine
    // volatile char ghost1_yfine = 35
    lda #$23
    sta.z ghost1_yfine
    // volatile enum DIRECTION ghost1_direction = STOP
    lda #STOP
    sta.z ghost1_direction
    // volatile char ghost1_substep = 0
    lda #0
    sta.z ghost1_substep
    // volatile char ghost1_reverse = 0
    sta.z ghost1_reverse
    // volatile char ghost1_respawn = 0
    sta.z ghost1_respawn
    // volatile char ghost2_xfine = 45
    lda #$2d
    sta.z ghost2_xfine
    // volatile char ghost2_yfine = 35
    lda #$23
    sta.z ghost2_yfine
    // volatile enum DIRECTION ghost2_direction = STOP
    lda #STOP
    sta.z ghost2_direction
    // volatile char ghost2_substep = 0
    lda #0
    sta.z ghost2_substep
    // volatile char ghost2_reverse = 0
    sta.z ghost2_reverse
    // volatile char ghost2_respawn = 0
    sta.z ghost2_respawn
    // volatile char ghost3_xfine = 45
    lda #$2d
    sta.z ghost3_xfine
    // volatile char ghost3_yfine = 35
    lda #$23
    sta.z ghost3_yfine
    // volatile enum DIRECTION ghost3_direction = STOP
    lda #STOP
    sta.z ghost3_direction
    // volatile char ghost3_substep = 0
    lda #0
    sta.z ghost3_substep
    // volatile char ghost3_reverse = 0
    sta.z ghost3_reverse
    // volatile char ghost3_respawn = 0
    sta.z ghost3_respawn
    // volatile char ghost4_xfine = 45
    lda #$2d
    sta.z ghost4_xfine
    // volatile char ghost4_yfine = 35
    lda #$23
    sta.z ghost4_yfine
    // volatile enum DIRECTION ghost4_direction = STOP
    lda #STOP
    sta.z ghost4_direction
    // volatile char ghost4_substep = 0
    lda #0
    sta.z ghost4_substep
    // volatile char ghost4_reverse = 0
    sta.z ghost4_reverse
    // volatile char ghost4_respawn = 0
    sta.z ghost4_respawn
    // volatile char game_logic_substep = 0
    sta.z game_logic_substep
    // volatile char game_playable = 0
    sta.z game_playable
    jsr main
    rts
}
// Interrupt Routine at Screen Top
irq_screen_top: {
    .const toDd001_return = 0
    .const toDd002_return = 3^(>SCREENS_1)/$40
    .const toD0181_return = 0
    sta rega+1
    stx regx+1
    sty regy+1
    // kickasm
    // Stabilize the raster by using the double IRQ method
        // Acknowledge the IRQ
        lda #IRQ_RASTER
        sta IRQ_STATUS
        // Set-up IRQ for the next line
        inc RASTER
        // Point IRQ to almost stable code
        lda #<stable
        sta HARDWARE_IRQ
        lda #>stable
        sta HARDWARE_IRQ+1
        tsx       // Save stack pointer
        cli       // Reenable interrupts
        // Wait for new IRQ using NOP's to ensure minimal jitter when it hits
        .fill 15, NOP
        .align $20
    stable:
        txs             // Restore stack pointer
        ldx #9          // Wait till the raster has almost crossed to the next line (48 cycles)
        !: dex
        bne !-
        nop
        lda RASTER
        cmp RASTER
        bne !+          // And correct the last cycle of potential jitter
        !:
        // Raster is now completely stable! (Line 0x007 cycle 7)
    
    // asm
    jsr RASTER_CODE
    // VICII->SPRITE0_Y =7
    // Move sprites back to the top
    lda #7
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE0_Y
    // VICII->SPRITE1_Y =7
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE1_Y
    // VICII->SPRITE2_Y =7
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE2_Y
    // VICII->SPRITE3_Y =7
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE3_Y
    // VICII->SPRITE4_Y =7
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE4_Y
    // VICII->SPRITE5_Y =7
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE5_Y
    // VICII->SPRITE6_Y =7
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE6_Y
    // VICII->SPRITE7_Y =7
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE7_Y
    // VICII->MEMORY = toD018(SCREENS_1, SCREENS_1)
    // Select first screen (graphics bank not important since layout in the banks is identical)
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // VICII->SPRITES_MC = top_sprites_mc
    // Set the top sprites color/MC
    lda.z top_sprites_mc
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MC
    // VICII->SPRITE0_COLOR = top_sprites_color
    lda.z top_sprites_color
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE0_COLOR
    // VICII->SPRITE1_COLOR = top_sprites_color
    lda.z top_sprites_color
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE1_COLOR
    // frame+1
    lda.z frame
    clc
    adc #1
    // (frame+1) & 1
    and #1
    // frame = (frame+1) & 1
    // Move to next frame
    sta.z frame
    // if(frame)
    bne __b6
    // CIA2->PORT_A = toDd00(SCREENS_1)
    // Change graphics bank
    lda #toDd002_return
    sta CIA2
    // canvas_base_hi = BYTE1(SPRITES_2)
    // Set the next canvas base address
    lda #>SPRITES_2
    sta.z canvas_base_hi
    // bobs_restore_base = NUM_BOBS*SIZE_BOB_RESTORE
    lda #NUM_BOBS*SIZE_BOB_RESTORE
    sta.z bobs_restore_base
  __b1:
    // if(phase==0)
    lda.z phase
    beq __b2
    // game_logic()
    // Game phase
    // Perform game logic
    jsr game_logic
    // pacman_sound_play()
    // Play sounds
    jsr pacman_sound_play
  __b3:
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->RASTER = IRQ_SCREEN_TOP_LINE
    // Trigger IRQ at screen top again
    lda #IRQ_SCREEN_TOP_LINE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *HARDWARE_IRQ = &irq_screen_top
    lda #<irq_screen_top
    sta HARDWARE_IRQ
    lda #>irq_screen_top
    sta HARDWARE_IRQ+1
    // }
  rega:
    lda #0
  regx:
    ldx #0
  regy:
    ldy #0
    rti
  __b2:
    // music_play_next = 1
    // intro phase
    // Play intro music
    lda #1
    sta.z music_play_next
    jmp __b3
  __b6:
    // CIA2->PORT_A = toDd00(SCREENS_2)
    // Change graphics bank
    lda #toDd001_return
    sta CIA2
    // canvas_base_hi = BYTE1(SPRITES_1)
    // Set the next canvas base address
    lda #>SPRITES_1
    sta.z canvas_base_hi
    // bobs_restore_base = 0
    lda #0
    sta.z bobs_restore_base
    jmp __b1
}
main: {
    // splash_run()
  // Show the splash screen
    jsr splash_run
  __b1:
    // gameplay_run()
  // Run the gameplay
    jsr gameplay_run
    // done_run()
    // Show victory or game over image
    jsr done_run
    jmp __b1
}
// Perform game logic such as moving pacman and ghosts
game_logic: {
    .label __67 = $51
    .label __71 = $51
    .label __210 = $50
    .label ghost_frame_idx = 2
    .label pacman_xtile = $4f
    .label ytiles = $51
    .label ghost4_xtile = $53
    .label ghost4_ytile = 4
    .label target_ytile = 3
    .label ghost3_xtile = $54
    .label ghost3_ytile = 4
    .label target_ytile1 = 3
    .label ghost2_xtile = $55
    .label ghost2_ytile = 4
    .label target_ytile2 = 3
    .label ghost1_xtile = $56
    .label ghost1_ytile = 4
    .label target_ytile3 = 3
    // if(game_playable==0)
    lda.z game_playable
    bne __b1
  __breturn:
    // }
    rts
  __b1:
    // game_logic_substep+1
    ldx.z game_logic_substep
    inx
    // (game_logic_substep+1)&7
    txa
    and #7
    // game_logic_substep = (game_logic_substep+1)&7
    // Move to next sub-step
    sta.z game_logic_substep
    // if(game_logic_substep==0)
    bne !__b2+
    jmp __b2
  !__b2:
    // if(game_logic_substep==1)
    lda #1
    cmp.z game_logic_substep
    bne !__b3+
    jmp __b3
  !__b3:
    // if(game_logic_substep==2)
    lda #2
    cmp.z game_logic_substep
    bne !__b4+
    jmp __b4
  !__b4:
    // if(game_logic_substep==4)
    lda #4
    cmp.z game_logic_substep
    bne !__b5+
    jmp __b5
  !__b5:
    // if(game_logic_substep==5)
    lda #5
    cmp.z game_logic_substep
    bne !__b6+
    jmp __b6
  !__b6:
    // if(game_logic_substep==6)
    lda #6
    cmp.z game_logic_substep
    bne !__b7+
    jmp __b7
  !__b7:
    // if(game_logic_substep==3 || game_logic_substep==7)
    lda #3
    cmp.z game_logic_substep
    beq __b14
    lda #7
    cmp.z game_logic_substep
    beq __b14
    rts
  __b14:
    // anim_frame_idx+1
    ldx.z anim_frame_idx
    inx
    // (anim_frame_idx+1) & 3
    txa
    and #3
    // anim_frame_idx = (anim_frame_idx+1) & 3
    // Update animation and bobs
    sta.z anim_frame_idx
    // char pacman_bob_xfine = pacman_xfine-1
    lda.z pacman_xfine
    tay
    dey
    // pacman_bob_xfine/4
    tya
    lsr
    lsr
    // bobs_xcol[0] = pacman_bob_xfine/4
    sta bobs_xcol
    // pacman_yfine-1
    ldx.z pacman_yfine
    dex
    // bobs_yfine[0] = pacman_yfine-1
    stx bobs_yfine
    // pacman_direction|anim_frame_idx
    lda.z pacman_direction
    ora.z anim_frame_idx
    tax
    // pacman_bob_xfine&3
    tya
    and #3
    // pacman_frames[pacman_direction|anim_frame_idx] +  (pacman_bob_xfine&3)
    clc
    adc pacman_frames,x
    // bobs_bob_id[0] = pacman_frames[pacman_direction|anim_frame_idx] +  (pacman_bob_xfine&3)
    sta bobs_bob_id
    // char ghost_frame_idx = anim_frame_idx
    lda.z anim_frame_idx
    sta.z ghost_frame_idx
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    bne __b44
    // ghost_frame_idx |= 0x40
    lda #$40
    ora.z ghost_frame_idx
    sta.z ghost_frame_idx
  __b44:
    // char ghost1_bob_xfine = ghost1_xfine-1
    lda.z ghost1_xfine
    tay
    dey
    // ghost1_bob_xfine/4
    tya
    lsr
    lsr
    // bobs_xcol[1] = ghost1_bob_xfine/4
    sta bobs_xcol+1
    // ghost1_yfine-1
    ldx.z ghost1_yfine
    dex
    // bobs_yfine[1] = ghost1_yfine-1
    stx bobs_yfine+1
    // ghost1_direction|ghost_frame_idx
    lda.z ghost1_direction
    ora.z ghost_frame_idx
    tax
    // ghost1_bob_xfine&3
    tya
    and #3
    // ghost_frames[ghost1_direction|ghost_frame_idx] +  (ghost1_bob_xfine&3)
    clc
    adc ghost_frames,x
    // bobs_bob_id[1] = ghost_frames[ghost1_direction|ghost_frame_idx] +  (ghost1_bob_xfine&3)
    sta bobs_bob_id+1
    // char ghost2_bob_xfine = ghost2_xfine-1
    lda.z ghost2_xfine
    tay
    dey
    // ghost2_bob_xfine/4
    tya
    lsr
    lsr
    // bobs_xcol[2] = ghost2_bob_xfine/4
    sta bobs_xcol+2
    // ghost2_yfine-1
    ldx.z ghost2_yfine
    dex
    // bobs_yfine[2] = ghost2_yfine-1
    stx bobs_yfine+2
    // ghost2_direction|ghost_frame_idx
    lda.z ghost2_direction
    ora.z ghost_frame_idx
    tax
    // ghost2_bob_xfine&3
    tya
    and #3
    // ghost_frames[ghost2_direction|ghost_frame_idx] +  (ghost2_bob_xfine&3)
    clc
    adc ghost_frames,x
    // bobs_bob_id[2] = ghost_frames[ghost2_direction|ghost_frame_idx] +  (ghost2_bob_xfine&3)
    sta bobs_bob_id+2
    // char ghost3_bob_xfine = ghost3_xfine-1
    lda.z ghost3_xfine
    tay
    dey
    // ghost3_bob_xfine/4
    tya
    lsr
    lsr
    // bobs_xcol[3] = ghost3_bob_xfine/4
    sta bobs_xcol+3
    // ghost3_yfine-1
    ldx.z ghost3_yfine
    dex
    // bobs_yfine[3] = ghost3_yfine-1
    stx bobs_yfine+3
    // ghost3_direction|ghost_frame_idx
    lda.z ghost3_direction
    ora.z ghost_frame_idx
    tax
    // ghost3_bob_xfine&3
    tya
    and #3
    // ghost_frames[ghost3_direction|ghost_frame_idx] +  (ghost3_bob_xfine&3)
    clc
    adc ghost_frames,x
    // bobs_bob_id[3] = ghost_frames[ghost3_direction|ghost_frame_idx] +  (ghost3_bob_xfine&3)
    sta bobs_bob_id+3
    // char ghost4_bob_xfine = ghost4_xfine-1
    lda.z ghost4_xfine
    tay
    dey
    // ghost4_bob_xfine/4
    tya
    lsr
    lsr
    // bobs_xcol[4] = ghost4_bob_xfine/4
    sta bobs_xcol+4
    // ghost4_yfine-1
    ldx.z ghost4_yfine
    dex
    // bobs_yfine[4] = ghost4_yfine-1
    stx bobs_yfine+4
    // ghost4_direction|ghost_frame_idx
    lda.z ghost4_direction
    ora.z ghost_frame_idx
    tax
    // ghost4_bob_xfine&3
    tya
    and #3
    // ghost_frames[ghost4_direction|ghost_frame_idx] +  (ghost4_bob_xfine&3)
    clc
    adc ghost_frames,x
    // bobs_bob_id[4] = ghost_frames[ghost4_direction|ghost_frame_idx] +  (ghost4_bob_xfine&3)
    sta bobs_bob_id+4
    rts
  __b7:
    // ghosts_mode_count++;
    inc.z ghosts_mode_count
    // if(ghosts_mode==SCATTER)
    lda #SCATTER
    cmp.z ghosts_mode
    bne !__b45+
    jmp __b45
  !__b45:
    // if(ghosts_mode==CHASE)
    lda #CHASE
    cmp.z ghosts_mode
    bne !__b46+
    jmp __b46
  !__b46:
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    bne __b9
    // if(ghosts_mode_count>50)
    lda.z ghosts_mode_count
    cmp #$32+1
    bcc __b9
    // ghosts_mode = CHASE
    lda #CHASE
    sta.z ghosts_mode
    // ghosts_mode_count = 0
    lda #0
    sta.z ghosts_mode_count
  __b8:
    lda #1
    jmp __b47
  __b9:
    lda #0
  __b47:
    // if(do_reverse)
    cmp #0
    beq __b48
    // ghost1_reverse = 1
    lda #1
    sta.z ghost1_reverse
    // ghost2_reverse = 1
    sta.z ghost2_reverse
    // ghost3_reverse = 1
    sta.z ghost3_reverse
    // ghost4_reverse = 1
    sta.z ghost4_reverse
  __b48:
    // char pacman_xtile = pacman_xfine/2
    lda.z pacman_xfine
    lsr
    sta.z pacman_xtile
    // char pacman_ytile = pacman_yfine/2
    lda.z pacman_yfine
    lsr
    // LEVEL_TILES + LEVEL_YTILE_OFFSET[pacman_ytile]
    asl
    sta.z __210
    // char* ytiles = LEVEL_TILES + LEVEL_YTILE_OFFSET[pacman_ytile]
    tay
    clc
    lda #<LEVEL_TILES
    adc LEVEL_YTILE_OFFSET,y
    sta.z ytiles
    lda #>LEVEL_TILES
    adc LEVEL_YTILE_OFFSET+1,y
    sta.z ytiles+1
    // char tile_id = ytiles[pacman_xtile]
    ldy.z pacman_xtile
    lda (ytiles),y
    tax
    // if(TILES_TYPE[tile_id]==PILL)
    lda TILES_TYPE,x
    cmp #PILL
    bne !__b49+
    jmp __b49
  !__b49:
    // if(TILES_TYPE[tile_id]==POWERUP)
    lda TILES_TYPE,x
    cmp #POWERUP
    bne __b50
    // ytiles[pacman_xtile] = EMPTY
    // Empty the tile
    lda #EMPTY
    sta (ytiles),y
    // pacman_xtile/2
    tya
    lsr
    // logic_tile_xcol = pacman_xtile/2
    // Ask the logic code renderer to update the tile
    sta.z logic_tile_xcol
    // pacman_xtile & 0xfe
    lda #$fe
    and.z pacman_xtile
    // ytiles + (pacman_xtile & 0xfe)
    clc
    adc.z __67
    sta.z __67
    bcc !+
    inc.z __67+1
  !:
    // logic_tile_ptr = ytiles + (pacman_xtile & 0xfe)
    lda.z __67
    sta.z logic_tile_ptr
    lda.z __67+1
    sta.z logic_tile_ptr+1
    // pacman_ytile*2
    lda.z __210
    // logic_tile_yfine = pacman_ytile*2
    sta.z logic_tile_yfine
    // ghosts_mode = FRIGHTENED
    // Start power-up mode
    lda #FRIGHTENED
    sta.z ghosts_mode
    // ghosts_mode_count = 0
    lda #0
    sta.z ghosts_mode_count
  __b50:
    // pacman_xfine-ghost1_xfine
    lda.z pacman_xfine
    sec
    sbc.z ghost1_xfine
    tax
    // pacman_yfine-ghost1_yfine
    lda.z pacman_yfine
    sec
    sbc.z ghost1_yfine
    tay
    // if(ABS[pacman_xfine-ghost1_xfine]<2 && ABS[pacman_yfine-ghost1_yfine]<2)
    // Check if anyone dies
    lda ABS,x
    cmp #2
    bcs __b64
    lda ABS,y
    cmp #2
    bcs !__b51+
    jmp __b51
  !__b51:
  __b64:
    // pacman_xfine-ghost2_xfine
    lda.z pacman_xfine
    sec
    sbc.z ghost2_xfine
    tax
    // pacman_yfine-ghost2_yfine
    lda.z pacman_yfine
    sec
    sbc.z ghost2_yfine
    tay
    // if(ABS[pacman_xfine-ghost2_xfine]<2 && ABS[pacman_yfine-ghost2_yfine]<2)
    lda ABS,x
    cmp #2
    bcs __b65
    lda ABS,y
    cmp #2
    bcc __b52
  __b65:
    // pacman_xfine-ghost3_xfine
    lda.z pacman_xfine
    sec
    sbc.z ghost3_xfine
    tax
    // pacman_yfine-ghost3_yfine
    lda.z pacman_yfine
    sec
    sbc.z ghost3_yfine
    tay
    // if(ABS[pacman_xfine-ghost3_xfine]<2 && ABS[pacman_yfine-ghost3_yfine]<2)
    lda ABS,x
    cmp #2
    bcs __b66
    lda ABS,y
    cmp #2
    bcc __b53
  __b66:
    // pacman_xfine-ghost4_xfine
    lda.z pacman_xfine
    sec
    sbc.z ghost4_xfine
    tax
    // pacman_yfine-ghost4_yfine
    lda.z pacman_yfine
    sec
    sbc.z ghost4_yfine
    tay
    // if(ABS[pacman_xfine-ghost4_xfine]<2 && ABS[pacman_yfine-ghost4_yfine]<2)
    lda ABS,x
    cmp #2
    bcc !__breturn+
    jmp __breturn
  !__breturn:
    lda ABS,y
    cmp #2
    bcc __b67
    rts
  __b67:
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    beq __b54
    // pacman_lives--;
    dec.z pacman_lives
    // spawn_all()
    jsr spawn_all
    rts
  __b54:
    // ghost4_direction = STOP
    lda #STOP
    sta.z ghost4_direction
    // ghost4_xfine = 50
    lda #$32
    sta.z ghost4_xfine
    // ghost4_yfine = 35
    lda #$23
    sta.z ghost4_yfine
    // ghost4_substep = 0
    lda #0
    sta.z ghost4_substep
    // ghost4_respawn = 50
    lda #$32
    sta.z ghost4_respawn
    rts
  __b53:
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    beq __b55
    // pacman_lives--;
    dec.z pacman_lives
    // spawn_all()
    jsr spawn_all
    rts
  __b55:
    // ghost3_direction = STOP
    lda #STOP
    sta.z ghost3_direction
    // ghost3_xfine = 50
    lda #$32
    sta.z ghost3_xfine
    // ghost3_yfine = 35
    lda #$23
    sta.z ghost3_yfine
    // ghost3_substep = 0
    lda #0
    sta.z ghost3_substep
    // ghost3_respawn = 50
    lda #$32
    sta.z ghost3_respawn
    rts
  __b52:
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    beq __b56
    // pacman_lives--;
    dec.z pacman_lives
    // spawn_all()
    jsr spawn_all
    rts
  __b56:
    // ghost2_direction = STOP
    lda #STOP
    sta.z ghost2_direction
    // ghost2_xfine = 50
    lda #$32
    sta.z ghost2_xfine
    // ghost2_yfine = 35
    lda #$23
    sta.z ghost2_yfine
    // ghost2_substep = 0
    lda #0
    sta.z ghost2_substep
    // ghost2_respawn = 50
    lda #$32
    sta.z ghost2_respawn
    rts
  __b51:
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    beq __b57
    // pacman_lives--;
    dec.z pacman_lives
    // spawn_all()
    jsr spawn_all
    rts
  __b57:
    // ghost1_direction = STOP
    // ghost dies
    lda #STOP
    sta.z ghost1_direction
    // ghost1_xfine = 50
    lda #$32
    sta.z ghost1_xfine
    // ghost1_yfine = 35
    lda #$23
    sta.z ghost1_yfine
    // ghost1_substep = 0
    lda #0
    sta.z ghost1_substep
    // ghost1_respawn = 50
    lda #$32
    sta.z ghost1_respawn
    rts
  __b49:
    // ytiles[pacman_xtile] = EMPTY
    // Empty the tile
    lda #EMPTY
    ldy.z pacman_xtile
    sta (ytiles),y
    // pacman_xtile/2
    tya
    lsr
    // logic_tile_xcol = pacman_xtile/2
    // Ask the logic code renderer to update the tile
    sta.z logic_tile_xcol
    // pacman_xtile & 0xfe
    lda #$fe
    and.z pacman_xtile
    // ytiles + (pacman_xtile & 0xfe)
    clc
    adc.z __71
    sta.z __71
    bcc !+
    inc.z __71+1
  !:
    // logic_tile_ptr = ytiles + (pacman_xtile & 0xfe)
    lda.z __71
    sta.z logic_tile_ptr
    lda.z __71+1
    sta.z logic_tile_ptr+1
    // pacman_ytile*2
    lda.z __210
    // logic_tile_yfine = pacman_ytile*2
    sta.z logic_tile_yfine
    // if(--pill_count==0)
    lda.z pill_count
    bne !+
    dec.z pill_count+1
  !:
    dec.z pill_count
    lda.z pill_count
    ora.z pill_count+1
    beq !__b50+
    jmp __b50
  !__b50:
    // pacman_wins = 1
    lda #1
    sta.z pacman_wins
    jmp __b50
  __b46:
    // if(ghosts_mode_count>150)
    lda.z ghosts_mode_count
    cmp #$96+1
    bcs !__b9+
    jmp __b9
  !__b9:
    // ghosts_mode = SCATTER
    lda #SCATTER
    sta.z ghosts_mode
    // ghosts_mode_count = 0
    lda #0
    sta.z ghosts_mode_count
    jmp __b8
  __b45:
    // if(ghosts_mode_count>50)
    lda.z ghosts_mode_count
    cmp #$32+1
    bcs !__b9+
    jmp __b9
  !__b9:
    // ghosts_mode = CHASE
    lda #CHASE
    sta.z ghosts_mode
    // ghosts_mode_count = 0
    lda #0
    sta.z ghosts_mode_count
    jmp __b8
  __b6:
    // if(ghost4_respawn)
    // Ghost spawn timer
    lda.z ghost4_respawn
    beq !__b72+
    jmp __b72
  !__b72:
    // if(ghost4_direction==RIGHT)
    // Move in the current direction (unless he is stopped)
    lda #RIGHT
    cmp.z ghost4_direction
    bne !__b73+
    jmp __b73
  !__b73:
    // if(ghost4_direction==DOWN)
    lda #DOWN
    cmp.z ghost4_direction
    bne !__b74+
    jmp __b74
  !__b74:
    // if(ghost4_direction==LEFT)
    lda #LEFT
    cmp.z ghost4_direction
    bne !__b75+
    jmp __b75
  !__b75:
    // if(ghost4_direction==UP)
    lda #UP
    cmp.z ghost4_direction
    bne __b76
    // --ghost4_yfine;
    dec.z ghost4_yfine
  __b76:
    // ghost4_direction!=STOP
    ldx.z ghost4_direction
    // if(ghost4_substep==0 && ghost4_direction!=STOP)
    lda.z ghost4_substep
    bne __b82
    cpx #STOP
    bne __b77
  __b82:
    // ghost4_substep = 0
    // Ghost is on a tile
    lda #0
    sta.z ghost4_substep
    // if(ghost4_reverse)
    lda.z ghost4_reverse
    bne __b78
    // char ghost4_xtile = ghost4_xfine/2
    lda.z ghost4_xfine
    lsr
    sta.z ghost4_xtile
    // char ghost4_ytile = ghost4_yfine/2
    lda.z ghost4_yfine
    lsr
    sta.z ghost4_ytile
    // level_tile_directions(ghost4_xtile, ghost4_ytile)
    ldx.z ghost4_xtile
    jsr level_tile_directions
    // level_tile_directions(ghost4_xtile, ghost4_ytile)
    // char open_directions = level_tile_directions(ghost4_xtile, ghost4_ytile)
    // open_directions &= DIRECTION_ELIMINATE[ghost4_direction]
    // Eliminate the direction ghost came from
    ldy.z ghost4_direction
    and DIRECTION_ELIMINATE,y
    tay
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    beq __b79
    // if(ghosts_mode==SCATTER)
    lda #SCATTER
    cmp.z ghosts_mode
    beq __b10
    // target_xtile = pacman_xfine/2
    lda.z pacman_xfine
    lsr
    tax
    // target_ytile = pacman_yfine/2
    lda.z pacman_yfine
    lsr
    sta.z target_ytile
    jmp __b80
  __b10:
    lda #2
    sta.z target_ytile
    tax
  __b80:
    // choose_direction( open_directions, ghost4_xtile, ghost4_ytile, target_xtile, target_ytile )
    sty.z choose_direction.open_directions
    ldy.z ghost4_xtile
    jsr choose_direction
    // choose_direction( open_directions, ghost4_xtile, ghost4_ytile, target_xtile, target_ytile )
    lda.z choose_direction.return
    // ghost4_direction = choose_direction( open_directions, ghost4_xtile, ghost4_ytile, target_xtile, target_ytile )
    sta.z ghost4_direction
    rts
  __b79:
    // ghost4_direction = DIRECTION_SINGLE[open_directions]
    // Choose a random direction between the open directions
    lda DIRECTION_SINGLE,y
    sta.z ghost4_direction
    rts
  __b78:
    // ghost4_direction = DIRECTION_REVERSE[ghost4_direction]
    // If we are changing between scatter & chase then reverse the direction
    ldy.z ghost4_direction
    lda DIRECTION_REVERSE,y
    sta.z ghost4_direction
    // ghost4_reverse = 0
    lda #0
    sta.z ghost4_reverse
    rts
  __b77:
    // ghost4_substep = 1
    // Ghost was on a tile and is moving, so he is now between tiles
    lda #1
    sta.z ghost4_substep
    // if(ghost4_xfine==1)
    // Teleport if we are in the magic positions
    cmp.z ghost4_xfine
    beq __b81
    // if(ghost4_xfine==97)
    lda #$61
    cmp.z ghost4_xfine
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // ghost4_xfine = 1
    lda #1
    sta.z ghost4_xfine
    rts
  __b81:
    // ghost4_xfine = 97
    lda #$61
    sta.z ghost4_xfine
    rts
  __b75:
    // --ghost4_xfine;
    dec.z ghost4_xfine
    jmp __b76
  __b74:
    // ++ghost4_yfine;
    inc.z ghost4_yfine
    jmp __b76
  __b73:
    // ++ghost4_xfine;
    inc.z ghost4_xfine
    jmp __b76
  __b72:
    // if(--ghost4_respawn==0)
    dec.z ghost4_respawn
    lda.z ghost4_respawn
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // ghost4_direction = RIGHT
    // Spawn ghost
    lda #RIGHT
    sta.z ghost4_direction
    // ghost4_xfine = 2
    lda #2
    sta.z ghost4_xfine
    // ghost4_yfine = 2
    sta.z ghost4_yfine
    // ghost4_substep = 0
    lda #0
    sta.z ghost4_substep
    rts
  __b5:
    // if(ghost3_respawn)
    // Ghost spawn timer
    lda.z ghost3_respawn
    beq !__b89+
    jmp __b89
  !__b89:
    // if(ghost3_direction==RIGHT)
    // Move in the current direction (unless he is stopped)
    lda #RIGHT
    cmp.z ghost3_direction
    bne !__b90+
    jmp __b90
  !__b90:
    // if(ghost3_direction==DOWN)
    lda #DOWN
    cmp.z ghost3_direction
    bne !__b91+
    jmp __b91
  !__b91:
    // if(ghost3_direction==LEFT)
    lda #LEFT
    cmp.z ghost3_direction
    bne !__b92+
    jmp __b92
  !__b92:
    // if(ghost3_direction==UP)
    lda #UP
    cmp.z ghost3_direction
    bne __b93
    // --ghost3_yfine;
    dec.z ghost3_yfine
  __b93:
    // ghost3_direction!=STOP
    ldx.z ghost3_direction
    // if(ghost3_substep==0 && ghost3_direction!=STOP)
    lda.z ghost3_substep
    bne __b99
    cpx #STOP
    bne __b94
  __b99:
    // ghost3_substep = 0
    // Ghost is on a tile
    lda #0
    sta.z ghost3_substep
    // if(ghost3_reverse)
    lda.z ghost3_reverse
    bne __b95
    // char ghost3_xtile = ghost3_xfine/2
    lda.z ghost3_xfine
    lsr
    sta.z ghost3_xtile
    // char ghost3_ytile = ghost3_yfine/2
    lda.z ghost3_yfine
    lsr
    sta.z ghost3_ytile
    // level_tile_directions(ghost3_xtile, ghost3_ytile)
    ldx.z ghost3_xtile
    jsr level_tile_directions
    // level_tile_directions(ghost3_xtile, ghost3_ytile)
    // char open_directions = level_tile_directions(ghost3_xtile, ghost3_ytile)
    // open_directions &= DIRECTION_ELIMINATE[ghost3_direction]
    // Eliminate the direction ghost came from
    ldy.z ghost3_direction
    and DIRECTION_ELIMINATE,y
    tay
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    beq __b96
    // if(ghosts_mode==SCATTER)
    lda #SCATTER
    cmp.z ghosts_mode
    beq __b11
    // target_xtile = pacman_xfine/2
    lda.z pacman_xfine
    lsr
    tax
    // target_ytile = pacman_yfine/2
    lda.z pacman_yfine
    lsr
    sta.z target_ytile1
    jmp __b97
  __b11:
    lda #2
    sta.z target_ytile1
    tax
  __b97:
    // choose_direction( open_directions, ghost3_xtile, ghost3_ytile, target_xtile, target_ytile )
    sty.z choose_direction.open_directions
    ldy.z ghost3_xtile
    jsr choose_direction
    // choose_direction( open_directions, ghost3_xtile, ghost3_ytile, target_xtile, target_ytile )
    lda.z choose_direction.return
    // ghost3_direction = choose_direction( open_directions, ghost3_xtile, ghost3_ytile, target_xtile, target_ytile )
    sta.z ghost3_direction
    rts
  __b96:
    // ghost3_direction = DIRECTION_SINGLE[open_directions]
    // Choose a random direction between the open directions
    lda DIRECTION_SINGLE,y
    sta.z ghost3_direction
    rts
  __b95:
    // ghost3_direction = DIRECTION_REVERSE[ghost3_direction]
    // If we are changing between scatter & chase then reverse the direction
    ldy.z ghost3_direction
    lda DIRECTION_REVERSE,y
    sta.z ghost3_direction
    // ghost3_reverse = 0
    lda #0
    sta.z ghost3_reverse
    rts
  __b94:
    // ghost3_substep = 1
    // Ghost was on a tile and is moving, so he is now between tiles
    lda #1
    sta.z ghost3_substep
    // if(ghost3_xfine==1)
    // Teleport if we are in the magic positions
    cmp.z ghost3_xfine
    beq __b98
    // if(ghost3_xfine==97)
    lda #$61
    cmp.z ghost3_xfine
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // ghost3_xfine = 1
    lda #1
    sta.z ghost3_xfine
    rts
  __b98:
    // ghost3_xfine = 97
    lda #$61
    sta.z ghost3_xfine
    rts
  __b92:
    // --ghost3_xfine;
    dec.z ghost3_xfine
    jmp __b93
  __b91:
    // ++ghost3_yfine;
    inc.z ghost3_yfine
    jmp __b93
  __b90:
    // ++ghost3_xfine;
    inc.z ghost3_xfine
    jmp __b93
  __b89:
    // if(--ghost3_respawn==0)
    dec.z ghost3_respawn
    lda.z ghost3_respawn
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // ghost3_direction = UP
    // Spawn ghost
    lda #UP
    sta.z ghost3_direction
    // ghost3_xfine = 2
    lda #2
    sta.z ghost3_xfine
    // ghost3_yfine = 70
    lda #$46
    sta.z ghost3_yfine
    // ghost3_substep = 0
    lda #0
    sta.z ghost3_substep
    rts
  __b4:
    // if(ghost2_respawn)
    // Ghost spawn timer
    lda.z ghost2_respawn
    beq !__b106+
    jmp __b106
  !__b106:
    // if(ghost2_direction==RIGHT)
    // Move in the current direction (unless he is stopped)
    lda #RIGHT
    cmp.z ghost2_direction
    bne !__b107+
    jmp __b107
  !__b107:
    // if(ghost2_direction==DOWN)
    lda #DOWN
    cmp.z ghost2_direction
    bne !__b108+
    jmp __b108
  !__b108:
    // if(ghost2_direction==LEFT)
    lda #LEFT
    cmp.z ghost2_direction
    bne !__b109+
    jmp __b109
  !__b109:
    // if(ghost2_direction==UP)
    lda #UP
    cmp.z ghost2_direction
    bne __b110
    // --ghost2_yfine;
    dec.z ghost2_yfine
  __b110:
    // ghost2_direction!=STOP
    ldx.z ghost2_direction
    // if(ghost2_substep==0 && ghost2_direction!=STOP)
    lda.z ghost2_substep
    bne __b116
    cpx #STOP
    bne __b111
  __b116:
    // ghost2_substep = 0
    // Ghost is on a tile
    lda #0
    sta.z ghost2_substep
    // if(ghost2_reverse)
    lda.z ghost2_reverse
    bne __b112
    // char ghost2_xtile = ghost2_xfine/2
    lda.z ghost2_xfine
    lsr
    sta.z ghost2_xtile
    // char ghost2_ytile = ghost2_yfine/2
    lda.z ghost2_yfine
    lsr
    sta.z ghost2_ytile
    // level_tile_directions(ghost2_xtile, ghost2_ytile)
    ldx.z ghost2_xtile
    jsr level_tile_directions
    // level_tile_directions(ghost2_xtile, ghost2_ytile)
    // char open_directions = level_tile_directions(ghost2_xtile, ghost2_ytile)
    // open_directions &= DIRECTION_ELIMINATE[ghost2_direction]
    // Eliminate the direction ghost came from
    ldy.z ghost2_direction
    and DIRECTION_ELIMINATE,y
    tay
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    beq __b113
    // if(ghosts_mode==SCATTER)
    lda #SCATTER
    cmp.z ghosts_mode
    beq __b12
    // target_xtile = pacman_xfine/2
    lda.z pacman_xfine
    lsr
    tax
    // target_ytile = pacman_yfine/2
    lda.z pacman_yfine
    lsr
    sta.z target_ytile2
    jmp __b114
  __b12:
    lda #2
    sta.z target_ytile2
    tax
  __b114:
    // choose_direction( open_directions, ghost2_xtile, ghost2_ytile, target_xtile, target_ytile )
    sty.z choose_direction.open_directions
    ldy.z ghost2_xtile
    jsr choose_direction
    // choose_direction( open_directions, ghost2_xtile, ghost2_ytile, target_xtile, target_ytile )
    lda.z choose_direction.return
    // ghost2_direction = choose_direction( open_directions, ghost2_xtile, ghost2_ytile, target_xtile, target_ytile )
    sta.z ghost2_direction
    rts
  __b113:
    // ghost2_direction = DIRECTION_SINGLE[open_directions]
    // Choose a random direction between the open directions
    lda DIRECTION_SINGLE,y
    sta.z ghost2_direction
    rts
  __b112:
    // ghost2_direction = DIRECTION_REVERSE[ghost2_direction]
    // If we are changing between scatter & chase then reverse the direction
    ldy.z ghost2_direction
    lda DIRECTION_REVERSE,y
    sta.z ghost2_direction
    // ghost2_reverse = 0
    lda #0
    sta.z ghost2_reverse
    rts
  __b111:
    // ghost2_substep = 1
    // Ghost was on a tile and is moving, so he is now between tiles
    lda #1
    sta.z ghost2_substep
    // if(ghost2_xfine==1)
    // Teleport if we are in the magic positions
    cmp.z ghost2_xfine
    beq __b115
    // if(ghost2_xfine==97)
    lda #$61
    cmp.z ghost2_xfine
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // ghost2_xfine = 1
    lda #1
    sta.z ghost2_xfine
    rts
  __b115:
    // ghost2_xfine = 97
    lda #$61
    sta.z ghost2_xfine
    rts
  __b109:
    // --ghost2_xfine;
    dec.z ghost2_xfine
    jmp __b110
  __b108:
    // ++ghost2_yfine;
    inc.z ghost2_yfine
    jmp __b110
  __b107:
    // ++ghost2_xfine;
    inc.z ghost2_xfine
    jmp __b110
  __b106:
    // if(--ghost2_respawn==0)
    dec.z ghost2_respawn
    lda.z ghost2_respawn
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // ghost2_direction = LEFT
    // Spawn ghost
    lda #LEFT
    sta.z ghost2_direction
    // ghost2_xfine = 96
    lda #$60
    sta.z ghost2_xfine
    // ghost2_yfine = 70
    lda #$46
    sta.z ghost2_yfine
    // ghost2_substep = 0
    lda #0
    sta.z ghost2_substep
    rts
  __b3:
    // if(ghost1_respawn)
    // Ghost spawn timer
    lda.z ghost1_respawn
    beq !__b123+
    jmp __b123
  !__b123:
    // if(ghost1_direction==RIGHT)
    // Ghost 1 animation
    // Move in the current direction (unless he is stopped)
    lda #RIGHT
    cmp.z ghost1_direction
    bne !__b124+
    jmp __b124
  !__b124:
    // if(ghost1_direction==DOWN)
    lda #DOWN
    cmp.z ghost1_direction
    bne !__b125+
    jmp __b125
  !__b125:
    // if(ghost1_direction==LEFT)
    lda #LEFT
    cmp.z ghost1_direction
    bne !__b126+
    jmp __b126
  !__b126:
    // if(ghost1_direction==UP)
    lda #UP
    cmp.z ghost1_direction
    bne __b127
    // --ghost1_yfine;
    dec.z ghost1_yfine
  __b127:
    // ghost1_direction!=STOP
    ldx.z ghost1_direction
    // if(ghost1_substep==0 && ghost1_direction!=STOP)
    lda.z ghost1_substep
    bne __b133
    cpx #STOP
    bne __b128
  __b133:
    // ghost1_substep = 0
    // Ghost is on a tile
    lda #0
    sta.z ghost1_substep
    // if(ghost1_reverse)
    lda.z ghost1_reverse
    bne __b129
    // char ghost1_xtile = ghost1_xfine/2
    lda.z ghost1_xfine
    lsr
    sta.z ghost1_xtile
    // char ghost1_ytile = ghost1_yfine/2
    lda.z ghost1_yfine
    lsr
    sta.z ghost1_ytile
    // level_tile_directions(ghost1_xtile, ghost1_ytile)
    ldx.z ghost1_xtile
    jsr level_tile_directions
    // level_tile_directions(ghost1_xtile, ghost1_ytile)
    // char open_directions = level_tile_directions(ghost1_xtile, ghost1_ytile)
    // open_directions &= DIRECTION_ELIMINATE[ghost1_direction]
    // Eliminate the direction ghost came from
    ldy.z ghost1_direction
    and DIRECTION_ELIMINATE,y
    tay
    // if(ghosts_mode==FRIGHTENED)
    lda #FRIGHTENED
    cmp.z ghosts_mode
    beq __b130
    // if(ghosts_mode==SCATTER)
    lda #SCATTER
    cmp.z ghosts_mode
    beq __b13
    // target_xtile = pacman_xfine/2
    lda.z pacman_xfine
    lsr
    tax
    // target_ytile = pacman_yfine/2
    lda.z pacman_yfine
    lsr
    sta.z target_ytile3
    jmp __b131
  __b13:
    lda #2
    sta.z target_ytile3
    tax
  __b131:
    // choose_direction( open_directions, ghost1_xtile, ghost1_ytile, target_xtile, target_ytile )
    sty.z choose_direction.open_directions
    ldy.z ghost1_xtile
    jsr choose_direction
    // choose_direction( open_directions, ghost1_xtile, ghost1_ytile, target_xtile, target_ytile )
    lda.z choose_direction.return
    // ghost1_direction = choose_direction( open_directions, ghost1_xtile, ghost1_ytile, target_xtile, target_ytile )
    sta.z ghost1_direction
    rts
  __b130:
    // ghost1_direction = DIRECTION_SINGLE[open_directions]
    // Choose a random direction between the open directions
    lda DIRECTION_SINGLE,y
    sta.z ghost1_direction
    rts
  __b129:
    // ghost1_direction = DIRECTION_REVERSE[ghost1_direction]
    // If we are changing between scatter & chase then reverse the direction
    ldy.z ghost1_direction
    lda DIRECTION_REVERSE,y
    sta.z ghost1_direction
    // ghost1_reverse = 0
    lda #0
    sta.z ghost1_reverse
    rts
  __b128:
    // ghost1_substep = 1
    // Ghost was on a tile and is moving, so he is now between tiles
    lda #1
    sta.z ghost1_substep
    // if(ghost1_xfine==1)
    // Teleport if we are in the magic positions
    cmp.z ghost1_xfine
    beq __b132
    // if(ghost1_xfine==97)
    lda #$61
    cmp.z ghost1_xfine
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // ghost1_xfine = 1
    lda #1
    sta.z ghost1_xfine
    rts
  __b132:
    // ghost1_xfine = 97
    lda #$61
    sta.z ghost1_xfine
    rts
  __b126:
    // --ghost1_xfine;
    dec.z ghost1_xfine
    jmp __b127
  __b125:
    // ++ghost1_yfine;
    inc.z ghost1_yfine
    jmp __b127
  __b124:
    // ++ghost1_xfine;
    inc.z ghost1_xfine
    jmp __b127
  __b123:
    // if(--ghost1_respawn==0)
    dec.z ghost1_respawn
    lda.z ghost1_respawn
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // ghost1_direction = DOWN
    // Spawn ghost 1
    lda #DOWN
    sta.z ghost1_direction
    // ghost1_xfine = 96
    lda #$60
    sta.z ghost1_xfine
    // ghost1_yfine = 2
    lda #2
    sta.z ghost1_yfine
    // ghost1_substep = 0
    lda #0
    sta.z ghost1_substep
    rts
  __b2:
    // if(pacman_direction==RIGHT)
    // Animate pacman
    // Move pacman in the current direction (unless he is stopped)
    lda #RIGHT
    cmp.z pacman_direction
    beq __b140
    // if(pacman_direction==DOWN)
    lda #DOWN
    cmp.z pacman_direction
    beq __b141
    // if(pacman_direction==LEFT)
    lda #LEFT
    cmp.z pacman_direction
    beq __b142
    // if(pacman_direction==UP)
    lda #UP
    cmp.z pacman_direction
    bne __b143
    // --pacman_yfine;
    dec.z pacman_yfine
  __b143:
    // pacman_direction!=STOP
    ldx.z pacman_direction
    // if(pacman_substep==0 && pacman_direction!=STOP)
    lda.z pacman_substep
    bne __b147
    cpx #STOP
    bne __b144
  __b147:
    // pacman_substep = 0
    // Pacman is on a (new) tile
    lda #0
    sta.z pacman_substep
    // char pacman_xtile = pacman_xfine/2
    lda.z pacman_xfine
    lsr
    tax
    // char pacman_ytile = pacman_yfine/2
    lda.z pacman_yfine
    lsr
    // level_tile_directions(pacman_xtile, pacman_ytile)
    jsr level_tile_directions
    // level_tile_directions(pacman_xtile, pacman_ytile)
    // char open_directions = level_tile_directions(pacman_xtile, pacman_ytile)
    tax
    // CIA1->PORT_A & 0x0f
    lda #$f
    and CIA1
    // (CIA1->PORT_A & 0x0f)^0x0f
    eor #$f
    // char joy_directions = ((CIA1->PORT_A & 0x0f)^0x0f)*4
    asl
    asl
    // if(joy_directions!=0)
    cmp #0
    beq __b145
    // joy_directions&open_directions
    stx.z $ff
    and.z $ff
    // char new_direction = DIRECTION_SINGLE[joy_directions&open_directions]
    tay
    lda DIRECTION_SINGLE,y
    // if(new_direction!=0)
    cmp #0
    beq __b145
    // pacman_direction = new_direction
    sta.z pacman_direction
  __b145:
    // pacman_direction &= open_directions
    // Stop pacman if the current direction is no longer open
    lda.z pacman_direction
    sax.z pacman_direction
    rts
  __b144:
    // pacman_substep = 1
    // Pacman was on a tile and is moving, so he is now between tiles
    lda #1
    sta.z pacman_substep
    // pacman_ch1_enabled = 1
    // Enable the eating sound whenever pacman is moving
    sta.z pacman_ch1_enabled
    // if(pacman_xfine==1)
    // Teleport if we are in the magic positions
    cmp.z pacman_xfine
    beq __b146
    // if(pacman_xfine==97)
    lda #$61
    cmp.z pacman_xfine
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // pacman_xfine = 1
    lda #1
    sta.z pacman_xfine
    rts
  __b146:
    // pacman_xfine = 97
    lda #$61
    sta.z pacman_xfine
    rts
  __b142:
    // --pacman_xfine;
    dec.z pacman_xfine
    jmp __b143
  __b141:
    // ++pacman_yfine;
    inc.z pacman_yfine
    jmp __b143
  __b140:
    // ++pacman_xfine;
    inc.z pacman_xfine
    jmp __b143
}
pacman_sound_play: {
    // if(pacman_ch1_enabled)
    lda.z pacman_ch1_enabled
    beq __breturn
    // *SID_CH1_FREQ_HI = PACMAN_CH1_FREQ_HI[pacman_ch1_idx]
    // Play the entire sound - and then reset and disable it
    ldy.z pacman_ch1_idx
    lda PACMAN_CH1_FREQ_HI,y
    sta SID_CH1_FREQ_HI
    // SID->CH1_CONTROL = PACMAN_CH1_CONTROL[pacman_ch1_idx]
    lda PACMAN_CH1_CONTROL,y
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH1_CONTROL
    // if(++pacman_ch1_idx==sizeof(PACMAN_CH1_FREQ_HI))
    inc.z pacman_ch1_idx
    lda #$16*SIZEOF_BYTE
    cmp.z pacman_ch1_idx
    bne __breturn
    // pacman_ch1_idx = 0
    lda #0
    sta.z pacman_ch1_idx
    // pacman_ch1_enabled = 0
    sta.z pacman_ch1_enabled
  __breturn:
    // }
    rts
}
// Initializes all data for the splash and shows the splash.
// Returns when the splash is complete and the user clicks the joystidk #2 button
splash_run: {
    .const toDd001_return = 3^(>SCREENS_1)/$40
    .const toD0181_return = 0
    .label xpos = $59
    .label i = 5
    // asm
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable kernal & basic & IO
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_ALL
    lda #PROCPORT_RAM_ALL
    sta PROCPORT
    // memset((char*)0x4000, 0, 0xc00)
  // Reset memory to avoid crashes
    lda #<$4000
    sta.z memset.str
    lda #>$4000
    sta.z memset.str+1
    lda #<$c00
    sta.z memset.num
    lda #>$c00
    sta.z memset.num+1
    jsr memset
    // byteboozer_decrunch(RASTER_CODE_CRUNCHED)
    lda #<RASTER_CODE_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>RASTER_CODE_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch raster code
    jsr byteboozer_decrunch
    // byteboozer_decrunch(LOGIC_CODE_CRUNCHED)
    lda #<LOGIC_CODE_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>LOGIC_CODE_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch logic code
    jsr byteboozer_decrunch
    // merge_code(RASTER_CODE, RASTER_CODE_UNMERGED, LOGIC_CODE_UNMERGED)
  // Merge the raster with the logic-code
    jsr merge_code
    // memset(BANK_1+0x2000, 0x00, 0x1fff)
  // Clear the graphics banks
    lda #<BANK_1+$2000
    sta.z memset.str
    lda #>BANK_1+$2000
    sta.z memset.str+1
    lda #<$1fff
    sta.z memset.num
    lda #>$1fff
    sta.z memset.num+1
    jsr memset
    // memset(BANK_2, 0x00, 0x3fff)
    lda #<BANK_2
    sta.z memset.str
    lda #>BANK_2
    sta.z memset.str+1
    lda #<$3fff
    sta.z memset.num
    lda #>$3fff
    sta.z memset.num+1
    jsr memset
    // init_render_index()
  // Initialize the renderer tables
    jsr init_render_index
    // byteboozer_decrunch(SPLASH_CRUNCHED)
    lda #<SPLASH_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>SPLASH_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // decrunch splash screen 
    jsr byteboozer_decrunch
    // splash_show()
  // Show the splash screen
    jsr splash_show
    // memset(BANK_1, 0x00, 0x1fff)
  // Clear the graphics bank
    lda #<BANK_1
    sta.z memset.str
    lda #>BANK_1
    sta.z memset.str+1
    lda #<$1fff
    sta.z memset.num
    lda #>$1fff
    sta.z memset.num+1
    jsr memset
    // init_bobs_restore()
  // Initialize bobs_restore to "safe" values
    jsr init_bobs_restore
    // byteboozer_decrunch(BOB_GRAPHICS_CRUNCHED)
    lda #<BOB_GRAPHICS_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>BOB_GRAPHICS_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // decrunch bobs graphics tables 
    jsr byteboozer_decrunch
    // init_sprite_pointers()
  // Set sprite pointers on all screens (in both graphics banks)
    jsr init_sprite_pointers
    // memcpy(INTRO_MUSIC_CRUNCHED_UPPER, INTRO_MUSIC_CRUNCHED, INTRO_MUSIC_CRUNCHED_SIZE)
  // Move the crunched music to upper memory before decrunching it
    jsr memcpy
    // byteboozer_decrunch(INTRO_MUSIC_CRUNCHED_UPPER)
    lda #<INTRO_MUSIC_CRUNCHED_UPPER
    sta.z byteboozer_decrunch.crunched
    lda #>INTRO_MUSIC_CRUNCHED_UPPER
    sta.z byteboozer_decrunch.crunched+1
    // zero-fill the entire Init segment
    //memset(LEVEL_TILES_CRUNCHED, 0, INTRO_MUSIC_CRUNCHED+INTRO_MUSIC_CRUNCHED_SIZE-LEVEL_TILES_CRUNCHED);
    // decrunch intro music
    jsr byteboozer_decrunch
    // memset(INTRO_MUSIC_CRUNCHED_UPPER, 0, INTRO_MUSIC_CRUNCHED_SIZE)
  // Zero-fill the upper memory
    lda #<INTRO_MUSIC_CRUNCHED_UPPER
    sta.z memset.str
    lda #>INTRO_MUSIC_CRUNCHED_UPPER
    sta.z memset.str+1
    lda #<INTRO_MUSIC_CRUNCHED_SIZE
    sta.z memset.num
    lda #>INTRO_MUSIC_CRUNCHED_SIZE
    sta.z memset.num+1
    jsr memset
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable kernal & basic - enable IO
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    ldx #0
    txa
    sta.z i
  __b1:
    // for(char i=0;i<8;i++)
    lda.z i
    cmp #8
    bcs !__b2+
    jmp __b2
  !__b2:
    // CIA2->PORT_A = toDd00(SCREENS_1)
    // Set initial graphics bank
    lda #toDd001_return
    sta CIA2
    // canvas_base_hi = BYTE1(SPRITES_2)
    // Set initial render/restore buffer
    lda #>SPRITES_2
    sta.z canvas_base_hi
    // bobs_restore_base = NUM_BOBS*SIZE_BOB_RESTORE
    lda #NUM_BOBS*SIZE_BOB_RESTORE
    sta.z bobs_restore_base
    // VICII->MEMORY = toD018(SCREENS_1, SCREENS_1)
    // Select first screen
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // VICII->SPRITES_XMSB = msb
    stx VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_XMSB
    // VICII->SPRITES_ENABLE = 0xff
    lda #$ff
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE
    // VICII->SPRITES_EXPAND_X = 0xff
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_EXPAND_X
    // VICII->BORDER_COLOR = BLACK
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->BG_COLOR = BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // VICII->SPRITES_MCOLOR1 = BLUE
    lda #BLUE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR1
    // VICII->SPRITES_MCOLOR2 = RED
    lda #RED
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR2
    // top_sprites_mc = 0x03
    // On the splash screen sprites all sprites are SC - except sprite #0,1 on the top/bottom of the screen
    lda #3
    sta.z top_sprites_mc
    // side_sprites_mc = 0x00
    lda #0
    sta.z side_sprites_mc
    // bottom_sprites_mc = 0x03
    lda #3
    sta.z bottom_sprites_mc
    // top_sprites_color = YELLOW
    // On the splash top/bottom sc-sprites are yellow and side-sprites are blue
    lda #YELLOW
    sta.z top_sprites_color
    // side_sprites_color = BLUE
    lda #BLUE
    sta.z side_sprites_color
    // bottom_sprites_color = YELLOW
    lda #YELLOW
    sta.z bottom_sprites_color
    // VICII->SPRITES_MC = top_sprites_mc
    // Set the initial top colors/MC
    lda.z top_sprites_mc
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MC
    ldx #0
  // Set initial Sprite Color
  __b5:
    // for(char i=0;i<8;i++)
    cpx #8
    bcc __b6
    // VICII->CONTROL2 = 0x08
    // Set VICII CONTROL2 ($d016) to 8 to allow ASL, LSR to be used for opening the border
    lda #8
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    ldx #0
  // Move the bobs to the center to avoid interference while rendering the level
  __b8:
    // for(char i=0;i<4;i++)
    cpx #4
    bcc __b9
    // asm
    // Disable SID CH#3
    lda #1
    sta INTRO_MUSIC+$69
    // Init music
    lda #0
    // (*musicInit)()
    jsr musicInit
    // phase = 0
    // Set phase to intro
    lda #0
    sta.z phase
    // VICII->CONTROL1 = VICII_RSEL|VICII_DEN|VICII_ECM|VICII_BMM
    // Start a hyperscreen with no badlines and open borders
    // Set screen height to 25 lines (preparing for the hyperscreen), enable display
    // Set an illegal mode to prevent any character graphics
    lda #VICII_RSEL|VICII_DEN|VICII_ECM|VICII_BMM
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
  // Wait for line 0xfa (lower border)
  __b11:
    // while(VICII->RASTER!=0xfa)
    lda #$fa
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b11
    // VICII->CONTROL1 &= ~(VICII_RST8|VICII_RSEL|VICII_DEN)
    // Open lower/upper border using RSEL - and disable all graphics (except sprites)
    // Set up RASTER IRQ to start at irq_screen_top() (RST8=0)
    lda #(VICII_RST8|VICII_RSEL|VICII_DEN)^$ff
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->RASTER = IRQ_SCREEN_TOP_LINE
    lda #IRQ_SCREEN_TOP_LINE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *HARDWARE_IRQ = &irq_screen_top
    lda #<irq_screen_top
    sta HARDWARE_IRQ
    lda #>irq_screen_top
    sta HARDWARE_IRQ+1
    // VICII->IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE
    // asm
    // Acknowledge any timer IRQ
    lda CIA1_INTERRUPT
    // *IRQ_STATUS = 0x0f
    // Acknowledge any VIC IRQ
    lda #$f
    sta IRQ_STATUS
    // asm
    cli
    // joyinit()
    // Prepare for joystick control
    jsr joyinit
    // music_play_next = 0
    // Wait for fire
    lda #0
    sta.z music_play_next
  __b13:
    // joyfire()
    jsr joyfire
    // while(!joyfire())
    cmp #0
    beq __b14
    // }
    rts
  __b14:
    // if(music_play_next)
    lda.z music_play_next
    beq __b13
    // (*musicPlay)()
    //VICII->BG_COLOR=1;
    jsr musicPlay
    // music_play_next = 0
    //VICII->BG_COLOR=0;
    lda #0
    sta.z music_play_next
    jmp __b13
  __b9:
    // bobs_xcol[i] = 10
    lda #$a
    sta bobs_xcol,x
    // bobs_yfine[i] = 45
    lda #$2d
    sta bobs_yfine,x
    // bobs_bob_id[i] = 0
    lda #0
    sta bobs_bob_id,x
    // for(char i=0;i<4;i++)
    inx
    jmp __b8
  __b6:
    // SPRITES_COLOR[i] = top_sprites_color
    lda.z top_sprites_color
    sta SPRITES_COLOR,x
    // for(char i=0;i<8;i++)
    inx
    jmp __b5
  __b2:
    // i*2
    lda.z i
    asl
    tay
    // SPRITES_YPOS[i*2] = 7
    lda #7
    sta SPRITES_YPOS,y
    // unsigned int xpos = sprites_xpos[i]
    lda sprites_xpos,y
    sta.z xpos
    lda sprites_xpos+1,y
    sta.z xpos+1
    // SPRITES_XPOS[i*2] = (char)xpos
    lda.z xpos
    sta SPRITES_XPOS,y
    // msb /= 2
    txa
    lsr
    tax
    // BYTE1(xpos)
    lda.z xpos+1
    // if(BYTE1(xpos))
    cmp #0
    beq __b3
    // msb |=0x80
    txa
    ora #$80
    tax
  __b3:
    // for(char i=0;i<8;i++)
    inc.z i
    jmp __b1
  .segment Data
    // Sprite positions
    sprites_xpos: .word $1e7, $13f, $10f, $df, $af, $7f, $4f, $1f
}
.segment Code
// Initialize all data for gameplay and runs the game. 
// Exits when the user has won or lost
gameplay_run: {
    .label __4 = $b
    // asm
    sei
    ldx #0
  // Stop any sound
  __b1:
    // for(char i=0;i<0x2f;i++)
    cpx #$2f
    bcs !__b2+
    jmp __b2
  !__b2:
    // pacman_wins = 0
    // Pacman has not won yet
    lda #0
    sta.z pacman_wins
    // pacman_lives = 3
    // Pacman has 3 lives
    lda #3
    sta.z pacman_lives
    // VICII->SPRITES_MCOLOR1 = BLACK
    // During transition all sprites are black
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR1
    // VICII->SPRITES_MCOLOR2 = BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR2
    ldx #0
  __b4:
    // for(char i=0;i<8;i++)
    cpx #8
    bcs !__b5+
    jmp __b5
  !__b5:
    // byteboozer_decrunch(LEVEL_TILES_CRUNCHED)
    lda #<LEVEL_TILES_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>LEVEL_TILES_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // decrunch level tiles 
    jsr byteboozer_decrunch
    // init_level_tile_directions()
  // Initialize tile directions
    jsr init_level_tile_directions
    // init_sprite_pointers()
  // Set sprite pointers on all screens (in both graphics banks)
    jsr init_sprite_pointers
    // level_show()
    jsr level_show
    // level_show()
    // pill_count = level_show()
    // Show the level
    lda.z __4
    sta.z pill_count
    lda.z __4+1
    sta.z pill_count+1
    // top_sprites_mc = 0xff
    // During gameplay all sprites are MC.
    lda #$ff
    sta.z top_sprites_mc
    // side_sprites_mc = 0xff
    sta.z side_sprites_mc
    // bottom_sprites_mc = 0xff
    sta.z bottom_sprites_mc
    // top_sprites_color = YELLOW
    // During gameplay all sprites are yellow
    lda #YELLOW
    sta.z top_sprites_color
    // side_sprites_color = YELLOW
    sta.z side_sprites_color
    // bottom_sprites_color = YELLOW
    sta.z bottom_sprites_color
    // VICII->SPRITES_MC = top_sprites_mc
    // Set the initial top colors/MC
    lda.z top_sprites_mc
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MC
    ldx #0
  // Set initial Sprite Color
  __b7:
    // for(char i=0;i<8;i++)
    cpx #8
    bcc __b8
    // VICII->SPRITES_MCOLOR1 = BLUE
    // Set sprite MC-colors for the game
    lda #BLUE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR1
    // VICII->SPRITES_MCOLOR2 = RED
    lda #RED
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR2
    // phase = 1
    // Set phase to game
    lda #1
    sta.z phase
    // spawn_all()
    // Spawn pacman and all ghosts
    jsr spawn_all
    // pacman_sound_init()
    // Initialize the game sound
    jsr pacman_sound_init
    // game_playable = 1
    // Start the game play
    lda #1
    sta.z game_playable
    // VICII->CONTROL1 = VICII_RSEL|VICII_DEN|VICII_ECM|VICII_BMM
    // Turn on raster after transition
    // Start a hyperscreen with no badlines and open borders
    // Set screen height to 25 lines (preparing for the hyperscreen), enable display
    lda #VICII_RSEL|VICII_DEN|VICII_ECM|VICII_BMM
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
  // Wait at least one frames for DEN to take effect
  __b10:
    // while(VICII->RASTER!=0xfb)
    lda #$fb
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b10
  __b11:
    // while(VICII->RASTER!=0xfa)
    lda #$fa
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b11
    // VICII->CONTROL1 &= ~(VICII_RST8|VICII_RSEL|VICII_DEN)
    // Open lower/upper border using RSEL - and disable all graphics (except sprites)
    // Set up RASTER IRQ to start at irq_screen_top() (RST8=0)
    lda #(VICII_RST8|VICII_RSEL|VICII_DEN)^$ff
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->RASTER = IRQ_SCREEN_TOP_LINE
    lda #IRQ_SCREEN_TOP_LINE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *HARDWARE_IRQ = &irq_screen_top
    lda #<irq_screen_top
    sta HARDWARE_IRQ
    lda #>irq_screen_top
    sta HARDWARE_IRQ+1
    // VICII->IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE
    // asm
    // Acknowledge any timer IRQ
    lda CIA1_INTERRUPT
    // *IRQ_STATUS = 0x0f
    // Acknowledge any VIC IRQ
    lda #$f
    sta IRQ_STATUS
    // asm
    cli
  __b13:
    // if(pacman_wins || pacman_lives==0)
    lda.z pacman_wins
    bne __breturn
    lda.z pacman_lives
    beq __breturn
    jmp __b13
  __breturn:
    // }
    rts
  __b8:
    // SPRITES_COLOR[i] = top_sprites_color
    lda.z top_sprites_color
    sta SPRITES_COLOR,x
    // for(char i=0;i<8;i++)
    inx
    jmp __b7
  __b5:
    // SPRITES_COLOR[i] = BLACK
    lda #BLACK
    sta SPRITES_COLOR,x
    // for(char i=0;i<8;i++)
    inx
    jmp __b4
  __b2:
    // ((char*)SID)[i] = 0
    lda #0
    sta SID,x
    // for(char i=0;i<0x2f;i++)
    inx
    jmp __b1
}
// Show Victory or Game Over Image 
// Returns when the user clicks the joystick button
done_run: {
    // Show the win graphics
    .label gfx = $59
    .label ypos = 6
    .label xcol = 5
    // game_playable = 0
    // Stop the game play
    lda #0
    sta.z game_playable
    // phase = 0
    // Set phase to intro
    sta.z phase
    tax
  // Stop any sound
  __b2:
    // for(char i=0;i<0x2f;i++)
    cpx #$2f
    bcs !__b3+
    jmp __b3
  !__b3:
    ldx #0
  // Move the bobs to the center to avoid interference while rendering the level
  __b4:
    // for(char i=0;i<4;i++)
    cpx #4
    bcc __b5
    // asm
    // Init music
    lda #0
    // (*musicInit)()
    jsr musicInit
    // if(pacman_wins)
    lda.z pacman_wins
    bne __b1
    // byteboozer_decrunch(GAMEOVER_GFX_CRUNCHED)
    lda #<GAMEOVER_GFX_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>GAMEOVER_GFX_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // decrunch game over graphics 
    jsr byteboozer_decrunch
  __b6:
    lda #<WIN_GFX
    sta.z gfx
    lda #>WIN_GFX
    sta.z gfx+1
    lda #0
    sta.z xcol
  __b8:
    // for(char xcol=0;xcol<25;xcol++)
    lda.z xcol
    cmp #$19
    bcc __b7
    // music_play_next = 0
    // Wait for fire
    lda #0
    sta.z music_play_next
  __b13:
    // joyfire()
    jsr joyfire
    // while(!joyfire())
    cmp #0
    beq __b14
    // }
    rts
  __b14:
    // if(music_play_next)
    lda.z music_play_next
    beq __b13
    // (*musicPlay)()
    //VICII->BG_COLOR=1;
    jsr musicPlay
    // music_play_next = 0
    //VICII->BG_COLOR=0;
    lda #0
    sta.z music_play_next
    jmp __b13
  __b7:
    lda #0
    sta.z ypos
  __b10:
    // for(char ypos=0;ypos<25;ypos++)
    lda.z ypos
    cmp #$19
    bcc __b11
    // for(char xcol=0;xcol<25;xcol++)
    inc.z xcol
    jmp __b8
  __b11:
    // char pixels = *gfx++
    // Render 8px x 1px
    ldy #0
    lda (gfx),y
    tax
    inc.z gfx
    bne !+
    inc.z gfx+1
  !:
    // render(xcol, ypos, pixels)
    stx.z render.pixels
    jsr render
    // for(char ypos=0;ypos<25;ypos++)
    inc.z ypos
    jmp __b10
  __b1:
    // byteboozer_decrunch(WIN_GFX_CRUNCHED)
    lda #<WIN_GFX_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>WIN_GFX_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // decrunch win graphics 
    jsr byteboozer_decrunch
    jmp __b6
  __b5:
    // bobs_xcol[i] = 10
    lda #$a
    sta bobs_xcol,x
    // bobs_yfine[i] = 45
    lda #$2d
    sta bobs_yfine,x
    // bobs_bob_id[i] = 0
    lda #0
    sta bobs_bob_id,x
    // for(char i=0;i<4;i++)
    inx
    jmp __b4
  __b3:
    // ((char*)SID)[i] = 0
    lda #0
    sta SID,x
    // for(char i=0;i<0x2f;i++)
    inx
    jmp __b2
}
// Spawn pacman and all ghosts
spawn_all: {
    // ghosts_mode_count = 0
    lda #0
    sta.z ghosts_mode_count
    // pacman_substep = 0
    sta.z pacman_substep
    // ghost1_substep = 0
    sta.z ghost1_substep
    // ghost2_substep = 0
    sta.z ghost2_substep
    // ghost3_substep = 0
    sta.z ghost3_substep
    // ghost4_substep = 0
    sta.z ghost4_substep
    // pacman_direction = STOP
    lda #STOP
    sta.z pacman_direction
    // ghost1_direction = STOP
    sta.z ghost1_direction
    // ghost2_direction = STOP
    sta.z ghost2_direction
    // ghost3_direction = STOP
    sta.z ghost3_direction
    // ghost4_direction = STOP
    sta.z ghost4_direction
    // pacman_xfine = 50
    lda #$32
    sta.z pacman_xfine
    // ghost1_xfine = 50
    sta.z ghost1_xfine
    // ghost2_xfine = 50
    sta.z ghost2_xfine
    // ghost3_xfine = 50
    sta.z ghost3_xfine
    // ghost4_xfine = 50
    sta.z ghost4_xfine
    // ghost1_yfine = 35
    lda #$23
    sta.z ghost1_yfine
    // ghost2_yfine = 35
    sta.z ghost2_yfine
    // ghost3_yfine = 35
    sta.z ghost3_yfine
    // ghost4_yfine = 35
    sta.z ghost4_yfine
    // pacman_yfine = 62
    lda #$3e
    sta.z pacman_yfine
    // ghost1_respawn = 10
    lda #$a
    sta.z ghost1_respawn
    // ghost2_respawn = 20
    lda #$14
    sta.z ghost2_respawn
    // ghost3_respawn = 30
    lda #$1e
    sta.z ghost3_respawn
    // ghost4_respawn = 40
    lda #$28
    sta.z ghost4_respawn
    // }
    rts
}
// Get the open directions at a given (xtile, ytile) position
// Returns the open DIRECTIONs as bits
// If xtile of ytile is outside the legal range the empty tile (0) is returned
// level_tile_directions(byte register(X) xtile, byte register(A) ytile)
level_tile_directions: {
    .label ytiles = $5b
    // if(xtile>49 || ytile>36)
    cpx #$31+1
    bcs __b1
    cmp #$24+1
    bcs __b1
    // LEVEL_TILES_DIRECTIONS + LEVEL_YTILE_OFFSET[ytile]
    asl
    // char* ytiles = LEVEL_TILES_DIRECTIONS + LEVEL_YTILE_OFFSET[ytile]
    tay
    clc
    lda #<LEVEL_TILES_DIRECTIONS
    adc LEVEL_YTILE_OFFSET,y
    sta.z ytiles
    lda #>LEVEL_TILES_DIRECTIONS
    adc LEVEL_YTILE_OFFSET+1,y
    sta.z ytiles+1
    // return ytiles[xtile];
    txa
    tay
    lda (ytiles),y
    rts
  __b1:
    lda #0
    // }
    rts
}
// Choose the open direction that brings the ghost closest to the target
// Uses Manhattan distance calculation
// choose_direction(byte zp($4f) open_directions, byte register(Y) ghost_xtile, byte zp(4) ghost_ytile, byte register(X) target_xtile, byte zp(3) target_ytile)
choose_direction: {
    .label open_directions = $4f
    .label ghost_ytile = 4
    .label target_ytile = 3
    .label xdiff = $5d
    .label ydiff = 4
    .label dist_left = $50
    .label return = $53
    .label direction = $53
    .label dist_min = $50
    // char xdiff = ghost_xtile-target_xtile
    tya
    stx.z $ff
    sec
    sbc.z $ff
    sta.z xdiff
    // char ydiff = ghost_ytile-target_ytile
    lda.z ydiff
    sec
    sbc.z target_ytile
    sta.z ydiff
    // open_directions&UP
    lda #UP
    and.z open_directions
    // if(open_directions&UP)
    cmp #0
    beq __b5
    // ABS[xdiff] + ABS[ydiff-1]
    ldy.z xdiff
    lda ABS,y
    ldy.z ydiff
    clc
    adc ABS+-1,y
    tay
    // if(dist_up<dist_min)
    cpy #$ff
    bcs __b5
    lda #UP
    sta.z direction
    jmp __b1
  __b5:
    lda #STOP
    sta.z direction
    ldy #$ff
  __b1:
    // open_directions&DOWN
    lda #DOWN
    and.z open_directions
    // if(open_directions&DOWN)
    cmp #0
    beq __b10
    // ABS[xdiff] + ABS[ydiff+1]
    ldx.z xdiff
    lda ABS,x
    ldx.z ydiff
    clc
    adc ABS+1,x
    tax
    // if(dist_down<dist_min)
    sty.z $ff
    cpx.z $ff
    bcs __b11
    lda #DOWN
    sta.z direction
    jmp __b2
  __b11:
    tya
    tax
  __b2:
    // open_directions&LEFT
    lda #LEFT
    and.z open_directions
    // if(open_directions&LEFT)
    cmp #0
    beq __b12
    // ABS[xdiff-1] + ABS[ydiff]
    ldy.z xdiff
    lda ABS+-1,y
    ldy.z ydiff
    clc
    adc ABS,y
    sta.z dist_left
    // if(dist_left<dist_min)
    stx.z $ff
    cmp.z $ff
    bcs __b13
    lda #LEFT
    sta.z direction
    jmp __b3
  __b13:
    stx.z dist_min
  __b3:
    // open_directions&RIGHT
    lda #RIGHT
    and.z open_directions
    // if(open_directions&RIGHT)
    cmp #0
    beq __b4
    // ABS[xdiff+1] + ABS[ydiff]
    ldy.z xdiff
    lda ABS+1,y
    ldy.z ydiff
    clc
    adc ABS,y
    // if(dist_right<dist_min)
    cmp.z dist_min
    bcs __b4
    lda #RIGHT
    sta.z return
    rts
  __b4:
    // }
    rts
  __b12:
    stx.z dist_min
    jmp __b3
  __b10:
    tya
    tax
    jmp __b2
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($63) str, word zp($59) num)
memset: {
    .label end = $59
    .label dst = $63
    .label num = $59
    .label str = $63
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // char* end = (char*)str + num
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    // }
    rts
  __b3:
    // *dst = c
    lda #0
    tay
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Decrunch crunched data using ByteBoozer
// - crunched: Pointer to the start of the crunched data
// byteboozer_decrunch(byte* zp($57) crunched)
byteboozer_decrunch: {
    .label crunched = $57
    // asm
    ldy crunched
    ldx crunched+1
    jsr b2.Decrunch
    // }
    rts
}
// Merge unrolled cycle-exact logic code into an unrolled cycle-exact raster code. 
// The logic-code is merged into the raster code ensuring cycle-exact execution. If a logic-code block does not fit within the remaining cycle-budget of a raster-slot then NOPs/BIT $EA are used to reach the cycle-budget.
// If the logic-code runs out before the raster-code ends then the remaining raster-slots are filled with NOP/BIT$EA.
// If the raster-code runs out before the logic-code then the rest of the logic-code is added at the end.
// An RTS is added at the very end.
//
// Parameters:
// - dest_code: Address where the merged code is placed
// - raster_code: The unrolled raster code blocks with information about cycles to be filled. Format is decribed below.
// - logic_code: The unrolled logic code with information about cycles spent. Format is decribed below.
//
// Format of unrolled raster code. 
// A number of blocks that have the following structure: 
// <nn>* 0xff <cc> 
// <nn>* : some bytes of code. any number of bytes are allowed.
// 0xff  : signals the end of a block.
// <cc>  : If <cc> is 00 then this is the last block of the unrolled raster code. 
//         If <cc> is non-zero it means that <cc> cycles must be spent here (the cycle budget of the slot). The merger merges logic code into the slot and fills with NOP's to match the number of cycles needed.
//
// Format of unrolled logic code.
// A number of blocks that has the following structure: 
// <cc> <nn>* 0xff
// <cc>  : If <cc> is 00 then this is the last block of the unrolled logic code. No more bytes are used.
//         If <cc> is non-zero it holds the number of cycles used by the block of code.
// <nn>* : some bytes of code. any number of bytes are allowed. This code uses exactly the number of cycles specified by <cc>
// 0xff  : signals the end of a block.
// merge_code(byte* zp($b) dest_code, byte* zp($63) raster_code, byte* zp($59) logic_code)
merge_code: {
    // Cycle-count signalling the last block of the logic-code
    .const LOGIC_EXIT = 0
    // Value signalling the end of a block of the logic-code
    .const LOGIC_END = $ff
    // Cycle-count signalling the last block of the raster-code
    .const RASTER_EXIT = 0
    // Value signalling the end of a block of the raster-code
    .const RASTER_END = $ff
    .label dest_code = $b
    .label raster_code = $63
    .label logic_cycles = $60
    .label logic_code = $59
    lda #<LOGIC_CODE_UNMERGED
    sta.z logic_code
    lda #>LOGIC_CODE_UNMERGED
    sta.z logic_code+1
    lda #<RASTER_CODE
    sta.z dest_code
    lda #>RASTER_CODE
    sta.z dest_code+1
    lda #<RASTER_CODE_UNMERGED
    sta.z raster_code
    lda #>RASTER_CODE_UNMERGED
    sta.z raster_code+1
  // Output raster code until meeting RASTER_END signalling the end of a block
  __b1:
    // while(*raster_code!=RASTER_END)
    ldy #0
    lda (raster_code),y
    cmp #RASTER_END
    beq !__b2+
    jmp __b2
  !__b2:
    // raster_code++;
    inc.z raster_code
    bne !+
    inc.z raster_code+1
  !:
    // char cycle_budget = *raster_code++
    // Find the number of cycles
    ldy #0
    lda (raster_code),y
    tax
    inc.z raster_code
    bne !+
    inc.z raster_code+1
  !:
    // if(cycle_budget==RASTER_EXIT)
    cpx #RASTER_EXIT
    bne __b4
  __b3:
  // No more raster code - fill in the rest of the logic code
    // while(*logic_code!=LOGIC_EXIT)
    ldy #0
    lda (logic_code),y
    cmp #LOGIC_EXIT
    bne __b15
    // *dest_code++ = 0x60
    // And add an RTS
    lda #$60
    sta (dest_code),y
    // }
    rts
  __b15:
    // logic_code++;
    inc.z logic_code
    bne !+
    inc.z logic_code+1
  !:
  __b5:
  // Fill in the logic-code
    // while(*logic_code!=LOGIC_END)
    ldy #0
    lda (logic_code),y
    cmp #LOGIC_END
    bne __b18
    // logic_code++;
    inc.z logic_code
    bne !+
    inc.z logic_code+1
  !:
    jmp __b3
  __b18:
    // *dest_code++ = *logic_code++
    ldy #0
    lda (logic_code),y
    sta (dest_code),y
    // *dest_code++ = *logic_code++;
    inc.z dest_code
    bne !+
    inc.z dest_code+1
  !:
    inc.z logic_code
    bne !+
    inc.z logic_code+1
  !:
    jmp __b5
  // Fit the cycle budget with logic-code
  __b4:
    // while(cycle_budget>0)
    cpx #0
    beq __b6
    // char logic_cycles = *logic_code
    // Find the number of logic code cycles
    ldy #0
    lda (logic_code),y
    sta.z logic_cycles
    // cycle_budget-1
    txa
    tay
    dey
    // if(logic_cycles!=LOGIC_EXIT && (logic_cycles < cycle_budget-1 || logic_cycles==cycle_budget))
    lda #LOGIC_EXIT
    cmp.z logic_cycles
    bne __b20
  __b6:
  // Fit the cycle budget with NOPs
  __b10:
    // while(cycle_budget>0)
    cpx #0
    bne __b11
    jmp __b1
  __b11:
    // if(cycle_budget==3)
    cpx #3
    beq __b12
    // *dest_code++ = 0xEA
    lda #$ea
    ldy #0
    sta (dest_code),y
    // *dest_code++ = 0xEA;
    inc.z dest_code
    bne !+
    inc.z dest_code+1
  !:
    // cycle_budget -= 2
    // NOP
    dex
    dex
    jmp __b6
  __b12:
    // *dest_code++ = 0x24
    lda #$24
    ldy #0
    sta (dest_code),y
    // *dest_code++ = 0x24;
    inc.z dest_code
    bne !+
    inc.z dest_code+1
  !:
    // *dest_code++ = 0xEA
    // BIT $EA
    lda #$ea
    ldy #0
    sta (dest_code),y
    // *dest_code++ = 0xEA;
    inc.z dest_code
    bne !+
    inc.z dest_code+1
  !:
    // cycle_budget -= 3
    txa
    axs #3
    jmp __b6
  __b20:
    // if(logic_cycles!=LOGIC_EXIT && (logic_cycles < cycle_budget-1 || logic_cycles==cycle_budget))
    cpy.z logic_cycles
    beq !+
    bcs __b9
  !:
    cpx.z logic_cycles
    beq __b9
    jmp __b10
  __b9:
    // logic_code++;
    inc.z logic_code
    bne !+
    inc.z logic_code+1
  !:
  __b13:
  // Fill in the logic-code
    // while(*logic_code!=LOGIC_END)
    ldy #0
    lda (logic_code),y
    cmp #LOGIC_END
    bne __b7
    // logic_code++;
    inc.z logic_code
    bne !+
    inc.z logic_code+1
  !:
    // cycle_budget -= logic_cycles
    // Reduce the cycle budget
    txa
    sec
    sbc.z logic_cycles
    tax
    jmp __b4
  __b7:
    // *dest_code++ = *logic_code++
    ldy #0
    lda (logic_code),y
    sta (dest_code),y
    // *dest_code++ = *logic_code++;
    inc.z dest_code
    bne !+
    inc.z dest_code+1
  !:
    inc.z logic_code
    bne !+
    inc.z logic_code+1
  !:
    jmp __b13
  __b2:
    // *dest_code++ = *raster_code++
    ldy #0
    lda (raster_code),y
    sta (dest_code),y
    // *dest_code++ = *raster_code++;
    inc.z dest_code
    bne !+
    inc.z dest_code+1
  !:
    inc.z raster_code
    bne !+
    inc.z raster_code+1
  !:
    jmp __b1
}
// Initialize the RENDER_INDEX table from sub-tables
init_render_index: {
    .label __10 = $61
    .label __11 = $61
    .label render_index_xcol = $59
    .label canvas_xcol = $5e
    .label canvas = $61
    .label render_index = $59
    .label x_col = 5
    .label render_index_xcol_1 = $63
    .label y_pos = 6
    // Special column in sprite#9
    .label render_ypos_table = $b
    .label __12 = $61
    lda #<RENDER_INDEX
    sta.z render_index_xcol
    lda #>RENDER_INDEX
    sta.z render_index_xcol+1
    lda #0
    sta.z x_col
  __b1:
    // for(char x_col=0;x_col<26;x_col++)
    lda.z x_col
    cmp #$1a
    bcc __b2
    // (RENDER_INDEX+24*0x100)[RENDER_OFFSET_YPOS_INC] = 0
    // Fix the first entry of the inc_offset in the last column (set it to point to 0,0,6,6...)
    lda #0
    sta RENDER_INDEX+$18*$100+RENDER_OFFSET_YPOS_INC
    // (RENDER_INDEX+25*0x100)[RENDER_OFFSET_YPOS_INC] = 0
    sta RENDER_INDEX+$19*$100+RENDER_OFFSET_YPOS_INC
    // }
    rts
  __b2:
    // if(x_col>=24)
    lda.z x_col
    cmp #$18
    bcc __b3
    ldx #$b
    lda #<RENDER_YPOS_9TH
    sta.z render_ypos_table
    lda #>RENDER_YPOS_9TH
    sta.z render_ypos_table+1
    jmp __b4
  __b3:
    ldx #0
    lda #<RENDER_YPOS
    sta.z render_ypos_table
    lda #>RENDER_YPOS
    sta.z render_ypos_table+1
  __b4:
    // char * canvas_xcol = RENDER_XCOLS[x_col]
    lda.z x_col
    asl
    tay
    lda RENDER_XCOLS,y
    sta.z canvas_xcol
    lda RENDER_XCOLS+1,y
    sta.z canvas_xcol+1
    lda.z render_index_xcol
    sta.z render_index_xcol_1
    lda.z render_index_xcol+1
    sta.z render_index_xcol_1+1
    lda #0
    sta.z y_pos
  __b5:
    // for(char y_pos=0;y_pos<148;y_pos+=2)
    lda.z y_pos
    cmp #$94
    bcc __b6
    // render_index += 0x100
    clc
    lda.z render_index
    adc #<$100
    sta.z render_index
    lda.z render_index+1
    adc #>$100
    sta.z render_index+1
    // for(char x_col=0;x_col<26;x_col++)
    inc.z x_col
    jmp __b1
  __b6:
    // canvas_xcol + render_ypos_table[(unsigned int)y_pos]
    lda.z y_pos
    sta.z __11
    lda #0
    sta.z __11+1
    asl.z __10
    rol.z __10+1
    // char * canvas = canvas_xcol + render_ypos_table[(unsigned int)y_pos]
    lda.z __12
    clc
    adc.z render_ypos_table
    sta.z __12
    lda.z __12+1
    adc.z render_ypos_table+1
    sta.z __12+1
    ldy #0
    clc
    lda (canvas),y
    adc.z canvas_xcol
    pha
    iny
    lda (canvas),y
    adc.z canvas_xcol+1
    sta.z canvas+1
    pla
    sta.z canvas
    // BYTE0(canvas)
    // render_index_xcol[RENDER_OFFSET_CANVAS_LO] = BYTE0(canvas)
    ldy #0
    sta (render_index_xcol_1),y
    // BYTE1(canvas)
    lda.z canvas+1
    // render_index_xcol[RENDER_OFFSET_CANVAS_HI] = BYTE1(canvas)
    ldy #RENDER_OFFSET_CANVAS_HI
    sta (render_index_xcol_1),y
    // render_index_xcol[RENDER_OFFSET_YPOS_INC] = ypos_inc_offset
    ldy #RENDER_OFFSET_YPOS_INC
    txa
    sta (render_index_xcol_1),y
    // ypos_inc_offset += 2
    inx
    inx
    // if(ypos_inc_offset>=23)
    cpx #$17
    bcc __b8
    // ypos_inc_offset-=21
    txa
    axs #$15
  __b8:
    // render_index_xcol++;
    inc.z render_index_xcol_1
    bne !+
    inc.z render_index_xcol_1+1
  !:
    // y_pos+=2
    lda.z y_pos
    clc
    adc #2
    sta.z y_pos
    jmp __b5
}
// Show the splash screen
splash_show: {
    // Show splash screen
    .label splash = $63
    .label ypos = 6
    .label xcol = 5
    lda #<SPLASH
    sta.z splash
    lda #>SPLASH
    sta.z splash+1
    lda #0
    sta.z xcol
  __b1:
    // for(char xcol=0;xcol<25;xcol++)
    lda.z xcol
    cmp #$19
    bcc __b4
    // }
    rts
  __b4:
    lda #0
    sta.z ypos
  __b2:
    // for(char ypos=0;ypos<147;ypos++)
    lda.z ypos
    cmp #$93
    bcc __b3
    // for(char xcol=0;xcol<25;xcol++)
    inc.z xcol
    jmp __b1
  __b3:
    // char pixels = *splash++
    // Render 8px x 1px
    ldy #0
    lda (splash),y
    tax
    inc.z splash
    bne !+
    inc.z splash+1
  !:
    // render(xcol, ypos, pixels)
    stx.z render.pixels
    jsr render
    // for(char ypos=0;ypos<147;ypos++)
    inc.z ypos
    jmp __b2
}
// Initialize bobs_restore with data to prevent crash on the first call
init_bobs_restore: {
    .label CANVAS_HIDDEN = $ea00
    .label bob_restore = $b
    lda #<bobs_restore
    sta.z bob_restore
    lda #>bobs_restore
    sta.z bob_restore+1
    ldx #0
  __b1:
    // for(char bob=0;bob<NUM_BOBS*2;bob++)
    cpx #NUM_BOBS*2
    bcc __b2
    // logic_tile_ptr = LEVEL_TILES + 64*18 + 12
    // Also set the logic tile to something sane
    lda #<LEVEL_TILES+$40*$12+$c
    sta.z logic_tile_ptr
    lda #>LEVEL_TILES+$40*$12+$c
    sta.z logic_tile_ptr+1
    // logic_tile_xcol = 12
    lda #$c
    sta.z logic_tile_xcol
    // logic_tile_yfine = 35
    lda #$23
    sta.z logic_tile_yfine
    // }
    rts
  __b2:
    ldy #0
  __b3:
    // for(char i=0;i<SIZE_BOB_RESTORE;i++)
    cpy #SIZE_BOB_RESTORE
    bcc __b4
    // bob_restore[0] = BYTE0(CANVAS_HIDDEN)
    lda #0
    tay
    sta (bob_restore),y
    // bob_restore[1] = BYTE1(CANVAS_HIDDEN)
    lda #>CANVAS_HIDDEN
    ldy #1
    sta (bob_restore),y
    // bob_restore[3] = BYTE0(CANVAS_HIDDEN)
    lda #0
    ldy #3
    sta (bob_restore),y
    // bob_restore[4] = BYTE1(CANVAS_HIDDEN)
    lda #>CANVAS_HIDDEN
    ldy #4
    sta (bob_restore),y
    // bob_restore += SIZE_BOB_RESTORE
    lda #SIZE_BOB_RESTORE
    clc
    adc.z bob_restore
    sta.z bob_restore
    bcc !+
    inc.z bob_restore+1
  !:
    // for(char bob=0;bob<NUM_BOBS*2;bob++)
    inx
    jmp __b1
  __b4:
    // bob_restore[i] = 0
    lda #0
    sta (bob_restore),y
    // for(char i=0;i<SIZE_BOB_RESTORE;i++)
    iny
    jmp __b3
}
// Initialize sprite pointers on all screens (in both graphics banks)
init_sprite_pointers: {
    .const SPRITE_ID_0 = $ff&(SPRITES_1&$3fff)/$40
    .label sprites_ptr_1 = $b
    .label sprites_ptr_2 = 9
    lda #<SCREENS_2+OFFSET_SPRITE_PTRS
    sta.z sprites_ptr_2
    lda #>SCREENS_2+OFFSET_SPRITE_PTRS
    sta.z sprites_ptr_2+1
    lda #<SCREENS_1+OFFSET_SPRITE_PTRS
    sta.z sprites_ptr_1
    lda #>SCREENS_1+OFFSET_SPRITE_PTRS
    sta.z sprites_ptr_1+1
    ldx #0
  __b1:
    // for(char screen=0;screen<14;screen++)
    cpx #$e
    bcc __b4
    // }
    rts
  __b4:
    ldy #0
  __b2:
    // for(char sprite=0; sprite<8; sprite++)
    cpy #8
    bcc __b3
    // sprites_ptr_1 += 0x400
    clc
    lda.z sprites_ptr_1
    adc #<$400
    sta.z sprites_ptr_1
    lda.z sprites_ptr_1+1
    adc #>$400
    sta.z sprites_ptr_1+1
    // sprites_ptr_2 += 0x400
    clc
    lda.z sprites_ptr_2
    adc #<$400
    sta.z sprites_ptr_2
    lda.z sprites_ptr_2+1
    adc #>$400
    sta.z sprites_ptr_2+1
    // for(char screen=0;screen<14;screen++)
    inx
    jmp __b1
  __b3:
    // SPRITE_ID_0 + screen
    txa
    clc
    adc #SPRITE_ID_0
    // char sprite_id = SPRITE_ID_0 + screen + sprites_id[sprite]
    clc
    adc sprites_id,y
    // sprites_ptr_1[sprite] = sprite_id
    sta (sprites_ptr_1),y
    // sprites_ptr_2[sprite] = sprite_id
    sta (sprites_ptr_2),y
    // for(char sprite=0; sprite<8; sprite++)
    iny
    jmp __b2
  .segment Data
    sprites_id: .byte 0, $70, $60, $50, $40, $30, $20, $10
}
.segment Code
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
memcpy: {
    .label destination = INTRO_MUSIC_CRUNCHED_UPPER
    .label source = INTRO_MUSIC_CRUNCHED
    .label src_end = source+INTRO_MUSIC_CRUNCHED_SIZE
    .label dst = $b
    .label src = 9
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    lda #<source
    sta.z src
    lda #>source
    sta.z src+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp #>src_end
    bne __b2
    lda.z src
    cmp #<src_end
    bne __b2
    // }
    rts
  __b2:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
// Prepare for joystick control
joyinit: {
    // CIA1->PORT_A_DDR = 0x00
    // Joystick  Read Mode
    lda #0
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // }
    rts
}
// Return 1 if joy #2 fire is pressed
joyfire: {
    // CIA1->PORT_A & 0x10
    lda #$10
    and CIA1
    // if( (CIA1->PORT_A & 0x10) == 0 )
    cmp #0
    beq __b1
    lda #0
    rts
  __b1:
    lda #1
    // }
    rts
}
// Initialize the LEVEL_TILES_DIRECTIONS table with bits representing all open (non-blocked) movement directions from a tile
init_level_tile_directions: {
    .label directions = $b
    .label ytile = 5
    .label open_directions = 7
    .label xtile = 6
    lda #<LEVEL_TILES_DIRECTIONS
    sta.z directions
    lda #>LEVEL_TILES_DIRECTIONS
    sta.z directions+1
    lda #0
    sta.z ytile
  __b1:
    // for(char ytile=0;ytile<37;ytile++)
    lda.z ytile
    cmp #$25
    bcc __b4
    // }
    rts
  __b4:
    lda #0
    sta.z xtile
  __b2:
    // for(char xtile=0; xtile<50; xtile++)
    lda.z xtile
    cmp #$32
    bcc __b3
    // directions += 0x40
    lda #$40
    clc
    adc.z directions
    sta.z directions
    bcc !+
    inc.z directions+1
  !:
    // for(char ytile=0;ytile<37;ytile++)
    inc.z ytile
    jmp __b1
  __b3:
    // level_tile_get(xtile-1, ytile)
    ldx.z xtile
    dex
    lda.z ytile
    jsr level_tile_get
    // level_tile_get(xtile-1, ytile)
    tax
    // if(TILES_TYPE[level_tile_get(xtile-1, ytile)]!=WALL)
    lda TILES_TYPE,x
    cmp #WALL
    beq __b9
    lda #LEFT
    sta.z open_directions
    jmp __b5
  __b9:
    lda #0
    sta.z open_directions
  __b5:
    // level_tile_get(xtile+1, ytile)
    ldx.z xtile
    inx
    lda.z ytile
    jsr level_tile_get
    // level_tile_get(xtile+1, ytile)
    tax
    // if(TILES_TYPE[level_tile_get(xtile+1, ytile)]!=WALL)
    lda TILES_TYPE,x
    cmp #WALL
    beq __b6
    // open_directions |= RIGHT
    lda #RIGHT
    ora.z open_directions
    sta.z open_directions
  __b6:
    // level_tile_get(xtile, ytile-1)
    lda.z ytile
    sec
    sbc #1
    ldx.z xtile
    jsr level_tile_get
    // level_tile_get(xtile, ytile-1)
    // if(TILES_TYPE[level_tile_get(xtile, ytile-1)]!=WALL)
    tay
    lda TILES_TYPE,y
    cmp #WALL
    beq __b7
    // open_directions |= UP
    lda #UP
    ora.z open_directions
    sta.z open_directions
  __b7:
    // level_tile_get(xtile, ytile+1)
    lda.z ytile
    clc
    adc #1
    ldx.z xtile
    jsr level_tile_get
    // level_tile_get(xtile, ytile+1)
    // if(TILES_TYPE[level_tile_get(xtile, ytile+1)]!=WALL)
    tay
    lda TILES_TYPE,y
    cmp #WALL
    beq __b8
    // open_directions |= DOWN
    lda #DOWN
    ora.z open_directions
    sta.z open_directions
  __b8:
    // directions[xtile] = open_directions
    lda.z open_directions
    ldy.z xtile
    sta (directions),y
    // for(char xtile=0; xtile<50; xtile++)
    inc.z xtile
    jmp __b2
}
// Show the level by rendering all tiles
// Returns the number of pills on the level
level_show: {
    .label return = $b
    .label level = 9
    .label ytile = 6
    .label tile_right = $60
    .label xtile = 8
    .label count = $b
    .label xcol = 7
    lda #<LEVEL_TILES
    sta.z level
    lda #>LEVEL_TILES
    sta.z level+1
    lda #<0
    sta.z count
    sta.z count+1
    sta.z ytile
  __b1:
    // for(char ytile=0;ytile<37;ytile++)
    lda.z ytile
    cmp #$25
    bcc __b4
    // }
    rts
  __b4:
    lda #0
    sta.z xtile
    sta.z xcol
  __b2:
    // for(char xcol=0, xtile=0; xcol<25; xcol++)
    lda.z xcol
    cmp #$19
    bcc __b3
    // level += 0x40
    lda #$40
    clc
    adc.z level
    sta.z level
    bcc !+
    inc.z level+1
  !:
    // for(char ytile=0;ytile<37;ytile++)
    inc.z ytile
    jmp __b1
  __b3:
    // char tile_left = level[xtile++]
    ldy.z xtile
    lda (level),y
    tax
    iny
    // if(TILES_TYPE[tile_left]==PILL)
    lda TILES_TYPE,x
    cmp #PILL
    bne __b5
    // count++;
    inc.z count
    bne !+
    inc.z count+1
  !:
  __b5:
    // char tile_right = level[xtile++]
    lda (level),y
    sta.z tile_right
    iny
    sty.z xtile
    // if(TILES_TYPE[tile_right]==PILL)
    lda #PILL
    ldy.z tile_right
    cmp TILES_TYPE,y
    bne __b6
    // count++;
    inc.z count
    bne !+
    inc.z count+1
  !:
  __b6:
    // render_tiles(xcol, ytile, tile_left, tile_right)
    ldy.z tile_right
    jsr render_tiles
    // for(char xcol=0, xtile=0; xcol<25; xcol++)
    inc.z xcol
    jmp __b2
}
// Sound effects for pacman
pacman_sound_init: {
    // SID->VOLUME_FILTER_MODE = 0x0f
    // Set master volume
    lda #$f
    sta SID+OFFSET_STRUCT_MOS6581_SID_VOLUME_FILTER_MODE
    // SID->CH1_FREQ = 0
    // Channel 1 is Pacman eating sound
    lda #0
    sta SID+1
    sta SID
    // SID->CH1_PULSE_WIDTH = 0
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH1_PULSE_WIDTH+1
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH1_PULSE_WIDTH
    // SID->CH1_CONTROL = 0
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH1_CONTROL
    // SID->CH1_ATTACK_DECAY = 0
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH1_ATTACK_DECAY
    // SID->CH1_SUSTAIN_RELEASE = 0xf0
    lda #$f0
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH1_SUSTAIN_RELEASE
    // }
    rts
}
// Render graphic pixels into the 9 all-border sprites
// - xcol: x column (0-24). The x-column represents 8 bits of data, 4 mc pixels, 16 on-screen pixels (due to x-expanded sprites)
// - ypos: y position (0-145). The y-position is a line on the screen. Since every second line is black each ypos represents a 2 pixel distance.
// - pixels: The pixel data to set 
// render(byte zp(5) xcol, byte zp(6) ypos, byte zp(8) pixels)
render: {
    .label render_index_xcol = $61
    .label canvas_offset = $b
    .label canvas1 = 9
    .label canvas2 = $b
    .label ypix = $60
    .label xcol = 5
    .label ypos = 6
    .label pixels = 8
    // char ytile = ypos/4
    lda.z ypos
    lsr
    lsr
    tay
    // BYTE1(RENDER_INDEX) + xcol
    lax.z xcol
    axs #-[>RENDER_INDEX]
    // ytile*2
    tya
    asl
    // char * render_index_xcol = (char*){ BYTE1(RENDER_INDEX) + xcol, ytile*2 }
    stx.z render_index_xcol+1
    sta.z render_index_xcol
    // unsigned int canvas_offset = { render_index_xcol[RENDER_OFFSET_CANVAS_HI], render_index_xcol[RENDER_OFFSET_CANVAS_LO] }
    ldy #RENDER_OFFSET_CANVAS_HI
    lda (render_index_xcol),y
    sta.z canvas_offset+1
    ldy #0
    lda (render_index_xcol),y
    sta.z canvas_offset
    // char * canvas1 = SPRITES_1 + canvas_offset
    clc
    adc #<SPRITES_1
    sta.z canvas1
    lda.z canvas_offset+1
    adc #>SPRITES_1
    sta.z canvas1+1
    // char * canvas2 = SPRITES_2 + canvas_offset
    clc
    lda.z canvas2
    adc #<SPRITES_2
    sta.z canvas2
    lda.z canvas2+1
    adc #>SPRITES_2
    sta.z canvas2+1
    // char ypos_inc_offset = render_index_xcol[RENDER_OFFSET_YPOS_INC]
    ldy #RENDER_OFFSET_YPOS_INC
    lda (render_index_xcol),y
    tax
    // char ypix = ypos&3
    lda #3
    and.z ypos
    sta.z ypix
    ldy #0
  __b1:
    // for(char i=0;i<ypix;i++)
    cpy.z ypix
    bcc __b2
    // *canvas1 = pixels
    // Render the pixels
    lda.z pixels
    ldy #0
    sta (canvas1),y
    // *canvas2 = pixels
    sta (canvas2),y
    // }
    rts
  __b2:
    // canvas1 += RENDER_YPOS_INC[ypos_inc_offset]
    lda RENDER_YPOS_INC,x
    clc
    adc.z canvas1
    sta.z canvas1
    bcc !+
    inc.z canvas1+1
  !:
    // canvas2 += RENDER_YPOS_INC[ypos_inc_offset]
    lda RENDER_YPOS_INC,x
    clc
    adc.z canvas2
    sta.z canvas2
    bcc !+
    inc.z canvas2+1
  !:
    // ypos_inc_offset++;
    inx
    // for(char i=0;i<ypix;i++)
    iny
    jmp __b1
}
// Get the level tile at a given (xtile, ytile) position
// Returns the TILE ID
// If xtile of ytile is outside the legal range the empty tile (0) is returned
// level_tile_get(byte register(X) xtile, byte register(A) ytile)
level_tile_get: {
    .label ytiles = $61
    // if(xtile>49 || ytile>36)
    cpx #$31+1
    bcs __b1
    cmp #$24+1
    bcs __b1
    // LEVEL_TILES + LEVEL_YTILE_OFFSET[ytile]
    asl
    // char* ytiles = LEVEL_TILES + LEVEL_YTILE_OFFSET[ytile]
    tay
    clc
    lda #<LEVEL_TILES
    adc LEVEL_YTILE_OFFSET,y
    sta.z ytiles
    lda #>LEVEL_TILES
    adc LEVEL_YTILE_OFFSET+1,y
    sta.z ytiles+1
    // return ytiles[xtile];
    txa
    tay
    lda (ytiles),y
    rts
  __b1:
    lda #0
    // }
    rts
}
// Renders 2x1 tiles on the canvas. 
// Tiles are 4x4 px. This renders 8px x 4px. 
// - xcol: The x column position (0-24) (a column is 8 pixels)
// - ytile: The y tile position (0-37). Tile y position 0 is a special half-tile at the top of the screen.
// - tile_left:  The left tile ID.
// - tile_right:  The right tile ID.
// render_tiles(byte zp(7) xcol, byte zp(6) ytile, byte register(X) tile_left, byte register(Y) tile_right)
render_tiles: {
    .label tile_left_pixels = $61
    .label tile_right_pixels = $63
    .label render_index_xcol = $65
    .label canvas_offset = $5e
    .label canvas1 = $59
    .label canvas2 = $5e
    .label y = $60
    .label xcol = 7
    .label ytile = 6
    // tile_left*4
    txa
    asl
    asl
    // char * tile_left_pixels = TILES_LEFT + tile_left*4
    clc
    adc #<TILES_LEFT
    sta.z tile_left_pixels
    lda #>TILES_LEFT
    adc #0
    sta.z tile_left_pixels+1
    // tile_right*4
    tya
    asl
    asl
    // char * tile_right_pixels = TILES_RIGHT + tile_right*4
    clc
    adc #<TILES_RIGHT
    sta.z tile_right_pixels
    lda #>TILES_RIGHT
    adc #0
    sta.z tile_right_pixels+1
    // BYTE1(RENDER_INDEX) + xcol
    lax.z xcol
    axs #-[>RENDER_INDEX]
    // ytile*2
    lda.z ytile
    asl
    // char * render_index_xcol = (char*){ BYTE1(RENDER_INDEX) + xcol, ytile*2 }
    stx.z render_index_xcol+1
    sta.z render_index_xcol
    // unsigned int canvas_offset = {render_index_xcol[RENDER_OFFSET_CANVAS_HI], render_index_xcol[RENDER_OFFSET_CANVAS_LO] }
    ldy #RENDER_OFFSET_CANVAS_HI
    lda (render_index_xcol),y
    sta.z canvas_offset+1
    ldy #0
    lda (render_index_xcol),y
    sta.z canvas_offset
    // char * canvas1 = SPRITES_1 + canvas_offset
    clc
    adc #<SPRITES_1
    sta.z canvas1
    lda.z canvas_offset+1
    adc #>SPRITES_1
    sta.z canvas1+1
    // char * canvas2 = SPRITES_2 + canvas_offset
    clc
    lda.z canvas2
    adc #<SPRITES_2
    sta.z canvas2
    lda.z canvas2+1
    adc #>SPRITES_2
    sta.z canvas2+1
    // char ypos_inc_offset = render_index_xcol[RENDER_OFFSET_YPOS_INC]
    ldy #RENDER_OFFSET_YPOS_INC
    lda (render_index_xcol),y
    tax
    lda #0
    sta.z y
  __b1:
    // for(char y=0;y<4;y++)
    lda.z y
    cmp #4
    bcc __b2
    // }
    rts
  __b2:
    // char pixels = tile_left_pixels[y] | tile_right_pixels[y]
    ldy.z y
    lda (tile_left_pixels),y
    ora (tile_right_pixels),y
    // *canvas1 = pixels
    ldy #0
    sta (canvas1),y
    // *canvas2 = pixels
    sta (canvas2),y
    // canvas1 += RENDER_YPOS_INC[ypos_inc_offset]
    lda RENDER_YPOS_INC,x
    clc
    adc.z canvas1
    sta.z canvas1
    bcc !+
    inc.z canvas1+1
  !:
    // canvas2 += RENDER_YPOS_INC[ypos_inc_offset]
    lda RENDER_YPOS_INC,x
    clc
    adc.z canvas2
    sta.z canvas2
    bcc !+
    inc.z canvas2+1
  !:
    // ypos_inc_offset++;
    inx
    // for(char y=0;y<4;y++)
    inc.z y
    jmp __b1
}
.segment Data
  // The byteboozer decruncher
BYTEBOOZER:
.const B2_ZP_BASE = $fc
    #import "byteboozer_decrunch.asm"

  // Pacman eating sound
  PACMAN_CH1_FREQ_HI: .byte $23, $1d, $1a, $17, $15, $12, 0, 0, 0, 0, 0, $19, $1a, $1c, $1d, $20, $23, 0, 0, 0, 0, 0
  PACMAN_CH1_CONTROL: .byte $21, $21, $21, $21, $21, $21, 0, 0, 0, 0, 0, $21, $21, $21, $21, $21, $21, 0, 0, 0, 0, 0
  // Address of the first pixel each x column
  RENDER_XCOLS: .word 0, 1, 2, $400, $401, $402, $800, $801, $802, $c00, $c01, $c02, $1000, $1001, $1002, $1400, $1401, $1402, $1800, $1801, $1802, $1c00, $1c01, $1c02, 0, 0
  // Offset for each y-position from the first pixel of an X column
  RENDER_YPOS: .word 0, 0, 0, 6, $c, $12, $18, $1e, $24, $2a, $30, $36, $3c, $40+3, $40+9, $40+$f, $40+$15, $40+$1b, $40+$21, $40+$27, $40+$2d, $40+$33, $40+$39, $80, $80+6, $80+$c, $80+$12, $80+$18, $80+$1e, $80+$24, $80+$2a, $80+$30, $80+$36, $80+$3c, $c0+3, $c0+9, $c0+$f, $c0+$15, $c0+$1b, $c0+$21, $c0+$27, $c0+$2d, $c0+$33, $c0+$39, $100, $100+6, $100+$c, $100+$12, $100+$18, $100+$1e, $100+$24, $100+$2a, $100+$30, $100+$36, $100+$3c, $140+3, $140+9, $140+$f, $140+$15, $140+$1b, $140+$21, $140+$27, $140+$2d, $140+$33, $140+$39, $180, $180+6, $180+$c, $180+$12, $180+$18, $180+$1e, $180+$24, $180+$2a, $180+$30, $180+$36, $180+$3c, $1c0+3, $1c0+9, $1c0+$f, $1c0+$15, $1c0+$1b, $1c0+$21, $1c0+$27, $1c0+$2d, $1c0+$33, $1c0+$39, $200, $200+6, $200+$c, $200+$12, $200+$18, $200+$1e, $200+$24, $200+$2a, $200+$30, $200+$36, $200+$3c, $240+3, $240+9, $240+$f, $240+$15, $240+$1b, $240+$21, $240+$27, $240+$2d, $240+$33, $240+$39, $280, $280+6, $280+$c, $280+$12, $280+$18, $280+$1e, $280+$24, $280+$2a, $280+$30, $280+$36, $280+$3c, $2c0+3, $2c0+9, $2c0+$f, $2c0+$15, $2c0+$1b, $2c0+$21, $2c0+$27, $2c0+$2d, $2c0+$33, $2c0+$39, $300, $300+6, $300+$c, $300+$12, $300+$18, $300+$1e, $300+$24, $300+$2a, $300+$30, $300+$36, $300+$3c, $340+3, $340+9, $340+$f, $340+$15, $340+$1b, $340+$21, $340+$27, $340+$2d, $340+$33, $340+$39
  // Offset for each y-position from the first pixel of an X column in sprite#9
  RENDER_YPOS_9TH: .word 3, 3, 3, 9, $f, $15, $1b, $21, $27, $2d, $33, $39, $40, $40+6, $40+$c, $40+$12, $40+$18, $40+$1e, $40+$24, $40+$2a, $40+$30, $40+$36, $40+$3c, $80+3, $80+9, $80+$f, $80+$15, $80+$1b, $80+$21, $80+$27, $80+$2d, $80+$33, $80+$39, $c0, $c0+6, $c0+$c, $c0+$12, $c0+$18, $c0+$1e, $c0+$24, $c0+$2a, $c0+$30, $c0+$36, $c0+$3c, $100+3, $100+9, $100+$f, $100+$15, $100+$1b, $100+$21, $100+$27, $100+$2d, $100+$33, $100+$39, $140, $140+6, $140+$c, $140+$12, $140+$18, $140+$1e, $140+$24, $140+$2a, $140+$30, $140+$36, $140+$3c, $180+3, $180+9, $180+$f, $180+$15, $180+$1b, $180+$21, $180+$27, $180+$2d, $180+$33, $180+$39, $1c0, $1c0+6, $1c0+$c, $1c0+$12, $1c0+$18, $1c0+$1e, $1c0+$24, $1c0+$2a, $1c0+$30, $1c0+$36, $1c0+$3c, $200+3, $200+9, $200+$f, $200+$15, $200+$1b, $200+$21, $200+$27, $200+$2d, $200+$33, $200+$39, $240, $240+6, $240+$c, $240+$12, $240+$18, $240+$1e, $240+$24, $240+$2a, $240+$30, $240+$36, $240+$3c, $280+3, $280+9, $280+$f, $280+$15, $280+$1b, $280+$21, $280+$27, $280+$2d, $280+$33, $280+$39, $2c0, $2c0+6, $2c0+$c, $2c0+$12, $2c0+$18, $2c0+$1e, $2c0+$24, $2c0+$2a, $2c0+$30, $2c0+$36, $2c0+$3c, $300+3, $300+9, $300+$f, $300+$15, $300+$1b, $300+$21, $300+$27, $300+$2d, $300+$33, $300+$39, $340, $340+6, $340+$c, $340+$12, $340+$18, $340+$1e, $340+$24, $340+$2a, $340+$30, $340+$36, $340+$3c
  // Increment for each y-position from the first pixel of an X column
  .align $20
  RENDER_YPOS_INC: .byte 0, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7
  // The BOB x column position (0-24) (a column is 8 pixels)
  bobs_xcol: .byte $a, $a, $a, $a, $a
  // The BOB y fine position (0-99). The y-position is a line on the screen. Since every second line is black each ypos represents a 2 pixel distance.
  bobs_yfine: .byte $2d, $2d, $2d, $2d, $2d
  // The BOB ID in the BOB data tables
  bobs_bob_id: .byte 0, 0, 0, 0, 0
  // The BOB restore data: 18 bytes per BOB. Doubled for double-buffering.
  // char * left_canvas;
  // char left_ypos_inc_offset;
  // char * right_canvas;
  // char right_ypos_inc_offset;
  // char[12] restore_pixels; 
  .align $100
  bobs_restore: .fill NUM_BOBS*SIZE_BOB_RESTORE*2, 0
.segment Init
  // The level represented as 4x4 px tiles. Each byte is the ID of a tile from the tile set.
  // The level is 50 tiles * 37 tiles. The first tile line are special half-tiles (where only the last 2 pixel rows are shown).
  // The level data is organized as 37 rows of 50 tile IDs.
LEVEL_TILES_CRUNCHED:
.modify B2() {
        .pc = LEVEL_TILES "LEVEL TILE GRAPHICS"
        .var pic_level = LoadPicture("pacman-tiled.png", List().add($000000, $352879, $bfce72, $883932))
        // Maps the tile pixels (a 16 bit number) to the tile ID
        .var TILESET = Hashtable()
        // Maps the tile ID to the pixels (a 16 bit number)
        .var TILESET_BY_ID = Hashtable()
        // Tile ID 0 is empty
        .eval TILESET.put(0, 0)
        .eval TILESET_BY_ID.put(0, 0)

        .align $100
        // TABLE LEVEL_TILES[64*37]
        // The level is 50 tiles * 37 tiles. The first tile line are special half-tiles (where only the last 2 pixel rows are shown).
        // The level data is organized as 37 rows of 64 bytes containing tile IDs. (the last 14 are unused to achieve 64-byte alignment)
        .for(var ytile=0; ytile<37; ytile++) {
            .for(var xtile=0; xtile<50; xtile++) {
                // Find the tile pixels (4x4 px - 16 bits)
                .var pixels = 0;
                .for(var i=0; i<4; i++) {
                    .var pix = pic_level.getMulticolorByte(xtile/2,ytile*4+i)
                    .if((xtile&1)==0) {
                        // left nibble
                        .eval pix = floor(pix / $10)
                    } else {
                        // right nibble
                        .eval pix = pix & $0f
                    }
                    .eval pixels = pixels*$10 + pix                
                }
                .var tile_id = 0
                .if(TILESET.containsKey(pixels)) {
                    .eval tile_id = TILESET.get(pixels)
                } else {
                    .eval tile_id = TILESET.keys().size()
                    .eval TILESET.put(pixels, tile_id)
                    .eval TILESET_BY_ID.put(tile_id, pixels)
//                    .print "tile "+tile_id+" : "+toHexString(pixels,4)
                }
                // Output the tile ID
                .byte tile_id
            }
            .fill 14, 0
        }

        .align $100
        // TABLE char TILES_LEFT[0x80] 
        // The left tile graphics. A tile is 4x4 px. The left tiles contain tile graphics for the 4 left bits of a char. Each tile is 4 bytes.
        .for(var tile_id=0;tile_id<TILESET_BY_ID.keys().size();tile_id++) {
            .var pixels = TILESET_BY_ID.get(tile_id)
            .for(var i=0; i<4; i++) {
                .var pix = (pixels & $f000) >> 12
                .byte pix<<4
                .eval pixels = pixels << 4
            }
        }

        .align $80
        // TABLE char TILES_RIGHT[0x80]
        // The right tile graphics. A tile is 4x4 px. The right tiles contain tile graphics for the 4 right bits of a char. Each tile is 4 bytes.
        .for(var tile_id=0;tile_id<TILESET_BY_ID.keys().size();tile_id++) {
            .var pixels = TILESET_BY_ID.get(tile_id)
            .for(var i=0; i<4; i++) {
                .var pix = (pixels & $f000) >> 12
                .byte pix
                .eval pixels = pixels << 4
            }
        }
        .align $80
        // TABLE char TILES_TYPE[0x20]
        // 0: empty (all black), 1:pill, 2:powerup, 4: wall (contains blue pixels)
        .for(var tile_id=0;tile_id<TILESET_BY_ID.keys().size();tile_id++) {
            .var pixels = TILESET_BY_ID.get(tile_id)
            .var tile_type = 0
            .if(pixels==$0220) .eval tile_type=1 // 1:pill
            .if(pixels==$aaaa) .eval tile_type=2 // 2:powerup
            .for(var i=0; i<4; i++) {
                .var pix = (pixels & $f000) >> 12
                // Detect wall - any blue pixels (%01)
                .if( (pix&%0100)==%0100) .eval tile_type = 4; // 4:wall
                .if( (pix&%0001)==%0001) .eval tile_type = 4; // 4:wall
                .eval pixels = pixels << 4
            }
            .byte tile_type
            //.print "tile "+tile_id+" gfx "+toHexString(TILESET_BY_ID.get(tile_id),4) + " type "+tile_type
        }

    }

  // BOB data: One table per bob byte (left/right, mask/pixels = 4 tables). The index into the table is the bob_id + row*BOB_ROW_SIZE.
BOB_GRAPHICS_CRUNCHED:
.modify B2() {
        .pc = BOB_MASK_LEFT "BOB GRAPHICS TABLES"
        .var bobs_pic = LoadPicture("pacman-bobs.png", List().add($000000, $352879, $bfce72, $883932))
        // TABLE char BOB_MASK_LEFT[BOB_ROW_SIZE*6]
        .for(var row=0; row<6;row++) {
            .align BOB_ROW_SIZE
            .for(var pac=0; pac<9;pac++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(0,scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(0,24+scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(0,48+scroll*6+row)
        }    
        // TABLE char BOB_MASK_RIGT[BOB_ROW_SIZE*6]
        .for(var row=0; row<6;row++) {
            .align BOB_ROW_SIZE
            .for(var pac=0; pac<9;pac++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(1,scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(1,24+scroll*6+row)
            .for(var blue=0; blue<8;blue++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(1,48+scroll*6+row)
        }    
        // TABLE char BOB_PIXEL_LEFT[BOB_ROW_SIZE*6]
        .for(var row=0; row<6;row++) {
            .align BOB_ROW_SIZE
            .for(var pac=0; pac<9;pac++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(2+pac*2,scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(2+ghost*2,24+scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(2+ghost*2,48+scroll*6+row)
        }    
        // TABLE char BOB_PIXEL_RIGT[BOB_ROW_SIZE*6]
        .for(var row=0; row<6;row++) {
            .align BOB_ROW_SIZE
            .for(var pac=0; pac<9;pac++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(3+pac*2,scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(3+ghost*2,24+scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(3+ghost*2,48+scroll*6+row)
        }  
    }  

  // Splash screen 25 xcol * 147 ypos bytes
SPLASH_CRUNCHED:
.modify B2() {
        .pc = SPLASH "SPLASH SCREEN"                           //       00:BLACK, 01:BLUE, 10:YELLOW, 11:RED
        .var pic_splash_mc = LoadPicture("pacman-splash.png", List().add($000000, $352879, $bfce72, $883932))
                                                           //                0:BLACK, 1:YELLOW
        .var pic_splash_yellow = LoadPicture("pacman-splash.png", List().add($000000, $bfce72))
                                                           //                0:BLACK, 1:BLUE
        .var pic_splash_blue = LoadPicture("pacman-splash.png", List().add($000000, $352879))
        .for(var xcol=0; xcol<25; xcol++) {
            .for(var ypos=0; ypos<147; ypos++) {
                .if(ypos>25 && ypos<123) {
                    // Sprites in the sides are in single color blue on splash screen
                    .byte pic_splash_blue.getSinglecolorByte(xcol,ypos)
                } else .if(xcol>2 && xcol<21) {
                    // Sprites 2-7 are in single color yellow on splash screen
                    .byte pic_splash_yellow.getSinglecolorByte(xcol,ypos)
                } else {
                    // Sprites 0&1 are in multi color on splash screen
                    .byte pic_splash_mc.getMulticolorByte(xcol,ypos)
                }
            }        
        }
    }

  // Victory graphics 25 xcol * 25 ypos bytes
WIN_GFX_CRUNCHED:
.modify B2() {
        .pc = WIN_GFX "WIN GRAPHICS"                           //       00:BLACK, 01:BLUE, 10:YELLOW, 11:RED
        .var pic_win = LoadPicture("pacman-win.png", List().add($000000, $352879, $bfce72, $883932))
        .for(var xcol=0; xcol<25; xcol++) {
            .for(var ypos=0; ypos<25; ypos++) {
                .byte pic_win.getMulticolorByte(xcol,ypos)
            }
        }
    }

  // Game Over graphics 25 xcol * 25 ypos bytes
GAMEOVER_GFX_CRUNCHED:
.modify B2() {
        .pc = GAMEOVER_GFX "GAMEOVER GRAPHICS"                           //       00:BLACK, 01:BLUE, 10:YELLOW, 11:RED
        .var pic_gameover = LoadPicture("pacman-gameover.png", List().add($000000, $352879, $bfce72, $883932))
        .for(var xcol=0; xcol<25; xcol++) {
            .for(var ypos=0; ypos<25; ypos++) {
                .byte pic_gameover.getMulticolorByte(xcol,ypos)
            }
        }
    }

  // Renders the BOBs at the given positions
  // The bob logic code will be merged with raster code using code-merger.c
  // First restores the canvas from previously rendered bobs, and then renders the bobs at the given positions.
  // BOBs are 16px*6px graphics  (2 x-columns * 6px) with masks and pixels
  // Uses the bobs_xcol, bobs_yfine, bobs_bob_id and bob_restore for data about the bobs
  // Implemented in inline kick assembler
LOGIC_CODE_CRUNCHED:
.macro LOGIC_BEGIN(cycles) {
        .byte cycles
    }
    .macro LOGIC_END() {
        .byte $ff
    }
    .modify B2() {
        .pc = LOGIC_CODE_UNMERGED "LOGIC CODE UNMERGED"
        LOGIC_BEGIN(2)
        clc
        LOGIC_END()

        // ******************************************
        // Restores the canvas under the rendered bobs
        // ******************************************

        .for(var bob=NUM_BOBS-1;bob>=0; bob--) {
            //LOGIC_BEGIN(6)
            //inc $d021
            //LOGIC_END()

            LOGIC_BEGIN(3)
            ldx bobs_restore_base
            LOGIC_END()
            // char * volatile left_canvas = *((char**)&bob_restore[0]);
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+0,x
            sta.z left_canvas
            LOGIC_END()
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+1,x
            sta.z left_canvas+1            
            LOGIC_END()
            // char left_ypos_inc_offset = bob_restore[2];
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+2,x
            sta.z left_ypos_inc_offset            
            LOGIC_END()
            // char * volatile rigt_canvas = *((char**)&bob_restore[3]);
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+3,x
            sta.z rigt_canvas
            LOGIC_END()
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+4,x
            sta.z rigt_canvas+1
            LOGIC_END()
            // char rigt_ypos_inc_offset = bob_restore[5];
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+5,x
            sta.z rigt_ypos_inc_offset 
            LOGIC_END()

            // Restore Bob Rows 
            LOGIC_BEGIN(2)
            ldy #0
            LOGIC_END()
            .for(var row=0;row<6;row++) {
                //left_canvas += RENDER_YPOS_INC[left_ypos_inc_offset++];
                LOGIC_BEGIN(3)
                ldx.z left_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(5)
                inc.z left_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(18)
                lda RENDER_YPOS_INC,x
                adc.z left_canvas
                sta.z left_canvas
                lda.z left_canvas+1
                adc #0
                sta.z left_canvas+1
                LOGIC_END()
                //rigt_canvas += RENDER_YPOS_INC[rigt_ypos_inc_offset++];
                LOGIC_BEGIN(3)
                ldx.z rigt_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(5)
                inc.z rigt_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(18)
                lda RENDER_YPOS_INC,x
                adc.z rigt_canvas
                sta.z rigt_canvas
                lda.z rigt_canvas+1
                adc #0
                sta.z rigt_canvas+1
                LOGIC_END()

                LOGIC_BEGIN(3)
                ldx bobs_restore_base
                LOGIC_END()            
                // *left_canvas = bob_restore[6] ;
                LOGIC_BEGIN(10)
                lda bobs_restore+SIZE_BOB_RESTORE*bob+6+row,x
                sta (left_canvas),y 
                LOGIC_END()
                // *rigt_canvas = bob_restore[7];
                LOGIC_BEGIN(10)
                lda bobs_restore+SIZE_BOB_RESTORE*bob+12+row,x
                sta (rigt_canvas),y
                LOGIC_END()
            }
        }

        // ******************************************
        // Render two tiles on the canvas
        // ******************************************

        // y==0 from bob restore
        LOGIC_BEGIN(12)
        // char tile_left_idx = 4 * logic_tile_ptr[0];
        lda (logic_tile_ptr),y
        asl
        asl
        sta logic_tile_left_idx
        LOGIC_END()
        // char logic_tile_right_idx = 4 * logic_tile_ptr[1];
        LOGIC_BEGIN(2)
        iny
        LOGIC_END()
        LOGIC_BEGIN(12)
        lda (logic_tile_ptr),y
        asl
        asl
        sta logic_tile_right_idx
        LOGIC_END()    
        // char * render_index_xcol = (char*){ (>RENDER_INDEX) + xcol, ytile*2 };
        LOGIC_BEGIN(8)
        lda #>RENDER_INDEX
        adc logic_tile_xcol
        sta.z left_render_index_xcol+1
        LOGIC_END()
        LOGIC_BEGIN(6)
        lda logic_tile_yfine
        sta.z left_render_index_xcol
        LOGIC_END()

        // unsigned int canvas_offset = {render_index_xcol[RENDER_OFFSET_CANVAS_HI], render_index_xcol[RENDER_OFFSET_CANVAS_LO] };
        // char * left_canvas = canvas_base_hi*$100 + canvas_offset;
        LOGIC_BEGIN(2)
        ldy #RENDER_OFFSET_CANVAS_LO
        LOGIC_END()
        LOGIC_BEGIN(8)
        lda (left_render_index_xcol),y
        sta.z left_canvas
        LOGIC_END()
        LOGIC_BEGIN(2)
        ldy #RENDER_OFFSET_CANVAS_HI
        LOGIC_END()
        LOGIC_BEGIN(11)
        lda (left_render_index_xcol),y
        adc canvas_base_hi
        sta.z left_canvas+1
        LOGIC_END()
        // char left_ypos_inc_offset = render_index_xcol[RENDER_OFFSET_YPOS_INC];
        LOGIC_BEGIN(2)
        ldy #RENDER_OFFSET_YPOS_INC
        LOGIC_END()
        LOGIC_BEGIN(8)
        lda (left_render_index_xcol),y
        sta.z left_ypos_inc_offset            
        LOGIC_END()

        // Render Tile Rows 
        LOGIC_BEGIN(2)
        ldy #0                
        LOGIC_END()  
        .for(var row=0;row<4;row++) {

            //   *left_canvas = tile_left_pixels[y] | tile_right_pixels[y];
            LOGIC_BEGIN(3)
            ldx logic_tile_left_idx
            LOGIC_END()
            LOGIC_BEGIN(17)
            lda TILES_LEFT+row,x
            ldx logic_tile_right_idx
            ora TILES_RIGHT+row,x            
            sta (left_canvas),y
            LOGIC_END()

            //left_canvas += RENDER_YPOS_INC[left_ypos_inc_offset++];
            LOGIC_BEGIN(3)
            ldx.z left_ypos_inc_offset
            LOGIC_END()
            LOGIC_BEGIN(18)
            lda RENDER_YPOS_INC,x
            adc.z left_canvas
            sta.z left_canvas
            lda.z left_canvas+1
            adc #0
            sta.z left_canvas+1
            LOGIC_END()
            LOGIC_BEGIN(5)
            inc.z left_ypos_inc_offset
            LOGIC_END()
        }

        // ******************************************
        // Renders the BOBs at the given positions
        // ******************************************

        .for(var bob=0;bob<NUM_BOBS; bob++) {
            // char * left_render_index_xcol = (char*){ (>RENDER_INDEX) + xcol, yfine };
            // char * rigt_render_index_xcol = (char*){ (>RENDER_INDEX) + xcol+1, yfine };

            //LOGIC_BEGIN(6)
            //inc $d021
            //LOGIC_END()

            LOGIC_BEGIN(14)
            lda #>RENDER_INDEX
            adc bobs_xcol+bob
            sta.z left_render_index_xcol+1
            adc #1
            sta.z rigt_render_index_xcol+1
            LOGIC_END()

            LOGIC_BEGIN(10)
            lda bobs_yfine+bob
            sta.z left_render_index_xcol
            sta.z rigt_render_index_xcol
            LOGIC_END()

            // char * left_canvas = (char*){ left_render_index_xcol[85], left_render_index_xcol[0] };
            // bob_restore[0] = <left_canvas; bob_restore[1] = >left_canvas;
            // char * rigt_canvas = (char*){ rigt_render_index_xcol[85], rigt_render_index_xcol[0] };
            // bob_restore[3] = <rigt_canvas; bob_restore[4] = >rigt_canvas;
            LOGIC_BEGIN(3)
            ldx bobs_restore_base
            LOGIC_END()            
            LOGIC_BEGIN(2)
            ldy #RENDER_OFFSET_CANVAS_LO
            LOGIC_END()
            LOGIC_BEGIN(13)
            lda (left_render_index_xcol),y
            sta.z left_canvas
            sta bobs_restore+SIZE_BOB_RESTORE*bob+0,x
            LOGIC_END()
            LOGIC_BEGIN(13)
            lda (rigt_render_index_xcol),y
            sta.z rigt_canvas
            sta bobs_restore+SIZE_BOB_RESTORE*bob+3,x
            LOGIC_END()
            LOGIC_BEGIN(2)
            ldy #RENDER_OFFSET_CANVAS_HI
            LOGIC_END()
            LOGIC_BEGIN(16)
            lda (left_render_index_xcol),y
            adc canvas_base_hi
            sta.z left_canvas+1
            sta bobs_restore+SIZE_BOB_RESTORE*bob+1,x
            LOGIC_END()
            LOGIC_BEGIN(16)
            lda (rigt_render_index_xcol),y
            adc canvas_base_hi
            sta.z rigt_canvas+1
            sta bobs_restore+SIZE_BOB_RESTORE*bob+4,x
            LOGIC_END()

            // char left_ypos_inc_offset = left_render_index_xcol[170];
            // bob_restore[2] = left_ypos_inc_offset;
            // char rigt_ypos_inc_offset = rigt_render_index_xcol[170];
            // bob_restore[5] = rigt_ypos_inc_offset;            

            LOGIC_BEGIN(2)
            ldy #RENDER_OFFSET_YPOS_INC
            LOGIC_END()
            LOGIC_BEGIN(13)
            lda (left_render_index_xcol),y
            sta.z left_ypos_inc_offset            
            sta bobs_restore+SIZE_BOB_RESTORE*bob+2,x
            LOGIC_END()
            LOGIC_BEGIN(13)
            lda (rigt_render_index_xcol),y
            sta.z rigt_ypos_inc_offset            
            sta bobs_restore+SIZE_BOB_RESTORE*bob+5,x
            LOGIC_END()

            // Render Bob Rows 
            LOGIC_BEGIN(2)
            ldy #0                
            LOGIC_END()  
            .for(var row=0;row<6;row++) {

                //left_canvas += RENDER_YPOS_INC[left_ypos_inc_offset++];
                LOGIC_BEGIN(3)
                ldx.z left_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(18)
                lda RENDER_YPOS_INC,x
                adc.z left_canvas
                sta.z left_canvas
                lda.z left_canvas+1
                adc #0
                sta.z left_canvas+1
                LOGIC_END()
                LOGIC_BEGIN(5)
                inc.z left_ypos_inc_offset
                LOGIC_END()
                //rigt_canvas += RENDER_YPOS_INC[rigt_ypos_inc_offset++];
                LOGIC_BEGIN(3)
                ldx.z rigt_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(18)
                lda RENDER_YPOS_INC,x
                adc.z rigt_canvas
                sta.z rigt_canvas
                lda.z rigt_canvas+1
                adc #0
                sta.z rigt_canvas+1
                LOGIC_END()
                LOGIC_BEGIN(5)
                inc.z rigt_ypos_inc_offset
                LOGIC_END()

                // bob_restore[6] = *left_canvas;
                // *left_canvas = *left_canvas & BOB_MASK_LEFT_0[bob_id] | BOB_PIXEL_LEFT_0[bob_id];
                LOGIC_BEGIN(3)
                ldx bobs_restore_base
                LOGIC_END()            
                LOGIC_BEGIN(10)
                lda (left_canvas),y
                sta bobs_restore+SIZE_BOB_RESTORE*bob+6+row,x
                LOGIC_END()
                LOGIC_BEGIN(10)
                lda (rigt_canvas),y
                sta bobs_restore+SIZE_BOB_RESTORE*bob+12+row,x
                LOGIC_END()

                LOGIC_BEGIN(4)
                ldx bobs_bob_id+bob
                LOGIC_END()
                LOGIC_BEGIN(19)
                lda (left_canvas),y
                and BOB_MASK_LEFT+row*BOB_ROW_SIZE,x
                ora BOB_PIXEL_LEFT+row*BOB_ROW_SIZE,x
                sta (left_canvas),y
                LOGIC_END()
                // bob_restore[7] = *rigt_canvas;
                // *rigt_canvas = *rigt_canvas & BOB_MASK_RIGT_0[bob_id] | BOB_PIXEL_RIGT_0[bob_id];
                LOGIC_BEGIN(19)
                lda (rigt_canvas),y
                and BOB_MASK_RIGT+row*BOB_ROW_SIZE,x
                ora BOB_PIXEL_RIGT+row*BOB_ROW_SIZE,x
                sta (rigt_canvas),y
                LOGIC_END()
            }
        }
        //LOGIC_BEGIN(6)
        //lda #0
        //sta $d021
        //LOGIC_END()

        LOGIC_BEGIN(0) // end of logic code
    }

  // Raster-code for displaying 9 sprites on the entire screen - with open side borders
  // The uncrunched code will be merged with logic code using code-merger.c
  // The unmerged raster-code is identical for both buffers!
RASTER_CODE_CRUNCHED:
.macro RASTER_CYCLES(cycles) {
        .byte $ff, cycles
    }
    .modify B2() {
        .pc = RASTER_CODE_UNMERGED "RASTER CODE UNMERGED"
        RASTER_CYCLES(29)
        // Line 7 cycle 44
        // Raster Line
        .var raster_line = 7    
        // Line in the sprite
        .var sprite_line = 20
        // Current sprite ypos
        .var sprite_ypos = 7
        // Current sprite screen (graphics bank not important since sprite layout in the banks is identical)
        .var sprite_screen = SCREENS_1
        .var available_cycles = 0;
        .for(var i=0;i<293;i++) {
            // Line cycle count            
            .var line_cycles = 46
            .if(raster_line>=70 && raster_line<238) {
                // Only 2 sprites on these lines - so more cycles available
                .eval line_cycles = 58
            }            
            // Create 9th sprite by moving sprite 0
            .if(mod(raster_line,2)==0) {
                lda #$6f            
                sta $d000           
            } else {
                lda #$e7
                sta $d000
            }
            .eval line_cycles -= 6;
            lda #$8
            // Cycle 50. LSR abs is a 6 cycle RWM instruction.
            lsr VICII_CONTROL2  
            sta VICII_CONTROL2
            .eval line_cycles -= 12;
            .eval raster_line++
            .eval sprite_line++
            .if(sprite_line==21) {
                .eval sprite_line = 0
                .eval sprite_ypos += 21
            }
            // Set sprite single-color mode on splash
            .if(raster_line==53) {
                lda side_sprites_mc
                sta $d01c
                lda side_sprites_color
                sta $d027
                sta $d028
                .eval line_cycles -= 18
            }
            // Set sprite multi-color mode on splash
            .if(raster_line==248) {
                lda bottom_sprites_mc
                sta $d01c
                lda bottom_sprites_color
                sta $d027
                sta $d028
                .eval line_cycles -= 18
                //.print "raster:"+raster_line+" multi-color"
            }
            // Open top border
            .if(raster_line==55) {
                lda #VICII_RSEL|VICII_ECM|VICII_BMM|7
                sta VICII_CONTROL1
                .eval line_cycles -= 6
                //.print "raster:"+raster_line+" top border rsel=1"
            }
            // Open bottom border
            .if(raster_line==250) {
                lda #VICII_ECM|VICII_BMM|7 // DEN=0, RSEL=0
                sta VICII_CONTROL1
                .eval line_cycles -= 6
                //.print "raster:"+raster_line+" bottom border rsel=0"
            }
            // Move sprites down
            .if(sprite_line>=2 && sprite_line<=9) {
                .if(sprite_ypos<300) {
                    .var sprite_id = sprite_line-2
                    .if(sprite_id==0 || sprite_id==1 || sprite_ypos<=55 || sprite_ypos>=(246-21)) {
                        lda #sprite_ypos
                        sta SPRITES_YPOS+2*sprite_id
                        .eval line_cycles -= 6;
                        //.print "raster:"+raster_line+" sprite:"+sprite_id+" ypos:"+sprite_ypos
                    }
                }
            }
            // Change sprite data
            .if(sprite_line==20) {
                .eval sprite_screen += $400
                lda #sprite_screen/$40
                sta VICII_MEMORY
                .eval line_cycles -= 6
                //.print "raster:"+raster_line+" sprite data $"+toHexString(sprite_screen)
            }
            // Spend the rest of the cycles on NOPS
            .if(line_cycles<0 || line_cycles==1) .error "Too many cycles spent on line "+raster_line            
            .if(line_cycles>0) {
                //.print "raster:"+raster_line+"  cycles $"+toHexString(line_cycles)                
                RASTER_CYCLES(line_cycles)
                .eval line_cycles -= line_cycles
                .eval available_cycles += line_cycles
            }
        } 
        //.print "Available cycles: "+available_cycles

        lda #$6f            
        sta $d000   
        lda #$8
        // Cycle 50. LSR abs is a 6 cycle RWM instruction.
        lsr VICII_CONTROL2  
        sta VICII_CONTROL2
        RASTER_CYCLES(00) // End of raster code
    }

  // SID tune
  // Pacman 2 channel music by Metal/Camelot
INTRO_MUSIC_CRUNCHED:
.modify B2() {
        .pc = INTRO_MUSIC "INTRO MUSIC"
        .const music = LoadBinary("pacman-2chn-simpler.prg", BF_C64FILE)
        .fill music.getSize(), music.get(i)
    }

.segment Data
  // Offset of the LEVEL_TILE data within the LEVEL_TILE data (each row is 64 bytes of data)
  LEVEL_YTILE_OFFSET: .word 0, $40, $80, $c0, $100, $140, $180, $1c0, $200, $240, $280, $2c0, $300, $340, $380, $3c0, $400, $440, $480, $4c0, $500, $540, $580, $5c0, $600, $640, $680, $6c0, $700, $740, $780, $7c0, $800, $840, $880, $8c0, $900
  // Used to choose a single direction when presented with multiple potential directions.
  // Used to eliminate diagonal joy directions and convert them to a single direction
  // Priority: (4)up, (8)down, (16)left, (32)right
  .align $40
  DIRECTION_SINGLE: .byte 0, 0, 0, 0, 4, 4, 4, 4, 8, 8, 8, 8, 4, 4, 4, 4, $10, $10, $10, $10, 4, 4, 4, 4, 8, 8, 8, 8, 4, 4, 4, 4, $20, $20, $20, $20, 4, 4, 4, 4, 8, 8, 8, 8, 4, 4, 4, 4, $10, $10, $10, $10, 4, 4, 4, 4, 8, 8, 8, 8, 4, 4, 4, 4
  // Used to eliminate a single direction (the one that the ghost came from)
  // The value DIRECTION_ELIMINATE[current_direction] is ANDed onto the open directions to remove the current direction 
  .align $40
  DIRECTION_ELIMINATE: .byte $ff, 0, 0, 0, $f7, 0, 0, 0, $fb, 0, 0, 0, 0, 0, 0, 0, $df, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, $ef
  // Used to reverse direction direction (when a ghost changes between chase and scatter)
  .align $40
  DIRECTION_REVERSE: .byte 0, 0, 0, 0, 8, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, $20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, $10
  // The animation frames for pacman. The index into this is DIRECTION + anim_frame_idx.
  .align $40
  pacman_frames: .byte 8, 8, 8, 8, 8, $18, $14, $18, 8, $20, $1c, $20, 0, 0, 0, 0, 8, 4, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, $c, $10, $c
  // The animation frames for ghost. The index into thos is DIRECTION + anim_frame_idx.
  .align $80
  ghost_frames: .byte 0, 0, 0, 0, $3c, $40, $3c, $40, $34, $38, $34, $38, 0, 0, 0, 0, $2c, $30, $2c, $30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $24, $28, $24, $28, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $5c, $60, $5c, $60, $54, $58, $54, $58, 0, 0, 0, 0, $4c, $50, $4c, $50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $44, $48, $44, $48
  // Lookup the absolute value of a signed number
  // PRE_ and POST_ are used to ensure lookup of ABS-1,y works for y=0 and ABS+1,y works for y=0xff
  .align $100
  ABS_PRE: .byte 1
ABS:
.for(var i=0;i<$100;i++) {
        .var x = (i<$80)?i:($100-i);
        .byte abs(x)
    }

  ABS_POST: .byte 0
