// The Demo collects the parts and handles overall control
  // Commodore 64 PRG executable file
.plugin "se.triad.kickass.CruncherPlugins"
.file [name="new_30_years_low_resolution.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Common, Part2, Part1, InitDemo"]
.segmentdef Basic [start=$0801]
.segmentdef Common [segments="Code, Data"]
.segmentdef   Code [start=$80d]
.segmentdef   Data [startAfter="Code"]
.segmentdef Part2 [segments="CodePart2, DataPart2, InitPart2"]
.segmentdef   CodePart2 [startAfter="Data"]
.segmentdef   DataPart2 [startAfter="CodePart2"]
.segmentdef   InitPart2 [startAfter="DataPart2"]
.segmentdef Part1 [segments="CodePart1, DataPart1, InitPart1"]
.segmentdef   CodePart1 [startAfter="InitPart2"]
.segmentdef   DataPart1 [startAfter="CodePart1"]
.segmentdef   InitPart1 [startAfter="DataPart1"]
.segmentdef InitDemo [startAfter="InitPart1"]
.segment Basic
:BasicUpstart(__start)
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  .const VICII_BMM = $20
  .const VICII_MCM = $10
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in all three areas 0xA000, 0xD000, 0xE000
  .const PROCPORT_RAM_ALL = 0
  // RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  // RAM in 0xA000, 0xE000 CHAR ROM in 0xD000
  .const PROCPORT_RAM_CHARROM = 1
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const RED = 2
  .const CYAN = 3
  .const PURPLE = 4
  .const GREEN = 5
  .const BLUE = 6
  .const YELLOW = 7
  .const BROWN = 9
  .const PINK = $a
  .const GREY = $c
  .const LIGHT_GREEN = $d
  .const LIGHT_BLUE = $e
  .const IRQ_PART1_TOP_LINE = $36
  .const SIZEOF_STRUCT_BUCKETSPRITE = 2
  // -0xFF72
  // Size of the crunched PLEX ID updaters 
  .const PLEX_ID_UPDATERS_CRUNCHED_SIZE = $b72
  // -0xAA2D
  // Size of the crunched PLEX ID updaters 
  .const LOGO_DATA_CRUNCHED_SIZE = $222d
  // Char-based sizes for the logo
  .const LOGO_HEIGHT = $19
  .const LOGO_WIDTH = $50
  // IRQ performing the VSP
  .const IRQ_SWING_VSP_LINE = $2d
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_MC = $1c
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE0_COLOR = $27
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR1 = $25
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR2 = $26
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_XMSB = $10
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITE0_Y = 1
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE = $15
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL1 = $11
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL2 = $16
  .const OFFSET_STRUCT_MOS6569_VICII_MEMORY = $18
  .const OFFSET_STRUCT_BUCKETSPRITE_PLEX_ID = 1
  .const SIZEOF_BYTE = 1
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
  .label SPRITES_COLOR = $d027
  .label SPRITES_ENABLE = $d015
  .label RASTER = $d012
  .label BORDER_COLOR = $d020
  .label BG_COLOR = $d021
  .label VICII_CONTROL = $d011
  .label VICII_CONTROL2 = $d016
  .label VICII_MEMORY = $d018
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The address of the CHARGEN character set
  .label CHARGEN = $d000
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Color Ram
  .label COLS = $d800
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  // CIA#1 Interrupt for reading in ASM
  .label CIA1_INTERRUPT = $dc0d
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  .label P1_COLORS = $a800
  // A800-AFFF 
  .label P1_PIXELS = $c000
  // C000-DFFF
  .label P1_SCREEN = $e000
  // E000-E3FF 
  .label P1_SPRITES = $fc00
  // E000-E3FF 
  .label PIXELS_EMPTY = $e800
  // E800-EFFF
  // A copy of the load screen and colors
  .label LOAD_SCREEN = $e400
  // E400-E7FF
  .label LOAD_CHARSET = $f000
  // F000-F7FF
  .label LOAD_COLORS = $f800
  // Flipper cosine easing table
  .label FLIPPER_EASING = $a400
  // Sprite pointers 
  .label P1_SCREEN_SPRITE_PTRS = $e3f8
  // The screen sprite pointers to update
  .label SCREEN_SPRITE_PTRS = $e3f8
  // Memory layout of the graphics bank
  .label LOGO_DATA = $5400
  .label PART2_BITMAP = $c000
  // -0xdfff
  .label PART2_SCREEN = $e000
  // -0xe400
  .label PART2_SPRITES = $e400
  // -0xf400
  // Location PLEX ID updaters are placed when running
  .label PLEX_ID_UPDATERS = $3c00
  // Location where the crunched PLEX ID updaters are placed to be decrunched
  .label PLEX_ID_UPDATERS_CRUNCHED2 = $7c00
  // Location where the crunched LOGO DATA is placed  to be decrunched
  .label LOGO_DATA_CRUNCHED2 = $8800
  // Address of color data
  .label LOGO_DATA_COLORS = LOGO_DATA+LOGO_HEIGHT*LOGO_WIDTH
  // Address of pixel data
  .label LOGO_DATA_BITMAP = LOGO_DATA_COLORS+LOGO_HEIGHT*LOGO_WIDTH
  // The high-value table
  .label XMOVEMENT_HI = XMOVEMENT+$200
  .label DEMO_MUSIC = $ac00
  // Pointer to the music init routine
  .label musicInit = DEMO_MUSIC
  // Pointer to the music play routine
  .label musicPlay = DEMO_MUSIC+3
  // Signals the main() loop to do work when all rasters are complete
  .label p1_work_ready = 9
  // Top of the flipper
  .label irq_flipper_top_line = $a
  // Bottom of the flipper
  .label irq_flipper_bottom_line = $c
  // 1 if flipper is done
  .label flipper_done = $e
  // Middle of the flipper
  .label irq_flipper_idx = $f
  // The current char line where the flipper switches from bitmap to text
  .label flipper_charline = $11
  // The number of chars to scroll the screen by VSP. 
  // Legal values are 0-40.
  //  0 shows the normal screen (no scrolling)
  // 20 shows char #20 in the top left corner of the screen, effectively scrolling the screen left 20 chars.
  .label vsp_scroll = $12
  // The next "real" sprite being used by the multiplexer
  .label plex_real_sprite_idx = $13
  // Signals the main() loop to do work when all rasters are complete
  .label p2_work_ready = $14
  // 1 if the logo is being revealed
  .label p2_logo_revealing = $15
  // 1 if the logo is completely revealed
  .label p2_logo_reveal_done = $16
  // 1 if the logo is being showed
  .label p2_logo_swinging = $17
  // 1 if the scroll is moving
  .label p2_plex_scroller_moving = $18
  // Number of columns shown of the logo
  .label p2_logo_reveal_idx = $19
  // X-movement index
  .label x_movement_idx = $1a
  // The next char to use from the scroll text
  .label scroll_text_next = $1b
  // The current frame ID (0-7)
  .label plex_frame_id = $1d
  // Pointer to the buckets of the current frame
  .label plex_frame = $1e
  // Offset added to plex_id to ensure the sprite cycling works (decreased 1 every time a cycle is complete)
  .label plex_id_offset = $20
  // Pointer to the current bucket of the current frame
  .label plex_bucket = $21
  // Index of the current bucket in the current frame (0..BUCKET_COUNT-1)
  .label plex_bucket_id = $23
  // The fine scroll (0-7)
  .label vsp_fine_scroll = $24
  // The coarse scroll (0-40)
  .label vsp_coarse_scroll = $25
  // Index into the VSP sinus value
  .label vsp_sin_idx = $26
  // Index into the sprite color sequence
  .label sprite_color_idx = $27
  // Counts total demo frames
  .label demo_frame_count = $28
  // Is the sparkler active
  .label sparkler_active = $2a
  // The sparkler sprite idx
  .label sparkler_idx = $2b
