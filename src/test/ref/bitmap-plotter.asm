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
    cpx #plots_cnt
    bcc b2
    rts
  b2:
    lda plots_x,x
    sta.z plot.x
    lda plots_y,x
    sta.z plot.y
    jsr plot
    inx
    jmp b1
}
// plot(byte zeropage(7) x, byte zeropage(2) y)
plot: {
    .label x = 7
    .label y = 2
    .label plotter_x = 3
    .label plotter_y = 5
    .label plotter = 3
    ldy.z x
    lda plot_xhi,y
    sta.z plotter_x+1
    lda #<0
    sta.z plotter_x
    lda plot_xlo,y
    sta.z plotter_x
    ldy.z y
    lda plot_yhi,y
    sta.z plotter_y+1
    lda #<0
    sta.z plotter_y
    lda plot_ylo,y
    sta.z plotter_y
    lda.z plotter
    clc
    adc.z plotter_y
    sta.z plotter
    lda.z plotter+1
    adc.z plotter_y+1
    sta.z plotter+1
    ldy #0
    lda (plotter),y
    ldy.z x
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
    sta.z yoffs
    sta.z yoffs+1
    tax
  b3:
    lda #7
    sax.z _10
    lda.z yoffs
    ora.z _10
    sta plot_ylo,x
    lda.z yoffs+1
    sta plot_yhi,x
    lda #7
    cmp.z _10
    bne b4
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
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
    sta.z b
    lda #>BITMAP
    sta.z b+1
  b1:
    lda.z b+1
    cmp #>BITMAP+$2000
    bne b2
    lda.z b
    cmp #<BITMAP+$2000
    bne b2
    lda #<SCREEN
    sta.z c
    lda #>SCREEN
    sta.z c+1
  b3:
    lda.z c+1
    cmp #>SCREEN+$400
    bne b4
    lda.z c
    cmp #<SCREEN+$400
    bne b4
    rts
  b4:
    lda #$14
    ldy #0
    sta (c),y
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp b3
  b2:
    lda #0
    tay
    sta (b),y
    inc.z b
    bne !+
    inc.z b+1
  !:
    jmp b1
}
  plots_x: .byte $3c, $50, $6e, $50, $3c, $28, $a, $28
  plots_y: .byte $a, $28, $3c, $50, $6e, $50, $3c, $28
  plot_xlo: .fill $100, 0
  plot_xhi: .fill $100, 0
  plot_ylo: .fill $100, 0
  plot_yhi: .fill $100, 0
  plot_bit: .fill $100, 0
