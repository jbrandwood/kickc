// Example program for the Commander X16.
// Demonstrates the usage of the VERA layer 0 and 1.
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="veralayers.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // The colors of the CX16
  .const BLACK = 0
  .const WHITE = 1
  .const RED = 2
  .const GREEN = 5
  .const BLUE = 6
  .const YELLOW = 7
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const VERA_LAYER1_ENABLE = $20
  .const VERA_LAYER0_ENABLE = $10
  .const VERA_CONFIG_HEIGHT_MASK = $c0
  .const VERA_CONFIG_WIDTH_MASK = $30
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
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
  // Variable holding the screen width;
  .label conio_screen_width = 5
  // Variable holding the screen height;
  .label conio_screen_height = 6
  // Variable holding the screen layer on the VERA card with which conio interacts;
  .label conio_screen_layer = 7
  // Variables holding the current map width and map height of the layer.
  .label conio_width = 8
  .label conio_height = $a
  .label conio_skip = $c
  .label CONIO_SCREEN_BANK = $11
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
  .label CONIO_SCREEN_TEXT = $12
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
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    jsr conio_x16_init
    jsr main
    rts
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
    ldy #0
    jsr gotoxy
    // }
    rts
}
main: {
    .label screensizex1_return = 3
    .label screensizey1_return = $d
    .label dcvideo = 3
    .label config = 3
    .label layershown = $e
    .label mapbase = 3
    .label tilebase = $f
    .label layershown_1 = 3
    .label tilebase_1 = $10
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
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #YELLOW
    jsr vera_set_layer_textcolor
    // printf("press a key")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
  __b1:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b1
    // clearline()
    jsr clearline
    // screenlayer(1)
    lda #1
    jsr screenlayer
    // gotoxy(0,16)
    ldy #0
    ldx #$10
    jsr gotoxy
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #GREEN
    jsr vera_set_layer_textcolor
    // printf("this program demonstrates the layer functionality in text mode.\n")
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // return conio_screen_width;
    lda.z conio_screen_width
    sta.z screensizex1_return
    // return conio_screen_height;
    lda.z conio_screen_height
    sta.z screensizey1_return
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    ldy #DECIMAL
    jsr printf_uchar
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    lda.z screensizey1_return
    sta.z printf_uchar.uvalue
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    ldy #DECIMAL
    jsr printf_uchar
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // dcvideo = *VERA_DC_VIDEO
    // This is the content of the main controller registers of the VERA of layer 1.
    // Layer 1 is the default layer that is activated in the CX16 at startup.
    // It displays the characters in 1BPP 16x16 color mode!
    lda VERA_DC_VIDEO
    sta.z dcvideo
    // printf("\nvera dc video = %x\n", dcvideo)
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // printf("\nvera dc video = %x\n", dcvideo)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("\nvera dc video = %x\n", dcvideo)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // vera_get_layer_config(1)
    lda #1
    jsr vera_get_layer_config
    // vera_get_layer_config(1)
    // config = vera_get_layer_config(1)
    sta.z config
    // printf("\nvera layer 1 config = %x\n", config)
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // printf("\nvera layer 1 config = %x\n", config)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("\nvera layer 1 config = %x\n", config)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // vera_is_layer_shown(1)
    lda #1
    jsr vera_is_layer_shown
    // vera_is_layer_shown(1)
    // layershown = vera_is_layer_shown(1)
    sta.z layershown
    // printf("vera layer 1 shown = %c\n", layershown)
    lda #<s9
    sta.z cputs.s
    lda #>s9
    sta.z cputs.s+1
    jsr cputs
    // printf("vera layer 1 shown = %c\n", layershown)
    lda.z layershown
    sta.z cputc.c
    jsr cputc
    // printf("vera layer 1 shown = %c\n", layershown)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // vera_get_layer_mapbase(1)
    lda #1
    jsr vera_get_layer_mapbase
    // vera_get_layer_mapbase(1)
    // mapbase = vera_get_layer_mapbase(1)
    sta.z mapbase
    // vera_get_layer_tilebase(1)
    lda #1
    jsr vera_get_layer_tilebase
    // vera_get_layer_tilebase(1)
    // tilebase = vera_get_layer_tilebase(1)
    sta.z tilebase
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    lda #<s11
    sta.z cputs.s
    lda #>s11
    sta.z cputs.s+1
    jsr cputs
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    lda #<s12
    sta.z cputs.s
    lda #>s12
    sta.z cputs.s+1
    jsr cputs
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    lda.z tilebase
    sta.z printf_uchar.uvalue
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #YELLOW
    jsr vera_set_layer_textcolor
    // printf("press a key")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
  __b3:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b3
    // clearline()
    jsr clearline
    // vera_set_layer_mapbase(0,0x80)
  // Now we continue with demonstrating the layering!
  // We set the mapbase of layer 0 to an address in VRAM.
  // We copy the tilebase address from layer 1, so that we reference to the same tilebase.
  // We print a text on layer 0, which of course, won't yet be displayed,
  // because we haven't activated layer 0 on the VERA.
  // But the text will be printed and awaiting to be displayer later, once we activate layer 0!
  // But first, we also print the layer 0 VERA configuration.
  // This statement sets the base of the display layer 1 at VRAM address 0x0200
    ldx #$80
    lda #0
    jsr vera_set_layer_mapbase
    // vera_get_layer_config(1)
    lda #1
    jsr vera_get_layer_config
    // vera_get_layer_config(1)
    // vera_set_layer_config(0, vera_get_layer_config(1))
    tax
    // Set the map base to address 0x10000 in VERA VRAM!
    jsr vera_set_layer_config
    // vera_get_layer_tilebase(1)
    lda #1
    jsr vera_get_layer_tilebase
    // vera_get_layer_tilebase(1)
    // vera_set_layer_tilebase(0, vera_get_layer_tilebase(1))
    tax
    jsr vera_set_layer_tilebase
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #WHITE
    jsr vera_set_layer_textcolor
    // vera_get_layer_config(0)
    lda #0
    jsr vera_get_layer_config
    // vera_get_layer_config(0)
    lda #0
    jsr vera_get_layer_config
    // vera_get_layer_config(0)
    // printf("\nvera layer 0 config = %x\n", vera_get_layer_config(0))
    sta.z printf_uchar.uvalue
    lda #<s15
    sta.z cputs.s
    lda #>s15
    sta.z cputs.s+1
    jsr cputs
    // printf("\nvera layer 0 config = %x\n", vera_get_layer_config(0))
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("\nvera layer 0 config = %x\n", vera_get_layer_config(0))
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // vera_is_layer_shown(0)
    lda #0
    jsr vera_is_layer_shown
    // vera_is_layer_shown(0)
    // layershown = vera_is_layer_shown(0)
    sta.z layershown_1
    // printf("vera layer 0 shown = %x\n", layershown)
    lda #<s17
    sta.z cputs.s
    lda #>s17
    sta.z cputs.s+1
    jsr cputs
    // printf("vera layer 0 shown = %x\n", layershown)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 shown = %x\n", layershown)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // vera_get_layer_mapbase(0)
    lda #0
    jsr vera_get_layer_mapbase
    // vera_get_layer_mapbase(0)
    // mapbase = vera_get_layer_mapbase(0)
    sta.z mapbase
    // vera_get_layer_tilebase(0)
    lda #0
    jsr vera_get_layer_tilebase
    // vera_get_layer_tilebase(0)
    // tilebase = vera_get_layer_tilebase(0)
    sta.z tilebase_1
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    lda #<s19
    sta.z cputs.s
    lda #>s19
    sta.z cputs.s+1
    jsr cputs
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    lda #<s12
    sta.z cputs.s
    lda #>s12
    sta.z cputs.s+1
    jsr cputs
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    lda.z tilebase_1
    sta.z printf_uchar.uvalue
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // screenlayer(0)
  // Now we print the layer 0 text on the layer 0!
    lda #0
    jsr screenlayer
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLUE
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLACK
    jsr vera_set_layer_backcolor
    // clrscr()
    jsr clrscr
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #WHITE
    jsr vera_set_layer_backcolor
    // gotoxy(19,4)
    ldy #$13
    ldx #4
    jsr gotoxy
    // printf("                                        ")
    lda #<s22
    sta.z cputs.s
    lda #>s22
    sta.z cputs.s+1
    jsr cputs
    // gotoxy(19,5)
    ldy #$13
    ldx #5
    jsr gotoxy
    // printf("     this is printed on layer 0 !!!     ")
    lda #<s23
    sta.z cputs.s
    lda #>s23
    sta.z cputs.s+1
    jsr cputs
    // gotoxy(19,6)
    ldy #$13
    ldx #6
    jsr gotoxy
    // printf("                                        ")
    lda #<s22
    sta.z cputs.s
    lda #>s22
    sta.z cputs.s+1
    jsr cputs
    // screenlayer(1)
    lda #1
    jsr screenlayer
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #YELLOW
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLACK
    jsr vera_set_layer_backcolor
    // printf("press a key to show layer 0 and show the text!")
    lda #<s25
    sta.z cputs.s
    lda #>s25
    sta.z cputs.s+1
    jsr cputs
  __b5:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b5
    // clearline()
    jsr clearline
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #WHITE
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLACK
    jsr vera_set_layer_backcolor
    // vera_is_layer_shown(0)
    lda #0
    jsr vera_is_layer_shown
    // vera_is_layer_shown(0)
    // printf("vera layer 0 shown = %x. ", vera_is_layer_shown(0))
    sta.z printf_uchar.uvalue
    lda #<s17
    sta.z cputs.s
    lda #>s17
    sta.z cputs.s+1
    jsr cputs
    // printf("vera layer 0 shown = %x. ", vera_is_layer_shown(0))
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 shown = %x. ", vera_is_layer_shown(0))
    lda #<s27
    sta.z cputs.s
    lda #>s27
    sta.z cputs.s+1
    jsr cputs
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #YELLOW
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLACK
    jsr vera_set_layer_backcolor
    // printf("press a key to hide layer 0 and hide the text again")
    lda #<s28
    sta.z cputs.s
    lda #>s28
    sta.z cputs.s+1
    jsr cputs
  __b7:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b7
    // clearline()
    jsr clearline
    // ~vera_layer_enable[layer]
    lda vera_layer_enable
    eor #$ff
    // *VERA_DC_VIDEO &= ~vera_layer_enable[layer]
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #WHITE
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLACK
    jsr vera_set_layer_backcolor
    // vera_is_layer_shown(0)
    lda #0
    jsr vera_is_layer_shown
    // vera_is_layer_shown(0)
    // printf("vera layer 0 shown = %x. ", vera_is_layer_shown(0))
    sta.z printf_uchar.uvalue
    lda #<s17
    sta.z cputs.s
    lda #>s17
    sta.z cputs.s+1
    jsr cputs
    // printf("vera layer 0 shown = %x. ", vera_is_layer_shown(0))
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 shown = %x. ", vera_is_layer_shown(0))
    lda #<s27
    sta.z cputs.s
    lda #>s27
    sta.z cputs.s+1
    jsr cputs
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #YELLOW
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #BLACK
    jsr vera_set_layer_backcolor
    // printf("press a key to finish")
    lda #<s31
    sta.z cputs.s
    lda #>s31
    sta.z cputs.s+1
    jsr cputs
  __b9:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b9
    // clearline()
    jsr clearline
    // clrscr()
    jsr clrscr
    // vera_set_layer_textcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #RED
    jsr vera_set_layer_textcolor
    // vera_set_layer_backcolor(conio_screen_layer, color)
    lda.z conio_screen_layer
    ldx #WHITE
    jsr vera_set_layer_backcolor
    // gotoxy(19,10)
    ldy #$13
    ldx #$a
    jsr gotoxy
    // printf("                                     ")
    lda #<s32
    sta.z cputs.s
    lda #>s32
    sta.z cputs.s+1
    jsr cputs
    // gotoxy(19,11)
    ldy #$13
    ldx #$b
    jsr gotoxy
    // printf("     analyze the code and learn!     ")
    lda #<s33
    sta.z cputs.s
    lda #>s33
    sta.z cputs.s+1
    jsr cputs
    // gotoxy(19,12)
    ldy #$13
    ldx #$c
    jsr gotoxy
    // printf("                                     ")
    lda #<s32
    sta.z cputs.s
    lda #>s32
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  .segment Data
    s: .text "press a key"
    .byte 0
    s1: .text @"this program demonstrates the layer functionality in text mode.\n"
    .byte 0
    s2: .text @"\nvera card width = "
    .byte 0
    s3: .text "; height = "
    .byte 0
    s4: .text @"\n"
    .byte 0
    s5: .text @"\nvera dc video = "
    .byte 0
    s7: .text @"\nvera layer 1 config = "
    .byte 0
    s9: .text "vera layer 1 shown = "
    .byte 0
    s11: .text "vera layer 1 mapbase = "
    .byte 0
    s12: .text ", tilebase = "
    .byte 0
    s15: .text @"\nvera layer 0 config = "
    .byte 0
    s17: .text "vera layer 0 shown = "
    .byte 0
    s19: .text "vera layer 0 mapbase = "
    .byte 0
    s22: .text "                                        "
    .byte 0
    s23: .text "     this is printed on layer 0 !!!     "
    .byte 0
    s25: .text "press a key to show layer 0 and show the text!"
    .byte 0
    s27: .text ". "
    .byte 0
    s28: .text "press a key to hide layer 0 and hide the text again"
    .byte 0
    s31: .text "press a key to finish"
    .byte 0
    s32: .text "                                     "
    .byte 0
    s33: .text "     analyze the code and learn!     "
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
    .label __4 = $1a
    .label __5 = $14
    .label __6 = $16
    .label addr_i = $18
    // layer &= $1
    and #1
    // conio_screen_layer = layer
    sta.z conio_screen_layer
    // vera_get_layer_mapbase(layer)
    jsr vera_get_layer_mapbase
    // vera_get_layer_mapbase(layer)
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
    .label addr = $18
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
// gotoxy(byte register(Y) x, byte register(X) y)
gotoxy: {
    .label __6 = $1a
    .label line_offset = $1a
    // if(y>CONIO_HEIGHT)
    lda.z conio_screen_height
    stx.z $ff
    cmp.z $ff
    bcs __b1
    ldx #0
  __b1:
    // if(x>=CONIO_WIDTH)
    cpy.z conio_screen_width
    bcc __b2
    ldy #0
  __b2:
    // conio_cursor_x[conio_screen_layer] = x
    tya
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
    .label __2 = $2a
    .label line_text = $21
    .label skip = $1f
    .label color = $2a
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
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($21) s)
cputs: {
    .label s = $21
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
// Return true if there's a key waiting, return false if not
kbhit: {
    .label chptr = ch
    .label IN_DEV = $28a
    // Current input device number
    .label GETIN = $ffe4
    .label ch = $1c
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
clearline: {
    .label addr = $1f
    .label c = $1d
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
// Print an unsigned char using a specific format
// printf_uchar(byte zp(3) uvalue, byte register(Y) format_radix)
printf_uchar: {
    .label uvalue = 3
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    ldx.z uvalue
    // Format number into buffer
    jsr uctoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// vera_get_layer_config(byte register(A) layer)
vera_get_layer_config: {
    .label config = $1d
    // layer &= $1
    and #1
    // config = vera_layer_config[layer]
    asl
    tay
    lda vera_layer_config,y
    sta.z config
    lda vera_layer_config+1,y
    sta.z config+1
    // return *config;
    ldy #0
    lda (config),y
    // }
    rts
}
// Is the layer shown on the screen?
// - returns: 1 if layer is displayed on the screen, 0 if not.
// vera_is_layer_shown(byte register(A) layer)
vera_is_layer_shown: {
    // layer &= $1
    and #1
    // *VERA_DC_VIDEO & vera_layer_enable[layer]
    tay
    lda VERA_DC_VIDEO
    and vera_layer_enable,y
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp(4) c)
cputc: {
    .label __16 = $1f
    .label conio_addr = $1d
    .label c = 4
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
// Get the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - return: Returns the base address of the tile map.
//   Note that the register is a byte, specifying only bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// vera_get_layer_mapbase(byte register(A) layer)
vera_get_layer_mapbase: {
    .label mapbase = $23
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
// Get the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - return: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// vera_get_layer_tilebase(byte register(A) layer)
vera_get_layer_tilebase: {
    .label tilebase = $1f
    // layer &= $1
    and #1
    // tilebase = vera_layer_tilebase[layer]
    asl
    tay
    lda vera_layer_tilebase,y
    sta.z tilebase
    lda vera_layer_tilebase+1,y
    sta.z tilebase+1
    // return *tilebase;
    ldy #0
    lda (tilebase),y
    // }
    rts
}
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// vera_set_layer_config(byte register(X) config)
vera_set_layer_config: {
    .label addr = $21
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
// Set the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// vera_set_layer_tilebase(byte register(X) tilebase)
vera_set_layer_tilebase: {
    .label addr = $21
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
// Get the map width or height of the layer.
// - layer: Value of 0 or 1.
// vera_get_layer_map_width(byte register(A) layer)
vera_get_layer_map_width: {
    .label return = $1a
    .label config = $23
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
    .label return = $16
    .label config = $23
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($1f) buffer, byte register(Y) radix)
uctoa: {
    .label buffer = $1f
    .label digit = $e
    .label started = $2a
    .label max_digits = 4
    .label digit_values = $1d
    // if(radix==DECIMAL)
    cpy #DECIMAL
    beq __b2
    // if(radix==HEXADECIMAL)
    cpy #HEXADECIMAL
    beq __b3
    // if(radix==OCTAL)
    cpy #OCTAL
    beq __b4
    // if(radix==BINARY)
    cpy #BINARY
    beq __b5
    // *buffer++ = 'e'
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // }
    rts
  __b2:
    lda #<RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values+1
    lda #3
    sta.z max_digits
    jmp __b1
  __b3:
    lda #<RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values+1
    lda #2
    sta.z max_digits
    jmp __b1
  __b4:
    lda #<RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values+1
    lda #3
    sta.z max_digits
    jmp __b1
  __b5:
    lda #<RADIX_BINARY_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_CHAR
    sta.z digit_values+1
    lda #8
    sta.z max_digits
  __b1:
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    sta.z digit
  __b6:
    // max_digits-1
    lda.z max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    cmp.z digit
    beq !+
    bcs __b7
  !:
    // *buffer++ = DIGITS[(char)value]
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    lda #0
    tay
    sta (buffer),y
    rts
  __b7:
    // digit_value = digit_values[digit]
    ldy.z digit
    lda (digit_values),y
    tay
    // if (started || value >= digit_value)
    lda.z started
    cmp #0
    bne __b10
    sty.z $ff
    cpx.z $ff
    bcs __b10
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b6
  __b10:
    // uctoa_append(buffer++, value, digit_value)
    sty.z uctoa_append.sub
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #1
    sta.z started
    jmp __b9
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte register(A) buffer_sign)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // if(buffer.sign)
    cmp #0
    beq __b2
    // cputc(buffer.sign)
    sta.z cputc.c
    jsr cputc
  __b2:
    // cputs(buffer.digits)
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
}
// Print a newline
cputln: {
    .label __5 = $27
    .label temp = $25
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// uctoa_append(byte* zp($1f) buffer, byte register(X) value, byte zp($29) sub)
uctoa_append: {
    .label buffer = $1f
    .label sub = $29
    ldy #0
  __b1:
    // while (value >= sub)
    cpx.z sub
    bcs __b2
    // *buffer = DIGITS[digit]
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    iny
    // value -= sub
    txa
    sec
    sbc.z sub
    tax
    jmp __b1
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
    ldy #0
    jsr gotoxy
    rts
}
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label __6 = $2d
    .label cy = $29
    .label width = $2a
    .label line = $2b
    .label start = $2b
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
// memcpy_in_vram(void* zp($2b) dest, byte* zp($2d) src, word zp($2f) num)
memcpy_in_vram: {
    .label i = $1f
    .label dest = $2b
    .label src = $2d
    .label num = $2f
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
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of binary digits
  RADIX_BINARY_VALUES_CHAR: .byte $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES_CHAR: .byte $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // --- VERA layer management ---
  vera_layer_config: .word VERA_L0_CONFIG, VERA_L1_CONFIG
  vera_layer_enable: .byte VERA_LAYER0_ENABLE, VERA_LAYER1_ENABLE
  vera_layer_mapbase: .word VERA_L0_MAPBASE, VERA_L1_MAPBASE
  vera_layer_tilebase: .word VERA_L0_TILEBASE, VERA_L1_TILEBASE
  vera_layer_textcolor: .byte WHITE, WHITE
  vera_layer_backcolor: .byte BLUE, BLUE
  VERA_CONFIG_WIDTH: .word $20, $40, $80, $100
  VERA_CONFIG_HEIGHT: .word $20, $40, $80, $100
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
