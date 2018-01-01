.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BGCOL = $d020
  .const FGCOL = $d021
  .const D018 = $d018
  .const D011 = $d011
  .const BMM = $20
  .const DEN = $10
  .const RSEL = 8
  .const SCREEN = $400
  .const BITMAP = $2000
  .const lines_cnt = 8
  jsr main
main: {
    lda #0
    sta BGCOL
    sta FGCOL
    lda #BMM|DEN|RSEL|3
    sta D011
    lda #$ff & ($ffff & SCREEN/$40|$ffff & BITMAP/$400)
    sta D018
    jsr init_screen
    jsr init_plot_tables
  b1:
    jsr lines
    jmp b1
}
lines: {
    ldx #0
  b1:
    lda lines_x,x
    sta line.x0
    lda lines_x+1,x
    sta line.x1
    ldy lines_y,x
    lda lines_y+1,x
    sta line.y1
    jsr line
    inx
    cpx #lines_cnt
    bcc b1
    rts
}
line: {
    .label x0 = 2
    .label x1 = 3
    .label y1 = 4
    .label xd = 7
    .label yd = $a
    lda x0
    cmp x1
    bcs b1
    lda x1
    sec
    sbc x0
    sta xd
    cpy y1
    bcs b2
    tya
    eor #$ff
    sec
    adc y1
    sta yd
    cmp xd
    bcs b3
    lda x0
    sta line_xdyi.x
    sty line_xdyi.y
    lda x1
    sta line_xdyi.x1
    lda xd
    sta line_xdyi.xd
    lda yd
    sta line_xdyi.yd
    jsr line_xdyi
  breturn:
    rts
  b3:
    sty line_ydxi.y
    lda x0
    sta line_ydxi.x
    lda yd
    sta line_ydxi.yd
    lda xd
    sta line_ydxi.xd
    jsr line_ydxi
    jmp breturn
  b2:
    tya
    sec
    sbc y1
    sta yd
    cmp xd
    bcs b6
    lda x0
    sta line_xdyd.x
    sty line_xdyd.y
    lda x1
    sta line_xdyd.x1
    lda xd
    sta line_xdyd.xd
    lda yd
    sta line_xdyd.yd
    jsr line_xdyd
    jmp breturn
  b6:
    lda y1
    sta line_ydxd.y
    lda x1
    sta line_ydxd.x
    sty line_ydxd.y1
    lda yd
    sta line_ydxd.yd
    lda xd
    sta line_ydxd.xd
    jsr line_ydxd
    jmp breturn
  b1:
    lda x0
    sec
    sbc x1
    sta xd
    cpy y1
    bcs b9
    tya
    eor #$ff
    sec
    adc y1
    sta yd
    cmp xd
    bcs b10
    lda x1
    sta line_xdyd.x
    lda y1
    sta line_xdyd.y
    lda x0
    sta line_xdyd.x1
    lda xd
    sta line_xdyd.xd
    lda yd
    sta line_xdyd.yd
    jsr line_xdyd
    jmp breturn
  b10:
    sty line_ydxd.y
    lda x0
    sta line_ydxd.x
    lda yd
    sta line_ydxd.yd
    lda xd
    sta line_ydxd.xd
    jsr line_ydxd
    jmp breturn
  b9:
    tya
    sec
    sbc y1
    sta yd
    cmp xd
    bcs b13
    lda x1
    sta line_xdyi.x
    lda y1
    sta line_xdyi.y
    lda x0
    sta line_xdyi.x1
    lda xd
    sta line_xdyi.xd
    lda yd
    sta line_xdyi.yd
    jsr line_xdyi
    jmp breturn
  b13:
    lda y1
    sta line_ydxi.y
    lda x1
    sta line_ydxi.x
    sty line_ydxi.y1
    lda yd
    sta line_ydxi.yd
    lda xd
    sta line_ydxi.xd
    jsr line_ydxi
    jmp breturn
}
line_ydxi: {
    .label y = 6
    .label x = 5
    .label y1 = 4
    .label yd = 3
    .label xd = 2
    .label e = 7
    lda xd
    lsr
    sta e
  b1:
    jsr plot
    inc y
    lda xd
    clc
    adc e
    sta e
    lda yd
    cmp e
    bcs b2
    inc x
    lda e
    sec
    sbc yd
    sta e
  b2:
    lda y1
    clc
    adc #1
    cmp y
    bne b1
    rts
}
plot: {
    .label _0 = 8
    .label x = 5
    .label y = 6
    .label plotter_x = 8
    .label plotter_y = $b
    .label plotter = 8
    ldy x
    lda plot_xhi,y
    sta plotter_x+1
    lda plot_xlo,y
    sta plotter_x
    ldy y
    lda plot_yhi,y
    sta plotter_y+1
    lda plot_ylo,y
    sta plotter_y
    lda _0
    clc
    adc plotter_y
    sta _0
    lda _0+1
    adc plotter_y+1
    sta _0+1
    ldy x
    lda plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
line_xdyi: {
    .label x = 5
    .label y = 6
    .label x1 = 4
    .label xd = 3
    .label yd = 2
    .label e = 7
    lda yd
    lsr
    sta e
  b1:
    jsr plot
    inc x
    lda yd
    clc
    adc e
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
    lda x1
    clc
    adc #1
    cmp x
    bne b1
    rts
}
line_ydxd: {
    .label y = 6
    .label x = 5
    .label y1 = 4
    .label yd = 3
    .label xd = 2
    .label e = 7
    lda xd
    lsr
    sta e
  b1:
    jsr plot
    inc y
    lda xd
    clc
    adc e
    sta e
    lda yd
    cmp e
    bcs b2
    dec x
    lda e
    sec
    sbc yd
    sta e
  b2:
    lda y1
    clc
    adc #1
    cmp y
    bne b1
    rts
}
line_xdyd: {
    .label x = 5
    .label y = 6
    .label x1 = 4
    .label xd = 3
    .label yd = 2
    .label e = 7
    lda yd
    lsr
    sta e
  b1:
    jsr plot
    inc x
    lda yd
    clc
    adc e
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
    lda x1
    clc
    adc #1
    cmp x
    bne b1
    rts
}
init_plot_tables: {
    .label _6 = 2
    .label yoffs = 8
    ldy #$80
    ldx #0
  b1:
    txa
    and #$f8
    sta plot_xlo,x
    lda #>BITMAP
    sta plot_xhi,x
    tya
    sta plot_bit,x
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
    sta plot_ylo,x
    lda yoffs+1
    sta plot_yhi,x
    txa
    and #7
    cmp #7
    bne b4
    lda yoffs
    clc
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
init_screen: {
    .label b = 8
    .label c = 8
    lda #<BITMAP
    sta b
    lda #>BITMAP
    sta b+1
  b1:
    lda #0
    tay
    sta (b),y
    inc b
    bne !+
    inc b+1
  !:
    lda b+1
    cmp #>BITMAP+$2000
    bne b1
    lda b
    cmp #<BITMAP+$2000
    bne b1
    lda #<SCREEN
    sta c
    lda #>SCREEN
    sta c+1
  b2:
    lda #$14
    ldy #0
    sta (c),y
    inc c
    bne !+
    inc c+1
  !:
    lda c+1
    cmp #>SCREEN+$400
    bne b2
    lda c
    cmp #<SCREEN+$400
    bne b2
    rts
}
  plot_xlo: .fill $100, 0
  plot_xhi: .fill $100, 0
  plot_ylo: .fill $100, 0
  plot_yhi: .fill $100, 0
  plot_bit: .fill $100, 0
  lines_x: .byte $3c, $50, $6e, $50, $3c, $28, $a, $28, $3c
  lines_y: .byte $a, $28, $3c, $50, $6e, $50, $3c, $28, $a
