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
    ldy _3
    stx line.y1
    jsr line
    inc l
    lda l
    cmp #lines_cnt
    bcc b1
    rts
}
line: {
    .label x0 = 5
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
    sty $ff
    lda y1
    sec
    sbc $ff
    sta yd
    cmp xd
    bcs b3
    ldx x0
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
    ldx x0
    lda y1
    sta line_ydxi.y1
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
    ldx x0
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
    ldx x1
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
    sty $ff
    lda y1
    sec
    sbc $ff
    sta yd
    cmp xd
    bcs b10
    ldx x1
    lda y1
    sta line_xdyd.y
    lda xd
    sta line_xdyd.xd
    lda yd
    sta line_xdyd.yd
    jsr line_xdyd
    jmp breturn
  b10:
    sty line_ydxd.y
    ldx x0
    lda y1
    sta line_ydxd.y1
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
    ldx x1
    lda y1
    sta line_xdyi.y
    lda xd
    sta line_xdyi.xd
    lda yd
    sta line_xdyi.yd
    jsr line_xdyi
    jmp breturn
  b13:
    lda y1
    sta line_ydxi.y
    ldx x1
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
    lda y1
    clc
    adc #1
    cmp y
    bcs b1
    rts
}
plot: {
    .label plotter_x = 8
    .label plotter_y = $b
    .label plotter = 8
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
    lda plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
line_xdyi: {
    .label _8 = $a
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
    lda x1
    clc
    adc #1
    sta _8
    cpx _8
    bcc b1
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
    lda y1
    clc
    adc #1
    cmp y
    bcs b1
    rts
}
line_xdyd: {
    .label _8 = $a
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
    lda x1
    clc
    adc #1
    sta _8
    cpx _8
    bcc b1
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
    bne b10
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
    .label b = 8
    .label c = 8
    lda #<BITMAP
    sta b
    lda #>BITMAP
    sta b+1
  b1:
    ldy #0
    tya
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
