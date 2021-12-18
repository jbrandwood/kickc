// Example program for the Commander X16.
// Demonstrates the usage of the VERA layer 0 and 1.
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cx16-tilemap.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  /// The colors of the CX16
  .const BLACK = 0
  .const WHITE = 1
  .const GREEN = 5
  .const BLUE = 6
  .const YELLOW = 7
  .const DARK_GREY = $b
  .const GREY = $c
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const VERA_VSYNC = 1
  .const VERA_LAYER1_ENABLE = $20
  .const VERA_LAYER0_ENABLE = $10
  .const VERA_LAYER_WIDTH_64 = $10
  .const VERA_LAYER_WIDTH_128 = $20
  .const VERA_LAYER_WIDTH_256 = $30
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_64 = $40
  .const VERA_LAYER_HEIGHT_128 = $80
  .const VERA_LAYER_HEIGHT_256 = $c0
  .const VERA_LAYER_HEIGHT_MASK = $c0
  /// Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
  .const VERA_LAYER_COLOR_DEPTH_1BPP = 0
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_TILEBASE_WIDTH_16 = 1
  .const VERA_TILEBASE_HEIGHT_16 = 2
  .const VERA_LAYER_TILEBASE_MASK = $fc
  .const SIZEOF_POINTER = 2
  .const STACK_BASE = $103
  /// $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  /// $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  /// $9F22 VRAM Address (7:0)
  /// Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  ///                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  /// Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  /// Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  /// $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  /// $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
  /// $9F25	CTRL Control
  /// Bit 7: Reset
  /// Bit 1: DCSEL
  /// Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  /// $9F26	IEN		Interrupt Enable
  /// Bit 7: IRQ line (8)
  /// Bit 3: AFLOW
  /// Bit 2: SPRCOL
  /// Bit 1: LINE
  /// Bit 0: VSYNC
  .label VERA_IEN = $9f26
  /// $9F27	ISR     Interrupt Status
  /// Interrupts will be generated for the interrupt sources set in the lower 4 bits of IEN. ISR will indicate the interrupts that have occurred.
  /// Writing a 1 to one of the lower 3 bits in ISR will clear that interrupt status. AFLOW can only be cleared by filling the audio FIFO for at least 1/4.
  /// Bit 4-7: Sprite Collisions. This field indicates which groups of sprites have collided.
  /// Bit 3: AFLOW
  /// Bit 2: SPRCOL
  /// Bit 1: LINE
  /// Bit 0: VSYNC
  .label VERA_ISR = $9f27
  /// $9F29	DC_VIDEO (DCSEL=0)
  /// Bit 7: Current Field     Read-only bit which reflects the active interlaced field in composite and RGB modes. (0: even, 1: odd)
  /// Bit 6: Sprites Enable	Enable output from the Sprites renderer
  /// Bit 5: Layer1 Enable	    Enable output from the Layer1 renderer
  /// Bit 4: Layer0 Enable	    Enable output from the Layer0 renderer
  /// Bit 2: Chroma Disable    Setting 'Chroma Disable' disables output of chroma in NTSC composite mode and will give a better picture on a monochrome display. (Setting this bit will also disable the chroma output on the S-video output.)
  /// Bit 0-1: Output Mode     0: Video disabled, 1: VGA output, 2: NTSC composite, 3: RGB interlaced, composite sync (via VGA connector)
  .label VERA_DC_VIDEO = $9f29
  /// $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  /// $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  /// $9F2D	L0_CONFIG   Layer 0 Configuration
  .label VERA_L0_CONFIG = $9f2d
  /// $9F2E	L0_MAPBASE	    Layer 0 Map Base Address (16:9)
  .label VERA_L0_MAPBASE = $9f2e
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L0_TILEBASE = $9f2f
  /// $9F30	L0_HSCROLL_L	Layer 0 H-Scroll (7:0)
  .label VERA_L0_HSCROLL_L = $9f30
  /// $9F31	L0_HSCROLL_H	Layer 0 H-Scroll (11:8)
  .label VERA_L0_HSCROLL_H = $9f31
  /// $9F32	L0_VSCROLL_L	Layer 0 V-Scroll (7:0)
  .label VERA_L0_VSCROLL_L = $9f32
  /// $9F33	L0_VSCROLL_H    Layer 0 V-Scroll (11:8)
  .label VERA_L0_VSCROLL_H = $9f33
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  /// $9F36	L1_TILEBASE	    Layer 1 Tile Base
  /// Bit 2-7: Tile Base Address (16:11)
  /// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
  /// $9F37	L1_HSCROLL_L	Layer 1 H-Scroll (7:0)
  .label VERA_L1_HSCROLL_L = $9f37
  /// $9F38	L1_HSCROLL_H	Layer 1 H-Scroll (11:8)
  .label VERA_L1_HSCROLL_H = $9f38
  /// $9F39	L1_VSCROLL_L	Layer 1 V-Scroll (7:0)
  .label VERA_L1_VSCROLL_L = $9f39
  /// $9F3A	L1_VSCROLL_H	Layer 1 V-Scroll (11:8)
  .label VERA_L1_VSCROLL_H = $9f3a
  /// $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  // Variable holding the screen width;
  .label conio_screen_width = $c
  // Variable holding the screen height;
  .label conio_screen_height = $17
  // Variable holding the screen layer on the VERA card with which conio interacts;
  .label conio_screen_layer = $16
  // Variables holding the current map width and map height of the layer.
  .label conio_width = $27
  .label conio_height = $1a
  .label conio_rowshift = $f
  .label conio_rowskip = $10
  // X sine index
  .label scroll_x = $5b
  .label scroll_y = $5d
  .label delta_x = $47
  .label delta_y = $51
  .label speed = $61
  .label CONIO_SCREEN_BANK = $1e
  .label CONIO_SCREEN_BANK_1 = $49
  // The screen width
  // The screen height
  // The text screen base address, which is a 16:0 bit value in VERA VRAM.
  // That is 128KB addressable space, thus 17 bits in total.
  // CONIO_SCREEN_TEXT contains bits 15:0 of the address.
  // CONIO_SCREEN_BANK contains bit 16, the the 64K memory bank in VERA VRAM (the upper 17th bit).
  // !!! note that these values are not const for the cx16!
  // This conio implements the two layers of VERA, which can be layer 0 or layer 1.
  // Configuring conio to output to a different layer, will change these fields to the address base
  // configured using VERA_L0_MAPBASE = 0x9f2e or VERA_L1_MAPBASE = 0x9f35.
  // Using the function setscreenlayer(layer) will re-calculate using CONIO_SCREEN_TEXT and CONIO_SCREEN_BASE
  // based on the values of VERA_L0_MAPBASE or VERA_L1_MAPBASE, mapping the base address of the selected layer.
  // The function setscreenlayermapbase(layer,mapbase) allows to configure bit 16:9 of the
  // mapbase address of the time map in VRAM of the selected layer VERA_L0_MAPBASE or VERA_L1_MAPBASE.
  .label CONIO_SCREEN_TEXT = $d
  // The screen width
  // The screen height
  // The text screen base address, which is a 16:0 bit value in VERA VRAM.
  // That is 128KB addressable space, thus 17 bits in total.
  // CONIO_SCREEN_TEXT contains bits 15:0 of the address.
  // CONIO_SCREEN_BANK contains bit 16, the the 64K memory bank in VERA VRAM (the upper 17th bit).
  // !!! note that these values are not const for the cx16!
  // This conio implements the two layers of VERA, which can be layer 0 or layer 1.
  // Configuring conio to output to a different layer, will change these fields to the address base
  // configured using VERA_L0_MAPBASE = 0x9f2e or VERA_L1_MAPBASE = 0x9f35.
  // Using the function setscreenlayer(layer) will re-calculate using CONIO_SCREEN_TEXT and CONIO_SCREEN_BASE
  // based on the values of VERA_L0_MAPBASE or VERA_L1_MAPBASE, mapping the base address of the selected layer.
  // The function setscreenlayermapbase(layer,mapbase) allows to configure bit 16:9 of the
  // mapbase address of the time map in VRAM of the selected layer VERA_L0_MAPBASE or VERA_L1_MAPBASE.
  .label CONIO_SCREEN_TEXT_1 = $5f
