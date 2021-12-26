// Commander X16 Load a file to a memory bank
.cpu _65c02
  // Create a bunch of files
.file [name="cx16-bankload.prg", type="prg", segments="Program"]
.file [name="SPRITE", type="bin", segments="Sprite"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
.segmentdef Sprite

  .const WHITE = 1
  .const BLUE = 6
  .const VERA_INC_1 = $10
  .const VERA_DCSEL = 2
  .const VERA_ADDRSEL = 1
  .const VERA_SPRITES_ENABLE = $40
  .const VERA_LAYER_WIDTH_128 = $20
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_64 = $40
  .const VERA_LAYER_HEIGHT_MASK = $c0
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_LAYER_TILEBASE_MASK = $fc
  /// VERA Palette address in VRAM  $1FA00 - $1FBFF
  /// 256 entries of 2 bytes
  /// byte 0 bits 4-7: Green
  /// byte 0 bits 0-3: Blue
  /// byte 1 bits 0-3: Red
  .const VERA_PALETTE = $1fa00
  /// Sprite Attributes address in VERA VRAM $1FC00 - $1FFFF
  .const VERA_SPRITE_ATTR = $1fc00
  /// 8BPP sprite mode (add to VERA_SPRITE.ADDR to enable)
  .const VERA_SPRITE_8BPP = $8000
  .const SIZEOF_UNSIGNED_INT = 2
  .const SIZEOF_POINTER = 2
  .const SIZEOF_UNSIGNED_LONG = 4
  .const SIZEOF_STRUCT_VERA_SPRITE = 8
  .const OFFSET_STRUCT_MOS6522_VIA_PORT_A = 1
  .const OFFSET_STRUCT_VERA_SPRITE_X = 2
  .const OFFSET_STRUCT_VERA_SPRITE_Y = 4
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
  /// The VIA#1: ROM/RAM Bank Control
  /// Port A Bits 0-7 RAM bank
  /// Port B Bits 0-2 ROM bank
  /// Port B Bits 3-7 [TBD]
  .label VIA1 = $9f60
  // Variable holding the screen width;
  .label conio_screen_width = $10
  // Variable holding the screen height;
  .label conio_screen_height = $19
  // Variable holding the screen layer on the VERA card with which conio interacts;
  .label conio_screen_layer = $18
  // Variables holding the current map width and map height of the layer.
  .label conio_width = $2e
  .label conio_height = $22
  .label conio_rowshift = $15
  .label conio_rowskip = $16
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
  .label CONIO_SCREEN_TEXT = $13
  .label CONIO_SCREEN_BANK = $2d
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
  .label CONIO_SCREEN_TEXT_1 = $3f
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
    .label line = $37
    // char line = *BASIC_CURSOR_LINE
    lda.z BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    jsr vera_layer_mode_text
    // screensize(&conio_screen_width, &conio_screen_height)
    jsr screensize
    // screenlayer(1)
    jsr screenlayer
    // vera_layer_set_textcolor(1, WHITE)
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(1, BLUE)
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
// void cputc(__zp($24) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label __16 = 2
    .label c = $24
    .label conio_addr = 6
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
    // RAM Bank where sprite is loaded
    .label BANK_SPRITE = $12000
    // VRAM address of sprite
    .label VRAM_SPRITE = $10000
    .label SPRITE_ATTR = $41
    // vera_layer_set_text_color_mode( 1, VERA_LAYER_CONFIG_16C )
    lda #1
    jsr vera_layer_set_text_color_mode
    // screenlayer(1)
    jsr screenlayer
    // clrscr()
    jsr clrscr
    // printf("\n\nsprite banked file load and display demo.\n")
    jsr printf_str
    // struct VERA_SPRITE SPRITE_ATTR = { WORD0(VRAM_SPRITE/32)|VERA_SPRITE_8BPP, 320-32, 240-32, 0x0c, 0xf1 }
    ldy #SIZEOF_STRUCT_VERA_SPRITE
  !:
    lda __0-1,y
    sta SPRITE_ATTR-1,y
    dey
    bne !-
    // char status = load_to_bank(8, "SPRITE", BANK_SPRITE )
    jsr load_to_bank
    // memcpy_bank_to_vram(VERA_PALETTE+32, BANK_SPRITE-2, 32)
    lda #$20
    sta.z memcpy_bank_to_vram.num
    lda #0
    sta.z memcpy_bank_to_vram.num+1
    sta.z memcpy_bank_to_vram.num+2
    sta.z memcpy_bank_to_vram.num+3
    lda #<BANK_SPRITE-2
    sta.z memcpy_bank_to_vram.beg
    lda #>BANK_SPRITE-2
    sta.z memcpy_bank_to_vram.beg+1
    lda #<BANK_SPRITE-2>>$10
    sta.z memcpy_bank_to_vram.beg+2
    lda #>BANK_SPRITE-2>>$10
    sta.z memcpy_bank_to_vram.beg+3
    lda #<VERA_PALETTE+$20
    sta.z memcpy_bank_to_vram.vdest
    lda #>VERA_PALETTE+$20
    sta.z memcpy_bank_to_vram.vdest+1
    lda #<VERA_PALETTE+$20>>$10
    sta.z memcpy_bank_to_vram.vdest+2
    lda #>VERA_PALETTE+$20>>$10
    sta.z memcpy_bank_to_vram.vdest+3
    jsr memcpy_bank_to_vram
    // memcpy_bank_to_vram(VRAM_SPRITE, BANK_SPRITE+32-2, 64*32)
    lda #<$40*$20
    sta.z memcpy_bank_to_vram.num
    lda #>$40*$20
    sta.z memcpy_bank_to_vram.num+1
    lda #<$40*$20>>$10
    sta.z memcpy_bank_to_vram.num+2
    lda #>$40*$20>>$10
    sta.z memcpy_bank_to_vram.num+3
    lda #<BANK_SPRITE+$20-2
    sta.z memcpy_bank_to_vram.beg
    lda #>BANK_SPRITE+$20-2
    sta.z memcpy_bank_to_vram.beg+1
    lda #<BANK_SPRITE+$20-2>>$10
    sta.z memcpy_bank_to_vram.beg+2
    lda #>BANK_SPRITE+$20-2>>$10
    sta.z memcpy_bank_to_vram.beg+3
    lda #<VRAM_SPRITE
    sta.z memcpy_bank_to_vram.vdest
    lda #>VRAM_SPRITE
    sta.z memcpy_bank_to_vram.vdest+1
    lda #<VRAM_SPRITE>>$10
    sta.z memcpy_bank_to_vram.vdest+2
    lda #>VRAM_SPRITE>>$10
    sta.z memcpy_bank_to_vram.vdest+3
    jsr memcpy_bank_to_vram
    // SPRITE_ATTR.ADDR = WORD0(VRAM_SPRITE/32)|VERA_SPRITE_4BPP
    lda #<VRAM_SPRITE/$20&$ffff
    sta.z SPRITE_ATTR
    lda #>VRAM_SPRITE/$20&$ffff
    sta.z SPRITE_ATTR+1
    // SPRITE_ATTR.X = 100
    lda #<$64
    sta.z SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X
    lda #>$64
    sta.z SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X+1
    // SPRITE_ATTR.Y = 100
    lda #<$64
    sta.z SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y
    lda #>$64
    sta.z SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y+1
    // memcpy_to_vram(BYTE2(VERA_SPRITE_ATTR), (char*)WORD0(VERA_SPRITE_ATTR), &SPRITE_ATTR, sizeof(SPRITE_ATTR))
    jsr memcpy_to_vram
    // *VERA_CTRL &= ~VERA_DCSEL
    // Enable sprites
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // }
    rts
  .segment Data
    s: .text @"\n\nsprite banked file load and display demo.\n"
    .byte 0
    filename: .text "SPRITE"
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
    lda #layer
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
// void screenlayer(char layer)
screenlayer: {
    .label __2 = $1c
    .label __4 = $11
    .label __5 = $1e
    .label vera_layer_get_width1_config = $1a
    .label vera_layer_get_width1_return = $1c
    .label vera_layer_get_height1_config = $25
    .label vera_layer_get_height1_return = $1e
    // conio_screen_layer = layer
    lda #1
    sta.z conio_screen_layer
    // vera_layer_get_mapbase_bank(conio_screen_layer)
    tay
    jsr vera_layer_get_mapbase_bank
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
    ldy.z conio_screen_layer
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
// char vera_layer_set_textcolor(char layer, char color)
vera_layer_set_textcolor: {
    .const layer = 1
    // vera_layer_textcolor[layer] = color
    lda #WHITE
    sta vera_layer_textcolor+layer
    // }
    rts
}
// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char vera_layer_set_backcolor(char layer, char color)
vera_layer_set_backcolor: {
    .const layer = 1
    // vera_layer_backcolor[layer] = color
    lda #BLUE
    sta vera_layer_backcolor+layer
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
    .label addr = $1c
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
    .label __6 = $11
    .label line_offset = $11
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
    .label addr = $a
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
    .label temp = $a
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
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
// void vera_layer_set_text_color_mode(__register(A) char layer, char color_mode)
vera_layer_set_text_color_mode: {
    .label addr = $25
    // byte* addr = vera_layer_config[layer]
    asl
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
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
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $f
    .label line_text = $20
    .label color = $f
    .label l = $24
    // char* line_text = CONIO_SCREEN_TEXT
    lda.z CONIO_SCREEN_TEXT_1
    sta.z line_text
    lda.z CONIO_SCREEN_TEXT_1+1
    sta.z line_text+1
    // vera_layer_get_backcolor(conio_screen_layer)
    ldy.z conio_screen_layer
    jsr vera_layer_get_backcolor
    // vera_layer_get_backcolor(conio_screen_layer) << 4
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(conio_screen_layer)
    ldy.z conio_screen_layer
    jsr vera_layer_get_textcolor
    // char color = ( vera_layer_get_backcolor(conio_screen_layer) << 4 ) | vera_layer_get_textcolor(conio_screen_layer)
    ora.z color
    sta.z color
    lda #0
    sta.z l
  __b1:
    // for( char l=0;l<conio_height; l++ )
    lda.z conio_height+1
    bne __b2
    lda.z l
    cmp.z conio_height
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
    txa
    ora #VERA_INC_1
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
    inc.z l
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
// void printf_str(void (*putc)(char), __zp($20) const char *s)
printf_str: {
    .label s = $20
    lda #<main.s
    sta.z s
    lda #>main.s
    sta.z s+1
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
// Load a file into one of the 256 8KB RAM banks.
// - device: The device to load from
// - filename: The file name
// - address: The absolute address in banked memory to load the file too
// - returns: 0xff: Success, other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
// Note: This function only works if the entire file fits within the selected bank. The function cannot load to multiple banks.
// char load_to_bank(char device, char *filename, unsigned long address)
load_to_bank: {
    .const device = 8
    .const bank = (<main.BANK_SPRITE>>$10)<<3|(>main.BANK_SPRITE)>>5
    // setnam(filename)
    lda #<main.filename
    sta.z setnam.filename
    lda #>main.filename
    sta.z setnam.filename+1
    jsr setnam
    // setlfs(device)
    lda #device
    sta.z setlfs.device
    jsr setlfs
    // VIA1->PORT_A = (char)bank
    lda #bank
    sta VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // load(addr, 0)
    lda #<0+$a000
    sta.z load.address
    lda #>0+$a000
    sta.z load.address+1
    lda #0
    sta.z load.verify
    jsr load
    // }
    rts
}
// Copy block of memory (from banked RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vdest: absolute address in VRAM
// - src: absolute address in the banked RAM  of the CX16.
// - num: dword of the number of bytes to copy
// Note: This function can switch RAM bank during copying to copy data from multiple RAM banks.
// void memcpy_bank_to_vram(__zp($38) unsigned long vdest, unsigned long src, __zp($33) unsigned long num)
memcpy_bank_to_vram: {
    .label __5 = $f
    .label __9 = $20
    .label beg = $27
    .label end = $33
    // select the bank
    .label addr = $20
    .label pos = $27
    .label vdest = $38
    .label num = $33
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(vdest)
    lda.z vdest
    // *VERA_ADDRX_L = BYTE0(vdest)
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(vdest)
    lda.z vdest+1
    // *VERA_ADDRX_M = BYTE1(vdest)
    sta VERA_ADDRX_M
    // BYTE2(vdest)
    lda.z vdest+2
    // *VERA_ADDRX_H = BYTE2(vdest)
    sta VERA_ADDRX_H
    // *VERA_ADDRX_H |= VERA_INC_1
    lda #VERA_INC_1
    ora VERA_ADDRX_H
    sta VERA_ADDRX_H
    // unsigned long end = src+num
    clc
    lda.z end
    adc.z beg
    sta.z end
    lda.z end+1
    adc.z beg+1
    sta.z end+1
    lda.z end+2
    adc.z beg+2
    sta.z end+2
    lda.z end+3
    adc.z beg+3
    sta.z end+3
    // BYTE2(beg)
    lda.z beg+2
    // BYTE2(beg)<<3
    asl
    asl
    asl
    sta.z __5
    // BYTE1(beg)
    lda.z beg+1
    // BYTE1(beg)>>5
    lsr
    lsr
    lsr
    lsr
    lsr
    // char bank = BYTE2(beg)<<3 | BYTE1(beg)>>5
    ora.z __5
    tax
    // WORD0(beg)
    lda.z beg
    sta.z __9
    lda.z beg+1
    sta.z __9+1
    // WORD0(beg)&0x1FFF
    lda.z addr
    and #<$1fff
    sta.z addr
    lda.z addr+1
    and #>$1fff
    sta.z addr+1
    // addr += 0xA000
    // stip off the top 3 bits, which are representing the bank of the word!
    lda.z addr
    clc
    adc #<$a000
    sta.z addr
    lda.z addr+1
    adc #>$a000
    sta.z addr+1
    // VIA1->PORT_A = (char)bank
    stx VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
  __b1:
  // select the bank
    // for(unsigned long pos=beg; pos<end; pos++)
    lda.z pos+3
    cmp.z end+3
    bcc __b2
    bne !+
    lda.z pos+2
    cmp.z end+2
    bcc __b2
    bne !+
    lda.z pos+1
    cmp.z end+1
    bcc __b2
    bne !+
    lda.z pos
    cmp.z end
    bcc __b2
  !:
    // }
    rts
  __b2:
    // if(addr == 0xC000)
    lda.z addr+1
    cmp #>$c000
    bne __b3
    lda.z addr
    cmp #<$c000
    bne __b3
    // VIA1->PORT_A = (char)++bank;
    inx
    // VIA1->PORT_A = (char)++bank
    stx VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    lda #<$a000
    sta.z addr
    lda #>$a000
    sta.z addr+1
  __b3:
    // *VERA_DATA0 = *addr
    ldy #0
    lda (addr),y
    sta VERA_DATA0
    // addr++;
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // for(unsigned long pos=beg; pos<end; pos++)
    inc.z pos
    bne !+
    inc.z pos+1
    bne !+
    inc.z pos+2
    bne !+
    inc.z pos+3
  !:
    jmp __b1
}
// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
// void memcpy_to_vram(char vbank, void *vdest, void *src, unsigned int num)
memcpy_to_vram: {
    .const vbank = <VERA_SPRITE_ATTR>>$10
    .label vdest = VERA_SPRITE_ATTR&$ffff
    .label src = main.SPRITE_ATTR
    // Transfer the data
    .label end = src+SIZEOF_STRUCT_VERA_SPRITE
    .label s = $20
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_L = BYTE0(vdest)
    // Set address
    lda #0
    sta VERA_ADDRX_L
    // *VERA_ADDRX_M = BYTE1(vdest)
    lda #>vdest
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | vbank
    lda #VERA_INC_1|vbank
    sta VERA_ADDRX_H
    lda #<src
    sta.z s
    lda #>src
    sta.z s+1
  __b1:
    // for(char *s = src; s!=end; s++)
    lda.z s+1
    cmp #>end
    bne __b2
    lda.z s
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *VERA_DATA0 = *s
    ldy #0
    lda (s),y
    sta VERA_DATA0
    // for(char *s = src; s!=end; s++)
    inc.z s
    bne !+
    inc.z s+1
  !:
    jmp __b1
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
    .const mapbase = 0
    .label tilebase_address = vera_layer_mode_text.tilebase_address>>1
    // config
    .label config = VERA_LAYER_WIDTH_128|VERA_LAYER_HEIGHT_64
    // vera_layer_rowshift[layer] = 8
    lda #8
    sta vera_layer_rowshift+vera_layer_mode_text.layer
    // vera_layer_rowskip[layer] = 256
    lda #<$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_INT
    lda #>$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_UNSIGNED_INT+1
    // vera_layer_set_config(layer, config)
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
    jsr vera_layer_set_tilebase
    // }
    rts
}
// Get the map base bank of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Bank in vera vram.
// __register(X) char vera_layer_get_mapbase_bank(__register(Y) char layer)
vera_layer_get_mapbase_bank: {
    // return vera_mapbase_bank[layer];
    ldx vera_mapbase_bank,y
    // }
    rts
}
// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
// __zp($1a) unsigned int vera_layer_get_mapbase_offset(__register(A) char layer)
vera_layer_get_mapbase_offset: {
    .label return = $1a
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
// __register(A) char vera_layer_get_rowshift(__register(Y) char layer)
vera_layer_get_rowshift: {
    // return vera_layer_rowshift[layer];
    lda vera_layer_rowshift,y
    // }
    rts
}
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
// __zp($11) unsigned int vera_layer_get_rowskip(__register(A) char layer)
vera_layer_get_rowskip: {
    .label return = $11
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
// __register(A) char vera_layer_get_backcolor(__register(Y) char layer)
vera_layer_get_backcolor: {
    // return vera_layer_backcolor[layer];
    lda vera_layer_backcolor,y
    // }
    rts
}
// Get the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// __register(A) char vera_layer_get_textcolor(__register(Y) char layer)
vera_layer_get_textcolor: {
    // return vera_layer_textcolor[layer];
    lda vera_layer_textcolor,y
    // }
    rts
}
// Kernal SETNAM function
// SETNAM. Set file name parameters.
// void setnam(__zp($30) char * volatile filename)
setnam: {
    .label filename = $30
    .label filename_len = $2b
    .label __0 = 2
    // strlen(filename)
    lda.z filename
    sta.z strlen.str
    lda.z filename+1
    sta.z strlen.str+1
    jsr strlen
    // strlen(filename)
    // char filename_len = (char)strlen(filename)
    lda.z __0
    sta.z filename_len
    // asm
    ldx filename
    ldy filename+1
    jsr $ffbd
    // }
    rts
}
// SETLFS. Set file parameters.
// void setlfs(__zp($32) volatile char device)
setlfs: {
    .label device = $32
    // asm
    ldx device
    lda #1
    ldy #0
    jsr $ffba
    // }
    rts
}
// LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
// - verify: 0 = Load, 1-255 = Verify
//
// Returns a status, 0xff: Success other: Kernal Error Code
// char load(__zp($3d) char * volatile address, __zp($3c) volatile char verify)
load: {
    .label address = $3d
    .label verify = $3c
    .label status = $2c
    // char status
    lda #0
    sta.z status
    // asm
    ldx address
    ldy address+1
    lda verify
    jsr $ffd5
    bcs error
    lda #$ff
  error:
    sta status
    // }
    rts
}
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// void vera_layer_set_config(char layer, char config)
vera_layer_set_config: {
    .label addr = $1e
    // byte* addr = vera_layer_config[layer]
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr = config
    lda #vera_layer_mode_tile.config
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
// void vera_layer_set_tilebase(char layer, char tilebase)
vera_layer_set_tilebase: {
    .label addr = $1a
    // byte* addr = vera_layer_tilebase[layer]
    lda vera_layer_tilebase+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_tilebase+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr = tilebase
    lda #(>vera_layer_mode_tile.tilebase_address)&VERA_LAYER_TILEBASE_MASK
    ldy #0
    sta (addr),y
    // }
    rts
}
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label cy = $f
    .label width = $e
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
// Computes the length of the string str up to but not including the terminating null character.
// __zp(2) unsigned int strlen(__zp(6) char *str)
strlen: {
    .label str = 6
    .label return = 2
    .label len = 2
    lda #<0
    sta.z len
    sta.z len+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // len++;
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
clearline: {
    .label addr = $c
    .label c = 6
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
// void memcpy_in_vram(char dest_bank, __zp(8) void *dest, char dest_increment, char src_bank, __zp($c) char *src, char src_increment, __zp(4) unsigned int num)
memcpy_in_vram: {
    .label i = 2
    .label dest = 8
    .label src = $c
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
.segment Sprite
SPRITE_PIXELS:
.var pic = LoadPicture("ship.png")
    // palette: rgb->idx
    .var palette = Hashtable()
    // RGB value for each palette index
    .var palList = List()
    // Next palette index
    .var nxt_idx = 0;
    // Extract palette while outputting pixels as palete index values
    .for (var y=0; y<64; y++) {
        .for (var x=0;x<64; x++) {
            // Find palette index (add if not known)
            .var rgb = pic.getPixel(x,y);
            .var idx = palette.get(rgb)
            .if(idx==null) {
                .eval idx = nxt_idx++;
                .eval palette.put(rgb,idx);
                .eval palList.add(rgb)
            }
        }
    }
    .if(nxt_idx>16) .error "Image has too many colours "+nxt_idx

    .for(var i=0;i<16;i++) {
        .var rgb = palList.get(i)
        .var red = floor(rgb / [256*256])
        .var green = floor(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
    }

    .for (var y=0; y<64; y++) {
        .for (var x=0;x<64; x+=2) {
            // Find palette index (add if not known)
            .var rgb = pic.getPixel(x,y);
            .var idx1 = palette.get(rgb)
            .if(idx1==null) {
                .printnow "unknown rgb value!"
            }
            // Find palette index (add if not known)
            .eval rgb = pic.getPixel(x+1,y);
            .var idx2 = palette.get(rgb)
            .if(idx2==null) {
                .printnow "unknown rgb value!"
            }
            .byte idx1*16+idx2;
        }
    }

.segment Data
  __0: .word (main.VRAM_SPRITE/$20&$ffff)|VERA_SPRITE_8BPP, $140-$20, $f0-$20
  .byte $c, $f1
