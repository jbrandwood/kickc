// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="bitmap_8bpp_320_x_240.prg", type="prg", segments="Program"]
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
  .const YELLOW = 7
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
  .const VERA_LAYER_COLOR_DEPTH_8BPP = 3
  .const VERA_LAYER_COLOR_DEPTH_MASK = 3
  .const VERA_LAYER_CONFIG_MODE_BITMAP = 4
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
  .label conio_screen_width = $19
  // Variable holding the screen height;
  .label conio_screen_height = $1a
  // Variable holding the screen layer on the VERA card with which conio interacts;
  .label conio_screen_layer = $1b
  // Variables holding the current map width and map height of the layer.
  .label conio_width = $1c
  .label conio_height = $1e
  .label conio_rowshift = $20
  .label conio_rowskip = $21
  .label __bitmap_address = $23
  .label __bitmap_layer = $27
  .label __bitmap_hscale = $28
  .label __bitmap_vscale = $29
  .label __bitmap_color_depth = $2a
  // The random state variable
  .label rand_state = $11
  // Remainder after unsigned 16-bit division
  .label rem16u = $52
  .label CONIO_SCREEN_BANK = $2b
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
  .label CONIO_SCREEN_TEXT = $2c
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
    // __ma dword __bitmap_address = 0
    sta.z __bitmap_address
    sta.z __bitmap_address+1
    lda #<0>>$10
    sta.z __bitmap_address+2
    lda #>0>>$10
    sta.z __bitmap_address+3
    // __ma byte __bitmap_layer = 0
    lda #0
    sta.z __bitmap_layer
    // __ma byte __bitmap_hscale = 0
    sta.z __bitmap_hscale
    // __ma byte __bitmap_vscale = 0
    sta.z __bitmap_vscale
    // __ma byte __bitmap_color_depth = 0
    sta.z __bitmap_color_depth
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
main: {
    .label __40 = $13
    .label color = 5
    .label x = 3
    // memcpy_in_vram(1, (char*)0xF000, VERA_INC_1, 0, (char*)0xF800, VERA_INC_1, 256*8)
  // Before we configure the bitmap pane into vera  memory we need to re-arrange a few things!
  // It is better to load all in bank 0, but then there is an issue.
  // So the default CX16 character set is located in bank 0, at address 0xF800.
  // So we need to move this character set to bank 1, suggested is at address 0xF000.
  // The CX16 by default writes textual output to layer 1 in text mode, so we need to
  // realign the moved character set to 0xf000 as the new tile base for layer 1.
  // We also will need to realign for layer 1 the map base from 0x00000 to 0x14000.
  // This is now all easily done with a few statements in the new kickc vera lib ...
    lda #<$100*8
    sta.z memcpy_in_vram.num
    lda #>$100*8
    sta.z memcpy_in_vram.num+1
    ldy #1
    lda #<$f000
    sta.z memcpy_in_vram.dest
    lda #>$f000
    sta.z memcpy_in_vram.dest+1
    lda #<$f800
    sta.z memcpy_in_vram.src
    lda #>$f800
    sta.z memcpy_in_vram.src+1
    jsr memcpy_in_vram
    // vera_layer_mode_tile(1, 0x14000, 0x1F000, 128, 64, 8, 8, 1)
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
    lda #1
    sta.z vera_layer_mode_tile.layer
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    jsr vera_layer_mode_tile
    // vera_layer_mode_bitmap(0, (dword)0x00000, 320, 8)
    jsr vera_layer_mode_bitmap
    // screenlayer(1)
    jsr screenlayer
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
    // gotoxy(0,25)
    ldx #$19
    jsr gotoxy
    // printf("vera in bitmap mode,\n")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("color depth 8 bits per pixel.\n")
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("in this mode, it is possible to display\n")
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("graphics in 256 colors.\n")
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // bitmap_init(0, 0x00000)
    jsr bitmap_init
    // bitmap_clear()
    jsr bitmap_clear
    // gotoxy(0,29)
    ldx #$1d
    jsr gotoxy
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #YELLOW
    jsr vera_layer_set_textcolor
    // printf("press a key ...")
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
  __b1:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    bne !__b2+
    jmp __b2
  !__b2:
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
    // gotoxy(0,26)
    ldx #$1a
    jsr gotoxy
    // printf("here you see all the colors possible.\n")
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // gotoxy(0,29)
    ldx #$1d
    jsr gotoxy
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #YELLOW
    jsr vera_layer_set_textcolor
    // printf("press a key ...")
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    lda #0
    sta.z color
    sta.z x
    sta.z x+1
  __b3:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b4
    // screenlayer(1)
    jsr screenlayer
    // vera_layer_set_textcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #WHITE
    jsr vera_layer_set_textcolor
    // vera_layer_set_backcolor(conio_screen_layer, color)
    ldx.z conio_screen_layer
    lda #BLUE
    jsr vera_layer_set_backcolor
    // clrscr()
    jsr clrscr
    // }
    rts
  __b4:
    // bitmap_line(x, x, 0, 199, color)
    lda.z x
    sta.z bitmap_line.x1
    lda.z x+1
    sta.z bitmap_line.x1+1
    ldx.z color
    lda #<$c7
    sta.z bitmap_line.y1
    lda #>$c7
    sta.z bitmap_line.y1+1
    lda #<0
    sta.z bitmap_line.y0
    sta.z bitmap_line.y0+1
    jsr bitmap_line
    // color++;
    inc.z color
    // x++;
    inc.z x
    bne !+
    inc.z x+1
  !:
    // if(x>319)
    lda.z x+1
    cmp #>$13f
    bne !+
    lda.z x
    cmp #<$13f
  !:
    bcc __b3
    beq __b3
    lda #<0
    sta.z x
    sta.z x+1
    jmp __b3
  __b2:
    // rand()
    jsr rand
    // rand()
    // modr16u(rand(),320,0)
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    jsr modr16u
    // modr16u(rand(),320,0)
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    lda.z modr16u.return
    sta.z bitmap_line.x0
    lda.z modr16u.return+1
    sta.z bitmap_line.x0+1
    // rand()
    jsr rand
    // rand()
    // modr16u(rand(),320,0)
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    jsr modr16u
    // modr16u(rand(),320,0)
    lda.z modr16u.return
    sta.z modr16u.return_1
    lda.z modr16u.return+1
    sta.z modr16u.return_1+1
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    // rand()
    jsr rand
    // rand()
    // modr16u(rand(),200,0)
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    jsr modr16u
    // modr16u(rand(),200,0)
    lda.z modr16u.return
    sta.z modr16u.return_2
    lda.z modr16u.return+1
    sta.z modr16u.return_2+1
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    // rand()
    jsr rand
    // rand()
    // modr16u(rand(),200,0)
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    jsr modr16u
    // modr16u(rand(),200,0)
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    // rand()
    jsr rand
    // rand()
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    lda #$ff
    and.z __40
    tax
    jsr bitmap_line
    jmp __b1
  .segment Data
    s: .text @"vera in bitmap mode,\n"
    .byte 0
    s1: .text @"color depth 8 bits per pixel.\n"
    .byte 0
    s2: .text @"in this mode, it is possible to display\n"
    .byte 0
    s3: .text @"graphics in 256 colors.\n"
    .byte 0
    s4: .text "press a key ..."
    .byte 0
    s5: .text @"here you see all the colors possible.\n"
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
    .label __2 = $44
    .label __4 = $30
    .label __5 = $36
    .label vera_layer_get_width1_config = $2e
    .label vera_layer_get_width1_return = $44
    .label vera_layer_get_height1_config = $32
    .label vera_layer_get_height1_return = $36
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
// vera_layer_set_textcolor(byte register(X) layer, byte register(A) color)
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
    .label addr = $44
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
    .label __6 = $30
    .label line_offset = $30
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
// memcpy_in_vram(byte register(Y) dest_bank, void* zp($15) dest, byte* zp($13) src, word zp($17) num)
memcpy_in_vram: {
    .label i = $39
    .label dest = $15
    .label src = $13
    .label num = $17
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
    // dest_increment | dest_bank
    tya
    ora #VERA_INC_1
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
// vera_layer_mode_tile(byte zp(6) layer, dword zp(7) mapbase_address, dword zp($b) tilebase_address, word zp($30) mapwidth, word zp($2e) mapheight, byte zp($f) tilewidth, byte zp($10) tileheight)
vera_layer_mode_tile: {
    .label __1 = $32
    .label __6 = $36
    .label __17 = $34
    .label __18 = $35
    .label mapbase_address = 7
    .label tilebase_address = $b
    .label mapwidth = $30
    .label layer = 6
    .label mapheight = $2e
    .label tilewidth = $f
    .label tileheight = $10
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
    jmp __b5
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
    jmp __b6
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
    jmp __b7
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
    lda #$20
    cmp.z mapheight
    bne !+
    lda.z mapheight+1
    bne !+
    jmp __b16
  !:
    // case 64:
    //             config |= VERA_LAYER_HEIGHT_64;
    //             break;
    lda #$40
    cmp.z mapheight
    bne !+
    lda.z mapheight+1
    bne !+
    jmp __b13
  !:
    // case 128:
    //             config |= VERA_LAYER_HEIGHT_128;
    //             break;
    lda #$80
    cmp.z mapheight
    bne !+
    lda.z mapheight+1
    bne !+
    jmp __b14
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
// Set a vera layer in bitmap mode and configure the:
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
vera_layer_mode_bitmap: {
    .const layer = 0
    .const bitmap_address = 0
    // config
    .const config = VERA_LAYER_COLOR_DEPTH_8BPP|VERA_LAYER_CONFIG_MODE_BITMAP
    .const tilebase = 0
    // vera_tilebase_offset[layer] = WORD0(bitmap_address)
    // tilebase
    lda #<0
    sta vera_tilebase_offset
    sta vera_tilebase_offset+1
    // vera_tilebase_bank[layer] = BYTE2(bitmap_address)
    sta vera_tilebase_bank
    // vera_tilebase_address[layer] = bitmap_address
    lda #<bitmap_address
    sta vera_tilebase_address
    lda #>bitmap_address
    sta vera_tilebase_address+1
    lda #<bitmap_address>>$10
    sta vera_tilebase_address+2
    lda #>bitmap_address>>$10
    sta vera_tilebase_address+3
    // *VERA_DC_HSCALE = 64
    lda #$40
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 64
    sta VERA_DC_VSCALE
    // vera_layer_set_config(layer, config)
    ldx #config
    lda #layer
    jsr vera_layer_set_config
    // vera_layer_set_tilebase(layer,tilebase)
    ldx #tilebase
    lda #layer
    jsr vera_layer_set_tilebase
    // }
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $38
    .label line_text = $13
    .label color = $38
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
// Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .const layer = 0
    .const address = 0
    .label __7 = $39
    .label __10 = $42
    .label __13 = $4c
    .label __23 = $3b
    .label __24 = $46
    .label __25 = $4e
    .label __26 = $56
    .label __28 = $66
    .label vera_layer_get_color_depth1_config = $6a
    .label bitmask = $38
    .label x = $15
    .label hdelta = $64
    .label yoffs = $5a
    .label y = $17
    .label __29 = $3b
    .label __30 = $3e
    .label __31 = $40
    .label __32 = $46
    .label __33 = $48
    .label __34 = $4a
    .label __35 = $4e
    .label __36 = $50
    .label __37 = $54
    .label __38 = $56
    .label __39 = $58
    .label __40 = $5e
    .label __41 = $66
    // __bitmap_address = address
    lda #<address
    sta.z __bitmap_address
    lda #>address
    sta.z __bitmap_address+1
    lda #<address>>$10
    sta.z __bitmap_address+2
    lda #>address>>$10
    sta.z __bitmap_address+3
    // __bitmap_layer = layer
    lda #layer
    sta.z __bitmap_layer
    // vera_layer_get_color_depth(__bitmap_layer)
    // byte* config = vera_layer_config[layer]
    asl
    tay
    lda vera_layer_config,y
    sta.z vera_layer_get_color_depth1_config
    lda vera_layer_config+1,y
    sta.z vera_layer_get_color_depth1_config+1
    // *config & VERA_LAYER_COLOR_DEPTH_MASK
    lda #VERA_LAYER_COLOR_DEPTH_MASK
    ldy #0
    and (vera_layer_get_color_depth1_config),y
    // return (*config & VERA_LAYER_COLOR_DEPTH_MASK);
    // }
    // vera_layer_get_color_depth(__bitmap_layer)
    // __bitmap_color_depth = vera_layer_get_color_depth(__bitmap_layer)
    sta.z __bitmap_color_depth
    // vera_display_get_hscale()
    jsr vera_display_get_hscale
    // vera_display_get_hscale()
    // __bitmap_hscale = vera_display_get_hscale()
    stx.z __bitmap_hscale
    // vera_display_get_vscale()
    jsr vera_display_get_vscale
    // vera_display_get_vscale()
    // __bitmap_vscale = vera_display_get_vscale()
    // Returns 1 when 640 and 2 when 320.
    stx.z __bitmap_vscale
    // byte bitmask = bitmasks[__bitmap_color_depth]
    // Returns 1 when 480 and 2 when 240.
    ldy.z __bitmap_color_depth
    lda bitmasks,y
    sta.z bitmask
    // signed byte bitshift = bitshifts[__bitmap_color_depth]
    ldx bitshifts,y
    lda #<0
    sta.z x
    sta.z x+1
  __b1:
    // if(__bitmap_color_depth==0)
    lda.z __bitmap_color_depth
    bne __b2
    // x >> 3
    lda.z x+1
    lsr
    sta.z __7+1
    lda.z x
    ror
    sta.z __7
    lsr.z __7+1
    ror.z __7
    lsr.z __7+1
    ror.z __7
    // __bitmap_plot_x[x] = (x >> 3)
    lda.z x
    asl
    sta.z __23
    lda.z x+1
    rol
    sta.z __23+1
    clc
    lda.z __29
    adc #<__bitmap_plot_x
    sta.z __29
    lda.z __29+1
    adc #>__bitmap_plot_x
    sta.z __29+1
    ldy #0
    lda.z __7
    sta (__29),y
    iny
    lda.z __7+1
    sta (__29),y
    // __bitmap_plot_bitmask[x] = bitmask
    clc
    lda.z x
    adc #<__bitmap_plot_bitmask
    sta.z __30
    lda.z x+1
    adc #>__bitmap_plot_bitmask
    sta.z __30+1
    lda.z bitmask
    ldy #0
    sta (__30),y
    // __bitmap_plot_bitshift[x] = (byte)bitshift
    clc
    lda.z x
    adc #<__bitmap_plot_bitshift
    sta.z __31
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __31+1
    txa
    sta (__31),y
    // bitshift -= 1
    dex
    // bitmask >>= 1
    lsr.z bitmask
  __b2:
    // if(__bitmap_color_depth==1)
    lda #1
    cmp.z __bitmap_color_depth
    bne __b3
    // x >> 2
    lda.z x+1
    lsr
    sta.z __10+1
    lda.z x
    ror
    sta.z __10
    lsr.z __10+1
    ror.z __10
    // __bitmap_plot_x[x] = (x >> 2)
    lda.z x
    asl
    sta.z __24
    lda.z x+1
    rol
    sta.z __24+1
    clc
    lda.z __32
    adc #<__bitmap_plot_x
    sta.z __32
    lda.z __32+1
    adc #>__bitmap_plot_x
    sta.z __32+1
    ldy #0
    lda.z __10
    sta (__32),y
    iny
    lda.z __10+1
    sta (__32),y
    // __bitmap_plot_bitmask[x] = bitmask
    clc
    lda.z x
    adc #<__bitmap_plot_bitmask
    sta.z __33
    lda.z x+1
    adc #>__bitmap_plot_bitmask
    sta.z __33+1
    lda.z bitmask
    ldy #0
    sta (__33),y
    // __bitmap_plot_bitshift[x] = (byte)bitshift
    clc
    lda.z x
    adc #<__bitmap_plot_bitshift
    sta.z __34
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __34+1
    txa
    sta (__34),y
    // bitshift -= 2
    dex
    dex
    // bitmask >>= 2
    lda.z bitmask
    lsr
    lsr
    sta.z bitmask
  __b3:
    // if(__bitmap_color_depth==2)
    lda #2
    cmp.z __bitmap_color_depth
    bne __b4
    // x >> 1
    lda.z x+1
    lsr
    sta.z __13+1
    lda.z x
    ror
    sta.z __13
    // __bitmap_plot_x[x] = (x >> 1)
    lda.z x
    asl
    sta.z __25
    lda.z x+1
    rol
    sta.z __25+1
    clc
    lda.z __35
    adc #<__bitmap_plot_x
    sta.z __35
    lda.z __35+1
    adc #>__bitmap_plot_x
    sta.z __35+1
    ldy #0
    lda.z __13
    sta (__35),y
    iny
    lda.z __13+1
    sta (__35),y
    // __bitmap_plot_bitmask[x] = bitmask
    clc
    lda.z x
    adc #<__bitmap_plot_bitmask
    sta.z __36
    lda.z x+1
    adc #>__bitmap_plot_bitmask
    sta.z __36+1
    lda.z bitmask
    ldy #0
    sta (__36),y
    // __bitmap_plot_bitshift[x] = (byte)bitshift
    clc
    lda.z x
    adc #<__bitmap_plot_bitshift
    sta.z __37
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __37+1
    txa
    sta (__37),y
    // bitshift -= 4
    txa
    sec
    sbc #4
    tax
    // bitmask >>= 4
    lda.z bitmask
    lsr
    lsr
    lsr
    lsr
    sta.z bitmask
  __b4:
    // if(__bitmap_color_depth==3)
    lda #3
    cmp.z __bitmap_color_depth
    bne __b5
    // __bitmap_plot_x[x] = x
    lda.z x
    asl
    sta.z __26
    lda.z x+1
    rol
    sta.z __26+1
    clc
    lda.z __38
    adc #<__bitmap_plot_x
    sta.z __38
    lda.z __38+1
    adc #>__bitmap_plot_x
    sta.z __38+1
    ldy #0
    lda.z x
    sta (__38),y
    iny
    lda.z x+1
    sta (__38),y
    // __bitmap_plot_bitmask[x] = bitmask
    clc
    lda.z x
    adc #<__bitmap_plot_bitmask
    sta.z __39
    lda.z x+1
    adc #>__bitmap_plot_bitmask
    sta.z __39+1
    lda.z bitmask
    ldy #0
    sta (__39),y
    // __bitmap_plot_bitshift[x] = (byte)bitshift
    clc
    lda.z x
    adc #<__bitmap_plot_bitshift
    sta.z __40
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __40+1
    txa
    sta (__40),y
  __b5:
    // if(bitshift<0)
    cpx #0
    bpl __b6
    // bitshift = bitshifts[__bitmap_color_depth]
    ldy.z __bitmap_color_depth
    ldx bitshifts,y
  __b6:
    // if(bitmask==0)
    lda.z bitmask
    bne __b7
    // bitmask = bitmasks[__bitmap_color_depth]
    ldy.z __bitmap_color_depth
    lda bitmasks,y
    sta.z bitmask
  __b7:
    // for(word x : 0..639)
    inc.z x
    bne !+
    inc.z x+1
  !:
    lda.z x+1
    cmp #>$280
    beq !__b1+
    jmp __b1
  !__b1:
    lda.z x
    cmp #<$280
    beq !__b1+
    jmp __b1
  !__b1:
    // __bitmap_color_depth<<2
    lda.z __bitmap_color_depth
    asl
    asl
    // (__bitmap_color_depth<<2)+__bitmap_hscale
    clc
    adc.z __bitmap_hscale
    // word hdelta = hdeltas[(__bitmap_color_depth<<2)+__bitmap_hscale]
    asl
    // This sets the right delta to skip a whole line based on the scale, depending on the color depth.
    tay
    lda hdeltas,y
    sta.z hdelta
    lda hdeltas+1,y
    sta.z hdelta+1
    // dword yoffs = __bitmap_address
    // We start at the bitmap address; The plot_y contains the bitmap address embedded so we know where a line starts.
    lda.z __bitmap_address
    sta.z yoffs
    lda.z __bitmap_address+1
    sta.z yoffs+1
    lda.z __bitmap_address+2
    sta.z yoffs+2
    lda.z __bitmap_address+3
    sta.z yoffs+3
    lda #<0
    sta.z y
    sta.z y+1
  __b15:
    // __bitmap_plot_y[y] = yoffs
    lda.z y
    asl
    sta.z __28
    lda.z y+1
    rol
    sta.z __28+1
    asl.z __28
    rol.z __28+1
    clc
    lda.z __41
    adc #<__bitmap_plot_y
    sta.z __41
    lda.z __41+1
    adc #>__bitmap_plot_y
    sta.z __41+1
    ldy #0
    lda.z yoffs
    sta (__41),y
    iny
    lda.z yoffs+1
    sta (__41),y
    iny
    lda.z yoffs+2
    sta (__41),y
    iny
    lda.z yoffs+3
    sta (__41),y
    // yoffs = yoffs + hdelta
    lda.z yoffs
    clc
    adc.z hdelta
    sta.z yoffs
    lda.z yoffs+1
    adc.z hdelta+1
    sta.z yoffs+1
    lda.z yoffs+2
    adc #0
    sta.z yoffs+2
    lda.z yoffs+3
    adc #0
    sta.z yoffs+3
    // for(word y : 0..479)
    inc.z y
    bne !+
    inc.z y+1
  !:
    lda.z y+1
    cmp #>$1e0
    bne __b15
    lda.z y
    cmp #<$1e0
    bne __b15
    // }
    rts
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label vdelta = $39
    .label hdelta = $15
    .label count = $5a
    .label vdest = $3b
    // word vdelta = vdeltas[__bitmap_vscale]
    lda.z __bitmap_vscale
    asl
    tay
    lda vdeltas,y
    sta.z vdelta
    lda vdeltas+1,y
    sta.z vdelta+1
    // __bitmap_color_depth<<2
    lda.z __bitmap_color_depth
    asl
    asl
    // (__bitmap_color_depth<<2)+__bitmap_hscale
    clc
    adc.z __bitmap_hscale
    // word hdelta = hdeltas[(__bitmap_color_depth<<2)+__bitmap_hscale]
    asl
    tay
    lda hdeltas,y
    sta.z hdelta
    lda hdeltas+1,y
    sta.z hdelta+1
    // mul16u(hdelta,vdelta)
    jsr mul16u
    // dword count = mul16u(hdelta,vdelta)
    // char vbank = BYTE2(__bitmap_address)
    ldx.z __bitmap_address+2
    // WORD0(__bitmap_address)
    lda.z __bitmap_address
    sta.z vdest
    lda.z __bitmap_address+1
    sta.z vdest+1
    // memset_vram(vbank, vdest, 0, count)
    jsr memset_vram
    // }
    rts
}
// Return true if there's a key waiting, return false if not
kbhit: {
    .label chptr = ch
    .label IN_DEV = $28a
    // Current input device number
    .label GETIN = $ffe4
    .label ch = $3d
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
// Draw a line on the bitmap
// bitmap_line(word zp(3) x0, word zp($39) x1, word zp($3b) y0, word zp($15) y1, byte register(X) c)
bitmap_line: {
    .label xd = $17
    .label yd = $6a
    .label yd_1 = $3e
    .label x0 = 3
    .label x1 = $39
    .label y0 = $3b
    .label y1 = $15
    // if(x0<x1)
    lda.z x0+1
    cmp.z x1+1
    bcs !__b1+
    jmp __b1
  !__b1:
    bne !+
    lda.z x0
    cmp.z x1
    bcs !__b1+
    jmp __b1
  !__b1:
  !:
    // xd = x0-x1
    lda.z x0
    sec
    sbc.z x1
    sta.z xd
    lda.z x0+1
    sbc.z x1+1
    sta.z xd+1
    // if(y0<y1)
    lda.z y0+1
    cmp.z y1+1
    bcc __b7
    bne !+
    lda.z y0
    cmp.z y1
    bcc __b7
  !:
    // yd = y0-y1
    lda.z y0
    sec
    sbc.z y1
    sta.z yd_1
    lda.z y0+1
    sbc.z y1+1
    sta.z yd_1+1
    // if(yd<xd)
    cmp.z xd+1
    bcc __b8
    bne !+
    lda.z yd_1
    cmp.z xd
    bcc __b8
  !:
    // bitmap_line_ydxi(y1, x1, y0, yd, xd, c)
    lda.z y1
    sta.z bitmap_line_ydxi.y
    lda.z y1+1
    sta.z bitmap_line_ydxi.y+1
    stx.z bitmap_line_ydxi.c
    jsr bitmap_line_ydxi
    // }
    rts
  __b8:
    // bitmap_line_xdyi(x1, y1, x0, xd, yd, c)
    lda.z x1
    sta.z bitmap_line_xdyi.x
    lda.z x1+1
    sta.z bitmap_line_xdyi.x+1
    lda.z y1
    sta.z bitmap_line_xdyi.y
    lda.z y1+1
    sta.z bitmap_line_xdyi.y+1
    lda.z x0
    sta.z bitmap_line_xdyi.x1
    lda.z x0+1
    sta.z bitmap_line_xdyi.x1+1
    stx.z bitmap_line_xdyi.c
    jsr bitmap_line_xdyi
    rts
  __b7:
    // yd = y1-y0
    lda.z y1
    sec
    sbc.z y0
    sta.z yd
    lda.z y1+1
    sbc.z y0+1
    sta.z yd+1
    // if(yd<xd)
    cmp.z xd+1
    bcc __b9
    bne !+
    lda.z yd
    cmp.z xd
    bcc __b9
  !:
    // bitmap_line_ydxd(y0, x0, y1, yd, xd, c)
    lda.z y0
    sta.z bitmap_line_ydxd.y
    lda.z y0+1
    sta.z bitmap_line_ydxd.y+1
    lda.z x0
    sta.z bitmap_line_ydxd.x
    lda.z x0+1
    sta.z bitmap_line_ydxd.x+1
    lda.z y1
    sta.z bitmap_line_ydxd.y1
    lda.z y1+1
    sta.z bitmap_line_ydxd.y1+1
    stx.z bitmap_line_ydxd.c
    jsr bitmap_line_ydxd
    rts
  __b9:
    // bitmap_line_xdyd(x1, y1, x0, xd, yd, c)
    lda.z x1
    sta.z bitmap_line_xdyd.x
    lda.z x1+1
    sta.z bitmap_line_xdyd.x+1
    lda.z y1
    sta.z bitmap_line_xdyd.y
    lda.z y1+1
    sta.z bitmap_line_xdyd.y+1
    lda.z x0
    sta.z bitmap_line_xdyd.x1
    lda.z x0+1
    sta.z bitmap_line_xdyd.x1+1
    stx.z bitmap_line_xdyd.c
    jsr bitmap_line_xdyd
    rts
  __b1:
    // xd = x1-x0
    lda.z x1
    sec
    sbc.z x0
    sta.z xd
    lda.z x1+1
    sbc.z x0+1
    sta.z xd+1
    // if(y0<y1)
    lda.z y0+1
    cmp.z y1+1
    bcc __b11
    bne !+
    lda.z y0
    cmp.z y1
    bcc __b11
  !:
    // yd = y0-y1
    lda.z y0
    sec
    sbc.z y1
    sta.z yd
    lda.z y0+1
    sbc.z y1+1
    sta.z yd+1
    // if(yd<xd)
    cmp.z xd+1
    bcc __b12
    bne !+
    lda.z yd
    cmp.z xd
    bcc __b12
  !:
    // bitmap_line_ydxd(y1, x1, y0, yd, xd, c)
    lda.z y1
    sta.z bitmap_line_ydxd.y
    lda.z y1+1
    sta.z bitmap_line_ydxd.y+1
    stx.z bitmap_line_ydxd.c
    jsr bitmap_line_ydxd
    rts
  __b12:
    // bitmap_line_xdyd(x0, y0, x1, xd, yd, c)
    lda.z x0
    sta.z bitmap_line_xdyd.x
    lda.z x0+1
    sta.z bitmap_line_xdyd.x+1
    stx.z bitmap_line_xdyd.c
    jsr bitmap_line_xdyd
    rts
  __b11:
    // yd = y1-y0
    lda.z y1
    sec
    sbc.z y0
    sta.z yd_1
    lda.z y1+1
    sbc.z y0+1
    sta.z yd_1+1
    // if(yd<xd)
    cmp.z xd+1
    bcc __b13
    bne !+
    lda.z yd_1
    cmp.z xd
    bcc __b13
  !:
    // bitmap_line_ydxi(y0, x0, y1, yd, xd, c)
    lda.z y0
    sta.z bitmap_line_ydxi.y
    lda.z y0+1
    sta.z bitmap_line_ydxi.y+1
    lda.z x0
    sta.z bitmap_line_ydxi.x
    lda.z x0+1
    sta.z bitmap_line_ydxi.x+1
    lda.z y1
    sta.z bitmap_line_ydxi.y1
    lda.z y1+1
    sta.z bitmap_line_ydxi.y1+1
    stx.z bitmap_line_ydxi.c
    jsr bitmap_line_ydxi
    rts
  __b13:
    // bitmap_line_xdyi(x0, y0, x1, xd, yd, c)
    lda.z x0
    sta.z bitmap_line_xdyi.x
    lda.z x0+1
    sta.z bitmap_line_xdyi.x+1
    stx.z bitmap_line_xdyi.c
    jsr bitmap_line_xdyi
    rts
}
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $3e
    .label __1 = $40
    .label __2 = $42
    .label return = $13
    // rand_state << 7
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    lda.z rand_state
    eor.z __0
    sta.z rand_state
    lda.z rand_state+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    lda.z rand_state
    eor.z __2
    sta.z rand_state
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state+1
    // return rand_state;
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // }
    rts
}
// Performs modulo on two 16 bit unsigned ints and an initial remainder
// Returns the remainder.
// Implemented using simple binary division
// modr16u(word zp($13) dividend, word zp($17) divisor)
modr16u: {
    .label return = $15
    .label dividend = $13
    .label return_1 = $39
    .label return_2 = $3b
    .label divisor = $17
    // divr16u(dividend, divisor, rem)
    jsr divr16u
    // return rem16u;
    lda.z rem16u
    sta.z return
    lda.z rem16u+1
    sta.z return+1
    // }
    rts
}
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
vera_layer_set_text_color_mode: {
    .label addr = $44
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
    .label return = $30
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
    .label return = $30
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
    .label addr = $44
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
    .label addr = $44
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
// cputc(byte zp($38) c)
cputc: {
    .label __16 = $48
    .label conio_addr = $46
    .label c = $38
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
vera_display_get_hscale: {
    .const scale = 0
    ldx #1
  __b1:
    // if(*VERA_DC_HSCALE==hscale[s])
    lda hscale,x
    cmp VERA_DC_HSCALE
    bne __b2
    rts
  __b2:
    // for(byte s:1..3)
    inx
    cpx #4
    bne __b1
    ldx #scale
    // }
    rts
  .segment Data
    hscale: .byte 0, $80, $40, $20
}
.segment Code
vera_display_get_vscale: {
    .const scale = 0
    ldx #1
  __b1:
    // if(*VERA_DC_VSCALE==vscale[s])
    lda vscale,x
    cmp VERA_DC_VSCALE
    bne __b2
    rts
  __b2:
    // for(byte s:1..3)
    inx
    cpx #4
    bne __b1
    ldx #scale
    // }
    rts
  .segment Data
    vscale: .byte 0, $80, $40, $20
}
.segment Code
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// mul16u(word zp($15) a, word zp($39) b)
mul16u: {
    .label a = $15
    .label b = $39
    .label return = $5a
    .label mb = $60
    .label res = $5a
    // unsigned long mb = b
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
  __b1:
    // while(a!=0)
    lda.z a
    ora.z a+1
    bne __b2
    // }
    rts
  __b2:
    // a&1
    lda #1
    and.z a
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
  __b3:
    // a = a>>1
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp __b1
}
// Set block of memory to a value in VRAM.
// Sets num bytes to a value to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - data: The value to set the vram with.
// - num: The number of bytes to set
// memset_vram(byte register(X) vbank, void* zp($3b) vdest, dword zp($5a) num)
memset_vram: {
    .const data = 0
    .label i = $60
    .label vdest = $3b
    .label num = $5a
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
    // VERA_INC_1 | vbank
    txa
    ora #VERA_INC_1
    // *VERA_ADDRX_H = VERA_INC_1 | vbank
    sta VERA_ADDRX_H
    lda #<0
    sta.z i
    sta.z i+1
    lda #<0>>$10
    sta.z i+2
    lda #>0>>$10
    sta.z i+3
  // Transfer the data
  __b1:
    // for(unsigned long i = 0; i<num; i++)
    lda.z i+3
    cmp.z num+3
    bcc __b2
    bne !+
    lda.z i+2
    cmp.z num+2
    bcc __b2
    bne !+
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
    // *VERA_DATA0 = data
    lda #data
    sta VERA_DATA0
    // for(unsigned long i = 0; i<num; i++)
    inc.z i
    bne !+
    inc.z i+1
    bne !+
    inc.z i+2
    bne !+
    inc.z i+3
  !:
    jmp __b1
}
// bitmap_line_ydxi(word zp($40) y, word zp($39) x, word zp($3b) y1, word zp($3e) yd, word zp($17) xd, byte zp($38) c)
bitmap_line_ydxi: {
    .label __6 = $4a
    .label y = $40
    .label x = $39
    .label y1 = $3b
    .label yd = $3e
    .label xd = $17
    .label c = $38
    .label e = $46
    // word e = xd>>1
    lda.z xd+1
    lsr
    sta.z e+1
    lda.z xd
    ror
    sta.z e
  __b1:
    // bitmap_plot(x,y,c)
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    ldx.z c
    jsr bitmap_plot
    // y++;
    inc.z y
    bne !+
    inc.z y+1
  !:
    // e = e+xd
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda.z e+1
    adc.z xd+1
    sta.z e+1
    // if(yd<e)
    cmp.z yd+1
    bne !+
    lda.z e
    cmp.z yd
    beq __b2
  !:
    bcc __b2
    // x++;
    inc.z x
    bne !+
    inc.z x+1
  !:
    // e = e - yd
    lda.z e
    sec
    sbc.z yd
    sta.z e
    lda.z e+1
    sbc.z yd+1
    sta.z e+1
  __b2:
    // y1+1
    clc
    lda.z y1
    adc #1
    sta.z __6
    lda.z y1+1
    adc #0
    sta.z __6+1
    // while (y!=(y1+1))
    lda.z y+1
    cmp.z __6+1
    bne __b1
    lda.z y
    cmp.z __6
    bne __b1
    // }
    rts
}
// bitmap_line_xdyi(word zp($42) x, word zp($3b) y, word zp($39) x1, word zp($17) xd, word zp($3e) yd, byte zp($38) c)
bitmap_line_xdyi: {
    .label __6 = $4c
    .label x = $42
    .label y = $3b
    .label x1 = $39
    .label xd = $17
    .label yd = $3e
    .label c = $38
    .label e = $46
    // word e = yd>>1
    lda.z yd+1
    lsr
    sta.z e+1
    lda.z yd
    ror
    sta.z e
  __b1:
    // bitmap_plot(x,y,c)
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    ldx.z c
    jsr bitmap_plot
    // x++;
    inc.z x
    bne !+
    inc.z x+1
  !:
    // e = e+yd
    lda.z e
    clc
    adc.z yd
    sta.z e
    lda.z e+1
    adc.z yd+1
    sta.z e+1
    // if(xd<e)
    cmp.z xd+1
    bne !+
    lda.z e
    cmp.z xd
    beq __b2
  !:
    bcc __b2
    // y++;
    inc.z y
    bne !+
    inc.z y+1
  !:
    // e = e - xd
    lda.z e
    sec
    sbc.z xd
    sta.z e
    lda.z e+1
    sbc.z xd+1
    sta.z e+1
  __b2:
    // x1+1
    clc
    lda.z x1
    adc #1
    sta.z __6
    lda.z x1+1
    adc #0
    sta.z __6+1
    // while (x!=(x1+1))
    lda.z x+1
    cmp.z __6+1
    bne __b1
    lda.z x
    cmp.z __6
    bne __b1
    // }
    rts
}
// bitmap_line_ydxd(word zp($40) y, word zp($39) x, word zp($3b) y1, word zp($6a) yd, word zp($17) xd, byte zp($38) c)
bitmap_line_ydxd: {
    .label __6 = $4e
    .label y = $40
    .label x = $39
    .label y1 = $3b
    .label yd = $6a
    .label xd = $17
    .label c = $38
    .label e = $46
    // word e = xd>>1
    lda.z xd+1
    lsr
    sta.z e+1
    lda.z xd
    ror
    sta.z e
  __b1:
    // bitmap_plot(x,y,c)
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    ldx.z c
    jsr bitmap_plot
    // y = y++;
    inc.z y
    bne !+
    inc.z y+1
  !:
    // e = e+xd
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda.z e+1
    adc.z xd+1
    sta.z e+1
    // if(yd<e)
    cmp.z yd+1
    bne !+
    lda.z e
    cmp.z yd
    beq __b2
  !:
    bcc __b2
    // x--;
    lda.z x
    bne !+
    dec.z x+1
  !:
    dec.z x
    // e = e - yd
    lda.z e
    sec
    sbc.z yd
    sta.z e
    lda.z e+1
    sbc.z yd+1
    sta.z e+1
  __b2:
    // y1+1
    clc
    lda.z y1
    adc #1
    sta.z __6
    lda.z y1+1
    adc #0
    sta.z __6+1
    // while (y!=(y1+1))
    lda.z y+1
    cmp.z __6+1
    bne __b1
    lda.z y
    cmp.z __6
    bne __b1
    // }
    rts
}
// bitmap_line_xdyd(word zp($42) x, word zp($3b) y, word zp($39) x1, word zp($17) xd, word zp($6a) yd, byte zp($38) c)
bitmap_line_xdyd: {
    .label __6 = $50
    .label x = $42
    .label y = $3b
    .label x1 = $39
    .label xd = $17
    .label yd = $6a
    .label c = $38
    .label e = $46
    // word e = yd>>1
    lda.z yd+1
    lsr
    sta.z e+1
    lda.z yd
    ror
    sta.z e
  __b1:
    // bitmap_plot(x,y,c)
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    ldx.z c
    jsr bitmap_plot
    // x++;
    inc.z x
    bne !+
    inc.z x+1
  !:
    // e = e+yd
    lda.z e
    clc
    adc.z yd
    sta.z e
    lda.z e+1
    adc.z yd+1
    sta.z e+1
    // if(xd<e)
    cmp.z xd+1
    bne !+
    lda.z e
    cmp.z xd
    beq __b2
  !:
    bcc __b2
    // y--;
    lda.z y
    bne !+
    dec.z y+1
  !:
    dec.z y
    // e = e - xd
    lda.z e
    sec
    sbc.z xd
    sta.z e
    lda.z e+1
    sbc.z xd+1
    sta.z e+1
  __b2:
    // x1+1
    clc
    lda.z x1
    adc #1
    sta.z __6
    lda.z x1+1
    adc #0
    sta.z __6+1
    // while (x!=(x1+1))
    lda.z x+1
    cmp.z __6+1
    bne __b1
    lda.z x
    cmp.z __6
    bne __b1
    // }
    rts
}
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp($13) dividend, word zp($17) divisor, word zp($3e) rem)
divr16u: {
    .label rem = $3e
    .label dividend = $13
    .label quotient = $40
    .label return = $40
    .label divisor = $17
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
    sta.z rem
    sta.z rem+1
  __b1:
    // rem = rem << 1
    asl.z rem
    rol.z rem+1
    // BYTE1(dividend)
    lda.z dividend+1
    // BYTE1(dividend) & $80
    and #$80
    // if( (BYTE1(dividend) & $80) != 0 )
    cmp #0
    beq __b2
    // rem = rem | 1
    lda #1
    ora.z rem
    sta.z rem
  __b2:
    // dividend = dividend << 1
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    lda.z rem+1
    cmp.z divisor+1
    bcc __b3
    bne !+
    lda.z rem
    cmp.z divisor
    bcc __b3
  !:
    // quotient++;
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    lda.z rem
    sec
    sbc.z divisor
    sta.z rem
    lda.z rem+1
    sbc.z divisor+1
    sta.z rem+1
  __b3:
    // for( char i : 0..15)
    inx
    cpx #$10
    bne __b1
    // rem16u = rem
    lda.z rem
    sta.z rem16u
    lda.z rem+1
    sta.z rem16u+1
    // }
    rts
}
// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_color(byte register(X) layer)
vera_layer_get_color: {
    .label addr = $54
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
    .label temp = $56
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
// bitmap_plot(word zp($42) x, word zp($40) y, byte register(X) c)
bitmap_plot: {
    .label __9 = $58
    .label __10 = $5e
    .label plot_x = $5a
    .label plot_y = $60
    .label vera_vram_address01_bankaddr = $5a
    .label x = $42
    .label y = $40
    .label __12 = $58
    .label __13 = $5e
    .label __14 = $64
    .label __15 = $66
    // dword plot_x = __bitmap_plot_x[x]
    lda.z x
    asl
    sta.z __9
    lda.z x+1
    rol
    sta.z __9+1
    clc
    lda.z __12
    adc #<__bitmap_plot_x
    sta.z __12
    lda.z __12+1
    adc #>__bitmap_plot_x
    sta.z __12+1
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    ldy #0
    sty.z plot_x+2
    sty.z plot_x+3
    lda (__12),y
    sta.z plot_x
    iny
    lda (__12),y
    sta.z plot_x+1
    // dword plot_y = __bitmap_plot_y[y]
    lda.z y
    asl
    sta.z __10
    lda.z y+1
    rol
    sta.z __10+1
    asl.z __10
    rol.z __10+1
    clc
    lda.z __13
    adc #<__bitmap_plot_y
    sta.z __13
    lda.z __13+1
    adc #>__bitmap_plot_y
    sta.z __13+1
    ldy #0
    lda (__13),y
    sta.z plot_y
    iny
    lda (__13),y
    sta.z plot_y+1
    iny
    lda (__13),y
    sta.z plot_y+2
    iny
    lda (__13),y
    sta.z plot_y+3
    // dword plotter = plot_x+plot_y
    lda.z vera_vram_address01_bankaddr
    clc
    adc.z plot_y
    sta.z vera_vram_address01_bankaddr
    lda.z vera_vram_address01_bankaddr+1
    adc.z plot_y+1
    sta.z vera_vram_address01_bankaddr+1
    lda.z vera_vram_address01_bankaddr+2
    adc.z plot_y+2
    sta.z vera_vram_address01_bankaddr+2
    lda.z vera_vram_address01_bankaddr+3
    adc.z plot_y+3
    sta.z vera_vram_address01_bankaddr+3
    // byte bitshift = __bitmap_plot_bitshift[x]
    clc
    lda.z x
    adc #<__bitmap_plot_bitshift
    sta.z __14
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __14+1
    ldy #0
    lda (__14),y
    // bitshift?c<<(bitshift):c
    cmp #0
    bne __b1
    jmp __b2
  __b1:
    tay
    txa
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    tax
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(bankaddr)
    lda.z vera_vram_address01_bankaddr
    // *VERA_ADDRX_L = BYTE0(bankaddr)
    sta VERA_ADDRX_L
    // BYTE1(bankaddr)
    lda.z vera_vram_address01_bankaddr+1
    // *VERA_ADDRX_M = BYTE1(bankaddr)
    sta VERA_ADDRX_M
    // BYTE2(bankaddr) | incr
    lda.z vera_vram_address01_bankaddr+2
    // *VERA_ADDRX_H = BYTE2(bankaddr) | incr
    sta VERA_ADDRX_H
    // ~__bitmap_plot_bitmask[x]
    clc
    lda.z x
    adc #<__bitmap_plot_bitmask
    sta.z __15
    lda.z x+1
    adc #>__bitmap_plot_bitmask
    sta.z __15+1
    ldy #0
    lda (__15),y
    eor #$ff
    // *VERA_DATA0 & ~__bitmap_plot_bitmask[x]
    and VERA_DATA0
    // (*VERA_DATA0 & ~__bitmap_plot_bitmask[x]) | c
    stx.z $ff
    ora.z $ff
    // *VERA_DATA0 = (*VERA_DATA0 & ~__bitmap_plot_bitmask[x]) | c
    sta VERA_DATA0
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
    .label cy = $68
    .label width = $69
    .label line = $15
    .label start = $15
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
    tay
    jsr memcpy_in_vram
    // for(unsigned byte i=1; i<=cy; i++)
    inx
    jmp __b1
}
clearline: {
    .label addr = $6a
    .label c = $42
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
  // Tables for the plotter - initialized by calling bitmap_draw_init();
  __bitmap_plot_x: .fill 2*$280, 0
  __bitmap_plot_y: .fill 4*$1e0, 0
  __bitmap_plot_bitmask: .fill $280, 0
  __bitmap_plot_bitshift: .fill $280, 0
  hdeltas: .word 0, $50, $28, $14, 0, $a0, $50, $28, 0, $140, $a0, $50, 0, $280, $140, $a0
  vdeltas: .word 0, $1e0, $f0, $a0
  bitmasks: .byte $80, $c0, $f0, $ff
  .fill 1, 0
  bitshifts: .byte 7, 6, 4, 0
  .fill 1, 0
