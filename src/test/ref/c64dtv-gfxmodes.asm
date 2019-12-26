// Exploring C64DTV Screen Modes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = 5
  // RAM in $A000, $E000 CHAR ROM in $D000
  .const PROCPORT_RAM_CHARROM = 1
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label BGCOL1 = $d021
  .label BGCOL2 = $d022
  .label BGCOL3 = $d023
  .label BGCOL4 = $d024
  .label VIC_CONTROL = $d011
  .const VIC_ECM = $40
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label VIC_CONTROL2 = $d016
  .const VIC_MCM = $10
  .const VIC_CSEL = 8
  .label VIC_MEMORY = $d018
  // Color Ram
  .label COLS = $d800
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CIA1_PORT_B = $dc01
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  // The colors of the C64
  .const BLACK = 0
  .const GREEN = 5
  .const BLUE = 6
  .const LIGHT_GREEN = $d
  // Feature enables or disables the extra C64 DTV features
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  // Controls the graphics modes of the C64 DTV
  .label DTV_CONTROL = $d03c
  .const DTV_LINEAR = 1
  .const DTV_BORDER_OFF = 2
  .const DTV_HIGHCOLOR = 4
  .const DTV_OVERSCAN = 8
  .const DTV_COLORRAM_OFF = $10
  .const DTV_CHUNKY = $40
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
  .const DTV_COLOR_BANK_DEFAULT = $1d800
  // Selects memory bank for normal VIC color mode and lower data for high color modes. (bits 5:0)
  // Memory address of VIC Graphics is GraphicsBank*$10000
  .label DTV_GRAPHICS_VIC_BANK = $d03d
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
  .label print_char_cursor = 4
  // The value of the DTV control register
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  // DTV Graphics Mode
  .label dtv_control = $d
  .label print_line_cursor = 9
