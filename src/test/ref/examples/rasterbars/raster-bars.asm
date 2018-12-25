.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label BGCOL = $d021
main: {
    sei
  b2:
    lda RASTER
    cmp #$a
    bne b2
  b3:
    lda RASTER
    cmp #$b
    bne b3
    jsr raster
    jmp b2
}
raster: {
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
    lda rastercols
    ldx #0
  b1:
    sta BGCOL
    sta BORDERCOL
    inx
    lda rastercols,x
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
    cmp #$ff
    bne b1
    rts
}
  rastercols: .byte $b, 0, $b, $b, $c, $b, $c, $c, $f, $c, $f, $f, 1, $f, 1, 1, $f, 1, $f, $f, $c, $f, $c, $c, $b, $c, $b, $b, 0, $b, 0, $ff
