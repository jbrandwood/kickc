.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const D011 = $d011
  .const RST8 = $80
  .const ECM = $40
  .const BMM = $20
  .const DEN = $10
  .const RSEL = 8
  .const RASTER = $d012
  .const D016 = $d016
  .const MCM = $10
  .const CSEL = 8
  .const D018 = $d018
  .const BGCOL = $d020
  .const FGCOL = $d021
  .const COLS = $d800
  .const SCREEN = $400
  .const BITMAP = $2000
  .const plots_cnt = 8
  .const plot_xlo = $1000
  .const plot_xhi = $1100
  .const plot_ylo = $1200
  .const plot_yhi = $1300
  .const plot_bit = $1400
  plots_x: .byte $3c, $50, $6e, $50, $3c, $28, $a, $28
  plots_y: .byte $a, $28, $3c, $50, $6e, $50, $3c, $28
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
  b2:
    lda RASTER
    cmp #$ff
    bne b2
    inc BGCOL
    jsr plots
    dec BGCOL
    jmp b2
    rts
}
plots: {
    .label i = 2
    lda #0
    sta i
  b1:
    ldx i
    lda plots_x,x
    tay
    ldx i
    lda plots_y,x
    tax
    jsr plot
    inc i
    lda i
    cmp #plots_cnt
    bcc b1
    rts
}
plot: {
    .label _5 = 7
    .label plotter_x = 3
    .label plotter_y = 5
    .label plotter = 3
    lda plot_xhi,y
    sta plotter_x+1
    lda #<0
    sta plotter_x
    lda plot_xlo,y
    sta plotter_x
    lda plot_yhi,x
    sta plotter_y+1
    lda #<0
    sta plotter_y
    lda plot_ylo,x
    sta plotter_y
    lda plotter
    clc
    adc plotter_y
    sta plotter
    lda plotter+1
    adc plotter_y+1
    sta plotter+1
    lda plot_bit,y
    sta _5
    ldy #0
    lda (plotter),y
    ora _5
    sta (plotter),y
    rts
}
init_plot_tables: {
    .label _6 = 2
    .label yoffs = 3
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
    .label b = 3
    .label c = 3
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