main: {
    sei
    // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // Enable DTV extended modes
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
  __b1:
    jsr menu
    jmp __b1
}
menu: {
    .label SCREEN = $8000
    .label CHARSET = $9800
    .label c = 4
    // Charset ROM
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    // DTV Graphics Mode
    sta DTV_CONTROL
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    lda #<COLS
    sta.z c
    lda #>COLS
    sta.z c+1
  // Char Colors
  __b2:
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
    // Screen colors
    lda #0
    sta BGCOL
    sta BORDERCOL
    jsr print_set_screen
    jsr print_cls
    jsr print_str_lines
  __b5:
    ldy #KEY_1
    jsr keyboard_key_pressed
    cmp #0
    beq __b6
    jsr mode_stdchar
    rts
  __b6:
    ldy #KEY_2
    jsr keyboard_key_pressed
    cmp #0
    beq __b7
    jsr mode_ecmchar
    rts
  __b7:
    ldy #KEY_3
    jsr keyboard_key_pressed
    cmp #0
    beq __b8
    jsr mode_mcchar
    rts
  __b8:
    ldy #KEY_4
    jsr keyboard_key_pressed
    cmp #0
    beq __b9
    jsr mode_stdbitmap
    rts
  __b9:
    ldy #KEY_6
    jsr keyboard_key_pressed
    cmp #0
    beq __b10
    jsr mode_hicolstdchar
    rts
  __b10:
    ldy #KEY_7
    jsr keyboard_key_pressed
    cmp #0
    beq __b11
    jsr mode_hicolecmchar
    rts
  __b11:
    ldy #KEY_8
    jsr keyboard_key_pressed
    cmp #0
    beq __b12
    jsr mode_hicolmcchar
    rts
  __b12:
    ldy #KEY_A
    jsr keyboard_key_pressed
    cmp #0
    beq __b13
    jsr mode_sixsfred2
    rts
  __b13:
    ldy #KEY_B
    jsr keyboard_key_pressed
    cmp #0
    beq __b14
    jsr mode_twoplanebitmap
    rts
  __b14:
    ldy #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq __b15
    jsr mode_sixsfred
    rts
  __b15:
    ldy #KEY_D
    jsr keyboard_key_pressed
    cmp #0
    beq __b16
    jsr mode_8bpppixelcell
    rts
  __b16:
    ldy #KEY_E
    jsr keyboard_key_pressed
    cmp #0
    bne !__b5+
    jmp __b5
  !__b5:
    jsr mode_8bppchunkybmm
    rts
  __b3:
    lda #LIGHT_GREEN
    ldy #0
    sta (c),y
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b2
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
    .label __7 = 9
    .label gfxb = $b
    .label x = 4
    .label y = $d
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_COLORRAM_OFF
    sta DTV_CONTROL
    // VIC Graphics Mode
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    // Linear Graphics Plane B Counter
    lda #<PLANEB&$ffff
    sta DTV_PLANEB_START_LO
    lda #>PLANEB&$ffff
    sta DTV_PLANEB_START_MI
    lda #<PLANEB>>$10
    sta DTV_PLANEB_START_HI
    lda #8
    sta DTV_PLANEB_STEP
    lda #0
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    // Border color
    sta BORDERCOL
    tax
  // DTV Palette - Grey Tones
  __b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
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
    lda.z gfxb+1
    cmp #>$8000
    bne __b5
    lda.z gfxb
    cmp #<$8000
    bne __b5
    txa
    jsr dtvSetCpuBankSegment1
    inx
    lda #<$4000
    sta.z gfxb
    lda #>$4000
    sta.z gfxb+1
  __b5:
    lda.z y
    clc
    adc.z x
    sta.z __7
    lda #0
    adc.z x+1
    sta.z __7+1
    lda.z __7
    ldy #0
    sta (gfxb),y
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
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
    inc.z y
    lda #$c8
    cmp.z y
    bne __b3
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_COLORRAM_OFF
    sta.z dtv_control
    jsr mode_ctrl
    rts
}
// Allow the user to control the DTV graphics using different keys
mode_ctrl: {
  __b1:
  // Wait for the raster
  __b2:
    lda #$ff
    cmp RASTER
    bne __b2
    ldy #KEY_SPACE
    jsr keyboard_key_pressed
    cmp #0
    beq __b4
    rts
  __b4:
    // Read the current control byte
    ldx.z dtv_control
    ldy #KEY_L
    jsr keyboard_key_pressed
    cmp #0
    beq __b5
    txa
    ora #DTV_LINEAR
    tax
  __b5:
    ldy #KEY_H
    jsr keyboard_key_pressed
    cmp #0
    beq __b6
    txa
    ora #DTV_HIGHCOLOR
    tax
  __b6:
    ldy #KEY_O
    jsr keyboard_key_pressed
    cmp #0
    beq __b7
    txa
    ora #DTV_OVERSCAN
    tax
  __b7:
    ldy #KEY_B
    jsr keyboard_key_pressed
    cmp #0
    beq __b8
    txa
    ora #DTV_BORDER_OFF
    tax
  __b8:
    ldy #KEY_U
    jsr keyboard_key_pressed
    cmp #0
    beq __b9
    txa
    ora #DTV_CHUNKY
    tax
  __b9:
    ldy #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq __b10
    txa
    ora #DTV_COLORRAM_OFF
    tax
  __b10:
    ldy #KEY_0
    jsr keyboard_key_pressed
    cmp #0
    beq __b11
    ldx #0
  __b11:
    cpx.z dtv_control
    beq __b1
    stx.z dtv_control
    stx DTV_CONTROL
    stx BORDERCOL
    jmp __b1
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
// keyboard_key_pressed(byte register(Y) key)
keyboard_key_pressed: {
    .label colidx = 6
    tya
    and #7
    sta.z colidx
    tya
    lsr
    lsr
    lsr
    tay
    jsr keyboard_matrix_read
    ldy.z colidx
    and keyboard_matrix_col_bitmask,y
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
// keyboard_matrix_read(byte register(Y) rowid)
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,y
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
// Set the memory pointed to by CPU BANK 1 SEGMENT ($4000-$7fff)
// This sets which actual memory is addressed when the CPU reads/writes to $4000-$7fff
// The actual memory addressed will be $4000*cpuSegmentIdx
// dtvSetCpuBankSegment1(byte register(A) cpuBankIdx)
dtvSetCpuBankSegment1: {
    // Move CPU BANK 1 SEGMENT ($4000-$7fff)
    .label cpuBank = $ff
    sta cpuBank
    .byte $32, $dd
    lda.z $ff
    .byte $32, $00
    rts
}
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
    .label __3 = $e
    // Screen Chars for Plane A (screen) - 16x16 repeating
    .label gfxa = $b
    .label ay = $d
    .label bits = 6
    .label chargen = 4
    .label gfxb = 9
    .label col = 7
    .label cr = 3
    .label ch = 2
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY
    sta DTV_CONTROL
    // VIC Graphics Mode
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    // Linear Graphics Plane A Counter
    lda #0
    sta DTV_PLANEA_START_LO
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    // Linear Graphics Plane B Counter
    sta DTV_PLANEB_START_LO
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    sta DTV_PLANEB_STEP
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    // Border color
    sta BORDERCOL
    tax
  // DTV Palette - Grey Tones
  __b1:
    txa
    sta DTV_PALETTE,x
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
    lda #$f
    and.z ay
    asl
    asl
    asl
    asl
    sta.z __3
    txa
    and #$f
    ora.z __3
    ldy #0
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    inx
    cpx #$28
    bne __b3
    inc.z ay
    lda #$19
    cmp.z ay
    bne __b2
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
    ldy #0
    lda (chargen),y
    sta.z bits
    inc.z chargen
    bne !+
    inc.z chargen+1
  !:
    ldx #0
  __b8:
    lda #$80
    and.z bits
    cmp #0
    beq b1
    lda.z col
    jmp __b9
  b1:
    lda #0
  __b9:
    ldy #0
    sta (gfxb),y
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    asl.z bits
    inc.z col
    inx
    cpx #8
    bne __b8
    inc.z cr
    lda #8
    cmp.z cr
    bne __b7
    inc.z ch
    lda.z ch
    cmp #0
    bne __b6
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY
    sta.z dtv_control
    jsr mode_ctrl
    rts
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
    .label col = 4
    .label cy = $d
    // Graphics for Plane A () - horizontal stripes every 2 pixels
    .label gfxa = 9
    .label ay = 2
    // Graphics for Plane B - vertical stripes every 2 pixels
    .label gfxb = $b
    .label by = 3
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta DTV_CONTROL
    // VIC Graphics Mode
    lda #VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    // Linear Graphics Plane A Counter
    lda #0
    sta DTV_PLANEA_START_LO
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    // Linear Graphics Plane B Counter
    sta DTV_PLANEB_START_LO
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    lda #1
    sta DTV_PLANEB_STEP
    lda #0
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    tax
  // DTV Palette - Grey Tones
  __b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BORDERCOL
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    txa
    clc
    adc.z cy
    and #$f
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    inx
    cpx #$28
    bne __b4
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
    lda.z ay
    lsr
    and #3
    tay
    lda row_bitmask,y
    ldy #0
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    inx
    cpx #$28
    bne __b7
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
    lda #$1b
    ldy #0
    sta (gfxb),y
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    inx
    cpx #$28
    bne __b10
    inc.z by
    lda #$c8
    cmp.z by
    bne __b9
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta.z dtv_control
    jsr mode_ctrl
    rts
    row_bitmask: .byte 0, $55, $aa, $ff
}
// Two Plane Bitmap - generated from the two DTV linear graphics plane counters
// Two Plane Bitmap Mode (CHUNK/COLDIS/MCM = 0, ECM/BMM/HICOL/LINEAR = 1)
// Resolution: 320x200
// Linear Adressing
// GfxData/PlaneA Pixel Shifter (1), CharData/PlaneB Pixel Shifter (1):
// - Plane A = 0 Plane B = 0: 8bpp BgColor0[7:0]
// - Plane A = 0 Plane B = 1: 8bpp "0000" & ColorData[7:4]
// - Plane A = 1 Plane B = 0: 8bpp "0000" & ColorData[3:0]
// - Plane A = 1 Plane B = 1: 8bpp BgColor1[7:0]
mode_twoplanebitmap: {
    .label PLANEA = $4000
    .label PLANEB = $6000
    .label COLORS = $8000
    .label __3 = $e
    // Color for bits 11
    // Colors for bits 01 / 10
    .label col = $b
    .label cy = 6
    // Graphics for Plane A - horizontal stripes
    .label gfxa = 9
    .label ay = 7
    // Graphics for Plane B - vertical stripes
    .label gfxb = 4
    .label by = 2
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta DTV_CONTROL
    // VIC Graphics Mode
    lda #VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    // Linear Graphics Plane A Counter
    lda #0
    sta DTV_PLANEA_START_LO
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    // Linear Graphics Plane B Counter
    sta DTV_PLANEB_START_LO
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    lda #1
    sta DTV_PLANEB_STEP
    lda #0
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    tax
  // DTV Palette - Grey Tones
  __b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BORDERCOL
    lda #$70
    sta BGCOL1
    // Color for bits 00
    lda #$d4
    sta BGCOL2
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    lda #$f
    and.z cy
    asl
    asl
    asl
    asl
    sta.z __3
    txa
    and #$f
    ora.z __3
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    inx
    cpx #$28
    bne __b4
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
    lda #4
    and.z ay
    cmp #0
    beq __b8
    lda #$ff
    ldy #0
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
  __b9:
    inx
    cpx #$28
    bne __b7
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
    lda #$f
    ldy #0
    sta (gfxb),y
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    inx
    cpx #$28
    bne __b13
    inc.z by
    lda #$c8
    cmp.z by
    bne __b12
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta.z dtv_control
    jsr mode_ctrl
    rts
  __b8:
    lda #0
    tay
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    jmp __b9
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
    .label __3 = 7
    // Colors for high 4 bits of 8bpp
    .label col = 9
    .label cy = 2
    // Graphics for Plane A () - horizontal stripes every 2 pixels
    .label gfxa = 4
    .label ay = 3
    // Graphics for Plane B - vertical stripes every 2 pixels
    .label gfxb = $b
    .label by = 6
    lda #DTV_LINEAR
    sta DTV_CONTROL
    // VIC Graphics Mode
    lda #VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    // Linear Graphics Plane A Counter
    lda #0
    sta DTV_PLANEA_START_LO
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    // Linear Graphics Plane B Counter
    sta DTV_PLANEB_START_LO
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    lda #1
    sta DTV_PLANEB_STEP
    lda #0
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    tax
  // DTV Palette - Grey Tones
  __b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BORDERCOL
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    txa
    and #3
    asl
    asl
    asl
    asl
    sta.z __3
    lda #3
    and.z cy
    ora.z __3
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    inx
    cpx #$28
    bne __b4
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
    lda.z ay
    lsr
    and #3
    tay
    lda row_bitmask,y
    ldy #0
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    inx
    cpx #$28
    bne __b7
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
    lda #$1b
    ldy #0
    sta (gfxb),y
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    inx
    cpx #$28
    bne __b10
    inc.z by
    lda #$c8
    cmp.z by
    bne __b9
    lda #DTV_LINEAR
    sta.z dtv_control
    jsr mode_ctrl
    rts
    row_bitmask: .byte 0, $55, $aa, $ff
}
// High Color Multicolor Character Mode (LINEAR/CHUNK/COLDIS/BMM/ECM = 0, MCM/HICOL = 1)
// Resolution: 160x200 (320x200)
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
//GfxData Pixel Shifter (1) if ColorData[3:3] = 0:
// - 0: 8bpp BgColor0[7:0]
// - 1: 8bpp ColorData[7:4] "0" & Color[2:0]
//GfxData Pixel Shifter (2) if ColorData[3:3] = 1:
// - 00: 8bpp BgColor0[7:0]
// - 01: 8bpp BgColor1[7:0]
// - 10: 8bpp BgColor2[7:0]
// - 11: 8bpp ColorData[7:4] "0" & Color[2:0]
mode_hicolmcchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $8400
    .label __3 = 7
    // Char Colors and screen chars
    .label col = $b
    .label ch = 4
    .label cy = 3
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    lda #DTV_HIGHCOLOR
    sta DTV_CONTROL
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL|VIC_MCM
    sta VIC_CONTROL2
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  // DTV Palette - Grey Tones
  __b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BORDERCOL
    lda #$50
    sta BGCOL1
    lda #$54
    sta BGCOL2
    lda #$58
    sta BGCOL3
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
    lda #$f
    and.z cy
    asl
    asl
    asl
    asl
    sta.z __3
    txa
    and #$f
    ora.z __3
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b4
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #DTV_HIGHCOLOR
    sta.z dtv_control
    jsr mode_ctrl
    rts
}
// High Color Extended Background Color Character Mode (LINEAR/CHUNK/COLDIS/MCM/BMM = 0, ECM/HICOL = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & "00" & CharData[5:0] & RowCounter[2:0] )
// GfxData Pixel Shifter (1)
//  - 0: 8bpp Background Color
//    - CharData[7:6] 00: 8bpp BgColor0[7:0]
//    - CharData[7:6] 01: 8bpp BgColor1[7:0]
//    - CharData[7:6] 10: 8bpp BgColor2[7:0]
//    - CharData[7:6] 11: 8bpp BgColor3[7:0]
//  - 1: 8bpp ColorData[7:0]
mode_hicolecmchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $8400
    .label __3 = 8
    // Char Colors and screen chars
    .label col = 4
    .label ch = $b
    .label cy = 6
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    lda #DTV_HIGHCOLOR
    sta DTV_CONTROL
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VIC_DEN|VIC_RSEL|VIC_ECM|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  // DTV Palette - Grey Tones
  __b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BORDERCOL
    lda #$50
    sta BGCOL1
    lda #$54
    sta BGCOL2
    lda #$58
    sta BGCOL3
    lda #$5c
    sta BGCOL4
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
    lda #$f
    and.z cy
    asl
    asl
    asl
    asl
    sta.z __3
    txa
    and #$f
    ora.z __3
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b4
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #DTV_HIGHCOLOR
    sta.z dtv_control
    jsr mode_ctrl
    rts
}
// High Color Standard Character Mode (LINEAR/CHUNK/COLDIS/ECM/MCM/BMM = 0, HICOL = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
// Pixel Shifter (1)
//  - 0: 8bpp BgColor0[7:0]
//  - 1: 8bpp ColorData[7:0]
mode_hicolstdchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $8400
    .label __3 = 8
    // Char Colors and screen chars
    .label col = $b
    .label ch = 9
    .label cy = 7
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // DTV Color Bank
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    lda #DTV_HIGHCOLOR
    sta DTV_CONTROL
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  // DTV Palette - Grey Tones
  __b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BGCOL
    sta BORDERCOL
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
    lda #$f
    and.z cy
    asl
    asl
    asl
    asl
    sta.z __3
    txa
    and #$f
    ora.z __3
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b4
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #DTV_HIGHCOLOR
    sta.z dtv_control
    jsr mode_ctrl
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
    .label SCREEN = $4000
    .label BITMAP = $6000
    .const lines_cnt = 9
    .label col2 = $d
    // Bitmap Colors
    .label ch = 9
    .label cy = 7
    .label l = $e
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    sta DTV_CONTROL
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^BITMAP/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    // VIC Memory Pointers
    lda #(BITMAP&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #BLACK
    sta BGCOL
    sta BORDERCOL
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #0
    sta.z cy
  __b3:
    ldx #0
  __b4:
    txa
    clc
    adc.z cy
    and #$f
    tay
    tya
    eor #$ff
    clc
    adc #$f+1
    sta.z col2
    tya
    asl
    asl
    asl
    asl
    ora.z col2
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b4
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    jsr bitmap_init
    jsr bitmap_clear
    lda #0
    sta.z l
  __b7:
    lda.z l
    cmp #lines_cnt
    bcc __b8
    lda #0
    sta.z dtv_control
    jsr mode_ctrl
    rts
  __b8:
    ldy.z l
    lda lines_x,y
    sta.z bitmap_line.x0
    ldx lines_x+1,y
    lda lines_y,y
    sta.z bitmap_line.y0
    lda lines_y+1,y
    sta.z bitmap_line.y1
    jsr bitmap_line
    inc.z l
    jmp __b7
    lines_x: .byte 0, $ff, $ff, 0, 0, $80, $ff, $80, 0, $80
    lines_y: .byte 0, 0, $c7, $c7, 0, 0, $64, $c7, $64, 0
}
// Draw a line on the bitmap
// bitmap_line(byte zp(6) x0, byte register(X) x1, byte zp(8) y0, byte zp(3) y1)
bitmap_line: {
    .label xd = 7
    .label x0 = 6
    .label y0 = 8
    .label y1 = 3
    txa
    cmp.z x0
    beq !+
    bcs __b1
  !:
    txa
    eor #$ff
    sec
    adc.z x0
    sta.z xd
    lda.z y0
    cmp.z y1
    bcc __b7
    sec
    sbc.z y1
    tay
    cpy.z xd
    bcc __b8
    lda.z y1
    sta.z bitmap_line_ydxi.y
    lda.z y0
    sta.z bitmap_line_ydxi.y1
    sty.z bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
    rts
  __b8:
    stx.z bitmap_line_xdyi.x
    lda.z y1
    sta.z bitmap_line_xdyi.y
    sty.z bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    rts
  __b7:
    lda.z y1
    sec
    sbc.z y0
    tay
    cpy.z xd
    bcc __b9
    lda.z y0
    sta.z bitmap_line_ydxd.y
    ldx.z x0
    lda.z y1
    sta.z bitmap_line_ydxd.y1
    sty.z bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    rts
  __b9:
    stx.z bitmap_line_xdyd.x
    lda.z y1
    sta.z bitmap_line_xdyd.y
    sty.z bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    rts
  __b1:
    txa
    sec
    sbc.z x0
    sta.z xd
    lda.z y0
    cmp.z y1
    bcc __b11
    sec
    sbc.z y1
    tay
    cpy.z xd
    bcc __b12
    lda.z y1
    sta.z bitmap_line_ydxd.y
    sty.z bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    rts
  __b12:
    lda.z x0
    sta.z bitmap_line_xdyd.x
    stx.z bitmap_line_xdyd.x1
    sty.z bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    rts
  __b11:
    lda.z y1
    sec
    sbc.z y0
    tay
    cpy.z xd
    bcc __b13
    lda.z y0
    sta.z bitmap_line_ydxi.y
    ldx.z x0
    sty.z bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
    rts
  __b13:
    lda.z x0
    sta.z bitmap_line_xdyi.x
    stx.z bitmap_line_xdyi.x1
    sty.z bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    rts
}
// bitmap_line_xdyi(byte zp(2) x, byte zp(8) y, byte zp(6) x1, byte zp(7) xd, byte zp($d) yd)
bitmap_line_xdyi: {
    .label x = 2
    .label y = 8
    .label x1 = 6
    .label xd = 7
    .label yd = $d
    .label e = 3
    lda.z yd
    lsr
    sta.z e
  __b1:
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    inc.z x
    lda.z e
    clc
    adc.z yd
    sta.z e
    lda.z xd
    cmp.z e
    bcs __b2
    inc.z y
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    ldx.z x1
    inx
    cpx.z x
    bne __b1
    rts
}
// bitmap_plot(byte register(X) x, byte register(Y) y)
bitmap_plot: {
    .label plotter_x = 9
    .label plotter_y = $b
    .label plotter = 9
    lda bitmap_plot_xhi,x
    sta.z plotter_x+1
    lda bitmap_plot_xlo,x
    sta.z plotter_x
    lda bitmap_plot_yhi,y
    sta.z plotter_y+1
    lda bitmap_plot_ylo,y
    sta.z plotter_y
    lda.z plotter
    clc
    adc.z plotter_y
    sta.z plotter
    lda.z plotter+1
    adc.z plotter_y+1
    sta.z plotter+1
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// bitmap_line_ydxi(byte zp(2) y, byte register(X) x, byte zp(3) y1, byte zp($d) yd, byte zp(7) xd)
bitmap_line_ydxi: {
    .label y = 2
    .label y1 = 3
    .label yd = $d
    .label xd = 7
    .label e = 6
    lda.z xd
    lsr
    sta.z e
  __b1:
    ldy.z y
    jsr bitmap_plot
    inc.z y
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda.z yd
    cmp.z e
    bcs __b2
    inx
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    lda.z y1
    clc
    adc #1
    cmp.z y
    bne __b1
    rts
}
// bitmap_line_xdyd(byte zp(2) x, byte zp(8) y, byte zp(6) x1, byte zp(7) xd, byte zp($d) yd)
bitmap_line_xdyd: {
    .label x = 2
    .label y = 8
    .label x1 = 6
    .label xd = 7
    .label yd = $d
    .label e = 3
    lda.z yd
    lsr
    sta.z e
  __b1:
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    inc.z x
    lda.z e
    clc
    adc.z yd
    sta.z e
    lda.z xd
    cmp.z e
    bcs __b2
    dec.z y
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    ldx.z x1
    inx
    cpx.z x
    bne __b1
    rts
}
// bitmap_line_ydxd(byte zp(2) y, byte register(X) x, byte zp(8) y1, byte zp($d) yd, byte zp(7) xd)
bitmap_line_ydxd: {
    .label y = 2
    .label y1 = 8
    .label yd = $d
    .label xd = 7
    .label e = 3
    lda.z xd
    lsr
    sta.z e
  __b1:
    ldy.z y
    jsr bitmap_plot
    inc.z y
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda.z yd
    cmp.z e
    bcs __b2
    dex
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    lda.z y1
    clc
    adc #1
    cmp.z y
    bne __b1
    rts
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = 9
    .label y = $e
    lda bitmap_plot_xlo
    sta.z bitmap
    lda bitmap_plot_xhi
    sta.z bitmap+1
    lda #0
    sta.z y
  __b1:
    ldx #0
  __b2:
    lda #0
    tay
    sta (bitmap),y
    inc.z bitmap
    bne !+
    inc.z bitmap+1
  !:
    inx
    cpx #$c8
    bne __b2
    inc.z y
    lda #$28
    cmp.z y
    bne __b1
    rts
}
// Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .label __10 = $d
    .label yoffs = 9
    ldy #$80
    ldx #0
  __b1:
    txa
    and #$f8
    sta bitmap_plot_xlo,x
    lda #>mode_stdbitmap.BITMAP
    sta bitmap_plot_xhi,x
    tya
    sta bitmap_plot_bit,x
    tya
    lsr
    tay
    cpy #0
    bne __b2
    ldy #$80
  __b2:
    inx
    cpx #0
    bne __b1
    lda #<0
    sta.z yoffs
    sta.z yoffs+1
    tax
  __b3:
    lda #7
    sax.z __10
    lda.z yoffs
    ora.z __10
    sta bitmap_plot_ylo,x
    lda.z yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp.z __10
    bne __b4
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    inx
    cpx #0
    bne __b3
    rts
}
// Multicolor Character Mode (LINEAR/HICOL/CHUNK/COLDIS/BMM/ECM = 0, MCM = 1)
// Resolution: 160x200 (320x200)
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
// GfxData Pixel Shifter (1) if ColorData[3:3] = 0:
//  - 0: 4bpp BgColor0[3:0]
//  - 1: 4bpp ColorData[2:0]
// GfxData Pixel Shifter (2) if ColorData[3:3] = 1:
//  - 00: 4bpp BgColor0[3:0]
//  - 01: 4bpp BgColor1[3:0]
//  - 10: 4bpp BgColor2[3:0]
//  - 11: 4bpp ColorData[2:0]// Standard Character Mode (LINEAR/HICOL/CHUNK/COLDIS/ECM/MCM/BMM = 0)
mode_mcchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $d800
    .label __5 = $d
    // Char Colors and screen chars
    .label col = $b
    .label ch = 4
    .label cy = 7
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    sta DTV_CONTROL
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL|VIC_MCM
    sta VIC_CONTROL2
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BORDERCOL
    lda #BLACK
    sta BGCOL1
    lda #GREEN
    sta BGCOL2
    lda #BLUE
    sta BGCOL3
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
    txa
    clc
    adc.z cy
    and #$f
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    lda #$f
    and.z cy
    asl
    asl
    asl
    asl
    sta.z __5
    txa
    and #$f
    ora.z __5
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b4
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #0
    sta.z dtv_control
    jsr mode_ctrl
    rts
}
// Extended Background Color Character Mode (LINEAR/HICOL/CHUNK/COLDIS/MCM/BMM = 0, ECM = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & "00" & CharData[5:0] & RowCounter[2:0] ) 
// GfxData Pixel Shifter (1)
//  - 0: 4bpp Background Color
//    - CharData[7:6] 00: 4bpp BgColor0[3:0]
//    - CharData[7:6] 01: 4bpp BgColor1[3:0]
//    - CharData[7:6] 10: 4bpp BgColor2[3:0]
//    - CharData[7:6] 11: 4bpp BgColor3[3:0]
//  - 1: 4bpp ColorData[3:0]
mode_ecmchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $d800
    .label __5 = $d
    // Char Colors and screen chars
    .label col = $b
    .label ch = 4
    .label cy = 8
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    sta DTV_CONTROL
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VIC_DEN|VIC_RSEL|VIC_ECM|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BORDERCOL
    sta BGCOL1
    lda #2
    sta BGCOL2
    lda #5
    sta BGCOL3
    lda #6
    sta BGCOL4
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
    txa
    clc
    adc.z cy
    and #$f
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    lda #$f
    and.z cy
    asl
    asl
    asl
    asl
    sta.z __5
    txa
    and #$f
    ora.z __5
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b4
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #0
    sta.z dtv_control
    jsr mode_ctrl
    rts
}
// Standard Character Mode (LINEAR/HICOL/CHUNK/COLDIS/ECM/MCM/BMM = 0)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
// Pixel Shifter (1)
// - 0: 4bpp BgColor0[3:0]
// - 1: 4bpp ColorData[3:0]
mode_stdchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    // Charset ROM
    .label COLORS = $d800
    .label __5 = $e
    // Char Colors and screen chars
    .label col = $b
    .label ch = 4
    .label cy = 6
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    sta DTV_CONTROL
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // VIC Graphics Mode
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    // VIC Memory Pointers
    lda #(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  // DTV Palette - default
  __b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BGCOL
    sta BORDERCOL
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
    txa
    clc
    adc.z cy
    and #$f
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    lda #$f
    and.z cy
    asl
    asl
    asl
    asl
    sta.z __5
    txa
    and #$f
    ora.z __5
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b4
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b3
    lda #0
    sta.z dtv_control
    jsr mode_ctrl
    rts
}
// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
// print_str_lines(byte* zp($b) str)
print_str_lines: {
    .label str = $b
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
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (str),y
    inc.z str
    bne !+
    inc.z str+1
  !:
    cmp #0
    beq __b3
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
  __b3:
    cmp #0
    bne __b2
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
}
// Print a newline
print_ln: {
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = menu.SCREEN
    .label end = str+num
    .label dst = 9
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    rts
  __b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Set the screen to print on. Also resets current line/char cursor.
print_set_screen: {
    rts
}
  // Default vallues for the palette
  DTV_PALETTE_DEFAULT: .byte 0, $f, $36, $be, $58, $db, $86, $ff, $29, $26, $3b, 5, 7, $df, $9a, $a
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  // Tables for the plotter - initialized by calling bitmap_draw_init();
  bitmap_plot_xlo: .fill $100, 0
  bitmap_plot_xhi: .fill $100, 0
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  MENU_TEXT: .text "C64DTV Graphics Modes            CCLHBME@                                 OHIIMCC@                                 LUNCMMM@----------------------------------------@1. Standard Char             (V) 0000000@2. Extended Color Char       (V) 0000001@3. Multicolor Char           (V) 0000010@4. Standard Bitmap           (V) 0000100@5. Multicolor Bitmap         (V) 0000110@6. High Color Standard Char  (H) 0001000@7. High Extended Color Char  (H) 0001001@8. High Multicolor Char      (H) 0001010@9. High Multicolor Bitmap    (H) 0001110@a. Sixs Fred 2               (D) 0010111@b. Two Plane Bitmap          (D) 0011101@c. Sixs Fred (2 Plane MC BM) (D) 0011111@d. 8bpp Pixel Cell           (D) 0111011@e. Chunky 8bpp Bitmap        (D) 1111011@----------------------------------------@    (V) vicII (H) vicII+hicol (D) c64dtv@"
  .byte 0
