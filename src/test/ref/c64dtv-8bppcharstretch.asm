// C64DTV 8bpp charmode stretcher
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
  // The address of the CHARGEN character set
  .label CHARGEN = $d000
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label VIC_CONTROL = $d011
  .const VIC_ECM = $40
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label VIC_CONTROL2 = $d016
  .const VIC_MCM = $10
  .const VIC_CSEL = 8
  .label VIC_MEMORY = $d018
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  // Feature enables or disables the extra C64 DTV features
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  // Controls the graphics modes of the C64 DTV
  .label DTV_CONTROL = $d03c
  .const DTV_LINEAR = 1
  .const DTV_HIGHCOLOR = 4
  .const DTV_BADLINE_OFF = $20
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
  // Plane with the screen
  .label SCREEN = $7c00
  // Plane with all pixels
  .label CHARSET8 = $8000
main: {
    sei
    // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    jsr gfx_init
    // Enable DTV extended modes
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    // 8BPP Pixel Cell Mode
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_BADLINE_OFF
    sta DTV_CONTROL
    lda #VIC_DEN|VIC_ECM|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    // Plane A: SCREEN
    lda #0
    sta DTV_PLANEA_START_LO
    lda #>SCREEN
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    // Plane B: CHARSET8
    sta DTV_PLANEB_START_LO
    lda #>CHARSET8
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    sta DTV_PLANEB_STEP
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^SCREEN/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // VIC memory
    lda #(SCREEN&$3fff)/$40|(>(SCREEN&$3fff))/4
    sta VIC_MEMORY
    ldx #0
  // DTV Palette - Grey Tones
  __b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
  __b2:
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
    lda #VIC_DEN|VIC_ECM|VIC_RSEL|3
    sta VIC_CONTROL
    lda #0
    sta BORDERCOL
  __b3:
    lda #$42
    cmp RASTER
    bne __b3
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
    ldx RASTER
    txa
    and #7
    ora #VIC_DEN|VIC_ECM|VIC_RSEL
    sta VIC_CONTROL
    txa
    asl
    asl
    asl
    asl
    sta BORDERCOL
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
    cpx #$f2
    bne __b5
    jmp __b2
}
// Initialize the different graphics in the memory
gfx_init: {
    jsr gfx_init_screen0
    jsr gfx_init_plane_charset8
    rts
}
// Initialize Plane with 8bpp charset
gfx_init_plane_charset8: {
    .const gfxbCpuBank = $ff&CHARSET8/$4000
    .label bits = 2
    .label chargen = 7
    .label gfxa = 3
    .label col = 5
    .label cr = 9
    .label ch = 6
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
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
    ldy #0
    lda (chargen),y
    sta.z bits
    inc.z chargen
    bne !+
    inc.z chargen+1
  !:
    ldx #0
  __b3:
    lda #$80
    and.z bits
    cmp #0
    beq b1
    lda.z col
    jmp __b4
  b1:
    lda #0
  __b4:
    ldy #0
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    asl.z bits
    inc.z col
    inx
    cpx #8
    bne __b3
    inc.z cr
    lda #8
    cmp.z cr
    bne __b2
    inc.z ch
    lda.z ch
    cmp #0
    bne __b1
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
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
// Initialize VIC screen 0 ( value is %yyyyxxxx where yyyy is ypos and xxxx is xpos)
gfx_init_screen0: {
    .label __1 = 9
    .label ch = 7
    .label cy = 6
    lda #<SCREEN
    sta.z ch
    lda #>SCREEN
    sta.z ch+1
    lda #0
    sta.z cy
  __b1:
    ldx #0
  __b2:
    lda #$f
    and.z cy
    asl
    asl
    asl
    asl
    sta.z __1
    txa
    and #$f
    ora.z __1
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b2
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    rts
}
