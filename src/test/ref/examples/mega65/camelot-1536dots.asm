// A pretty simple double sine plotter
.cpu _45gs02
  // MEGA65 platform PRG executable starting in MEGA65 mode.
.file [name="camelot-1536dots.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(__start)                                   //         NNNN
.byte $00, $00, $00                                     // 
  /// $47, $53: MEGA65 personality
  .const VICIV_KEY_M65_A = $47
  .const VICIV_KEY_M65_B = $53
  /// 6    FAST  Enable C65 FAST mode (3 .5MHz)
  .const VICIV_FAST = $40
  /// $D054 VIC-IV Control register C
  /// 0 CHR16 enable 16-bit character numbers (two screen bytes per character)
  .const VICIV_CHR16 = 1
  /// 6 VIC-IV:VFAST C65GS FAST mode (48MHz)
  .const VICIV_VFAST = $40
  /// $D06E.0-6 SPRPTRADR sprite pointer address (bits 22 - 16)
  ///   7 SPRPTR16 16-bit sprite pointer mode (allows sprites to be located on any 64 byte boundary in chip RAM)
  .const VICIV_SPRPTR16 = $80
  /// DMA command fill
  .const DMA_COMMAND_FILL = 3
  /// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  /// RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  /// The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const PURPLE = 4
  .const BLUE = 6
  .const DARK_GREY = $b
  // Sine table
  .const SINY1_SIZE = $2dd
  .const SINY2_SIZE = $13d
  .const SINX1_SIZE = $64d
  .const SINX2_SIZE = $223
  .const SIZEOF_UNSIGNED_INT = 2
  .const OFFSET_STRUCT_F018_DMAGIC_EN018B = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_COUNT = 1
  .const OFFSET_STRUCT_DMA_LIST_F018B_SRC = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_DEST = 6
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMB = 4
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRBANK = 2
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMSB = 1
  .const OFFSET_STRUCT_MEGA65_VICIV_KEY = $2f
  .const OFFSET_STRUCT_MEGA65_VICIV_CONTROLA = $30
  .const OFFSET_STRUCT_MEGA65_VICIV_CONTROLB = $31
  .const OFFSET_STRUCT_MEGA65_VICIV_CONTROLC = $54
  .const OFFSET_STRUCT_MEGA65_VICIV_SPRPTRADR_LOLO = $6c
  .const OFFSET_STRUCT_MEGA65_VICIV_SPRPTRADR_LOHI = $6d
  .const OFFSET_STRUCT_MEGA65_VICIV_SPRPTRADR_HILO = $6e
  .const OFFSET_STRUCT_MEGA65_VICIV_SPRITES_ENABLE = $15
  .const OFFSET_STRUCT_MEGA65_VICIV_SPRITES_PRIORITY = $1b
  .const OFFSET_STRUCT_MEGA65_VICIV_RASTER = $12
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOLO = $68
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOHI = $69
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_HILO = $6a
  .const OFFSET_STRUCT_MEGA65_VICIV_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARSTEP_LO = $58
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARSTEP_HI = $59
  .const OFFSET_STRUCT_MEGA65_VICIV_CHRCOUNT = $5e
  .const OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_LOLO = $60
  .const OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_LOHI = $61
  .const OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_HILO = $62
  .const OFFSET_STRUCT_MEGA65_VICIV_BG_COLOR = $21
  /// Sprite X position register for sprite #0
  .label SPRITES_XPOS = $d000
  /// Sprite Y position register for sprite #0
  .label SPRITES_YPOS = $d001
  /// Sprite X position MSB register
  .label SPRITES_XMSB = $d010
  /// Sprite colors register for sprite #0
  .label SPRITES_COLOR = $d027
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The VIC IV
  .label VICIV = $d000
  /// DMAgic F018 Controller
  .label DMA = $d700
  // Address of the screen
  .label SCREEN = $c800
  // // Absolute address of graphics buffer 1
  .label GRAPHICS1 = $a000
  // // Absolute address of graphics buffer 2
  .label GRAPHICS2 = $7000
  // Pointer to the music init routine
  .label musicInit = MUSIC
  // Pointer to the music play routine
  .label musicPlay = MUSIC+3
  // 0: show GRAPHICS1, render to GRAPHICS2
  // 1: show GRAPHICS2, render to GRAPHICS1
  .label buffer = $2a
  // The graphics being rendered to
  .label graphics_render = $16
  // Sine idx for each plot
  .label sin_x1_idx = $21
  .label sin_x2_idx = $23
  .label sin_y1_idx = $25
  .label sin_y2_idx = $27
.segment Code
__start: {
    // volatile char buffer = 0
    ldz #0
    stz.z buffer
    // char * volatile graphics_render = GRAPHICS1
    lda #<GRAPHICS1
    sta.z graphics_render
    lda #>GRAPHICS1
    sta.z graphics_render+1
    // volatile unsigned int sin_x1_idx
    tza
    sta.z sin_x1_idx
    sta.z sin_x1_idx+1
    // volatile unsigned int sin_x2_idx
    sta.z sin_x2_idx
    sta.z sin_x2_idx+1
    // volatile unsigned int sin_y1_idx
    sta.z sin_y1_idx
    sta.z sin_y1_idx+1
    // volatile unsigned int sin_y2_idx
    sta.z sin_y2_idx
    sta.z sin_y2_idx+1
    jsr main
    rts
}
main: {
    .const toSpritePtr1_return = $ff&toSpritePtr1_sprite/$40
    .const toSpritePtr2_return = $ff&toSpritePtr2_sprite/$40
    .const toSpritePtr3_return = $ff&SPRITES/$40
    .label toSpritePtr1_sprite = SPRITES+$40
    .label toSpritePtr2_sprite = SPRITES+$80
    // asm
    sei
    // memoryRemap(0x00,0,0)
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    jsr memoryRemap
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable Kernal & Basic
    ldz #PROCPORT_DDR_MEMORY_MASK
    stz PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    ldz #PROCPORT_RAM_IO
    stz PROCPORT
    // VICIV->KEY = VICIV_KEY_M65_A
    // Enable MEGA65 features
    ldz #VICIV_KEY_M65_A
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_KEY
    // VICIV->KEY = VICIV_KEY_M65_B
    ldz #VICIV_KEY_M65_B
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_KEY
    // VICIV->CONTROLA = 0
    // No C65 ROMs are mapped
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLA
    // VICIV->CONTROLB |= VICIV_FAST
    // Enable 48MHz fast mode
    lda #VICIV_FAST
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    // VICIV->CONTROLC |= VICIV_VFAST
    lda #VICIV_VFAST
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    // graphics_mode()
    // Initialize graphics
    jsr graphics_mode
    // VICIV->SPRPTRADR_LOLO = LOBYTE
    // Show sprites
    ldz #<SPRITE_PTRS
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_SPRPTRADR_LOLO
    // VICIV->SPRPTRADR_LOHI = HIBYTE
    ldz #>SPRITE_PTRS
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_SPRPTRADR_LOHI
    // VICIV->SPRPTRADR_HILO = VICIV_SPRPTR16
    ldz #VICIV_SPRPTR16
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_SPRPTRADR_HILO
    // SPRITE_PTRS[0] = toSpritePtr(SPRITES+0x40)
    lda #<toSpritePtr1_return
    sta SPRITE_PTRS
    lda #>toSpritePtr1_return
    sta SPRITE_PTRS+1
    // SPRITE_PTRS[1] = toSpritePtr(SPRITES+0x80)
    lda #<toSpritePtr2_return
    sta SPRITE_PTRS+1*SIZEOF_UNSIGNED_INT
    lda #>toSpritePtr2_return
    sta SPRITE_PTRS+1*SIZEOF_UNSIGNED_INT+1
    // SPRITE_PTRS[2] = toSpritePtr(SPRITES+0x00)
    lda #<toSpritePtr3_return
    sta SPRITE_PTRS+2*SIZEOF_UNSIGNED_INT
    lda #>toSpritePtr3_return
    sta SPRITE_PTRS+2*SIZEOF_UNSIGNED_INT+1
    // VICIV->SPRITES_ENABLE = 7
    ldz #7
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_SPRITES_ENABLE
    // VICIV->SPRITES_PRIORITY = 0xff
    ldz #$ff
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_SPRITES_PRIORITY
    // SPRITES_COLOR[0] = DARK_GREY
    ldz #DARK_GREY
    stz SPRITES_COLOR
    // SPRITES_COLOR[1] = DARK_GREY
    stz SPRITES_COLOR+1
    // SPRITES_COLOR[2] = DARK_GREY
    stz SPRITES_COLOR+2
    // SPRITES_YPOS[0] = 0xe3
    ldz #$e3
    stz SPRITES_YPOS
    // SPRITES_YPOS[2] = 0xe3
    stz SPRITES_YPOS+2
    // SPRITES_YPOS[4] = 0xe3
    stz SPRITES_YPOS+4
    // SPRITES_XPOS[0] = 46
    ldz #$2e
    stz SPRITES_XPOS
    // SPRITES_XPOS[2] = 46+24
    ldz #$2e+$18
    stz SPRITES_XPOS+2
    // SPRITES_XPOS[4] = 25
    ldz #$19
    stz SPRITES_XPOS+4
    // *SPRITES_XMSB = 3
    ldz #3
    stz SPRITES_XMSB
    // init_plot()
  // Initialize plotter
    jsr init_plot
    // asm
    // Initialize SID 
    lda #0
    // (*musicInit)()
    jsr musicInit
  // Wait for the raster
  __b1:
    // while(VICIV->RASTER!=0xe3)
    ldz #$e3
    cpz VICIV+OFFSET_STRUCT_MEGA65_VICIV_RASTER
    bne __b1
    // buffer ^=1
    // Switch buffer
    lda #1
    eor.z buffer
    sta.z buffer
    // if(buffer==0)
    // Select charset 
    beq __b4
    // VICIV->CHARPTR_LOLO = LOBYTE
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOLO
    // VICIV->CHARPTR_LOHI = HIBYTE
    ldz #>GRAPHICS2
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOHI
    // VICIV->CHARPTR_HILO = 0
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_HILO
    // graphics_render = GRAPHICS1
    lda #<GRAPHICS1
    sta.z graphics_render
    lda #>GRAPHICS1
    sta.z graphics_render+1
  __b5:
    // VICIV->BORDER_COLOR = BLUE
    ldz #BLUE
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_BORDER_COLOR
    // memset_dma(graphics_render, 0x00, 40*25*8)
    lda.z graphics_render
    sta.z memset_dma.dest
    lda.z graphics_render+1
    sta.z memset_dma.dest+1
  // Clear the graphics
    jsr memset_dma
    // VICIV->BORDER_COLOR = PURPLE
    ldz #PURPLE
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_BORDER_COLOR
    // render_dots()
    // Render some dots
    jsr render_dots
    // VICIV->BORDER_COLOR = BLACK
    ldz #BLACK
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_BORDER_COLOR
    // (*musicPlay)()
    //Play  SID
    jsr musicPlay
    jmp __b1
  __b4:
    // VICIV->CHARPTR_LOLO = LOBYTE
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOLO
    // VICIV->CHARPTR_LOHI = HIBYTE
    ldz #>GRAPHICS1
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOHI
    // VICIV->CHARPTR_HILO = 0
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_HILO
    // graphics_render = GRAPHICS2
    lda #<GRAPHICS2
    sta.z graphics_render
    lda #>GRAPHICS2
    sta.z graphics_render+1
    jmp __b5
}
// Remap some of the eight 8K memory blocks in the 64K address space of the 6502 to point somewhere else in the first 1MB memory space of the MEGA65.
// After the remapping the CPU will access the mapped memory whenever it uses instructions that access a remapped block.
// See section 2.3.4 in http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt for a description of the CPU memory remapper of the C65.
// remapBlocks: Indicates which 8K blocks of the 6502 address space to remap. Each bit represents one 8K block
// - bit 0  Memory block $0000-$1fff. Use constant MEMORYBLOCK_0000.
// - bit 1  Memory block $2000-$3fff. Use constant MEMORYBLOCK_2000.
// - bit 2  Memory block $4000-$5fff. Use constant MEMORYBLOCK_4000.
// - bit 3  Memory block $6000-$7fff. Use constant MEMORYBLOCK_6000.
// - bit 4  Memory block $8000-$9fff. Use constant MEMORYBLOCK_8000.
// - bit 5  Memory block $a000-$bfff. Use constant MEMORYBLOCK_A000.
// - bit 6  Memory block $c000-$dfff. Use constant MEMORYBLOCK_C000.
// - bit 7  Memory block $e000-$ffff. Use constant MEMORYBLOCK_E000.
// lowerPageOffset: Offset that will be added to any remapped blocks in the lower 32K of memory (block 0-3).
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 12bits of the passed value is used.
// - If block 0 ($0000-$1fff) is remapped it will point to lowerPageOffset*$100.
// - If block 1 ($2000-$3fff) is remapped it will point to lowerPageOffset*$100 + $2000.
// - If block 2 ($4000-$5fff) is remapped it will point to lowerPageOffset*$100 + $4000.
// - If block 3 ($6000-$7fff) is remapped it will point to lowerPageOffset*$100 + $6000.
// upperPageOffset: Offset that will be added to any remapped blocks in the upper 32K of memory (block 4-7).
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 12bits of the passed value is used.
// - If block 4 ($8000-$9fff) is remapped it will point to upperPageOffset*$100 + $8000
// - If block 5 ($a000-$bfff) is remapped it will point to upperPageOffset*$100 + $a000.
// - If block 6 ($c000-$dfff) is remapped it will point to upperPageOffset*$100 + $c000.
// - If block 7 ($e000-$ffff) is remapped it will point to upperPageOffset*$100 + $e000.
// void memoryRemap(char remapBlocks, unsigned int lowerPageOffset, unsigned int upperPageOffset)
memoryRemap: {
    .label aVal = $2d
    .label xVal = $2c
    .label yVal = $2b
    .label zVal = $29
    // char aVal = BYTE0(lowerPageOffset)
    // lower blocks offset page low
    ldz #0
    stz.z aVal
    // char xVal = (remapBlocks << 4)   | (BYTE1(lowerPageOffset) & 0xf)
    // lower blocks to map + lower blocks offset high nibble
    stz.z xVal
    // char yVal = BYTE0(upperPageOffset)
    // upper blocks offset page
    stz.z yVal
    // char zVal = (remapBlocks & 0xf0) | (BYTE1(upperPageOffset) & 0xf)
    // upper blocks to map + upper blocks offset page high nibble
    stz.z zVal
    // asm
    lda aVal
    ldx xVal
    ldy yVal
    map
    eom
    // }
    rts
}
graphics_mode: {
    .label ch_x = $a
    // Layout screen so that graphics data comes from $40000 -- $4FFFF
    // Each column is consequtive values
    .label screen = 6
    .label ch = 4
    // Set color ram to white
    .label cols = $18
    .label i = $10
    // VICIV->CONTROLC = VICIV_CHR16|VICIV_VFAST
    // 16-bit text mode
    ldz #VICIV_CHR16|VICIV_VFAST
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    // VICIV->CONTROLB = VICIV_FAST
    // H320, fast CPU
    ldz #VICIV_FAST
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    // VICIV->CHARSTEP_LO = 80
    // 320x200 per char, 16 pixels wide per char
    // = 320/8 x 16 bits = 80 bytes per row
    ldz #$50
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARSTEP_LO
    // VICIV->CHARSTEP_HI = 0
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARSTEP_HI
    // VICIV->CHRCOUNT = 40
    // Draw 40 chars per row
    ldz #$28
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHRCOUNT
    // VICIV->SCRNPTR_LOLO = LOBYTE
    // Select 2KB screen
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_LOLO
    // VICIV->SCRNPTR_LOHI = HIBYTE
    ldz #>SCREEN
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_LOHI
    // VICIV->SCRNPTR_HILO = 0x00
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_HILO
    // VICIV->CHARPTR_LOLO = LOBYTE
    // Select charset 
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOLO
    // VICIV->CHARPTR_LOHI = HIBYTE
    ldz #>GRAPHICS1
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOHI
    // VICIV->CHARPTR_HILO = 0
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_HILO
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
    tza
    sta.z ch
    sta.z ch+1
    tax
  __b1:
    // for(char y=0;y<25;y++)
    cpx #$19
    bcc __b2
    lda #<$ff80000
    sta.z cols
    lda #>$ff80000
    sta.z cols+1
    lda #<$ff80000>>$10
    sta.z cols+2
    lda #>$ff80000>>$10
    sta.z cols+3
    lda #<0
    sta.z i
    sta.z i+1
  __b6:
    // for( unsigned int i=0; i<1000;i++)
    lda.z i+1
    cmp #>$3e8
    bcc __b7
    bne !+
    lda.z i
    cmp #<$3e8
    bcc __b7
  !:
    // VICIV->BORDER_COLOR = 0
    // Black border and background
    ldz #0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_BORDER_COLOR
    // VICIV->BG_COLOR = 0
    stz VICIV+OFFSET_STRUCT_MEGA65_VICIV_BG_COLOR
    // memset_dma(GRAPHICS1, 0x00, 40*25*8)
  // Clear the graphics
    lda #<GRAPHICS1
    sta.z memset_dma.dest
    lda #>GRAPHICS1
    sta.z memset_dma.dest+1
    jsr memset_dma
    // memset_dma(GRAPHICS2, 0x00, 40*25*8)
    lda #<GRAPHICS2
    sta.z memset_dma.dest
    lda #>GRAPHICS2
    sta.z memset_dma.dest+1
    jsr memset_dma
    // }
    rts
  __b7:
    // lpoke(cols++, 0)
    ldq.z cols
    stq.z lpoke.addr
    ldz #0
    stz.z lpoke.val
    jsr lpoke
    // lpoke(cols++, 0);
    inq.z cols
    // lpoke(cols++, WHITE)
    ldq.z cols
    stq.z lpoke.addr
    ldz #WHITE
    stz.z lpoke.val
    // No extended attributes
    jsr lpoke
    // lpoke(cols++, WHITE);
    inq.z cols
    // for( unsigned int i=0; i<1000;i++)
    inw.z i
    jmp __b6
  __b2:
    lda.z ch
    sta.z ch_x
    lda.z ch+1
    sta.z ch_x+1
    ldz #0
  __b3:
    // for(char x=0;x<40;x++)
    cpz #$28
    bcc __b4
    // screen += 40
    lda #$28*SIZEOF_UNSIGNED_INT
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // ch++;
    inw.z ch
    // for(char y=0;y<25;y++)
    inx
    jmp __b1
  __b4:
    // screen[x] = ch_x
    tza
    asl
    tay
    lda.z ch_x
    sta (screen),y
    iny
    lda.z ch_x+1
    sta (screen),y
    // ch_x += 25
    lda #$19
    clc
    adc.z ch_x
    sta.z ch_x
    bcc !+
    inc.z ch_x+1
  !:
    // for(char x=0;x<40;x++)
    inz
    jmp __b3
}
init_plot: {
    .label __4 = 8
    .label i = 4
    .label gfx = 6
    .label __5 = 8
    lda #<0
    sta.z gfx
    sta.z gfx+1
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned int i=0; i<320;i++)
    lda.z i+1
    cmp #>$140
    bcc __b2
    bne !+
    lda.z i
    cmp #<$140
    bcc __b2
  !:
    // }
    rts
  __b2:
    // GFX_OFFSET[i] = gfx
    lda.z i
    asl
    sta.z __4
    lda.z i+1
    rol
    sta.z __4+1
    lda.z __5
    clc
    adc #<GFX_OFFSET
    sta.z __5
    lda.z __5+1
    adc #>GFX_OFFSET
    sta.z __5+1
    ldy #0
    lda.z gfx
    sta (__5),y
    iny
    lda.z gfx+1
    sta (__5),y
    // i&7
    lda #7
    and.z i
    // if((i&7)==7)
    cmp #7
    bne __b3
    // gfx +=200
    lda #$c8
    clc
    adc.z gfx
    sta.z gfx
    bcc !+
    inc.z gfx+1
  !:
  __b3:
    // for(unsigned int i=0; i<320;i++)
    inw.z i
    jmp __b1
}
// Fill a memory block within the first 64K memory space using MEGA65 DMagic DMA
// Fills the values of num bytes at the destination with a single byte value.
// - dest The destination address (within the MB and bank)
// - fill The char to fill with
// - num The number of bytes to copy
// void memset_dma(__zp($c) void *dest, char fill, unsigned int num)
memset_dma: {
    .label dest = $c
    // char dmaMode = DMA->EN018B
    // Remember current F018 A/B mode
    ldx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // memset_dma_command.count = num
    // Set up command
    lda #<$28*$19*8
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_COUNT
    lda #>$28*$19*8
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_COUNT+1
    // memset_dma_command.src = (char*)fill
    lda #<0
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_SRC
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_SRC+1
    // memset_dma_command.dest = dest
    lda.z dest
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_DEST
    lda.z dest+1
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_DEST+1
    // DMA->EN018B = 1
    // Set F018B mode
    ldz #1
    stz DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // DMA->ADDRMB = 0
    // Set address of DMA list
    ldz #0
    stz DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRMB
    // DMA->ADDRBANK = 0
    stz DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRBANK
    // DMA-> ADDRMSB = BYTE1(&memset_dma_command)
    ldz #>memset_dma_command
    stz DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRMSB
    // DMA-> ADDRLSBTRIG = BYTE0(&memset_dma_command)
    // Trigger the DMA (without option lists)
    ldz #<memset_dma_command
    stz DMA
    // DMA->EN018B = dmaMode
    // Re-enable F018A mode
    stx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // }
    rts
}
render_dots: {
    .label __20 = 6
    .label __21 = $e
    .label idx_x1 = $a
    .label idx_x2 = $c
    .label idx_y1 = 8
    .label idx_y2 = 4
    .label i = $10
    .label __22 = 6
    .label __23 = $e
    .label __24 = $14
    .label __25 = $12
    // unsigned int idx_x1 = sin_x1_idx
    // Plot some dots
    lda.z sin_x1_idx
    sta.z idx_x1
    lda.z sin_x1_idx+1
    sta.z idx_x1+1
    // sin_x1_idx += 1
    inw.z sin_x1_idx
    // if(sin_x1_idx>SINX1_SIZE)
    lda.z sin_x1_idx+1
    cmp #>SINX1_SIZE
    bne !+
    lda.z sin_x1_idx
    cmp #<SINX1_SIZE
  !:
    bcc __b1
    beq __b1
    // sin_x1_idx -=SINX1_SIZE
    lda.z sin_x1_idx
    sec
    sbc #<SINX1_SIZE
    sta.z sin_x1_idx
    lda.z sin_x1_idx+1
    sbc #>SINX1_SIZE
    sta.z sin_x1_idx+1
  __b1:
    // unsigned int idx_x2 = sin_x2_idx
    lda.z sin_x2_idx
    sta.z idx_x2
    lda.z sin_x2_idx+1
    sta.z idx_x2+1
    // sin_x2_idx -= 1
    lda.z sin_x2_idx
    sec
    sbc #1
    sta.z sin_x2_idx
    lda.z sin_x2_idx+1
    sbc #0
    sta.z sin_x2_idx+1
    // if(sin_x2_idx>SINX2_SIZE)
    cmp #>SINX2_SIZE
    bne !+
    lda.z sin_x2_idx
    cmp #<SINX2_SIZE
  !:
    bcc __b2
    beq __b2
    // sin_x2_idx +=SINX2_SIZE
    lda.z sin_x2_idx
    clc
    adc #<SINX2_SIZE
    sta.z sin_x2_idx
    lda.z sin_x2_idx+1
    adc #>SINX2_SIZE
    sta.z sin_x2_idx+1
  __b2:
    // unsigned int idx_y1 = sin_y1_idx
    lda.z sin_y1_idx
    sta.z idx_y1
    lda.z sin_y1_idx+1
    sta.z idx_y1+1
    // sin_y1_idx -= 1
    lda.z sin_y1_idx
    sec
    sbc #1
    sta.z sin_y1_idx
    lda.z sin_y1_idx+1
    sbc #0
    sta.z sin_y1_idx+1
    // if(sin_y1_idx>SINY1_SIZE)
    cmp #>SINY1_SIZE
    bne !+
    lda.z sin_y1_idx
    cmp #<SINY1_SIZE
  !:
    bcc __b3
    beq __b3
    // sin_y1_idx +=SINY1_SIZE
    lda.z sin_y1_idx
    clc
    adc #<SINY1_SIZE
    sta.z sin_y1_idx
    lda.z sin_y1_idx+1
    adc #>SINY1_SIZE
    sta.z sin_y1_idx+1
  __b3:
    // unsigned int idx_y2 = sin_y2_idx
    lda.z sin_y2_idx
    sta.z idx_y2
    lda.z sin_y2_idx+1
    sta.z idx_y2+1
    // sin_y2_idx += 1
    inw.z sin_y2_idx
    // if(sin_y2_idx>SINY2_SIZE)
    lda.z sin_y2_idx+1
    cmp #>SINY2_SIZE
    bne !+
    lda.z sin_y2_idx
    cmp #<SINY2_SIZE
  !:
    bcc __b4
    beq __b4
    // sin_y2_idx -=SINY2_SIZE
    lda.z sin_y2_idx
    sec
    sbc #<SINY2_SIZE
    sta.z sin_y2_idx
    lda.z sin_y2_idx+1
    sbc #>SINY2_SIZE
    sta.z sin_y2_idx+1
  __b4:
    lda #<0
    sta.z i
    sta.z i+1
  __b8:
    // for(unsigned int i=0;i<1536;i++)
    lda.z i+1
    cmp #>$600
    bcc __b9
    bne !+
    lda.z i
    cmp #<$600
    bcc __b9
  !:
    // }
    rts
  __b9:
    // SINX1[idx_x1]+SINX2[idx_x2]
    lda.z idx_x1
    asl
    sta.z __20
    lda.z idx_x1+1
    rol
    sta.z __20+1
    lda.z idx_x2
    asl
    sta.z __21
    lda.z idx_x2+1
    rol
    sta.z __21+1
    // plot(SINX1[idx_x1]+SINX2[idx_x2], SINY1[idx_y1]+SINY2[idx_y2])
    lda.z __22
    clc
    adc #<SINX1
    sta.z __22
    lda.z __22+1
    adc #>SINX1
    sta.z __22+1
    lda.z __23
    clc
    adc #<SINX2
    sta.z __23
    lda.z __23+1
    adc #>SINX2
    sta.z __23+1
    ldy #0
    clc
    lda (plot.x),y
    adc (__23),y
    pha
    iny
    lda (plot.x),y
    adc (__23),y
    sta.z plot.x+1
    pla
    sta.z plot.x
    lda.z idx_y1
    clc
    adc #<SINY1
    sta.z __24
    lda.z idx_y1+1
    adc #>SINY1
    sta.z __24+1
    lda.z idx_y2
    clc
    adc #<SINY2
    sta.z __25
    lda.z idx_y2+1
    adc #>SINY2
    sta.z __25+1
    ldy #0
    lda (__24),y
    clc
    adc (__25),y
    taz
    jsr plot
    // idx_x1 -= 11
    sec
    lda.z idx_x1
    sbc #$b
    sta.z idx_x1
    lda.z idx_x1+1
    sbc #0
    sta.z idx_x1+1
    // if(idx_x1>SINX1_SIZE)
    cmp #>SINX1_SIZE
    bne !+
    lda.z idx_x1
    cmp #<SINX1_SIZE
  !:
    bcc __b10
    beq __b10
    // idx_x1 += SINX1_SIZE
    lda.z idx_x1
    clc
    adc #<SINX1_SIZE
    sta.z idx_x1
    lda.z idx_x1+1
    adc #>SINX1_SIZE
    sta.z idx_x1+1
  __b10:
    // idx_x2 += 3
    lda #3
    clc
    adc.z idx_x2
    sta.z idx_x2
    bcc !+
    inc.z idx_x2+1
  !:
    // if(idx_x2>SINX2_SIZE)
    lda.z idx_x2+1
    cmp #>SINX2_SIZE
    bne !+
    lda.z idx_x2
    cmp #<SINX2_SIZE
  !:
    bcc __b11
    beq __b11
    // idx_x2 -= SINX2_SIZE
    lda.z idx_x2
    sec
    sbc #<SINX2_SIZE
    sta.z idx_x2
    lda.z idx_x2+1
    sbc #>SINX2_SIZE
    sta.z idx_x2+1
  __b11:
    // idx_y1 += 9
    lda #9
    clc
    adc.z idx_y1
    sta.z idx_y1
    bcc !+
    inc.z idx_y1+1
  !:
    // if(idx_y1>SINY1_SIZE)
    lda.z idx_y1+1
    cmp #>SINY1_SIZE
    bne !+
    lda.z idx_y1
    cmp #<SINY1_SIZE
  !:
    bcc __b12
    beq __b12
    // idx_y1 -= SINY1_SIZE
    lda.z idx_y1
    sec
    sbc #<SINY1_SIZE
    sta.z idx_y1
    lda.z idx_y1+1
    sbc #>SINY1_SIZE
    sta.z idx_y1+1
  __b12:
    // idx_y2 -= 5
    sec
    lda.z idx_y2
    sbc #5
    sta.z idx_y2
    lda.z idx_y2+1
    sbc #0
    sta.z idx_y2+1
    // if(idx_y2>SINY2_SIZE)
    cmp #>SINY2_SIZE
    bne !+
    lda.z idx_y2
    cmp #<SINY2_SIZE
  !:
    bcc __b13
    beq __b13
    // idx_y2 += SINY2_SIZE
    lda.z idx_y2
    clc
    adc #<SINY2_SIZE
    sta.z idx_y2
    lda.z idx_y2+1
    adc #>SINY2_SIZE
    sta.z idx_y2+1
  __b13:
    // for(unsigned int i=0;i<1536;i++)
    inw.z i
    jmp __b8
}
// Get the low byte from a word/int
// Get the high byte from a word/int
// Poke a byte value into memory
// Peek a byte value from memory
// Poke a value directly into memory
// - addr: The 32bit address to poke to
// - val: The value to poke
// void lpoke(__zp($1d) volatile unsigned long addr, __zp($1c) volatile char val)
lpoke: {
    .label addr = $1d
    .label val = $1c
    // asm
    // Use the 45GS02 32-bit addressing mode
    ldz #0
    lda val
    sta ((addr)),z
    // }
    rts
}
// Do a single plot on the canvas
// void plot(__zp(6) unsigned int x, __register(Z) char y)
plot: {
    .label __0 = 2
    .label __3 = 2
    .label x = 6
    .label __4 = 2
    // graphics_render + GFX_OFFSET[x]
    lda.z x
    asl
    sta.z __3
    lda.z x+1
    rol
    sta.z __3+1
    lda.z __4
    clc
    adc #<GFX_OFFSET
    sta.z __4
    lda.z __4+1
    adc #>GFX_OFFSET
    sta.z __4+1
    ldy #0
    clc
    lda (__0),y
    adc.z graphics_render
    pha
    iny
    lda (__0),y
    adc.z graphics_render+1
    sta.z __0+1
    pla
    sta.z __0
    // x&7
    lda #7
    and.z x
    // *gfx |= GFX_BIT[x&7]
    tax
    tza
    tay
    lda (__0),y
    ora GFX_BIT,x
    sta (__0),y
    // }
    rts
}
.segment Data
  .align $40
