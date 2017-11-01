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
  jsr main
main: {
    lda #0
    sta BGCOL
    sta FGCOL
    lda #BMM|DEN|RSEL|3
    sta D011
    lda #$18
    sta D018
    jsr initscreen
    jsr initplottables
    lda #0
    sta line.y
    ldx #$64
    sta line.x
    lda #$c8
    sta line.x1
    jsr line
    lda #$14
    sta line.y
    ldx #$8c
    lda #$a
    sta line.x
    lda #$8c
    sta line.x1
    jsr line
    rts
}
line: {
    .label xd = 8
    .label yd = 9
    .label x = 3
    .label y = 4
    .label e = 5
    .label x1 = 2
    lda x1
    sec
    sbc x
    sta xd
    txa
    sec
    sbc y
    sta yd
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
plot: {
    .label _5 = 12
    .label plotter_x = 6
    .label plotter_y = 10
    .label plotter = 6
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
initplottables: {
    .label _6 = 2
    .label yoffs = 6
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
initscreen: {
    .label b = 6
    .label c = 6
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