.segment Code
__start: {
    // p1_work_ready = 0
    lda #0
    sta.z p1_work_ready
    // irq_flipper_top_line = 0x00
    sta.z irq_flipper_top_line
    sta.z irq_flipper_top_line+1
    // irq_flipper_bottom_line = 0x08
    lda #<8
    sta.z irq_flipper_bottom_line
    lda #>8
    sta.z irq_flipper_bottom_line+1
    // flipper_done = 0
    sta.z flipper_done
    // irq_flipper_idx = 0x00
    sta.z irq_flipper_idx
    sta.z irq_flipper_idx+1
    // flipper_charline = 0
    sta.z flipper_charline
    // vsp_scroll = 0
    sta.z vsp_scroll
    // plex_real_sprite_idx = 0
    sta.z plex_real_sprite_idx
    // p2_work_ready
    sta.z p2_work_ready
    // p2_logo_revealing = 0
    sta.z p2_logo_revealing
    // p2_logo_reveal_done = 0
    sta.z p2_logo_reveal_done
    // p2_logo_swinging = 0
    sta.z p2_logo_swinging
    // p2_plex_scroller_moving = 0
    sta.z p2_plex_scroller_moving
    // p2_logo_reveal_idx = 0
    sta.z p2_logo_reveal_idx
    // x_movement_idx = 0
    sta.z x_movement_idx
    // scroll_text_next = SCROLL_TEXT
    lda #<SCROLL_TEXT
    sta.z scroll_text_next
    lda #>SCROLL_TEXT
    sta.z scroll_text_next+1
    // plex_frame_id = 0
    lda #0
    sta.z plex_frame_id
    // plex_frame = BUCKET_SPRITES
    lda #<BUCKET_SPRITES
    sta.z plex_frame
    lda #>BUCKET_SPRITES
    sta.z plex_frame+1
    // plex_id_offset = 0
    lda #0
    sta.z plex_id_offset
    // plex_bucket = BUCKET_SPRITES
    lda #<BUCKET_SPRITES
    sta.z plex_bucket
    lda #>BUCKET_SPRITES
    sta.z plex_bucket+1
    // plex_bucket_id = 0
    lda #0
    sta.z plex_bucket_id
    // vsp_fine_scroll
    sta.z vsp_fine_scroll
    // vsp_coarse_scroll
    sta.z vsp_coarse_scroll
    // vsp_sin_idx = 0x40
    lda #$40
    sta.z vsp_sin_idx
    // sprite_color_idx = 0
    lda #0
    sta.z sprite_color_idx
    // demo_frame_count = 0
    sta.z demo_frame_count
    sta.z demo_frame_count+1
    // sparkler_active = 0
    sta.z sparkler_active
    // sparkler_idx = 0
    sta.z sparkler_idx
    jsr main
    rts
}
// IRQ running during between parts
irq_demo: {
    .label port_value = $2c
    sta rega+1
    stx regx+1
    sty regy+1
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Remember processor port value
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // port_value = *PROCPORT
    lda PROCPORT
    sta.z port_value
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Enable IO
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // demo_work()
    // Perform any demo work
    jsr demo_work
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Restore processor port value
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = port_value
    lda.z port_value
    sta PROCPORT
    // }
  rega:
    lda #0
  regx:
    ldx #0
  regy:
    ldy #0
    rti
}
.segment CodePart2
// Show sprites from the multiplexer, rescheduling the IRQ for each bucket
irq_swing_plex: {
    // Move to the next frame of the plexer
    .const YMOVE = 3
    .label __7 = $2d
    .label __26 = $2d
    .label __27 = $2d
    .label scroll = $2d
    .label new_coarse_scroll = $2f
    .label x_offset = $30
    .label __31 = $2d
    sta rega+1
    stx regx+1
    sty regy+1
    // plexBucketShow(plex_bucket)
    lda.z plex_bucket
    sta.z plexBucketShow.bucket
    lda.z plex_bucket+1
    sta.z plexBucketShow.bucket+1
  //*BORDER_COLOR = DARK_GREY;
  // Show the bucket
    jsr plexBucketShow
    // plex_bucket += BUCKET_SIZE
    // Move forward to the next bucket
    lda #8*SIZEOF_STRUCT_BUCKETSPRITE
    clc
    adc.z plex_bucket
    sta.z plex_bucket
    bcc !+
    inc.z plex_bucket+1
  !:
    // plex_bucket_id++;
    inc.z plex_bucket_id
    // if(plex_bucket_id<BUCKET_COUNT)
    lda.z plex_bucket_id
    cmp #9
    bcs !__b1+
    jmp __b1
  !__b1:
    // *HARDWARE_IRQ = &irq_swing_top
    // We are done with this frame - finish it and perform other stuff!
    //VICII->BORDER_COLOR = RED;
    // Set up the TOP IRQ
    lda #<irq_swing_top
    sta HARDWARE_IRQ
    lda #>irq_swing_top
    sta HARDWARE_IRQ+1
    // *RASTER = BUCKET_YPOS[0]
    lda BUCKET_YPOS
    sta RASTER
    // plex_frame_id += YMOVE
    lax.z plex_frame_id
    axs #-[YMOVE]
    stx.z plex_frame_id
    // plex_frame += (unsigned int)YMOVE*BUCKET_COUNT*BUCKET_SIZE
    clc
    lda.z plex_frame
    adc #<YMOVE*9*8*SIZEOF_STRUCT_BUCKETSPRITE
    sta.z plex_frame
    lda.z plex_frame+1
    adc #>YMOVE*9*8*SIZEOF_STRUCT_BUCKETSPRITE
    sta.z plex_frame+1
    // if(plex_frame_id>=FRAME_COUNT)
    txa
    cmp #8
    bcc __b5
    // plex_frame -= BUCKET_COUNT*BUCKET_SIZE*FRAME_COUNT
    // Reset to start of cycle 
    lda.z plex_frame
    sec
    sbc #<9*8*8*SIZEOF_STRUCT_BUCKETSPRITE
    sta.z plex_frame
    lda.z plex_frame+1
    sbc #>9*8*8*SIZEOF_STRUCT_BUCKETSPRITE
    sta.z plex_frame+1
    // plex_frame_id -= FRAME_COUNT
    lax.z plex_frame_id
    axs #8
    stx.z plex_frame_id
    // plex_id_offset--;
    dec.z plex_id_offset
  __b5:
    // update_frame_plex_id_offset(plex_frame_id)
    lda.z plex_frame_id
    // Update plex_id in the next frame
    //VICII->BORDER_COLOR = BLUE;
    jsr update_frame_plex_id_offset
    // if(p2_logo_swinging)
    lda.z p2_logo_swinging
    cmp #0
    beq __b6
    // scroll = VSP_SINTABLE[(unsigned int)(vsp_sin_idx++)]
    lda.z vsp_sin_idx
    sta.z __27
    lda #0
    sta.z __27+1
    asl.z __26
    rol.z __26+1
    clc
    lda.z __31
    adc #<VSP_SINTABLE
    sta.z __31
    lda.z __31+1
    adc #>VSP_SINTABLE
    sta.z __31+1
    // Update the VSP value with a sinus
    ldy #0
    lda (scroll),y
    pha
    iny
    lda (scroll),y
    sta.z scroll+1
    pla
    sta.z scroll
    inc.z vsp_sin_idx
    // (char)scroll&7
    and #7
    // vsp_fine_scroll = (char)scroll&7
    sta.z vsp_fine_scroll
    // scroll/8
    lsr.z __7+1
    ror.z __7
    lsr.z __7+1
    ror.z __7
    lsr.z __7+1
    ror.z __7
    // new_coarse_scroll = (char)(scroll/8)
    lda.z __7
    sta.z new_coarse_scroll
    // coarse_scroll_diff = vsp_coarse_scroll - new_coarse_scroll
    lda.z vsp_coarse_scroll
    sec
    sbc.z new_coarse_scroll
    // if(coarse_scroll_diff==0x01)
    // Update screen column (if needed)
    cmp #1
    beq __b7
    // if(coarse_scroll_diff==0xff)
    cmp #$ff
    bne __b8
    // x_offset = 0x27-vsp_coarse_scroll
    lda #$27
    sec
    sbc.z vsp_coarse_scroll
    sta.z x_offset
    // vsp_update_screen(x_offset)
    sta.z vsp_update_screen.x_offset
    jsr vsp_update_screen
    // (PART2_SCREEN+24*40)[x_offset] = 0
    // Clear line 25 - because the start of the last line was over-written by line #24 chars 40-80
    lda #0
    ldy.z x_offset
    sta PART2_SCREEN+$18*$28,y
    // (COLS+24*40)[x_offset] = 0
    //(LOGO_DATA_SCREEN+24*80)[x_offset];
    sta COLS+$18*$28,y
  __b8:
    // vsp_coarse_scroll = new_coarse_scroll
    lda.z new_coarse_scroll
    sta.z vsp_coarse_scroll
    // 40-vsp_coarse_scroll
    lda #$28
    sec
    sbc.z vsp_coarse_scroll
    // vsp_scroll = 40-vsp_coarse_scroll
    sta.z vsp_scroll
  __b6:
    // if(p2_plex_scroller_moving)
    lda.z p2_plex_scroller_moving
    cmp #0
    beq __b9
    // plex_scroller_move()
    jsr plex_scroller_move
    // if(++sprite_color_idx == sizeof(SPRITE_COLOR_SEQUENCE))
    inc.z sprite_color_idx
    lda #$30*SIZEOF_BYTE
    cmp.z sprite_color_idx
    bne __b3
    // sprite_color_idx = 0
    lda #0
    sta.z sprite_color_idx
  __b3:
    ldx #0
  __b10:
    // for(char s=0;s<8;s++)
    cpx #8
    bcc __b11
  __b9:
    // p2_work_ready = 1
    // Signal the main routine
    lda #1
    sta.z p2_work_ready
  __b2:
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #0
  regx:
    ldx #0
  regy:
    ldy #0
    rti
  __b11:
    // SPRITES_COLOR[s] = SPRITE_COLOR_SEQUENCE[sprite_color_idx]
    ldy.z sprite_color_idx
    lda SPRITE_COLOR_SEQUENCE,y
    sta SPRITES_COLOR,x
    // for(char s=0;s<8;s++)
    inx
    jmp __b10
  __b7:
    // x_offset = 0x50-vsp_coarse_scroll
    lda #$50
    sec
    sbc.z vsp_coarse_scroll
    // vsp_update_screen(x_offset)
    sta.z vsp_update_screen.x_offset
    // Only move 24 - because the last line is empty (and holds sprite pointers)
    jsr vsp_update_screen
    jmp __b8
  __b1:
    // *HARDWARE_IRQ = &irq_swing_plex
    // Not done with the frame yet - set up the next PLEX IRQ (handles the rest of the multiplexer buckets)
    lda #<irq_swing_plex
    sta HARDWARE_IRQ
    lda #>irq_swing_plex
    sta HARDWARE_IRQ+1
    // *RASTER = BUCKET_YPOS[plex_bucket_id]
    ldy.z plex_bucket_id
    lda BUCKET_YPOS,y
    sta RASTER
    jmp __b2
}
// Show sprites from the multiplexer, rescheduling the IRQ as many times as needed
irq_swing_vsp: {
    sta rega+1
    stx regx+1
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
        .align $100
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
        // Raster is now completely stable! (Line $2f cycle 7)
        // Perform VSP by waiting an exact number of cycles and then enabling the display
        // See http://www.zimmers.net/cbmpics/cbm/c64/vic-ii.txt (Section 3.14.6. DMA delay)
        ldx #8          // Wait 45 cycles to get the VSP timing right
        !: dex
        bne !-
        nop
        nop
        lda vsp_scroll
        lsr         //  Put bit 0 into carry 
        bcc dma1    // Spend 2 or 3 cycles depending on the carry (bit 0)
    dma1:
        sta dma2+1  // Update the branch
        clv
    dma2:
        bvc dma2    // This branch is updated with vsp_scroll/2 - changing the number of NOP's executed
        // 20 NOP's - enabling vsp scroll from 0-40
        .fill 20, NOP
        ldx #$18
        lda #$1b  // TODO: To control Y-scrolling this must be flexible!
        // The STX $d011 must be line $30 cycle $10 for vsp_scroll==0
        stx VICII_CONTROL // Enable the display - starts DMA
        sta VICII_CONTROL
    
    // VICII->CONTROL1 |= VICII_BMM
    // Set BMM
    lda #VICII_BMM
    ora VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // vsp_fine_scroll | VICII_MCM
    lda #VICII_MCM
    ora.z vsp_fine_scroll
    // VICII->CONTROL2 = vsp_fine_scroll | VICII_MCM
    // Set fine scroll (and MCM)
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    // *IRQ_STATUS = IRQ_RASTER
    //*BORDER_COLOR = DARK_GREY;
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // *HARDWARE_IRQ = &irq_swing_plex
    // Set up the PLEX IRQ (handles the rest of the multiplexer buckets)
    lda #<irq_swing_plex
    sta HARDWARE_IRQ
    lda #>irq_swing_plex
    sta HARDWARE_IRQ+1
    // *RASTER = BUCKET_YPOS[1]
    lda BUCKET_YPOS+1
    sta RASTER
    // }
  rega:
    lda #0
  regx:
    ldx #0
    rti
}
// Inititialize plex frame and show first bucket
irq_swing_top: {
    sta rega+1
    stx regx+1
    sty regy+1
    // plexFrameStart()
    //*BORDER_COLOR = DARK_GREY;
    //VICII->BORDER_COLOR++;
    // Initialize the multiplexer frame
    jsr plexFrameStart
    // plex_bucket = plex_frame
    lda.z plex_frame
    sta.z plex_bucket
    lda.z plex_frame+1
    sta.z plex_bucket+1
    // plex_bucket_id = 0
    lda #0
    sta.z plex_bucket_id
    // plexBucketShow(plex_bucket)
    lda.z plex_bucket
    sta.z plexBucketShow.bucket
    lda.z plex_bucket+1
    sta.z plexBucketShow.bucket+1
  // Show the first bucket
    jsr plexBucketShow
    // plex_bucket += BUCKET_SIZE
    // Move forward to the next bucket
    lda #8*SIZEOF_STRUCT_BUCKETSPRITE
    clc
    adc.z plex_bucket
    sta.z plex_bucket
    bcc !+
    inc.z plex_bucket+1
  !:
    // plex_bucket_id++;
    inc.z plex_bucket_id
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // *HARDWARE_IRQ = &irq_swing_vsp
    // Set up the VSP IRQ
    lda #<irq_swing_vsp
    sta HARDWARE_IRQ
    lda #>irq_swing_vsp
    sta HARDWARE_IRQ+1
    // *RASTER = IRQ_SWING_VSP_LINE
    lda #IRQ_SWING_VSP_LINE
    sta RASTER
    // }
  rega:
    lda #0
  regx:
    ldx #0
  regy:
    ldy #0
    rti
}
.segment CodePart1
// IRQ running during set-up
// Flips from start screen to bitmap (starts the start-up screen)
irq_flipper_bottom: {
    .const toD0181_return = (>(LOAD_SCREEN&$3fff)*4)|(>LOAD_CHARSET)/4&$f
    .label __7 = $35
    .label __9 = $37
    .label __12 = $33
    .label irq_flipper_line = $33
    .label __14 = $33
    sta rega+1
    stx regx+1
    sty regy+1
    // asm
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    // <irq_flipper_bottom_line
    lda.z irq_flipper_bottom_line
    // (<irq_flipper_bottom_line)&7
    and #7
    // raster_fine((<irq_flipper_bottom_line)&7)
    sta.z raster_fine.line_offset
    jsr raster_fine
    // asm
    // Colors
    nop
    nop
    nop
    nop
    // VICII->BORDER_COLOR = LIGHT_BLUE
    lda #LIGHT_BLUE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->BG_COLOR = BLUE
    lda #BLUE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // VICII->MEMORY = toD018(LOAD_SCREEN, LOAD_CHARSET)
    // Show default screen
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // if(!flipper_done)
    lda.z flipper_done
    cmp #0
    bne __b1
    // irq_flipper_line = FLIPPER_EASING[irq_flipper_idx++]
    lda.z irq_flipper_idx
    asl
    sta.z __12
    lda.z irq_flipper_idx+1
    rol
    sta.z __12+1
    clc
    lda.z __14
    adc #<FLIPPER_EASING
    sta.z __14
    lda.z __14+1
    adc #>FLIPPER_EASING
    sta.z __14+1
    // Move the flipper down    
    ldy #0
    lda (irq_flipper_line),y
    pha
    iny
    lda (irq_flipper_line),y
    sta.z irq_flipper_line+1
    pla
    sta.z irq_flipper_line
    inc.z irq_flipper_idx
    bne !+
    inc.z irq_flipper_idx+1
  !:
    // if(irq_flipper_line<8)
    // Check limits
    lda.z irq_flipper_line+1
    bne !+
    lda.z irq_flipper_line
    cmp #8
    bcc __b4
  !:
    // irq_flipper_line-8
    sec
    lda.z irq_flipper_line
    sbc #8
    sta.z __7
    lda.z irq_flipper_line+1
    sbc #0
    sta.z __7+1
    // irq_flipper_top_line = irq_flipper_line-8
    lda.z __7
    sta.z irq_flipper_top_line
    lda.z __7+1
    sta.z irq_flipper_top_line+1
  __b5:
    // if(irq_flipper_line>0x128)
    lda #>$128
    cmp.z irq_flipper_line+1
    bcc __b6
    bne !+
    lda #<$128
    cmp.z irq_flipper_line
    bcc __b6
  !:
    // irq_flipper_line+8
    lda #8
    clc
    adc.z irq_flipper_line
    sta.z __9
    lda #0
    adc.z irq_flipper_line+1
    sta.z __9+1
    // irq_flipper_bottom_line = irq_flipper_line+8
    lda.z __9
    sta.z irq_flipper_bottom_line
    lda.z __9+1
    sta.z irq_flipper_bottom_line+1
  __b7:
    // if(irq_flipper_line==0x130)
    lda.z irq_flipper_line+1
    cmp #>$130
    bne __b1
    lda.z irq_flipper_line
    cmp #<$130
    bne __b1
    // flipper_done = 1
    lda #1
    sta.z flipper_done
  __b1:
    // *VICII_CONTROL |=0x80
    // Set up the IRQ again
    lda #$80
    ora VICII_CONTROL
    sta VICII_CONTROL
    // *RASTER = IRQ_PART1_TOP_LINE
    lda #IRQ_PART1_TOP_LINE
    sta RASTER
    // *HARDWARE_IRQ = &irq_part1_top
    lda #<irq_part1_top
    sta HARDWARE_IRQ
    lda #>irq_part1_top
    sta HARDWARE_IRQ+1
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #0
  regx:
    ldx #0
  regy:
    ldy #0
    rti
  __b6:
    // irq_flipper_bottom_line = 0x130
    lda #<$130
    sta.z irq_flipper_bottom_line
    lda #>$130
    sta.z irq_flipper_bottom_line+1
    jmp __b7
  __b4:
    // irq_flipper_top_line = 0
    lda #<0
    sta.z irq_flipper_top_line
    sta.z irq_flipper_top_line+1
    jmp __b5
}
// IRQ running during set-up
// Flips from start screen to bitmap (stops the bitmap)
irq_flipper_top: {
    sta rega+1
    stx regx+1
    sty regy+1
    // asm
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    // <irq_flipper_top_line
    lda.z irq_flipper_top_line
    // (<irq_flipper_top_line)&7
    and #7
    // raster_fine((<irq_flipper_top_line)&7)
    sta.z raster_fine.line_offset
    jsr raster_fine
    // asm
    lda #$9a
    ldx #LIGHT_GREEN
    ldy #$1b
    sta VICII_MEMORY
    stx BORDER_COLOR
    sty VICII_CONTROL
    stx BG_COLOR
    lda #$c8
    sta VICII_CONTROL2
    // >irq_flipper_bottom_line
    lda.z irq_flipper_bottom_line+1
    // if(>irq_flipper_bottom_line)
    // Set up the flipper IRQ
    cmp #0
    bne __b1
    // *VICII_CONTROL &= 0x7f
    lda #$7f
    and VICII_CONTROL
    sta VICII_CONTROL
  __b2:
    // <irq_flipper_bottom_line
    lda.z irq_flipper_bottom_line
    // (<irq_flipper_bottom_line)&0xf8
    and #$f8
    // *RASTER = (<irq_flipper_bottom_line)&0xf8
    sta RASTER
    // *HARDWARE_IRQ = &irq_flipper_bottom
    lda #<irq_flipper_bottom
    sta HARDWARE_IRQ
    lda #>irq_flipper_bottom
    sta HARDWARE_IRQ+1
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #0
  regx:
    ldx #0
  regy:
    ldy #0
    rti
  __b1:
    // *VICII_CONTROL |= 0x80
    lda #$80
    ora VICII_CONTROL
    sta VICII_CONTROL
    jmp __b2
}
// IRQ running during set-up
irq_part1_top: {
    .const toDd001_return = 0
    .const toD0181_return = >(P1_SCREEN&$3fff)*4
    sta rega+1
    // VICII->BORDER_COLOR = BLACK
    // Colors
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->BG_COLOR = BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // VICII->CONTROL1 |= VICII_BMM
    // Set BMM
    lda #VICII_BMM
    ora VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->CONTROL2 |= VICII_MCM
    // Set MCM
    lda #VICII_MCM
    ora VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    // CIA2->PORT_A = toDd00(P1_SCREEN)
    // Change graphics bank
    lda #toDd001_return
    sta CIA2
    // VICII->MEMORY = toD018(P1_SCREEN, P1_PIXELS)
    // Show screen
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // >irq_flipper_top_line
    lda.z irq_flipper_top_line+1
    // if(>irq_flipper_top_line)
    // Set up the flipper IRQ
    cmp #0
    bne __b1
    // *VICII_CONTROL &= 0x7f
    lda #$7f
    and VICII_CONTROL
    sta VICII_CONTROL
  __b2:
    // <irq_flipper_top_line
    lda.z irq_flipper_top_line
    // (<irq_flipper_top_line)&0xf8
    and #$f8
    // *RASTER = (<irq_flipper_top_line)&0xf8
    sta RASTER
    // *HARDWARE_IRQ = &irq_flipper_top
    lda #<irq_flipper_top
    sta HARDWARE_IRQ
    lda #>irq_flipper_top
    sta HARDWARE_IRQ+1
    // p1_work_ready = 1
    // Signal main routine to play music    
    lda #1
    sta.z p1_work_ready
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #0
    rti
  __b1:
    // *VICII_CONTROL |= 0x80
    lda #$80
    ora VICII_CONTROL
    sta VICII_CONTROL
    jmp __b2
}
.segment Code
main: {
    // demo_init()
  // Initialize the demo - start the IRQ
    jsr demo_init
    // byteboozer_decrunch(DEMO_MUSIC_CRUNCHED)
    lda #<DEMO_MUSIC_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>DEMO_MUSIC_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch music
    jsr byteboozer_decrunch
    // asm
    // Init music
    lda #0
    // (*musicInit)()
    jsr musicInit
    // demo_start()
  // Initialize the demo - start the IRQ
    jsr demo_start
    // part1_init()
    // Initialize Part 1 (Revealing "Happy New Year" logo)
    jsr part1_init
  // Start part 1 at 0:04,5
  __b1:
    // while(demo_frame_count<5*50)
    lda.z demo_frame_count+1
    bne !+
    lda.z demo_frame_count
    cmp #5*$32
    bcc __b1
  !:
    // part1_run()
  // Run Part 1 (Revealing "Happy New Year" logo)
    jsr part1_run
    // part2_init()
    // Initialize part 2
    jsr part2_init
  // Wait for the right place to start part 2
  __b3:
    // while(demo_frame_count<16*50)
    lda.z demo_frame_count+1
    cmp #>$10*$32
    bcc __b3
    bne !+
    lda.z demo_frame_count
    cmp #<$10*$32
    bcc __b3
  !:
    // sparkler_active = 0
    // Disable sparkler
    lda #0
    sta.z sparkler_active
    // part2_run()
  // Run part 2
    jsr part2_run
  __b5:
    jmp __b5
}
// Work to be performed every frame while the demo runs
// Assumes that I/O is enabled
demo_work: {
    // demo_frame_count++;
    inc.z demo_frame_count
    bne !+
    inc.z demo_frame_count+1
  !:
    // (*musicPlay)()
    // Play music
    jsr musicPlay
    // if(sparkler_active)
    lda.z sparkler_active
    cmp #0
    beq __breturn
    // sparkler_anim()
    jsr sparkler_anim
  __breturn:
    // }
    rts
}
.segment CodePart2
// Show the sprites in a specific bucket
// - bucket: The bucket to show
// plexBucketShow(struct BucketSprite* zp(2) bucket)
plexBucketShow: {
    .label i = $3b
    .label bucket = 2
    // real_idx = plex_real_sprite_idx*2
    lda.z plex_real_sprite_idx
    asl
    tax
    ldy #0
  __b1:
    // while(bucket_ptr[i])
    lda (bucket),y
    cmp #0
    bne __b2
  __b5:
    // real_idx/2
    txa
    lsr
    // plex_real_sprite_idx = real_idx/2
    sta.z plex_real_sprite_idx
    // }
    rts
  __b2:
    // SPRITES_YPOS[real_idx] = bucket_ptr[i++]
    lda (bucket),y
    sta SPRITES_YPOS,x
    // SPRITES_YPOS[real_idx] = bucket_ptr[i++];
    iny
    sty.z i
    // plex_id = bucket_ptr[i]
    lda (bucket),y
    tay
    // SPRITES_XPOS[real_idx] = PLEX_XPOS[plex_id]
    lda PLEX_XPOS,y
    sta SPRITES_XPOS,x
    // real_idx /= 2
    txa
    lsr
    tax
    // if(PLEX_XPOS_MSB[plex_id])
    lda PLEX_XPOS_MSB,y
    cmp #0
    bne __b3
    // *SPRITES_XMSB &= MSB_CLEAR_MASK_BY_ID[real_idx]
    lda SPRITES_XMSB
    and MSB_CLEAR_MASK_BY_ID,x
    sta SPRITES_XMSB
  __b4:
    // SCREEN_SPRITE_PTRS[real_idx] = PLEX_PTR[plex_id]
    lda PLEX_PTR,y
    sta SCREEN_SPRITE_PTRS,x
    // real_idx+1
    inx
    txa
    // real_idx = (real_idx+1)&7
    and #7
    // real_idx *= 2
    asl
    tax
    // i++;
    ldy.z i
    iny
    // if(i==BUCKET_SIZE*sizeof(struct BucketSprite))
    cpy #8*SIZEOF_STRUCT_BUCKETSPRITE
    beq __b5
    jmp __b1
  __b3:
    // *SPRITES_XMSB |= MSB_SET_MASK_BY_ID[real_idx]
    lda SPRITES_XMSB
    ora MSB_SET_MASK_BY_ID,x
    sta SPRITES_XMSB
    jmp __b4
  .segment DataPart2
    // Masks used for MSB
    MSB_SET_MASK_BY_ID: .byte 1, 2, 4, 8, $10, $20, $40, $80
    MSB_CLEAR_MASK_BY_ID: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
}
.segment CodePart2
// Update the plex_id's of a multiplexer frame to reflect a specific plex_id_offset
// update_frame_plex_id_offset(byte register(A) plex_frame_id)
update_frame_plex_id_offset: {
    .label jmp_table = PLEX_ID_UPDATERS
    .label jmp_address = $3c
    // jmp_address = jmp_table[plex_frame_id]
    asl
    tay
    lda jmp_table,y
    sta.z jmp_address
    lda jmp_table+1,y
    sta.z jmp_address+1
    // kickasm
    lda jmp_address
        sta call+1
        lda jmp_address+1
        sta call+2
        call: jsr $0000
    
    // }
    rts
}
// Update screen, colors and bitmap with a single column of new data
// - x_offset is the offset of the column to update (0-79)
// vsp_update_screen(byte zp($31) x_offset)
vsp_update_screen: {
    .label x_offset = $31
    .label x_offset8 = $40
    .label __0 = $3e
    .label __5 = $3e
    // kickasm
    // Update screen and colors
    ldx x_offset
        .for(var row=0;row<24;row++) {
            lda LOGO_DATA+80*row,x
            sta PART2_SCREEN+40*row,x
            lda LOGO_DATA_COLORS+80*row,x
            sta COLS+40*row,x
        }
    
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable I/O (BITMAP is below I/O)
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_ALL
    lda #PROCPORT_RAM_ALL
    sta PROCPORT
    // (unsigned int)x_offset*8
    lda.z x_offset
    sta.z __5
    lda #0
    sta.z __5+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    // x_offset8 = (unsigned int)x_offset*8
    // Update bitmap (using 3 routines to handle all bitmap columns)
    lda.z __0
    sta.z x_offset8
    lda.z __0+1
    sta.z x_offset8+1
    // >x_offset8
    // if(>x_offset8 == 0)
    cmp #0
    bne !__b1+
    jmp __b1
  !__b1:
    // >x_offset8
    // if(>x_offset8 == 1)
    cmp #1
    bne !__b2+
    jmp __b2
  !__b2:
    // kickasm
    // >x_offset8 == 2
    ldx x_offset
            ldy x_offset8
            .for(var row=0;row<24;row++)
                .for(var pix=0;pix<8;pix++) {
                    lda LOGO_DATA_BITMAP+80*(row*8+pix),x
                    sta PART2_BITMAP+$200+row*40*8+pix,y
                }
        
  __b3:
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // }
    rts
  __b2:
    // kickasm
    ldx x_offset
            ldy x_offset8
            .for(var row=0;row<24;row++)
                .for(var pix=0;pix<8;pix++) {
                    lda LOGO_DATA_BITMAP+80*(row*8+pix),x
                    sta PART2_BITMAP+$100+row*40*8+pix,y
                }
        
    jmp __b3
  __b1:
    ldx x_offset
            ldy x_offset8
            .for(var row=0;row<24;row++)
                .for(var pix=0;pix<8;pix++) {
                    lda LOGO_DATA_BITMAP+80*(row*8+pix),x
                    sta PART2_BITMAP+row*40*8+pix,y
                }
        
    jmp __b3
}
// Scroll the plex sprites to the left.
plex_scroller_move: {
    .const toSpritePtr1_return = $ff&PART2_SPRITES/$40
    .label s = $2f
    // x_idx = x_movement_idx
    ldx.z x_movement_idx
    lda #0
    sta.z s
  __b1:
    // for(char s=0; s<PLEX_COUNT;s++)
    lda.z s
    cmp #$20
    bcc __b2
    // x_movement_idx++;
    inc.z x_movement_idx
    // }
    rts
  __b2:
    // PLEX_XPOS[s] = XMOVEMENT[x_idx]
    lda XMOVEMENT,x
    ldy.z s
    sta PLEX_XPOS,y
    // PLEX_XPOS_MSB[s] = XMOVEMENT_HI[x_idx]
    lda XMOVEMENT_HI,x
    sta PLEX_XPOS_MSB,y
    // if(x_idx==0)
    cpx #0
    bne __b4
    // if(*scroll_text_next==0x00)
    ldy #0
    lda (scroll_text_next),y
    cmp #0
    bne __b5
    // scroll_text_next = SCROLL_TEXT
    lda #<SCROLL_TEXT
    sta.z scroll_text_next
    lda #>SCROLL_TEXT
    sta.z scroll_text_next+1
  __b5:
    // letter = *scroll_text_next++
    // Read next char from the scroll text
    ldy #0
    lda (scroll_text_next),y
    inc.z scroll_text_next
    bne !+
    inc.z scroll_text_next+1
  !:
    // if(letter==0xff)
    cmp #$ff
    bne __b9
    lda #0
  __b9:
    // SPRITE_0+letter
    clc
    adc #toSpritePtr1_return
    // PLEX_PTR[s] = SPRITE_0+letter
    // Add the letter
    ldy.z s
    sta PLEX_PTR,y
  __b4:
    // x_idx +=8
    txa
    axs #-[8]
    // for(char s=0; s<PLEX_COUNT;s++)
    inc.z s
    jmp __b1
}
// Start a new frame (initializing data structures)
plexFrameStart: {
    // plex_real_sprite_idx = 0
    lda #0
    sta.z plex_real_sprite_idx
    // }
    rts
}
.segment CodePart1
// Waits until at the exact start of raster line 
// Excepts to start at a line divisible by 8 (0x00, 0x08, x010, ...). 
// Waits line_offset (0-7) additional lines.
// raster_fine(byte zp($32) line_offset)
raster_fine: {
    .label line_offset = $32
    // kickasm
    jmp aligned
        .align $100
    aligned:
        ldy RASTER
        ldx line_offset
        inx
    rst:
        nop 
        nop 
        nop 
        nop
        dex                             // 2
        beq done                        // 2
        lda RASTER_BADLINES,y           // 4
        beq notbad                      // 3
    bad:
        nop                             // 2
        nop 
        nop 
        nop 
        nop
        dex                             
        beq done                        
        iny                             
        nop                             
        bit $ea                         
    notbad:
        .fill 18, NOP
        bit $ea
        iny                             
        jmp rst                         
    done:
    
    // }
    rts
}
.segment Code
// Initialize demo code. 
// Can be called multiple times!
// Setting IRQ to the "demo" IRQ running outside the parts and 
// Setting memory to IO + RAM (no kernal/basic)
demo_init: {
    // asm
    sei
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
    // asm
    // Acknowledge any timer IRQ
    lda CIA1_INTERRUPT
    // *IRQ_STATUS = 0x0f
    // Acknowledge any VIC IRQ
    lda #$f
    sta IRQ_STATUS
    // }
    rts
}
// Decrunch crunched data using ByteBoozer
// - crunched: Pointer to the start of the crunched data
// byteboozer_decrunch(byte* zp($39) crunched)
byteboozer_decrunch: {
    .label crunched = $39
    // asm
    ldy crunched
    ldx crunched+1
    jsr b2.Decrunch
    // }
    rts
}
// Start the demo IRQ. Can be called multiple times!
// Setting IRQ to the "demo" IRQ running outside the parts and 
// Setting memory to IO + RAM (no kernal/basic)
demo_start: {
    // demo_init()
    jsr demo_init
    // *VICII_CONTROL &= 0x7f
    // Set raster line to 0x00
    lda #$7f
    and VICII_CONTROL
    sta VICII_CONTROL
    // *RASTER = 0
    lda #0
    sta RASTER
    // *HARDWARE_IRQ = &irq_demo
    // Set the IRQ routine
    lda #<irq_demo
    sta HARDWARE_IRQ
    lda #>irq_demo
    sta HARDWARE_IRQ+1
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // asm
    cli
    // }
    rts
}
.segment CodePart1
part1_init: {
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable IO
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_ALL
    lda #PROCPORT_RAM_ALL
    sta PROCPORT
    // byteboozer_decrunch(P1_PIXELS_CRUNCHED)
    lda #<P1_PIXELS_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>P1_PIXELS_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch pixels
    jsr byteboozer_decrunch
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Enable IO, Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // byteboozer_decrunch(P1_SCREEN_CRUNCHED)
    lda #<P1_SCREEN_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>P1_SCREEN_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch screen
    jsr byteboozer_decrunch
    // byteboozer_decrunch(P1_COLORS_CRUNCHED)
    lda #<P1_COLORS_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>P1_COLORS_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch colors
    jsr byteboozer_decrunch
    // byteboozer_decrunch(P1_SPRITES_CRUNCHED)
    lda #<P1_SPRITES_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>P1_SPRITES_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch sprites
    jsr byteboozer_decrunch
    // byteboozer_decrunch(FLIPPER_EASING_CRUNCHED)
    lda #<FLIPPER_EASING_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>FLIPPER_EASING_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch flipper sine table
    jsr byteboozer_decrunch
    // init_rasters()
  // Initialize the badlines
    jsr init_rasters
    // memset(PIXELS_EMPTY, 0x00, 0x800)
  // Fill some empty pixels
    ldx #0
    lda #<PIXELS_EMPTY
    sta.z memset.str
    lda #>PIXELS_EMPTY
    sta.z memset.str+1
    lda #<$800
    sta.z memset.num
    lda #>$800
    sta.z memset.num+1
    jsr memset
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Enable CHARGEN, Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_CHARROM
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    // memcpy(LOAD_CHARSET, CHARGEN, 0x800)
    lda #<$800
    sta.z memcpy.num
    lda #>$800
    sta.z memcpy.num+1
    lda #<LOAD_CHARSET
    sta.z memcpy.destination
    lda #>LOAD_CHARSET
    sta.z memcpy.destination+1
    lda #<CHARGEN
    sta.z memcpy.source
    lda #>CHARGEN
    sta.z memcpy.source+1
    jsr memcpy
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Enable IO, Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // memcpy(LOAD_SCREEN, DEFAULT_SCREEN, 0x0400)
  // Copy loading screen 
    lda #<$400
    sta.z memcpy.num
    lda #>$400
    sta.z memcpy.num+1
    lda #<LOAD_SCREEN
    sta.z memcpy.destination
    lda #>LOAD_SCREEN
    sta.z memcpy.destination+1
    lda #<DEFAULT_SCREEN
    sta.z memcpy.source
    lda #>DEFAULT_SCREEN
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(LOAD_COLORS, COLS, 1000)
  // Copy loading  colors
    lda #<$3e8
    sta.z memcpy.num
    lda #>$3e8
    sta.z memcpy.num+1
    lda #<LOAD_COLORS
    sta.z memcpy.destination
    lda #>LOAD_COLORS
    sta.z memcpy.destination+1
    lda #<COLS
    sta.z memcpy.source
    lda #>COLS
    sta.z memcpy.source+1
    jsr memcpy
    // }
    rts
}
part1_run: {
    .const toSpritePtr1_return = $ff&P1_SPRITES/$40
    // asm
    sei
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
    // asm
    // Acknowledge any timer IRQ
    lda CIA1_INTERRUPT
    // *IRQ_STATUS = 0x0f
    // Acknowledge any VIC IRQ
    lda #$f
    sta IRQ_STATUS
    // *VICII_CONTROL |= 0x80
    // Set raster line to 0x136
    lda #$80
    ora VICII_CONTROL
    sta VICII_CONTROL
    // *RASTER = IRQ_PART1_TOP_LINE
    lda #IRQ_PART1_TOP_LINE
    sta RASTER
    // *HARDWARE_IRQ = &irq_part1_top
    // Set the IRQ routine
    lda #<irq_part1_top
    sta HARDWARE_IRQ
    lda #>irq_part1_top
    sta HARDWARE_IRQ+1
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // VICII->SPRITES_MC = 0x01
    // Show Sparkler 
    lda #1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MC
    // VICII->SPRITE0_COLOR = PINK
    lda #PINK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE0_COLOR
    // VICII->SPRITES_MCOLOR1 = YELLOW
    lda #YELLOW
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR1
    // VICII->SPRITES_MCOLOR2 = PURPLE
    lda #PURPLE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR2
    // VICII->SPRITES_XMSB = 0x01
    lda #1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_XMSB
    // VICII->SPRITE0_X = 22
    // 262
    lda #$16
    sta VICII
    // VICII->SPRITE0_Y = 190
    // 262
    lda #$be
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE0_Y
    // P1_SCREEN_SPRITE_PTRS[0] = toSpritePtr(P1_SPRITES)
    // 144
    lda #toSpritePtr1_return
    sta P1_SCREEN_SPRITE_PTRS
    // asm
    cli
    // part1_loop()
    jsr part1_loop
    // }
    rts
}
.segment CodePart2
part2_init: {
    .const toSpritePtr1_return = $ff&PART2_SPRITES/$40
    // Prepare 8 frames of y-positions into BUCKET_SPRITES
    .label frame = $46
    .label frame_idx = 4
    // byteboozer_decrunch(SPRITES_CRUNCHED)
    lda #<SPRITES_CRUNCHED
    sta.z byteboozer_decrunch.crunched
    lda #>SPRITES_CRUNCHED
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch sprites
    jsr byteboozer_decrunch
    // memcpy(LOGO_DATA_CRUNCHED2, LOGO_DATA_CRUNCHED, LOGO_DATA_CRUNCHED_SIZE)
  // Move the crunched logo data out of harms way
    lda #<LOGO_DATA_CRUNCHED_SIZE
    sta.z memcpy.num
    lda #>LOGO_DATA_CRUNCHED_SIZE
    sta.z memcpy.num+1
    lda #<LOGO_DATA_CRUNCHED2
    sta.z memcpy.destination
    lda #>LOGO_DATA_CRUNCHED2
    sta.z memcpy.destination+1
    lda #<LOGO_DATA_CRUNCHED
    sta.z memcpy.source
    lda #>LOGO_DATA_CRUNCHED
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(PLEX_ID_UPDATERS_CRUNCHED2, PLEX_ID_UPDATERS_CRUNCHED, PLEX_ID_UPDATERS_CRUNCHED_SIZE)
  // Move the crunched plex updaters out of harms way
    lda #<PLEX_ID_UPDATERS_CRUNCHED_SIZE
    sta.z memcpy.num
    lda #>PLEX_ID_UPDATERS_CRUNCHED_SIZE
    sta.z memcpy.num+1
    lda #<PLEX_ID_UPDATERS_CRUNCHED2
    sta.z memcpy.destination
    lda #>PLEX_ID_UPDATERS_CRUNCHED2
    sta.z memcpy.destination+1
    lda #<PLEX_ID_UPDATERS_CRUNCHED
    sta.z memcpy.source
    lda #>PLEX_ID_UPDATERS_CRUNCHED
    sta.z memcpy.source+1
    jsr memcpy
    // byteboozer_decrunch(PLEX_ID_UPDATERS_CRUNCHED2)
    lda #<PLEX_ID_UPDATERS_CRUNCHED2
    sta.z byteboozer_decrunch.crunched
    lda #>PLEX_ID_UPDATERS_CRUNCHED2
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch multiplexer frame updaters (from new location)
    jsr byteboozer_decrunch
    // byteboozer_decrunch(LOGO_DATA_CRUNCHED2)
    lda #<LOGO_DATA_CRUNCHED2
    sta.z byteboozer_decrunch.crunched
    lda #>LOGO_DATA_CRUNCHED2
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch logo data
    jsr byteboozer_decrunch
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Empty the hidden part of the bitmap   
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_ALL
    lda #PROCPORT_RAM_ALL
    sta PROCPORT
    // memset(PART2_BITMAP+8000, 0, 192)
    ldx #0
    lda #<PART2_BITMAP+$1f40
    sta.z memset.str
    lda #>PART2_BITMAP+$1f40
    sta.z memset.str+1
    lda #<$c0
    sta.z memset.num
    lda #>$c0
    sta.z memset.num+1
    jsr memset
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // memset(COLS, BLACK, 1024)
  // Empty screen & cols
    ldx #BLACK
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    lda #<$400
    sta.z memset.num
    lda #>$400
    sta.z memset.num+1
    jsr memset
    // memset(PART2_SCREEN, BLACK, 1000)
    ldx #BLACK
    lda #<PART2_SCREEN
    sta.z memset.str
    lda #>PART2_SCREEN
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    // VICII->SPRITE0_COLOR = GREY
    // Fade the sparkler
    lda #GREY
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITE0_COLOR
    // VICII->SPRITES_MCOLOR1 = BROWN
    lda #BROWN
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR1
    // VICII->SPRITES_MCOLOR2 = BLUE
    lda #BLUE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MCOLOR2
    // plexPrepareInit()
  // Initialize PLEX tables
    jsr plexPrepareInit
    lda #<BUCKET_SPRITES
    sta.z frame
    lda #>BUCKET_SPRITES
    sta.z frame+1
    lda #0
    sta.z frame_idx
  __b1:
    // for(char frame_idx=0;frame_idx<8;frame_idx++)
    lda.z frame_idx
    cmp #8
    bcc __b2
    // memcpy(ORIGINAL_BUCKET_SPRITES, BUCKET_SPRITES, sizeof(BUCKET_SPRITES))
  // Copy the original buckets 
    lda #<8*9*8*SIZEOF_STRUCT_BUCKETSPRITE
    sta.z memcpy.num
    lda #>8*9*8*SIZEOF_STRUCT_BUCKETSPRITE
    sta.z memcpy.num+1
    lda #<ORIGINAL_BUCKET_SPRITES
    sta.z memcpy.destination
    lda #>ORIGINAL_BUCKET_SPRITES
    sta.z memcpy.destination+1
    lda #<BUCKET_SPRITES
    sta.z memcpy.source
    lda #>BUCKET_SPRITES
    sta.z memcpy.source+1
    jsr memcpy
    ldx #0
  // Set the initial sprite pointers
  __b7:
    // for(char s=0;s<PLEX_COUNT;s++)
    cpx #$20
    bcc __b12
    // VICII->SPRITES_XMSB = 0x00
    // Disable sparkler
    lda #0
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_XMSB
    // VICII->SPRITE0_X = 0x00
    sta VICII
    // VICII->SPRITES_ENABLE = 0x00
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE
    // VICII->SPRITES_MC = 0x00
    // Set sprite colors
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_MC
    tax
  __b9:
    // for(char s=0;s<8;s++)
    cpx #8
    bcc __b10
    // memset(PART2_SCREEN+1000, BLACK, 24)
  // Empty the rest of the screen    
    ldx #BLACK
    lda #<PART2_SCREEN+$3e8
    sta.z memset.str
    lda #>PART2_SCREEN+$3e8
    sta.z memset.str+1
    lda #<$18
    sta.z memset.num
    lda #>$18
    sta.z memset.num+1
    jsr memset
    // }
    rts
  __b10:
    // SPRITES_COLOR[s] = WHITE
    lda #WHITE
    sta SPRITES_COLOR,x
    // for(char s=0;s<8;s++)
    inx
    jmp __b9
  __b12:
    // PLEX_PTR[s] = SPRITE_0+' '
    lda #toSpritePtr1_return+' '
    sta PLEX_PTR,x
    // for(char s=0;s<PLEX_COUNT;s++)
    inx
    jmp __b7
  __b2:
    ldx.z frame_idx
    ldy #0
  __b4:
    // for(char s=0; s<PLEX_COUNT;s++)
    cpy #$20
    bcc __b5
    // plexPrepareFrame(frame)
    lda.z frame
    sta.z plexPrepareFrame.frame
    lda.z frame+1
    sta.z plexPrepareFrame.frame+1
  // Perform bucket sort
    jsr plexPrepareFrame
    // frame += BUCKET_SIZE*BUCKET_COUNT
    // Move to Next frame
    lda #8*9*SIZEOF_STRUCT_BUCKETSPRITE
    clc
    adc.z frame
    sta.z frame
    bcc !+
    inc.z frame+1
  !:
    // for(char frame_idx=0;frame_idx<8;frame_idx++)
    inc.z frame_idx
    jmp __b1
  __b5:
    // PLEX_YPOS[s] = SCROLL_YSIN[sin_idx]
    lda SCROLL_YSIN,x
    sta PLEX_YPOS,y
    // sin_idx += 8
    txa
    axs #-[8]
    // for(char s=0; s<PLEX_COUNT;s++)
    iny
    jmp __b4
}
part2_run: {
    .const toDd001_return = 0
    .const toD0181_return = >(PART2_SCREEN&$3fff)*4
    // asm
    sei
    // VICII->BORDER_COLOR = BLACK
    // Colors
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->BG_COLOR = BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // CIA2->PORT_A = toDd00(PART2_SCREEN)
    // Change graphics bank
    lda #toDd001_return
    sta CIA2
    // VICII->MEMORY = toD018(PART2_SCREEN, PART2_BITMAP)
    // Show screen
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // VICII->CONTROL1 |= VICII_BMM
    // Set bitmap mode
    lda #VICII_BMM
    ora VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // *SPRITES_ENABLE = 0xff
    // Enable & initialize sprites
    lda #$ff
    sta SPRITES_ENABLE
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // asm
    // Acknowledge any timer IRQ
    lda CIA1_INTERRUPT
    // *IRQ_STATUS = 0x0f
    // Acknowledge any VIC IRQ
    lda #$f
    sta IRQ_STATUS
    // *VICII_CONTROL &=0x7f
    // Set raster line to first bucket
    lda #$7f
    and VICII_CONTROL
    sta VICII_CONTROL
    // *RASTER = BUCKET_YPOS[0]
    lda BUCKET_YPOS
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *HARDWARE_IRQ = &irq_swing_top
    // Set the IRQ routine
    lda #<irq_swing_top
    sta HARDWARE_IRQ
    lda #>irq_swing_top
    sta HARDWARE_IRQ+1
    // asm
    cli
    // plex_frame_id = 0
    // The current frame ID (0-7)
    lda #0
    sta.z plex_frame_id
    // plex_frame = BUCKET_SPRITES
    // Pointer to the buckets of the current frame
    lda #<BUCKET_SPRITES
    sta.z plex_frame
    lda #>BUCKET_SPRITES
    sta.z plex_frame+1
    // plex_id_offset = 0
    // Offset added to plex_id to ensure the sprite cycling works (decreased 1 every time a cycle is complete)
    lda #0
    sta.z plex_id_offset
    // part2_loop()
    jsr part2_loop
    // }
    rts
}
.segment Code
// Animate the sparkler sprite
sparkler_anim: {
    .const toSpritePtr1_return = $ff&P1_SPRITES/$40
    // if(++sparkler_idx==30)
    inc.z sparkler_idx
    lda #$1e
    cmp.z sparkler_idx
    bne __b2
    // sparkler_idx=0
    lda #0
    sta.z sparkler_idx
  __b2:
    // sparkler_idx/2
    lda.z sparkler_idx
    lsr
    // toSpritePtr(P1_SPRITES)+sparkler_idx/2
    clc
    adc #toSpritePtr1_return
    // P1_SCREEN_SPRITE_PTRS[0] = toSpritePtr(P1_SPRITES)+sparkler_idx/2
    sta P1_SCREEN_SPRITE_PTRS
    // }
    rts
}
.segment CodePart1
// Initialize the BADLINES
init_rasters: {
    .label i = $46
    .label __3 = $4c
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned int i=0;i<sizeof(RASTER_BADLINES);i++)
    lda.z i+1
    cmp #>$130*SIZEOF_BYTE
    bcc __b2
    bne !+
    lda.z i
    cmp #<$130*SIZEOF_BYTE
    bcc __b2
  !:
    ldx #$32
  __b3:
    // for(char b=0x32;b<0xfa;b+=8)
    cpx #$fa
    bcc __b4
    // }
    rts
  __b4:
    // RASTER_BADLINES[b] = 1
    lda #1
    sta RASTER_BADLINES,x
    // b+=8
    txa
    axs #-[8]
    jmp __b3
  __b2:
    // RASTER_BADLINES[i] = 0
    clc
    lda.z i
    adc #<RASTER_BADLINES
    sta.z __3
    lda.z i+1
    adc #>RASTER_BADLINES
    sta.z __3+1
    lda #0
    tay
    sta (__3),y
    // for(unsigned int i=0;i<sizeof(RASTER_BADLINES);i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
