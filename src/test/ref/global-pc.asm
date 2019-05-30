// Test setting the program PC through a #pc directive
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $1000 "Program"
  .label BGCOL = $d021
  .label RASTER = $d012
main: {
    sei
  b1:
    lda RASTER
    sta BGCOL
    jmp b1
}
