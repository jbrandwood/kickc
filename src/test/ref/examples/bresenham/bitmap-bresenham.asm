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
    // *BORDERCOL = 0
    lda #0
    sta BORDERCOL
    // *BGCOL = 0
    sta BGCOL
    // *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    // *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)BITMAP&$3fff)/$400))
    lda #(SCREEN&$3fff)/$40|(BITMAP&$3fff)/$400
    sta VIC_MEMORY
    // bitmap_init(BITMAP)
    jsr bitmap_init
    // bitmap_clear()
    jsr bitmap_clear
    // init_screen()
    jsr init_screen
  __b1:
    // lines()
    jsr lines
    jmp __b1
}
lines: {
    .label l = 8
    lda #0
    sta.z l
  __b1:
    // for(byte l=0; l<lines_cnt;l++)
    lda.z l
    cmp #lines_cnt
    bcc __b2
    // }
    rts
  __b2:
    // bitmap_line(lines_x[l], lines_x[l+1], lines_y[l], lines_y[l+1])
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
    // for(byte l=0; l<lines_cnt;l++)
    inc.z l
    jmp __b1
}
// Draw a line on the bitmap
// bitmap_line(byte zp(3) x0, byte zp(6) x1, byte zp(4) y0, byte register(Y) y1)
bitmap_line: {
    .label xd = 2
    .label yd = 5
    .label yd_1 = $e
    .label x0 = 3
    .label x1 = 6
    .label y0 = 4
    // if(x0<x1)
    lda.z x0
    cmp.z x1
    bcc __b1
    // xd = x0-x1
    sec
    sbc.z x1
    sta.z xd
    // if(y0<y1)
    tya
    cmp.z y0
    beq !+
    bcs __b7
  !:
    // yd = y0-y1
    tya
    eor #$ff
    sec
    adc.z y0
    sta.z yd_1
    // if(yd<xd)
    cmp.z xd
    bcc __b8
    // bitmap_line_ydxi(y1, x1, y0, yd, xd)
    sty.z bitmap_line_ydxi.y
    ldx.z x1
    jsr bitmap_line_ydxi
    // }
    rts
  __b8:
    // bitmap_line_xdyi(x1, y1, x0, xd, yd)
    ldx.z x1
    sty.z bitmap_line_xdyi.y
    jsr bitmap_line_xdyi
    rts
  __b7:
    // yd = y1-y0
    tya
    sec
    sbc.z y0
    sta.z yd
    // if(yd<xd)
    cmp.z xd
    bcc __b9
    // bitmap_line_ydxd(y0, x0, y1, yd, xd)
    lda.z y0
    sta.z bitmap_line_ydxd.y
    ldx.z x0
    sty.z bitmap_line_ydxd.y1
    jsr bitmap_line_ydxd
    rts
  __b9:
    // bitmap_line_xdyd(x1, y1, x0, xd, yd)
    ldx.z x1
    sty.z bitmap_line_xdyd.y
    lda.z x0
    sta.z bitmap_line_xdyd.x1
    jsr bitmap_line_xdyd
    rts
  __b1:
    // xd = x1-x0
    lda.z x1
    sec
    sbc.z x0
    sta.z xd
    // if(y0<y1)
    tya
    cmp.z y0
    beq !+
    bcs __b11
  !:
    // yd = y0-y1
    tya
    eor #$ff
    sec
    adc.z y0
    sta.z yd
    // if(yd<xd)
    cmp.z xd
    bcc __b12
    // bitmap_line_ydxd(y1, x1, y0, yd, xd)
    sty.z bitmap_line_ydxd.y
    ldx.z x1
    jsr bitmap_line_ydxd
    rts
  __b12:
    // bitmap_line_xdyd(x0, y0, x1, xd, yd)
    ldx.z x0
    jsr bitmap_line_xdyd
    rts
  __b11:
    // yd = y1-y0
    tya
    sec
    sbc.z y0
    sta.z yd_1
    // if(yd<xd)
    cmp.z xd
    bcc __b13
    // bitmap_line_ydxi(y0, x0, y1, yd, xd)
    lda.z y0
    sta.z bitmap_line_ydxi.y
    ldx.z x0
    sty.z bitmap_line_ydxi.y1
    jsr bitmap_line_ydxi
    rts
  __b13:
    // bitmap_line_xdyi(x0, y0, x1, xd, yd)
    ldx.z x0
    lda.z x1
    sta.z bitmap_line_xdyi.x1
    jsr bitmap_line_xdyi
    rts
}
// bitmap_line_xdyi(byte register(X) x, byte zp(4) y, byte zp(3) x1, byte zp(2) xd, byte zp($e) yd)
bitmap_line_xdyi: {
    .label __6 = $d
    .label y = 4
    .label x1 = 3
    .label xd = 2
    .label yd = $e
    .label e = 7
    // e = yd>>1
    lda.z yd
    lsr
    sta.z e
  __b1:
    // bitmap_plot(x,y)
    ldy.z y
    jsr bitmap_plot
    // x++;
    inx
    // e = e+yd
    lda.z e
    clc
    adc.z yd
    sta.z e
    // if(xd<e)
    lda.z xd
    cmp.z e
    bcs __b2
    // y++;
    inc.z y
    // e = e - xd
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    // x1+1
    ldy.z x1
    iny
    sty.z __6
    // while (x!=(x1+1))
    cpx.z __6
    bne __b1
    // }
    rts
}
// bitmap_plot(byte register(X) x, byte register(Y) y)
bitmap_plot: {
    .label plotter_x = 9
    .label plotter_y = $b
    .label plotter = 9
    // plotter_x = { bitmap_plot_xhi[x], bitmap_plot_xlo[x] }
    lda bitmap_plot_xhi,x
    sta.z plotter_x+1
    lda bitmap_plot_xlo,x
    sta.z plotter_x
    // plotter_y = { bitmap_plot_yhi[y], bitmap_plot_ylo[y] }
    lda bitmap_plot_yhi,y
    sta.z plotter_y+1
    lda bitmap_plot_ylo,y
    sta.z plotter_y
    // plotter_x+plotter_y
    lda.z plotter
    clc
    adc.z plotter_y
    sta.z plotter
    lda.z plotter+1
    adc.z plotter_y+1
    sta.z plotter+1
    // *plotter | bitmap_plot_bit[x]
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    // *plotter = *plotter | bitmap_plot_bit[x]
    sta (plotter),y
    // }
    rts
}
// bitmap_line_ydxi(byte zp(7) y, byte register(X) x, byte zp(4) y1, byte zp($e) yd, byte zp(2) xd)
bitmap_line_ydxi: {
    .label y = 7
    .label y1 = 4
    .label yd = $e
    .label xd = 2
    .label e = 5
    // e = xd>>1
    lda.z xd
    lsr
    sta.z e
  __b1:
    // bitmap_plot(x,y)
    ldy.z y
    jsr bitmap_plot
    // y++;
    inc.z y
    // e = e+xd
    lda.z e
    clc
    adc.z xd
    sta.z e
    // if(yd<e)
    lda.z yd
    cmp.z e
    bcs __b2
    // x++;
    inx
    // e = e - yd
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    // y1+1
    ldy.z y1
    iny
    // while (y!=(y1+1))
    cpy.z y
    bne __b1
    // }
    rts
}
// bitmap_line_xdyd(byte register(X) x, byte zp(4) y, byte zp(6) x1, byte zp(2) xd, byte zp(5) yd)
bitmap_line_xdyd: {
    .label __6 = $d
    .label y = 4
    .label x1 = 6
    .label xd = 2
    .label yd = 5
    .label e = 7
    // e = yd>>1
    lda.z yd
    lsr
    sta.z e
  __b1:
    // bitmap_plot(x,y)
    ldy.z y
    jsr bitmap_plot
    // x++;
    inx
    // e = e+yd
    lda.z e
    clc
    adc.z yd
    sta.z e
    // if(xd<e)
    lda.z xd
    cmp.z e
    bcs __b2
    // y--;
    dec.z y
    // e = e - xd
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    // x1+1
    ldy.z x1
    iny
    sty.z __6
    // while (x!=(x1+1))
    cpx.z __6
    bne __b1
    // }
    rts
}
// bitmap_line_ydxd(byte zp(7) y, byte register(X) x, byte zp(4) y1, byte zp(5) yd, byte zp(2) xd)
bitmap_line_ydxd: {
    .label y = 7
    .label y1 = 4
    .label yd = 5
    .label xd = 2
    .label e = $d
    // e = xd>>1
    lda.z xd
    lsr
    sta.z e
  __b1:
    // bitmap_plot(x,y)
    ldy.z y
    jsr bitmap_plot
    // y = y++;
    inc.z y
    // e = e+xd
    lda.z e
    clc
    adc.z xd
    sta.z e
    // if(yd<e)
    lda.z yd
    cmp.z e
    bcs __b2
    // x--;
    dex
    // e = e - yd
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    // y1+1
    ldy.z y1
    iny
    // while (y!=(y1+1))
    cpy.z y
    bne __b1
    // }
    rts
}
init_screen: {
    .label c = 9
    lda #<SCREEN
    sta.z c
    lda #>SCREEN
    sta.z c+1
  __b1:
    // for(byte* c = SCREEN; c!=SCREEN+$400;c++)
    lda.z c+1
    cmp #>SCREEN+$400
    bne __b2
    lda.z c
    cmp #<SCREEN+$400
    bne __b2
    // }
    rts
  __b2:
    // *c = $14
    lda #$14
    ldy #0
    sta (c),y
    // for(byte* c = SCREEN; c!=SCREEN+$400;c++)
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = 9
    .label y = 8
    // (byte*) { bitmap_plot_xhi[0], bitmap_plot_xlo[0] }
    lda bitmap_plot_xlo
    sta.z bitmap
    lda bitmap_plot_xhi
    sta.z bitmap+1
    lda #0
    sta.z y
  __b1:
    ldx #0
  __b2:
    // *bitmap++ = 0
    lda #0
    tay
    sta (bitmap),y
    // *bitmap++ = 0;
    inc.z bitmap
    bne !+
    inc.z bitmap+1
  !:
    // for( byte x: 0..199 )
    inx
    cpx #$c8
    bne __b2
    // for( byte y: 0..39 )
    inc.z y
    lda #$28
    cmp.z y
    bne __b1
    // }
    rts
}
// Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .label __10 = $e
    .label yoffs = 9
    ldy #$80
    ldx #0
  __b1:
    // x&$f8
    txa
    and #$f8
    // bitmap_plot_xlo[x] = x&$f8
    sta bitmap_plot_xlo,x
    // bitmap_plot_xhi[x] = >bitmap
    lda #>BITMAP
    sta bitmap_plot_xhi,x
    // bitmap_plot_bit[x] = bits
    tya
    sta bitmap_plot_bit,x
    // bits = bits>>1
    tya
    lsr
    tay
    // if(bits==0)
    cpy #0
    bne __b2
    ldy #$80
  __b2:
    // for(byte x : 0..255)
    inx
    cpx #0
    bne __b1
    lda #<0
    sta.z yoffs
    sta.z yoffs+1
    tax
  __b3:
    // y&$7
    lda #7
    sax.z __10
    // <yoffs
    lda.z yoffs
    // y&$7 | <yoffs
    ora.z __10
    // bitmap_plot_ylo[y] = y&$7 | <yoffs
    sta bitmap_plot_ylo,x
    // >yoffs
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = >yoffs
    sta bitmap_plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __10
    bne __b4
    // yoffs = yoffs + 40*8
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    // for(byte y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
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
