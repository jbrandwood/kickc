.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d020
  .label FGCOL = $d021
  .label D018 = $d018
  .label D011 = $d011
  .const BMM = $20
  .const DEN = $10
  .const RSEL = 8
  .label SCREEN = $400
  .label BITMAP = $2000
  .const lines_cnt = 8
  jsr main
main: {
    lda #0
    sta BGCOL
    sta FGCOL
    lda #BMM|DEN|RSEL|3
    sta D011
    lda #($ffff&SCREEN)/$40|($ffff&BITMAP)/$400
    sta D018
    jsr init_screen
    jsr init_plot_tables
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
    sta line.x0
    lda lines_x+1,y
    sta line.x1
    lda lines_y,y
    sta line.y0
    ldx l
    ldy lines_y+1,x
    jsr line
    inc l
    lda l
    cmp #lines_cnt
    bcc b1
    rts
}
line: {
    .label x0 = 7
    .label x1 = 8
    .label y0 = 5
    .label xd = 3
    .label yd = 4
    lda x0
    cmp x1
    bcs b1
    lda x1
    sec
    sbc x0
    sta xd
    lda y0
    sty $ff
    cmp $ff
    bcs b2
    tya
    sec
    sbc y0
    sta yd
    cmp xd
    bcs b3
    ldx x0
    lda x1
    sta line_xdyi.x1
    jsr line_xdyi
  breturn:
    rts
  b3:
    lda y0
    sta line_ydxi.y
    ldx x0
    sty line_ydxi.y1
    jsr line_ydxi
    jmp breturn
  b2:
    tya
    eor #$ff
    sec
    adc y0
    sta yd
    cmp xd
    bcs b6
    ldx x0
    jsr line_xdyd
    jmp breturn
  b6:
    sty line_ydxd.y
    ldx x1
    jsr line_ydxd
    jmp breturn
  b1:
    lda x0
    sec
    sbc x1
    sta xd
    lda y0
    sty $ff
    cmp $ff
    bcs b9
    tya
    sec
    sbc y0
    sta yd
    cmp xd
    bcs b10
    ldx x1
    sty line_xdyd.y
    lda x0
    sta line_xdyd.x1
    jsr line_xdyd
    jmp breturn
  b10:
    lda y0
    sta line_ydxd.y
    ldx x0
    sty line_ydxd.y1
    jsr line_ydxd
    jmp breturn
  b9:
    tya
    eor #$ff
    sec
    adc y0
    sta yd
    cmp xd
    bcs b13
    ldx x1
    sty line_xdyi.y
    jsr line_xdyi
    jmp breturn
  b13:
    sty line_ydxi.y
    ldx x1
    jsr line_ydxi
    jmp breturn
}
line_ydxi: {
    .label y = 6
    .label y1 = 5
    .label yd = 4
    .label xd = 3
    .label e = 7
    lda xd
    lsr
    sta e
  b1:
    ldy y
    jsr plot
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
plot: {
    .label _0 = 9
    .label plotter_x = 9
    .label plotter_y = $b
    lda plot_xhi,x
    sta plotter_x+1
    lda plot_xlo,x
    sta plotter_x
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
    lda plot_bit,x
    ldy #0
    ora (_0),y
    sta (_0),y
    rts
}
line_xdyi: {
    .label _6 = 8
    .label y = 5
    .label x1 = 7
    .label xd = 3
    .label yd = 4
    .label e = 6
    lda yd
    lsr
    sta e
  b1:
    ldy y
    jsr plot
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
line_ydxd: {
    .label y = 6
    .label y1 = 5
    .label yd = 4
    .label xd = 3
    .label e = 7
    lda xd
    lsr
    sta e
  b1:
    ldy y
    jsr plot
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
line_xdyd: {
    .label _6 = 7
    .label y = 5
    .label x1 = 8
    .label xd = 3
    .label yd = 4
    .label e = 6
    lda yd
    lsr
    sta e
  b1:
    ldy y
    jsr plot
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
init_plot_tables: {
    .label _6 = 2
    .label yoffs = 9
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
init_screen: {
    .label b = 9
    .label c = 9
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
