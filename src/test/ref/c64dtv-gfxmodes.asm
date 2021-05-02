// Exploring C64DTV Screen Modes
// C64 DTV version 2 Registers and Constants
//
// Sources
// (J) https://www.c64-wiki.com/wiki/C64DTV_Programming_Guide
// (H) http://dtvhacking.cbm8bit.com/dtv_wiki/images/d/d9/Dtv_registers_full.txt
  // Commodore 64 PRG executable file
.file [name="c64dtv-gfxmodes.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const VICII_ECM = $40
  .const VICII_BMM = $20
  .const VICII_DEN = $10
  .const VICII_RSEL = 8
  .const VICII_MCM = $10
  .const VICII_CSEL = 8
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  // RAM in 0xA000, 0xE000 CHAR ROM in 0xD000
  .const PROCPORT_RAM_CHARROM = 1
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const GREEN = 5
  .const BLUE = 6
  .const LIGHT_GREEN = $d
  .const DTV_FEATURE_ENABLE = 1
  .const DTV_LINEAR = 1
  .const DTV_BORDER_OFF = 2
  .const DTV_HIGHCOLOR = 4
  .const DTV_OVERSCAN = 8
  .const DTV_COLORRAM_OFF = $10
  .const DTV_CHUNKY = $40
  .const DTV_COLOR_BANK_DEFAULT = $1d800
  .const KEY_3 = 8
  .const KEY_A = $a
  .const KEY_4 = $b
  .const KEY_E = $e
  .const KEY_D = $12
  .const KEY_6 = $13
  .const KEY_C = $14
  .const KEY_7 = $18
  .const KEY_8 = $1b
  .const KEY_B = $1c
  .const KEY_H = $1d
  .const KEY_U = $1e
  .const KEY_0 = $23
  .const KEY_O = $26
  .const KEY_L = $2a
  .const KEY_1 = $38
  .const KEY_2 = $3b
  .const KEY_SPACE = $3c
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  .label RASTER = $d012
  .label BORDER_COLOR = $d020
  .label BG_COLOR = $d021
  .label BG_COLOR1 = $d022
  .label BG_COLOR2 = $d023
  .label BG_COLOR3 = $d024
  .label VICII_CONTROL1 = $d011
  .label VICII_CONTROL2 = $d016
  .label VICII_MEMORY = $d018
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // Color Ram
  .label COLS = $d800
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  // Feature enables or disables the extra C64 DTV features
  .label DTV_FEATURE = $d03f
  // Controls the graphics modes of the C64 DTV
  .label DTV_CONTROL = $d03c
  // Defines colors for the 16 first colors ($00-$0f)
  .label DTV_PALETTE = $d200
  // Linear Graphics Plane A Counter Control
  .label DTV_PLANEA_START_LO = $d03a
  .label DTV_PLANEA_START_MI = $d03b
  .label DTV_PLANEA_START_HI = $d045
  .label DTV_PLANEA_STEP = $d046
  .label DTV_PLANEA_MODULO_LO = $d038
  .label DTV_PLANEA_MODULO_HI = $d039
  // Linear Graphics Plane B Counter Control
  .label DTV_PLANEB_START_LO = $d049
  .label DTV_PLANEB_START_MI = $d04a
  .label DTV_PLANEB_START_HI = $d04b
  .label DTV_PLANEB_STEP = $d04c
  .label DTV_PLANEB_MODULO_LO = $d047
  .label DTV_PLANEB_MODULO_HI = $d048
  // Select memory bank where color data is fetched from (bits 11:0)
  // Memory address of Color RAM is ColorBank*$400
  .label DTV_COLOR_BANK_LO = $d036
  .label DTV_COLOR_BANK_HI = $d037
  // Selects memory bank for normal VIC color mode and lower data for high color modes. (bits 5:0)
  // Memory address of VIC Graphics is GraphicsBank*$10000
  .label DTV_GRAPHICS_VIC_BANK = $d03d
  .label print_char_cursor = 2
  .label print_line_cursor = 9
  // The adddress of the bitmap graphics (used for pixels)
  .label bitmap_gfx = 4
  // The adddress of the bitmap screen (used for colors)
  .label bitmap_screen = $b
.segment Code
main: {
    // asm
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // *DTV_FEATURE = DTV_FEATURE_ENABLE
    // Enable DTV extended modes
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    lda #<0
    sta.z bitmap_screen
    sta.z bitmap_screen+1
    sta.z bitmap_gfx
    sta.z bitmap_gfx+1
  // Enter the menu for ever
  __b2:
    // menu()
    jsr menu
    jmp __b2
}
menu: {
    .label SCREEN = $8000
    .label CHARSET = $9800
    .label c = 2
    // *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000)
    // Charset ROM
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // *DTV_COLOR_BANK_LO = <((word)(DTV_COLOR_BANK_DEFAULT/$400))
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >((word)(DTV_COLOR_BANK_DEFAULT/$400))
    lda #0
    sta DTV_COLOR_BANK_HI
    // *DTV_CONTROL = 0
    // DTV Graphics Mode
    sta DTV_CONTROL
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2
    // *VICII_CONTROL1 = VICII_DEN|VICII_RSEL|3
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_CSEL
    lda #VICII_CSEL
    sta VICII_CONTROL2
    // *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400))
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VICII_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    // DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i]
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    lda #<COLS
    sta.z c
    lda #>COLS
    sta.z c+1
  // Char Colors
  __b2:
    // for(byte* c=COLS;c!=COLS+1000;c++)
    lda.z c+1
    cmp #>COLS+$3e8
    beq !__b3+
    jmp __b3
  !__b3:
    lda.z c
    cmp #<COLS+$3e8
    beq !__b3+
    jmp __b3
  !__b3:
    // *BG_COLOR = 0
    // Screen colors
    lda #0
    sta BG_COLOR
    // *BORDER_COLOR = 0
    sta BORDER_COLOR
    // print_cls()
    jsr print_cls
    // print_str_lines(MENU_TEXT)
    jsr print_str_lines
  __b5:
    // keyboard_key_pressed(KEY_1)
    ldy #KEY_1
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_1)
    // if(keyboard_key_pressed(KEY_1)!=0)
    cmp #0
    beq __b6
    // mode_stdchar()
    jsr mode_stdchar
    // }
    rts
  __b6:
    // keyboard_key_pressed(KEY_2)
    ldy #KEY_2
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_2)
    // if(keyboard_key_pressed(KEY_2)!=0)
    cmp #0
    beq __b7
    // mode_ecmchar()
    jsr mode_ecmchar
    rts
  __b7:
    // keyboard_key_pressed(KEY_3)
    ldy #KEY_3
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_3)
    // if(keyboard_key_pressed(KEY_3)!=0)
    cmp #0
    beq __b8
    // mode_mcchar()
    jsr mode_mcchar
    rts
  __b8:
    // keyboard_key_pressed(KEY_4)
    ldy #KEY_4
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_4)
    // if(keyboard_key_pressed(KEY_4)!=0)
    cmp #0
    beq __b9
    // mode_stdbitmap()
    jsr mode_stdbitmap
    lda #<mode_stdbitmap.SCREEN
    sta.z bitmap_screen
    lda #>mode_stdbitmap.SCREEN
    sta.z bitmap_screen+1
    lda #<mode_stdbitmap.BITMAP
    sta.z bitmap_gfx
    lda #>mode_stdbitmap.BITMAP
    sta.z bitmap_gfx+1
    rts
  __b9:
    // keyboard_key_pressed(KEY_6)
    ldy #KEY_6
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_6)
    // if(keyboard_key_pressed(KEY_6)!=0)
    cmp #0
    beq __b10
    // mode_hicolstdchar()
    jsr mode_hicolstdchar
    rts
  __b10:
    // keyboard_key_pressed(KEY_7)
    ldy #KEY_7
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_7)
    // if(keyboard_key_pressed(KEY_7)!=0)
    cmp #0
    beq __b11
    // mode_hicolecmchar()
    jsr mode_hicolecmchar
    rts
  __b11:
    // keyboard_key_pressed(KEY_8)
    ldy #KEY_8
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_8)
    // if(keyboard_key_pressed(KEY_8)!=0)
    cmp #0
    beq __b12
    // mode_hicolmcchar()
    jsr mode_hicolmcchar
    rts
  __b12:
    // keyboard_key_pressed(KEY_A)
    ldy #KEY_A
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_A)
    // if(keyboard_key_pressed(KEY_A)!=0)
    cmp #0
    beq __b13
    // mode_sixsfred2()
    jsr mode_sixsfred2
    rts
  __b13:
    // keyboard_key_pressed(KEY_B)
    ldy #KEY_B
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_B)
    // if(keyboard_key_pressed(KEY_B)!=0)
    cmp #0
    beq __b14
    // mode_twoplanebitmap()
    jsr mode_twoplanebitmap
    rts
  __b14:
    // keyboard_key_pressed(KEY_C)
    ldy #KEY_C
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_C)
    // if(keyboard_key_pressed(KEY_C)!=0)
    cmp #0
    beq __b15
    // mode_sixsfred()
    jsr mode_sixsfred
    rts
  __b15:
    // keyboard_key_pressed(KEY_D)
    ldy #KEY_D
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_D)
    // if(keyboard_key_pressed(KEY_D)!=0)
    cmp #0
    beq __b16
    // mode_8bpppixelcell()
    jsr mode_8bpppixelcell
    rts
  __b16:
    // keyboard_key_pressed(KEY_E)
    ldy #KEY_E
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_E)
    // if(keyboard_key_pressed(KEY_E)!=0)
    cmp #0
    bne !__b5+
    jmp __b5
  !__b5:
    // mode_8bppchunkybmm()
    jsr mode_8bppchunkybmm
    rts
  __b3:
    // *c=LIGHT_GREEN
    lda #LIGHT_GREEN
    ldy #0
    sta (c),y
    // for(byte* c=COLS;c!=COLS+1000;c++)
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b2
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    ldx #' '
    lda #<menu.SCREEN
    sta.z memset.str
    lda #>menu.SCREEN
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    // }
    rts
}
// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
// print_str_lines(byte* zp($d) str)
print_str_lines: {
    .label str = $d
    lda #<menu.SCREEN
    sta.z print_line_cursor
    lda #>menu.SCREEN
    sta.z print_line_cursor+1
    lda #<menu.SCREEN
    sta.z print_char_cursor
    lda #>menu.SCREEN
    sta.z print_char_cursor+1
    lda #<MENU_TEXT
    sta.z str
    lda #>MENU_TEXT
    sta.z str+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // char ch = *(str++)
    ldy #0
    lda (str),y
    inc.z str
    bne !+
    inc.z str+1
  !:
    // if(ch)
    cmp #0
    beq __b3
    // print_char(ch)
    jsr print_char
  __b3:
    // while (ch)
    cmp #0
    bne __b2
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
// keyboard_key_pressed(byte register(Y) key)
keyboard_key_pressed: {
    .label colidx = $1c
    // char colidx = key&7
    tya
    and #7
    sta.z colidx
    // char rowidx = key>>3
    tya
    lsr
    lsr
    lsr
    // keyboard_matrix_read(rowidx)
    tay
    jsr keyboard_matrix_read
    // keyboard_matrix_read(rowidx) & keyboard_matrix_col_bitmask[colidx]
    ldy.z colidx
    and keyboard_matrix_col_bitmask,y
    // }
    rts
}
// Standard Character Mode (LINEAR/HICOL/CHUNK/COLDIS/ECM/MCM/BMM = 0)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
// Pixel Shifter (1)
// - 0: 4bpp BG_COLORor0[3:0]
// - 1: 4bpp ColorData[3:0]
mode_stdchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $d800
    .label __5 = $18
    // Char Colors and screen chars
    .label col = $d
    .label ch = $f
    .label cy = 6
    // *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000)
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // *DTV_COLOR_BANK_LO = <((word)(DTV_COLOR_BANK_DEFAULT/$400))
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >((word)(DTV_COLOR_BANK_DEFAULT/$400))
    lda #0
    sta DTV_COLOR_BANK_HI
    // *DTV_CONTROL = 0
    sta DTV_CONTROL
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2
    // *VICII_CONTROL1 = VICII_DEN|VICII_RSEL|3
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_CSEL
    lda #VICII_CSEL
    sta VICII_CONTROL2
    // *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400))
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VICII_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    // DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i]
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BG_COLOR = 0
    // Screen colors
    lda #0
    sta BG_COLOR
    // *BORDER_COLOR = 0
    sta BORDER_COLOR
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cx+cy
    txa
    clc
    adc.z cy
    // (cx+cy)&$f
    and #$f
    // *col++ = (cx+cy)&$f
    ldy #0
    sta (col),y
    // *col++ = (cx+cy)&$f;
    inc.z col
    bne !+
    inc.z col+1
  !:
    // cy&$f
    lda #$f
    and.z cy
    // (cy&$f)*$10
    asl
    asl
    asl
    asl
    sta.z __5
    // cx&$f
    txa
    and #$f
    // (cy&$f)*$10|(cx&$f)
    ora.z __5
    // *ch++ = (cy&$f)*$10|(cx&$f)
    ldy #0
    sta (ch),y
    // *ch++ = (cy&$f)*$10|(cx&$f);
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #0
    jsr mode_ctrl
    // }
    rts
}
// Extended Background Color Character Mode (LINEAR/HICOL/CHUNK/COLDIS/MCM/BMM = 0, ECM = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & "00" & CharData[5:0] & RowCounter[2:0] ) 
// GfxData Pixel Shifter (1)
//  - 0: 4bpp Background Color
//    - CharData[7:6] 00: 4bpp BG_COLORor0[3:0]
//    - CharData[7:6] 01: 4bpp BG_COLORor1[3:0]
//    - CharData[7:6] 10: 4bpp BG_COLORor2[3:0]
//    - CharData[7:6] 11: 4bpp BG_COLORor3[3:0]
//  - 1: 4bpp ColorData[3:0]
mode_ecmchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $d800
    .label __5 = $19
    // Char Colors and screen chars
    .label col = $f
    .label ch = $d
    .label cy = 6
    // *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000)
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // *DTV_COLOR_BANK_LO = <((word)(DTV_COLOR_BANK_DEFAULT/$400))
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >((word)(DTV_COLOR_BANK_DEFAULT/$400))
    lda #0
    sta DTV_COLOR_BANK_HI
    // *DTV_CONTROL = 0
    sta DTV_CONTROL
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2
    // *VICII_CONTROL1 = VICII_DEN|VICII_RSEL|VICII_ECM|3
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VICII_DEN|VICII_RSEL|VICII_ECM|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_CSEL
    lda #VICII_CSEL
    sta VICII_CONTROL2
    // *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400))
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VICII_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    // DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i]
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BORDER_COLOR = 0
    // Screen colors
    lda #0
    sta BORDER_COLOR
    // *BG_COLOR = 0
    sta BG_COLOR
    // *BG_COLOR1 = 2
    lda #2
    sta BG_COLOR1
    // *BG_COLOR2 = 5
    lda #5
    sta BG_COLOR2
    // *BG_COLOR3 = 6
    lda #6
    sta BG_COLOR3
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cx+cy
    txa
    clc
    adc.z cy
    // (cx+cy)&$f
    and #$f
    // *col++ = (cx+cy)&$f
    ldy #0
    sta (col),y
    // *col++ = (cx+cy)&$f;
    inc.z col
    bne !+
    inc.z col+1
  !:
    // cy&$f
    lda #$f
    and.z cy
    // (cy&$f)*$10
    asl
    asl
    asl
    asl
    sta.z __5
    // cx&$f
    txa
    and #$f
    // (cy&$f)*$10|(cx&$f)
    ora.z __5
    // *ch++ = (cy&$f)*$10|(cx&$f)
    ldy #0
    sta (ch),y
    // *ch++ = (cy&$f)*$10|(cx&$f);
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #0
    jsr mode_ctrl
    // }
    rts
}
// Multicolor Character Mode (LINEAR/HICOL/CHUNK/COLDIS/BMM/ECM = 0, MCM = 1)
// Resolution: 160x200 (320x200)
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
// GfxData Pixel Shifter (1) if ColorData[3:3] = 0:
//  - 0: 4bpp BG_COLORor0[3:0]
//  - 1: 4bpp ColorData[2:0]
// GfxData Pixel Shifter (2) if ColorData[3:3] = 1:
//  - 00: 4bpp BG_COLORor0[3:0]
//  - 01: 4bpp BG_COLORor1[3:0]
//  - 10: 4bpp BG_COLORor2[3:0]
//  - 11: 4bpp ColorData[2:0]// Standard Character Mode (LINEAR/HICOL/CHUNK/COLDIS/ECM/MCM/BMM = 0)
mode_mcchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $d800
    .label __5 = $1c
    // Char Colors and screen chars
    .label col = $d
    .label ch = $f
    .label cy = 6
    // *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000)
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // *DTV_COLOR_BANK_LO = <((word)(DTV_COLOR_BANK_DEFAULT/$400))
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >((word)(DTV_COLOR_BANK_DEFAULT/$400))
    lda #0
    sta DTV_COLOR_BANK_HI
    // *DTV_CONTROL = 0
    sta DTV_CONTROL
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2
    // *VICII_CONTROL1 = VICII_DEN|VICII_RSEL|3
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_CSEL|VICII_MCM
    lda #VICII_CSEL|VICII_MCM
    sta VICII_CONTROL2
    // *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400))
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VICII_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    // DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i]
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BORDER_COLOR = 0
    // Screen colors
    lda #0
    sta BORDER_COLOR
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // *BG_COLOR1 = GREEN
    lda #GREEN
    sta BG_COLOR1
    // *BG_COLOR2 = BLUE
    lda #BLUE
    sta BG_COLOR2
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cx+cy
    txa
    clc
    adc.z cy
    // (cx+cy)&$f
    and #$f
    // *col++ = (cx+cy)&$f
    ldy #0
    sta (col),y
    // *col++ = (cx+cy)&$f;
    inc.z col
    bne !+
    inc.z col+1
  !:
    // cy&$f
    lda #$f
    and.z cy
    // (cy&$f)*$10
    asl
    asl
    asl
    asl
    sta.z __5
    // cx&$f
    txa
    and #$f
    // (cy&$f)*$10|(cx&$f)
    ora.z __5
    // *ch++ = (cy&$f)*$10|(cx&$f)
    ldy #0
    sta (ch),y
    // *ch++ = (cy&$f)*$10|(cx&$f);
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #0
    jsr mode_ctrl
    // }
    rts
}
// Standard Bitmap Mode (LINEAR/HICOL/CHUNK/COLDIS/MCM/ECM = 0, BMM = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:2] & Matrix[9:0] & RowCounter[2:0] )
// Pixel Shifter (1)
//  - 0: 4bpp CharData[3:0]
//  - 1: 4bpp CharData[7:4]
mode_stdbitmap: {
    .const lines_cnt = 9
    .label SCREEN = $4000
    .label BITMAP = $6000
    .label col2 = $17
    // Bitmap Colors
    .label ch = 4
    .label cy = 6
    .label l = 7
    // *DTV_GRAPHICS_VIC_BANK = (byte)((dword)BITMAP/$10000)
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // *DTV_CONTROL = 0
    sta DTV_CONTROL
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)BITMAP/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^BITMAP/$4000
    sta CIA2
    // *VICII_CONTROL1 = VICII_BMM|VICII_DEN|VICII_RSEL|3
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_CSEL
    lda #VICII_CSEL
    sta VICII_CONTROL2
    // *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)BITMAP&$3fff)/$400))
    // VIC Memory Pointers
    lda #(BITMAP&$3fff)/$400
    sta VICII_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    // DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i]
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BG_COLOR = BLACK
    // Screen colors
    lda #BLACK
    sta BG_COLOR
    // *BORDER_COLOR = BLACK
    sta BORDER_COLOR
    // bitmap_init(BITMAP, SCREEN)
  // Draw some lines on the bitmap
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cx+cy
    txa
    clc
    adc.z cy
    // byte col = (cx+cy)&$f
    and #$f
    tay
    // byte col2 = ($f-col)
    tya
    eor #$ff
    sec
    adc #$f
    sta.z col2
    // col*$10
    tya
    asl
    asl
    asl
    asl
    // col*$10 | col2
    ora.z col2
    // *ch++ = col*$10 | col2
    ldy #0
    sta (ch),y
    // *ch++ = col*$10 | col2;
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #0
    sta.z l
  __b6:
    // for(byte l=0; l<lines_cnt;l++)
    lda.z l
    cmp #lines_cnt
    bcc __b7
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #0
    jsr mode_ctrl
    // }
    rts
  __b7:
    // bitmap_line(lines_x[l], lines_y[l], lines_x[l+1], lines_y[l+1])
    ldy.z l
    lda lines_x,y
    sta.z bitmap_line.x1
    lda #0
    sta.z bitmap_line.x1+1
    lda lines_y,y
    sta.z bitmap_line.y1
    lda #0
    sta.z bitmap_line.y1+1
    lda lines_x+1,y
    sta.z bitmap_line.x2
    lda #0
    sta.z bitmap_line.x2+1
    lda lines_y+1,y
    sta.z bitmap_line.y2
    lda #0
    sta.z bitmap_line.y2+1
    jsr bitmap_line
    // for(byte l=0; l<lines_cnt;l++)
    inc.z l
    jmp __b6
  .segment Data
    lines_x: .byte 0, $ff, $ff, 0, 0, $80, $ff, $80, 0, $80
    lines_y: .byte 0, 0, $c7, $c7, 0, 0, $64, $c7, $64, 0
}
.segment Code
// High Color Standard Character Mode (LINEAR/CHUNK/COLDIS/ECM/MCM/BMM = 0, HICOL = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
// Pixel Shifter (1)
//  - 0: 8bpp BG_COLORor0[7:0]
//  - 1: 8bpp ColorData[7:0]
mode_hicolstdchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $8400
    .label __3 = $17
    // Char Colors and screen chars
    .label col = $f
    .label ch = $d
    .label cy = 7
    // *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000)
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // *DTV_COLOR_BANK_LO = <((word)(COLORS/$400))
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >((word)(COLORS/$400))
    lda #0
    sta DTV_COLOR_BANK_HI
    // *DTV_CONTROL = DTV_HIGHCOLOR
    lda #DTV_HIGHCOLOR
    sta DTV_CONTROL
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2
    // *VICII_CONTROL1 = VICII_DEN|VICII_RSEL|3
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_CSEL
    lda #VICII_CSEL
    sta VICII_CONTROL2
    // *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400))
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VICII_MEMORY
    ldx #0
  // DTV Palette - Grey Tones
  __b1:
    // DTV_PALETTE[i] = i
    txa
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BG_COLOR = 0
    // Screen colors
    lda #0
    sta BG_COLOR
    // *BORDER_COLOR = 0
    sta BORDER_COLOR
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cy&$f
    lda #$f
    and.z cy
    // (cy&$f)*$10
    asl
    asl
    asl
    asl
    sta.z __3
    // cx&$f
    txa
    and #$f
    // byte v = (cy&$f)*$10|(cx&$f)
    ora.z __3
    // *col++ = v
    ldy #0
    sta (col),y
    // *col++ = v;
    inc.z col
    bne !+
    inc.z col+1
  !:
    // *ch++ = v
    ldy #0
    sta (ch),y
    // *ch++ = v;
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #DTV_HIGHCOLOR
    jsr mode_ctrl
    // }
    rts
}
// High Color Extended Background Color Character Mode (LINEAR/CHUNK/COLDIS/MCM/BMM = 0, ECM/HICOL = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & "00" & CharData[5:0] & RowCounter[2:0] )
// GfxData Pixel Shifter (1)
//  - 0: 8bpp Background Color
//    - CharData[7:6] 00: 8bpp BG_COLORor0[7:0]
//    - CharData[7:6] 01: 8bpp BG_COLORor1[7:0]
//    - CharData[7:6] 10: 8bpp BG_COLORor2[7:0]
//    - CharData[7:6] 11: 8bpp BG_COLORor3[7:0]
//  - 1: 8bpp ColorData[7:0]
mode_hicolecmchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $8400
    .label __3 = $18
    // Char Colors and screen chars
    .label col = $d
    .label ch = $f
    .label cy = 7
    // *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000)
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // *DTV_COLOR_BANK_LO = <((word)(COLORS/$400))
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >((word)(COLORS/$400))
    lda #0
    sta DTV_COLOR_BANK_HI
    // *DTV_CONTROL = DTV_HIGHCOLOR
    lda #DTV_HIGHCOLOR
    sta DTV_CONTROL
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2
    // *VICII_CONTROL1 = VICII_DEN|VICII_RSEL|VICII_ECM|3
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VICII_DEN|VICII_RSEL|VICII_ECM|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_CSEL
    lda #VICII_CSEL
    sta VICII_CONTROL2
    // *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400))
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VICII_MEMORY
    ldx #0
  // DTV Palette - Grey Tones
  __b1:
    // DTV_PALETTE[i] = i
    txa
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BORDER_COLOR = 0
    // Screen colors
    lda #0
    sta BORDER_COLOR
    // *BG_COLOR = $50
    lda #$50
    sta BG_COLOR
    // *BG_COLOR1 = $54
    lda #$54
    sta BG_COLOR1
    // *BG_COLOR2 = $58
    lda #$58
    sta BG_COLOR2
    // *BG_COLOR3 = $5c
    lda #$5c
    sta BG_COLOR3
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cy&$f
    lda #$f
    and.z cy
    // (cy&$f)*$10
    asl
    asl
    asl
    asl
    sta.z __3
    // cx&$f
    txa
    and #$f
    // byte v = (cy&$f)*$10|(cx&$f)
    ora.z __3
    // *col++ = v
    ldy #0
    sta (col),y
    // *col++ = v;
    inc.z col
    bne !+
    inc.z col+1
  !:
    // *ch++ = v
    ldy #0
    sta (ch),y
    // *ch++ = v;
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #DTV_HIGHCOLOR
    jsr mode_ctrl
    // }
    rts
}
// High Color Multicolor Character Mode (LINEAR/CHUNK/COLDIS/BMM/ECM = 0, MCM/HICOL = 1)
// Resolution: 160x200 (320x200)
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
//GfxData Pixel Shifter (1) if ColorData[3:3] = 0:
// - 0: 8bpp BG_COLORor0[7:0]
// - 1: 8bpp ColorData[7:4] "0" & Color[2:0]
//GfxData Pixel Shifter (2) if ColorData[3:3] = 1:
// - 00: 8bpp BG_COLORor0[7:0]
// - 01: 8bpp BG_COLORor1[7:0]
// - 10: 8bpp BG_COLORor2[7:0]
// - 11: 8bpp ColorData[7:4] "0" & Color[2:0]
mode_hicolmcchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $8400
    .label __3 = $18
    // Char Colors and screen chars
    .label col = $f
    .label ch = $d
    .label cy = 7
    // *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000)
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // *DTV_COLOR_BANK_LO = <((word)(COLORS/$400))
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >((word)(COLORS/$400))
    lda #0
    sta DTV_COLOR_BANK_HI
    // *DTV_CONTROL = DTV_HIGHCOLOR
    lda #DTV_HIGHCOLOR
    sta DTV_CONTROL
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2
    // *VICII_CONTROL1 = VICII_DEN|VICII_RSEL|3
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_CSEL|VICII_MCM
    lda #VICII_CSEL|VICII_MCM
    sta VICII_CONTROL2
    // *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400))
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VICII_MEMORY
    ldx #0
  // DTV Palette - Grey Tones
  __b1:
    // DTV_PALETTE[i] = i
    txa
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BORDER_COLOR = 0
    // Screen colors
    lda #0
    sta BORDER_COLOR
    // *BG_COLOR = $50
    lda #$50
    sta BG_COLOR
    // *BG_COLOR1 = $54
    lda #$54
    sta BG_COLOR1
    // *BG_COLOR2 = $58
    lda #$58
    sta BG_COLOR2
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cy&$f
    lda #$f
    and.z cy
    // (cy&$f)*$10
    asl
    asl
    asl
    asl
    sta.z __3
    // cx&$f
    txa
    and #$f
    // byte v = (cy&$f)*$10|(cx&$f)
    ora.z __3
    // *col++ = v
    ldy #0
    sta (col),y
    // *col++ = v;
    inc.z col
    bne !+
    inc.z col+1
  !:
    // *ch++ = v
    ldy #0
    sta (ch),y
    // *ch++ = v;
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #DTV_HIGHCOLOR
    jsr mode_ctrl
    // }
    rts
}
// Sixs Fred Mode 2 - 8bpp Packed Bitmap - Generated from the two DTV linear graphics plane counters
// Two Plane MultiColor Bitmap - 8bpp Packed Bitmap (CHUNK/COLDIS/HICOL = 0, ECM/BMM/MCM/LINEAR = 1)
// Resolution: 160x200
// Linear Adressing
// PlaneA Pixel Shifter (2), PlaneB Pixel Shifter (2):
// - 8bpp color (PlaneB[1:0],ColorData[5:4],PlaneA[1:0],ColorData[1:0])
mode_sixsfred2: {
    .label PLANEA = $4000
    .label PLANEB = $6000
    .label COLORS = $8000
    .label __3 = $19
    // Colors for high 4 bits of 8bpp
    .label col = $d
    .label cy = 6
    // Graphics for Plane A () - horizontal stripes every 2 pixels
    .label gfxa = $f
    .label ay = 7
    // Graphics for Plane B - vertical stripes every 2 pixels
    .label gfxb = 9
    .label by = 8
    // *DTV_CONTROL = DTV_LINEAR
    lda #DTV_LINEAR
    sta DTV_CONTROL
    // *VICII_CONTROL1 = VICII_ECM|VICII_BMM|VICII_DEN|VICII_RSEL|3
    // VIC Graphics Mode
    lda #VICII_ECM|VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_MCM|VICII_CSEL
    lda #VICII_MCM|VICII_CSEL
    sta VICII_CONTROL2
    // *DTV_PLANEA_START_LO = <PLANEA
    // Linear Graphics Plane A Counter
    lda #0
    sta DTV_PLANEA_START_LO
    // *DTV_PLANEA_START_MI = >PLANEA
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    // *DTV_PLANEA_START_HI = 0
    lda #0
    sta DTV_PLANEA_START_HI
    // *DTV_PLANEA_STEP = 1
    lda #1
    sta DTV_PLANEA_STEP
    // *DTV_PLANEA_MODULO_LO = 0
    lda #0
    sta DTV_PLANEA_MODULO_LO
    // *DTV_PLANEA_MODULO_HI = 0
    sta DTV_PLANEA_MODULO_HI
    // *DTV_PLANEB_START_LO = <PLANEB
    // Linear Graphics Plane B Counter
    sta DTV_PLANEB_START_LO
    // *DTV_PLANEB_START_MI = >PLANEB
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    // *DTV_PLANEB_START_HI = 0
    lda #0
    sta DTV_PLANEB_START_HI
    // *DTV_PLANEB_STEP = 1
    lda #1
    sta DTV_PLANEB_STEP
    // *DTV_PLANEB_MODULO_LO = 0
    lda #0
    sta DTV_PLANEB_MODULO_LO
    // *DTV_PLANEB_MODULO_HI = 0
    sta DTV_PLANEB_MODULO_HI
    // *DTV_COLOR_BANK_LO = <(COLORS/$400)
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >(COLORS/$400)
    lda #0
    sta DTV_COLOR_BANK_HI
    tax
  // DTV Palette - Grey Tones
  __b1:
    // DTV_PALETTE[i] = i
    txa
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BORDER_COLOR = $00
    // Screen colors
    lda #0
    sta BORDER_COLOR
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cx&3
    txa
    and #3
    // (cx&3)*$10
    asl
    asl
    asl
    asl
    sta.z __3
    // cy&3
    lda #3
    and.z cy
    // (cx&3)*$10|(cy&3)
    ora.z __3
    // *col++ = (cx&3)*$10|(cy&3)
    ldy #0
    sta (col),y
    // *col++ = (cx&3)*$10|(cy&3);
    inc.z col
    bne !+
    inc.z col+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #<PLANEA
    sta.z gfxa
    lda #>PLANEA
    sta.z gfxa+1
    lda #0
    sta.z ay
  __b6:
    ldx #0
  __b7:
    // ay/2
    lda.z ay
    lsr
    // byte row = (ay/2) & 3
    and #3
    // *gfxa++ = row_bitmask[row]
    tay
    lda row_bitmask,y
    ldy #0
    sta (gfxa),y
    // *gfxa++ = row_bitmask[row];
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    // for (byte ax : 0..39)
    inx
    cpx #$28
    bne __b7
    // for(byte ay : 0..199)
    inc.z ay
    lda #$c8
    cmp.z ay
    bne __b6
    lda #0
    sta.z by
    lda #<PLANEB
    sta.z gfxb
    lda #>PLANEB
    sta.z gfxb+1
  __b9:
    ldx #0
  __b10:
    // *gfxb++ = %00011011
    lda #$1b
    ldy #0
    sta (gfxb),y
    // *gfxb++ = %00011011;
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    // for ( byte bx : 0..39)
    inx
    cpx #$28
    bne __b10
    // for(byte by : 0..199)
    inc.z by
    lda #$c8
    cmp.z by
    bne __b9
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #DTV_LINEAR
    jsr mode_ctrl
    // }
    rts
  .segment Data
    row_bitmask: .byte 0, $55, $aa, $ff
}
.segment Code
// Two Plane Bitmap - generated from the two DTV linear graphics plane counters
// Two Plane Bitmap Mode (CHUNK/COLDIS/MCM = 0, ECM/BMM/HICOL/LINEAR = 1)
// Resolution: 320x200
// Linear Adressing
// GfxData/PlaneA Pixel Shifter (1), CharData/PlaneB Pixel Shifter (1):
// - Plane A = 0 Plane B = 0: 8bpp BG_COLORor0[7:0]
// - Plane A = 0 Plane B = 1: 8bpp "0000" & ColorData[7:4]
// - Plane A = 1 Plane B = 0: 8bpp "0000" & ColorData[3:0]
// - Plane A = 1 Plane B = 1: 8bpp BG_COLORor1[7:0]
mode_twoplanebitmap: {
    .label PLANEA = $4000
    .label PLANEB = $6000
    .label COLORS = $8000
    .label __3 = $19
    // Color for bits 11
    // Colors for bits 01 / 10
    .label col = $f
    .label cy = 6
    // Graphics for Plane A - horizontal stripes
    .label gfxa = 9
    .label ay = 7
    // Graphics for Plane B - vertical stripes
    .label gfxb = $d
    .label by = 8
    // *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta DTV_CONTROL
    // *VICII_CONTROL1 = VICII_ECM|VICII_BMM|VICII_DEN|VICII_RSEL|3
    // VIC Graphics Mode
    lda #VICII_ECM|VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_CSEL
    lda #VICII_CSEL
    sta VICII_CONTROL2
    // *DTV_PLANEA_START_LO = <PLANEA
    // Linear Graphics Plane A Counter
    lda #0
    sta DTV_PLANEA_START_LO
    // *DTV_PLANEA_START_MI = >PLANEA
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    // *DTV_PLANEA_START_HI = 0
    lda #0
    sta DTV_PLANEA_START_HI
    // *DTV_PLANEA_STEP = 1
    lda #1
    sta DTV_PLANEA_STEP
    // *DTV_PLANEA_MODULO_LO = 0
    lda #0
    sta DTV_PLANEA_MODULO_LO
    // *DTV_PLANEA_MODULO_HI = 0
    sta DTV_PLANEA_MODULO_HI
    // *DTV_PLANEB_START_LO = <PLANEB
    // Linear Graphics Plane B Counter
    sta DTV_PLANEB_START_LO
    // *DTV_PLANEB_START_MI = >PLANEB
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    // *DTV_PLANEB_START_HI = 0
    lda #0
    sta DTV_PLANEB_START_HI
    // *DTV_PLANEB_STEP = 1
    lda #1
    sta DTV_PLANEB_STEP
    // *DTV_PLANEB_MODULO_LO = 0
    lda #0
    sta DTV_PLANEB_MODULO_LO
    // *DTV_PLANEB_MODULO_HI = 0
    sta DTV_PLANEB_MODULO_HI
    // *DTV_COLOR_BANK_LO = <(COLORS/$400)
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >(COLORS/$400)
    lda #0
    sta DTV_COLOR_BANK_HI
    tax
  // DTV Palette - Grey Tones
  __b1:
    // DTV_PALETTE[i] = i
    txa
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BORDER_COLOR = $00
    // Screen colors
    lda #0
    sta BORDER_COLOR
    // *BG_COLOR = $70
    lda #$70
    sta BG_COLOR
    // *BG_COLOR1 = $d4
    // Color for bits 00
    lda #$d4
    sta BG_COLOR1
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cy & $f
    lda #$f
    and.z cy
    // (cy & $f)*$10
    asl
    asl
    asl
    asl
    sta.z __3
    // cx &$f
    txa
    and #$f
    // (cy & $f)*$10 | (cx &$f)
    ora.z __3
    // *col++ = (cy & $f)*$10 | (cx &$f)
    ldy #0
    sta (col),y
    // *col++ = (cy & $f)*$10 | (cx &$f);
    inc.z col
    bne !+
    inc.z col+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #<PLANEA
    sta.z gfxa
    lda #>PLANEA
    sta.z gfxa+1
    lda #0
    sta.z ay
  __b6:
    ldx #0
  __b7:
    // ay&4
    lda #4
    and.z ay
    // if((ay&4)==0)
    cmp #0
    beq __b8
    // *gfxa++ = %11111111
    lda #$ff
    ldy #0
    sta (gfxa),y
    // *gfxa++ = %11111111;
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
  __b9:
    // for (byte ax : 0..39)
    inx
    cpx #$28
    bne __b7
    // for(byte ay : 0..199)
    inc.z ay
    lda #$c8
    cmp.z ay
    bne __b6
    lda #0
    sta.z by
    lda #<PLANEB
    sta.z gfxb
    lda #>PLANEB
    sta.z gfxb+1
  __b12:
    ldx #0
  __b13:
    // *gfxb++ = %00001111
    lda #$f
    ldy #0
    sta (gfxb),y
    // *gfxb++ = %00001111;
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    // for ( byte bx : 0..39)
    inx
    cpx #$28
    bne __b13
    // for(byte by : 0..199)
    inc.z by
    lda #$c8
    cmp.z by
    bne __b12
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #DTV_HIGHCOLOR|DTV_LINEAR
    jsr mode_ctrl
    // }
    rts
  __b8:
    // *gfxa++ = %00000000
    lda #0
    tay
    sta (gfxa),y
    // *gfxa++ = %00000000;
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    jmp __b9
}
// Sixs Fred Mode - 8bpp Packed Bitmap - Generated from the two DTV linear graphics plane counters
// Two Plane MultiColor Bitmap - 8bpp Packed Bitmap (CHUNK/COLDIS = 0, ECM/BMM/MCM/HICOL/LINEAR = 1)
// Resolution: 160x200
// Linear Adressing
// GfxData/PlaneA Pixel Shifter (2), CharData/PlaneB Pixel Shifter (2):
// - 8bpp color (ColorData[3:0],CharData/PlaneB[1:0], GfxData/PlaneA[1:0])
mode_sixsfred: {
    .label PLANEA = $4000
    .label PLANEB = $6000
    .label COLORS = $8000
    // Colors for high 4 bits of 8bpp
    .label col = $d
    .label cy = 6
    // Graphics for Plane A () - horizontal stripes every 2 pixels
    .label gfxa = 9
    .label ay = 7
    // Graphics for Plane B - vertical stripes every 2 pixels
    .label gfxb = $f
    .label by = 8
    // *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta DTV_CONTROL
    // *VICII_CONTROL1 = VICII_ECM|VICII_BMM|VICII_DEN|VICII_RSEL|3
    // VIC Graphics Mode
    lda #VICII_ECM|VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_MCM|VICII_CSEL
    lda #VICII_MCM|VICII_CSEL
    sta VICII_CONTROL2
    // *DTV_PLANEA_START_LO = <PLANEA
    // Linear Graphics Plane A Counter
    lda #0
    sta DTV_PLANEA_START_LO
    // *DTV_PLANEA_START_MI = >PLANEA
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    // *DTV_PLANEA_START_HI = 0
    lda #0
    sta DTV_PLANEA_START_HI
    // *DTV_PLANEA_STEP = 1
    lda #1
    sta DTV_PLANEA_STEP
    // *DTV_PLANEA_MODULO_LO = 0
    lda #0
    sta DTV_PLANEA_MODULO_LO
    // *DTV_PLANEA_MODULO_HI = 0
    sta DTV_PLANEA_MODULO_HI
    // *DTV_PLANEB_START_LO = <PLANEB
    // Linear Graphics Plane B Counter
    sta DTV_PLANEB_START_LO
    // *DTV_PLANEB_START_MI = >PLANEB
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    // *DTV_PLANEB_START_HI = 0
    lda #0
    sta DTV_PLANEB_START_HI
    // *DTV_PLANEB_STEP = 1
    lda #1
    sta DTV_PLANEB_STEP
    // *DTV_PLANEB_MODULO_LO = 0
    lda #0
    sta DTV_PLANEB_MODULO_LO
    // *DTV_PLANEB_MODULO_HI = 0
    sta DTV_PLANEB_MODULO_HI
    // *DTV_COLOR_BANK_LO = <(COLORS/$400)
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >(COLORS/$400)
    lda #0
    sta DTV_COLOR_BANK_HI
    tax
  // DTV Palette - Grey Tones
  __b1:
    // DTV_PALETTE[i] = i
    txa
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BORDER_COLOR = $00
    // Screen colors
    lda #0
    sta BORDER_COLOR
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    // cx+cy
    txa
    clc
    adc.z cy
    // (cx+cy) & $f
    and #$f
    // *col++ = (cx+cy) & $f
    ldy #0
    sta (col),y
    // *col++ = (cx+cy) & $f;
    inc.z col
    bne !+
    inc.z col+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b4
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #<PLANEA
    sta.z gfxa
    lda #>PLANEA
    sta.z gfxa+1
    lda #0
    sta.z ay
  __b6:
    ldx #0
  __b7:
    // ay/2
    lda.z ay
    lsr
    // byte row = (ay/2) & 3
    and #3
    // *gfxa++ = row_bitmask[row]
    tay
    lda row_bitmask,y
    ldy #0
    sta (gfxa),y
    // *gfxa++ = row_bitmask[row];
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    // for (byte ax : 0..39)
    inx
    cpx #$28
    bne __b7
    // for(byte ay : 0..199)
    inc.z ay
    lda #$c8
    cmp.z ay
    bne __b6
    lda #0
    sta.z by
    lda #<PLANEB
    sta.z gfxb
    lda #>PLANEB
    sta.z gfxb+1
  __b9:
    ldx #0
  __b10:
    // *gfxb++ = %00011011
    lda #$1b
    ldy #0
    sta (gfxb),y
    // *gfxb++ = %00011011;
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    // for ( byte bx : 0..39)
    inx
    cpx #$28
    bne __b10
    // for(byte by : 0..199)
    inc.z by
    lda #$c8
    cmp.z by
    bne __b9
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #DTV_HIGHCOLOR|DTV_LINEAR
    jsr mode_ctrl
    // }
    rts
  .segment Data
    row_bitmask: .byte 0, $55, $aa, $ff
}
.segment Code
//8bpp Pixel Cell Mode (BMM/COLDIS = 0, ECM/MCM/HICOL/LINEAR/CHUNK = 1)
//Pixel Cell Adressing
//CharData[8]: (PlaneA[21:0])
//GfxData[8]: (PlaneB[21:14] & CharData[7:0] & RowCounter[3:0] & PixelCounter[7:0] )
//GfxData Pixel Shifter (8):
//- 8bpp color GfxData[7:0]
//Pixel cell mode can be thought of as a text mode that uses a 8x8 pixel 8bpp font (64 bytes/char).
//The characters come from counter A and the font (or "cells") from counter B.
//Counter B step and modulo should be set to 0, counter A modulo to 0 and counter A step to 1 for normal operation.
mode_8bpppixelcell: {
    // 8BPP Pixel Cell Screen (contains 40x25=1000 chars)
    .label PLANEA = $3c00
    // 8BPP Pixel Cell Charset (contains 256 64 byte chars)
    .label PLANEB = $4000
    .label CHARGEN = $d000
    .label __3 = $1c
    // Screen Chars for Plane A (screen) - 16x16 repeating
    .label gfxa = 9
    .label ay = 6
    .label bits = $17
    .label chargen = $f
    .label gfxb = $d
    .label col = $18
    .label cr = 8
    .label ch = 7
    // *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR | DTV_CHUNKY
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY
    sta DTV_CONTROL
    // *VICII_CONTROL1 = VICII_ECM|VICII_DEN|VICII_RSEL|3
    // VIC Graphics Mode
    lda #VICII_ECM|VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_MCM|VICII_CSEL
    lda #VICII_MCM|VICII_CSEL
    sta VICII_CONTROL2
    // *DTV_PLANEA_START_LO = <PLANEA
    // Linear Graphics Plane A Counter
    lda #0
    sta DTV_PLANEA_START_LO
    // *DTV_PLANEA_START_MI = >PLANEA
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    // *DTV_PLANEA_START_HI = 0
    lda #0
    sta DTV_PLANEA_START_HI
    // *DTV_PLANEA_STEP = 1
    lda #1
    sta DTV_PLANEA_STEP
    // *DTV_PLANEA_MODULO_LO = 0
    lda #0
    sta DTV_PLANEA_MODULO_LO
    // *DTV_PLANEA_MODULO_HI = 0
    sta DTV_PLANEA_MODULO_HI
    // *DTV_PLANEB_START_LO = <PLANEB
    // Linear Graphics Plane B Counter
    sta DTV_PLANEB_START_LO
    // *DTV_PLANEB_START_MI = >PLANEB
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    // *DTV_PLANEB_START_HI = 0
    lda #0
    sta DTV_PLANEB_START_HI
    // *DTV_PLANEB_STEP = 0
    sta DTV_PLANEB_STEP
    // *DTV_PLANEB_MODULO_LO = 0
    sta DTV_PLANEB_MODULO_LO
    // *DTV_PLANEB_MODULO_HI = 0
    sta DTV_PLANEB_MODULO_HI
    // *BORDER_COLOR = $00
    // Border color
    sta BORDER_COLOR
    tax
  // DTV Palette - Grey Tones
  __b1:
    // DTV_PALETTE[i] = i
    txa
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    lda #<PLANEA
    sta.z gfxa
    lda #>PLANEA
    sta.z gfxa+1
    lda #0
    sta.z ay
  __b2:
    ldx #0
  __b3:
    // ay & $f
    lda #$f
    and.z ay
    // (ay & $f)*$10
    asl
    asl
    asl
    asl
    sta.z __3
    // ax & $f
    txa
    and #$f
    // (ay & $f)*$10 | (ax & $f)
    ora.z __3
    // *gfxa++ = (ay & $f)*$10 | (ax & $f)
    ldy #0
    sta (gfxa),y
    // *gfxa++ = (ay & $f)*$10 | (ax & $f);
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    // for (byte ax : 0..39)
    inx
    cpx #$28
    bne __b3
    // for(byte ay : 0..24)
    inc.z ay
    lda #$19
    cmp.z ay
    bne __b2
    // *PROCPORT = PROCPORT_RAM_CHARROM
    // 8bpp cells for Plane B (charset) - ROM charset with 256 colors
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    lda #0
    sta.z ch
    sta.z col
    lda #<PLANEB
    sta.z gfxb
    lda #>PLANEB
    sta.z gfxb+1
    lda #<CHARGEN
    sta.z chargen
    lda #>CHARGEN
    sta.z chargen+1
  __b6:
    lda #0
    sta.z cr
  __b7:
    // byte bits = *chargen++
    ldy #0
    lda (chargen),y
    sta.z bits
    inc.z chargen
    bne !+
    inc.z chargen+1
  !:
    ldx #0
  __b8:
    // bits & $80
    lda #$80
    and.z bits
    // if((bits & $80) != 0)
    cmp #0
    beq __b4
    lda.z col
    jmp __b9
  __b4:
    lda #0
  __b9:
    // *gfxb++ = c
    ldy #0
    sta (gfxb),y
    // *gfxb++ = c;
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    // bits = bits*2
    asl.z bits
    // col++;
    inc.z col
    // for ( byte cp : 0..7)
    inx
    cpx #8
    bne __b8
    // for ( byte cr : 0..7)
    inc.z cr
    lda #8
    cmp.z cr
    bne __b7
    // for(byte ch : $00..$ff)
    inc.z ch
    lda.z ch
    bne __b6
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY
    jsr mode_ctrl
    // }
    rts
}
//Chunky 8bpp Bitmap Mode (BMM = 0, ECM/MCM/HICOL/LINEAR/CHUNK/COLDIS = 1)
// Resolution: 320x200
// Linear Adressing
// CharData/PlaneB Pixel Shifter (8):
// - 8bpp color PlaneB[7:0]
// To set up a linear video frame buffer the step size must be set to 8.
mode_8bppchunkybmm: {
    // 8BPP Chunky Bitmap (contains 8bpp pixels)
    .const PLANEB = $20000
    .label __7 = $1a
    .label gfxb = $f
    .label x = $d
    .label y = $17
    // *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR | DTV_CHUNKY | DTV_COLORRAM_OFF
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_COLORRAM_OFF
    sta DTV_CONTROL
    // *VICII_CONTROL1 = VICII_ECM | VICII_DEN | VICII_RSEL | 3
    // VIC Graphics Mode
    lda #VICII_ECM|VICII_DEN|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_MCM | VICII_CSEL
    lda #VICII_MCM|VICII_CSEL
    sta VICII_CONTROL2
    // *DTV_PLANEB_START_LO = < < PLANEB
    // Linear Graphics Plane B Counter
    lda #0
    sta DTV_PLANEB_START_LO
    // *DTV_PLANEB_START_MI = > < PLANEB
    sta DTV_PLANEB_START_MI
    // *DTV_PLANEB_START_HI = < > PLANEB
    lda #<PLANEB>>$10
    sta DTV_PLANEB_START_HI
    // *DTV_PLANEB_STEP = 8
    lda #8
    sta DTV_PLANEB_STEP
    // *DTV_PLANEB_MODULO_LO = 0
    lda #0
    sta DTV_PLANEB_MODULO_LO
    // *DTV_PLANEB_MODULO_HI = 0
    sta DTV_PLANEB_MODULO_HI
    // *BORDER_COLOR = $00
    // Border color
    sta BORDER_COLOR
    tax
  // DTV Palette - Grey Tones
  __b1:
    // DTV_PALETTE[i] = i
    txa
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
    lda #PLANEB/$4000
    jsr dtvSetCpuBankSegment1
    ldx #PLANEB/$4000+1
    lda #0
    sta.z y
    lda #<$4000
    sta.z gfxb
    lda #>$4000
    sta.z gfxb+1
  __b3:
    lda #<0
    sta.z x
    sta.z x+1
  __b4:
    // if(gfxb==$8000)
    lda.z gfxb+1
    cmp #>$8000
    bne __b5
    lda.z gfxb
    cmp #<$8000
    bne __b5
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
    txa
    jsr dtvSetCpuBankSegment1
    // dtvSetCpuBankSegment1(gfxbCpuBank++);
    inx
    lda #<$4000
    sta.z gfxb
    lda #>$4000
    sta.z gfxb+1
  __b5:
    // x+y
    lda.z y
    clc
    adc.z x
    sta.z __7
    lda #0
    adc.z x+1
    sta.z __7+1
    // byte c = (byte)(x+y)
    lda.z __7
    // *gfxb++ = c
    ldy #0
    sta (gfxb),y
    // *gfxb++ = c;
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    // for (word x : 0..319)
    inc.z x
    bne !+
    inc.z x+1
  !:
    lda.z x+1
    cmp #>$140
    bne __b4
    lda.z x
    cmp #<$140
    bne __b4
    // for(byte y : 0..199)
    inc.z y
    lda #$c8
    cmp.z y
    bne __b3
    // dtvSetCpuBankSegment1((byte)($4000/$4000))
  // Reset CPU BANK segment to $4000
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    // mode_ctrl()
  // Leave control to the user until exit
    ldx #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_COLORRAM_OFF
    jsr mode_ctrl
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(9) str, byte register(X) c, word zp($f) num)
memset: {
    .label end = $f
    .label dst = 9
    .label num = $f
    .label str = 9
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // char* end = (char*)str + num
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
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable the normal interrupt or sei/cli around calls to the keyboard matrix reader.
// keyboard_matrix_read(byte register(Y) rowid)
keyboard_matrix_read: {
    // CIA1->PORT_A = keyboard_matrix_row_bitmask[rowid]
    lda keyboard_matrix_row_bitmask,y
    sta CIA1
    // ~CIA1->PORT_B
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    eor #$ff
    // }
    rts
}
// Allow the user to control the DTV graphics using different keys
mode_ctrl: {
    // DTV Graphics Mode - Reset
    .label ctrl = $19
  __b1:
  // Wait for the raster
  __b2:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b2
    // keyboard_key_pressed(KEY_SPACE)
    ldy #KEY_SPACE
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // if(keyboard_key_pressed(KEY_SPACE)!=0)
    cmp #0
    beq __b4
    // }
    rts
  __b4:
    // byte ctrl = dtv_control
    // Read the current control byte
    stx.z ctrl
    // keyboard_key_pressed(KEY_L)
    ldy #KEY_L
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_L)
    // if(keyboard_key_pressed(KEY_L)!=0)
    cmp #0
    beq __b5
    // ctrl = ctrl|DTV_LINEAR
    lda #DTV_LINEAR
    ora.z ctrl
    sta.z ctrl
  __b5:
    // keyboard_key_pressed(KEY_H)
    ldy #KEY_H
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_H)
    // if(keyboard_key_pressed(KEY_H)!=0)
    cmp #0
    beq __b6
    // ctrl = ctrl|DTV_HIGHCOLOR
    lda #DTV_HIGHCOLOR
    ora.z ctrl
    sta.z ctrl
  __b6:
    // keyboard_key_pressed(KEY_O)
    ldy #KEY_O
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_O)
    // if(keyboard_key_pressed(KEY_O)!=0)
    cmp #0
    beq __b7
    // ctrl = ctrl|DTV_OVERSCAN
    lda #DTV_OVERSCAN
    ora.z ctrl
    sta.z ctrl
  __b7:
    // keyboard_key_pressed(KEY_B)
    ldy #KEY_B
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_B)
    // if(keyboard_key_pressed(KEY_B)!=0)
    cmp #0
    beq __b8
    // ctrl = ctrl|DTV_BORDER_OFF
    lda #DTV_BORDER_OFF
    ora.z ctrl
    sta.z ctrl
  __b8:
    // keyboard_key_pressed(KEY_U)
    ldy #KEY_U
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_U)
    // if(keyboard_key_pressed(KEY_U)!=0)
    cmp #0
    beq __b9
    // ctrl = ctrl|DTV_CHUNKY
    lda #DTV_CHUNKY
    ora.z ctrl
    sta.z ctrl
  __b9:
    // keyboard_key_pressed(KEY_C)
    ldy #KEY_C
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_C)
    // if(keyboard_key_pressed(KEY_C)!=0)
    cmp #0
    beq __b10
    // ctrl = ctrl|DTV_COLORRAM_OFF
    lda #DTV_COLORRAM_OFF
    ora.z ctrl
    sta.z ctrl
  __b10:
    // keyboard_key_pressed(KEY_0)
    ldy #KEY_0
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_0)
    // if(keyboard_key_pressed(KEY_0)!=0)
    cmp #0
    beq __b11
    lda #0
    sta.z ctrl
  __b11:
    // if(ctrl != dtv_control)
    cpx.z ctrl
    beq __b1
    // dtv_control = ctrl
    ldx.z ctrl
    // *DTV_CONTROL = ctrl
    txa
    sta DTV_CONTROL
    // *BORDER_COLOR = ctrl
    txa
    sta BORDER_COLOR
    jmp __b1
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label __7 = $1c
    .label yoffs = $b
    ldx #0
    lda #$80
  __b1:
    // bitmap_plot_bit[x] = bits
    sta bitmap_plot_bit,x
    // bits >>= 1
    lsr
    // if(bits==0)
    cmp #0
    bne __b2
    lda #$80
  __b2:
    // for(char x : 0..255)
    inx
    cpx #0
    bne __b1
    lda #<mode_stdbitmap.BITMAP
    sta.z yoffs
    lda #>mode_stdbitmap.BITMAP
    sta.z yoffs+1
    ldx #0
  __b3:
    // y&$7
    lda #7
    sax.z __7
    // <yoffs
    lda.z yoffs
    // y&$7 | <yoffs
    ora.z __7
    // bitmap_plot_ylo[y] = y&$7 | <yoffs
    sta bitmap_plot_ylo,x
    // >yoffs
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = >yoffs
    sta bitmap_plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __7
    bne __b4
    // yoffs = yoffs + 40*8
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    // for(char y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE*$10
    // memset(bitmap_screen, col, 1000uw)
    ldx #col
    lda #<mode_stdbitmap.SCREEN
    sta.z memset.str
    lda #>mode_stdbitmap.SCREEN
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    // memset(bitmap_gfx, 0, 8000uw)
    ldx #0
    lda #<mode_stdbitmap.BITMAP
    sta.z memset.str
    lda #>mode_stdbitmap.BITMAP
    sta.z memset.str+1
    lda #<$1f40
    sta.z memset.num
    lda #>$1f40
    sta.z memset.num+1
    jsr memset
    // }
    rts
}
// Draw a line on the bitmap using bresenhams algorithm
// bitmap_line(word zp(9) x1, word zp($b) y1, word zp($13) x2, word zp($15) y2)
bitmap_line: {
    .label dx = $1d
    .label dy = $f
    .label sx = $1f
    .label sy = $11
    .label e1 = $d
    .label e = $1a
    .label y = $b
    .label x = 9
    .label x1 = 9
    .label y1 = $b
    .label x2 = $13
    .label y2 = $15
    // abs_u16(x2-x1)
    lda.z x2
    sec
    sbc.z x1
    sta.z abs_u16.w
    lda.z x2+1
    sbc.z x1+1
    sta.z abs_u16.w+1
    jsr abs_u16
    // abs_u16(x2-x1)
    // unsigned int dx = abs_u16(x2-x1)
    lda.z abs_u16.return
    sta.z dx
    lda.z abs_u16.return+1
    sta.z dx+1
    // abs_u16(y2-y1)
    lda.z y2
    sec
    sbc.z y1
    sta.z abs_u16.w
    lda.z y2+1
    sbc.z y1+1
    sta.z abs_u16.w+1
    jsr abs_u16
    // abs_u16(y2-y1)
    // unsigned int dy = abs_u16(y2-y1)
    // if(dx==0 && dy==0)
    lda.z dx
    ora.z dx+1
    bne __b1
    lda.z dy
    ora.z dy+1
    bne !__b4+
    jmp __b4
  !__b4:
  __b1:
    // sgn_u16(x2-x1)
    lda.z x2
    sec
    sbc.z x1
    sta.z sgn_u16.w
    lda.z x2+1
    sbc.z x1+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    // sgn_u16(x2-x1)
    // unsigned int sx = sgn_u16(x2-x1)
    lda.z sgn_u16.return
    sta.z sx
    lda.z sgn_u16.return+1
    sta.z sx+1
    // sgn_u16(y2-y1)
    lda.z y2
    sec
    sbc.z y1
    sta.z sgn_u16.w
    lda.z y2+1
    sbc.z y1+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    // sgn_u16(y2-y1)
    // unsigned int sy = sgn_u16(y2-y1)
    // if(dx > dy)
    lda.z dy+1
    cmp.z dx+1
    bcc __b2
    bne !+
    lda.z dy
    cmp.z dx
    bcc __b2
  !:
    // unsigned int e = dx/2
    lda.z dx+1
    lsr
    sta.z e+1
    lda.z dx
    ror
    sta.z e
  __b6:
    // bitmap_plot(x,(char)y)
    lda.z y
    jsr bitmap_plot
    // y += sy
    lda.z y
    clc
    adc.z sy
    sta.z y
    lda.z y+1
    adc.z sy+1
    sta.z y+1
    // e += dx
    lda.z e
    clc
    adc.z dx
    sta.z e
    lda.z e+1
    adc.z dx+1
    sta.z e+1
    // if(dy<e)
    cmp.z dy+1
    bne !+
    lda.z e
    cmp.z dy
    beq __b7
  !:
    bcc __b7
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    lda.z x+1
    adc.z sx+1
    sta.z x+1
    // e -= dy
    lda.z e
    sec
    sbc.z dy
    sta.z e
    lda.z e+1
    sbc.z dy+1
    sta.z e+1
  __b7:
    // while (y != y2)
    lda.z y+1
    cmp.z y2+1
    bne __b6
    lda.z y
    cmp.z y2
    bne __b6
  __b3:
    // bitmap_plot(x,(char)y)
    lda.z y
    jsr bitmap_plot
    // }
    rts
  __b2:
    // unsigned int e = dy/2
    lda.z dy+1
    lsr
    sta.z e1+1
    lda.z dy
    ror
    sta.z e1
  __b9:
    // bitmap_plot(x,(char)y)
    lda.z y
    jsr bitmap_plot
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    lda.z x+1
    adc.z sx+1
    sta.z x+1
    // e += dy
    lda.z e1
    clc
    adc.z dy
    sta.z e1
    lda.z e1+1
    adc.z dy+1
    sta.z e1+1
    // if(dx < e)
    cmp.z dx+1
    bne !+
    lda.z e1
    cmp.z dx
    beq __b10
  !:
    bcc __b10
    // y += sy
    lda.z y
    clc
    adc.z sy
    sta.z y
    lda.z y+1
    adc.z sy+1
    sta.z y+1
    // e -= dx
    lda.z e1
    sec
    sbc.z dx
    sta.z e1
    lda.z e1+1
    sbc.z dx+1
    sta.z e1+1
  __b10:
    // while (x != x2)
    lda.z x+1
    cmp.z x2+1
    bne __b9
    lda.z x
    cmp.z x2
    bne __b9
    jmp __b3
  __b4:
    // bitmap_plot(x,(char)y)
    lda.z y1
    jsr bitmap_plot
    rts
}
// Set the memory pointed to by CPU BANK 1 SEGMENT ($4000-$7fff)
// This sets which actual memory is addressed when the CPU reads/writes to $4000-$7fff
// The actual memory addressed will be $4000*cpuSegmentIdx
// dtvSetCpuBankSegment1(byte register(A) cpuBankIdx)
dtvSetCpuBankSegment1: {
    // Move CPU BANK 1 SEGMENT ($4000-$7fff)
    .label cpuBank = $ff
    // *cpuBank = cpuBankIdx
    sta cpuBank
    // asm
    .byte $32, $dd
    lda.z $ff
    .byte $32, $00
    // }
    rts
}
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// abs_u16(word zp($f) w)
abs_u16: {
    .label w = $f
    .label return = $f
    // >w
    lda.z w+1
    // >w&0x80
    and #$80
    // if(>w&0x80)
    cmp #0
    bne __b1
    rts
  __b1:
    // return -w;
    sec
    lda #0
    sbc.z return
    sta.z return
    lda #0
    sbc.z return+1
    sta.z return+1
    // }
    rts
}
// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
// sgn_u16(word zp($21) w)
sgn_u16: {
    .label w = $21
    .label return = $11
    // >w
    lda.z w+1
    // >w&0x80
    and #$80
    // if(>w&0x80)
    cmp #0
    bne __b1
    lda #<1
    sta.z return
    lda #>1
    sta.z return+1
    rts
  __b1:
    lda #<-1
    sta.z return
    sta.z return+1
    // }
    rts
}
// Plot a single dot in the bitmap
// bitmap_plot(word zp(9) x, byte register(A) y)
bitmap_plot: {
    .label __0 = $23
    .label plotter = $21
    .label x = 9
    // char* plotter = (char*) { bitmap_plot_yhi[y], bitmap_plot_ylo[y] }
    tay
    lda bitmap_plot_yhi,y
    sta.z plotter+1
    lda bitmap_plot_ylo,y
    sta.z plotter
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __0
    lda.z x+1
    and #>$fff8
    sta.z __0+1
    // plotter += ( x & $fff8 )
    lda.z plotter
    clc
    adc.z __0
    sta.z plotter
    lda.z plotter+1
    adc.z __0+1
    sta.z plotter+1
    // <x
    ldx.z x
    // *plotter |= bitmap_plot_bit[<x]
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    // }
    rts
}
.segment Data
  // Default vallues for the palette
  DTV_PALETTE_DEFAULT: .byte 0, $f, $36, $be, $58, $db, $86, $ff, $29, $26, $3b, 5, 7, $df, $9a, $a
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  MENU_TEXT: .text "C64DTV Graphics Modes            CCLHBME@                                 OHIIMCC@                                 LUNCMMM@----------------------------------------@1. Standard Char             (V) 0000000@2. Extended Color Char       (V) 0000001@3. Multicolor Char           (V) 0000010@4. Standard Bitmap           (V) 0000100@5. Multicolor Bitmap         (V) 0000110@6. High Color Standard Char  (H) 0001000@7. High Extended Color Char  (H) 0001001@8. High Multicolor Char      (H) 0001010@9. High Multicolor Bitmap    (H) 0001110@a. Sixs Fred 2               (D) 0010111@b. Two Plane Bitmap          (D) 0011101@c. Sixs Fred (2 Plane MC BM) (D) 0011111@d. 8bpp Pixel Cell           (D) 0111011@e. Chunky 8bpp Bitmap        (D) 1111011@----------------------------------------@    (V) vicII (H) vicII+hicol (D) c64dtv@"
  .byte 0
