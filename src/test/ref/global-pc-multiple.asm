// Test setting the program PC through a #pc directive
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $2000 "Program"
  .label BG_COLOR = $d021
  .label RASTER = $d012
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
