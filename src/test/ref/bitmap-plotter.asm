.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label D011 = $d011
  .const BMM = $20
  .const DEN = $10
  .const RSEL = 8
  .label RASTER = $d012
  .label D018 = $d018
  .label BGCOL = $d020
  .label FGCOL = $d021
  .label SCREEN = $400
  .label BITMAP = $2000
  .const plots_cnt = 8
main: {
    lda #0
    sta BGCOL
    sta FGCOL
    lda #BMM|DEN|RSEL|3
    sta D011
    lda #SCREEN/$40|BITMAP/$400
    sta D018
    jsr init_screen
    jsr init_plot_tables
  b1:
    lda #$ff
    cmp RASTER
    bne b1
    inc BGCOL
    jsr plots
    dec BGCOL
    jmp b1
}
plots: {
    ldx #0
  b1:
    lda plots_x,x
    sta plot.x
    lda plots_y,x
    sta plot.y
    jsr plot
    inx
    cpx #plots_cnt
    bcc b1
    rts
}
// plot(byte zeropage(7) x, byte zeropage(2) y)
plot: {
    .label x = 7
    .label y = 2
    .label plotter_x = 3
    .label plotter_y = 5
    .label plotter = 3
    ldy x
    lda plot_xhi,y
    sta plotter_x+1
    lda #<0
    sta plotter_x
    lda plot_xlo,y
    sta plotter_x
    ldy y
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
    ldy x
    ora plot_bit,y
    ldy #0
    sta (plotter),y
    rts
}
init_plot_tables: {
    .label _10 = 7
    .label yoffs = 5
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
    lda #7
    sax _10
    lda yoffs
    ora _10
    sta plot_ylo,x
    lda yoffs+1
    sta plot_yhi,x
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
init_screen: {
    .label b = 5
    .label c = 3
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
  plots_x: .byte $3c, $50, $6e, $50, $3c, $28, $a, $28
  plots_y: .byte $a, $28, $3c, $50, $6e, $50, $3c, $28
  plot_xlo: .fill $100, 0
  plot_xhi: .fill $100, 0
  plot_ylo: .fill $100, 0
  plot_yhi: .fill $100, 0
  plot_bit: .fill $100, 0
