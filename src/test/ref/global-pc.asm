// Test setting the program PC through a #pc directive
  // Commodore 64 PRG executable file
.file [name="global-pc.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$1000]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label BG_COLOR = $d021
  .label RASTER = $d012
.segment Code
main: {
    // asm
    sei
  __b1:
    // byte col = *RASTER
    lda RASTER
    // *BG_COLOR = col
    sta BG_COLOR
    jmp __b1
}
