// NullPointerException using current_movedown_rate in the main loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label SCREEN = $400
  .const RATE = $32
main: {
    ldx #0
    ldy #RATE
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    dey
    cpy #0
    bne b2
    inx
    stx SCREEN
    ldy #RATE
    jmp b2
}
