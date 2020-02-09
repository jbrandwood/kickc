// Shows that bitmap2.kc line() does not have the same problem as bitmap-draw.kc
// See bitmap-line-anim-1.kc
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label VIC_MEMORY = $d018
  .const WHITE = 1
  .const PURPLE = 4
  .label SCREEN = $400
  .label BITMAP = $2000
  .label next = $a
main: {
    lda #0
    sta BORDERCOL
    sta BGCOL
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #(SCREEN&$3fff)/$40|(BITMAP&$3fff)/$400
    sta VIC_MEMORY
    jsr bitmap_init
    jsr bitmap_clear
    lda #<0
    sta.z next
    sta.z next+1
  __b1:
    jsr bitmap_line
    inc.z next
    bne !+
    inc.z next+1
  !:
    lda.z next+1
    cmp #>$140
    bne __b1
    lda.z next
    cmp #<$140
    bne __b1
    lda #<0
    sta.z next
    sta.z next+1
    jmp __b1
}
// Draw a line on the bitmap using bresenhams algorithm
// bitmap_line(word zp($a) x2)
bitmap_line: {
    .const x1 = 0
    .const y1 = 0
    .const y2 = $64
    .label dx = $10
    .label dy = 8
    .label sx = $12
    .label sy = 6
    .label e1 = 2
    .label e = 4
    .label y = $c
    .label x = $e
    .label x2 = $a
    lda.z x2
    sta.z abs_u16.w
    lda.z x2+1
    sta.z abs_u16.w+1
    jsr abs_u16
    lda.z abs_u16.return
    sta.z dx
    lda.z abs_u16.return+1
    sta.z dx+1
    lda #<y2
    sta.z abs_u16.w
    lda #>y2
    sta.z abs_u16.w+1
    jsr abs_u16
    lda.z dx
    bne __b1
    lda.z dx+1
    bne __b1
    lda.z dy
    bne !+
    lda.z dy+1
    bne !__b4+
    jmp __b4
  !__b4:
  !:
  __b1:
    lda.z x2
    sta.z sgn_u16.w
    lda.z x2+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    lda.z sgn_u16.return
    sta.z sx
    lda.z sgn_u16.return+1
    sta.z sx+1
    lda #<y2
    sta.z sgn_u16.w
    lda #>y2
    sta.z sgn_u16.w+1
    jsr sgn_u16
    lda.z dy+1
    cmp.z dx+1
    bcc __b2
    bne !+
    lda.z dy
    cmp.z dx
    bcc __b2
  !:
    lda.z dx+1
    lsr
    sta.z e+1
    lda.z dx
    ror
    sta.z e
    lda #<x1
    sta.z x
    lda #>x1
    sta.z x+1
    lda #<y1
    sta.z y
    lda #>y1
    sta.z y+1
  __b6:
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
    beq __b7
  !:
    bcc __b7
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
  __b7:
    lda.z y+1
    cmp #>y2
    bne __b6
    lda.z y
    cmp #<y2
    bne __b6
  __b3:
    lda.z y
    tax
    jsr bitmap_plot
    rts
  __b2:
    lda.z dy+1
    lsr
    sta.z e1+1
    lda.z dy
    ror
    sta.z e1
    lda #<x1
    sta.z x
    lda #>x1
    sta.z x+1
    lda #<y1
    sta.z y
    lda #>y1
    sta.z y+1
  __b9:
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
    beq __b10
  !:
    bcc __b10
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
  __b10:
    lda.z x+1
    cmp.z x2+1
    bne __b9
    lda.z x
    cmp.z x2
    bne __b9
    jmp __b3
  __b4:
    lda #<x1
    sta.z bitmap_plot.x
    lda #>x1
    sta.z bitmap_plot.x+1
    ldx #0
    jsr bitmap_plot
    rts
}
// Plot a single dot in the bitmap
// bitmap_plot(word zp($e) x, byte register(X) y)
bitmap_plot: {
    .label __1 = $16
    .label plotter = $14
    .label x = $e
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    lda.z x
    and #<$fff8
    sta.z __1
    lda.z x+1
    and #>$fff8
    sta.z __1+1
    lda.z plotter
    clc
    adc.z __1
    sta.z plotter
    lda.z plotter+1
    adc.z __1+1
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
// sgn_u16(word zp(4) w)
sgn_u16: {
    .label w = 4
    .label return = 6
    lda.z w+1
    and #$80
    cmp #0
    bne __b1
    lda #<1
    sta.z return
    lda #>1
    sta.z return+1
    rts
  __b1:
    lda #<-1
    sta.z return
    sta.z return+1
    rts
}
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// abs_u16(word zp(8) w)
abs_u16: {
    .label w = 8
    .label return = 8
    lda.z w+1
    and #$80
    cmp #0
    bne __b1
    rts
  __b1:
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
    .const col = WHITE*$10+PURPLE
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
// memset(void* zp($c) str, byte register(X) c, word zp($a) num)
memset: {
    .label end = $a
    .label dst = $c
    .label num = $a
    .label str = $c
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    rts
  __b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label __7 = $18
    .label yoffs = $e
    ldx #0
    lda #$80
  __b1:
    sta bitmap_plot_bit,x
    lsr
    cmp #0
    bne __b2
    lda #$80
  __b2:
    inx
    cpx #0
    bne __b1
    lda #<BITMAP
    sta.z yoffs
    lda #>BITMAP
    sta.z yoffs+1
    ldx #0
  __b3:
    lda #7
    sax.z __7
    lda.z yoffs
    ora.z __7
    sta bitmap_plot_ylo,x
    lda.z yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp.z __7
    bne __b4
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    inx
    cpx #0
    bne __b3
    rts
}
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
