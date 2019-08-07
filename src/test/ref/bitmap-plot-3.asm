// Tests the simple bitmap plotter
// Plots a few lines using the bresenham line algorithm
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D018 = $d018
  .const WHITE = 1
  .label BITMAP = $2000
  .label SCREEN = $400
  .label COSTAB = SINTAB+$40
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label _7 = $b
    .label _11 = $f
    .label a = 2
    .label i = $1b
    jsr bitmap_init
    jsr bitmap_clear
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #toD0181_return
    sta D018
    lda #0
    sta.z a
    sta.z i
  b2:
    ldy.z a
    lda COSTAB,y
    sta.z _7
    lda #0
    sta.z _7+1
    lda #$78
    clc
    adc.z bitmap_line.x1
    sta.z bitmap_line.x1
    bcc !+
    inc.z bitmap_line.x1+1
  !:
    ldy.z a
    lda SINTAB,y
    sta.z bitmap_line.y1
    lda #0
    sta.z bitmap_line.y1+1
    lda COSTAB+$20,y
    sta.z _11
    lda #0
    sta.z _11+1
    lda #$78
    clc
    adc.z bitmap_line.x2
    sta.z bitmap_line.x2
    bcc !+
    inc.z bitmap_line.x2+1
  !:
    ldy.z a
    lda SINTAB+$20,y
    sta.z bitmap_line.y2
    lda #0
    sta.z bitmap_line.y2+1
    jsr bitmap_line
    lax.z a
    axs #-[$20]
    stx.z a
    inc.z i
    lda #8
    cmp.z i
    bne b2
  b3:
    inc SCREEN+$3e7
    jmp b3
}
// Draw a line on the bitmap using bresenhams algorithm
// bitmap_line(word zeropage($b) x1, word zeropage(9) y1, word zeropage($f) x2, word zeropage($11) y2)
bitmap_line: {
    .label dx = $13
    .label dy = 7
    .label sx = $15
    .label sy = 5
    .label e1 = $d
    .label e = 3
    .label y = 9
    .label x = $b
    .label x1 = $b
    .label y1 = 9
    .label x2 = $f
    .label y2 = $11
    lda.z x2
    sec
    sbc.z x1
    sta.z abs_u16.w
    lda.z x2+1
    sbc.z x1+1
    sta.z abs_u16.w+1
    jsr abs_u16
    lda.z abs_u16.return
    sta.z dx
    lda.z abs_u16.return+1
    sta.z dx+1
    lda.z y2
    sec
    sbc.z y1
    sta.z abs_u16.w
    lda.z y2+1
    sbc.z y1+1
    sta.z abs_u16.w+1
    jsr abs_u16
    lda.z dx
    bne b1
    lda.z dx+1
    bne b1
    lda.z dy
    bne !+
    lda.z dy+1
    bne !b4+
    jmp b4
  !b4:
  !:
  b1:
    lda.z x2
    sec
    sbc.z x1
    sta.z sgn_u16.w
    lda.z x2+1
    sbc.z x1+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    lda.z sgn_u16.return
    sta.z sx
    lda.z sgn_u16.return+1
    sta.z sx+1
    lda.z y2
    sec
    sbc.z y1
    sta.z sgn_u16.w
    lda.z y2+1
    sbc.z y1+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    lda.z dy+1
    cmp.z dx+1
    bcc b2
    bne !+
    lda.z dy
    cmp.z dx
    bcc b2
  !:
    lda.z dx+1
    lsr
    sta.z e+1
    lda.z dx
    ror
    sta.z e
  b6:
    lda.z y
    tax
    jsr bitmap_plot
    lda.z y
    clc
    adc.z sy
    sta.z y
    lda.z y+1
    adc.z sy+1
    sta.z y+1
    lda.z e
    clc
    adc.z dx
    sta.z e
    lda.z e+1
    adc.z dx+1
    sta.z e+1
    cmp.z dy+1
    bne !+
    lda.z e
    cmp.z dy
    beq b7
  !:
    bcc b7
    lda.z x
    clc
    adc.z sx
    sta.z x
    lda.z x+1
    adc.z sx+1
    sta.z x+1
    lda.z e
    sec
    sbc.z dy
    sta.z e
    lda.z e+1
    sbc.z dy+1
    sta.z e+1
  b7:
    lda.z y+1
    cmp.z y2+1
    bne b6
    lda.z y
    cmp.z y2
    bne b6
  b3:
    lda.z y
    tax
    jsr bitmap_plot
    rts
  b2:
    lda.z dy+1
    lsr
    sta.z e1+1
    lda.z dy
    ror
    sta.z e1
  b9:
    lda.z y
    tax
    jsr bitmap_plot
    lda.z x
    clc
    adc.z sx
    sta.z x
    lda.z x+1
    adc.z sx+1
    sta.z x+1
    lda.z e1
    clc
    adc.z dy
    sta.z e1
    lda.z e1+1
    adc.z dy+1
    sta.z e1+1
    cmp.z dx+1
    bne !+
    lda.z e1
    cmp.z dx
    beq b10
  !:
    bcc b10
    lda.z y
    clc
    adc.z sy
    sta.z y
    lda.z y+1
    adc.z sy+1
    sta.z y+1
    lda.z e1
    sec
    sbc.z dx
    sta.z e1
    lda.z e1+1
    sbc.z dx+1
    sta.z e1+1
  b10:
    lda.z x+1
    cmp.z x2+1
    bne b9
    lda.z x
    cmp.z x2
    bne b9
    jmp b3
  b4:
    lda.z y1
    tax
    jsr bitmap_plot
    rts
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage($b) x, byte register(X) y)
bitmap_plot: {
    .label _1 = $19
    .label plotter = $17
    .label x = $b
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    lda.z x
    and #<$fff8
    sta.z _1
    lda.z x+1
    and #>$fff8
    sta.z _1+1
    lda.z plotter
    clc
    adc.z _1
    sta.z plotter
    lda.z plotter+1
    adc.z _1+1
    sta.z plotter+1
    lda.z x
    tay
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
// sgn_u16(word zeropage(3) w)
sgn_u16: {
    .label w = 3
    .label return = 5
    lda.z w+1
    and #$80
    cmp #0
    bne b1
    lda #<1
    sta.z return
    lda #>1
    sta.z return+1
    rts
  b1:
    lda #<-1
    sta.z return
    lda #>-1
    sta.z return+1
    rts
}
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// abs_u16(word zeropage(7) w)
abs_u16: {
    .label w = 7
    .label return = 7
    lda.z w+1
    and #$80
    cmp #0
    bne b1
    rts
  b1:
    sec
    lda #0
    sbc.z return
    sta.z return
    lda #0
    sbc.z return+1
    sta.z return+1
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE*$10
    ldx #col
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    ldx #0
    lda #<BITMAP
    sta.z memset.str
    lda #>BITMAP
    sta.z memset.str+1
    lda #<$1f40
    sta.z memset.num
    lda #>$1f40
    sta.z memset.num+1
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($b) str, byte register(X) c, word zeropage(9) num)
memset: {
    .label end = 9
    .label dst = $b
    .label num = 9
    .label str = $b
    lda.z num
    bne !+
    lda.z num+1
    beq breturn
  !:
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  b2:
    lda.z dst+1
    cmp.z end+1
    bne b3
    lda.z dst
    cmp.z end
    bne b3
  breturn:
    rts
  b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp b2
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label _7 = $1b
    .label yoffs = $d
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
    sta.z yoffs
    lda #>BITMAP
    sta.z yoffs+1
    ldx #0
  b3:
    lda #7
    sax.z _7
    lda.z yoffs
    ora.z _7
    sta bitmap_plot_ylo,x
    lda.z yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp.z _7
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
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  .align $100
SINTAB:
.fill $180, 99.5+99.5*sin(i*2*PI/256) 
