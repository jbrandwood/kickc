// Illustrates problem with bitmap-draw.kc line()
// Reported by Janne Johansson
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
  .label next = 5
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
    lda #0
    sta.z next
  __b1:
    ldx.z next
    jsr bitmap_line
    inc.z next
    jmp __b1
}
// Draw a line on the bitmap
// bitmap_line(byte register(X) x1)
bitmap_line: {
    .label x0 = 0
    .label y0 = 0
    .label y1 = $64
    cpx #x0
    beq !+
    bcs __b1
  !:
    txa
    cmp #y1
    beq !+
    bcs __b4
  !:
    sta.z bitmap_line_ydxd.xd
    jsr bitmap_line_ydxd
    rts
  __b4:
    stx.z bitmap_line_xdyd.x
    sta.z bitmap_line_xdyd.xd
    jsr bitmap_line_xdyd
    rts
  __b1:
    txa
    cmp #y1
    beq !+
    bcs __b7
  !:
    sta.z bitmap_line_ydxi.xd
    jsr bitmap_line_ydxi
    rts
  __b7:
    stx.z bitmap_line_xdyi.x1
    sta.z bitmap_line_xdyi.xd
    jsr bitmap_line_xdyi
    rts
}
// bitmap_line_xdyi(byte zeropage(2) x, byte zeropage(3) y, byte zeropage(6) x1, byte zeropage($b) xd)
bitmap_line_xdyi: {
    .label x1 = 6
    .label xd = $b
    .label x = 2
    .label e = 4
    .label y = 3
    lda #bitmap_line.y1>>1
    sta.z e
    lda #bitmap_line.y0
    sta.z y
    lda #bitmap_line.x0
    sta.z x
  __b1:
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    inc.z x
    lax.z e
    axs #-[bitmap_line.y1]
    stx.z e
    lda.z xd
    cmp.z e
    bcs __b2
    inc.z y
    txa
    sec
    sbc.z xd
    sta.z e
  __b2:
    ldx.z x1
    inx
    cpx.z x
    bne __b1
    rts
}
// bitmap_plot(byte register(X) x, byte register(Y) y)
bitmap_plot: {
    .label plotter_x = 7
    .label plotter_y = 9
    .label plotter = 7
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
// bitmap_line_ydxi(byte zeropage(3) y, byte zeropage(2) x, byte zeropage(6) xd)
bitmap_line_ydxi: {
    .label xd = 6
    .label e = 4
    .label y = 3
    .label x = 2
    lda.z xd
    lsr
    sta.z e
    lda #bitmap_line.y0
    sta.z y
    lda #bitmap_line.x0
    sta.z x
  __b1:
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    inc.z y
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda #bitmap_line.y1
    cmp.z e
    bcs __b2
    inc.z x
    lax.z e
    axs #bitmap_line.y1
    stx.z e
  __b2:
    lda #bitmap_line.y1+1
    cmp.z y
    bne __b1
    rts
}
// bitmap_line_xdyd(byte zeropage(2) x, byte zeropage(3) y, byte zeropage(6) xd)
bitmap_line_xdyd: {
    .label x = 2
    .label xd = 6
    .label e = 4
    .label y = 3
    lda #bitmap_line.y1>>1
    sta.z e
    lda #bitmap_line.y1
    sta.z y
  __b1:
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    inc.z x
    lax.z e
    axs #-[bitmap_line.y1]
    stx.z e
    lda.z xd
    cmp.z e
    bcs __b2
    dec.z y
    txa
    sec
    sbc.z xd
    sta.z e
  __b2:
    lda #1
    cmp.z x
    bne __b1
    rts
}
// bitmap_line_ydxd(byte zeropage(3) y, byte zeropage(2) x, byte zeropage(6) xd)
bitmap_line_ydxd: {
    .label xd = 6
    .label e = 4
    .label y = 3
    .label x = 2
    lda.z xd
    lsr
    sta.z e
    lda #bitmap_line.y0
    sta.z y
    lda #bitmap_line.x0
    sta.z x
  __b1:
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    inc.z y
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda #bitmap_line.y1
    cmp.z e
    bcs __b2
    dec.z x
    lax.z e
    axs #bitmap_line.y1
    stx.z e
  __b2:
    lda #bitmap_line.y1+1
    cmp.z y
    bne __b1
    rts
}
init_screen: {
    .label c = 7
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
    .label bitmap = 7
    .label y = 5
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
    .label __10 = $b
    .label yoffs = 7
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
