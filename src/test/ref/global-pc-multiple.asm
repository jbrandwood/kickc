// Test setting the program PC through a #pc directive
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $2000 "Program"
  .label BGCOL = $d021
  .label RASTER = $d012
main: {
    // asm
    sei
  __b1:
    // if(*RASTER<30)
    lda RASTER
    cmp #$1e
    bcc __b2
    // *BGCOL = 0
    lda #0
    sta BGCOL
    jmp __b1
  __b2:
    // incScreen()
    jsr incScreen
    jmp __b1
}
incScreen: {
    // *BGCOL = *RASTER
    lda RASTER
    sta BGCOL
    // }
    rts
}
