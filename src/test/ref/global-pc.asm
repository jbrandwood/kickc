// Test setting the program PC through a #pc directive
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $1000 "Program"
  .label BG_COLOR = $d021
  .label RASTER = $d012
main: {
    // asm
    sei
  __b1:
    // col = *RASTER
    lda RASTER
    // *BG_COLOR = col
    sta BG_COLOR
    jmp __b1
}