SPRITES:
.var pic = LoadPicture("camelot-sprites.png", List().add($000000, $ffffff))
    .for (var s=0; s<3; s++) {
      .for (var y=0; y<21; y++) {
          .for (var x=0;x<3; x++) {
              .byte pic.getSinglecolorByte(s*3+x,y)
          }
      }
      .byte 0
    }       

  // The sprite pointers
  SPRITE_PTRS: .fill 2*8, 0
  // Graphics bit
  GFX_BIT: .byte $80, $40, $20, $10, 8, 4, 2, 1
  // Offset to graphics for (x, 0)
  GFX_OFFSET: .fill 2*$140, 0
SINY1:
.fill 733+256, round(66.5+66.5*sin(toRadians(360*i/733)))

SINY2:
.fill 317+256, round(33+33*sin(toRadians(360*i/317)))

SINX1:
.fillword 1613+256, round(98+98*sin(toRadians(360*i/1613)))

SINX2:
.fillword 547+256, round(60+60*sin(toRadians(360*i/547)))

  // DMA list entry for filling data
  memset_dma_command: .byte DMA_COMMAND_FILL
  .word 0, 0
  .byte 0
  .word 0
  .byte 0, 0
  .word 0
.pc = $5000 "MUSIC"
// SID tune at an absolute address
MUSIC:
.const music = LoadSid("Thaw_5000.sid")
    .fill music.size, music.getData(i)

