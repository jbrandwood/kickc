// Example program for the Commander X16.
// Demonstrates the usage of the VERA layer 0 and 1.
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="tilemap.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // The colors of the CX16
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
  .const VERA_CONFIG_HEIGHT_128 = $80
  .const VERA_CONFIG_HEIGHT_MASK = $c0
  .const VERA_CONFIG_WIDTH_128 = $20
  .const VERA_CONFIG_WIDTH_MASK = $30
  .const SIZEOF_POINTER = 2
  // $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  // $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  // $9F22 VRAM Address (7:0)
  // Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  //                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  // Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  // Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  // $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  // $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
  // $9F25	CTRL Control
  // Bit 7: Reset
  // Bit 1: DCSEL
  // Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  // $9F26	IEN		Interrupt Enable
  // Bit 7: IRQ line (8)
  // Bit 3: AFLOW
  // Bit 2: SPRCOL
  // Bit 1: LINE
  // Bit 0: VSYNC
  .label VERA_IEN = $9f26
  // $9F27	ISR     Interrupt Status
  // Interrupts will be generated for the interrupt sources set in the lower 4 bits of IEN. ISR will indicate the interrupts that have occurred.
  // Writing a 1 to one of the lower 3 bits in ISR will clear that interrupt status. AFLOW can only be cleared by filling the audio FIFO for at least 1/4.
  // Bit 4-7: Sprite Collisions. This field indicates which groups of sprites have collided.
  // Bit 3: AFLOW
  // Bit 2: SPRCOL
  // Bit 1: LINE
  // Bit 0: VSYNC
  .label VERA_ISR = $9f27
  // $9F29	DC_VIDEO (DCSEL=0)
  // Bit 7: Current Field     Read-only bit which reflects the active interlaced field in composite and RGB modes. (0: even, 1: odd)
  // Bit 6: Sprites Enable	Enable output from the Sprites renderer
  // Bit 5: Layer1 Enable	    Enable output from the Layer1 renderer
  // Bit 4: Layer0 Enable	    Enable output from the Layer0 renderer
  // Bit 2: Chroma Disable    Setting 'Chroma Disable' disables output of chroma in NTSC composite mode and will give a better picture on a monochrome display. (Setting this bit will also disable the chroma output on the S-video output.)
  // Bit 0-1: Output Mode     0: Video disabled, 1: VGA output, 2: NTSC composite, 3: RGB interlaced, composite sync (via VGA connector)
  .label VERA_DC_VIDEO = $9f29
  // $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  // $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  // $9F2D	L0_CONFIG   Layer 0 Configuration
  // Bit 6-7: Map Height	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
  // Bit 4-5. Map Width	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
  // Bit 3: T256C	        (0: tiles use a 16-color foreground and background color, 1: tiles use a 256-color foreground color) (only relevant in 1bpp modes)
  // Bit 2: Bitmap Mode	(0:tile mode, 1: bitmap mode)
  // Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
  .label VERA_L0_CONFIG = $9f2d
  // $9F2E	L0_MAPBASE	    Layer 0 Map Base Address (16:9)
  .label VERA_L0_MAPBASE = $9f2e
  // $9F2F	L0_TILEBASE	    Layer 0 Tile Base
  // Bit 2-7: Tile Base Address (16:11)
  // Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  // Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L0_TILEBASE = $9f2f
  // $9F30	L0_HSCROLL_L	Layer 0 H-Scroll (7:0)
  .label VERA_L0_HSCROLL_L = $9f30
  // $9F31	L0_HSCROLL_H	Layer 0 H-Scroll (11:8)
  .label VERA_L0_HSCROLL_H = $9f31
  // $9F32	L0_VSCROLL_L	Layer 0 V-Scroll (7:0)
  .label VERA_L0_VSCROLL_L = $9f32
  // $9F33	L0_VSCROLL_H    Layer 0 V-Scroll (11:8)
  .label VERA_L0_VSCROLL_H = $9f33
  // Bit 6-7: Map Height	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
  // Bit 4-5. Map Width	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
  // Bit 3: T256C	        (0: tiles use a 16-color foreground and background color, 1: tiles use a 256-color foreground color) (only relevant in 1bpp modes)
  // Bit 2: Bitmap Mode	(0:tile mode, 1: bitmap mode)
  // Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
  .label VERA_L1_CONFIG = $9f34
  // $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  // $9F36	L1_TILEBASE	    Layer 1 Tile Base
  // Bit 2-7: Tile Base Address (16:11)
  // Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  // Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
  // $9F37	L1_HSCROLL_L	Layer 1 H-Scroll (7:0)
  .label VERA_L1_HSCROLL_L = $9f37
  // $9F38	L1_HSCROLL_H	Layer 1 H-Scroll (11:8)
  .label VERA_L1_HSCROLL_H = $9f38
  // $9F39	L1_VSCROLL_L	Layer 1 V-Scroll (7:0)
  .label VERA_L1_VSCROLL_L = $9f39
  // $9F3A	L1_VSCROLL_H	Layer 1 V-Scroll (11:8)
  .label VERA_L1_VSCROLL_H = $9f3a
  // $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  // Variable holding the screen width;
  .label conio_screen_width = $13
  // Variable holding the screen height;
  .label conio_screen_height = $14
  // Variable holding the screen layer on the VERA card with which conio interacts;
  .label conio_screen_layer = $15
  // Variables holding the current map width and map height of the layer.
  .label conio_width = $16
  .label conio_height = $18
  .label conio_skip = $1a
  // X sine index
  .label scroll_x = $1b
  .label scroll_y = $1d
  .label delta_x = $1f
  .label delta_y = $21
  .label speed = $23
  .label CONIO_SCREEN_BANK = $35
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
  .label CONIO_SCREEN_TEXT = $36
