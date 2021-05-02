// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="tilemap_8bpp_16_x_16.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // The colors of the CX16
  .const BLACK = 0
  .const WHITE = 1
  .const BLUE = 6
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
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
  // Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
  .const VERA_LAYER_COLOR_DEPTH_1BPP = 0
  .const VERA_LAYER_COLOR_DEPTH_2BPP = 1
  .const VERA_LAYER_COLOR_DEPTH_4BPP = 2
  .const VERA_LAYER_COLOR_DEPTH_8BPP = 3
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_TILEBASE_WIDTH_16 = 1
  .const VERA_TILEBASE_HEIGHT_16 = 2
  .const VERA_LAYER_TILEBASE_MASK = $fc
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
  .label VERA_L0_CONFIG = $9f2d
  // $9F2E	L0_MAPBASE	    Layer 0 Map Base Address (16:9)
  .label VERA_L0_MAPBASE = $9f2e
  // Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L0_TILEBASE = $9f2f
  // $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  // $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  // $9F36	L1_TILEBASE	    Layer 1 Tile Base
  // Bit 2-7: Tile Base Address (16:11)
  // Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  // Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
  // Variable holding the screen width;
  .label conio_screen_width = $1d
  // Variable holding the screen height;
  .label conio_screen_height = $1e
  // Variable holding the screen layer on the VERA card with which conio interacts;
  .label conio_screen_layer = $1f
  // Variables holding the current map width and map height of the layer.
  .label conio_width = $20
  .label conio_height = $22
  .label conio_rowshift = $24
  .label conio_rowskip = $25
  .label CONIO_SCREEN_BANK = $27
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
  .label CONIO_SCREEN_TEXT = $28
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
    .label line = 2
    // char line = *BASIC_CURSOR_LINE
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    jsr vera_layer_mode_text
    // screensize(&conio_screen_width, &conio_screen_height)
    jsr screensize
    // screenlayer(1)
    jsr screenlayer
    // vera_layer_set_textcolor(1, WHITE)
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
main: {
    .label tilebase = 3
    .label t = 5
    .label tile = 8
    .label c = $a
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label row = 6
    .label r = 7
    .label column1 = $c
    .label r1 = $b
    // memcpy_in_vram(1, 0xF000, VERA_INC_1, 0, 0xF800, VERA_INC_1, 256*8)
  // Before we can load the tiles into memory we need to re-arrange a few things!
  // The amount of tiles is 256, the color depth is 256, so each tile is 256 bytes!
  // That is 65356 bytes of memory, which is 64K. Yup! One memory bank in VRAM.
  // VERA VRAM holds in bank 1 many registers that interfere loading all of this data.
  // So it is better to load all in bank 0, but then there is an other issue.
  // So the default CX16 character set is located in bank 0, at address 0xF800.
  // So we need to move this character set to bank 1, suggested is at address 0xF000.
  // The CX16 by default writes textual output to layer 1 in text mode, so we need to
  // realign the moved character set to 0xf000 as the new tile base for layer 1.
  // We also will need to realign for layer 1 the map base from 0x00000 to 0x10000.
  // This is now all easily done with a few statements in the new kickc vera lib ...
    lda #<$100*8
    sta.z memcpy_in_vram.num
    lda #>$100*8
    sta.z memcpy_in_vram.num+1
    lda #1
    sta.z memcpy_in_vram.dest_bank
    lda #<$f000
    sta.z memcpy_in_vram.dest
    lda #>$f000
    sta.z memcpy_in_vram.dest+1
    ldy #0
    lda #<$f800
    sta.z memcpy_in_vram.src
    lda #>$f800
    sta.z memcpy_in_vram.src+1
    jsr memcpy_in_vram
    // vera_layer_mode_tile(1, 0x10000, 0x1F000, 128, 64, 8, 8, 1)
  // We copy the 128 character set of 8 bytes each.
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    sta.z vera_layer_mode_tile.tilewidth
    lda #<$1f000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$1f000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    lda #<$10000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$10000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$10000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$10000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    lda #1
    sta.z vera_layer_mode_tile.layer
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    ldx #1
    jsr vera_layer_mode_tile
    // screenlayer(1)
    jsr screenlayer
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLACK
    jsr vera_layer_set_backcolor
    // clrscr()
    jsr clrscr
    // vera_layer_mode_tile(0, 0x14000, 0x00000, 64, 64, 16, 16, 8)
  // Now we can use the full bank 0!
  // We set the mapbase of the tile demo to output to 0x12000,
  // and the tilebase is set to 0x0000!
    lda #$10
    sta.z vera_layer_mode_tile.tileheight
    sta.z vera_layer_mode_tile.tilewidth
    lda #0
    sta.z vera_layer_mode_tile.tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address+1
    sta.z vera_layer_mode_tile.tilebase_address+2
    sta.z vera_layer_mode_tile.tilebase_address+3
    lda #<$14000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    lda #0
    sta.z vera_layer_mode_tile.layer
    lda #<$40
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$40
    sta.z vera_layer_mode_tile.mapwidth+1
    ldx #8
    jsr vera_layer_mode_tile
    // memcpy_to_vram(0, tilebase, tiles, 256)
    lda #<0
    sta.z memcpy_to_vram.vdest
    sta.z memcpy_to_vram.vdest+1
    jsr memcpy_to_vram
    lda #1
    sta.z t
    lda #<$100
    sta.z tilebase
    lda #>$100
    sta.z tilebase+1
  __b1:
    ldx #0
  __b2:
    // tiles[p]+=1
    lda tiles,x
    inc
    sta tiles,x
    // for(byte p:0..255)
    inx
    cpx #0
    bne __b2
    // memcpy_to_vram(0, tilebase, tiles, 256)
    lda.z tilebase
    sta.z memcpy_to_vram.vdest
    lda.z tilebase+1
    sta.z memcpy_to_vram.vdest+1
    jsr memcpy_to_vram
    // tilebase+=256
    clc
    lda.z tilebase
    adc #<$100
    sta.z tilebase
    lda.z tilebase+1
    adc #>$100
    sta.z tilebase+1
    // for(byte t:1..255)
    inc.z t
    lda.z t
    bne __b1
    // vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0)
  //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)
    lda #$28
    sta.z vera_tile_area.w
    lda #$1e
    sta.z vera_tile_area.h
    lda #0
    sta.z vera_tile_area.x
    sta.z vera_tile_area.y
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    jsr vera_tile_area
    lda #0
    sta.z r
    lda #1
    sta.z row
    lda #<0
    sta.z tile
    sta.z tile+1
  __b5:
    lda #0
    sta.z c
    tax
  __b6:
    // vera_tile_area(0, tile, column, row, 1, 1, 0, 0, 0)
    stx.z vera_tile_area.x
    lda #1
    sta.z vera_tile_area.w
    sta.z vera_tile_area.h
    jsr vera_tile_area
    // column+=2
    inx
    inx
    // tile++;
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // tile &= 0xff
    lda #$ff
    and.z tile
    sta.z tile
    lda #0
    sta.z tile+1
    // for(byte c:0..19)
    inc.z c
    lda #$14
    cmp.z c
    bne __b6
    // row += 2
    lda.z row
    clc
    adc #2
    sta.z row
    // for(byte r:0..11)
    inc.z r
    lda #$c
    cmp.z r
    bne __b5
    // gotoxy(0,50)
    ldx #$32
    jsr gotoxy
    // printf("vera in tile mode 8 x 8, color depth 8 bits per pixel.\n")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("each tile can have a variation of 256 colors.\n")
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("the vera palette of 256 colors, can be used by setting the palette\n")
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("offset for each tile.\n")
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("here each column is displaying the same tile, but with different offsets!\n")
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // printf("each offset aligns to multiples of 16 colors in the palette!.\n")
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // printf("however, the first color will always be transparent (black).\n")
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
  __b9:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b9
    // vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0)
    lda #$28
    sta.z vera_tile_area.w
    lda #$1e
    sta.z vera_tile_area.h
    lda #0
    sta.z vera_tile_area.x
    sta.z vera_tile_area.y
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    jsr vera_tile_area
    lda #0
    sta.z r1
    sta.z row
    sta.z tile
    sta.z tile+1
  __b11:
    ldx #0
    txa
    sta.z column1
  __b12:
    // vera_tile_area(0, tile, column, row, 2, 2, 0, 0, 0)
    lda #2
    sta.z vera_tile_area.w
    sta.z vera_tile_area.h
    jsr vera_tile_area
    // column+=2
    lda.z column1
    clc
    adc #2
    sta.z column1
    // tile++;
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // tile &= 0xff
    lda #$ff
    and.z tile
    sta.z tile
    lda #0
    sta.z tile+1
    // for(byte c:0..19)
    inx
    cpx #$14
    bne __b12
    // row += 2
    lda.z row
    clc
    adc #2
    sta.z row
    // for(byte r:0..11)
    inc.z r1
    lda #$c
    cmp.z r1
    bne __b11
  __b14:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b14
    // vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0)
  // Now put back the defaults ...
    lda #$28
    sta.z vera_tile_area.w
    lda #$1e
    sta.z vera_tile_area.h
    lda #0
    sta.z vera_tile_area.x
    sta.z vera_tile_area.y
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    jsr vera_tile_area
    // ~vera_layer_enable[layer]
    lda vera_layer_enable
    eor #$ff
    // *VERA_DC_VIDEO &= ~vera_layer_enable[layer]
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // memcpy_in_vram(0, 0xF800, VERA_INC_1, 1, 0xF000, VERA_INC_1, 256*8)
    lda #<$100*8
    sta.z memcpy_in_vram.num
    lda #>$100*8
    sta.z memcpy_in_vram.num+1
    lda #0
    sta.z memcpy_in_vram.dest_bank
    lda #<$f800
    sta.z memcpy_in_vram.dest
    lda #>$f800
    sta.z memcpy_in_vram.dest+1
    ldy #1
    lda #<$f000
    sta.z memcpy_in_vram.src
    lda #>$f000
    sta.z memcpy_in_vram.src+1
    jsr memcpy_in_vram
    // vera_layer_mode_tile(1, 0x00000, 0x0F800, 128, 128, 8, 8, 1)
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    sta.z vera_layer_mode_tile.tilewidth
    lda #<$f800
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$f800
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$f800>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$f800>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    lda #0
    sta.z vera_layer_mode_tile.mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address+1
    sta.z vera_layer_mode_tile.mapbase_address+2
    sta.z vera_layer_mode_tile.mapbase_address+3
    lda #<$80
    sta.z vera_layer_mode_tile.mapheight
    lda #>$80
    sta.z vera_layer_mode_tile.mapheight+1
    lda #1
    sta.z vera_layer_mode_tile.layer
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    ldx #1
    jsr vera_layer_mode_tile
    // vera_layer_mode_tile(0, 0x00000, 0x0F800, 128, 128, 8, 8, 1)
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    sta.z vera_layer_mode_tile.tilewidth
    lda #<$f800
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$f800
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$f800>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$f800>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    lda #0
    sta.z vera_layer_mode_tile.mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address+1
    sta.z vera_layer_mode_tile.mapbase_address+2
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
    ldx #1
    jsr vera_layer_mode_tile
    // screenlayer(1)
    jsr screenlayer
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLUE
    jsr vera_layer_set_backcolor
    // clrscr()
    jsr clrscr
    // }
    rts
  .segment Data
    tiles: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    s: .text @"vera in tile mode 8 x 8, color depth 8 bits per pixel.\n"
    .byte 0
    s1: .text @"in this mode, tiles are 8 pixels wide and 8 pixels tall.\n"
    .byte 0
    s2: .text @"each tile can have a variation of 256 colors.\n"
    .byte 0
    s3: .text @"the vera palette of 256 colors, can be used by setting the palette\n"
    .byte 0
    s4: .text @"offset for each tile.\n"
    .byte 0
    s5: .text @"here each column is displaying the same tile, but with different offsets!\n"
    .byte 0
    s6: .text @"each offset aligns to multiples of 16 colors in the palette!.\n"
    .byte 0
    s7: .text @"however, the first color will always be transparent (black).\n"
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
    ldx #1
    jsr vera_layer_mode_tile
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    jsr vera_layer_set_text_color_mode
    // }
    rts
}
// Return the current screen size.
screensize: {
    .label x = conio_screen_width
    .label y = conio_screen_height
    // char hscale = (*VERA_DC_HSCALE) >> 7
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
screenlayer: {
    .label __2 = $34
    .label __4 = $2c
    .label __5 = $31
    .label vera_layer_get_width1_config = $2a
    .label vera_layer_get_width1_return = $34
    .label vera_layer_get_height1_config = $2e
    .label vera_layer_get_height1_return = $31
    // conio_screen_layer = layer
    lda #1
    sta.z conio_screen_layer
    // vera_layer_get_mapbase_bank(conio_screen_layer)
    tax
    jsr vera_layer_get_mapbase_bank
    sta.z CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(conio_screen_layer)
    lda.z conio_screen_layer
    jsr vera_layer_get_mapbase_offset
    lda.z vera_layer_get_mapbase_offset.return
    sta.z CONIO_SCREEN_TEXT
    lda.z vera_layer_get_mapbase_offset.return+1
    sta.z CONIO_SCREEN_TEXT+1
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
// vera_layer_set_textcolor(byte register(X) layer)
vera_layer_set_textcolor: {
    // vera_layer_textcolor[layer] = color
    lda #WHITE
    sta vera_layer_textcolor,x
    // }
    rts
}
// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_set_backcolor(byte register(X) layer, byte register(A) color)
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
// vera_layer_set_mapbase(byte register(A) layer, byte register(X) mapbase)
vera_layer_set_mapbase: {
    .label addr = $34
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
// gotoxy(byte register(X) y)
gotoxy: {
    .label __6 = $2c
    .label line_offset = $2c
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
    // (unsigned int)y << conio_rowshift
    txa
    sta.z __6
    lda #0
    sta.z __6+1
    // unsigned int line_offset = (unsigned int)y << conio_rowshift
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
// memcpy_in_vram(byte zp($18) dest_bank, void* zp($47) dest, byte register(Y) src_bank, byte* zp($45) src, word zp($4d) num)
memcpy_in_vram: {
    .label i = $49
    .label dest = $47
    .label src = $45
    .label num = $4d
    .label dest_bank = $18
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
    // src_increment | src_bank
    tya
    ora #VERA_INC_1
    // *VERA_ADDRX_H = src_increment | src_bank
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
    // dest_increment | dest_bank
    lda #VERA_INC_1
    ora.z dest_bank
    // *VERA_ADDRX_H = dest_increment | dest_bank
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
// vera_layer_mode_tile(byte zp($d) layer, dword zp($e) mapbase_address, dword zp($12) tilebase_address, word zp($2c) mapwidth, word zp($2a) mapheight, byte zp($16) tilewidth, byte zp($17) tileheight, byte register(X) color_depth)
vera_layer_mode_tile: {
    .label __1 = $2e
    .label __2 = $31
    .label __4 = $41
    .label __7 = $34
    .label __8 = $36
    .label __10 = $38
    .label __19 = $30
    .label __20 = $33
    .label mapbase_address = $e
    .label tilebase_address = $12
    .label layer = $d
    .label mapwidth = $2c
    .label mapheight = $2a
    .label tileheight = $17
    .label tilewidth = $16
    // case 1:
    //             config |= VERA_LAYER_COLOR_DEPTH_1BPP;
    //             break;
    cpx #1
    beq __b1
    // case 2:
    //             config |= VERA_LAYER_COLOR_DEPTH_2BPP;
    //             break;
    cpx #2
    beq __b2
    // case 4:
    //             config |= VERA_LAYER_COLOR_DEPTH_4BPP;
    //             break;
    cpx #4
    beq __b3
    // case 8:
    //             config |= VERA_LAYER_COLOR_DEPTH_8BPP;
    //             break;
    cpx #8
    bne __b4
    ldx #VERA_LAYER_COLOR_DEPTH_8BPP
    jmp __b5
  __b1:
    ldx #VERA_LAYER_COLOR_DEPTH_1BPP
    jmp __b5
  __b2:
    ldx #VERA_LAYER_COLOR_DEPTH_2BPP
    jmp __b5
  __b3:
    ldx #VERA_LAYER_COLOR_DEPTH_4BPP
    jmp __b5
  __b4:
    ldx #0
  __b5:
    // case 32:
    //             config |= VERA_LAYER_WIDTH_32;
    //             vera_layer_rowshift[layer] = 6;
    //             vera_layer_rowskip[layer] = 64;
    //             break;
    lda #$20
    cmp.z mapwidth
    bne !+
    lda.z mapwidth+1
    bne !+
    jmp __b9
  !:
    // case 64:
    //             config |= VERA_LAYER_WIDTH_64;
    //             vera_layer_rowshift[layer] = 7;
    //             vera_layer_rowskip[layer] = 128;
    //             break;
    lda #$40
    cmp.z mapwidth
    bne !+
    lda.z mapwidth+1
    bne !+
    jmp __b10
  !:
    // case 128:
    //             config |= VERA_LAYER_WIDTH_128;
    //             vera_layer_rowshift[layer] = 8;
    //             vera_layer_rowskip[layer] = 256;
    //             break;
    lda #$80
    cmp.z mapwidth
    bne !+
    lda.z mapwidth+1
    bne !+
    jmp __b11
  !:
    // case 256:
    //             config |= VERA_LAYER_WIDTH_256;
    //             vera_layer_rowshift[layer] = 9;
    //             vera_layer_rowskip[layer] = 512;
    //             break;
    lda.z mapwidth+1
    cmp #>$100
    bne __b13
    lda.z mapwidth
    cmp #<$100
    bne __b13
    // config |= VERA_LAYER_WIDTH_256
    txa
    ora #VERA_LAYER_WIDTH_256
    tax
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
  __b13:
    // case 32:
    //             config |= VERA_LAYER_HEIGHT_32;
    //             break;
    lda #$20
    cmp.z mapheight
    bne !+
    lda.z mapheight+1
    bne !+
    jmp __b20
  !:
    // case 64:
    //             config |= VERA_LAYER_HEIGHT_64;
    //             break;
    lda #$40
    cmp.z mapheight
    bne !+
    lda.z mapheight+1
    bne !+
    jmp __b17
  !:
    // case 128:
    //             config |= VERA_LAYER_HEIGHT_128;
    //             break;
    lda #$80
    cmp.z mapheight
    bne !+
    lda.z mapheight+1
    bne !+
    jmp __b18
  !:
    // case 256:
    //             config |= VERA_LAYER_HEIGHT_256;
    //             break;
    lda.z mapheight+1
    cmp #>$100
    bne __b20
    lda.z mapheight
    cmp #<$100
    bne __b20
    // config |= VERA_LAYER_HEIGHT_256
    txa
    ora #VERA_LAYER_HEIGHT_256
    tax
  __b20:
    // vera_layer_set_config(layer, config)
    lda.z layer
    jsr vera_layer_set_config
    // <mapbase_address
    lda.z mapbase_address
    sta.z __1
    lda.z mapbase_address+1
    sta.z __1+1
    // vera_mapbase_offset[layer] = <mapbase_address
    lda.z layer
    asl
    sta.z __19
    // mapbase
    tay
    lda.z __1
    sta vera_mapbase_offset,y
    lda.z __1+1
    sta vera_mapbase_offset+1,y
    // >mapbase_address
    lda.z mapbase_address+2
    sta.z __2
    lda.z mapbase_address+3
    sta.z __2+1
    // vera_mapbase_bank[layer] = (byte)(>mapbase_address)
    ldy.z layer
    lda.z __2
    sta vera_mapbase_bank,y
    // vera_mapbase_address[layer] = mapbase_address
    tya
    asl
    asl
    sta.z __20
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
    // <mapbase_address
    lda.z mapbase_address
    sta.z __4
    lda.z mapbase_address+1
    sta.z __4+1
    // byte mapbase = >(<mapbase_address)
    tax
    // vera_layer_set_mapbase(layer,mapbase)
    lda.z layer
    jsr vera_layer_set_mapbase
    // <tilebase_address
    lda.z tilebase_address
    sta.z __7
    lda.z tilebase_address+1
    sta.z __7+1
    // vera_tilebase_offset[layer] = <tilebase_address
    // tilebase
    ldy.z __19
    lda.z __7
    sta vera_tilebase_offset,y
    lda.z __7+1
    sta vera_tilebase_offset+1,y
    // >tilebase_address
    lda.z tilebase_address+2
    sta.z __8
    lda.z tilebase_address+3
    sta.z __8+1
    // vera_tilebase_bank[layer] = (byte)>tilebase_address
    ldy.z layer
    lda.z __8
    sta vera_tilebase_bank,y
    // vera_tilebase_address[layer] = tilebase_address
    ldy.z __20
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
    // <tilebase_address
    lda.z tilebase_address
    sta.z __10
    lda.z tilebase_address+1
    sta.z __10+1
    // byte tilebase = >(<tilebase_address)
    // tilebase &= VERA_LAYER_TILEBASE_MASK
    and #VERA_LAYER_TILEBASE_MASK
    tax
    // case 8:
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    lda #8
    cmp.z tilewidth
    beq __b23
    // case 16:
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    lda #$10
    cmp.z tilewidth
    bne __b23
    // tilebase |= VERA_TILEBASE_WIDTH_16
    txa
    ora #VERA_TILEBASE_WIDTH_16
    tax
  __b23:
    // case 8:
    //             tilebase |= VERA_TILEBASE_HEIGHT_8;
    //             break;
    lda #8
    cmp.z tileheight
    beq __b26
    // case 16:
    //             tilebase |= VERA_TILEBASE_HEIGHT_16;
    //             break;
    lda #$10
    cmp.z tileheight
    bne __b26
    // tilebase |= VERA_TILEBASE_HEIGHT_16
    txa
    ora #VERA_TILEBASE_HEIGHT_16
    tax
  __b26:
    // vera_layer_set_tilebase(layer,tilebase)
    lda.z layer
    jsr vera_layer_set_tilebase
    // }
    rts
  __b18:
    // config |= VERA_LAYER_HEIGHT_128
    txa
    ora #VERA_LAYER_HEIGHT_128
    tax
    jmp __b20
  __b17:
    // config |= VERA_LAYER_HEIGHT_64
    txa
    ora #VERA_LAYER_HEIGHT_64
    tax
    jmp __b20
  __b11:
    // config |= VERA_LAYER_WIDTH_128
    txa
    ora #VERA_LAYER_WIDTH_128
    tax
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
    jmp __b13
  __b10:
    // config |= VERA_LAYER_WIDTH_64
    txa
    ora #VERA_LAYER_WIDTH_64
    tax
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
    jmp __b13
  __b9:
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
    jmp __b13
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $3a
    .label line_text = $45
    .label color = $3a
    // char* line_text = CONIO_SCREEN_TEXT
    lda.z CONIO_SCREEN_TEXT
    sta.z line_text
    lda.z CONIO_SCREEN_TEXT+1
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
    // line_text += conio_rowskip
    lda.z line_text
    clc
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
// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
// memcpy_to_vram(void* zp($47) vdest)
memcpy_to_vram: {
    .label end = main.tiles+$100
    .label s = $4d
    .label vdest = $47
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <vdest
    lda.z vdest
    // *VERA_ADDRX_L = <vdest
    // Set address
    sta VERA_ADDRX_L
    // >vdest
    lda.z vdest+1
    // *VERA_ADDRX_M = >vdest
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | vbank
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    lda #<main.tiles
    sta.z s
    lda #>main.tiles
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
// --- TILE FUNCTIONS ---
// vera_tile_area(word zp(8) tileindex, byte zp($c) x, byte zp(6) y, byte zp($3a) w, byte zp($18) h, byte zp($4c) hflip, byte zp($3d) vflip)
vera_tile_area: {
    .label __4 = $45
    .label __10 = $45
    .label vera_vram_address01___0 = $47
    .label vera_vram_address01___2 = $4d
    .label vera_vram_address01___4 = $49
    .label mapbase = $19
    .label shift = $4b
    .label rowskip = $3b
    .label hflip = $4c
    .label vflip = $3d
    .label index_l = $3e
    .label index_h = $3d
    .label r = $3f
    .label tileindex = 8
    .label x = $c
    .label y = 6
    .label h = $18
    .label w = $3a
    // dword mapbase = vera_mapbase_address[layer]
    lda vera_mapbase_address
    sta.z mapbase
    lda vera_mapbase_address+1
    sta.z mapbase+1
    lda vera_mapbase_address+2
    sta.z mapbase+2
    lda vera_mapbase_address+3
    sta.z mapbase+3
    // byte shift = vera_layer_rowshift[layer]
    lda vera_layer_rowshift
    sta.z shift
    // word rowskip = (word)1 << shift
    tay
    lda #<1
    sta.z rowskip
    lda #>1+1
    sta.z rowskip+1
    cpy #0
    beq !e+
  !:
    asl.z rowskip
    rol.z rowskip+1
    dey
    bne !-
  !e:
    // hflip = vera_layer_hflip[hflip]
    lda vera_layer_hflip
    sta.z hflip
    // vflip = vera_layer_vflip[vflip]
    lda vera_layer_vflip
    sta.z vflip
    // byte index_l = <tileindex
    lda.z tileindex
    sta.z index_l
    // byte index_h = >tileindex
    lda.z tileindex+1
    // index_h |= hflip
    ora.z hflip
    // index_h |= vflip
    ora.z index_h
    sta.z index_h
    // (word)y << shift
    lda.z y
    sta.z __10
    lda #0
    sta.z __10+1
    ldy.z shift
    beq !e+
  !:
    asl.z __4
    rol.z __4+1
    dey
    bne !-
  !e:
    // mapbase += ((word)y << shift)
    lda.z mapbase
    clc
    adc.z __4
    sta.z mapbase
    lda.z mapbase+1
    adc.z __4+1
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    // x << 1
    lda.z x
    asl
    // mapbase += (x << 1)
    clc
    adc.z mapbase
    sta.z mapbase
    lda.z mapbase+1
    adc #0
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    lda #0
    sta.z r
  __b1:
    // for(byte r=0; r<h; r++)
    lda.z r
    cmp.z h
    bcc vera_vram_address01
    // }
    rts
  vera_vram_address01:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <bankaddr
    lda.z mapbase
    sta.z vera_vram_address01___0
    lda.z mapbase+1
    sta.z vera_vram_address01___0+1
    // <(<bankaddr)
    lda.z vera_vram_address01___0
    // *VERA_ADDRX_L = <(<bankaddr)
    sta VERA_ADDRX_L
    // <bankaddr
    lda.z mapbase
    sta.z vera_vram_address01___2
    lda.z mapbase+1
    sta.z vera_vram_address01___2+1
    // >(<bankaddr)
    // *VERA_ADDRX_M = >(<bankaddr)
    sta VERA_ADDRX_M
    // >bankaddr
    lda.z mapbase+2
    sta.z vera_vram_address01___4
    lda.z mapbase+3
    sta.z vera_vram_address01___4+1
    // <(>bankaddr)
    lda.z vera_vram_address01___4
    // <(>bankaddr) | incr
    ora #VERA_INC_1
    // *VERA_ADDRX_H = <(>bankaddr) | incr
    sta VERA_ADDRX_H
    ldy #0
  __b2:
    // for(byte c=0; c<w; c++)
    cpy.z w
    bcc __b3
    // mapbase += rowskip
    lda.z mapbase
    clc
    adc.z rowskip
    sta.z mapbase
    lda.z mapbase+1
    adc.z rowskip+1
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    // for(byte r=0; r<h; r++)
    inc.z r
    jmp __b1
  __b3:
    // *VERA_DATA0 = index_l
    lda.z index_l
    sta VERA_DATA0
    // *VERA_DATA0 = index_h
    lda.z index_h
    sta VERA_DATA0
    // for(byte c=0; c<w; c++)
    iny
    jmp __b2
}
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp($3b) s)
cputs: {
    .label s = $3b
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
    .label ch = $40
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
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
vera_layer_set_text_color_mode: {
    .label addr = $41
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
// vera_layer_get_mapbase_bank(byte register(X) layer)
vera_layer_get_mapbase_bank: {
    // return vera_mapbase_bank[layer];
    lda vera_mapbase_bank,x
    // }
    rts
}
// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
// vera_layer_get_mapbase_offset(byte register(A) layer)
vera_layer_get_mapbase_offset: {
    .label return = $2c
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
// vera_layer_get_rowshift(byte register(X) layer)
vera_layer_get_rowshift: {
    // return vera_layer_rowshift[layer];
    lda vera_layer_rowshift,x
    // }
    rts
}
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
// vera_layer_get_rowskip(byte register(A) layer)
vera_layer_get_rowskip: {
    .label return = $2c
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
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// vera_layer_set_config(byte register(A) layer, byte register(X) config)
vera_layer_set_config: {
    .label addr = $43
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
// vera_layer_set_tilebase(byte register(A) layer, byte register(X) tilebase)
vera_layer_set_tilebase: {
    .label addr = $43
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
// Get the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_backcolor(byte register(X) layer)
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
// vera_layer_get_textcolor(byte register(X) layer)
vera_layer_get_textcolor: {
    // return vera_layer_textcolor[layer];
    lda vera_layer_textcolor,x
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($3f) c)
cputc: {
    .label __16 = $47
    .label conio_addr = $45
    .label c = $3f
    // vera_layer_get_color( conio_screen_layer)
    ldx.z conio_screen_layer
    jsr vera_layer_get_color
    // vera_layer_get_color( conio_screen_layer)
    // char color = vera_layer_get_color( conio_screen_layer)
    tax
    // CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    lda.z conio_screen_layer
    asl
    // char* conio_addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
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
// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_color(byte register(X) layer)
vera_layer_get_color: {
    .label addr = $4d
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
    .label temp = $49
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
    lda.z temp
    clc
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
    .label cy = $4b
    .label width = $4c
    .label line = $47
    .label start = $47
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
    lda.z start
    clc
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
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+conio_rowskip, VERA_INC_1, width)
    sta.z memcpy_in_vram.dest_bank
    tay
    jsr memcpy_in_vram
    // for(unsigned byte i=1; i<=cy; i++)
    inx
    jmp __b1
}
clearline: {
    .label addr = $4d
    .label c = $49
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    lda.z conio_screen_layer
    asl
    // byte* addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
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
    // vera_layer_get_color( conio_screen_layer)
    ldx.z conio_screen_layer
    jsr vera_layer_get_color
    // vera_layer_get_color( conio_screen_layer)
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
.segment Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  // --- VERA function encapsulation ---
  vera_mapbase_offset: .word 0, 0
  vera_mapbase_bank: .byte 0, 0
  vera_mapbase_address: .dword 0, 0
  vera_tilebase_offset: .word 0, 0
  vera_tilebase_bank: .byte 0, 0
  vera_tilebase_address: .dword 0, 0
  vera_layer_rowshift: .byte 0, 0
  vera_layer_rowskip: .word 0, 0
  vera_layer_hflip: .byte 0, 4
  vera_layer_vflip: .byte 0, 8
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