.segment Code
__start: {
    // __ma unsigned byte conio_screen_width = 0
    lda #0
    sta.z conio_screen_width
    // __ma unsigned byte conio_screen_height = 0
    sta.z conio_screen_height
    // __ma unsigned byte conio_screen_layer = 1
    lda #1
    sta.z conio_screen_layer
    // __ma word conio_width = 0
    lda #<0
    sta.z conio_width
    sta.z conio_width+1
    // __ma word conio_height = 0
    sta.z conio_height
    sta.z conio_height+1
    // __ma byte conio_rowshift = 0
    sta.z conio_rowshift
    // __ma word conio_rowskip = 0
    sta.z conio_rowskip
    sta.z conio_rowskip+1
    // volatile int scroll_x = 0
    sta.z scroll_x
    sta.z scroll_x+1
    // volatile int scroll_y = 0
    sta.z scroll_y
    sta.z scroll_y+1
    // volatile int delta_x = 2
    lda #<2
    sta.z delta_x
    lda #>2
    sta.z delta_x+1
    // volatile int delta_y = 0
    sta.z delta_y
    sta.z delta_y+1
    // volatile int speed = 2
    lda #<2
    sta.z speed
    lda #>2
    sta.z speed+1
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    jsr conio_x16_init
    jsr main
    rts
}
// VSYNC Interrupt Routine
irq_vsync: {
    .label __10 = $53
    .label __11 = $55
    .label vera_layer_set_horizontal_scroll1_scroll = $57
    .label vera_layer_set_vertical_scroll1_scroll = $59
    // scroll_x += delta_x
    clc
    lda.z scroll_x
    adc.z delta_x
    sta.z scroll_x
    lda.z scroll_x+1
    adc.z delta_x+1
    sta.z scroll_x+1
    // scroll_y += delta_y
    clc
    lda.z scroll_y
    adc.z delta_y
    sta.z scroll_y
    lda.z scroll_y+1
    adc.z delta_y+1
    sta.z scroll_y+1
    // if( scroll_x>(128*8-80*8))
    lda #<$80*8-$50*8
    cmp.z scroll_x
    lda #>$80*8-$50*8
    sbc.z scroll_x+1
    bvc !+
    eor #$80
  !:
    bpl __b1
    // delta_x = 0
    lda #<0
    sta.z delta_x
    sta.z delta_x+1
    // delta_y = speed
    lda.z speed
    sta.z delta_y
    lda.z speed+1
    sta.z delta_y+1
    // scroll_x = (128*8-80*8)
    lda #<$80*8-$50*8
    sta.z scroll_x
    lda #>$80*8-$50*8
    sta.z scroll_x+1
  __b1:
    // if( scroll_y>(128*8-60*8))
    lda #<$80*8-$3c*8
    cmp.z scroll_y
    lda #>$80*8-$3c*8
    sbc.z scroll_y+1
    bvc !+
    eor #$80
  !:
    bpl __b2
    // -speed
    sec
    lda #0
    sbc.z speed
    sta.z __10
    lda #0
    sbc.z speed+1
    sta.z __10+1
    // delta_x = -speed
    lda.z __10
    sta.z delta_x
    lda.z __10+1
    sta.z delta_x+1
    // delta_y = 0
    lda #<0
    sta.z delta_y
    sta.z delta_y+1
    // scroll_y = (128*8-60*8)
    lda #<$80*8-$3c*8
    sta.z scroll_y
    lda #>$80*8-$3c*8
    sta.z scroll_y+1
  __b2:
    // if(scroll_x<0)
    lda.z scroll_x+1
    bpl __b3
    // delta_x = 0
    lda #<0
    sta.z delta_x
    sta.z delta_x+1
    // -speed
    sec
    sbc.z speed
    sta.z __11
    lda #0
    sbc.z speed+1
    sta.z __11+1
    // delta_y = -speed
    lda.z __11
    sta.z delta_y
    lda.z __11+1
    sta.z delta_y+1
    // scroll_x = 0
    lda #<0
    sta.z scroll_x
    sta.z scroll_x+1
  __b3:
    // if(scroll_y<0)
    lda.z scroll_y+1
    bpl __b4
    // delta_x = speed
    lda.z speed
    sta.z delta_x
    lda.z speed+1
    sta.z delta_x+1
    // delta_y = 0
    lda #<0
    sta.z delta_y
    sta.z delta_y+1
    // scroll_y = 0
    sta.z scroll_y
    sta.z scroll_y+1
  __b4:
    // vera_layer_set_horizontal_scroll(0,(word)scroll_x)
    lda.z scroll_x
    sta.z vera_layer_set_horizontal_scroll1_scroll
    lda.z scroll_x+1
    sta.z vera_layer_set_horizontal_scroll1_scroll+1
    // BYTE0(scroll)
    lda.z vera_layer_set_horizontal_scroll1_scroll
    // *vera_layer_hscroll_l[layer] = BYTE0(scroll)
    ldy vera_layer_hscroll_l
    sty.z $fe
    ldy vera_layer_hscroll_l+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // BYTE1(scroll)
    lda.z vera_layer_set_horizontal_scroll1_scroll+1
    // *vera_layer_hscroll_h[layer] = BYTE1(scroll)
    ldy vera_layer_hscroll_h
    sty.z $fe
    ldy vera_layer_hscroll_h+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // vera_layer_set_vertical_scroll(0,(word)scroll_y)
    lda.z scroll_y
    sta.z vera_layer_set_vertical_scroll1_scroll
    lda.z scroll_y+1
    sta.z vera_layer_set_vertical_scroll1_scroll+1
    // BYTE0(scroll)
    lda.z vera_layer_set_vertical_scroll1_scroll
    // *vera_layer_vscroll_l[layer] = BYTE0(scroll)
    ldy vera_layer_vscroll_l
    sty.z $fe
    ldy vera_layer_vscroll_l+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // BYTE1(scroll)
    lda.z vera_layer_set_vertical_scroll1_scroll+1
    // *vera_layer_vscroll_h[layer] = BYTE1(scroll)
    ldy vera_layer_vscroll_h
    sty.z $fe
    ldy vera_layer_vscroll_h+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *VERA_ISR = VERA_VSYNC
    // Reset the VSYNC interrupt
    lda #VERA_VSYNC
    sta VERA_ISR
    // }
    jmp $e034
}
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = $4e
    // char line = *BASIC_CURSOR_LINE
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    jsr vera_layer_mode_text
    // screensize(&conio_screen_width, &conio_screen_height)
    jsr screensize
    // screenlayer(1)
    lda #1
    jsr screenlayer
    // vera_layer_set_textcolor(1, WHITE)
    lda #WHITE
    ldx #1
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(1, BLUE)
    lda #BLUE
    ldx #1
    jsr vera_layer_set_backcolor
    // vera_layer_set_mapbase(0,0x20)
    ldx #$20
    lda #0
    jsr vera_layer_set_mapbase
    // vera_layer_set_mapbase(1,0x00)
    ldx #0
    lda #1
    jsr vera_layer_set_mapbase
    // if(line>=CONIO_HEIGHT)
    lda.z line
    cmp.z conio_screen_height
    bcc __b1
    // line=CONIO_HEIGHT-1
    ldx.z conio_screen_height
    dex
    stx.z line
  __b1:
    // gotoxy(0, line)
    ldx.z line
    jsr gotoxy
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($1d) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label __16 = $18
    .label c = $1d
    .label conio_addr = 2
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // char color = vera_layer_get_color( conio_screen_layer)
    ldx.z conio_screen_layer
    jsr vera_layer_get_color
    // char color = vera_layer_get_color( conio_screen_layer)
    tax
    // char* conio_addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    lda.z conio_screen_layer
    asl
    tay
    clc
    lda.z CONIO_SCREEN_TEXT
    adc conio_line_text,y
    sta.z conio_addr
    lda.z CONIO_SCREEN_TEXT+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[conio_screen_layer] << 1
    ldy.z conio_screen_layer
    lda conio_cursor_x,y
    asl
    // conio_addr += conio_cursor_x[conio_screen_layer] << 1
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    lda #'\n'
    cmp.z c
    beq __b1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(conio_addr)
    lda.z conio_addr
    // *VERA_ADDRX_L = BYTE0(conio_addr)
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(conio_addr)
    lda.z conio_addr+1
    // *VERA_ADDRX_M = BYTE1(conio_addr)
    sta VERA_ADDRX_M
    // CONIO_SCREEN_BANK | VERA_INC_1
    lda #VERA_INC_1
    ora.z CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = CONIO_SCREEN_BANK | VERA_INC_1
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    stx VERA_DATA0
    // conio_cursor_x[conio_screen_layer]++;
    ldx.z conio_screen_layer
    inc conio_cursor_x,x
    // byte scroll_enable = conio_scroll_enable[conio_screen_layer]
    ldy.z conio_screen_layer
    lda conio_scroll_enable,y
    // if(scroll_enable)
    cmp #0
    bne __b5
    // (unsigned int)conio_cursor_x[conio_screen_layer] == conio_width
    lda conio_cursor_x,y
    sta.z __16
    lda #0
    sta.z __16+1
    // if((unsigned int)conio_cursor_x[conio_screen_layer] == conio_width)
    cmp.z conio_width+1
    bne __breturn
    lda.z __16
    cmp.z conio_width
    bne __breturn
    // cputln()
    jsr cputln
  __breturn:
    // }
    rts
  __b5:
    // if(conio_cursor_x[conio_screen_layer] == CONIO_WIDTH)
    lda.z conio_screen_width
    ldy.z conio_screen_layer
    cmp conio_cursor_x,y
    bne __breturn
    // cputln()
    jsr cputln
    rts
  __b1:
    // cputln()
    jsr cputln
    rts
}
main: {
    .label tilebase = $4a
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #WHITE
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // clrscr()
    jsr clrscr
    // dword tilebase = vera_layer_get_tilebase_address(1)
    jsr vera_layer_get_tilebase_address
    // vera_layer_mode_tile(0, 0x10000, tilebase, 128, 128, 8, 8, 1)
    lda.z tilebase
    sta.z vera_layer_mode_tile.tilebase_address
    lda.z tilebase+1
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda.z tilebase+2
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda.z tilebase+3
    sta.z vera_layer_mode_tile.tilebase_address+3
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    sta.z vera_layer_mode_tile.tilewidth
    lda #<$10000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$10000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$10000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$10000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    lda #<$80
    sta.z vera_layer_mode_tile.mapheight
    lda #>$80
    sta.z vera_layer_mode_tile.mapheight+1
    lda #0
    sta.z vera_layer_mode_tile.layer
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    jsr vera_layer_mode_tile
    // screenlayer(0)
    lda #0
    jsr screenlayer
    // scroll(0)
    jsr scroll
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #WHITE
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #GREEN
    jsr vera_layer_set_backcolor
    // draw_characters(tilebase)
    lda.z tilebase
    sta.z draw_characters.tilebase
    lda.z tilebase+1
    sta.z draw_characters.tilebase+1
    lda.z tilebase+2
    sta.z draw_characters.tilebase+2
    lda.z tilebase+3
    sta.z draw_characters.tilebase+3
    jsr draw_characters
    // asm
    sei
    // *KERNEL_IRQ = &irq_vsync
    lda #<irq_vsync
    sta KERNEL_IRQ
    lda #>irq_vsync
    sta KERNEL_IRQ+1
    // *VERA_IEN = VERA_VSYNC
    lda #VERA_VSYNC
    sta VERA_IEN
    // asm
    cli
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
  __b1:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b1
    // ~vera_layer_enable[layer]
    lda vera_layer_enable
    eor #$ff
    // *VERA_DC_VIDEO &= ~vera_layer_enable[layer]
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #GREY
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #GREEN
    jsr vera_layer_set_backcolor
    // draw_characters(tilebase)
    lda.z tilebase
    sta.z draw_characters.tilebase
    lda.z tilebase+1
    sta.z draw_characters.tilebase+1
    lda.z tilebase+2
    sta.z draw_characters.tilebase+2
    lda.z tilebase+3
    sta.z draw_characters.tilebase+3
    jsr draw_characters
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // screenlayer(1)
    lda #1
    jsr screenlayer
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #WHITE
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // printf("\n\nthis demo displays the design of the standard x16 commander\n")
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // printf("character set on the vera layer 0. it's the character set i grew up with :-).\n")
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("\nthe smooth scrolling is implemented by manipulating the scrolling \n")
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // printf("registers of layer 0. at each raster line interrupt, \n")
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // printf("the x and y scrolling registers are manipulated. the cx16 terminal \n")
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("works on layer 1. when layer 0 is enabled with the scrolling, \n")
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // printf("it gives a nice background effect. this technique can be used to implement\n")
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // printf("smooth scrolling backgrounds using tile layouts in games or demos.\n")
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #YELLOW
    jsr vera_layer_set_textcolor
    // printf("\npress a key to continue ...")
    lda #<s8
    sta.z printf_str.s
    lda #>s8
    sta.z printf_str.s+1
    jsr printf_str
  __b2:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b2
    // screenlayer(0)
    lda #0
    jsr screenlayer
    // ~vera_layer_enable[layer]
    lda vera_layer_enable
    eor #$ff
    // *VERA_DC_VIDEO &= ~vera_layer_enable[layer]
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #DARK_GREY
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // draw_characters(tilebase)
    lda.z tilebase
    sta.z draw_characters.tilebase
    lda.z tilebase+1
    sta.z draw_characters.tilebase+1
    lda.z tilebase+2
    sta.z draw_characters.tilebase+2
    lda.z tilebase+3
    sta.z draw_characters.tilebase+3
    jsr draw_characters
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // screenlayer(1)
    lda #1
    jsr screenlayer
    // gotoxy(0,20)
    ldx #$14
    jsr gotoxy
    // }
    rts
  .segment Data
    s: .text @"\n\nthis demo displays the design of the standard x16 commander\n"
    .byte 0
    s1: .text @"character set on the vera layer 0. it's the character set i grew up with :-).\n"
    .byte 0
    s2: .text @"\nthe smooth scrolling is implemented by manipulating the scrolling \n"
    .byte 0
    s3: .text @"registers of layer 0. at each raster line interrupt, \n"
    .byte 0
    s4: .text @"the x and y scrolling registers are manipulated. the cx16 terminal \n"
    .byte 0
    s5: .text @"works on layer 1. when layer 0 is enabled with the scrolling, \n"
    .byte 0
    s6: .text @"it gives a nice background effect. this technique can be used to implement\n"
    .byte 0
    s7: .text @"smooth scrolling backgrounds using tile layouts in games or demos.\n"
    .byte 0
    s8: .text @"\npress a key to continue ..."
    .byte 0
}
.segment Code
// Set a vera layer in text mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_mode: The color mode, which can be 16 or 256.
// void vera_layer_mode_text(char layer, unsigned long mapbase_address, unsigned long tilebase_address, unsigned int mapwidth, unsigned int mapheight, char tilewidth, char tileheight, unsigned int color_mode)
vera_layer_mode_text: {
    .const mapbase_address = 0
    .const tilebase_address = $f800
    .const mapwidth = $80
    .const mapheight = $40
    .const tilewidth = 8
    .const tileheight = 8
    .label layer = 1
    // vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 )
    lda #tileheight
    sta.z vera_layer_mode_tile.tileheight
    lda #tilewidth
    sta.z vera_layer_mode_tile.tilewidth
    lda #<tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    lda #<mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    lda #<mapheight
    sta.z vera_layer_mode_tile.mapheight
    lda #>mapheight
    sta.z vera_layer_mode_tile.mapheight+1
    lda #layer
    sta.z vera_layer_mode_tile.layer
    lda #<mapwidth
    sta.z vera_layer_mode_tile.mapwidth
    lda #>mapwidth
    sta.z vera_layer_mode_tile.mapwidth+1
    jsr vera_layer_mode_tile
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    jsr vera_layer_set_text_color_mode
    // }
    rts
}
// Return the current screen size.
// void screensize(char *x, char *y)
screensize: {
    .label x = conio_screen_width
    .label y = conio_screen_height
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // VERA returns in VERA_DC_HSCALE the value of 128 when 80 columns is used in text mode,
    // and the value of 64 when 40 columns is used in text mode.
    // Basically, 40 columns mode in the VERA is a double scan mode.
    // Same for the VERA_DC_VSCALE mode, but then the subdivision is 60 or 30 rows.
    // I still need to test the other modes, but this will suffice for now for the pure text modes.
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    // 40 << hscale
    tay
    lda #$28
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // *x = 40 << hscale
    sta.z x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    // 30 << vscale
    tay
    lda #$1e
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // *y = 30 << vscale
    sta.z y
    // }
    rts
}
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
// void screenlayer(__register(A) char layer)
screenlayer: {
    .label __2 = $25
    .label __4 = $14
    .label __5 = $30
    .label vera_layer_get_width1_config = $42
    .label vera_layer_get_width1_return = $25
    .label vera_layer_get_height1_config = $3f
    .label vera_layer_get_height1_return = $30
    // conio_screen_layer = layer
    sta.z conio_screen_layer
    // vera_layer_get_mapbase_bank(conio_screen_layer)
    tax
    jsr vera_layer_get_mapbase_bank
    sta.z CONIO_SCREEN_BANK_1
    // vera_layer_get_mapbase_offset(conio_screen_layer)
    lda.z conio_screen_layer
    jsr vera_layer_get_mapbase_offset
    lda.z vera_layer_get_mapbase_offset.return
    sta.z CONIO_SCREEN_TEXT_1
    lda.z vera_layer_get_mapbase_offset.return+1
    sta.z CONIO_SCREEN_TEXT_1+1
    // vera_layer_get_width(conio_screen_layer)
    lda.z conio_screen_layer
    // byte* config = vera_layer_config[layer]
    asl
    tay
    lda vera_layer_config,y
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+1,y
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    lsr
    lsr
    lsr
    lsr
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    asl
    tay
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // }
    // vera_layer_get_width(conio_screen_layer)
    // conio_width = vera_layer_get_width(conio_screen_layer)
    lda.z __2
    sta.z conio_width
    lda.z __2+1
    sta.z conio_width+1
    // vera_layer_get_rowshift(conio_screen_layer)
    ldx.z conio_screen_layer
    jsr vera_layer_get_rowshift
    // conio_rowshift = vera_layer_get_rowshift(conio_screen_layer)
    sta.z conio_rowshift
    // vera_layer_get_rowskip(conio_screen_layer)
    lda.z conio_screen_layer
    jsr vera_layer_get_rowskip
    // conio_rowskip = vera_layer_get_rowskip(conio_screen_layer)
    lda.z __4
    sta.z conio_rowskip
    lda.z __4+1
    sta.z conio_rowskip+1
    // vera_layer_get_height(conio_screen_layer)
    lda.z conio_screen_layer
    // byte* config = vera_layer_config[layer]
    asl
    tay
    lda vera_layer_config,y
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+1,y
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    rol
    rol
    rol
    and #3
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    asl
    tay
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // }
    // vera_layer_get_height(conio_screen_layer)
    // conio_height = vera_layer_get_height(conio_screen_layer)
    lda.z __5
    sta.z conio_height
    lda.z __5+1
    sta.z conio_height+1
    // }
    rts
}
// Set the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15) when the VERA works in 16x16 color text mode.
//   An 8 bit value (decimal between 0 and 255) when the VERA works in 256 text mode.
//   Note that on the VERA, the transparent color has value 0.
// char vera_layer_set_textcolor(__register(X) char layer, __register(A) char color)
vera_layer_set_textcolor: {
    // vera_layer_textcolor[layer] = color
    sta vera_layer_textcolor,x
    // }
    rts
}
// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char vera_layer_set_backcolor(__register(X) char layer, __register(A) char color)
vera_layer_set_backcolor: {
    // vera_layer_backcolor[layer] = color
    sta vera_layer_backcolor,x
    // }
    rts
}
// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - mapbase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// void vera_layer_set_mapbase(__register(A) char layer, __register(X) char mapbase)
vera_layer_set_mapbase: {
    .label addr = $25
    // byte* addr = vera_layer_mapbase[layer]
    asl
    tay
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    txa
    ldy #0
    sta (addr),y
    // }
    rts
}
// Set the cursor to the specified position
// void gotoxy(char x, __register(X) char y)
gotoxy: {
    .label __6 = $14
    .label line_offset = $14
    // if(y>CONIO_HEIGHT)
    lda.z conio_screen_height
    stx.z $ff
    cmp.z $ff
    bcs __b1
    ldx #0
  __b1:
    // if(x>=CONIO_WIDTH)
    lda.z conio_screen_width
    // conio_cursor_x[conio_screen_layer] = x
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // conio_cursor_y[conio_screen_layer] = y
    txa
    sta conio_cursor_y,y
    // unsigned int line_offset = (unsigned int)y << conio_rowshift
    txa
    sta.z __6
    lda #0
    sta.z __6+1
    ldy.z conio_rowshift
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // conio_line_text[conio_screen_layer] = line_offset
    lda.z conio_screen_layer
    asl
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // }
    rts
}
// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// __register(A) char vera_layer_get_color(__register(X) char layer)
vera_layer_get_color: {
    .label addr = $12
    // byte* addr = vera_layer_config[layer]
    txa
    asl
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    // if( *addr & VERA_LAYER_CONFIG_256C )
    cmp #0
    bne __b1
    // vera_layer_backcolor[layer] << 4
    lda vera_layer_backcolor,x
    asl
    asl
    asl
    asl
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    ora vera_layer_textcolor,x
    // }
    rts
  __b1:
    // return (vera_layer_textcolor[layer]);
    lda vera_layer_textcolor,x
    rts
}
// Print a newline
cputln: {
    .label temp = $12
    // word temp = conio_line_text[conio_screen_layer]
    lda.z conio_screen_layer
    asl
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += conio_rowskip
    clc
    lda.z temp
    adc.z conio_rowskip
    sta.z temp
    lda.z temp+1
    adc.z conio_rowskip+1
    sta.z temp+1
    // conio_line_text[conio_screen_layer] = temp
    lda.z conio_screen_layer
    asl
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[conio_screen_layer] = 0
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // conio_cursor_y[conio_screen_layer]++;
    ldx.z conio_screen_layer
    inc conio_cursor_y,x
    // cscroll()
    jsr cscroll
    // }
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $1d
    .label line_text = $2a
    .label color = $1d
    // char* line_text = CONIO_SCREEN_TEXT
    lda.z CONIO_SCREEN_TEXT_1
    sta.z line_text
    lda.z CONIO_SCREEN_TEXT_1+1
    sta.z line_text+1
    // vera_layer_get_backcolor(conio_screen_layer)
    ldx.z conio_screen_layer
    jsr vera_layer_get_backcolor
    // vera_layer_get_backcolor(conio_screen_layer) << 4
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(conio_screen_layer)
    ldx.z conio_screen_layer
    jsr vera_layer_get_textcolor
    // char color = ( vera_layer_get_backcolor(conio_screen_layer) << 4 ) | vera_layer_get_textcolor(conio_screen_layer)
    ora.z color
    sta.z color
    ldx #0
  __b1:
    // for( char l=0;l<conio_height; l++ )
    lda.z conio_height+1
    bne __b2
    cpx.z conio_height
    bcc __b2
    // conio_cursor_x[conio_screen_layer] = 0
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // conio_cursor_y[conio_screen_layer] = 0
    sta conio_cursor_y,y
    // conio_line_text[conio_screen_layer] = 0
    tya
    asl
    tay
    lda #0
    sta conio_line_text,y
    sta conio_line_text+1,y
    // }
    rts
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(ch)
    lda.z line_text
    // *VERA_ADDRX_L = BYTE0(ch)
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    lda.z line_text+1
    // *VERA_ADDRX_M = BYTE1(ch)
    sta VERA_ADDRX_M
    // CONIO_SCREEN_BANK | VERA_INC_1
    lda #VERA_INC_1
    ora.z CONIO_SCREEN_BANK_1
    // *VERA_ADDRX_H = CONIO_SCREEN_BANK | VERA_INC_1
    sta VERA_ADDRX_H
    ldy #0
  __b4:
    // for( char c=0;c<conio_width; c++ )
    lda.z conio_width+1
    bne __b5
    cpy.z conio_width
    bcc __b5
    // line_text += conio_rowskip
    clc
    lda.z line_text
    adc.z conio_rowskip
    sta.z line_text
    lda.z line_text+1
    adc.z conio_rowskip+1
    sta.z line_text+1
    // for( char l=0;l<conio_height; l++ )
    inx
    jmp __b1
  __b5:
    // *VERA_DATA0 = ' '
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_width; c++ )
    iny
    jmp __b4
}
// Get the tile base address of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Specifies the base address of the tile map, which is calculated as an unsigned long int.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// __zp($4a) unsigned long vera_layer_get_tilebase_address(char layer)
vera_layer_get_tilebase_address: {
    .const layer = 1
    .label address = $3b
    .label return = $4a
    // byte tilebase = *vera_layer_tilebase[layer]
    ldy vera_layer_tilebase+layer*SIZEOF_POINTER
    sty.z $fe
    ldy vera_layer_tilebase+layer*SIZEOF_POINTER+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    // dword address = tilebase
    sta.z address
    tya
    sta.z address+1
    sta.z address+2
    sta.z address+3
    // address &= $FC
    lda.z address
    and #<$fc
    sta.z address
    lda.z address+1
    and #>$fc
    sta.z address+1
    lda.z address+2
    and #<$fc>>$10
    sta.z address+2
    lda.z address+3
    and #>$fc>>$10
    sta.z address+3
    // address <<= 8
    lda.z address+2
    sta.z address+3
    lda.z address+1
    sta.z address+2
    lda.z address
    sta.z address+1
    tya
    sta.z address
    // address <<= 1
    asl
    sta.z return
    lda.z address+1
    rol
    sta.z return+1
    lda.z address+2
    rol
    sta.z return+2
    lda.z address+3
    rol
    sta.z return+3
    // }
    rts
}
// Set a vera layer in tile mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_depth: The color depth in bits per pixel (BPP), which can be 1, 2, 4 or 8.
// void vera_layer_mode_tile(__zp($45) char layer, __zp($32) unsigned long mapbase_address, __zp($36) unsigned long tilebase_address, __zp($14) unsigned int mapwidth, __zp($42) unsigned int mapheight, __zp($4f) char tilewidth, __zp($50) char tileheight, char color_depth)
vera_layer_mode_tile: {
    .label __1 = $3f
    .label __6 = $30
    .label __17 = $46
    .label __18 = $44
    .label mapbase_address = $32
    .label tilebase_address = $36
    .label mapwidth = $14
    .label layer = $45
    .label mapheight = $42
    .label tilewidth = $4f
    .label tileheight = $50
    // case 32:
    //             config |= VERA_LAYER_WIDTH_32;
    //             vera_layer_rowshift[layer] = 6;
    //             vera_layer_rowskip[layer] = 64;
    //             break;
    lda.z mapwidth+1
    bne !+
    lda.z mapwidth
    cmp #$20
    bne !__b5+
    jmp __b5
  !__b5:
  !:
    // case 64:
    //             config |= VERA_LAYER_WIDTH_64;
    //             vera_layer_rowshift[layer] = 7;
    //             vera_layer_rowskip[layer] = 128;
    //             break;
    lda.z mapwidth+1
    bne !+
    lda.z mapwidth
    cmp #$40
    bne !__b6+
    jmp __b6
  !__b6:
  !:
    // case 128:
    //             config |= VERA_LAYER_WIDTH_128;
    //             vera_layer_rowshift[layer] = 8;
    //             vera_layer_rowskip[layer] = 256;
    //             break;
    lda.z mapwidth+1
    bne !+
    lda.z mapwidth
    cmp #$80
    bne !__b7+
    jmp __b7
  !__b7:
  !:
    // case 256:
    //             config |= VERA_LAYER_WIDTH_256;
    //             vera_layer_rowshift[layer] = 9;
    //             vera_layer_rowskip[layer] = 512;
    //             break;
    lda.z mapwidth+1
    cmp #>$100
    bne __b1
    lda.z mapwidth
    cmp #<$100
    bne __b1
    // vera_layer_rowshift[layer] = 9
    lda #9
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 512
    tya
    asl
    tay
    lda #<$200
    sta vera_layer_rowskip,y
    lda #>$200
    sta vera_layer_rowskip+1,y
    ldx #VERA_LAYER_WIDTH_256
    jmp __b9
  __b1:
    ldx #VERA_LAYER_COLOR_DEPTH_1BPP
  __b9:
    // case 32:
    //             config |= VERA_LAYER_HEIGHT_32;
    //             break;
    lda.z mapheight+1
    bne !+
    lda.z mapheight
    cmp #$20
    beq __b16
  !:
    // case 64:
    //             config |= VERA_LAYER_HEIGHT_64;
    //             break;
    lda.z mapheight+1
    bne !+
    lda.z mapheight
    cmp #$40
    bne !__b13+
    jmp __b13
  !__b13:
  !:
    // case 128:
    //             config |= VERA_LAYER_HEIGHT_128;
    //             break;
    lda.z mapheight+1
    bne !+
    lda.z mapheight
    cmp #$80
    bne !__b14+
    jmp __b14
  !__b14:
  !:
    // case 256:
    //             config |= VERA_LAYER_HEIGHT_256;
    //             break;
    lda.z mapheight+1
    cmp #>$100
    bne __b16
    lda.z mapheight
    cmp #<$100
    bne __b16
    // config |= VERA_LAYER_HEIGHT_256
    txa
    ora #VERA_LAYER_HEIGHT_256
    tax
  __b16:
    // vera_layer_set_config(layer, config)
    lda.z layer
    jsr vera_layer_set_config
    // WORD0(mapbase_address)
    lda.z mapbase_address
    sta.z __1
    lda.z mapbase_address+1
    sta.z __1+1
    // vera_mapbase_offset[layer] = WORD0(mapbase_address)
    lda.z layer
    asl
    sta.z __17
    // mapbase
    tay
    lda.z __1
    sta vera_mapbase_offset,y
    lda.z __1+1
    sta vera_mapbase_offset+1,y
    // BYTE2(mapbase_address)
    lda.z mapbase_address+2
    // vera_mapbase_bank[layer] = BYTE2(mapbase_address)
    ldy.z layer
    sta vera_mapbase_bank,y
    // vera_mapbase_address[layer] = mapbase_address
    tya
    asl
    asl
    sta.z __18
    tay
    lda.z mapbase_address
    sta vera_mapbase_address,y
    lda.z mapbase_address+1
    sta vera_mapbase_address+1,y
    lda.z mapbase_address+2
    sta vera_mapbase_address+2,y
    lda.z mapbase_address+3
    sta vera_mapbase_address+3,y
    // mapbase_address = mapbase_address >> 1
    lsr.z mapbase_address+3
    ror.z mapbase_address+2
    ror.z mapbase_address+1
    ror.z mapbase_address
    // byte mapbase = BYTE1(mapbase_address)
    ldx.z mapbase_address+1
    // vera_layer_set_mapbase(layer,mapbase)
    lda.z layer
    jsr vera_layer_set_mapbase
    // WORD0(tilebase_address)
    lda.z tilebase_address
    sta.z __6
    lda.z tilebase_address+1
    sta.z __6+1
    // vera_tilebase_offset[layer] = WORD0(tilebase_address)
    // tilebase
    ldy.z __17
    lda.z __6
    sta vera_tilebase_offset,y
    lda.z __6+1
    sta vera_tilebase_offset+1,y
    // BYTE2(tilebase_address)
    lda.z tilebase_address+2
    // vera_tilebase_bank[layer] = BYTE2(tilebase_address)
    ldy.z layer
    sta vera_tilebase_bank,y
    // vera_tilebase_address[layer] = tilebase_address
    ldy.z __18
    lda.z tilebase_address
    sta vera_tilebase_address,y
    lda.z tilebase_address+1
    sta vera_tilebase_address+1,y
    lda.z tilebase_address+2
    sta vera_tilebase_address+2,y
    lda.z tilebase_address+3
    sta vera_tilebase_address+3,y
    // tilebase_address = tilebase_address >> 1
    lsr.z tilebase_address+3
    ror.z tilebase_address+2
    ror.z tilebase_address+1
    ror.z tilebase_address
    // byte tilebase = BYTE1(tilebase_address)
    lda.z tilebase_address+1
    // tilebase &= VERA_LAYER_TILEBASE_MASK
    and #VERA_LAYER_TILEBASE_MASK
    tax
    // case 8:
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    lda #8
    cmp.z tilewidth
    beq __b19
    // case 16:
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    lda #$10
    cmp.z tilewidth
    bne __b19
    // tilebase |= VERA_TILEBASE_WIDTH_16
    txa
    ora #VERA_TILEBASE_WIDTH_16
    tax
  __b19:
    // case 8:
    //             tilebase |= VERA_TILEBASE_HEIGHT_8;
    //             break;
    lda #8
    cmp.z tileheight
    beq __b22
    // case 16:
    //             tilebase |= VERA_TILEBASE_HEIGHT_16;
    //             break;
    lda #$10
    cmp.z tileheight
    bne __b22
    // tilebase |= VERA_TILEBASE_HEIGHT_16
    txa
    ora #VERA_TILEBASE_HEIGHT_16
    tax
  __b22:
    // vera_layer_set_tilebase(layer,tilebase)
    lda.z layer
    jsr vera_layer_set_tilebase
    // }
    rts
  __b14:
    // config |= VERA_LAYER_HEIGHT_128
    txa
    ora #VERA_LAYER_HEIGHT_128
    tax
    jmp __b16
  __b13:
    // config |= VERA_LAYER_HEIGHT_64
    txa
    ora #VERA_LAYER_HEIGHT_64
    tax
    jmp __b16
  __b7:
    // vera_layer_rowshift[layer] = 8
    lda #8
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 256
    tya
    asl
    tay
    lda #<$100
    sta vera_layer_rowskip,y
    lda #>$100
    sta vera_layer_rowskip+1,y
    ldx #VERA_LAYER_WIDTH_128
    jmp __b9
  __b6:
    // vera_layer_rowshift[layer] = 7
    lda #7
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 128
    tya
    asl
    tay
    lda #$80
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    ldx #VERA_LAYER_WIDTH_64
    jmp __b9
  __b5:
    // vera_layer_rowshift[layer] = 6
    lda #6
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 64
    tya
    asl
    tay
    lda #$40
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b1
}
// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
// char scroll(char onoff)
scroll: {
    .const onoff = 0
    // conio_scroll_enable[conio_screen_layer] = onoff
    lda #onoff
    ldy.z conio_screen_layer
    sta conio_scroll_enable,y
    // }
    rts
}
// void draw_characters(__zp($3b) unsigned long tilebase)
draw_characters: {
    .label tilebase = $3b
    .label tilerow = $3b
    .label tilecolumn = $2c
    .label bit = $24
    .label b = $1c
    .label tilecolumn_1 = $20
    .label x = $1f
    .label tilerow_1 = $2c
    .label r = $29
    .label y = $3a
    // clrscr()
    jsr clrscr
    lda #0
    sta.z y
  __b1:
    lda.z tilerow
    sta.z tilecolumn
    lda.z tilerow+1
    sta.z tilecolumn+1
    lda.z tilerow+2
    sta.z tilecolumn+2
    lda.z tilerow+3
    sta.z tilecolumn+3
    lda #0
    sta.z r
  __b2:
    lda.z tilecolumn
    sta.z tilecolumn_1
    lda.z tilecolumn+1
    sta.z tilecolumn_1+1
    lda.z tilecolumn+2
    sta.z tilecolumn_1+2
    lda.z tilecolumn+3
    sta.z tilecolumn_1+3
    lda #0
    sta.z x
  __b3:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(bankaddr)
    lda.z tilecolumn_1
    // *VERA_ADDRX_L = BYTE0(bankaddr)
    sta VERA_ADDRX_L
    // BYTE1(bankaddr)
    lda.z tilecolumn_1+1
    // *VERA_ADDRX_M = BYTE1(bankaddr)
    sta VERA_ADDRX_M
    // BYTE2(bankaddr) | incr
    lda.z tilecolumn_1+2
    // *VERA_ADDRX_H = BYTE2(bankaddr) | incr
    sta VERA_ADDRX_H
    // byte data = *VERA_DATA0
    lda VERA_DATA0
    sta.z bit
    lda #8
    sta.z b
  __b4:
    // b-1
    ldx.z b
    dex
    // data >> (b-1)
    lda.z bit
    cpx #0
    beq !e+
  !:
    lsr
    dex
    bne !-
  !e:
    // bit = (data >> (b-1)) & $1
    and #1
    // (bit)?'*':'.'
    cmp #0
    bne __b5
    lda #'.'
    jmp __b6
  __b5:
    // (bit)?'*':'.'
    lda #'*'
  __b6:
    // printf("%c", (char)((bit)?'*':'.'))
    pha
    jsr cputc
    pla
    // for(byte b:8..1)
    dec.z b
    lda.z b
    bne __b4
    // tilecolumn += 8
    lda.z tilecolumn_1
    clc
    adc #8
    sta.z tilecolumn_1
    bcc !+
    inc.z tilecolumn_1+1
    bne !+
    inc.z tilecolumn_1+2
    bne !+
    inc.z tilecolumn_1+3
  !:
    // for(byte x:0..15)
    inc.z x
    lda #$10
    cmp.z x
    bne __b3
    // tilerow += 1
    //printf("\n");
    lda.z tilerow_1
    clc
    adc #1
    sta.z tilerow_1
    lda.z tilerow_1+1
    adc #0
    sta.z tilerow_1+1
    lda.z tilerow_1+2
    adc #0
    sta.z tilerow_1+2
    lda.z tilerow_1+3
    adc #0
    sta.z tilerow_1+3
    // for(byte r:0..7)
    inc.z r
    lda #8
    cmp.z r
    beq !__b2+
    jmp __b2
  !__b2:
    // tilebase += 8*16
    lda.z tilebase
    clc
    adc #8*$10
    sta.z tilebase
    bcc !+
    inc.z tilebase+1
    bne !+
    inc.z tilebase+2
    bne !+
    inc.z tilebase+3
  !:
    // for(byte y:0..15)
    inc.z y
    lda #$10
    cmp.z y
    beq !__b1+
    jmp __b1
  !__b1:
    // }
    rts
}
// Return true if there's a key waiting, return false if not
kbhit: {
    .label chptr = ch
    .label IN_DEV = $28a
    // Current input device number
    .label GETIN = $ffe4
    .label ch = $41
    // char ch = 0
    lda #0
    sta.z ch
    // kickasm
    // CBM GETIN API
    jsr _kbhit
        bne L3

        jmp continue1

        .var via1 = $9f60                  //VIA#1
        .var d1pra = via1+1

    _kbhit:
        ldy     d1pra       // The count of keys pressed is stored in RAM bank 0.
        stz     d1pra       // Set d1pra to zero to access RAM bank 0.
        lda     $A00A       // Get number of characters from this address in the ROM of the CX16 (ROM 38).
        sty     d1pra       // Set d1pra to previous value.
        rts

    L3:
        ldy     IN_DEV          // Save current input device
        stz     IN_DEV          // Keyboard
        phy
        jsr     GETIN           // Read char, and return in .A
        ply
        sta     chptr           // Store the character read in ch
        sty     IN_DEV          // Restore input device
        ldx     #>$0000
        rts

    continue1:
        nop
     
    // return ch;
    lda.z ch
    // }
    rts
}
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __zp($2a) const char *s)
printf_str: {
    .label s = $2a
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // putc(c)
    pha
    jsr cputc
    pla
    jmp __b1
}
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
// void vera_layer_set_text_color_mode(char layer, char color_mode)
vera_layer_set_text_color_mode: {
    .label addr = $25
    // byte* addr = vera_layer_config[layer]
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    lda (addr),y
    sta (addr),y
    // }
    rts
}
// Get the map base bank of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Bank in vera vram.
// __register(A) char vera_layer_get_mapbase_bank(__register(X) char layer)
vera_layer_get_mapbase_bank: {
    // return vera_mapbase_bank[layer];
    lda vera_mapbase_bank,x
    // }
    rts
}
// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
// __zp($14) unsigned int vera_layer_get_mapbase_offset(__register(A) char layer)
vera_layer_get_mapbase_offset: {
    .label return = $14
    // return vera_mapbase_offset[layer];
    asl
    tay
    lda vera_mapbase_offset,y
    sta.z return
    lda vera_mapbase_offset+1,y
    sta.z return+1
    // }
    rts
}
// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
// __register(A) char vera_layer_get_rowshift(__register(X) char layer)
vera_layer_get_rowshift: {
    // return vera_layer_rowshift[layer];
    lda vera_layer_rowshift,x
    // }
    rts
}
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
// __zp($14) unsigned int vera_layer_get_rowskip(__register(A) char layer)
vera_layer_get_rowskip: {
    .label return = $14
    // return vera_layer_rowskip[layer];
    asl
    tay
    lda vera_layer_rowskip,y
    sta.z return
    lda vera_layer_rowskip+1,y
    sta.z return+1
    // }
    rts
}
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[conio_screen_layer]>=CONIO_HEIGHT)
    ldy.z conio_screen_layer
    lda conio_cursor_y,y
    cmp.z conio_screen_height
    bcc __b3
    // if(conio_scroll_enable[conio_screen_layer])
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // if(conio_cursor_y[conio_screen_layer]>=conio_height)
    lda conio_cursor_y,y
    ldy.z conio_height+1
    bne __b3
    cmp.z conio_height
  __b3:
    // }
    rts
  __b4:
    // insertup()
    jsr insertup
    // gotoxy( 0, CONIO_HEIGHT-1)
    ldx.z conio_screen_height
    dex
    jsr gotoxy
    rts
}
// Get the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// __register(A) char vera_layer_get_backcolor(__register(X) char layer)
vera_layer_get_backcolor: {
    // return vera_layer_backcolor[layer];
    lda vera_layer_backcolor,x
    // }
    rts
}
// Get the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// __register(A) char vera_layer_get_textcolor(__register(X) char layer)
vera_layer_get_textcolor: {
    // return vera_layer_textcolor[layer];
    lda vera_layer_textcolor,x
    // }
    rts
}
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// void vera_layer_set_config(__register(A) char layer, __register(X) char config)
vera_layer_set_config: {
    .label addr = $25
    // byte* addr = vera_layer_config[layer]
    asl
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr = config
    txa
    ldy #0
    sta (addr),y
    // }
    rts
}
// Set the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// void vera_layer_set_tilebase(__register(A) char layer, __register(X) char tilebase)
vera_layer_set_tilebase: {
    .label addr = $25
    // byte* addr = vera_layer_tilebase[layer]
    asl
    tay
    lda vera_layer_tilebase,y
    sta.z addr
    lda vera_layer_tilebase+1,y
    sta.z addr+1
    // *addr = tilebase
    txa
    ldy #0
    sta (addr),y
    // }
    rts
}
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label cy = $b
    .label width = $a
    .label line = 6
    .label start = 6
    // unsigned byte cy = conio_cursor_y[conio_screen_layer]
    ldy.z conio_screen_layer
    lda conio_cursor_y,y
    sta.z cy
    // unsigned byte width = CONIO_WIDTH * 2
    lda.z conio_screen_width
    asl
    sta.z width
    ldx #1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    lda.z cy
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // clearline()
    jsr clearline
    // }
    rts
  __b2:
    // i-1
    txa
    sec
    sbc #1
    // unsigned int line = (i-1) << conio_rowshift
    ldy.z conio_rowshift
    sta.z line
    lda #0
    sta.z line+1
    cpy #0
    beq !e+
  !:
    asl.z line
    rol.z line+1
    dey
    bne !-
  !e:
    // unsigned char* start = CONIO_SCREEN_TEXT + line
    clc
    lda.z start
    adc.z CONIO_SCREEN_TEXT
    sta.z start
    lda.z start+1
    adc.z CONIO_SCREEN_TEXT+1
    sta.z start+1
    // start+conio_rowskip
    lda.z start
    clc
    adc.z conio_rowskip
    sta.z memcpy_in_vram.src
    lda.z start+1
    adc.z conio_rowskip+1
    sta.z memcpy_in_vram.src+1
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+conio_rowskip, VERA_INC_1, width)
    lda.z width
    sta.z memcpy_in_vram.num
    lda #0
    sta.z memcpy_in_vram.num+1
    jsr memcpy_in_vram
    // for(unsigned byte i=1; i<=cy; i++)
    inx
    jmp __b1
}
clearline: {
    .label addr = 8
    .label c = 2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // byte* addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    lda.z conio_screen_layer
    asl
    // Set address
    tay
    clc
    lda.z CONIO_SCREEN_TEXT
    adc conio_line_text,y
    sta.z addr
    lda.z CONIO_SCREEN_TEXT+1
    adc conio_line_text+1,y
    sta.z addr+1
    // BYTE0(addr)
    lda.z addr
    // *VERA_ADDRX_L = BYTE0(addr)
    sta VERA_ADDRX_L
    // BYTE1(addr)
    lda.z addr+1
    // *VERA_ADDRX_M = BYTE1(addr)
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // char color = vera_layer_get_color( conio_screen_layer)
    ldx.z conio_screen_layer
    jsr vera_layer_get_color
    // char color = vera_layer_get_color( conio_screen_layer)
    tax
    lda #<0
    sta.z c
    sta.z c+1
  __b1:
    // for( unsigned int c=0;c<CONIO_WIDTH; c++ )
    lda.z c+1
    bne !+
    lda.z c
    cmp.z conio_screen_width
    bcc __b2
  !:
    // conio_cursor_x[conio_screen_layer] = 0
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // }
    rts
  __b2:
    // *VERA_DATA0 = ' '
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    stx VERA_DATA0
    // for( unsigned int c=0;c<CONIO_WIDTH; c++ )
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
}
// Copy block of memory (from VRAM to VRAM)
// Copies the values from the location pointed by src to the location pointed by dest.
// The method uses the VERA access ports 0 and 1 to copy data from and to in VRAM.
// - src_bank:  64K VRAM bank number to copy from (0/1).
// - src: pointer to the location to copy from. Note that the address is a 16 bit value!
// - src_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
// - dest_bank:  64K VRAM bank number to copy to (0/1).
// - dest: pointer to the location to copy to. Note that the address is a 16 bit value!
// - dest_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
// - num: The number of bytes to copy
// void memcpy_in_vram(char dest_bank, __zp(6) void *dest, char dest_increment, char src_bank, __zp(8) char *src, char src_increment, __zp(4) unsigned int num)
memcpy_in_vram: {
    .label i = 2
    .label dest = 6
    .label src = 8
    .label num = 4
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(src)
    lda.z src
    // *VERA_ADDRX_L = BYTE0(src)
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(src)
    lda.z src+1
    // *VERA_ADDRX_M = BYTE1(src)
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = src_increment | src_bank
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(dest)
    lda.z dest
    // *VERA_ADDRX_L = BYTE0(dest)
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(dest)
    lda.z dest+1
    // *VERA_ADDRX_M = BYTE1(dest)
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = dest_increment | dest_bank
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
  __b1:
    // for(unsigned int i=0; i<num; i++)
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // }
    rts
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
.segment Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  /// --- VERA function encapsulation ---
  vera_mapbase_offset: .word 0, 0
  vera_mapbase_bank: .byte 0, 0
  vera_mapbase_address: .dword 0, 0
  vera_tilebase_offset: .word 0, 0
  vera_tilebase_bank: .byte 0, 0
  vera_tilebase_address: .dword 0, 0
  vera_layer_rowshift: .byte 0, 0
  vera_layer_rowskip: .word 0, 0
  vera_layer_config: .word VERA_L0_CONFIG, VERA_L1_CONFIG
  vera_layer_enable: .byte VERA_LAYER0_ENABLE, VERA_LAYER1_ENABLE
  vera_layer_mapbase: .word VERA_L0_MAPBASE, VERA_L1_MAPBASE
  vera_layer_tilebase: .word VERA_L0_TILEBASE, VERA_L1_TILEBASE
  vera_layer_vscroll_l: .word VERA_L0_VSCROLL_L, VERA_L1_VSCROLL_L
  vera_layer_vscroll_h: .word VERA_L0_VSCROLL_H, VERA_L1_VSCROLL_H
  vera_layer_hscroll_l: .word VERA_L0_HSCROLL_L, VERA_L1_HSCROLL_L
  vera_layer_hscroll_h: .word VERA_L0_HSCROLL_H, VERA_L1_HSCROLL_H
  vera_layer_textcolor: .byte WHITE, WHITE
  vera_layer_backcolor: .byte BLUE, BLUE
  // The number of bytes on the screen
  // The current cursor x-position
  conio_cursor_x: .byte 0, 0
  // The current cursor y-position
  conio_cursor_y: .byte 0, 0
  // The current text cursor line start
  conio_line_text: .word 0, 0
  // Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
  // If disabled the cursor just moves back to (0,0) instead
  conio_scroll_enable: .byte 1, 1
