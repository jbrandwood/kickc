.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PROCPORT_DDR = 0
  .const PROCPORT_DDR_MEMORY_MASK = 7
  .label PROCPORT = 1
  .const PROCPORT_RAM_IO = $35
  .label BORDERCOL = $d020
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D018 = $d018
  .label CIA2_PORT_A = $dd00
  .label CIA2_PORT_A_DDR = $dd02
  .label BITMAP = $a000
  .label SCREEN = $8800
  .const DELAY = 8
  jsr main
main: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>SCREEN)>>6
    .const toD0181_return = (>(SCREEN&$3fff)<<2)|(>BITMAP)>>2&$f
    sei
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    jsr bitmap_init
    jsr bitmap_clear
    jsr screen_fill
    ldx #0
  b1:
    jsr point_init
    txa
    lsr
    tay
    lda x_start,x
    sta bitmap_plot.x
    lda x_start+1,x
    sta bitmap_plot.x+1
    lda y_start,y
    jsr bitmap_plot
    inx
    inx
    cpx #8
    bne b1
  b3:
    inc BORDERCOL
    jmp b3
}
bitmap_plot: {
    .label _1 = 7
    .label x = 3
    .label plotter = 5
    .label _3 = 5
    tay
    lda bitmap_plot_yhi,y
    sta _3+1
    lda bitmap_plot_ylo,y
    sta _3
    lda x
    and #<$fff8
    sta _1
    lda x+1
    and #>$fff8
    sta _1+1
    lda plotter
    clc
    adc _1
    sta plotter
    lda plotter+1
    adc _1+1
    sta plotter+1
    lda x
    tay
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
point_init: {
    .label _0 = 3
    .label _2 = 3
    .label _3 = 3
    lda x_start,x
    sta _0
    lda x_start+1,x
    sta _0+1
    asl _0
    rol _0+1
    asl _0
    rol _0+1
    asl _0
    rol _0+1
    asl _0
    rol _0+1
    lda _0
    sta x_cur,x
    lda _0+1
    sta x_cur+1,x
    txa
    lsr
    tay
    lda y_start,y
    sta _2
    lda #0
    sta _2+1
    asl _3
    rol _3+1
    asl _3
    rol _3+1
    asl _3
    rol _3+1
    asl _3
    rol _3+1
    lda _3
    sta y_cur,x
    lda _3+1
    sta y_cur+1,x
    txa
    lsr
    tay
    lda #DELAY
    sta delay,y
    rts
}
screen_fill: {
    .const ch = $10
    .label screen = 3
    .label y = 2
    lda #0
    sta y
    lda #<SCREEN
    sta screen
    lda #>SCREEN
    sta screen+1
  b1:
    ldx #0
  b2:
    lda #ch
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx #$28
    bne b2
    inc y
    lda y
    cmp #$19
    bne b1
    rts
}
bitmap_clear: {
    .label bitmap = 3
    .label y = 2
    .label _3 = 3
    lda bitmap_plot_ylo+0
    sta _3
    lda bitmap_plot_yhi+0
    sta _3+1
    lda #0
    sta y
  b1:
    ldx #0
  b2:
    lda #0
    tay
    sta (bitmap),y
    inc bitmap
    bne !+
    inc bitmap+1
  !:
    inx
    cpx #$c8
    bne b2
    inc y
    lda y
    cmp #$28
    bne b1
    rts
}
bitmap_init: {
    .label _3 = 2
    .label yoffs = 3
    ldx #0
    lda #$80
  b1:
    sta bitmap_plot_bit,x
    lsr
    cmp #0
    bne b2
    lda #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #<BITMAP
    sta yoffs
    lda #>BITMAP
    sta yoffs+1
    ldx #0
  b3:
    txa
    and #7
    sta _3
    lda yoffs
    ora _3
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
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
  x_start: .word $a, $14, $1e, $1e
  y_start: .byte $a, $a, $a, $14
  x_cur: .fill 8, 0
  y_cur: .fill 8, 0
  delay: .fill 4, 0
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
