// Test setting the program PC through a #pc directive
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $2000 "Program"
  .label BGCOL = $d021
  .label RASTER = $d012
main: {
    sei
  b1:
    lda RASTER
    cmp #$1e
    bcc b2
    lda #0
    sta BGCOL
    jmp b1
  b2:
    jsr incScreen
    jmp b1
}
incScreen: {
    lda RASTER
    sta BGCOL
    rts
}
