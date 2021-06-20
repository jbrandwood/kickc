// A simple usage of the flexible sprite multiplexer routine
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="simple-multiplexer-irq.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  /// Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
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
  .const WHITE = 1
  .const RED = 2
  .const GREEN = 5
  // The number of sprites in the multiplexer
  .const PLEX_COUNT = $20
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  /// Sprite X position register for sprite #0
  .label SPRITES_XPOS = $d000
  /// Sprite Y position register for sprite #0
  .label SPRITES_YPOS = $d001
  /// Sprite X position MSB register
  .label SPRITES_XMSB = $d010
  /// Sprite colors register for sprite #0
  .label SPRITES_COLOR = $d027
  /// Sprite enable register
  .label SPRITES_ENABLE = $d015
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
  /// $D011 Control Register #1
  /// @see #VICII_CONTROL1
  .label D011 = $d011
  /// VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  /// VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  /// The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  // Location of screen & sprites
  .label SCREEN = $400
  // The address of the sprite pointers on the current screen (screen+0x3f8).
  .label PLEX_SCREEN_PTR = 6
  // The index in the PLEX tables of the next sprite to show
  .label plex_show_idx = 8
  // The index the next sprite to use for showing (sprites are used round-robin)
  .label plex_sprite_idx = 9
  // The MSB bit of the next sprite to use for showing
  .label plex_sprite_msb = $a
  // The index of the sprite that is free next. Since sprites are used round-robin this moves forward each time a sprite is shown.
  .label plex_free_next = $b
  .label framedone = $c
