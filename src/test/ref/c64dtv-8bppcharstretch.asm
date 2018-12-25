.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PROCPORT_DDR = 0
  .const PROCPORT_DDR_MEMORY_MASK = 7
  .label PROCPORT = 1
  .const PROCPORT_RAM_IO = $35
  .const PROCPORT_RAM_CHARROM = $31
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
  .label CIA2_PORT_A = $dd00
  .label CIA2_PORT_A_DDR = $dd02
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  .label DTV_CONTROL = $d03c
  .const DTV_LINEAR = 1
  .const DTV_HIGHCOLOR = 4
  .const DTV_BADLINE_OFF = $20
  .const DTV_CHUNKY = $40
  .label DTV_PALETTE = $d200
  .label DTV_PLANEA_START_LO = $d03a
  .label DTV_PLANEA_START_MI = $d03b
  .label DTV_PLANEA_START_HI = $d045
  .label DTV_PLANEA_STEP = $d046
  .label DTV_PLANEA_MODULO_LO = $d038
  .label DTV_PLANEA_MODULO_HI = $d039
  .label DTV_PLANEB_START_LO = $d049
  .label DTV_PLANEB_START_MI = $d04a
  .label DTV_PLANEB_START_HI = $d04b
  .label DTV_PLANEB_STEP = $d04c
  .label DTV_PLANEB_MODULO_LO = $d047
  .label DTV_PLANEB_MODULO_HI = $d048
  .label SCREEN = $7c00
  .label CHARSET8 = $8000
main: {
    sei
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    jsr gfx_init
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_BADLINE_OFF
    sta DTV_CONTROL
    lda #VIC_DEN|VIC_ECM|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
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
    lda #<CHARSET8
    sta DTV_PLANEB_START_LO
    lda #>CHARSET8
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    sta DTV_PLANEB_STEP
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    lda #3
    sta CIA2_PORT_A_DDR
    lda #3^SCREEN/$4000
    sta CIA2_PORT_A
    lda #(SCREEN&$3fff)>>6|(>(SCREEN&$3fff))>>2
    sta VIC_MEMORY
    ldx #0
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
  b3:
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
gfx_init: {
    jsr gfx_init_screen0
    jsr gfx_init_plane_charset8
    rts
}
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
dtvSetCpuBankSegment1: {
    .label cpuBank = $ff
    sta cpuBank
    .byte $32, $dd
    lda $ff
    .byte $32, $00
    rts
}
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
