// Tests that constant offset indexing into arrays is handled correctly
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label COLS = $d800
main: {
    ldx #0
  b1:
    lda MAPDATA,x
    sta SCREEN,x
    lda MAPDATA,x
    tay
    lda COLORMAP1,y
    sta COLS,x
    lda MAPDATA+$c8,x
    sta SCREEN+$c8,x
    lda MAPDATA+$c8,x
    tay
    lda COLORMAP1,y
    sta COLS+$c8,x
    lda MAPDATA+$190,x
    sta SCREEN+$190,x
    lda MAPDATA+$190,x
    tay
    lda COLORMAP1,y
    sta COLS+$190,x
    lda MAPDATA+$258,x
    sta SCREEN+$258,x
    lda MAPDATA+$258,x
    tay
    lda COLORMAP2,y
    sta COLS+$258,x
    lda MAPDATA+$320,x
    sta SCREEN+$320,x
    lda MAPDATA+$320,x
    tay
    lda COLORMAP2,y
    sta COLS+$320,x
    inx
    cpx #$c9
    bne b1
    rts
}
  MAPDATA: .fill $3e8, 0
  COLORMAP1: .fill $100, 0
  COLORMAP2: .fill $100, 0