.segment Code
__start: {
    // char* volatile PLEX_SCREEN_PTR = (char*)0x400+0x3f8
    lda #<$400+$3f8
    sta.z PLEX_SCREEN_PTR
    lda #>$400+$3f8
    sta.z PLEX_SCREEN_PTR+1
    // volatile char plex_show_idx=0
    lda #0
    sta.z plex_show_idx
    // volatile char plex_sprite_idx=0
    sta.z plex_sprite_idx
    // volatile char plex_sprite_msb=1
    lda #1
    sta.z plex_sprite_msb
    // volatile char plex_free_next = 0
    lda #0
    sta.z plex_free_next
    // volatile bool framedone = true
    lda #1
    sta.z framedone
    jsr main
    rts
}
plex_irq: {
    .label __4 = $d
    // asm
    sei
    // *BORDER_COLOR = WHITE
    lda #WHITE
    sta BORDER_COLOR
  __b3:
    // plexShowSprite()
    jsr plexShowSprite
    // return PLEX_FREE_YPOS[plex_free_next];
    ldy.z plex_free_next
    ldx PLEX_FREE_YPOS,y
    // *RASTER+2
    lda RASTER
    clc
    adc #2
    sta.z __4
    // while (plex_show_idx < PLEX_COUNT && rasterY < *RASTER+2)
    lda.z plex_show_idx
    cmp #PLEX_COUNT
    bcs __b4
    cpx.z __4
    bcc __b3
  __b4:
    // *IRQ_STATUS = IRQ_RASTER
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // if (plex_show_idx<PLEX_COUNT)
    lda.z plex_show_idx
    cmp #PLEX_COUNT
    bcc __b1
    // *RASTER = 0x0
    lda #0
    sta RASTER
    // framedone = true
    lda #1
    sta.z framedone
  __b2:
    // *BORDER_COLOR = 0
    lda #0
    sta BORDER_COLOR
    // asm
    cli
    // }
    jmp $ea81
  __b1:
    // *RASTER = rasterY
    stx RASTER
    jmp __b2
}
main: {
    // asm
    sei
    // init()
    jsr init
    // loop()
    jsr loop
    // }
    rts
}
// Show the next sprite.
// plexSort() prepares showing the sprites
plexShowSprite: {
    .label plex_sprite_idx2 = $e
    // char plex_sprite_idx2 = plex_sprite_idx*2
    lda.z plex_sprite_idx
    asl
    sta.z plex_sprite_idx2
    // char ypos = PLEX_YPOS[PLEX_SORTED_IDX[plex_show_idx]]
    ldx.z plex_show_idx
    ldy PLEX_SORTED_IDX,x
    lda PLEX_YPOS,y
    // SPRITES_YPOS[plex_sprite_idx2] = ypos
    ldy.z plex_sprite_idx2
    sta SPRITES_YPOS,y
    // ypos+22
    clc
    adc #$16
    // PLEX_FREE_YPOS[plex_free_next] =  ypos+22
    ldy.z plex_free_next
    sta PLEX_FREE_YPOS,y
    // plex_free_next+1
    ldx.z plex_free_next
    inx
    // (plex_free_next+1)&7
    txa
    and #7
    // plex_free_next = (plex_free_next+1)&7
    sta.z plex_free_next
    // PLEX_SCREEN_PTR[plex_sprite_idx] = PLEX_PTR[PLEX_SORTED_IDX[plex_show_idx]]
    ldx.z plex_show_idx
    ldy PLEX_SORTED_IDX,x
    lda PLEX_PTR,y
    ldy.z plex_sprite_idx
    sta (PLEX_SCREEN_PTR),y
    // char xpos_idx = PLEX_SORTED_IDX[plex_show_idx]
    ldy.z plex_show_idx
    lda PLEX_SORTED_IDX,y
    // SPRITES_XPOS[plex_sprite_idx2] = (char)PLEX_XPOS[xpos_idx]
    asl
    tax
    ldy.z plex_sprite_idx2
    lda PLEX_XPOS,x
    sta SPRITES_XPOS,y
    // BYTE1(PLEX_XPOS[xpos_idx])
    lda PLEX_XPOS+1,x
    // if(BYTE1(PLEX_XPOS[xpos_idx])!=0)
    cmp #0
    bne __b1
    // 0xff^plex_sprite_msb
    lda #$ff
    eor.z plex_sprite_msb
    // *SPRITES_XMSB &= (0xff^plex_sprite_msb)
    and SPRITES_XMSB
    sta SPRITES_XMSB
  __b2:
    // plex_sprite_idx+1
    ldx.z plex_sprite_idx
    inx
    // (plex_sprite_idx+1)&7
    txa
    and #7
    // plex_sprite_idx = (plex_sprite_idx+1)&7
    sta.z plex_sprite_idx
    // plex_show_idx++;
    inc.z plex_show_idx
    // plex_sprite_msb <<=1
    asl.z plex_sprite_msb
    // if(plex_sprite_msb==0)
    lda.z plex_sprite_msb
    bne __breturn
    // plex_sprite_msb = 1
    lda #1
    sta.z plex_sprite_msb
  __breturn:
    // }
    rts
  __b1:
    // *SPRITES_XMSB |= plex_sprite_msb
    lda SPRITES_XMSB
    ora.z plex_sprite_msb
    sta SPRITES_XMSB
    jmp __b2
}
// Initialize the program
init: {
    // Set the x-positions & pointers
    .label xp = 2
    // *D011 = VICII_DEN | VICII_RSEL | 3
    lda #VICII_DEN|VICII_RSEL|3
    sta D011
    // plexInit(SCREEN)
  // Initialize the multiplexer
    jsr plexInit
    lda #<$20
    sta.z xp
    lda #>$20
    sta.z xp+1
    ldx #0
  __b1:
    // PLEX_PTR[sx] = (char)(SPRITE/0x40)
    lda #$ff&SPRITE/$40
    sta PLEX_PTR,x
    // PLEX_XPOS[sx] = xp
    txa
    asl
    tay
    lda.z xp
    sta PLEX_XPOS,y
    lda.z xp+1
    sta PLEX_XPOS+1,y
    // xp += 9
    lda #9
    clc
    adc.z xp
    sta.z xp
    bcc !+
    inc.z xp+1
  !:
    // for(char sx: 0..PLEX_COUNT-1)
    inx
    cpx #PLEX_COUNT-1+1
    bne __b1
    // *SPRITES_ENABLE = 0xff
    // Enable & initialize sprites
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  __b3:
    // SPRITES_COLOR[ss] = GREEN
    lda #GREEN
    sta SPRITES_COLOR,x
    // for(char ss: 0..7)
    inx
    cpx #8
    bne __b3
    // asm
    // enable the interrupt
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *IRQ_ENABLE = IRQ_RASTER
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *IRQ_STATUS = IRQ_RASTER
    sta IRQ_STATUS
    // *KERNEL_IRQ = &plex_irq
    lda #<plex_irq
    sta KERNEL_IRQ
    lda #>plex_irq
    sta KERNEL_IRQ+1
    // *VICII_CONTROL1 &= 0x7f
    lda #$7f
    and VICII_CONTROL1
    sta VICII_CONTROL1
    // *RASTER = 0x0
    lda #0
    sta RASTER
    // asm
    cli
    // }
    rts
}
// The raster loop
loop: {
    // The current index into the y-sine
    .label sin_idx = 4
    lda #0
    sta.z sin_idx
  __b2:
    // while(!framedone)
    lda.z framedone
    cmp #0
    bne __b3
    jmp __b2
  __b3:
    // *BORDER_COLOR = RED
    lda #RED
    sta BORDER_COLOR
    ldx.z sin_idx
    ldy #0
  __b4:
    // PLEX_YPOS[sy] = YSIN[y_idx]
    lda YSIN,x
    sta PLEX_YPOS,y
    // y_idx += 8
    txa
    axs #-[8]
    // for(char sy: 0..PLEX_COUNT-1)
    iny
    cpy #PLEX_COUNT-1+1
    bne __b4
    // sin_idx +=1
    inc.z sin_idx
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    // plexSort()
    jsr plexSort
    // *BORDER_COLOR = GREEN
    lda #GREEN
    sta BORDER_COLOR
    // framedone = false
    lda #0
    sta.z framedone
    jmp __b2
}
// Initialize the multiplexer data structures
plexInit: {
    // PLEX_SCREEN_PTR = screen+0x3f8
    lda #<SCREEN+$3f8
    sta.z PLEX_SCREEN_PTR
    lda #>SCREEN+$3f8
    sta.z PLEX_SCREEN_PTR+1
    ldx #0
  __b1:
    // PLEX_SORTED_IDX[i] = i
    txa
    sta PLEX_SORTED_IDX,x
    // for(char i: 0..PLEX_COUNT-1)
    inx
    cpx #PLEX_COUNT-1+1
    bne __b1
    // }
    rts
}
// Ensure that the indices in PLEX_SORTED_IDX is sorted based on the y-positions in PLEX_YPOS
// Assumes that the positions are nearly sorted already (as each sprite just moves a bit)
// Uses an insertion sort:
// 1. Moves a marker (m) from the start to end of the array. Every time the marker moves forward all elements before the marker are sorted correctly.
// 2a. If the next element after the marker is larger that the current element
//     the marker can be moved forwards (as the sorting is correct).
// 2b. If the next element after the marker is smaller than the current element:
//     elements before the marker are shifted right one at a time until encountering one smaller than the current one.
//      It is then inserted at the spot. Now the marker can move forward.
plexSort: {
    .label nxt_idx = $f
    .label nxt_y = $10
    .label m = 5
    lda #0
    sta.z m
  __b1:
    // char nxt_idx = PLEX_SORTED_IDX[m+1]
    ldy.z m
    lda PLEX_SORTED_IDX+1,y
    sta.z nxt_idx
    // char nxt_y = PLEX_YPOS[nxt_idx]
    tay
    lda PLEX_YPOS,y
    sta.z nxt_y
    // if(nxt_y<PLEX_YPOS[PLEX_SORTED_IDX[m]])
    ldx.z m
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcs __b2
  __b3:
    // PLEX_SORTED_IDX[s+1] = PLEX_SORTED_IDX[s]
    lda PLEX_SORTED_IDX,x
    sta PLEX_SORTED_IDX+1,x
    // s--;
    dex
    // while((s!=0xff) && (nxt_y<PLEX_YPOS[PLEX_SORTED_IDX[s]]))
    cpx #$ff
    beq __b4
    lda.z nxt_y
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcc __b3
  __b4:
    // s++;
    inx
    // PLEX_SORTED_IDX[s] = nxt_idx
    lda.z nxt_idx
    sta PLEX_SORTED_IDX,x
  __b2:
    // for(char m: 0..PLEX_COUNT-2)
    inc.z m
    lda #PLEX_COUNT-2+1
    cmp.z m
    bne __b1
    // plex_show_idx = 0
    // Prepare for showing the sprites
    lda #0
    sta.z plex_show_idx
    // plex_sprite_idx = 0
    sta.z plex_sprite_idx
    // plex_sprite_msb = 1
    lda #1
    sta.z plex_sprite_msb
    ldx #0
  plexFreePrepare1___b1:
    // PLEX_FREE_YPOS[s] = 0
    lda #0
    sta PLEX_FREE_YPOS,x
    // for( char s: 0..7)
    inx
    cpx #8
    bne plexFreePrepare1___b1
    // plex_free_next = 0
    sta.z plex_free_next
    // }
    rts
}
.segment Data
  // The x-positions of the multiplexer sprites (0x000-0x1ff)
  PLEX_XPOS: .fill 2*PLEX_COUNT, 0
  // The y-positions of the multiplexer sprites.
  PLEX_YPOS: .fill PLEX_COUNT, 0
  // The sprite pointers for the multiplexed sprites
  PLEX_PTR: .fill PLEX_COUNT, 0
  // Indexes of the plex-sprites sorted by sprite y-position. Each call to plexSort() will fix the sorting if changes to the Y-positions have ruined it.
  PLEX_SORTED_IDX: .fill PLEX_COUNT, 0
  // Contains the Y-position where each sprite is free again. PLEX_FREE_YPOS[s] holds the Y-position where sprite s is free to use again.
  PLEX_FREE_YPOS: .fill 8, 0
  .align $40
SPRITE:
.var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

  .align $100
YSIN:
.fill $100, round(139.5+89.5*sin(toRadians(360*i/256)))

