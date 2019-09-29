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
  __b1:
    jsr lines
    jmp __b1
}
lines: {
    .label l = 6
    lda #0
    sta.z l
  __b1:
    lda.z l
    cmp #lines_cnt
    bcc __b2
    rts
  __b2:
    ldy.z l
    lda lines_x,y
    sta.z bitmap_line.x0
    lda lines_x+1,y
    sta.z bitmap_line.x1
    lda lines_y,y
    sta.z bitmap_line.y0
    ldx.z l
    ldy lines_y+1,x
    jsr bitmap_line
    inc.z l
    jmp __b1
}
// Draw a line on the bitmap
// bitmap_line(byte zeropage(3) x0, byte zeropage(5) x1, byte zeropage(2) y0, byte register(Y) y1)
bitmap_line: {
    .label xd = $d
    .label yd = 7
    .label yd_2 = 4
    .label x0 = 3
    .label x1 = 5
    .label y0 = 2
    .label yd_11 = 4
    lda.z x0
    cmp.z x1
    bcc __b1
    sec
    sbc.z x1
    sta.z xd
    tya
    cmp.z y0
    beq !+
    bcs __b7
  !:
    tya
    eor #$ff
    sec
    adc.z y0
    sta.z yd_2
    cmp.z xd
    bcc __b8
    sty.z bitmap_line_ydxi.y
    ldx.z x1
    jsr bitmap_line_ydxi
    rts
  __b8:
    ldx.z x1
    sty.z bitmap_line_xdyi.y
    jsr bitmap_line_xdyi
    rts
  __b7:
    tya
    sec
    sbc.z y0
    sta.z yd
    cmp.z xd
    bcc __b9
    lda.z y0
    sta.z bitmap_line_ydxd.y
    ldx.z x0
    sty.z bitmap_line_ydxd.y1
    jsr bitmap_line_ydxd
    rts
  __b9:
    ldx.z x1
    sty.z bitmap_line_xdyd.y
    lda.z x0
    sta.z bitmap_line_xdyd.x1
    jsr bitmap_line_xdyd
    rts
  __b1:
    lda.z x1
    sec
    sbc.z x0
    sta.z xd
    tya
    cmp.z y0
    beq !+
    bcs __b11
  !:
    tya
    eor #$ff
    sec
    adc.z y0
    sta.z yd
    cmp.z xd
    bcc __b12
    sty.z bitmap_line_ydxd.y
    ldx.z x1
    jsr bitmap_line_ydxd
    rts
  __b12:
    ldx.z x0
    jsr bitmap_line_xdyd
    rts
  __b11:
    tya
    sec
    sbc.z y0
    sta.z yd_11
    cmp.z xd
    bcc __b13
    lda.z y0
    sta.z bitmap_line_ydxi.y
    ldx.z x0
    sty.z bitmap_line_ydxi.y1
    jsr bitmap_line_ydxi
    rts
  __b13:
    ldx.z x0
    lda.z x1
    sta.z bitmap_line_xdyi.x1
    jsr bitmap_line_xdyi
    rts
}
// bitmap_line_xdyi(byte register(X) x, byte zeropage(2) y, byte zeropage(3) x1, byte zeropage($d) xd, byte zeropage(4) yd)
bitmap_line_xdyi: {
    .label __6 = 7
    .label y = 2
    .label x1 = 3
    .label xd = $d
    .label yd = 4
    .label e = $c
    lda.z yd
    lsr
    sta.z e
  __b1:
    ldy.z y
    jsr bitmap_plot
    inx
    lda.z e
    clc
    adc.z yd
    sta.z e
    lda.z xd
    cmp.z e
    bcs __b2
    inc.z y
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    ldy.z x1
    iny
    sty.z __6
    cpx.z __6
    bne __b1
    rts
}
// bitmap_plot(byte register(X) x, byte register(Y) y)
bitmap_plot: {
    .label plotter_x = 8
    .label plotter_y = $a
    .label plotter = 8
    lda bitmap_plot_xhi,x
    sta.z plotter_x+1
    lda bitmap_plot_xlo,x
    sta.z plotter_x
    lda bitmap_plot_yhi,y
    sta.z plotter_y+1
    lda bitmap_plot_ylo,y
    sta.z plotter_y
    lda.z plotter
    clc
    adc.z plotter_y
    sta.z plotter
    lda.z plotter+1
    adc.z plotter_y+1
    sta.z plotter+1
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// bitmap_line_ydxi(byte zeropage($c) y, byte register(X) x, byte zeropage(2) y1, byte zeropage(4) yd, byte zeropage($d) xd)
bitmap_line_ydxi: {
    .label y = $c
    .label y1 = 2
    .label yd = 4
    .label xd = $d
    .label e = 3
    lda.z xd
    lsr
    sta.z e
  __b1:
    ldy.z y
    jsr bitmap_plot
    inc.z y
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda.z yd
    cmp.z e
    bcs __b2
    inx
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    ldy.z y1
    iny
    cpy.z y
    bne __b1
    rts
}
// bitmap_line_xdyd(byte register(X) x, byte zeropage(2) y, byte zeropage(5) x1, byte zeropage($d) xd, byte zeropage(7) yd)
bitmap_line_xdyd: {
    .label __6 = $c
    .label y = 2
    .label x1 = 5
    .label xd = $d
    .label yd = 7
    .label e = 4
    lda.z yd
    lsr
    sta.z e
  __b1:
    ldy.z y
    jsr bitmap_plot
    inx
    lda.z e
    clc
    adc.z yd
    sta.z e
    lda.z xd
    cmp.z e
    bcs __b2
    dec.z y
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    ldy.z x1
    iny
    sty.z __6
    cpx.z __6
    bne __b1
    rts
}
// bitmap_line_ydxd(byte zeropage($c) y, byte register(X) x, byte zeropage(2) y1, byte zeropage(7) yd, byte zeropage($d) xd)
bitmap_line_ydxd: {
    .label y = $c
    .label y1 = 2
    .label yd = 7
    .label xd = $d
    .label e = 5
    lda.z xd
    lsr
    sta.z e
  __b1:
    ldy.z y
    jsr bitmap_plot
    inc.z y
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda.z yd
    cmp.z e
    bcs __b2
    dex
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    ldy.z y1
    iny
    cpy.z y
    bne __b1
    rts
}
init_screen: {
    .label c = 8
    lda #<SCREEN
    sta.z c
    lda #>SCREEN
    sta.z c+1
  __b1:
    lda.z c+1
    cmp #>SCREEN+$400
    bne __b2
    lda.z c
    cmp #<SCREEN+$400
    bne __b2
    rts
  __b2:
    lda #$14
    ldy #0
    sta (c),y
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = 8
    .label y = 6
    lda bitmap_plot_xlo
    sta.z bitmap
    lda bitmap_plot_xhi
    sta.z bitmap+1
    lda #0
    sta.z y
  __b1:
    ldx #0
  __b2:
    lda #0
    tay
    sta (bitmap),y
    inc.z bitmap
    bne !+
    inc.z bitmap+1
  !:
    inx
    cpx #$c8
    bne __b2
    inc.z y
    lda #$28
    cmp.z y
    bne __b1
    rts
}
// Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .label __10 = $d
    .label yoffs = 8
    ldy #$80
    ldx #0
  __b1:
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
    bne __b2
    ldy #$80
  __b2:
    inx
    cpx #0
    bne __b1
    lda #<0
    sta.z yoffs
    sta.z yoffs+1
    tax
  __b3:
    lda #7
    sax.z __10
    lda.z yoffs
    ora.z __10
    sta bitmap_plot_ylo,x
    lda.z yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp.z __10
    bne __b4
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    inx
    cpx #0
    bne __b3
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
