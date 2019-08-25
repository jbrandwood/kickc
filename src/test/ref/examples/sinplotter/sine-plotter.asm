// Generate a big sinus and plot it on a bitmap
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = 5
  .label BGCOL = $d021
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D016 = $d016
  .const VIC_CSEL = 8
  .label D018 = $d018
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  .const WHITE = 1
  // PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  // PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  // PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  .label SCREEN = $400
  .label BITMAP = $2000
  .const SIN_SIZE = $200
  .label rem16u = $1c
main: {
    .const vicSelectGfxBank1_toDd001_return = 3
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    sei
    // Disable normal interrupt
    // Disable kernal & basic
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
    jsr bitmap_init
    jsr bitmap_clear
    jsr sin16s_gen2
    jsr render_sine
  b1:
    inc BGCOL
    jmp b1
}
render_sine: {
    .label _1 = $16
    .label _4 = $16
    .label _10 = $16
    .label _11 = $16
    .label sin_val = $16
    .label sin2_val = $16
    .label xpos = 6
    .label sin_idx = $14
    lda #<0
    sta.z xpos
    sta.z xpos+1
    sta.z sin_idx
    sta.z sin_idx+1
  b1:
    lda.z sin_idx+1
    cmp #>SIN_SIZE
    bcc b2
    bne !+
    lda.z sin_idx
    cmp #<SIN_SIZE
    bcc b2
  !:
    rts
  b2:
    lda.z sin_idx
    asl
    sta.z _10
    lda.z sin_idx+1
    rol
    sta.z _10+1
    clc
    lda.z _1
    adc #<sin
    sta.z _1
    lda.z _1+1
    adc #>sin
    sta.z _1+1
    ldy #0
    lda (sin_val),y
    tax
    iny
    lda (sin_val),y
    stx.z sin_val
    sta.z sin_val+1
    jsr wrap_y
    tax
    jsr bitmap_plot
    lda.z sin_idx
    asl
    sta.z _11
    lda.z sin_idx+1
    rol
    sta.z _11+1
    clc
    lda.z _4
    adc #<sin2
    sta.z _4
    lda.z _4+1
    adc #>sin2
    sta.z _4+1
    ldy #0
    lda (sin2_val),y
    tax
    iny
    lda (sin2_val),y
    stx.z sin2_val
    sta.z sin2_val+1
    lda.z wrap_y.y
    clc
    adc #<$a
    sta.z wrap_y.y
    lda.z wrap_y.y+1
    adc #>$a
    sta.z wrap_y.y+1
    jsr wrap_y
    tax
    jsr bitmap_plot
    inc.z xpos
    bne !+
    inc.z xpos+1
  !:
    lda.z xpos+1
    cmp #>$140
    bne b3
    lda.z xpos
    cmp #<$140
    bne b3
    lda #<0
    sta.z xpos
    sta.z xpos+1
  b3:
    inc.z sin_idx
    bne !+
    inc.z sin_idx+1
  !:
    jmp b1
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage(6) x, byte register(X) y)
bitmap_plot: {
    .label _1 = $1c
    .label plotter = $16
    .label x = 6
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
// wrap_y(signed word zeropage($16) y)
wrap_y: {
    .label y = $16
  b1:
    lda.z y
    cmp #<$c8
    lda.z y+1
    sbc #>$c8
    bvc !+
    eor #$80
  !:
    bpl b2
  b3:
    lda.z y+1
    bmi b4
    lda.z y
    rts
  b4:
    clc
    lda.z y
    adc #<$c8
    sta.z y
    lda.z y+1
    adc #>$c8
    sta.z y+1
    jmp b3
  b2:
    lda.z y
    sec
    sbc #<$c8
    sta.z y
    lda.z y+1
    sbc #>$c8
    sta.z y+1
    jmp b1
}
// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen2(signed word* zeropage(6) sintab)
sin16s_gen2: {
    .const min = -$140
    .const max = $140
    .label ampl = max-min
    .label _6 = $c
    .label _9 = $1c
    .label step = $18
    .label sintab = 6
    .label x = 2
    .label i = $14
    jsr div32u16u
    lda #<sin
    sta.z sintab
    lda #>sin
    sta.z sintab+1
    lda #0
    sta.z x
    sta.z x+1
    sta.z x+2
    sta.z x+3
    sta.z i
    sta.z i+1
  // u[4.28]
  b1:
    lda.z i+1
    cmp #>SIN_SIZE
    bcc b2
    bne !+
    lda.z i
    cmp #<SIN_SIZE
    bcc b2
  !:
    rts
  b2:
    lda.z x
    sta.z sin16s.x
    lda.z x+1
    sta.z sin16s.x+1
    lda.z x+2
    sta.z sin16s.x+2
    lda.z x+3
    sta.z sin16s.x+3
    jsr sin16s
    jsr mul16s
    lda.z _6+2
    sta.z _9
    lda.z _6+3
    sta.z _9+1
    ldy #0
    lda.z _9
    sta (sintab),y
    iny
    lda.z _9+1
    sta (sintab),y
    lda #SIZEOF_SIGNED_WORD
    clc
    adc.z sintab
    sta.z sintab
    bcc !+
    inc.z sintab+1
  !:
    lda.z x
    clc
    adc.z step
    sta.z x
    lda.z x+1
    adc.z step+1
    sta.z x+1
    lda.z x+2
    adc.z step+2
    sta.z x+2
    lda.z x+3
    adc.z step+3
    sta.z x+3
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp b1
}
// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
// mul16s(signed word zeropage($10) a)
mul16s: {
    .label _9 = $1e
    .label _16 = $1e
    .label m = $c
    .label return = $c
    .label a = $10
    lda.z a
    sta.z mul16u.a
    lda.z a+1
    sta.z mul16u.a+1
    lda #<sin16s_gen2.ampl
    sta.z mul16u.mb
    lda #>sin16s_gen2.ampl
    sta.z mul16u.mb+1
    lda #<sin16s_gen2.ampl>>$10
    sta.z mul16u.mb+2
    lda #>sin16s_gen2.ampl>>$10
    sta.z mul16u.mb+3
    jsr mul16u
    lda.z a+1
    bpl b2
    lda.z m+2
    sta.z _9
    lda.z m+3
    sta.z _9+1
    lda.z _16
    sec
    sbc #<sin16s_gen2.ampl
    sta.z _16
    lda.z _16+1
    sbc #>sin16s_gen2.ampl
    sta.z _16+1
    lda.z _16
    sta.z m+2
    lda.z _16+1
    sta.z m+3
  b2:
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zeropage($1c) a, word zeropage($16) b)
mul16u: {
    .label mb = 8
    .label a = $1c
    .label res = $c
    .label return = $c
    .label b = $16
    lda #0
    sta.z res
    sta.z res+1
    sta.z res+2
    sta.z res+3
  b1:
    lda.z a
    bne b2
    lda.z a+1
    bne b2
    rts
  b2:
    lda #1
    and.z a
    cmp #0
    beq b3
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
  b3:
    lsr.z a+1
    ror.z a
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp b1
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zeropage($c) x)
sin16s: {
    .label _4 = $c
    .label x = $c
    .label return = $10
    .label x1 = $1e
    .label x2 = $12
    .label x3 = $12
    .label x3_6 = $20
    .label usinx = $10
    .label x4 = $12
    .label x5 = $20
    .label x5_128 = $20
    .label sinx = $10
    .label isUpper = $22
    lda.z x+3
    cmp #>PI_u4f28>>$10
    bcc b4
    bne !+
    lda.z x+2
    cmp #<PI_u4f28>>$10
    bcc b4
    bne !+
    lda.z x+1
    cmp #>PI_u4f28
    bcc b4
    bne !+
    lda.z x
    cmp #<PI_u4f28
    bcc b4
  !:
    lda.z x
    sec
    sbc #<PI_u4f28
    sta.z x
    lda.z x+1
    sbc #>PI_u4f28
    sta.z x+1
    lda.z x+2
    sbc #<PI_u4f28>>$10
    sta.z x+2
    lda.z x+3
    sbc #>PI_u4f28>>$10
    sta.z x+3
    lda #1
    sta.z isUpper
    jmp b1
  b4:
    lda #0
    sta.z isUpper
  b1:
    lda.z x+3
    cmp #>PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda.z x+2
    cmp #<PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda.z x+1
    cmp #>PI_HALF_u4f28
    bcc b2
    bne !+
    lda.z x
    cmp #<PI_HALF_u4f28
    bcc b2
  !:
    lda #<PI_u4f28
    sec
    sbc.z x
    sta.z x
    lda #>PI_u4f28
    sbc.z x+1
    sta.z x+1
    lda #<PI_u4f28>>$10
    sbc.z x+2
    sta.z x+2
    lda #>PI_u4f28>>$10
    sbc.z x+3
    sta.z x+3
  b2:
    ldy #3
  !:
    asl.z _4
    rol.z _4+1
    rol.z _4+2
    rol.z _4+3
    dey
    bne !-
    lda.z _4+2
    sta.z x1
    lda.z _4+3
    sta.z x1+1
    lda.z x1
    sta.z mulu16_sel.v1
    lda.z x1+1
    sta.z mulu16_sel.v1+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda.z mulu16_sel.return
    sta.z x2
    lda.z mulu16_sel.return+1
    sta.z x2+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    ldx #1
    lda #<$10000/6
    sta.z mulu16_sel.v2
    lda #>$10000/6
    sta.z mulu16_sel.v2+1
    jsr mulu16_sel
    lda.z x1
    sec
    sbc.z x3_6
    sta.z usinx
    lda.z x1+1
    sbc.z x3_6+1
    sta.z usinx+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_10
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_10+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lda.z usinx
    clc
    adc.z x5_128
    sta.z usinx
    lda.z usinx+1
    adc.z x5_128+1
    sta.z usinx+1
    lda.z isUpper
    cmp #0
    beq b3
    sec
    lda #0
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  b3:
    rts
}
// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zeropage($12) v1, word zeropage($16) v2, byte register(X) select)
mulu16_sel: {
    .label _0 = $c
    .label _1 = $c
    .label v1 = $12
    .label v2 = $16
    .label return = $20
    .label return_1 = $12
    .label return_10 = $12
    lda.z v1
    sta.z mul16u.a
    lda.z v1+1
    sta.z mul16u.a+1
    lda.z mul16u.b
    sta.z mul16u.mb
    lda.z mul16u.b+1
    sta.z mul16u.mb+1
    lda #0
    sta.z mul16u.mb+2
    sta.z mul16u.mb+3
    jsr mul16u
    cpx #0
    beq !e+
  !:
    asl.z _1
    rol.z _1+1
    rol.z _1+2
    rol.z _1+3
    dex
    bne !-
  !e:
    lda.z _1+2
    sta.z return
    lda.z _1+3
    sta.z return+1
    rts
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $20
    .label quotient_lo = $12
    .label return = $18
    lda #<PI2_u4f28>>$10
    sta.z divr16u.dividend
    lda #>PI2_u4f28>>$10
    sta.z divr16u.dividend+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    lda.z divr16u.return
    sta.z quotient_hi
    lda.z divr16u.return+1
    sta.z quotient_hi+1
    lda #<PI2_u4f28&$ffff
    sta.z divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta.z divr16u.dividend+1
    jsr divr16u
    lda.z quotient_hi
    sta.z return+2
    lda.z quotient_hi+1
    sta.z return+3
    lda.z quotient_lo
    sta.z return
    lda.z quotient_lo+1
    sta.z return+1
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($10) dividend, word zeropage($1c) rem)
divr16u: {
    .label rem = $1c
    .label dividend = $10
    .label quotient = $12
    .label return = $12
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
  b1:
    asl.z rem
    rol.z rem+1
    lda.z dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora.z rem
    sta.z rem
  b2:
    asl.z dividend
    rol.z dividend+1
    asl.z quotient
    rol.z quotient+1
    lda.z rem+1
    cmp #>SIN_SIZE
    bcc b3
    bne !+
    lda.z rem
    cmp #<SIN_SIZE
    bcc b3
  !:
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    lda.z rem
    sec
    sbc #<SIN_SIZE
    sta.z rem
    lda.z rem+1
    sbc #>SIN_SIZE
    sta.z rem+1
  b3:
    inx
    cpx #$10
    bne b1
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
// memset(void* zeropage($16) str, byte register(X) c, word zeropage($14) num)
memset: {
    .label end = $14
    .label dst = $16
    .label num = $14
    .label str = $16
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
    .label _7 = $22
    .label yoffs = $14
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
  sin: .fill 2*$200, 0
sin2:
.for(var i=0; i<512; i++) {
  	  .word sin(toRadians([i*360]/512))*320
    }

