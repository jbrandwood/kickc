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
  .const DTV_COLORRAM_OFF = $10
  .const DTV_BADLINE_OFF = $20
  .const DTV_CHUNKY = $40
  // Defines colors for the 16 first colors ($00-$0f)
  .label DTV_PALETTE = $d200
  // Linear Graphics Plane B Counter Control
  .label DTV_PLANEB_START_LO = $d049
  .label DTV_PLANEB_START_MI = $d04a
  .label DTV_PLANEB_START_HI = $d04b
  .label DTV_PLANEB_STEP = $d04c
  .label DTV_PLANEB_MODULO_LO = $d047
  .label DTV_PLANEB_MODULO_HI = $d048
  // Plane with all pixels
  .label CHUNKY = $8000
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
    // *VIC_CONTROL = VIC_DEN | VIC_ECM | VIC_RSEL | 3
    lda #VIC_DEN|VIC_ECM|VIC_RSEL|3
    sta VIC_CONTROL
    // *VIC_CONTROL2 = VIC_MCM | VIC_CSEL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    // *DTV_PLANEB_START_LO = < CHUNKY
    // Plane B: CHUNKY
    lda #0
    sta DTV_PLANEB_START_LO
    // *DTV_PLANEB_START_MI = > CHUNKY
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
    // *CIA2_PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // *CIA2_PORT_A = %00000011 ^ (byte)((word)CHUNKY/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^CHUNKY/$4000
    sta CIA2_PORT_A
    // *VIC_MEMORY = (byte)((((word)CHUNKY)&$3fff)/$40)  |   ((>(((word)CHUNKY)&$3fff))/4)
    // Set VIC Bank
    // VIC memory
    lda #0
    sta VIC_MEMORY
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
    // *VIC_CONTROL = VIC_DEN | VIC_ECM | VIC_RSEL | 3
    lda #VIC_DEN|VIC_ECM|VIC_RSEL|3
    sta VIC_CONTROL
    // *BORDERCOL = 0
    lda #0
    sta BORDERCOL
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
    // VIC_DEN | VIC_ECM | VIC_RSEL | (rst&7)
    ora #VIC_DEN|VIC_ECM|VIC_RSEL
    // *VIC_CONTROL = VIC_DEN | VIC_ECM | VIC_RSEL | (rst&7)
    sta VIC_CONTROL
    // rst*$10
    txa
    asl
    asl
    asl
    asl
    // *BORDERCOL = rst*$10
    sta BORDERCOL
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
    .label __5 = 7
    .label gfxb = 5
    .label x = 3
    .label y = 2
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
    // c = (byte)(x+y)
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
