.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BGCOL = $d021
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  .label DTV_CONTROL = $d03c
  .const DTV_BORDER_OFF = 2
  .const DTV_HIGHCOLOR = 4
  .const DTV_BADLINE_OFF = $20
  .label DTV_PALETTE = $d200
main: {
    sei
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    lda #DTV_HIGHCOLOR|DTV_BORDER_OFF|DTV_BADLINE_OFF
    sta DTV_CONTROL
  b4:
    lda RASTER
    cmp #$40
    bne b4
    lda #0
    sta BGCOL
    ldx #$31
  b7:
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
    inc BGCOL
    inx
    cpx #0
    bne b7
    ldx #0
  b8:
    lda palette,x
    sta DTV_PALETTE,x
    inc palette,x
    inx
    cpx #$10
    bne b8
    jmp b4
    palette: .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $a, $b, $c, $d, $e, $f
}
