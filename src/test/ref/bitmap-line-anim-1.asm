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
  .label next = 2
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
    lda #0
    sta.z next
  __b1:
    // bitmap_line(0,next,0,100)
    lda.z next
    jsr bitmap_line
    // next++;
    inc.z next
    jmp __b1
}
// Draw a line on the bitmap
// bitmap_line(byte register(A) x1)
bitmap_line: {
    .label x0 = 0
    .label y0 = 0
    .label y1 = $64
    // if(x0<x1)
    cmp #x0
    beq !+
    bcs __b1
  !:
    // xd = x0-x1
    tax
    // if(yd<xd)
    cpx #y1
    beq !+
    bcs __b4
  !:
    // bitmap_line_ydxd(y0, x0, y1, yd, xd)
    stx.z bitmap_line_ydxd.xd
    jsr bitmap_line_ydxd
    // }
    rts
  __b4:
    // bitmap_line_xdyd(x1, y1, x0, xd, yd)
    sta.z bitmap_line_xdyd.x
    stx.z bitmap_line_xdyd.xd
    jsr bitmap_line_xdyd
    rts
  __b1:
    // xd = x1-x0
    tax
    // if(yd<xd)
    cpx #y1
    beq !+
    bcs __b7
  !:
    // bitmap_line_ydxi(y0, x0, y1, yd, xd)
    stx.z bitmap_line_ydxi.xd
    jsr bitmap_line_ydxi
    rts
  __b7:
    // bitmap_line_xdyi(x0, y0, x1, xd, yd)
    sta.z bitmap_line_xdyi.x1
    stx.z bitmap_line_xdyi.xd
    jsr bitmap_line_xdyi
    rts
}
// bitmap_line_xdyi(byte zp(3) x, byte zp(4) y, byte zp($b) x1, byte zp(6) xd)
bitmap_line_xdyi: {
    .label x1 = $b
    .label xd = 6
    .label x = 3
    .label e = 5
    .label y = 4
    lda #bitmap_line.y1>>1
    sta.z e
    lda #bitmap_line.y0
    sta.z y
    lda #bitmap_line.x0
    sta.z x
  __b1:
    // bitmap_plot(x,y)
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    // x++;
    inc.z x
    // e = e+yd
    lax.z e
    axs #-[bitmap_line.y1]
    stx.z e
    // if(xd<e)
    lda.z xd
    cmp.z e
    bcs __b2
    // y++;
    inc.z y
    // e = e - xd
    txa
    sec
    sbc.z xd
    sta.z e
  __b2:
    // x1+1
    ldx.z x1
    inx
    // while (x!=(x1+1))
    cpx.z x
    bne __b1
    // }
    rts
}
// bitmap_plot(byte register(X) x, byte register(Y) y)
bitmap_plot: {
    .label plotter_x = 7
    .label plotter_y = 9
    .label plotter = 7
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
// bitmap_line_ydxi(byte zp(4) y, byte zp(3) x, byte zp(6) xd)
bitmap_line_ydxi: {
    .label xd = 6
    .label e = 5
    .label y = 4
    .label x = 3
    // e = xd>>1
    lda.z xd
    lsr
    sta.z e
    lda #bitmap_line.y0
    sta.z y
    lda #bitmap_line.x0
    sta.z x
  __b1:
    // bitmap_plot(x,y)
    ldx.z x
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
    lda #bitmap_line.y1
    cmp.z e
    bcs __b2
    // x++;
    inc.z x
    // e = e - yd
    lax.z e
    axs #bitmap_line.y1
    stx.z e
  __b2:
    // while (y!=(y1+1))
    lda #bitmap_line.y1+1
    cmp.z y
    bne __b1
    // }
    rts
}
// bitmap_line_xdyd(byte zp(3) x, byte zp(4) y, byte zp(6) xd)
bitmap_line_xdyd: {
    .label x = 3
    .label xd = 6
    .label e = 5
    .label y = 4
    lda #bitmap_line.y1>>1
    sta.z e
    lda #bitmap_line.y1
    sta.z y
  __b1:
    // bitmap_plot(x,y)
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    // x++;
    inc.z x
    // e = e+yd
    lax.z e
    axs #-[bitmap_line.y1]
    stx.z e
    // if(xd<e)
    lda.z xd
    cmp.z e
    bcs __b2
    // y--;
    dec.z y
    // e = e - xd
    txa
    sec
    sbc.z xd
    sta.z e
  __b2:
    // while (x!=(x1+1))
    lda #1
    cmp.z x
    bne __b1
    // }
    rts
}
// bitmap_line_ydxd(byte zp(4) y, byte zp(3) x, byte zp(6) xd)
bitmap_line_ydxd: {
    .label xd = 6
    .label e = 5
    .label y = 4
    .label x = 3
    // e = xd>>1
    lda.z xd
    lsr
    sta.z e
    lda #bitmap_line.y0
    sta.z y
    lda #bitmap_line.x0
    sta.z x
  __b1:
    // bitmap_plot(x,y)
    ldx.z x
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
    lda #bitmap_line.y1
    cmp.z e
    bcs __b2
    // x--;
    dec.z x
    // e = e - yd
    lax.z e
    axs #bitmap_line.y1
    stx.z e
  __b2:
    // while (y!=(y1+1))
    lda #bitmap_line.y1+1
    cmp.z y
    bne __b1
    // }
    rts
}
init_screen: {
    .label c = 7
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
    .label bitmap = 7
    .label y = 6
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
    .label __10 = $b
    .label yoffs = 7
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
