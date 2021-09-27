// Example program for the Commander X16.
// Demonstrates the usage of the VERA layer 0 and 1.
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cx16-veralayers.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  /// The colors of the CX16
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
  .const VERA_LAYER_WIDTH_128 = $20
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_64 = $40
  .const VERA_LAYER_HEIGHT_MASK = $c0
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_LAYER_TILEBASE_MASK = $fc
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const SIZEOF_UNSIGNED_INT = 2
  .const SIZEOF_POINTER = 2
  .const SIZEOF_UNSIGNED_LONG = 4
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
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
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  /// $9F36	L1_TILEBASE	    Layer 1 Tile Base
  /// Bit 2-7: Tile Base Address (16:11)
  /// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
  // Variable holding the screen width;
  .label conio_screen_width = $13
  // Variable holding the screen height;
  .label conio_screen_height = $1c
  // Variable holding the screen layer on the VERA card with which conio interacts;
  .label conio_screen_layer = $14
  // Variables holding the current map width and map height of the layer.
  .label conio_width = $32
  .label conio_height = $27
  .label conio_rowshift = $15
  .label conio_rowskip = $16
  .label CONIO_SCREEN_BANK = $30
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
  .label CONIO_SCREEN_TEXT = $a
  .label CONIO_SCREEN_BANK_1 = $35
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
  .label CONIO_SCREEN_TEXT_1 = $39
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
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    jsr conio_x16_init
    jsr main
    rts
}
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = $34
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
    ldy #0
    jsr gotoxy
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($2b) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label __16 = $24
    .label c = $2b
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
    .const vera_layer_is_visible1_layer = 1
    .label screensizex1_return = $31
    .label screensizey1_return = $38
    .label dcvideo = $31
    .label config = $31
    .label vera_layer_is_visible1_return = $2f
    .label mapbase = $31
    .label tilebase = $36
    .label vera_layer_is_visible2_return = $31
    .label tilebase_1 = $37
    .label vera_layer_is_visible3_return = $31
    .label vera_layer_is_visible4_return = $31
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
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #YELLOW
    jsr vera_layer_set_textcolor
    // printf("press a key")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
  __b1:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b1
    lda.z CONIO_SCREEN_TEXT_1
    sta.z CONIO_SCREEN_TEXT
    lda.z CONIO_SCREEN_TEXT_1+1
    sta.z CONIO_SCREEN_TEXT+1
    // clearline()
    jsr clearline
    // screenlayer(1)
    lda #1
    jsr screenlayer
    // gotoxy(0,16)
    ldy #0
    ldx #$10
    jsr gotoxy
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #GREEN
    jsr vera_layer_set_textcolor
    // printf("this program demonstrates the layer functionality in text mode.\n")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // return conio_screen_width;
    lda.z conio_screen_width
    sta.z screensizex1_return
    // return conio_screen_height;
    lda.z conio_screen_height
    sta.z screensizey1_return
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    ldy #DECIMAL
    jsr printf_uchar
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    lda.z screensizey1_return
    sta.z printf_uchar.uvalue
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    ldy #DECIMAL
    jsr printf_uchar
    // printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey())
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // unsigned byte dcvideo = *VERA_DC_VIDEO
    // This is the content of the main controller registers of the VERA of layer 1.
    // Layer 1 is the default layer that is activated in the CX16 at startup.
    // It displays the characters in 1BPP 16x16 color mode!
    lda VERA_DC_VIDEO
    sta.z dcvideo
    // printf("\nvera dc video = %x\n", dcvideo)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // printf("\nvera dc video = %x\n", dcvideo)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("\nvera dc video = %x\n", dcvideo)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // unsigned byte config = vera_layer_get_config(1)
    lda #1
    jsr vera_layer_get_config
    // unsigned byte config = vera_layer_get_config(1)
    sta.z config
    // printf("\nvera layer 1 config = %x\n", config)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // printf("\nvera layer 1 config = %x\n", config)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("\nvera layer 1 config = %x\n", config)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // *VERA_DC_VIDEO & vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    and vera_layer_enable+vera_layer_is_visible1_layer
    sta.z vera_layer_is_visible1_return
    // printf("vera layer 1 shown = %c\n", layershown)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s9
    sta.z printf_str.s
    lda #>s9
    sta.z printf_str.s+1
    jsr printf_str
    // printf("vera layer 1 shown = %c\n", layershown)
    lda.z vera_layer_is_visible1_return
    pha
    jsr cputc
    pla
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // unsigned byte mapbase = vera_layer_get_mapbase(1)
    lda #1
    jsr vera_layer_get_mapbase
    // unsigned byte mapbase = vera_layer_get_mapbase(1)
    sta.z mapbase
    // unsigned byte tilebase = vera_layer_get_tilebase(1)
    lda #1
    jsr vera_layer_get_tilebase
    // unsigned byte tilebase = vera_layer_get_tilebase(1)
    sta.z tilebase
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s11
    sta.z printf_str.s
    lda #>s11
    sta.z printf_str.s+1
    jsr printf_str
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s12
    sta.z printf_str.s
    lda #>s12
    sta.z printf_str.s+1
    jsr printf_str
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    lda.z tilebase
    sta.z printf_uchar.uvalue
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #YELLOW
    jsr vera_layer_set_textcolor
    // printf("press a key")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
  __b3:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b3
    lda.z CONIO_SCREEN_TEXT_1
    sta.z CONIO_SCREEN_TEXT
    lda.z CONIO_SCREEN_TEXT_1+1
    sta.z CONIO_SCREEN_TEXT+1
    // clearline()
    jsr clearline
    // vera_layer_set_mapbase(0,0x80)
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
    jsr vera_layer_set_mapbase
    // vera_layer_get_config(1)
    lda #1
    jsr vera_layer_get_config
    // vera_layer_get_config(1)
    // vera_layer_set_config(0, vera_layer_get_config(1))
    tax
  // Set the map base to address 0x10000 in VERA VRAM!
    lda #0
    jsr vera_layer_set_config
    // vera_layer_get_tilebase(1)
    lda #1
    jsr vera_layer_get_tilebase
    // vera_layer_get_tilebase(1)
    // vera_layer_set_tilebase(0, vera_layer_get_tilebase(1))
    tax
    lda #0
    jsr vera_layer_set_tilebase
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #WHITE
    jsr vera_layer_set_textcolor
    // vera_layer_get_config(0)
    lda #0
    jsr vera_layer_get_config
    // vera_layer_get_config(0)
    lda #0
    jsr vera_layer_get_config
    // vera_layer_get_config(0)
    // printf("\nvera layer 0 config = %x\n", vera_layer_get_config(0))
    sta.z printf_uchar.uvalue
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s15
    sta.z printf_str.s
    lda #>s15
    sta.z printf_str.s+1
    jsr printf_str
    // printf("\nvera layer 0 config = %x\n", vera_layer_get_config(0))
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("\nvera layer 0 config = %x\n", vera_layer_get_config(0))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // *VERA_DC_VIDEO & vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    and vera_layer_enable
    sta.z vera_layer_is_visible2_return
    // printf("vera layer 0 shown = %x\n", layershown)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s17
    sta.z printf_str.s
    lda #>s17
    sta.z printf_str.s+1
    jsr printf_str
    // printf("vera layer 0 shown = %x\n", layershown)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 shown = %x\n", layershown)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // vera_layer_get_mapbase(0)
    lda #0
    jsr vera_layer_get_mapbase
    // vera_layer_get_mapbase(0)
    // mapbase = vera_layer_get_mapbase(0)
    sta.z mapbase
    // vera_layer_get_tilebase(0)
    lda #0
    jsr vera_layer_get_tilebase
    // vera_layer_get_tilebase(0)
    // tilebase = vera_layer_get_tilebase(0)
    sta.z tilebase_1
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s19
    sta.z printf_str.s
    lda #>s19
    sta.z printf_str.s+1
    jsr printf_str
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s12
    sta.z printf_str.s
    lda #>s12
    sta.z printf_str.s+1
    jsr printf_str
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    lda.z tilebase_1
    sta.z printf_uchar.uvalue
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // screenlayer(0)
  // Now we print the layer 0 text on the layer 0!
    lda #0
    jsr screenlayer
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLUE
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // clrscr()
    jsr clrscr
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #WHITE
    jsr vera_layer_set_backcolor
    // gotoxy(19,4)
    ldy #$13
    ldx #4
    jsr gotoxy
    // printf("                                        ")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s22
    sta.z printf_str.s
    lda #>s22
    sta.z printf_str.s+1
    jsr printf_str
    // gotoxy(19,5)
    ldy #$13
    ldx #5
    jsr gotoxy
    // printf("     this is printed on layer 0 !!!     ")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s23
    sta.z printf_str.s
    lda #>s23
    sta.z printf_str.s+1
    jsr printf_str
    // gotoxy(19,6)
    ldy #$13
    ldx #6
    jsr gotoxy
    // printf("                                        ")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s22
    sta.z printf_str.s
    lda #>s22
    sta.z printf_str.s+1
    jsr printf_str
    // screenlayer(1)
    lda #1
    jsr screenlayer
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #YELLOW
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // printf("press a key to show layer 0 and show the text!")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s25
    sta.z printf_str.s
    lda #>s25
    sta.z printf_str.s+1
    jsr printf_str
  __b5:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b5
    lda.z CONIO_SCREEN_TEXT_1
    sta.z CONIO_SCREEN_TEXT
    lda.z CONIO_SCREEN_TEXT_1+1
    sta.z CONIO_SCREEN_TEXT+1
    // clearline()
    jsr clearline
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #WHITE
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // *VERA_DC_VIDEO & vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    and vera_layer_enable
    sta.z vera_layer_is_visible3_return
    // printf("vera layer 0 shown = %x. ", vera_layer_is_visible(0))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s17
    sta.z printf_str.s
    lda #>s17
    sta.z printf_str.s+1
    jsr printf_str
    // printf("vera layer 0 shown = %x. ", vera_layer_is_visible(0))
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 shown = %x. ", vera_layer_is_visible(0))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s27
    sta.z printf_str.s
    lda #>s27
    sta.z printf_str.s+1
    jsr printf_str
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #YELLOW
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // printf("press a key to hide layer 0 and hide the text again")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s28
    sta.z printf_str.s
    lda #>s28
    sta.z printf_str.s+1
    jsr printf_str
  __b7:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b7
    lda.z CONIO_SCREEN_TEXT_1
    sta.z CONIO_SCREEN_TEXT
    lda.z CONIO_SCREEN_TEXT_1+1
    sta.z CONIO_SCREEN_TEXT+1
    // clearline()
    jsr clearline
    // ~vera_layer_enable[layer]
    lda vera_layer_enable
    eor #$ff
    // *VERA_DC_VIDEO &= ~vera_layer_enable[layer]
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #WHITE
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // *VERA_DC_VIDEO & vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    and vera_layer_enable
    sta.z vera_layer_is_visible4_return
    // printf("vera layer 0 shown = %x. ", vera_layer_is_visible(0))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s17
    sta.z printf_str.s
    lda #>s17
    sta.z printf_str.s+1
    jsr printf_str
    // printf("vera layer 0 shown = %x. ", vera_layer_is_visible(0))
    ldy #HEXADECIMAL
    jsr printf_uchar
    // printf("vera layer 0 shown = %x. ", vera_layer_is_visible(0))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s27
    sta.z printf_str.s
    lda #>s27
    sta.z printf_str.s+1
    jsr printf_str
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #YELLOW
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // printf("press a key to finish")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s31
    sta.z printf_str.s
    lda #>s31
    sta.z printf_str.s+1
    jsr printf_str
  __b9:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b9
    lda.z CONIO_SCREEN_TEXT_1
    sta.z CONIO_SCREEN_TEXT
    lda.z CONIO_SCREEN_TEXT_1+1
    sta.z CONIO_SCREEN_TEXT+1
    // clearline()
    jsr clearline
    // clrscr()
    jsr clrscr
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #RED
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #WHITE
    jsr vera_layer_set_backcolor
    // gotoxy(19,10)
    ldy #$13
    ldx #$a
    jsr gotoxy
    // printf("                                     ")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s32
    sta.z printf_str.s
    lda #>s32
    sta.z printf_str.s+1
    jsr printf_str
    // gotoxy(19,11)
    ldy #$13
    ldx #$b
    jsr gotoxy
    // printf("     analyze the code and learn!     ")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s33
    sta.z printf_str.s
    lda #>s33
    sta.z printf_str.s+1
    jsr printf_str
    // gotoxy(19,12)
    ldy #$13
    ldx #$c
    jsr gotoxy
    // printf("                                     ")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s32
    sta.z printf_str.s
    lda #>s32
    sta.z printf_str.s+1
    jsr printf_str
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
    .label layer = 1
    .label mapbase_address = 0
    .label tilebase_address = $f800
    // vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 )
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
    .label __2 = $20
    .label __4 = $1e
    .label __5 = $29
    .label vera_layer_get_width1_config = $2d
    .label vera_layer_get_width1_return = $20
    .label vera_layer_get_height1_config = $22
    .label vera_layer_get_height1_return = $29
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
    .label addr = $20
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
// void gotoxy(__register(Y) char x, __register(X) char y)
gotoxy: {
    .label __6 = $c
    .label line_offset = $c
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
    .label addr = 6
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
    .label temp = 6
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
    .label line_text = $1a
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
/// Print a NUL-terminated string
// void printf_str(__zp($1a) void (*putc)(char), __zp($18) const char *s)
printf_str: {
    .label s = $18
    .label putc = $1a
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
    jsr icall2
    pla
    jmp __b1
  icall2:
    jmp (putc)
}
// Return true if there's a key waiting, return false if not
kbhit: {
    .label chptr = ch
    .label IN_DEV = $28a
    // Current input device number
    .label GETIN = $ffe4
    .label ch = $2c
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
    // }
    rts
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
// Print an unsigned char using a specific format
// void printf_uchar(void (*putc)(char), __zp($31) char uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, __register(Y) char format_radix)
printf_uchar: {
    .label uvalue = $31
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    ldx.z uvalue
    // Format number into buffer
    jsr uctoa
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Get the configuration of the layer.
// - layer: Value of 0 or 1.
// - return: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// __register(A) char vera_layer_get_config(__register(A) char layer)
vera_layer_get_config: {
    .label config = $1a
    // byte* config = vera_layer_config[layer]
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
// Get the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - return: Returns the base address of the tile map.
//   Note that the register is a byte, specifying only bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// __register(A) char vera_layer_get_mapbase(__register(A) char layer)
vera_layer_get_mapbase: {
    .label mapbase = $18
    // byte* mapbase = vera_layer_mapbase[layer]
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
// __register(A) char vera_layer_get_tilebase(__register(A) char layer)
vera_layer_get_tilebase: {
    .label tilebase = $18
    // byte* tilebase = vera_layer_tilebase[layer]
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
// void vera_layer_set_config(__register(A) char layer, __register(X) char config)
vera_layer_set_config: {
    .label addr = $1e
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
    .label addr = $22
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
// void vera_layer_mode_tile(char layer, unsigned long mapbase_address, unsigned long tilebase_address, unsigned int mapwidth, unsigned int mapheight, char tilewidth, char tileheight, char color_depth)
vera_layer_mode_tile: {
    .const tilebase_address = vera_layer_mode_text.tilebase_address>>1
    .const mapbase = 0
    // config
    .const config = VERA_LAYER_WIDTH_128|VERA_LAYER_HEIGHT_64
    // vera_layer_rowshift[layer] = 8
    lda #8
    sta vera_layer_rowshift+vera_layer_mode_text.layer
    // vera_layer_rowskip[layer] = 256
    lda #<$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_INT
    lda #>$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_INT+1
    // vera_layer_set_config(layer, config)
    ldx #config
    lda #vera_layer_mode_text.layer
    jsr vera_layer_set_config
    // vera_mapbase_offset[layer] = WORD0(mapbase_address)
    // mapbase
    lda #<0
    sta vera_mapbase_offset+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_INT
    sta vera_mapbase_offset+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_INT+1
    // vera_mapbase_bank[layer] = BYTE2(mapbase_address)
    sta vera_mapbase_bank+vera_layer_mode_text.layer
    // vera_mapbase_address[layer] = mapbase_address
    lda #<vera_layer_mode_text.mapbase_address
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_LONG
    lda #>vera_layer_mode_text.mapbase_address
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_LONG+1
    lda #<vera_layer_mode_text.mapbase_address>>$10
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_LONG+2
    lda #>vera_layer_mode_text.mapbase_address>>$10
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_LONG+3
    // vera_layer_set_mapbase(layer,mapbase)
    ldx #mapbase
    lda #vera_layer_mode_text.layer
    jsr vera_layer_set_mapbase
    // vera_tilebase_offset[layer] = WORD0(tilebase_address)
    // tilebase
    lda #<vera_layer_mode_text.tilebase_address&$ffff
    sta vera_tilebase_offset+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_INT
    lda #>vera_layer_mode_text.tilebase_address&$ffff
    sta vera_tilebase_offset+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_INT+1
    // vera_tilebase_bank[layer] = BYTE2(tilebase_address)
    lda #0
    sta vera_tilebase_bank+vera_layer_mode_text.layer
    // vera_tilebase_address[layer] = tilebase_address
    lda #<vera_layer_mode_text.tilebase_address
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_LONG
    lda #>vera_layer_mode_text.tilebase_address
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_LONG+1
    lda #<vera_layer_mode_text.tilebase_address>>$10
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_LONG+2
    lda #>vera_layer_mode_text.tilebase_address>>$10
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_LONG+3
    // vera_layer_set_tilebase(layer,tilebase)
    ldx #(>tilebase_address)&VERA_LAYER_TILEBASE_MASK
    lda #vera_layer_mode_text.layer
    jsr vera_layer_set_tilebase
    // }
    rts
}
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
// void vera_layer_set_text_color_mode(char layer, char color_mode)
vera_layer_set_text_color_mode: {
    .label addr = $29
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
// __zp($2d) unsigned int vera_layer_get_mapbase_offset(__register(A) char layer)
vera_layer_get_mapbase_offset: {
    .label return = $2d
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
// __zp($1e) unsigned int vera_layer_get_rowskip(__register(A) char layer)
vera_layer_get_rowskip: {
    .label return = $1e
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
    ldy #0
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__register(X) char value, __zp($1a) char *buffer, __register(Y) char radix)
uctoa: {
    .label buffer = $1a
    .label digit = $1d
    .label started = $26
    .label max_digits = $2f
    .label digit_values = $18
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
    // unsigned char digit_value = digit_values[digit]
    ldy.z digit
    lda (digit_values),y
    tay
    // if (started || value >= digit_value)
    lda.z started
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
// void printf_number_buffer(void (*putc)(char), __register(A) char buffer_sign, char *buffer_digits, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label putc = cputc
    // if(buffer.sign)
    cmp #0
    beq __b2
    // putc(buffer.sign)
    pha
    jsr cputc
    pla
  __b2:
    // printf_str(putc, buffer.digits)
    lda #<putc
    sta.z printf_str.putc
    lda #>putc
    sta.z printf_str.putc+1
    lda #<buffer_digits
    sta.z printf_str.s
    lda #>buffer_digits
    sta.z printf_str.s+1
    jsr printf_str
    // }
    rts
}
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label cy = $11
    .label width = $10
    .label line = 8
    .label start = 8
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __register(X) char uctoa_append(__zp($1a) char *buffer, __register(X) char value, __zp($12) char sub)
uctoa_append: {
    .label buffer = $1a
    .label sub = $12
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
// void memcpy_in_vram(char dest_bank, __zp(8) void *dest, char dest_increment, char src_bank, __zp($e) char *src, char src_increment, __zp(4) unsigned int num)
memcpy_in_vram: {
    .label i = 2
    .label dest = 8
    .label src = $e
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
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
