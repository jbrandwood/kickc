.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label BITMAP = $2000
  .const lines_cnt = 8
main: {
    lda #0
    sta BORDERCOL
    sta BGCOL
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #(SCREEN&$3fff)/$40|(BITMAP&$3fff)/$400
    sta VIC_MEMORY
    jsr bitmap_init
    jsr bitmap_clear
    jsr init_screen
  b1:
    jsr lines
    jmp b1
}
lines: {
    .label l = 2
    lda #0
    sta l
  b1:
    ldy l
    lda lines_x,y
    sta bitmap_line.x0
    lda lines_x+1,y
    sta bitmap_line.x1
    lda lines_y,y
    sta bitmap_line.y0
    ldx l
    ldy lines_y+1,x
    jsr bitmap_line
    inc l
    lda l
    cmp #lines_cnt
    bcc b1
    rts
}
//  Draw a line on the bitmap
bitmap_line: {
    .label xd = 4
    .label yd = 3
    .label x0 = 5
    .label x1 = 8
    .label y0 = 6
    lda x0
    cmp x1
    bcc b1
    sec
    sbc x1
    sta xd
    tya
    cmp y0
    beq !+
    bcs b2
  !:
    tya
    eor #$ff
    sec
    adc y0
    sta yd
    cmp xd
    bcc b3
    sty bitmap_line_ydxi.y
    ldx x1
    jsr bitmap_line_ydxi
  breturn:
    rts
  b3:
    ldx x1
    sty bitmap_line_xdyi.y
    jsr bitmap_line_xdyi
    jmp breturn
  b2:
    tya
    sec
    sbc y0
    sta yd
    cmp xd
    bcc b6
    lda y0
    sta bitmap_line_ydxd.y
    ldx x0
    sty bitmap_line_ydxd.y1
    jsr bitmap_line_ydxd
    jmp breturn
  b6:
    ldx x1
    sty bitmap_line_xdyd.y
    lda x0
    sta bitmap_line_xdyd.x1
    jsr bitmap_line_xdyd
    jmp breturn
  b1:
    lda x1
    sec
    sbc x0
    sta xd
    tya
    cmp y0
    beq !+
    bcs b9
  !:
    tya
    eor #$ff
    sec
    adc y0
    sta yd
    cmp xd
    bcc b10
    sty bitmap_line_ydxd.y
    ldx x1
    jsr bitmap_line_ydxd
    jmp breturn
  b10:
    ldx x0
    jsr bitmap_line_xdyd
    jmp breturn
  b9:
    tya
    sec
    sbc y0
    sta yd
    cmp xd
    bcc b13
    lda y0
    sta bitmap_line_ydxi.y
    ldx x0
    sty bitmap_line_ydxi.y1
    jsr bitmap_line_ydxi
    jmp breturn
  b13:
    ldx x0
    lda x1
    sta bitmap_line_xdyi.x1
    jsr bitmap_line_xdyi
    jmp breturn
}
bitmap_line_xdyi: {
    .label _6 = 8
    .label y = 6
    .label x1 = 5
    .label xd = 4
    .label yd = 3
    .label e = 7
    lda yd
    lsr
    sta e
  b1:
    ldy y
    jsr bitmap_plot
    inx
    lda e
    clc
    adc yd
    sta e
    lda xd
    cmp e
    bcs b2
    inc y
    lda e
    sec
    sbc xd
    sta e
  b2:
    ldy x1
    iny
    sty _6
    cpx _6
    bne b1
    rts
}
bitmap_plot: {
    .label _0 = 9
    .label plotter_x = 9
    .label plotter_y = $b
    lda bitmap_plot_xhi,x
    sta plotter_x+1
    lda bitmap_plot_xlo,x
    sta plotter_x
    lda bitmap_plot_yhi,y
    sta plotter_y+1
    lda bitmap_plot_ylo,y
    sta plotter_y
    lda _0
    clc
    adc plotter_y
    sta _0
    lda _0+1
    adc plotter_y+1
    sta _0+1
    lda bitmap_plot_bit,x
    ldy #0
    ora (_0),y
    sta (_0),y
    rts
}
bitmap_line_ydxi: {
    .label y = 7
    .label y1 = 6
    .label yd = 3
    .label xd = 4
    .label e = 5
    lda xd
    lsr
    sta e
  b1:
    ldy y
    jsr bitmap_plot
    inc y
    lda e
    clc
    adc xd
    sta e
    lda yd
    cmp e
    bcs b2
    inx
    lda e
    sec
    sbc yd
    sta e
  b2:
    ldy y1
    iny
    cpy y
    bne b1
    rts
}
bitmap_line_xdyd: {
    .label _6 = 7
    .label y = 6
    .label x1 = 8
    .label xd = 4
    .label yd = 3
    .label e = 5
    lda yd
    lsr
    sta e
  b1:
    ldy y
    jsr bitmap_plot
    inx
    lda e
    clc
    adc yd
    sta e
    lda xd
    cmp e
    bcs b2
    dec y
    lda e
    sec
    sbc xd
    sta e
  b2:
    ldy x1
    iny
    sty _6
    cpx _6
    bne b1
    rts
}
bitmap_line_ydxd: {
    .label y = 7
    .label y1 = 6
    .label yd = 3
    .label xd = 4
    .label e = 5
    lda xd
    lsr
    sta e
  b1:
    ldy y
    jsr bitmap_plot
    inc y
    lda e
    clc
    adc xd
    sta e
    lda yd
    cmp e
    bcs b2
    dex
    lda e
    sec
    sbc yd
    sta e
  b2:
    ldy y1
    iny
    cpy y
    bne b1
    rts
}
init_screen: {
    .label c = 9
    lda #<SCREEN
    sta c
    lda #>SCREEN
    sta c+1
  b1:
    lda #$14
    ldy #0
    sta (c),y
    inc c
    bne !+
    inc c+1
  !:
    lda c+1
    cmp #>SCREEN+$400
    bne b1
    lda c
    cmp #<SCREEN+$400
    bne b1
    rts
}
//  Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = 9
    .label y = 2
    .label _3 = 9
    lda bitmap_plot_xlo
    sta _3
    lda bitmap_plot_xhi
    sta _3+1
    lda #0
    sta y
  b1:
    ldx #0
  b2:
    lda #0
    tay
    sta (bitmap),y
    inc bitmap
    bne !+
    inc bitmap+1
  !:
    inx
    cpx #$c8
    bne b2
    inc y
    lda y
    cmp #$28
    bne b1
    rts
}
//  Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .label _6 = 2
    .label yoffs = 9
    ldy #$80
    ldx #0
  b1:
    txa
    and #$f8
    sta bitmap_plot_xlo,x
    lda #>BITMAP
    sta bitmap_plot_xhi,x
    tya
    sta bitmap_plot_bit,x
    tya
    lsr
    tay
    cpy #0
    bne b2
    ldy #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #<0
    sta yoffs
    sta yoffs+1
    tax
  b3:
    txa
    and #7
    sta _6
    lda yoffs
    ora _6
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    txa
    and #7
    cmp #7
    bne b4
    clc
    lda yoffs
    adc #<$28*8
    sta yoffs
    lda yoffs+1
    adc #>$28*8
    sta yoffs+1
  b4:
    inx
    cpx #0
    bne b3
    rts
}
  //  Plot and line drawing routines for HIRES bitmaps
  //  Currently it can only plot on the first 256 x-positions.
  //  Tables for the plotter - initialized by calling bitmap_draw_init();
  bitmap_plot_xlo: .fill $100, 0
  bitmap_plot_xhi: .fill $100, 0
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  lines_x: .byte $3c, $50, $6e, $50, $3c, $28, $a, $28, $3c
  lines_y: .byte $a, $28, $3c, $50, $6e, $50, $3c, $28, $a
