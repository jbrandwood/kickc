// NullPointerException using current_movedown_rate in the main loop
  // Commodore 64 PRG executable file
.file [name="tetris-npe.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const RATE = $32
  .label RASTER = $d012
  .label SCREEN = $400
.segment Code
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
