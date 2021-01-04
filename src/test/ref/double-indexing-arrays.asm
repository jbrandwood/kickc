// Tests that constant offset indexing into arrays is handled correctly
  // Commodore 64 PRG executable file
.file [name="double-indexing-arrays.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label COLS = $d800
.segment Code
main: {
    ldx #0
  __b1:
    // SCREEN[x] = MAPDATA[x]
    lda MAPDATA,x
    sta SCREEN,x
    // COLS[x] = COLORMAP1[MAPDATA[x]]
    ldy MAPDATA,x
    lda COLORMAP1,y
    sta COLS,x
    // SCREEN[200+x] = MAPDATA[200+x]
    lda MAPDATA+$c8,x
    sta SCREEN+$c8,x
    // COLS[200+x] = COLORMAP1[MAPDATA[200+x]]
    ldy MAPDATA+$c8,x
    lda COLORMAP1,y
    sta COLS+$c8,x
    // SCREEN[400+x] = MAPDATA[400+x]
    lda MAPDATA+$190,x
    sta SCREEN+$190,x
    // COLS[400+x] = COLORMAP1[MAPDATA[400+x]]
    ldy MAPDATA+$190,x
    lda COLORMAP1,y
    sta COLS+$190,x
    // SCREEN[600+x] = MAPDATA[600+x]
    lda MAPDATA+$258,x
    sta SCREEN+$258,x
    // COLS[600+x] = COLORMAP2[MAPDATA[600+x]]
    ldy MAPDATA+$258,x
    lda COLORMAP2,y
    sta COLS+$258,x
    // SCREEN[800+x] = MAPDATA[800+x]
    lda MAPDATA+$320,x
    sta SCREEN+$320,x
    // COLS[800+x] = COLORMAP2[MAPDATA[800+x]]
    ldy MAPDATA+$320,x
    lda COLORMAP2,y
    sta COLS+$320,x
    // for (byte x: 0..200)
    inx
    cpx #$c9
    bne __b1
    // }
    rts
}
.segment Data
  MAPDATA: .fill $3e8, 0
  COLORMAP1: .fill $100, 0
  COLORMAP2: .fill $100, 0
