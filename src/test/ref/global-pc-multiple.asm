// Test setting the program PC through a #pc directive
  // Commodore 64 PRG executable file
.file [name="global-pc-multiple.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$2000]
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
    // if(*RASTER<30)
    lda RASTER
    cmp #$1e
    bcc __b2
    // *BG_COLOR = 0
    lda #0
    sta BG_COLOR
    jmp __b1
  __b2:
    // incScreen()
    jsr incScreen
    jmp __b1
}
incScreen: {
    // *BG_COLOR = *RASTER
    lda RASTER
    sta BG_COLOR
    // }
    rts
}
