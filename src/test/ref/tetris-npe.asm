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
  __b2:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b2
    // if(--counter==0)
    dey
    cpy #0
    bne __b2
    // ypos++;
    inx
    // *SCREEN = ypos
    stx SCREEN
    ldy #RATE
    jmp __b2
}
