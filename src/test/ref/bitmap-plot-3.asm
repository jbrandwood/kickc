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
    .label _6 = 8
    .label _10 = $18
    .label a = 2
    .label i = 3
    jsr bitmap_init
    jsr bitmap_clear
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #toD0181_return
    sta D018
    lda #0
    sta i
    sta a
  b1:
    ldy a
    lda COSTAB,y
    sta _6
    lda #0
    sta _6+1
    lda #$78
    clc
    adc bitmap_line.x1
    sta bitmap_line.x1
    bcc !+
    inc bitmap_line.x1+1
  !:
    ldy a
    lda SINTAB,y
    sta bitmap_line.y1
    lda #0
    sta bitmap_line.y1+1
    lda COSTAB+$20,y
    sta _10
    lda #0
    sta _10+1
    lda #$78
    clc
    adc bitmap_line.x2
    sta bitmap_line.x2
    bcc !+
    inc bitmap_line.x2+1
  !:
    ldy a
    lda SINTAB+$20,y
    sta bitmap_line.y2
    lda #0
    sta bitmap_line.y2+1
    jsr bitmap_line
    lax a
    axs #-[$20]
    stx a
    inc i
    lda #8
    cmp i
    bne b1
  b2:
    inc SCREEN+$3e7
    jmp b2
}
// Draw a line on the bitmap using bresenhams algorithm
// bitmap_line(word zeropage(8) x1, word zeropage(6) y1, word zeropage($18) x2, word zeropage($1a) y2)
bitmap_line: {
    .label dx = $1c
    .label dy = $10
    .label sx = $1e
    .label sy = $e
    .label e1 = $a
    .label e = 4
    .label y = 6
    .label x = 8
    .label x1 = 8
    .label y1 = 6
    .label x2 = $18
    .label y2 = $1a
    lda x2
    sec
    sbc x1
    sta abs_u16.w
    lda x2+1
    sbc x1+1
    sta abs_u16.w+1
    jsr abs_u16
    lda abs_u16.return
    sta dx
    lda abs_u16.return+1
    sta dx+1
    lda y2
    sec
    sbc y1
    sta abs_u16.w
    lda y2+1
    sbc y1+1
    sta abs_u16.w+1
    jsr abs_u16
    lda dx
    bne b1
    lda dx+1
    bne b1
    lda dy
    bne !+
    lda dy+1
    bne !b4+
    jmp b4
  !b4:
  !:
  b1:
    lda x2
    sec
    sbc x1
    sta sgn_u16.w
    lda x2+1
    sbc x1+1
    sta sgn_u16.w+1
    jsr sgn_u16
    lda sgn_u16.return
    sta sx
    lda sgn_u16.return+1
    sta sx+1
    lda y2
    sec
    sbc y1
    sta sgn_u16.w
    lda y2+1
    sbc y1+1
    sta sgn_u16.w+1
    jsr sgn_u16
    lda dy+1
    cmp dx+1
    bcc b2
    bne !+
    lda dy
    cmp dx
    bcc b2
  !:
    lda dx+1
    lsr
    sta e+1
    lda dx
    ror
    sta e
  b6:
    lda y
    tax
    jsr bitmap_plot
    lda y
    clc
    adc sy
    sta y
    lda y+1
    adc sy+1
    sta y+1
    lda e
    clc
    adc dx
    sta e
    lda e+1
    adc dx+1
    sta e+1
    cmp dy+1
    bne !+
    lda e
    cmp dy
    beq b7
  !:
    bcc b7
    lda x
    clc
    adc sx
    sta x
    lda x+1
    adc sx+1
    sta x+1
    lda e
    sec
    sbc dy
    sta e
    lda e+1
    sbc dy+1
    sta e+1
  b7:
    lda y+1
    cmp y2+1
    bne b6
    lda y
    cmp y2
    bne b6
  b3:
    lda y
    tax
    jsr bitmap_plot
    rts
  b2:
    lda dy+1
    lsr
    sta e1+1
    lda dy
    ror
    sta e1
  b9:
    lda y
    tax
    jsr bitmap_plot
    lda x
    clc
    adc sx
    sta x
    lda x+1
    adc sx+1
    sta x+1
    lda e1
    clc
    adc dy
    sta e1
    lda e1+1
    adc dy+1
    sta e1+1
    cmp dx+1
    bne !+
    lda e1
    cmp dx
    beq b10
  !:
    bcc b10
    lda y
    clc
    adc sy
    sta y
    lda y+1
    adc sy+1
    sta y+1
    lda e1
    sec
    sbc dx
    sta e1
    lda e1+1
    sbc dx+1
    sta e1+1
  b10:
    lda x+1
    cmp x2+1
    bne b9
    lda x
    cmp x2
    bne b9
    jmp b3
  b4:
    lda y1
    tax
    jsr bitmap_plot
    rts
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage(8) x, byte register(X) y)
bitmap_plot: {
    .label _1 = $22
    .label plotter = $20
    .label x = 8
    lda bitmap_plot_yhi,x
    sta plotter+1
    lda bitmap_plot_ylo,x
    sta plotter
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
// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
// sgn_u16(word zeropage($c) w)
sgn_u16: {
    .label w = $c
    .label return = $e
    lda w+1
    and #$80
    cmp #0
    bne b1
    lda #<1
    sta return
    lda #>1
    sta return+1
    rts
  b1:
    lda #<-1
    sta return
    lda #>-1
    sta return+1
    rts
}
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// abs_u16(word zeropage($10) w)
abs_u16: {
    .label w = $10
    .label return = $10
    lda w+1
    and #$80
    cmp #0
    bne b1
    rts
  b1:
    sec
    lda #0
    sbc return
    sta return
    lda #0
    sbc return+1
    sta return+1
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE*$10
    ldx #col
    lda #<SCREEN
    sta memset.str
    lda #>SCREEN
    sta memset.str+1
    lda #<$3e8
    sta memset.num
    lda #>$3e8
    sta memset.num+1
    jsr memset
    ldx #0
    lda #<BITMAP
    sta memset.str
    lda #>BITMAP
    sta memset.str+1
    lda #<$1f40
    sta memset.num
    lda #>$1f40
    sta memset.num+1
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($14) str, byte register(X) c, word zeropage($12) num)
memset: {
    .label end = $12
    .label dst = $14
    .label num = $12
    .label str = $14
    lda num
    beq breturn
    lda num+1
    beq breturn
    lda end
    clc
    adc str
    sta end
    lda end+1
    adc str+1
    sta end+1
  b2:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp end+1
    bne b2
    lda dst
    cmp end
    bne b2
  breturn:
    rts
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label _7 = $24
    .label yoffs = $16
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
    lda #7
    sax _7
    lda yoffs
    ora _7
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp _7
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
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  .align $100
SINTAB:
.fill $180, 99.5+99.5*sin(i*2*PI/256) 
