// C64DTV 8bpp charmode stretcher
// C64 DTV version 2 Registers and Constants
//
// Sources
// (J) https://www.c64-wiki.com/wiki/C64DTV_Programming_Guide
// (H) http://dtvhacking.cbm8bit.com/dtv_wiki/images/d/d9/Dtv_registers_full.txt
  // Commodore 64 PRG executable file
.file [name="c64dtv-8bppcharstretch.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const VICII_ECM = $40
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
  .const DTV_FEATURE_ENABLE = 1
  .const DTV_LINEAR = 1
  .const DTV_HIGHCOLOR = 4
  .const DTV_BADLINE_OFF = $20
  .const DTV_CHUNKY = $40
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .label RASTER = $d012
  .label BORDER_COLOR = $d020
  .label VICII_CONTROL1 = $d011
  .label VICII_CONTROL2 = $d016
  .label VICII_MEMORY = $d018
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The address of the CHARGEN character set
  .label CHARGEN = $d000
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
  // Plane with the screen
  .label SCREEN = $7c00
  // Plane with all pixels
  .label CHARSET8 = $8000
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
    // gfx_init()
    jsr gfx_init
    // *DTV_FEATURE = DTV_FEATURE_ENABLE
    // Enable DTV extended modes
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    // *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR | DTV_CHUNKY | DTV_BADLINE_OFF
    // 8BPP Pixel Cell Mode
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_BADLINE_OFF
    sta DTV_CONTROL
    // *VICII_CONTROL1 = VICII_DEN | VICII_ECM | VICII_RSEL | 3
    lda #VICII_DEN|VICII_ECM|VICII_RSEL|3
    sta VICII_CONTROL1
    // *VICII_CONTROL2 = VICII_MCM | VICII_CSEL
    lda #VICII_MCM|VICII_CSEL
    sta VICII_CONTROL2
    // *DTV_PLANEA_START_LO = < SCREEN
    // Plane A: SCREEN
    lda #0
    sta DTV_PLANEA_START_LO
    // *DTV_PLANEA_START_MI = > SCREEN
    lda #>SCREEN
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
    // *DTV_PLANEB_START_LO = < CHARSET8
    // Plane B: CHARSET8
    sta DTV_PLANEB_START_LO
    // *DTV_PLANEB_START_MI = > CHARSET8
    lda #>CHARSET8
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
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)SCREEN/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^SCREEN/$4000
    sta CIA2
    // *VICII_MEMORY = (byte)((((word)SCREEN)&$3fff)/$40)  |   ((>(((word)SCREEN)&$3fff))/4)
    // Set VIC Bank
    // VIC memory
    lda #(SCREEN&$3fff)/$40|(>(SCREEN&$3fff))/4
    sta VICII_MEMORY
    ldx #0
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
// Initialize the different graphics in the memory
gfx_init: {
    // gfx_init_screen0()
    jsr gfx_init_screen0
    // gfx_init_plane_charset8()
    jsr gfx_init_plane_charset8
    // }
    rts
}
// Initialize VIC screen 0 ( value is %yyyyxxxx where yyyy is ypos and xxxx is xpos)
gfx_init_screen0: {
    .label __1 = 9
    .label ch = 3
    .label cy = 2
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #0
    sta.z cy
  __b1:
    ldx #0
  __b2:
    // cy&$f
    lda #$f
    and.z cy
    // (cy&$f)*$10
    asl
    asl
    asl
    asl
    sta.z __1
    // cx&$f
    txa
    and #$f
    // (cy&$f)*$10|(cx&$f)
    ora.z __1
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
    bne __b2
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    // }
    rts
}
// Initialize Plane with 8bpp charset
gfx_init_plane_charset8: {
    // 8bpp cells for Plane B (charset) - ROM charset with 256 colors
    .const gfxbCpuBank = $ff&CHARSET8/$4000
    .label bits = 5
    .label chargen = 3
    .label gfxa = 6
    .label col = 8
    .label cr = 9
    .label ch = 2
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    // *PROCPORT = PROCPORT_RAM_CHARROM
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    lda #0
    sta.z ch
    sta.z col
    lda #<$4000
    sta.z gfxa
    lda #>$4000
    sta.z gfxa+1
    lda #<CHARGEN+1
    sta.z chargen
    lda #>CHARGEN+1
    sta.z chargen+1
  __b1:
    lda #0
    sta.z cr
  __b2:
    // bits = *chargen++
    ldy #0
    lda (chargen),y
    sta.z bits
    inc.z chargen
    bne !+
    inc.z chargen+1
  !:
    ldx #0
  __b3:
    // bits & $80
    lda #$80
    and.z bits
    // if((bits & $80) != 0)
    cmp #0
    beq __b5
    lda.z col
    jmp __b4
  __b5:
    lda #0
  __b4:
    // *gfxa++ = c
    ldy #0
    sta (gfxa),y
    // *gfxa++ = c;
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    // bits = bits*2
    asl.z bits
    // col++;
    inc.z col
    // for ( byte cp : 0..7)
    inx
    cpx #8
    bne __b3
    // for ( byte cr : 0..7)
    inc.z cr
    lda #8
    cmp.z cr
    bne __b2
    // for(byte ch : $00..$ff)
    inc.z ch
    lda.z ch
    cmp #0
    bne __b1
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
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
