// Tests that constant offset indexing into arrays is handled correctly
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label COLS = $d800
main: {
    ldy #0
  __b1:
    lda MAPDATA,y
    sta SCREEN,y
    ldx MAPDATA,y
    lda COLORMAP1,x
    sta COLS,y
    lda MAPDATA+$c8,y
    sta SCREEN+$c8,y
    ldx MAPDATA+$c8,y
    lda COLORMAP1,x
    sta COLS+$c8,y
    lda MAPDATA+$190,y
    sta SCREEN+$190,y
    ldx MAPDATA+$190,y
    lda COLORMAP1,x
    sta COLS+$190,y
    lda MAPDATA+$258,y
    sta SCREEN+$258,y
    ldx MAPDATA+$258,y
    lda COLORMAP2,x
    sta COLS+$258,y
    lda MAPDATA+$320,y
    sta SCREEN+$320,y
    ldx MAPDATA+$320,y
    lda COLORMAP2,x
    sta COLS+$320,y
    iny
    cpy #$c9
    bne __b1
    rts
}
  MAPDATA: .fill $3e8, 0
  COLORMAP1: .fill $100, 0
  COLORMAP2: .fill $100, 0
