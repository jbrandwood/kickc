.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const COLS = $d800
  .const BGCOL = $d020
  .const FGCOL = $d021
  .const SCROLL = $d016
  .const D018 = $d018
  .const D011 = $d011
  .const RST8 = $80
  .const ECM = $40
  .const BMM = $20
  .const DEN = $10
  .const RSEL = 8
  .const D016 = $d016
  .const MCM = $10
  .const CSEL = 8
  .const SCREEN = $400
  .const BITMAP = $2000
  .const plot_xlo = $1000
  .const plot_xhi = $1100
  .const plot_ylo = $1200
  .const plot_yhi = $1300
  .const plot_bit = $1400
  .const lines_cnt = 8
  lines_x: .byte $3c, $50, $6e, $50, $3c, $28, $a, $28, $3c
  lines_y: .byte $a, $28, $3c, $50, $6e, $50, $3c, $28, $a
  jsr main
main: {
    lda #0
    sta BGCOL
    sta FGCOL
    lda #BMM|DEN|RSEL|3
    sta D011
    lda #$18
    sta D018
    jsr init_screen
    jsr init_plot_tables
  b1:
    jsr lines
    jmp b1
    rts
}
lines: {
    .label _2 = 3
    .label _3 = 4
    .label l = 2
    lda #0
    sta l
  b1:
    ldx l
    lda lines_x,x
    tay
    ldx l
    lda lines_x+1,x
    sta _2
    ldx l
    lda lines_y,x
    sta _3
    ldx l
    lda lines_y+1,x
    tax
    sty line.x0
    ldy _2
    lda _3
    sta line.y0
    jsr line
    inc l
    lda l
    cmp #lines_cnt
    bcc b1
    rts
}
line: {
    .label x0 = 5
    .label y0 = 3
    .label xd = 8
    .label yd = 4
    cpy x0
    bcc b1
    tya
    sec
    sbc x0
    sta xd
    cpx y0
    bcc b2
    txa
    sec
    sbc y0
    sta yd
    lda yd
    cmp xd
    bcs b3
    lda x0
    sta line_xdyi.x
    lda y0
    sta line_xdyi.y
    sty line_xdyi.x1
    lda xd
    sta line_xdyi.xd
    lda yd
    sta line_xdyi.yd
    jsr line_xdyi
  breturn:
    rts
  b3:
    lda y0
    sta line_ydxi.y
    lda x0
    sta line_ydxi.x
    stx line_ydxi.y1
    lda xd
    sta line_ydxi.xd
    jsr line_ydxi
    jmp breturn
  b2:
    stx $ff
    lda y0
    sec
    sbc $ff
    sta yd
    lda yd
    cmp xd
    bcs b6
    lda x0
    sta line_xdyd.x
    lda y0
    sta line_xdyd.y
    sty line_xdyd.x1
    lda xd
    sta line_xdyd.xd
    lda yd
    sta line_xdyd.yd
    jsr line_xdyd
    jmp breturn
  b6:
    stx line_ydxd.y
    sty line_ydxd.x
    lda y0
    sta line_ydxd.y1
    lda yd
    sta line_ydxd.yd
    lda xd
    sta line_ydxd.xd
    jsr line_ydxd
    jmp breturn
  b1:
    sty $ff
    lda x0
    sec
    sbc $ff
    sta xd
    cpx y0
    bcc b9
    txa
    sec
    sbc y0
    sta yd
    lda yd
    cmp xd
    bcs b10
    sty line_xdyd.x
    stx line_xdyd.y
    lda x0
    sta line_xdyd.x1
    lda xd
    sta line_xdyd.xd
    lda yd
    sta line_xdyd.yd
    jsr line_xdyd
    jmp breturn
  b10:
    lda y0
    sta line_ydxd.y
    lda x0
    sta line_ydxd.x
    stx line_ydxd.y1
    lda yd
    sta line_ydxd.yd
    lda xd
    sta line_ydxd.xd
    jsr line_ydxd
    jmp breturn
  b9:
    stx $ff
    lda y0
    sec
    sbc $ff
    sta yd
    lda yd
    cmp xd
    bcs b13
    sty line_xdyi.x
    stx line_xdyi.y
    lda x0
    sta line_xdyi.x1
    lda xd
    sta line_xdyi.xd
    lda yd
    sta line_xdyi.yd
    jsr line_xdyi
    jmp breturn
  b13:
    stx line_ydxi.y
    sty line_ydxi.x
    lda y0
    sta line_ydxi.y1
    lda xd
    sta line_ydxi.xd
    jsr line_ydxi
    jmp breturn
}
line_ydxi: {
    .label y = 7
    .label x = 6
    .label y1 = 5
    .label yd = 4
    .label xd = 3
    .label e = 8
    lda xd
    lsr
    sta e
  b1:
    ldx x
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
    bcs b1
    rts
}
plot: {
    .label _5 = $1f
    .label plotter_x = $1b
    .label plotter_y = $1d
    .label plotter = $1b
    lda plot_xhi,x
    sta plotter_x+1
    lda #<0
    sta plotter_x
    lda plot_xlo,x
    sta plotter_x
    lda plot_yhi,y
    sta plotter_y+1
    lda #<0
    sta plotter_y
    lda plot_ylo,y
    sta plotter_y
    lda plotter
    clc
    adc plotter_y
    sta plotter
    lda plotter+1
    adc plotter_y+1
    sta plotter+1
    ldy #0
    lda (plotter),y
    sta _5
    lda plot_bit,x
    ora _5
    sta (plotter),y
    rts
}
line_xdyi: {
    .label x = $c
    .label y = $d
    .label x1 = $b
    .label xd = $a
    .label yd = 9
    .label e = $e
    lda yd
    lsr
    sta e
  b1:
    ldx x
    ldy y
    jsr plot
    inc x
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
    lda x1
    clc
    adc #1
    cmp x
    bcs b1
    rts
}
line_ydxd: {
    .label y = $13
    .label x = $12
    .label y1 = $11
    .label yd = $10
    .label xd = $f
    .label e = $14
    lda xd
    lsr
    sta e
  b1:
    ldx x
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
    bcs b1
    rts
}
line_xdyd: {
    .label x = $18
    .label y = $19
    .label x1 = $17
    .label xd = $16
    .label yd = $15
    .label e = $1a
    lda yd
    lsr
    sta e
  b1:
    ldx x
    ldy y
    jsr plot
    inc x
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
    lda x1
    clc
    adc #1
    cmp x
    bcs b1
    rts
}
init_plot_tables: {
    .label _6 = 2
    .label yoffs = $1b
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
    bne b10
    ldy #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #0
    sta yoffs
    sta yoffs+1
    ldx #0
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
    adc #<$140
    sta yoffs
    lda yoffs+1
    adc #>$140
    sta yoffs+1
  b4:
    inx
    cpx #0
    bne b3
    rts
  b10:
    jmp b2
}
init_screen: {
    .label b = $1b
    .label c = $1b
    lda #<BITMAP
    sta b
    lda #>BITMAP
    sta b+1
  b1:
    ldy #0
    lda #0
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
    ldy #0
    lda #$14
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
