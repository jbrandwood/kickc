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
  .const PROCPORT_RAM_IO = $35
  // RAM in $A000, $E000 CHAR ROM in $D000
  .const PROCPORT_RAM_CHARROM = $31
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
  .label print_char_cursor = 5
  .label dtv_control = 4
  .label print_line_cursor = $d
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
  b1:
    jsr menu
    jmp b1
}
menu: {
    .label SCREEN = $8000
    .label CHARSET = $9800
    .label c = 2
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
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #<COLS
    sta c
    lda #>COLS
    sta c+1
  // Char Colors
  b2:
    lda #LIGHT_GREEN
    ldy #0
    sta (c),y
    inc c
    bne !+
    inc c+1
  !:
    lda c+1
    cmp #>COLS+$3e8
    bne b2
    lda c
    cmp #<COLS+$3e8
    bne b2
    // Screen colors
    lda #0
    sta BGCOL
    sta BORDERCOL
    jsr print_set_screen
    jsr print_cls
    jsr print_str_lines
  b4:
    ldy #KEY_1
    jsr keyboard_key_pressed
    cmp #0
    beq b5
    jsr mode_stdchar
    rts
  b5:
    ldy #KEY_2
    jsr keyboard_key_pressed
    cmp #0
    beq b6
    jsr mode_ecmchar
    rts
  b6:
    ldy #KEY_3
    jsr keyboard_key_pressed
    cmp #0
    beq b7
    jsr mode_mcchar
    rts
  b7:
    ldy #KEY_4
    jsr keyboard_key_pressed
    cmp #0
    beq b8
    jsr mode_stdbitmap
    rts
  b8:
    ldy #KEY_6
    jsr keyboard_key_pressed
    cmp #0
    beq b9
    jsr mode_hicolstdchar
    rts
  b9:
    ldy #KEY_7
    jsr keyboard_key_pressed
    cmp #0
    beq b10
    jsr mode_hicolecmchar
    rts
  b10:
    ldy #KEY_8
    jsr keyboard_key_pressed
    cmp #0
    beq b11
    jsr mode_hicolmcchar
    rts
  b11:
    ldy #KEY_A
    jsr keyboard_key_pressed
    cmp #0
    beq b12
    jsr mode_sixsfred2
    rts
  b12:
    ldy #KEY_B
    jsr keyboard_key_pressed
    cmp #0
    beq b13
    jsr mode_twoplanebitmap
    rts
  b13:
    ldy #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq b14
    jsr mode_sixsfred
    rts
  b14:
    ldy #KEY_D
    jsr keyboard_key_pressed
    cmp #0
    beq b15
    jsr mode_8bpppixelcell
    rts
  b15:
    ldy #KEY_E
    jsr keyboard_key_pressed
    cmp #0
    bne !b4+
    jmp b4
  !b4:
    jsr mode_8bppchunkybmm
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
    .label _27 = $d
    .label gfxb = 5
    .label x = 2
    .label y = 4
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_COLORRAM_OFF
    sta DTV_CONTROL
    // VIC Graphics Mode
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    // Linear Graphics Plane B Counter
    lda #0
    sta DTV_PLANEB_START_LO
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
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #PLANEB/$4000
    jsr dtvSetCpuBankSegment1
    ldx #PLANEB/$4000+1
    lda #0
    sta y
    lda #<$4000
    sta gfxb
    lda #>$4000
    sta gfxb+1
  b3:
    lda #0
    sta x
    sta x+1
  b4:
    lda gfxb+1
    cmp #>$8000
    bne b5
    lda gfxb
    cmp #<$8000
    bne b5
    txa
    jsr dtvSetCpuBankSegment1
    inx
    lda #<$4000
    sta gfxb
    lda #>$4000
    sta gfxb+1
  b5:
    lda y
    clc
    adc x
    sta _27
    lda #0
    adc x+1
    sta _27+1
    lda _27
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    inc x
    bne !+
    inc x+1
  !:
    lda x+1
    cmp #>$140
    bne b4
    lda x
    cmp #<$140
    bne b4
    inc y
    lda #$c8
    cmp y
    bne b3
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_COLORRAM_OFF
    sta dtv_control
    jsr mode_ctrl
    rts
}
// Allow the user to control the DTV graphics using different keys
mode_ctrl: {
  b1:
  // Wait for the raster
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    ldy #KEY_SPACE
    jsr keyboard_key_pressed
    cmp #0
    beq b4
    rts
  b4:
    // Read the current control byte
    ldx dtv_control
    ldy #KEY_L
    jsr keyboard_key_pressed
    cmp #0
    beq b5
    txa
    ora #DTV_LINEAR
    tax
  b5:
    ldy #KEY_H
    jsr keyboard_key_pressed
    cmp #0
    beq b6
    txa
    ora #DTV_HIGHCOLOR
    tax
  b6:
    ldy #KEY_O
    jsr keyboard_key_pressed
    cmp #0
    beq b7
    txa
    ora #DTV_OVERSCAN
    tax
  b7:
    ldy #KEY_B
    jsr keyboard_key_pressed
    cmp #0
    beq b8
    txa
    ora #DTV_BORDER_OFF
    tax
  b8:
    ldy #KEY_U
    jsr keyboard_key_pressed
    cmp #0
    beq b9
    txa
    ora #DTV_CHUNKY
    tax
  b9:
    ldy #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq b10
    txa
    ora #DTV_COLORRAM_OFF
    tax
  b10:
    ldy #KEY_0
    jsr keyboard_key_pressed
    cmp #0
    beq b11
    ldx #0
  b11:
    cpx dtv_control
    beq b1
    stx dtv_control
    stx DTV_CONTROL
    stx BORDERCOL
    jmp b1
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
// keyboard_key_pressed(byte register(Y) key)
keyboard_key_pressed: {
    .label colidx = 7
    tya
    and #7
    sta colidx
    tya
    lsr
    lsr
    lsr
    tay
    jsr keyboard_matrix_read
    ldy colidx
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
    lda $ff
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
    .label _15 = 7
    .label gfxa = 2
    .label ay = 4
    .label bits = 8
    .label chargen = 2
    .label gfxb = 5
    .label col = 9
    .label cr = 7
    .label ch = 4
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
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #<PLANEA
    sta gfxa
    lda #>PLANEA
    sta gfxa+1
    lda #0
    sta ay
  b2:
    ldx #0
  b3:
    lda #$f
    and ay
    asl
    asl
    asl
    asl
    sta _15
    txa
    and #$f
    ora _15
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    inx
    cpx #$28
    bne b3
    inc ay
    lda #$19
    cmp ay
    bne b2
    // 8bpp cells for Plane B (charset) - ROM charset with 256 colors
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    lda #0
    sta ch
    sta col
    lda #<PLANEB
    sta gfxb
    lda #>PLANEB
    sta gfxb+1
    lda #<CHARGEN
    sta chargen
    lda #>CHARGEN
    sta chargen+1
  b6:
    lda #0
    sta cr
  b7:
    ldy #0
    lda (chargen),y
    sta bits
    inc chargen
    bne !+
    inc chargen+1
  !:
    ldx #0
  b8:
    lda #$80
    and bits
    cmp #0
    beq b4
    lda col
    jmp b9
  b4:
    lda #0
  b9:
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    asl bits
    inc col
    inx
    cpx #8
    bne b8
    inc cr
    lda #8
    cmp cr
    bne b7
    inc ch
    lda ch
    cmp #0
    bne b6
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY
    sta dtv_control
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
    .label col = 2
    .label cy = 4
    .label gfxa = 2
    .label ay = 4
    .label gfxb = 2
    .label by = 4
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
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    // Screen colors
    lda #0
    sta BORDERCOL
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    txa
    clc
    adc cy
    and #$f
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    lda #<PLANEA
    sta gfxa
    lda #>PLANEA
    sta gfxa+1
    lda #0
    sta ay
  b6:
    ldx #0
  b7:
    lda ay
    lsr
    and #3
    tay
    lda row_bitmask,y
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    inx
    cpx #$28
    bne b7
    inc ay
    lda #$c8
    cmp ay
    bne b6
    lda #0
    sta by
    lda #<PLANEB
    sta gfxb
    lda #>PLANEB
    sta gfxb+1
  b9:
    ldx #0
  b10:
    lda #$1b
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    inx
    cpx #$28
    bne b10
    inc by
    lda #$c8
    cmp by
    bne b9
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta dtv_control
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
    .label _17 = 7
    .label col = 2
    .label cy = 4
    .label gfxa = 2
    .label ay = 4
    .label gfxb = 2
    .label by = 4
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
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    // Screen colors
    lda #0
    sta BORDERCOL
    lda #$70
    sta BGCOL1
    // Color for bits 00
    lda #$d4
    sta BGCOL2
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _17
    txa
    and #$f
    ora _17
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    lda #<PLANEA
    sta gfxa
    lda #>PLANEA
    sta gfxa+1
    lda #0
    sta ay
  b6:
    ldx #0
  b7:
    lda #4
    and ay
    cmp #0
    beq b8
    lda #$ff
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
  b9:
    inx
    cpx #$28
    bne b7
    inc ay
    lda #$c8
    cmp ay
    bne b6
    lda #0
    sta by
    lda #<PLANEB
    sta gfxb
    lda #>PLANEB
    sta gfxb+1
  b12:
    ldx #0
  b13:
    lda #$f
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    inx
    cpx #$28
    bne b13
    inc by
    lda #$c8
    cmp by
    bne b12
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta dtv_control
    jsr mode_ctrl
    rts
  b8:
    lda #0
    tay
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    jmp b9
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
    .label _16 = 7
    .label col = 2
    .label cy = 4
    .label gfxa = 2
    .label ay = 4
    .label gfxb = 2
    .label by = 4
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
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    // Screen colors
    lda #0
    sta BORDERCOL
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    txa
    and #3
    asl
    asl
    asl
    asl
    sta _16
    lda #3
    and cy
    ora _16
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    lda #<PLANEA
    sta gfxa
    lda #>PLANEA
    sta gfxa+1
    lda #0
    sta ay
  b6:
    ldx #0
  b7:
    lda ay
    lsr
    and #3
    tay
    lda row_bitmask,y
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    inx
    cpx #$28
    bne b7
    inc ay
    lda #$c8
    cmp ay
    bne b6
    lda #0
    sta by
    lda #<PLANEB
    sta gfxb
    lda #>PLANEB
    sta gfxb+1
  b9:
    ldx #0
  b10:
    lda #$1b
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    inx
    cpx #$28
    bne b10
    inc by
    lda #$c8
    cmp by
    bne b9
    lda #DTV_LINEAR
    sta dtv_control
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
    .label _27 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
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
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
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
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _27
    txa
    and #$f
    ora _27
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    lda #DTV_HIGHCOLOR
    sta dtv_control
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
    .label _27 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
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
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
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
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _27
    txa
    and #$f
    ora _27
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    lda #DTV_HIGHCOLOR
    sta dtv_control
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
    .label _26 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
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
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    // Screen colors
    lda #0
    sta BGCOL
    sta BORDERCOL
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _26
    txa
    and #$f
    ora _26
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    lda #DTV_HIGHCOLOR
    sta dtv_control
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
    .label col2 = 7
    .label ch = 2
    .label cy = 4
    .label l = 4
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
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    // Screen colors
    lda #BLACK
    sta BGCOL
    sta BORDERCOL
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    txa
    clc
    adc cy
    and #$f
    tay
    tya
    eor #$ff
    clc
    adc #$f+1
    sta col2
    tya
    asl
    asl
    asl
    asl
    ora col2
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    jsr bitmap_init
    jsr bitmap_clear
    lda #0
    sta l
  b7:
    ldy l
    lda lines_x,y
    sta bitmap_line.x0
    ldx lines_x+1,y
    lda lines_y,y
    sta bitmap_line.y0
    lda lines_y+1,y
    sta bitmap_line.y1
    jsr bitmap_line
    inc l
    lda l
    cmp #lines_cnt
    bcc b7
    lda #0
    sta dtv_control
    jsr mode_ctrl
    rts
    lines_x: .byte 0, $ff, $ff, 0, 0, $80, $ff, $80, 0, $80
    lines_y: .byte 0, 0, $c7, $c7, 0, 0, $64, $c7, $64, 0
}
// Draw a line on the bitmap
// bitmap_line(byte zeropage(9) x0, byte register(X) x1, byte zeropage($b) y0, byte zeropage($c) y1)
bitmap_line: {
    .label xd = 8
    .label x0 = 9
    .label y0 = $b
    .label y1 = $c
    txa
    cmp x0
    beq !+
    bcs b1
  !:
    txa
    eor #$ff
    sec
    adc x0
    sta xd
    lda y0
    cmp y1
    bcc b7
    sec
    sbc y1
    tay
    cpy xd
    bcc b8
    lda y1
    sta bitmap_line_ydxi.y
    lda y0
    sta bitmap_line_ydxi.y1
    sty bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
    rts
  b8:
    stx bitmap_line_xdyi.x
    lda y1
    sta bitmap_line_xdyi.y
    sty bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    rts
  b7:
    lda y1
    sec
    sbc y0
    tay
    cpy xd
    bcc b9
    lda y0
    sta bitmap_line_ydxd.y
    ldx x0
    lda y1
    sta bitmap_line_ydxd.y1
    sty bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    rts
  b9:
    stx bitmap_line_xdyd.x
    lda y1
    sta bitmap_line_xdyd.y
    sty bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    rts
  b1:
    txa
    sec
    sbc x0
    sta xd
    lda y0
    cmp y1
    bcc b11
    sec
    sbc y1
    tay
    cpy xd
    bcc b12
    lda y1
    sta bitmap_line_ydxd.y
    sty bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    rts
  b12:
    lda x0
    sta bitmap_line_xdyd.x
    stx bitmap_line_xdyd.x1
    sty bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    rts
  b11:
    lda y1
    sec
    sbc y0
    tay
    cpy xd
    bcc b13
    lda y0
    sta bitmap_line_ydxi.y
    ldx x0
    sty bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
    rts
  b13:
    lda x0
    sta bitmap_line_xdyi.x
    stx bitmap_line_xdyi.x1
    sty bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    rts
}
// bitmap_line_xdyi(byte zeropage($a) x, byte zeropage($b) y, byte zeropage(9) x1, byte zeropage(8) xd, byte zeropage(7) yd)
bitmap_line_xdyi: {
    .label x = $a
    .label y = $b
    .label x1 = 9
    .label xd = 8
    .label yd = 7
    .label e = $c
    lda yd
    lsr
    sta e
  b1:
    ldx x
    ldy y
    jsr bitmap_plot
    inc x
    lda e
    clc
    adc yd
    sta e
    lda xd
    cmp e
    bcs b2
    inc y
    lda e
    sec
    sbc xd
    sta e
  b2:
    ldx x1
    inx
    cpx x
    bne b1
    rts
}
// bitmap_plot(byte register(X) x, byte register(Y) y)
bitmap_plot: {
    .label plotter_x = 2
    .label plotter_y = 5
    .label plotter = 2
    lda bitmap_plot_xhi,x
    sta plotter_x+1
    lda bitmap_plot_xlo,x
    sta plotter_x
    lda bitmap_plot_yhi,y
    sta plotter_y+1
    lda bitmap_plot_ylo,y
    sta plotter_y
    lda plotter
    clc
    adc plotter_y
    sta plotter
    lda plotter+1
    adc plotter_y+1
    sta plotter+1
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// bitmap_line_ydxi(byte zeropage($a) y, byte register(X) x, byte zeropage($c) y1, byte zeropage(7) yd, byte zeropage(8) xd)
bitmap_line_ydxi: {
    .label y = $a
    .label y1 = $c
    .label yd = 7
    .label xd = 8
    .label e = 9
    lda xd
    lsr
    sta e
  b1:
    ldy y
    jsr bitmap_plot
    inc y
    lda e
    clc
    adc xd
    sta e
    lda yd
    cmp e
    bcs b2
    inx
    lda e
    sec
    sbc yd
    sta e
  b2:
    lda y1
    clc
    adc #1
    cmp y
    bne b1
    rts
}
// bitmap_line_xdyd(byte zeropage($a) x, byte zeropage($b) y, byte zeropage(9) x1, byte zeropage(8) xd, byte zeropage(7) yd)
bitmap_line_xdyd: {
    .label x = $a
    .label y = $b
    .label x1 = 9
    .label xd = 8
    .label yd = 7
    .label e = $c
    lda yd
    lsr
    sta e
  b1:
    ldx x
    ldy y
    jsr bitmap_plot
    inc x
    lda e
    clc
    adc yd
    sta e
    lda xd
    cmp e
    bcs b2
    dec y
    lda e
    sec
    sbc xd
    sta e
  b2:
    ldx x1
    inx
    cpx x
    bne b1
    rts
}
// bitmap_line_ydxd(byte zeropage($a) y, byte register(X) x, byte zeropage($b) y1, byte zeropage(7) yd, byte zeropage(8) xd)
bitmap_line_ydxd: {
    .label y = $a
    .label y1 = $b
    .label yd = 7
    .label xd = 8
    .label e = 9
    lda xd
    lsr
    sta e
  b1:
    ldy y
    jsr bitmap_plot
    inc y
    lda e
    clc
    adc xd
    sta e
    lda yd
    cmp e
    bcs b2
    dex
    lda e
    sec
    sbc yd
    sta e
  b2:
    lda y1
    clc
    adc #1
    cmp y
    bne b1
    rts
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = 2
    .label y = 4
    lda bitmap_plot_xlo
    sta bitmap
    lda bitmap_plot_xhi
    sta bitmap+1
    lda #0
    sta y
  b1:
    ldx #0
  b2:
    lda #0
    tay
    sta (bitmap),y
    inc bitmap
    bne !+
    inc bitmap+1
  !:
    inx
    cpx #$c8
    bne b2
    inc y
    lda #$28
    cmp y
    bne b1
    rts
}
// Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .label _10 = 4
    .label yoffs = 2
    ldy #$80
    ldx #0
  b1:
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
    bne b2
    ldy #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #<0
    sta yoffs
    sta yoffs+1
    tax
  b3:
    lda #7
    sax _10
    lda yoffs
    ora _10
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp _10
    bne b4
    clc
    lda yoffs
    adc #<$28*8
    sta yoffs
    lda yoffs+1
    adc #>$28*8
    sta yoffs+1
  b4:
    inx
    cpx #0
    bne b3
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
    .label _29 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
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
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
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
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    txa
    clc
    adc cy
    and #$f
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _29
    txa
    and #$f
    ora _29
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    lda #0
    sta dtv_control
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
    .label _29 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
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
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
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
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    txa
    clc
    adc cy
    and #$f
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _29
    txa
    and #$f
    ora _29
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    lda #0
    sta dtv_control
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
    .label _28 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
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
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    // Screen colors
    lda #0
    sta BGCOL
    sta BORDERCOL
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b3:
    ldx #0
  b4:
    txa
    clc
    adc cy
    and #$f
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _28
    txa
    and #$f
    ora _28
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b4
    inc cy
    lda #$19
    cmp cy
    bne b3
    lda #0
    sta dtv_control
    jsr mode_ctrl
    rts
}
// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
// print_str_lines(byte* zeropage(2) str)
print_str_lines: {
    .label str = 2
    lda #<menu.SCREEN
    sta print_line_cursor
    lda #>menu.SCREEN
    sta print_line_cursor+1
    lda #<menu.SCREEN
    sta print_char_cursor
    lda #>menu.SCREEN
    sta print_char_cursor+1
    lda #<MENU_TEXT
    sta str
    lda #>MENU_TEXT
    sta str+1
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    inc str
    bne !+
    inc str+1
  !:
    cmp #'@'
    beq b3
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
  b3:
    cmp #'@'
    bne b2
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b1
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
  !:
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    .label sc = 2
    lda #<menu.SCREEN
    sta sc
    lda #>menu.SCREEN
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>menu.SCREEN+$3e8
    bne b1
    lda sc
    cmp #<menu.SCREEN+$3e8
    bne b1
    rts
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
  MENU_TEXT: .text "C64DTV Graphics Modes            CCLHBME@                                 OHIIMCC@                                 LUNCMMM@----------------------------------------@1. Standard Char             (V) 0000000@2. Extended Color Char       (V) 0000001@3. Multicolor Char           (V) 0000010@4. Standard Bitmap           (V) 0000100@5. Multicolor Bitmap         (V) 0000110@6. High Color Standard Char  (H) 0001000@7. High Extended Color Char  (H) 0001001@8. High Multicolor Char      (H) 0001010@9. High Multicolor Bitmap    (H) 0001110@a. Sixs Fred 2               (D) 0010111@b. Two Plane Bitmap          (D) 0011101@c. Sixs Fred (2 Plane MC BM) (D) 0011111@d. 8bpp Pixel Cell           (D) 0111011@e. Chunky 8bpp Bitmap        (D) 1111011@----------------------------------------@    (V) vicII (H) vicII+hicol (D) c64dtv@@"
