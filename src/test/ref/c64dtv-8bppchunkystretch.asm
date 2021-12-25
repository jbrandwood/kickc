// C64DTV 8bpp charmode stretcher
/// @file
/// C64 DTV version 2 Registers and Constants
///
/// Sources
/// (J) https://www.c64-wiki.com/wiki/C64DTV_Programming_Guide
/// (H) http://dtvhacking.cbm8bit.com/dtv_wiki/images/d/d9/Dtv_registers_full.txt
  // Commodore 64 PRG executable file
.file [name="c64dtv-8bppchunkystretch.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// $D011 Control Register #1 Bit#6: ECM Turn Extended Color Mode on/off
  .const VICII_ECM = $40
  /// $D011 Control Register #1  Bit#4: DEN Switch VIC-II output on/off
  .const VICII_DEN = $10
  /// $D011 Control Register #1  Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  .const VICII_RSEL = 8
  /// $D016 Control register #2 Bit#4: MCM Turn Multicolor Mode on/off
  .const VICII_MCM = $10
  /// $D016 Control register #2 Bit#3: CSEL Switch betweem 40 or 38 visible columns
  ///           CSEL|   Display window width   | First X coo. | Last X coo.
  ///           ----+--------------------------+--------------+------------
  ///             0 | 38 characters/304 pixels |   31 ($1f)   |  334 ($14e)
  ///             1 | 40 characters/320 pixels |   24 ($18)   |  343 ($157)
  .const VICII_CSEL = 8
  /// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  /// RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  .const DTV_FEATURE_ENABLE = 1
  .const DTV_LINEAR = 1
  .const DTV_HIGHCOLOR = 4
  .const DTV_COLORRAM_OFF = $10
  .const DTV_BADLINE_OFF = $20
  .const DTV_CHUNKY = $40
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
  /// $D020 Border Color
  .label BORDER_COLOR = $d020
  /// $D011 Control Register #1
  /// - Bit#0-#2: YSCROLL Screen Soft Scroll Vertical
  /// - Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  /// - Bit#4: DEN Switch VIC-II output on/off
  /// - Bit#5: BMM Turn Bitmap Mode on/off
  /// - Bit#6: ECM Turn Extended Color Mode on/off
  /// - Bit#7: RST8 9th Bit for $D012 Rasterline counter
  /// Initial Value: %10011011
  .label VICII_CONTROL1 = $d011
  /// $D016 Control register 2
  /// -  Bit#0-#2: XSCROLL Screen Soft Scroll Horizontal
  /// -  Bit#3: CSEL Switch betweem 40 or 38 visible columns
  ///           CSEL|   Display window width   | First X coo. | Last X coo.
  ///           ----+--------------------------+--------------+------------
  ///             0 | 38 characters/304 pixels |   31 ($1f)   |  334 ($14e)
  ///             1 | 40 characters/320 pixels |   24 ($18)   |  343 ($157)
  /// -  Bit#4: MCM Turn Multicolor Mode on/off
  /// -  Bit#5-#7: not used
  /// Initial Value: %00001000
  .label VICII_CONTROL2 = $d016
  /// $D018 VIC-II base addresses
  /// - Bit#0: not used
  /// - Bit#1-#3: CB Address Bits 11-13 of the Character Set (*2048)
  /// - Bit#4-#7: VM Address Bits 10-13 of the Screen RAM (*1024)
  /// Initial Value: %00010100
  .label VICII_MEMORY = $d018
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  /// Feature enables or disables the extra C64 DTV features
  .label DTV_FEATURE = $d03f
  /// Controls the graphics modes of the C64 DTV
  .label DTV_CONTROL = $d03c
  /// Defines colors for the 16 first colors ($00-$0f)
  .label DTV_PALETTE = $d200
  /// Linear Graphics Plane B Counter Control
  .label DTV_PLANEB_START_LO = $d049
  .label DTV_PLANEB_START_MI = $d04a
  .label DTV_PLANEB_START_HI = $d04b
  .label DTV_PLANEB_STEP = $d04c
  .label DTV_PLANEB_MODULO_LO = $d047
  .label DTV_PLANEB_MODULO_HI = $d048
  // Plane with all pixels
  .label CHUNKY = $8000
.segment Code
main: {
    // asm
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta.z PROCPORT
    // gfx_init_chunky()
    jsr gfx_init_chunky
    // *DTV_FEATURE = DTV_FEATURE_ENABLE
    // Enable DTV extended modes
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    // *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR | DTV_COLORRAM_OFF | DTV_CHUNKY | DTV_BADLINE_OFF
    // 8BPP Pixel Cell Mode
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_COLORRAM_OFF|DTV_CHUNKY|DTV_BADLINE_OFF
    sta DTV_CONTROL
    // *VICII_CONTROL1 = VICII_DEN | VICII_ECM | VICII_RSEL | 3
    lda #VICII_DEN|VICII_ECM|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_MCM | VICII_CSEL
    lda #VICII_MCM|VICII_CSEL
    sta VICII_CONTROL2
    // *DTV_PLANEB_START_LO = BYTE0(CHUNKY)
    // Plane B: CHUNKY
    lda #0
    sta DTV_PLANEB_START_LO
    // *DTV_PLANEB_START_MI = BYTE1(CHUNKY)
    lda #>CHUNKY
    sta DTV_PLANEB_START_MI
    // *DTV_PLANEB_START_HI = 0
    lda #0
    sta DTV_PLANEB_START_HI
    // *DTV_PLANEB_STEP = 8
    lda #8
    sta DTV_PLANEB_STEP
    // *DTV_PLANEB_MODULO_LO = 0
    lda #0
    sta DTV_PLANEB_MODULO_LO
    // *DTV_PLANEB_MODULO_HI = 0
    sta DTV_PLANEB_MODULO_HI
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)CHUNKY/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^CHUNKY/$4000
    sta CIA2
    // *VICII_MEMORY = (byte)((((word)CHUNKY)&$3fff)/$40)  |   ((BYTE1(((word)CHUNKY)&$3fff))/4)
    // Set VIC Bank
    // VIC memory
    lda #0
    sta VICII_MEMORY
    tax
  // DTV Palette - Grey Tones
  __b1:
    // DTV_PALETTE[j] = j
    txa
    sta DTV_PALETTE,x
    // for(byte j : 0..$f)
    inx
    cpx #$10
    bne __b1
  __b2:
    // asm
    // Stabilize Raster
    ldx #$ff
  rff:
    cpx RASTER
    bne rff
  stabilize:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    cpx RASTER
    beq eat+0
  eat:
    inx
    cpx #8
    bne stabilize
    // *VICII_CONTROL1 = VICII_DEN | VICII_ECM | VICII_RSEL | 3
    lda #VICII_DEN|VICII_ECM|VICII_RSEL|3
    sta VICII_CONTROL1
    // *BORDER_COLOR = 0
    lda #0
    sta BORDER_COLOR
  __b3:
    // while(*RASTER!=rst)
    lda #$42
    cmp RASTER
    bne __b3
    // asm
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  __b5:
    // rst = *RASTER
    ldx RASTER
    // rst&7
    txa
    and #7
    // VICII_DEN | VICII_ECM | VICII_RSEL | (rst&7)
    ora #VICII_DEN|VICII_ECM|VICII_RSEL
    // *VICII_CONTROL1 = VICII_DEN | VICII_ECM | VICII_RSEL | (rst&7)
    sta VICII_CONTROL1
    // rst*$10
    txa
    asl
    asl
    asl
    asl
    // *BORDER_COLOR = rst*$10
    sta BORDER_COLOR
    // asm
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    // while (rst!=$f2)
    cpx #$f2
    bne __b5
    jmp __b2
}
// Initialize Plane with 8bpp chunky
gfx_init_chunky: {
    .label __5 = 6
    .label gfxb = 2
    .label x = 4
    .label y = 8
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
    lda #CHUNKY/$4000
    jsr dtvSetCpuBankSegment1
    ldx #($ff&CHUNKY/$4000)+1
    lda #0
    sta.z y
    lda #<$4000
    sta.z gfxb
    lda #>$4000
    sta.z gfxb+1
  __b1:
    lda #<0
    sta.z x
    sta.z x+1
  __b2:
    // if(gfxb==$8000)
    lda.z gfxb+1
    cmp #>$8000
    bne __b3
    lda.z gfxb
    cmp #<$8000
    bne __b3
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
    txa
    jsr dtvSetCpuBankSegment1
    // dtvSetCpuBankSegment1(gfxbCpuBank++);
    inx
    lda #<$4000
    sta.z gfxb
    lda #>$4000
    sta.z gfxb+1
  __b3:
    // x+y
    lda.z y
    clc
    adc.z x
    sta.z __5
    lda #0
    adc.z x+1
    sta.z __5+1
    // byte c = (byte)(x+y)
    lda.z __5
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
    bne __b2
    lda.z x
    cmp #<$140
    bne __b2
    // for(byte y : 0..50)
    inc.z y
    lda #$33
    cmp.z y
    bne __b1
    // dtvSetCpuBankSegment1((byte)($4000/$4000))
  // Reset CPU BANK segment to $4000
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    // }
    rts
}
// Set the memory pointed to by CPU BANK 1 SEGMENT ($4000-$7fff)
// This sets which actual memory is addressed when the CPU reads/writes to $4000-$7fff
// The actual memory addressed will be $4000*cpuSegmentIdx
// void dtvSetCpuBankSegment1(__register(A) char cpuBankIdx)
dtvSetCpuBankSegment1: {
    // Move CPU BANK 1 SEGMENT ($4000-$7fff)
    .label cpuBank = $ff
    // *cpuBank = cpuBankIdx
    sta.z cpuBank
    // asm
    .byte $32, $dd
    lda.z $ff
    .byte $32, $00
    // }
    rts
}
