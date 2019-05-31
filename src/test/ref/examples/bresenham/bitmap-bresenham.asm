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
// Draw a line on the bitmap
// bitmap_line(byte zeropage(5) x0, byte zeropage($b) x1, byte zeropage(6) y0, byte register(Y) y1)
bitmap_line: {
    .label xd = 4
    .label yd = $a
    .label yd_2 = 3
    .label x0 = 5
    .label x1 = $b
    .label y0 = 6
    .label yd_11 = 3
    lda x0
    cmp x1
    bcc b1
    sec
    sbc x1
    sta xd
    tya
    cmp y0
    beq !+
    bcs b7
  !:
    tya
    eor #$ff
    sec
    adc y0
    sta yd_2
    cmp xd
    bcc b8
    sty bitmap_line_ydxi.y
    ldx x1
    jsr bitmap_line_ydxi
    rts
  b8:
    ldx x1
    sty bitmap_line_xdyi.y
    jsr bitmap_line_xdyi
    rts
  b7:
    tya
    sec
    sbc y0
    sta yd
    cmp xd
    bcc b9
    lda y0
    sta bitmap_line_ydxd.y
    ldx x0
    sty bitmap_line_ydxd.y1
    jsr bitmap_line_ydxd
    rts
  b9:
    ldx x1
    sty bitmap_line_xdyd.y
    lda x0
    sta bitmap_line_xdyd.x1
    jsr bitmap_line_xdyd
    rts
  b1:
    lda x1
    sec
    sbc x0
    sta xd
    tya
    cmp y0
    beq !+
    bcs b11
  !:
    tya
    eor #$ff
    sec
    adc y0
    sta yd
    cmp xd
    bcc b12
    sty bitmap_line_ydxd.y
    ldx x1
    jsr bitmap_line_ydxd
    rts
  b12:
    ldx x0
    jsr bitmap_line_xdyd
    rts
  b11:
    tya
    sec
    sbc y0
    sta yd_11
    cmp xd
    bcc b13
    lda y0
    sta bitmap_line_ydxi.y
    ldx x0
    sty bitmap_line_ydxi.y1
    jsr bitmap_line_ydxi
    rts
  b13:
    ldx x0
    lda x1
    sta bitmap_line_xdyi.x1
    jsr bitmap_line_xdyi
    rts
}
// bitmap_line_xdyi(byte register(X) x, byte zeropage(6) y, byte zeropage(5) x1, byte zeropage(4) xd, byte zeropage(3) yd)
bitmap_line_xdyi: {
    .label _6 = $16
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
// bitmap_plot(byte register(X) x, byte register(Y) y)
bitmap_plot: {
    .label plotter_x = $17
    .label plotter_y = $19
    .label plotter = $17
    lda bitmap_plot_xhi,x
    sta plotter_x+1
    lda bitmap_plot_xlo,x
    sta plotter_x
    lda bitmap_plot_yhi,y
    sta plotter_y+1
    lda bitmap_plot_ylo,y
    sta plotter_y
    lda plotter
    clc
    adc plotter_y
    sta plotter
    lda plotter+1
    adc plotter_y+1
    sta plotter+1
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// bitmap_line_ydxi(byte zeropage(8) y, byte register(X) x, byte zeropage(6) y1, byte zeropage(3) yd, byte zeropage(4) xd)
bitmap_line_ydxi: {
    .label y = 8
    .label y1 = 6
    .label yd = 3
    .label xd = 4
    .label e = 9
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
// bitmap_line_xdyd(byte register(X) x, byte zeropage(6) y, byte zeropage($b) x1, byte zeropage(4) xd, byte zeropage($a) yd)
bitmap_line_xdyd: {
    .label _6 = $1b
    .label y = 6
    .label x1 = $b
    .label xd = 4
    .label yd = $a
    .label e = $c
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
// bitmap_line_ydxd(byte zeropage($d) y, byte register(X) x, byte zeropage(6) y1, byte zeropage($a) yd, byte zeropage(4) xd)
bitmap_line_ydxd: {
    .label y = $d
    .label y1 = 6
    .label yd = $a
    .label xd = 4
    .label e = $e
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
    .label c = $f
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
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = $12
    .label y = $11
    lda bitmap_plot_xlo
    sta bitmap
    lda bitmap_plot_xhi
    sta bitmap+1
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
    lda #$28
    cmp y
    bne b1
    rts
}
// Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .label _10 = $1c
    .label yoffs = $14
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
    lda #7
    sax _10
    lda yoffs
    ora _10
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp _10
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
  // Tables for the plotter - initialized by calling bitmap_draw_init();
  bitmap_plot_xlo: .fill $100, 0
  bitmap_plot_xhi: .fill $100, 0
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  lines_x: .byte $3c, $50, $6e, $50, $3c, $28, $a, $28, $3c
  lines_y: .byte $a, $28, $3c, $50, $6e, $50, $3c, $28, $a
