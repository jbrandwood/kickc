// Test setting the program PC through a #pc directive
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $1000 "Program"
  .label BGCOL = $d021
  .label RASTER = $d012
main: {
    // asm
    sei
  __b1:
    // col = *RASTER
    lda RASTER
    // *BGCOL = col
    sta BGCOL
    jmp __b1
}