.segment Code
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($48) str, byte register(X) c, word zp($4c) num)
memset: {
    .label end = $4c
    .label dst = $48
    .label num = $4c
    .label str = $48
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // end = (char*)str + num
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
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($48) destination, void* zp($4c) source, word zp($4a) num)
memcpy: {
    .label src_end = $4a
    .label dst = $48
    .label src = $4c
    .label source = $4c
    .label destination = $48
    .label num = $4a
    // src_end = (char*)source+num
    lda.z src_end
    clc
    adc.z source
    sta.z src_end
    lda.z src_end+1
    adc.z source+1
    sta.z src_end+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
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
.segment CodePart1
// Handle some stuff in the main() routine
part1_loop: {
    .label __11 = $46
    // p1_work_ready = 0
    lda #0
    sta.z p1_work_ready
  __b1:
    // while(p1_work_ready==0)
    lda.z p1_work_ready
    cmp #0
    beq __b1
    // flipper_fix_colors()
    // Fix colors
    jsr flipper_fix_colors
    // demo_frame_count>9*50-3
    lda.z demo_frame_count
    sta.z __11
    lda.z demo_frame_count+1
    sta.z __11+1
    // if(!sparkler_active && demo_frame_count>9*50-3)
    lda.z sparkler_active
    cmp #0
    bne __b4
    lda.z __11+1
    cmp #>9*$32-3
    bne !+
    lda.z __11
    cmp #<9*$32-3
  !:
    bcc __b4
    beq __b4
    // VICII->SPRITES_ENABLE = 0x01
    lda #1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE
    // sparkler_active = 1
    sta.z sparkler_active
  __b4:
    // demo_work()
    // Perform any demo-wide work
    jsr demo_work
    // if(demo_frame_count>14*50)
    lda.z demo_frame_count+1
    cmp #>$e*$32
    bne !+
    lda.z demo_frame_count
    cmp #<$e*$32
  !:
    bcc __b5
    beq __b5
    // demo_start()
  // Re-start the demo base IRQ
    jsr demo_start
    // }
    rts
  __b5:
    // p1_work_ready = 0
    // My work is done!
    lda #0
    sta.z p1_work_ready
    jmp __b1
}
.segment CodePart2
// Initialize data structures for the multiplexer
plexPrepareInit: {
    ldx #0
  // Initial sorting is trivial
  __b1:
    // for(char i=0; i<PLEX_COUNT;i++)
    cpx #$20
    bcc __b2
    // }
    rts
  __b2:
    // PLEX_SORTED_IDX[i] = i
    txa
    sta PLEX_SORTED_IDX,x
    // for(char i=0; i<PLEX_COUNT;i++)
    inx
    jmp __b1
}
// Performs run-time bucket sort of the sprites in the PLEX_ arrays into struct BucketSprite[]
// Starts by performing a true sorting of the sprites based on Y-position (unsing insertion sort)
// plexPrepareFrame(struct BucketSprite* zp($4c) frame)
plexPrepareFrame: {
    .label nxt_idx = $44
    .label nxt_y = $45
    .label m = 5
    .label bucket_ypos = 8
    .label plex_id = $42
    .label ypos = $43
    .label bucket = $4a
    .label sprite = $4c
    .label i1 = 6
    // The current bucket idx
    .label bucket_id = 7
    .label sprite_1 = $4a
    .label frame = $4c
    lda #0
    sta.z m
  // Sort the sprite indices in PLEX_SORTED_IDX based on the Y-position (using insertion sort)
  // Assumes that the positions are nearly sorted already (as each sprite just moves a bit)
  // 1. Moves a marker (m) from the start to end of the array. Every time the marker moves forward all elements before the marker are sorted correctly.
  // 2a. If the next element after the marker is larger that the current element
  //     the marker can be moved forwards (as the sorting is correct).
  // 2b. If the next element after the marker is smaller than the current element:
  //     elements before the marker are shifted right one at a time until encountering one smaller than the current one.
  //      It is then inserted at the spot. Now the marker can move forward.
  __b1:
    // for(char m=0;m<PLEX_COUNT-1;m++)
    lda.z m
    cmp #$20-1
    bcs !__b2+
    jmp __b2
  !__b2:
    ldx #0
  // Initialize real sprite free to the first bucket Y-position
  __b7:
    // for(char i=0;i<8;i++)
    cpx #8
    bcs !__b8+
    jmp __b8
  !__b8:
    // bucket_ypos = BUCKET_YPOS[bucket_id]
    // The current bucket start y-position
    lda BUCKET_YPOS
    sta.z bucket_ypos
    lda.z frame
    sta.z bucket
    lda.z frame+1
    sta.z bucket+1
    lda #0
    sta.z bucket_id
    tax
    sta.z i1
  __b10:
    // for(char i=0;i<PLEX_COUNT; i++)
    lda.z i1
    cmp #$20
    bcc __b11
    // bucket += BUCKET_SIZE
    // Zero-fill the next sprite in the bucket (if not full)
    lda #8*SIZEOF_STRUCT_BUCKETSPRITE
    clc
    adc.z bucket
    sta.z bucket
    bcc !+
    inc.z bucket+1
  !:
    // if(sprite!=bucket)
    lda.z sprite
    cmp.z bucket
    bne !+
    lda.z sprite+1
    cmp.z bucket+1
    beq __breturn
  !:
    // sprite->ypos=0
    lda #0
    tay
    sta (sprite),y
  __breturn:
    // }
    rts
  __b11:
    // plex_id = PLEX_SORTED_IDX[i]
    ldy.z i1
    lda PLEX_SORTED_IDX,y
    sta.z plex_id
    // ypos = PLEX_YPOS[plex_id]
    tay
    lda PLEX_YPOS,y
    sta.z ypos
    // if(real_sprite_free_ypos[real_sprite_id] > bucket_ypos)
    txa
    tay
    lda.z bucket_ypos
    cmp real_sprite_free_ypos,y
    bcs __b13
    // bucket_id++;
    inc.z bucket_id
    // bucket_ypos = BUCKET_YPOS[bucket_id]
    ldy.z bucket_id
    lda BUCKET_YPOS,y
    sta.z bucket_ypos
    // bucket += BUCKET_SIZE
    lda #8*SIZEOF_STRUCT_BUCKETSPRITE
    clc
    adc.z sprite_1
    sta.z sprite_1
    bcc !+
    inc.z sprite_1+1
  !:
    // if(sprite!=bucket)
    lda.z sprite
    cmp.z sprite_1
    bne !+
    lda.z sprite+1
    cmp.z sprite_1+1
    beq __b14
  !:
    // sprite->ypos=0
    lda #0
    tay
    sta (sprite),y
  __b14:
    lda.z sprite_1
    sta.z sprite
    lda.z sprite_1+1
    sta.z sprite+1
  __b13:
    // sprite->ypos = ypos
    // Identify problems filling buckets
    // Put the sprite into the bucket
    lda.z ypos
    ldy #0
    sta (sprite),y
    // sprite->plex_id = plex_id
    lda.z plex_id
    ldy #OFFSET_STRUCT_BUCKETSPRITE_PLEX_ID
    sta (sprite),y
    // bucket_ypos += 1
    // Increase bucket ypos to account for time spent placing the sprite
    inc.z bucket_ypos
    // ypos+22
    lda #$16
    clc
    adc.z ypos
    // real_sprite_free_ypos[real_sprite_id] = ypos+22
    // Update  next free ypos for the real sprite
    sta real_sprite_free_ypos,x
    // real_sprite_id+1
    inx
    // real_sprite_id = (real_sprite_id+1)&7
    lda #7
    axs #0
    // sprite++;
    lda #SIZEOF_STRUCT_BUCKETSPRITE
    clc
    adc.z sprite
    sta.z sprite
    bcc !+
    inc.z sprite+1
  !:
    // for(char i=0;i<PLEX_COUNT; i++)
    inc.z i1
    jmp __b10
  __b8:
    // real_sprite_free_ypos[i] = BUCKET_YPOS[0]
    lda BUCKET_YPOS
    sta real_sprite_free_ypos,x
    // for(char i=0;i<8;i++)
    inx
    jmp __b7
  __b2:
    // nxt_idx = PLEX_SORTED_IDX[m+1]
    ldy.z m
    lda PLEX_SORTED_IDX+1,y
    sta.z nxt_idx
    // nxt_y = PLEX_YPOS[nxt_idx]
    tay
    lda PLEX_YPOS,y
    sta.z nxt_y
    // if(nxt_y<PLEX_YPOS[PLEX_SORTED_IDX[m]])
    ldx.z m
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcs __b3
  __b4:
    // PLEX_SORTED_IDX[s+1] = PLEX_SORTED_IDX[s]
    lda PLEX_SORTED_IDX,x
    sta PLEX_SORTED_IDX+1,x
    // s--;
    dex
    // while((s!=0xff) && (nxt_y<PLEX_YPOS[PLEX_SORTED_IDX[s]]))
    cpx #$ff
    beq __b5
    lda.z nxt_y
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcc __b4
  __b5:
    // s++;
    inx
    // PLEX_SORTED_IDX[s] = nxt_idx
    lda.z nxt_idx
    sta PLEX_SORTED_IDX,x
  __b3:
    // for(char m=0;m<PLEX_COUNT-1;m++)
    inc.z m
    jmp __b1
  .segment DataPart2
    // Y-position where each real sprite is free (used for selecting the best bucket)
    real_sprite_free_ypos: .fill 8, 0
}
.segment CodePart2
// Part 2 main loop
part2_loop: {
    .label __23 = $46
    .label __24 = $48
    // p2_work_ready = 0
    lda #0
    sta.z p2_work_ready
  __b1:
    // while(p2_work_ready==0)
    lda.z p2_work_ready
    cmp #0
    beq __b1
    // demo_work()
    // Play music
    jsr demo_work
    // if(p2_logo_revealing && !p2_logo_reveal_done)
    lda.z p2_logo_revealing
    cmp #0
    beq __b4
    lda.z p2_logo_reveal_done
    cmp #0
    beq __b3
    jmp __b4
  __b3:
    // p2_logo_reveal()
    jsr p2_logo_reveal
  __b4:
    // demo_frame_count>18*50+25
    lda.z demo_frame_count
    sta.z __23
    lda.z demo_frame_count+1
    sta.z __23+1
    // if(!p2_logo_revealing && demo_frame_count>18*50+25)
    lda.z p2_logo_revealing
    cmp #0
    bne __b5
    lda.z __23+1
    cmp #>$12*$32+$19
    bne !+
    lda.z __23
    cmp #<$12*$32+$19
  !:
    bcc __b5
    beq __b5
    // p2_logo_revealing = 1
    lda #1
    sta.z p2_logo_revealing
  __b5:
    // if(!p2_logo_swinging && p2_logo_reveal_done)
    lda.z p2_logo_swinging
    cmp #0
    bne __b6
    lda.z p2_logo_reveal_done
    cmp #0
    beq __b6
    // p2_logo_swinging = 1
    lda #1
    sta.z p2_logo_swinging
  __b6:
    // demo_frame_count>26*50
    lda.z demo_frame_count
    sta.z __24
    lda.z demo_frame_count+1
    sta.z __24+1
    // if(!p2_plex_scroller_moving && demo_frame_count>26*50)
    lda.z p2_plex_scroller_moving
    cmp #0
    bne __b7
    lda.z __24+1
    cmp #>$1a*$32
    bne !+
    lda.z __24
    cmp #<$1a*$32
  !:
    bcc __b7
    beq __b7
    // p2_plex_scroller_moving = 1
    lda #1
    sta.z p2_plex_scroller_moving
  __b7:
    // p2_work_ready = 0
    // My work is done!
    lda #0
    sta.z p2_work_ready
    jmp __b1
}
.segment CodePart1
// Fixes the colors for the flipper
// Updates with bitmap colors when the bitmap is being shown
flipper_fix_colors: {
    .label __4 = $48
    .label __5 = $48
    .label __12 = $4a
    .label offset = $4a
    .label colors = $4e
    .label happy_cols = $4a
    .label __13 = $4c
    .label __14 = $4a
    // if(irq_flipper_top_line>0x2e && irq_flipper_top_line<0xf6)
    lda.z irq_flipper_top_line+1
    bne !+
    lda.z irq_flipper_top_line
    cmp #$2e+1
    bcc __breturn
  !:
    lda.z irq_flipper_top_line+1
    bne !+
    lda.z irq_flipper_top_line
    cmp #$f6
    bcc __b1
  !:
  __breturn:
    // }
    rts
  __b1:
    // irq_flipper_top_line-0x2e
    sec
    lda.z irq_flipper_top_line
    sbc #$2e
    sta.z __4
    lda.z irq_flipper_top_line+1
    sbc #0
    sta.z __4+1
    // (irq_flipper_top_line-0x2e)/8
    lsr.z __5+1
    ror.z __5
    lsr.z __5+1
    ror.z __5
    lsr.z __5+1
    ror.z __5
    // charline = (char)((irq_flipper_top_line-0x2e)/8)
    lda.z __5
    // if(charline>=flipper_charline)
    cmp.z flipper_charline
    bcc __breturn
    // (unsigned int)flipper_charline*40
    lda.z flipper_charline
    sta.z __12
    lda #0
    sta.z __12+1
    // offset = (unsigned int)flipper_charline*40
    lda.z __12
    asl
    sta.z __13
    lda.z __12+1
    rol
    sta.z __13+1
    asl.z __13
    rol.z __13+1
    lda.z __14
    clc
    adc.z __13
    sta.z __14
    lda.z __14+1
    adc.z __13+1
    sta.z __14+1
    asl.z offset
    rol.z offset+1
    asl.z offset
    rol.z offset+1
    asl.z offset
    rol.z offset+1
    // colors = COLS+offset
    clc
    lda.z offset
    adc #<COLS
    sta.z colors
    lda.z offset+1
    adc #>COLS
    sta.z colors+1
    // happy_cols = P1_COLORS+offset
    clc
    lda.z happy_cols
    adc #<P1_COLORS
    sta.z happy_cols
    lda.z happy_cols+1
    adc #>P1_COLORS
    sta.z happy_cols+1
    ldy #0
  __b3:
    // for(char i=0;i<40;i++)
    cpy #$28
    bcc __b4
    // flipper_charline++;
    inc.z flipper_charline
    rts
  __b4:
    // colors[i] = happy_cols[i]
    lda (happy_cols),y
    sta (colors),y
    // for(char i=0;i<40;i++)
    iny
    jmp __b3
}
.segment CodePart2
// Reveals the logo column by column
p2_logo_reveal: {
    // if(p2_logo_reveal_idx>=40)
    lda.z p2_logo_reveal_idx
    cmp #$28
    bcs __b1
    // vsp_update_screen(p2_logo_reveal_idx++)
    sta.z vsp_update_screen.x_offset
    jsr vsp_update_screen
    // vsp_update_screen(p2_logo_reveal_idx++);
    inc.z p2_logo_reveal_idx
    // }
    rts
  __b1:
    // p2_logo_reveal_done = 1
    lda #1
    sta.z p2_logo_reveal_done
    rts
}
.segment Data
  // The byteboozer decruncher
BYTEBOOZER:
.const B2_ZP_BASE = $fc
    #import "byteboozer_decrunch.asm"

.segment InitPart1
  // MC Bitmap Data
P1_PIXELS_CRUNCHED:
.modify B2() {
        .pc = P1_PIXELS "HAPPYNEWYEAR PIXELS"    
        #import "mcbitmap.asm"
        .var mcBmmData1 = getMcBitmapData(LoadPicture("happy-newyear.png"))
        .for (var y=0; y<25; y++)
            .for (var x=0; x<40; x++)
                .fill 8, getMcPixelData(x, y, i, mcBmmData1)
    }

P1_SCREEN_CRUNCHED:
.modify B2() {
        .pc = P1_SCREEN "HAPPYNEWYEAR SCREEN"    
        .for (var y=0; y<25; y++)
            .for (var x=0; x<40; x++)
                .byte getMcScreenData(x, y, mcBmmData1)
    }

P1_COLORS_CRUNCHED:
.modify B2() {
        .pc = P1_COLORS "HAPPYNEWYEAR COLORS"    
        .for (var y=0; y<25; y++)
            .for (var x=0; x<40; x++)
                .byte getMcColorData(x, y, mcBmmData1)
    }

  // Sparkler sprites
P1_SPRITES_CRUNCHED:
.modify B2() {
        .pc = P1_SPRITES "P1_SPRITES"
        // Pixels                                                    11         01     10       11
        .var p1_sprites = LoadPicture("sparklers.png", List().add($000000, $daccc3, $472a24, $957a71))
        .for(var sx=0;sx<15;sx++) {
            .for (var y=0;y<21; y++) {
                .for (var c=0; c<3; c++) {
                    .byte p1_sprites.getMulticolorByte(sx*3+c,y)
                }
            }
            .byte 0
        }
    }

  // An easing curve from 0x000 to 0x130
FLIPPER_EASING_CRUNCHED:
.modify B2() {
        .pc = FLIPPER_EASING "FLIPPER_EASING"
        .fillword $130, round($98+$98*cos(PI+PI*i/$130))
    }

.segment DataPart1
  // 1 if the raster line is a badline
  .align $100
  RASTER_BADLINES: .fill $130, 0
.segment DataPart2
  // The Y-position (IRQ raster line) starting each bucket
  BUCKET_YPOS: .byte $10, $48, $58, $72, $8e, $aa, $c0, $d0, $de
  // The y-positions of the multiplexer sprites. (These are converted to multiplexer buckets)
  PLEX_YPOS: .fill $20, 0
  // The low byte of the x-positions of the multiplexer sprites 
  PLEX_XPOS: .fill $20, 0
  // The MSB of the x-positions of the multiplexer sprites (0/1)
  PLEX_XPOS_MSB: .fill $20, 0
  // The sprite pointers for the multiplexed sprites
  PLEX_PTR: .fill $20, 0
  // Indexes of the plex-sprites sorted by sprite y-position. Each call to plexSort() will fix the sorting if changes to the Y-positions have ruined it.
  PLEX_SORTED_IDX: .fill $20, 0
.segment InitPart2
SPRITES_CRUNCHED:
.modify B2() {
            .pc = PART2_SPRITES "PART2_SPRITES"
	        .var p2_sprites = LoadPicture("spritefont.png", List().add($000000, $ffffff))
	        .for(var sy=0;sy<8;sy++) {
    		    .for(var sx=0;sx<8;sx++) {
    	    	    .for (var y=0;y<21; y++) {
	    	    	    .for (var c=0; c<3; c++) {
    	                	.byte p2_sprites.getSinglecolorByte(sx*3+c,sy*21+y)
	                    }
	                }
	    	        .byte 0
	  	        }
	        }
        }

LOGO_DATA_CRUNCHED:
.modify B2() {
            .pc = LOGO_DATA "LOGO DATA"
            #import "mcbitmap.asm"
            .var mcBmmData2 = getMcBitmapData(LoadPicture("logo-bitmap-640.png"))    
            // Screen data
            .for (var y=0; y<LOGO_HEIGHT; y++)
                .for (var x=0; x<LOGO_WIDTH; x++)
                    .byte getMcScreenData(x, y, mcBmmData2)
            // Color Data
            .for (var y=0; y<LOGO_HEIGHT; y++)
                .for (var x=0; x<LOGO_WIDTH; x++)
                    .byte getMcColorData(x, y, mcBmmData2)
            // Bitmap Data (row by row)
            .for (var y=0; y<LOGO_HEIGHT; y++)
                .for (var i=0; i<8; i++)
                    .for (var x=0; x<LOGO_WIDTH; x++)
                        .byte getMcPixelData(x, y, i, mcBmmData2)
        }

.segment DataPart2
  // A sinus table with values [0;320]
  .align $100
VSP_SINTABLE:
.fillword $100, round(160+160*sin(2*PI*i/256))

  // The sequence of colors for the sprites
  SPRITE_COLOR_SEQUENCE: .byte WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, YELLOW, CYAN, GREEN, PURPLE, RED, BLUE, RED, PURPLE, GREEN, CYAN, YELLOW, WHITE, WHITE
  .align $100
SCROLL_YSIN:
.fill $100, round(139+89.5*sin(toRadians(360*i/256)))

  // The buckets containing sprites to show. 8 sprites in each bucket.
  .align $100
  BUCKET_SPRITES: .fill 2*8*9*8, 0
  // Copy of the original buckets containing sprites to show. 8 sprites in each bucket. (Used for adding the plex_id_offset)
  .align $100
  ORIGINAL_BUCKET_SPRITES: .fill 2*8*9*8, 0
  .align $100
XMOVEMENT:
//.lohifill $100, round(344-i*344/$100-86*sin(toRadians(360*i/$100)))
    .lohifill $200, round(344-i*344/$100-129*sin(toRadians(360*i/$100)))
    //.lohifill $100, round(344-i*344/$100-86*sin(toRadians(360*i/$80)))
    //.lohifill $100, round(344-i*344/$100 -86*sin(toRadians(360*i/$100)) -43*sin(toRadians(360*i/$80)))
    //.lohifill $100, 344-i*344/$100

  // The scroll text
  SCROLL_TEXT: .text @"* most people will remember 2020 for a long time. for us nerds, it was a chance to dig deep into our hobbies. but we do miss the demoparties, and drinking beers with you crazy people... it is the 30th birthday of camelot, and this virtual greeting card is our way of celebrating with all of you!     credits  *  code: rex  *  music: linus  *  graphics: bizkid, snabel & vic  *    camelot sends love to \$ff  abyss connection  \$ff  algotech  \$ff  ancients  \$ff  arsenic  \$ff  arise  \$ff  artline designs  \$ff  artstate  \$ff  atlantis  \$ff  bonzai  \$ff  booze design  \$ff  censor design  \$ff  cosine  \$ff  crest  \$ff  chorus  \$ff  dekadence  \$ff  delysid  \$ff  desire  \$ff  elysium  \$ff  excess  \$ff  extend  \$ff  faic  \$ff  f4cg  \$ff  fairlight  \$ff  fossil  \$ff  glance  \$ff  genesis project  \$ff  haujobb  \$ff  hitmen  \$ff  hoaxers  \$ff  hokuto force  \$ff  horizon  \$ff  illusion  \$ff  john dillermand  \$ff  laxity  \$ff  lepsi de  \$ff  lethargy  \$ff  mayday  \$ff  megastyle  \$ff  multistyle labs  \$ff  nah-kolor  \$ff  noice  \$ff  offence  \$ff  onslaught  \$ff  oxyron  \$ff  padua  \$ff  panda design  \$ff  panoramic designs  \$ff  performers  \$ff  plush  \$ff  pretzel logic  \$ff  prosonix  \$ff  proxima  \$ff  rabenauge  \$ff  radwar  \$ff  rebels  \$ff  resource  \$ff  samar  \$ff  scenesat  \$ff  shape  \$ff  siesta  \$ff  silicon ltd.  \$ff  singular  \$ff  software of sweden  \$ff  starion  \$ff  success  \$ff  svenonacid  \$ff  the dreams  \$ff  the solution  \$ff  triad  \$ff  tropyx  \$ff  trsi  \$ff  unicess  \$ff  up rough  \$ff  vision  \$ff  xenon  \$ff  xentax  \$ff  ... we hope to see you all again in 2021...                                "
  .byte 0
.segment InitPart2
PLEX_ID_UPDATERS_CRUNCHED:
.modify B2() {
        .pc = PLEX_ID_UPDATERS "PLEX_ID_UPDATERS"
        // First generate a jump table
        .for(var frame=0;frame<8;frame++) 
            .word updaters[frame].updater
        // Generate the 8 unrolled updaters
        updaters: 
        .for(var frame=0;frame<8;frame++) {
            updater:
            ldx #$1f
            .for(var sprite=0; sprite<9*8; sprite++ ) {
                lda ORIGINAL_BUCKET_SPRITES + frame*8*9*2 + sprite*2 +1
                clc
                adc plex_id_offset
                sax BUCKET_SPRITES + frame*8*9*2 + sprite*2 +1
            }
            rts        
        }
    }

.segment InitDemo
// SID tune
DEMO_MUSIC_CRUNCHED:
.modify B2() {
        .pc = DEMO_MUSIC "MUSIC"
        .const music = LoadSid("do-it-again-$AC00-$FA-8580.sid")
        .fill music.size, music.getData(i)
    }

