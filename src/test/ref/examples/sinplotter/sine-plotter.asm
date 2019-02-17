//  Generate a big sinus and plot it on a bitmap
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  //  Processor port data direction register
  .label PROCPORT_DDR = 0
  //  Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  //  Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  //  RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = $35
  .label BGCOL = $d021
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D016 = $d016
  .const VIC_CSEL = 8
  .label D018 = $d018
  //  CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  //  CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  .const WHITE = 1
  //  PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  //  PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  //  PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  .label SCREEN = $400
  .label BITMAP = $2000
  .const SIN_SIZE = $200
  .label sin2 = $1400
  .label rem16u = 2
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
    lda #VIC_CSEL
    sta D016
    lda #toD0181_return
    sta D018
    jsr fill
    jsr bitmap_init
    jsr bitmap_clear
    jsr sin16s_gen2
    jsr render_sine
  b2:
    inc BGCOL
    jmp b2
}
render_sine: {
    .label _0 = 6
    .label _1 = 6
    .label _4 = 6
    .label _5 = 6
    .label sin_val = 6
    .label sin2_val = 6
    .label xpos = 4
    .label sin_idx = 2
    lda #<0
    sta xpos
    sta xpos+1
    sta sin_idx
    sta sin_idx+1
  b1:
    lda sin_idx
    asl
    sta _0
    lda sin_idx+1
    rol
    sta _0+1
    clc
    lda _1
    adc #<sin
    sta _1
    lda _1+1
    adc #>sin
    sta _1+1
    ldy #0
    lda (sin_val),y
    tax
    iny
    lda (sin_val),y
    stx sin_val
    sta sin_val+1
    jsr wrap_y
    tax
    jsr bitmap_plot
    lda sin_idx
    asl
    sta _4
    lda sin_idx+1
    rol
    sta _4+1
    clc
    lda _5
    adc #<sin2
    sta _5
    lda _5+1
    adc #>sin2
    sta _5+1
    ldy #0
    lda (sin2_val),y
    tax
    iny
    lda (sin2_val),y
    stx sin2_val
    sta sin2_val+1
    clc
    lda wrap_y.y
    adc #<$a
    sta wrap_y.y
    lda wrap_y.y+1
    adc #>$a
    sta wrap_y.y+1
    jsr wrap_y
    tax
    jsr bitmap_plot
    inc xpos
    bne !+
    inc xpos+1
  !:
    lda xpos+1
    cmp #>$140
    bne b2
    lda xpos
    cmp #<$140
    bne b2
    lda #<0
    sta xpos
    sta xpos+1
  b2:
    inc sin_idx
    bne !+
    inc sin_idx+1
  !:
    lda sin_idx+1
    cmp #>SIN_SIZE
    bcs !b1+
    jmp b1
  !b1:
    bne !+
    lda sin_idx
    cmp #<SIN_SIZE
    bcs !b1+
    jmp b1
  !b1:
  !:
    rts
}
//  Plot a single dot in the bitmap
bitmap_plot: {
    .label _1 = $10
    .label plotter = 6
    .label x = 4
    .label _3 = 6
    lda bitmap_plot_yhi,x
    sta _3+1
    lda bitmap_plot_ylo,x
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
wrap_y: {
    .label y = 6
  b1:
    lda y
    cmp #$c8
    lda y+1
    sbc #0
    bvc !+
    eor #$80
  !:
    bpl b2
  b4:
    lda y+1
    bmi b5
    lda y
    rts
  b5:
    clc
    lda y
    adc #<$c8
    sta y
    lda y+1
    adc #>$c8
    sta y+1
    jmp b4
  b2:
    lda y
    sec
    sbc #<$c8
    sta y
    lda y+1
    sbc #>$c8
    sta y+1
    jmp b1
}
//  Generate signed word sinus table - with values in the range min-max.
//  sintab - the table to generate into
//  wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
sin16s_gen2: {
    .const min = -$140
    .const max = $140
    .label ampl = max-min
    .const offs = min+(ampl>>1)
    .label _5 = $c
    .label _6 = 6
    .label _8 = 6
    .label step = $1b
    .label sintab = 2
    .label x = 8
    .label i = 4
    jsr div32u16u
    lda #<0
    sta i
    sta i+1
    lda #<sin
    sta sintab
    lda #>sin
    sta sintab+1
    lda #0
    sta x
    sta x+1
    sta x+2
    sta x+3
  b1:
    lda x
    sta sin16s.x
    lda x+1
    sta sin16s.x+1
    lda x+2
    sta sin16s.x+2
    lda x+3
    sta sin16s.x+3
    jsr sin16s
    jsr mul16s
    lda _5+2
    sta _6
    lda _5+3
    sta _6+1
    clc
    lda _8
    adc #<offs
    sta _8
    lda _8+1
    adc #>offs
    sta _8+1
    ldy #0
    lda _8
    sta (sintab),y
    iny
    lda _8+1
    sta (sintab),y
    lda sintab
    clc
    adc #2
    sta sintab
    bcc !+
    inc sintab+1
  !:
    lda x
    clc
    adc step
    sta x
    lda x+1
    adc step+1
    sta x+1
    lda x+2
    adc step+2
    sta x+2
    lda x+3
    adc step+3
    sta x+3
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>SIN_SIZE
    bcc b1
    bne !+
    lda i
    cmp #<SIN_SIZE
    bcc b1
  !:
    rts
}
//  Multiply of two signed words to a signed double word
//  Fixes offsets introduced by using unsigned multiplication
mul16s: {
    .label _5 = 2
    .label _6 = 6
    .label _16 = 6
    .label m = $c
    .label return = $c
    .label a = $17
    lda a
    sta mul16u.a
    lda a+1
    sta mul16u.a+1
    lda #<sin16s_gen2.ampl
    sta mul16u.b
    lda #>sin16s_gen2.ampl
    sta mul16u.b+1
    jsr mul16u
    lda a+1
    bpl b2
    lda m+2
    sta _5
    lda m+3
    sta _5+1
    lda m+2
    sta _6
    lda m+3
    sta _6+1
    lda _16
    sec
    sbc #<sin16s_gen2.ampl
    sta _16
    lda _16+1
    sbc #>sin16s_gen2.ampl
    sta _16+1
    lda _16
    sta m+2
    lda _16+1
    sta m+3
  b2:
    rts
}
//  Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
mul16u: {
    .label mb = $12
    .label a = $10
    .label res = $c
    .label return = $c
    .label b = 6
    lda b
    sta mb
    lda b+1
    sta mb+1
    lda #0
    sta mb+2
    sta mb+3
    sta res
    sta res+1
    sta res+2
    sta res+3
  b1:
    lda a
    bne b2
    lda a+1
    bne b2
    rts
  b2:
    lda a
    and #1
    cmp #0
    beq b4
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
    lda res+2
    adc mb+2
    sta res+2
    lda res+3
    adc mb+3
    sta res+3
  b4:
    clc
    ror a+1
    ror a
    asl mb
    rol mb+1
    rol mb+2
    rol mb+3
    jmp b1
}
//  Calculate signed word sinus sin(x)
//  x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
//  result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
sin16s: {
    .label _6 = $c
    .label x = $c
    .label return = $17
    .label x1 = $1f
    .label x2 = $19
    .label x3 = $19
    .label x3_6 = 6
    .label usinx = $17
    .label x4 = $19
    .label x5 = 6
    .label x5_128 = 6
    .label sinx = $17
    .label isUpper = $16
    lda x+3
    cmp #>PI_u4f28>>$10
    bcc b4
    bne !+
    lda x+2
    cmp #<PI_u4f28>>$10
    bcc b4
    bne !+
    lda x+1
    cmp #>PI_u4f28
    bcc b4
    bne !+
    lda x
    cmp #<PI_u4f28
    bcc b4
  !:
    lda x
    sec
    sbc #<PI_u4f28
    sta x
    lda x+1
    sbc #>PI_u4f28
    sta x+1
    lda x+2
    sbc #<PI_u4f28>>$10
    sta x+2
    lda x+3
    sbc #>PI_u4f28>>$10
    sta x+3
    lda #1
    sta isUpper
    jmp b1
  b4:
    lda #0
    sta isUpper
  b1:
    lda x+3
    cmp #>PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda x+2
    cmp #<PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda x+1
    cmp #>PI_HALF_u4f28
    bcc b2
    bne !+
    lda x
    cmp #<PI_HALF_u4f28
    bcc b2
  !:
    lda #<PI_u4f28
    sec
    sbc x
    sta x
    lda #>PI_u4f28
    sbc x+1
    sta x+1
    lda #<PI_u4f28>>$10
    sbc x+2
    sta x+2
    lda #>PI_u4f28>>$10
    sbc x+3
    sta x+3
  b2:
    ldy #3
  !:
    asl _6
    rol _6+1
    rol _6+2
    rol _6+3
    dey
    bne !-
    lda _6+2
    sta x1
    lda _6+3
    sta x1+1
    lda x1
    sta mulu16_sel.v1
    lda x1+1
    sta mulu16_sel.v1+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda mulu16_sel.return
    sta x2
    lda mulu16_sel.return+1
    sta x2+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    lda mulu16_sel.return
    sta mulu16_sel.return_1
    lda mulu16_sel.return+1
    sta mulu16_sel.return_1+1
    ldx #1
    lda #<$10000/6
    sta mulu16_sel.v2
    lda #>$10000/6
    sta mulu16_sel.v2+1
    jsr mulu16_sel
    lda x1
    sec
    sbc x3_6
    sta usinx
    lda x1+1
    sbc x3_6+1
    sta usinx+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda mulu16_sel.return
    sta mulu16_sel.return_10
    lda mulu16_sel.return+1
    sta mulu16_sel.return_10+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    ldy #4
  !:
    lsr x5_128+1
    ror x5_128
    dey
    bne !-
    lda usinx
    clc
    adc x5_128
    sta usinx
    lda usinx+1
    adc x5_128+1
    sta usinx+1
    lda isUpper
    cmp #0
    beq b3
    sec
    lda sinx
    eor #$ff
    adc #0
    sta sinx
    lda sinx+1
    eor #$ff
    adc #0
    sta sinx+1
  b3:
    rts
}
//  Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
//  The select parameter indicates how many of the highest bits of the 32-bit result to skip
mulu16_sel: {
    .label _0 = $c
    .label _1 = $c
    .label v1 = $19
    .label v2 = 6
    .label return = 6
    .label return_1 = $19
    .label return_10 = $19
    lda v1
    sta mul16u.a
    lda v1+1
    sta mul16u.a+1
    jsr mul16u
    cpx #0
    beq !e+
  !:
    asl _1
    rol _1+1
    rol _1+2
    rol _1+3
    dex
    bne !-
  !e:
    lda _1+2
    sta return
    lda _1+3
    sta return+1
    rts
}
//  Divide unsigned 32-bit dword dividend with a 16-bit word divisor
//  The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $10
    .label quotient_lo = 6
    .label return = $1b
    lda #<PI2_u4f28>>$10
    sta divr16u.dividend
    lda #>PI2_u4f28>>$10
    sta divr16u.dividend+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    lda divr16u.return
    sta quotient_hi
    lda divr16u.return+1
    sta quotient_hi+1
    lda #<PI2_u4f28&$ffff
    sta divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta divr16u.dividend+1
    jsr divr16u
    lda quotient_hi
    sta return+2
    lda quotient_hi+1
    sta return+3
    lda quotient_lo
    sta return
    lda quotient_lo+1
    sta return+1
    rts
}
//  Performs division on two 16 bit unsigned words and an initial remainder
//  Returns the quotient dividend/divisor.
//  The final remainder will be set into the global variable rem16u
//  Implemented using simple binary division
divr16u: {
    .label rem = 2
    .label dividend = 4
    .label quotient = 6
    .label return = 6
    ldx #0
    txa
    sta quotient
    sta quotient+1
  b1:
    asl rem
    rol rem+1
    lda dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora rem
    sta rem
  b2:
    asl dividend
    rol dividend+1
    asl quotient
    rol quotient+1
    lda rem+1
    cmp #>SIN_SIZE
    bcc b3
    bne !+
    lda rem
    cmp #<SIN_SIZE
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc #<SIN_SIZE
    sta rem
    lda rem+1
    sbc #>SIN_SIZE
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
//  Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = 2
    .label y = $16
    .label _3 = 2
    lda bitmap_plot_ylo
    sta _3
    lda bitmap_plot_yhi
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
//  Initialize bitmap plotting tables
bitmap_init: {
    .label _3 = $16
    .label yoffs = 2
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
//  Fill some memory with a value
fill: {
    .const size = $3e8
    .label end = SCREEN+size
    .label addr = 2
    lda #<SCREEN
    sta addr
    lda #>SCREEN
    sta addr+1
  b1:
    lda #WHITE
    ldy #0
    sta (addr),y
    inc addr
    bne !+
    inc addr+1
  !:
    lda addr+1
    cmp #>end
    bne b1
    lda addr
    cmp #<end
    bne b1
    rts
}
  //  Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  .align $100
  sin: .fill 2*$200, 0
.pc = sin2 "sin2"
  .for(var i=0; i<512; i++) {
  	  .word sin(toRadians([i*360]/512))*320
    }

