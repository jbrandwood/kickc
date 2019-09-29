// Test setting the program PC through a #pc directive
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $2000 "Program"
  .label BGCOL = $d021
  .label RASTER = $d012
main: {
    sei
  __b1:
    lda RASTER
    cmp #$1e
    bcc __b2
    lda #0
    sta BGCOL
    jmp __b1
  __b2:
    jsr incScreen
    jmp __b1
}
incScreen: {
    lda RASTER
    sta BGCOL
    rts
}
