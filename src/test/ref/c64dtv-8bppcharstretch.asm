//  C64DTV 8bpp charmode stretcher
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  //  Processor port data direction register
  .label PROCPORT_DDR = 0
  //  Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  //  Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  //  RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = $35
  //  RAM in $A000, $E000 CHAR ROM in $D000
  .const PROCPORT_RAM_CHARROM = $31
  //  The address of the CHARGEN character set
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
  //  CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  //  CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  //  Feature enables or disables the extra C64 DTV features
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  //  Controls the graphics modes of the C64 DTV
  .label DTV_CONTROL = $d03c
  .const DTV_LINEAR = 1
  .const DTV_HIGHCOLOR = 4
  .const DTV_BADLINE_OFF = $20
  .const DTV_CHUNKY = $40
  //  Defines colors for the 16 first colors ($00-$0f)
  .label DTV_PALETTE = $d200
  //  Linear Graphics Plane A Counter Control
  .label DTV_PLANEA_START_LO = $d03a
  .label DTV_PLANEA_START_MI = $d03b
  .label DTV_PLANEA_START_HI = $d045
  .label DTV_PLANEA_STEP = $d046
  .label DTV_PLANEA_MODULO_LO = $d038
  .label DTV_PLANEA_MODULO_HI = $d039
  //  Linear Graphics Plane B Counter Control
  .label DTV_PLANEB_START_LO = $d049
  .label DTV_PLANEB_START_MI = $d04a
  .label DTV_PLANEB_START_HI = $d04b
  .label DTV_PLANEB_STEP = $d04c
  .label DTV_PLANEB_MODULO_LO = $d047
  .label DTV_PLANEB_MODULO_HI = $d048
  //  Plane with the screen
  .label SCREEN = $7c00
  //  Plane with all pixels
  .label CHARSET8 = $8000
main: {
    sei
    //  Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    //  Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    jsr gfx_init
    //  Enable DTV extended modes
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    //  8BPP Pixel Cell Mode
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_BADLINE_OFF
    sta DTV_CONTROL
    lda #VIC_DEN|VIC_ECM|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    //  Plane A: SCREEN
    lda #<SCREEN
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
    //  Plane B: CHARSET8
    lda #<CHARSET8
    sta DTV_PLANEB_START_LO
    lda #>CHARSET8
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    sta DTV_PLANEB_STEP
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    //  VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    //  Set VIC Bank bits to output - all others to input
    lda #3^SCREEN/$4000
    sta CIA2_PORT_A
    //  Set VIC Bank
    //  VIC memory
    lda #(SCREEN&$3fff)>>6|(>(SCREEN&$3fff))>>2
    sta VIC_MEMORY
    ldx #0
  //  DTV Palette - Grey Tones
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
  b3:
    //  Stabilize Raster
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
  b5:
    lda RASTER
    cmp #$42
    bne b5
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
  b8:
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
    bne b8
    jmp b3
}
//  Initialize the different graphics in the memory
gfx_init: {
    jsr gfx_init_screen0
    jsr gfx_init_plane_charset8
    rts
}
//  Initialize Plane with 8bpp charset
gfx_init_plane_charset8: {
    .const gfxbCpuBank = $ff&CHARSET8/$4000
    .label bits = 6
    .label chargen = 3
    .label gfxa = 7
    .label col = 9
    .label cr = 5
    .label ch = 2
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    lda #0
    sta ch
    sta col
    lda #<$4000+(CHARSET8&$3fff)
    sta gfxa
    lda #>$4000+(CHARSET8&$3fff)
    sta gfxa+1
    lda #<CHARGEN+1
    sta chargen
    lda #>CHARGEN+1
    sta chargen+1
  b1:
    lda #0
    sta cr
  b2:
    ldy #0
    lda (chargen),y
    sta bits
    inc chargen
    bne !+
    inc chargen+1
  !:
    ldx #0
  b3:
    lda #$80
    and bits
    cmp #0
    beq b5
    lda col
    jmp b4
  b5:
    lda #0
  b4:
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    asl bits
    inc col
    inx
    cpx #8
    bne b3
    inc cr
    lda cr
    cmp #8
    bne b2
    inc ch
    lda ch
    cmp #0
    bne b1
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
}
//  Set the memory pointed to by CPU BANK 1 SEGMENT ($4000-$7fff)
//  This sets which actual memory is addressed when the CPU reads/writes to $4000-$7fff
//  The actual memory addressed will be $4000*cpuSegmentIdx
dtvSetCpuBankSegment1: {
    //  Move CPU BANK 1 SEGMENT ($4000-$7fff)
    .label cpuBank = $ff
    sta cpuBank
    .byte $32, $dd
    lda $ff
    .byte $32, $00
    rts
}
//  Initialize VIC screen 0 ( value is %yyyyxxxx where yyyy is ypos and xxxx is xpos)
gfx_init_screen0: {
    .label _1 = 5
    .label ch = 3
    .label cy = 2
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #0
    sta cy
  b1:
    ldx #0
  b2:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _1
    txa
    and #$f
    ora _1
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b2
    inc cy
    lda cy
    cmp #$19
    bne b1
    rts
}