.segment Code
__start: {
    // conio_screen_width = 0
    lda #0
    sta.z conio_screen_width
    // conio_screen_height = 0
    sta.z conio_screen_height
    // conio_screen_layer = 1
    lda #1
    sta.z conio_screen_layer
    // conio_width = 0
    lda #<0
    sta.z conio_width
    sta.z conio_width+1
    // conio_height = 0
    sta.z conio_height
    sta.z conio_height+1
    // conio_skip = 0
    sta.z conio_skip
    // scroll_x = 0
    sta.z scroll_x
    sta.z scroll_x+1
    // scroll_y = 0
    sta.z scroll_y
    sta.z scroll_y+1
    // delta_x = 2
    lda #<2
    sta.z delta_x
    lda #>2
    sta.z delta_x+1
    // delta_y = 0
    sta.z delta_y
    sta.z delta_y+1
    // speed = 2
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
    .label __10 = $25
    .label __11 = $27
    .label vera_set_layer_horizontal_scroll1_scroll = $29
    .label vera_set_layer_vertical_scroll1_scroll = $2b
    // scroll_x += delta_x
    lda.z scroll_x
    clc
    adc.z delta_x
    sta.z scroll_x
    lda.z scroll_x+1
    adc.z delta_x+1
    sta.z scroll_x+1
    // scroll_y += delta_y
    lda.z scroll_y
    clc
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
    // vera_set_layer_horizontal_scroll(0,(word)scroll_x)
    lda.z scroll_x
    sta.z vera_set_layer_horizontal_scroll1_scroll
    lda.z scroll_x+1
    sta.z vera_set_layer_horizontal_scroll1_scroll+1
    // <scroll
    lda.z vera_set_layer_horizontal_scroll1_scroll
    // *vera_layer_hscroll_l[layer] = <scroll
    ldy vera_layer_hscroll_l
    sty.z $fe
    ldy vera_layer_hscroll_l+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // >scroll
    lda.z vera_set_layer_horizontal_scroll1_scroll+1
    // *vera_layer_hscroll_h[layer] = >scroll
    ldy vera_layer_hscroll_h
    sty.z $fe
    ldy vera_layer_hscroll_h+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // vera_set_layer_vertical_scroll(0,(word)scroll_y)
    lda.z scroll_y
    sta.z vera_set_layer_vertical_scroll1_scroll
    lda.z scroll_y+1
    sta.z vera_set_layer_vertical_scroll1_scroll+1
    // <scroll
    lda.z vera_set_layer_vertical_scroll1_scroll
    // *vera_layer_vscroll_l[layer] = <scroll
    ldy vera_layer_vscroll_l
    sty.z $fe
    ldy vera_layer_vscroll_l+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // >scroll
    lda.z vera_set_layer_vertical_scroll1_scroll+1
    // *vera_layer_vscroll_h[layer] = >scroll
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
    .label line = 2
    // line = *BASIC_CURSOR_LINE
    lda BASIC_CURSOR_LINE
    sta.z line
    // screensize(&conio_screen_width, &conio_screen_height)
    jsr screensize
    // screenlayer(1)
    lda #1
    jsr screenlayer
    // vera_set_layer_textcolor(1, WHITE)
    ldx #WHITE
    lda #1
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(1, BLUE)
    ldx #BLUE
    lda #1
    jsr vera_set_layer_backcolor
    // vera_set_layer_mapbase(0,0x20)
    ldx #$20
    lda #0
    jsr vera_set_layer_mapbase
    // vera_set_layer_mapbase(1,0x00)
    ldx #0
    lda #1
    jsr vera_set_layer_mapbase
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
main: {
    .label vera_set_layer_map_width_1281_addr = $2d
    .label vera_set_layer_map_height_1281_addr = $2f
    .label tilebase = $31
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #WHITE
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLACK
    jsr vera_set_layer_backcolor
    // clrscr()
    jsr clrscr
    // vera_set_layer_mapbase(0,0x80)
  // Now we set the tile map width and height.
    ldx #$80
    lda #0
    jsr vera_set_layer_mapbase
    // vera_get_layer_config(1)
    jsr vera_get_layer_config
    // vera_set_layer_config(0, vera_get_layer_config(1))
    tax
    // Set the map base to address 0x10000 in VERA VRAM!
    jsr vera_set_layer_config
    // vera_get_layer_tilebase(1)
    jsr vera_get_layer_tilebase
    // vera_set_layer_tilebase(0, vera_get_layer_tilebase(1))
    tax
    jsr vera_set_layer_tilebase
    // addr = vera_layer_config[layer]
    lda vera_layer_config
    sta.z vera_set_layer_map_width_1281_addr
    lda vera_layer_config+1
    sta.z vera_set_layer_map_width_1281_addr+1
    // *addr &= ~VERA_CONFIG_WIDTH_MASK
    lda #VERA_CONFIG_WIDTH_MASK^$ff
    ldy #0
    and (vera_set_layer_map_width_1281_addr),y
    sta (vera_set_layer_map_width_1281_addr),y
    // *addr |= VERA_CONFIG_WIDTH_128
    lda #VERA_CONFIG_WIDTH_128
    ora (vera_set_layer_map_width_1281_addr),y
    sta (vera_set_layer_map_width_1281_addr),y
    // addr = vera_layer_config[layer]
    lda vera_layer_config
    sta.z vera_set_layer_map_height_1281_addr
    lda vera_layer_config+1
    sta.z vera_set_layer_map_height_1281_addr+1
    // *addr &= ~VERA_CONFIG_HEIGHT_MASK
    lda #VERA_CONFIG_HEIGHT_MASK^$ff
    and (vera_set_layer_map_height_1281_addr),y
    sta (vera_set_layer_map_height_1281_addr),y
    // *addr |= VERA_CONFIG_HEIGHT_128
    lda #VERA_CONFIG_HEIGHT_128
    ora (vera_set_layer_map_height_1281_addr),y
    sta (vera_set_layer_map_height_1281_addr),y
    // vera_get_layer_tilebase_address(0)
    jsr vera_get_layer_tilebase_address
    // tilebase = vera_get_layer_tilebase_address(0)
    // screenlayer(0)
    lda #0
    jsr screenlayer
    // scroll(0)
    jsr scroll
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #WHITE
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #GREEN
    jsr vera_set_layer_backcolor
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
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #GREY
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #GREEN
    jsr vera_set_layer_backcolor
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
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #WHITE
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLACK
    jsr vera_set_layer_backcolor
    // printf("\n\nthis demo displays the design of the standard x16 commander\n")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("character set on the vera layer 0. it's the character set i grew up with :-).\n")
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("\nthe smooth scrolling is implemented by manipulating the scrolling \n")
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("registers of layer 0. at each raster line interrupt, \n")
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("the x and y scrolling registers are manipulated. the cx16 terminal \n")
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("works on layer 1. when layer 0 is enabled with the scrolling, \n")
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // printf("it gives a nice background effect. this technique can be used to implement\n")
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // printf("smooth scrolling backgrounds using tile layouts in games or demos.\n")
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #YELLOW
    jsr vera_set_layer_textcolor
    // printf("\npress a key to continue ...")
    lda #<s8
    sta.z cputs.s
    lda #>s8
    sta.z cputs.s+1
    jsr cputs
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
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #DARK_GREY
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLACK
    jsr vera_set_layer_backcolor
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
// Return the current screen size.
screensize: {
    .label x = conio_screen_width
    .label y = conio_screen_height
    // hscale = (*VERA_DC_HSCALE) >> 7
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
    // vscale = (*VERA_DC_VSCALE) >> 7
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
// screenlayer(byte register(A) layer)
screenlayer: {
    .label __4 = $3e
    .label __5 = $38
    .label __6 = $3a
    .label addr_i = $3c
    // layer &= $1
    and #1
    // conio_screen_layer = layer
    sta.z conio_screen_layer
    // vera_get_layer_mapbase(layer)
    jsr vera_get_layer_mapbase
    // addr = vera_get_layer_mapbase(layer)
    // addr_i = addr << 1
    asl
    sta.z addr_i
    lda #0
    rol
    sta.z addr_i+1
    // >addr_i
    sta.z CONIO_SCREEN_BANK
    // addr_i << 8
    lda.z addr_i
    sta.z CONIO_SCREEN_TEXT+1
    lda #0
    sta.z CONIO_SCREEN_TEXT
    // vera_get_layer_map_width(conio_screen_layer)
    lda.z conio_screen_layer
    jsr vera_get_layer_map_width
    // conio_width = vera_get_layer_map_width(conio_screen_layer)
    lda.z __4
    sta.z conio_width
    lda.z __4+1
    sta.z conio_width+1
    // conio_width >> 4
    lsr
    sta.z __5+1
    lda.z conio_width
    ror
    sta.z __5
    lsr.z __5+1
    ror.z __5
    lsr.z __5+1
    ror.z __5
    lsr.z __5+1
    ror.z __5
    // conio_skip = (byte)(conio_width >> 4)
    lda.z __5
    sta.z conio_skip
    // vera_get_layer_map_height(conio_screen_layer)
    lda.z conio_screen_layer
    jsr vera_get_layer_map_height
    // conio_height = vera_get_layer_map_height(conio_screen_layer)
    lda.z __6
    sta.z conio_height
    lda.z __6+1
    sta.z conio_height+1
    // }
    rts
}
// Set the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_set_layer_textcolor(byte register(A) layer, byte register(X) color)
vera_set_layer_textcolor: {
    // layer &= $1
    and #1
    // vera_layer_textcolor[layer] = color
    tay
    txa
    sta vera_layer_textcolor,y
    // }
    rts
}
// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_set_layer_backcolor(byte register(A) layer, byte register(X) color)
vera_set_layer_backcolor: {
    // layer &= $1
    and #1
    // vera_layer_backcolor[layer] = color
    tay
    txa
    sta vera_layer_backcolor,y
    // }
    rts
}
// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - mapbase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// vera_set_layer_mapbase(byte register(A) layer, byte register(X) mapbase)
vera_set_layer_mapbase: {
    .label addr = $3c
    // layer &= $1
    and #1
    // addr = vera_layer_mapbase[layer]
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
// gotoxy(byte register(X) y)
gotoxy: {
    .label __6 = $3e
    .label line_offset = $3e
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
    // (unsigned int)y << conio_skip
    txa
    sta.z __6
    lda #0
    sta.z __6+1
    // line_offset = (unsigned int)y << conio_skip
    ldy.z conio_skip
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
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __2 = $40
    .label line_text = $2d
    .label skip = $49
    .label color = $40
    // line_text = CONIO_SCREEN_TEXT
    lda.z CONIO_SCREEN_TEXT
    sta.z line_text
    lda.z CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // skip = (word)((word)1<<conio_skip)
    ldy.z conio_skip
    lda #<1
    sta.z skip
    lda #>1+1
    sta.z skip+1
    cpy #0
    beq !e+
  !:
    asl.z skip
    rol.z skip+1
    dey
    bne !-
  !e:
    // vera_get_layer_backcolor(conio_screen_layer)
    lda.z conio_screen_layer
    jsr vera_get_layer_backcolor
    // vera_get_layer_backcolor(conio_screen_layer) << 4
    asl
    asl
    asl
    asl
    sta.z __2
    // vera_get_layer_textcolor(conio_screen_layer)
    lda.z conio_screen_layer
    jsr vera_get_layer_textcolor
    // color = ( vera_get_layer_backcolor(conio_screen_layer) << 4 ) | vera_get_layer_textcolor(conio_screen_layer)
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
    // <ch
    lda.z line_text
    // *VERA_ADDRX_L = <ch
    // Set address
    sta VERA_ADDRX_L
    // >ch
    lda.z line_text+1
    // *VERA_ADDRX_M = >ch
    sta VERA_ADDRX_M
    // CONIO_SCREEN_BANK | VERA_INC_1
    lda #VERA_INC_1
    ora.z CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = CONIO_SCREEN_BANK | VERA_INC_1
    sta VERA_ADDRX_H
    ldy #0
  __b4:
    // for( char c=0;c<conio_width; c++ )
    lda.z conio_width+1
    bne __b5
    cpy.z conio_width
    bcc __b5
    // line_text += skip
    lda.z line_text
    clc
    adc.z skip
    sta.z line_text
    lda.z line_text+1
    adc.z skip+1
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
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
vera_get_layer_config: {
    .label config = $49
    // config = vera_layer_config[layer]
    lda vera_layer_config+(1&1)*SIZEOF_POINTER
    sta.z config
    lda vera_layer_config+(1&1)*SIZEOF_POINTER+1
    sta.z config+1
    // return *config;
    ldy #0
    lda (config),y
    // }
    rts
}
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// vera_set_layer_config(byte register(X) config)
vera_set_layer_config: {
    .label addr = $49
    // addr = vera_layer_config[layer]
    lda vera_layer_config
    sta.z addr
    lda vera_layer_config+1
    sta.z addr+1
    // *addr = config
    txa
    ldy #0
    sta (addr),y
    // }
    rts
}
// Get the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - return: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
vera_get_layer_tilebase: {
    .label tilebase = $49
    // tilebase = vera_layer_tilebase[layer]
    lda vera_layer_tilebase+(1&1)*SIZEOF_POINTER
    sta.z tilebase
    lda vera_layer_tilebase+(1&1)*SIZEOF_POINTER+1
    sta.z tilebase+1
    // return *tilebase;
    ldy #0
    lda (tilebase),y
    // }
    rts
}
// Set the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// vera_set_layer_tilebase(byte register(X) tilebase)
vera_set_layer_tilebase: {
    .label addr = $49
    // addr = vera_layer_tilebase[layer]
    lda vera_layer_tilebase
    sta.z addr
    lda vera_layer_tilebase+1
    sta.z addr+1
    // *addr = tilebase
    txa
    ldy #0
    sta (addr),y
    // }
    rts
}
// Get the tile base address of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Specifies the base address of the tile map, which is calculated as an unsigned long int.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
vera_get_layer_tilebase_address: {
    .label address = $31
    .label return = $31
    // tilebase = *vera_layer_tilebase[layer]
    ldy vera_layer_tilebase
    sty.z $fe
    ldy vera_layer_tilebase+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    // address = tilebase
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
    asl.z return
    rol.z return+1
    rol.z return+2
    rol.z return+3
    // }
    rts
}
// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
scroll: {
    .const onoff = 0
    // conio_scroll_enable[conio_screen_layer] = onoff
    lda #onoff
    ldy.z conio_screen_layer
    sta conio_scroll_enable,y
    // }
    rts
}
// draw_characters(dword zp(3) tilebase)
draw_characters: {
    .label tilebase = 3
    .label tilerow = 3
    .label tilecolumn = 8
    .label bit = $41
    .label b = $12
    .label tilecolumn_1 = $d
    .label x = $11
    .label tilerow_1 = 8
    .label r = $c
    .label y = 7
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
    // vera_vram_address0(tilecolumn,VERA_INC_0)
    jsr vera_vram_address0
    // data = *VERA_DATA0
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
    sta.z cputc.c
    jmp __b6
  __b5:
    // (bit)?'*':'.'
    lda #'*'
    sta.z cputc.c
  __b6:
    // printf("%c", (char)((bit)?'*':'.'))
    jsr cputc
    // for(byte b:8..1)
    dec.z b
    lda.z b
    cmp #0
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
    .label ch = $42
    // ch = 0
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
    // }
    rts
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($2d) s)
cputs: {
    .label s = $2d
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
    // cputc(c)
    sta.z cputc.c
    jsr cputc
    jmp __b1
}
// Get the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - return: Returns the base address of the tile map.
//   Note that the register is a byte, specifying only bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// vera_get_layer_mapbase(byte register(A) layer)
vera_get_layer_mapbase: {
    .label mapbase = $43
    // layer &= $1
    and #1
    // mapbase = vera_layer_mapbase[layer]
    asl
    tay
    lda vera_layer_mapbase,y
    sta.z mapbase
    lda vera_layer_mapbase+1,y
    sta.z mapbase+1
    // return *mapbase;
    ldy #0
    lda (mapbase),y
    // }
    rts
}
// Get the map width or height of the layer.
// - layer: Value of 0 or 1.
// vera_get_layer_map_width(byte register(A) layer)
vera_get_layer_map_width: {
    .label return = $3e
    .label config = $43
    // config = vera_layer_config[layer]
    asl
    tay
    lda vera_layer_config,y
    sta.z config
    lda vera_layer_config+1,y
    sta.z config+1
    // *config & mask
    lda #VERA_CONFIG_WIDTH_MASK
    ldy #0
    and (config),y
    // (*config & mask) >> 4
    lsr
    lsr
    lsr
    lsr
    // return VERA_CONFIG_WIDTH[ (*config & mask) >> 4];
    asl
    tay
    lda VERA_CONFIG_WIDTH,y
    sta.z return
    lda VERA_CONFIG_WIDTH+1,y
    sta.z return+1
    // }
    rts
}
// vera_get_layer_map_height(byte register(A) layer)
vera_get_layer_map_height: {
    .label return = $3a
    .label config = $43
    // config = vera_layer_config[layer]
    asl
    tay
    lda vera_layer_config,y
    sta.z config
    lda vera_layer_config+1,y
    sta.z config+1
    // *config & mask
    lda #VERA_CONFIG_HEIGHT_MASK
    ldy #0
    and (config),y
    // (*config & mask) >> 6
    rol
    rol
    rol
    and #3
    // return VERA_CONFIG_HEIGHT[ (*config & mask) >> 6];
    asl
    tay
    lda VERA_CONFIG_HEIGHT,y
    sta.z return
    lda VERA_CONFIG_HEIGHT+1,y
    sta.z return+1
    // }
    rts
}
// Get the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_get_layer_backcolor(byte register(A) layer)
vera_get_layer_backcolor: {
    // layer &= $1
    and #1
    // return vera_layer_backcolor[layer];
    tay
    lda vera_layer_backcolor,y
    // }
    rts
}
// Get the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_get_layer_textcolor(byte register(A) layer)
vera_get_layer_textcolor: {
    // layer &= $1
    and #1
    // return vera_layer_textcolor[layer];
    tay
    lda vera_layer_textcolor,y
    // }
    rts
}
// --- VERA addressing ---
// vera_vram_address0(dword zp($d) bankaddr)
vera_vram_address0: {
    .label word_l = __0
    .label word_h = __1
    .label __0 = $45
    .label __1 = $47
    .label bankaddr = $d
    // <bankaddr
    lda.z bankaddr
    sta.z __0
    lda.z bankaddr+1
    sta.z __0+1
    // >bankaddr
    lda.z bankaddr+2
    sta.z __1
    lda.z bankaddr+3
    sta.z __1+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <(*word_l)
    lda.z word_l
    // *VERA_ADDRX_L = <(*word_l)
    // Set address
    sta VERA_ADDRX_L
    // >(*word_l)
    lda.z word_l+1
    // *VERA_ADDRX_M = >(*word_l)
    sta VERA_ADDRX_M
    // <(*word_h) | incr
    lda.z word_h
    // *VERA_ADDRX_H = <(*word_h) | incr
    sta VERA_ADDRX_H
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($40) c)
cputc: {
    .label __16 = $4b
    .label conio_addr = $49
    .label c = $40
    // vera_get_layer_color( conio_screen_layer)
    lda.z conio_screen_layer
    jsr vera_get_layer_color
    // vera_get_layer_color( conio_screen_layer)
    // color = vera_get_layer_color( conio_screen_layer)
    tax
    // CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    lda.z conio_screen_layer
    asl
    // conio_addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
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
    // <conio_addr
    lda.z conio_addr
    // *VERA_ADDRX_L = <conio_addr
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    lda.z conio_addr+1
    // *VERA_ADDRX_M = >conio_addr
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
    // scroll_enable = conio_scroll_enable[conio_screen_layer]
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
// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_get_layer_color(byte register(A) layer)
vera_get_layer_color: {
    // layer &= $1
    and #1
    tax
    // vera_layer_backcolor[layer] << 4
    lda vera_layer_backcolor,x
    asl
    asl
    asl
    asl
    // (vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]
    ora vera_layer_textcolor,x
    // }
    rts
}
// Print a newline
cputln: {
    .label __5 = $4f
    .label temp = $4d
    // temp = conio_line_text[conio_screen_layer]
    lda.z conio_screen_layer
    asl
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += (word)((word)1<<conio_skip)
    ldy.z conio_skip
    lda #<1
    sta.z __5
    lda #>1+1
    sta.z __5+1
    cpy #0
    beq !e+
  !:
    asl.z __5
    rol.z __5+1
    dey
    bne !-
  !e:
    lda.z temp
    clc
    adc.z __5
    sta.z temp
    lda.z temp+1
    adc.z __5+1
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
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label __6 = $55
    .label cy = $51
    .label width = $52
    .label line = $53
    .label start = $53
    // cy = conio_cursor_y[conio_screen_layer]
    ldy.z conio_screen_layer
    lda conio_cursor_y,y
    sta.z cy
    // width = CONIO_WIDTH * 2
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
    // line = (i-1) << conio_skip
    ldy.z conio_skip
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
    // start = CONIO_SCREEN_TEXT + line
    lda.z start
    clc
    adc.z CONIO_SCREEN_TEXT
    sta.z start
    lda.z start+1
    adc.z CONIO_SCREEN_TEXT+1
    sta.z start+1
    // (word)1<<conio_skip
    ldy.z conio_skip
    lda #<1
    sta.z __6
    lda #>1+1
    sta.z __6+1
    cpy #0
    beq !e+
  !:
    asl.z __6
    rol.z __6+1
    dey
    bne !-
  !e:
    // start+((word)1<<conio_skip)
    lda.z memcpy_in_vram.src
    clc
    adc.z start
    sta.z memcpy_in_vram.src
    lda.z memcpy_in_vram.src+1
    adc.z start+1
    sta.z memcpy_in_vram.src+1
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+((word)1<<conio_skip), VERA_INC_1, width)
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
    .label addr = $57
    .label c = $2f
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    lda.z conio_screen_layer
    asl
    // addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    tay
    clc
    lda.z CONIO_SCREEN_TEXT
    adc conio_line_text,y
    sta.z addr
    lda.z CONIO_SCREEN_TEXT+1
    adc conio_line_text+1,y
    sta.z addr+1
    // <addr
    lda.z addr
    // *VERA_ADDRX_L = <addr
    sta VERA_ADDRX_L
    // >addr
    lda.z addr+1
    // *VERA_ADDRX_M = >addr
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_get_layer_color( conio_screen_layer)
    lda.z conio_screen_layer
    jsr vera_get_layer_color
    // vera_get_layer_color( conio_screen_layer)
    // color = vera_get_layer_color( conio_screen_layer)
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
// memcpy_in_vram(void* zp($53) dest, byte* zp($55) src, word zp($57) num)
memcpy_in_vram: {
    .label i = $2f
    .label dest = $53
    .label src = $55
    .label num = $57
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <src
    lda.z src
    // *VERA_ADDRX_L = <src
    // Set address
    sta VERA_ADDRX_L
    // >src
    lda.z src+1
    // *VERA_ADDRX_M = >src
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = src_increment | src_bank
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // <dest
    lda.z dest
    // *VERA_ADDRX_L = <dest
    // Set address
    sta VERA_ADDRX_L
    // >dest
    lda.z dest+1
    // *VERA_ADDRX_M = >dest
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
  // --- VERA layer management ---
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
  VERA_CONFIG_WIDTH: .word $20, $40, $80, $100
  VERA_CONFIG_HEIGHT: .word $20, $40, $80, $100
