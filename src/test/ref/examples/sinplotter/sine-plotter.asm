// Generate a big sinus and plot it on a bitmap
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
  .const SIN_SIZE = $200
  .const SIZEOF_SIGNED_WORD = 2
  .label SCREEN = $400
  .label BITMAP = $2000
  // Remainder after unsigned 16-bit division
  .label rem16u = $10
main: {
    .const vicSelectGfxBank1_toDd001_return = 3
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    // asm
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable normal interrupt
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    // *CIA2_PORT_A_DDR = %00000011
    lda #3
    sta CIA2_PORT_A_DDR
    // *CIA2_PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    // *D016 = VIC_CSEL
    lda #VIC_CSEL
    sta D016
    // *D018 = toD018(SCREEN, BITMAP)
    lda #toD0181_return
    sta D018
    // bitmap_init(BITMAP, SCREEN)
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // sin16s_gen2(sin, SIN_SIZE, -320, 320)
    jsr sin16s_gen2
    // render_sine()
    jsr render_sine
  __b1:
    // (*BGCOL)++;
    inc BGCOL
    jmp __b1
}
render_sine: {
    .label __1 = $10
    .label __4 = $10
    .label __10 = $10
    .label __11 = $10
    .label sin_val = $10
    .label sin2_val = $10
    .label xpos = 6
    .label sin_idx = $12
    lda #<0
    sta.z xpos
    sta.z xpos+1
    sta.z sin_idx
    sta.z sin_idx+1
  __b1:
    // for(word sin_idx=0; sin_idx<SIN_SIZE; sin_idx++)
    lda.z sin_idx+1
    cmp #>SIN_SIZE
    bcc __b2
    bne !+
    lda.z sin_idx
    cmp #<SIN_SIZE
    bcc __b2
  !:
    // }
    rts
  __b2:
    // sin+sin_idx
    lda.z sin_idx
    asl
    sta.z __10
    lda.z sin_idx+1
    rol
    sta.z __10+1
    clc
    lda.z __1
    adc #<sin
    sta.z __1
    lda.z __1+1
    adc #>sin
    sta.z __1+1
    // sin_val = *(sin+sin_idx)
    ldy #0
    lda (sin_val),y
    pha
    iny
    lda (sin_val),y
    sta.z sin_val+1
    pla
    sta.z sin_val
    // wrap_y(sin_val)
    jsr wrap_y
    // wrap_y(sin_val)
    // ypos = wrap_y(sin_val)
    tax
    // bitmap_plot(xpos,ypos)
    lda.z xpos
    sta.z bitmap_plot.x
    lda.z xpos+1
    sta.z bitmap_plot.x+1
    jsr bitmap_plot
    // sin2+sin_idx
    lda.z sin_idx
    asl
    sta.z __11
    lda.z sin_idx+1
    rol
    sta.z __11+1
    clc
    lda.z __4
    adc #<sin2
    sta.z __4
    lda.z __4+1
    adc #>sin2
    sta.z __4+1
    // sin2_val = *(sin2+sin_idx)
    ldy #0
    lda (sin2_val),y
    pha
    iny
    lda (sin2_val),y
    sta.z sin2_val+1
    pla
    sta.z sin2_val
    // wrap_y(sin2_val+10)
    lda.z wrap_y.y
    clc
    adc #<$a
    sta.z wrap_y.y
    lda.z wrap_y.y+1
    adc #>$a
    sta.z wrap_y.y+1
    jsr wrap_y
    // wrap_y(sin2_val+10)
    // ypos2 = wrap_y(sin2_val+10)
    tax
    // bitmap_plot(xpos,ypos2)
    lda.z xpos
    sta.z bitmap_plot.x
    lda.z xpos+1
    sta.z bitmap_plot.x+1
    jsr bitmap_plot
    // xpos++;
    inc.z xpos
    bne !+
    inc.z xpos+1
  !:
    // if(xpos==320)
    lda.z xpos+1
    cmp #>$140
    bne __b3
    lda.z xpos
    cmp #<$140
    bne __b3
    lda #<0
    sta.z xpos
    sta.z xpos+1
  __b3:
    // for(word sin_idx=0; sin_idx<SIN_SIZE; sin_idx++)
    inc.z sin_idx
    bne !+
    inc.z sin_idx+1
  !:
    jmp __b1
}
// Plot a single dot in the bitmap
// bitmap_plot(word zp($10) x, byte register(X) y)
bitmap_plot: {
    .label __1 = $1a
    .label plotter = $14
    .label x = $10
    // (byte*) { bitmap_plot_yhi[y], bitmap_plot_ylo[y] }
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __1
    lda.z x+1
    and #>$fff8
    sta.z __1+1
    // plotter += ( x & $fff8 )
    lda.z plotter
    clc
    adc.z __1
    sta.z plotter
    lda.z plotter+1
    adc.z __1+1
    sta.z plotter+1
    // <x
    ldx.z x
    // *plotter |= bitmap_plot_bit[<x]
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    // }
    rts
}
// wrap_y(signed word zp($10) y)
wrap_y: {
    .label y = $10
  __b1:
    // while(y>=200)
    lda.z y
    cmp #<$c8
    lda.z y+1
    sbc #>$c8
    bvc !+
    eor #$80
  !:
    bpl __b2
  __b3:
    // while(y<0)
    lda.z y+1
    bmi __b4
    // (byte)y
    lda.z y
    // }
    rts
  __b4:
    // y += 200
    clc
    lda.z y
    adc #<$c8
    sta.z y
    lda.z y+1
    adc #>$c8
    sta.z y+1
    jmp __b3
  __b2:
    // y -= 200
    lda.z y
    sec
    sbc #<$c8
    sta.z y
    lda.z y+1
    sbc #>$c8
    sta.z y+1
    jmp __b1
}
// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen2(signed word* zp(6) sintab)
sin16s_gen2: {
    .const min = -$140
    .const max = $140
    .label ampl = max-min
    .label __6 = 8
    .label __9 = $1a
    .label step = $16
    .label sintab = 6
    // u[4.28]
    // Iterate over the table
    .label x = 2
    .label i = $12
    // div32u16u(PI2_u4f28, wavelength)
    jsr div32u16u
    // div32u16u(PI2_u4f28, wavelength)
    // step = div32u16u(PI2_u4f28, wavelength)
    lda #<sin
    sta.z sintab
    lda #>sin
    sta.z sintab+1
    lda #<0
    sta.z x
    sta.z x+1
    lda #<0>>$10
    sta.z x+2
    lda #>0>>$10
    sta.z x+3
    lda #<0
    sta.z i
    sta.z i+1
  // u[4.28]
  __b1:
    // for( word i=0; i<wavelength; i++)
    lda.z i+1
    cmp #>SIN_SIZE
    bcc __b2
    bne !+
    lda.z i
    cmp #<SIN_SIZE
    bcc __b2
  !:
    // }
    rts
  __b2:
    // sin16s(x)
    lda.z x
    sta.z sin16s.x
    lda.z x+1
    sta.z sin16s.x+1
    lda.z x+2
    sta.z sin16s.x+2
    lda.z x+3
    sta.z sin16s.x+3
    jsr sin16s
    // mul16s(sin16s(x), ampl)
    jsr mul16s
    // >mul16s(sin16s(x), ampl)
    lda.z __6+2
    sta.z __9
    lda.z __6+3
    sta.z __9+1
    // *sintab++ = offs + (signed word)>mul16s(sin16s(x), ampl)
    ldy #0
    lda.z __9
    sta (sintab),y
    iny
    lda.z __9+1
    sta (sintab),y
    // *sintab++ = offs + (signed word)>mul16s(sin16s(x), ampl);
    lda #SIZEOF_SIGNED_WORD
    clc
    adc.z sintab
    sta.z sintab
    bcc !+
    inc.z sintab+1
  !:
    // x = x + step
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
    // for( word i=0; i<wavelength; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
// mul16s(signed word zp($1a) a)
mul16s: {
    .label __9 = $20
    .label __16 = $20
    .label m = 8
    .label return = 8
    .label a = $1a
    // mul16u((word)a, (word) b)
    lda.z a
    sta.z mul16u.a
    lda.z a+1
    sta.z mul16u.a+1
    lda #<sin16s_gen2.ampl
    sta.z mul16u.b
    lda #>sin16s_gen2.ampl
    sta.z mul16u.b+1
    jsr mul16u
    // mul16u((word)a, (word) b)
    // m = mul16u((word)a, (word) b)
    // if(a<0)
    lda.z a+1
    bpl __b2
    // >m
    lda.z m+2
    sta.z __9
    lda.z m+3
    sta.z __9+1
    // >m = (>m)-(word)b
    lda.z __16
    sec
    sbc #<sin16s_gen2.ampl
    sta.z __16
    lda.z __16+1
    sbc #>sin16s_gen2.ampl
    sta.z __16+1
    lda.z __16
    sta.z m+2
    lda.z __16+1
    sta.z m+3
  __b2:
    // (signed dword)m
    // }
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zp($14) a, word zp($10) b)
mul16u: {
    .label mb = $c
    .label a = $14
    .label res = 8
    .label return = 8
    .label b = $10
    // mb = b
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
  __b1:
    // while(a!=0)
    lda.z a
    bne __b2
    lda.z a+1
    bne __b2
    // }
    rts
  __b2:
    // a&1
    lda #1
    and.z a
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
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
  __b3:
    // a = a>>1
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp __b1
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zp($c) x)
sin16s: {
    .label __4 = $1c
    .label x = $c
    .label return = $1a
    .label x1 = $20
    .label x2 = $14
    .label x3 = $24
    .label x3_6 = $22
    .label usinx = $22
    .label x4 = $14
    .label x5 = $14
    .label x5_128 = $1a
    .label usinx_1 = $1a
    .label sinx = $1a
    // if(x >= PI_u4f28 )
    lda.z x+3
    cmp #>PI_u4f28>>$10
    bcc b1
    bne !+
    lda.z x+2
    cmp #<PI_u4f28>>$10
    bcc b1
    bne !+
    lda.z x+1
    cmp #>PI_u4f28
    bcc b1
    bne !+
    lda.z x
    cmp #<PI_u4f28
    bcc b1
  !:
    // x = x - PI_u4f28
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
    ldy #1
    jmp __b1
  b1:
    ldy #0
  __b1:
    // if(x >= PI_HALF_u4f28 )
    lda.z x+3
    cmp #>PI_HALF_u4f28>>$10
    bcc __b2
    bne !+
    lda.z x+2
    cmp #<PI_HALF_u4f28>>$10
    bcc __b2
    bne !+
    lda.z x+1
    cmp #>PI_HALF_u4f28
    bcc __b2
    bne !+
    lda.z x
    cmp #<PI_HALF_u4f28
    bcc __b2
  !:
    // x = PI_u4f28 - x
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
  __b2:
    // x<<3
    lda.z x
    asl
    sta.z __4
    lda.z x+1
    rol
    sta.z __4+1
    lda.z x+2
    rol
    sta.z __4+2
    lda.z x+3
    rol
    sta.z __4+3
    asl.z __4
    rol.z __4+1
    rol.z __4+2
    rol.z __4+3
    asl.z __4
    rol.z __4+1
    rol.z __4+2
    rol.z __4+3
    // x1 = >x<<3
    lda.z __4+2
    sta.z x1
    lda.z __4+3
    sta.z x1+1
    // mulu16_sel(x1, x1, 0)
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
    // mulu16_sel(x1, x1, 0)
    // x2 = mulu16_sel(x1, x1, 0)
    // mulu16_sel(x2, x1, 1)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    // mulu16_sel(x2, x1, 1)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // x3 = mulu16_sel(x2, x1, 1)
    // mulu16_sel(x3, $10000/6, 1)
    lda.z x3
    sta.z mulu16_sel.v1
    lda.z x3+1
    sta.z mulu16_sel.v1+1
    ldx #1
    lda #<$10000/6
    sta.z mulu16_sel.v2
    lda #>$10000/6
    sta.z mulu16_sel.v2+1
    jsr mulu16_sel
    // mulu16_sel(x3, $10000/6, 1)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_2
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_2+1
    // x3_6 = mulu16_sel(x3, $10000/6, 1)
    // usinx = x1 - x3_6
    lda.z x1
    sec
    sbc.z usinx
    sta.z usinx
    lda.z x1+1
    sbc.z usinx+1
    sta.z usinx+1
    // mulu16_sel(x3, x1, 0)
    lda.z x3
    sta.z mulu16_sel.v1
    lda.z x3+1
    sta.z mulu16_sel.v1+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    // mulu16_sel(x3, x1, 0)
    // x4 = mulu16_sel(x3, x1, 0)
    // mulu16_sel(x4, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    // mulu16_sel(x4, x1, 0)
    // x5 = mulu16_sel(x4, x1, 0)
    // x5_128 = x5>>4
    lda.z x5+1
    lsr
    sta.z x5_128+1
    lda.z x5
    ror
    sta.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    // usinx = usinx + x5_128
    lda.z usinx_1
    clc
    adc.z usinx
    sta.z usinx_1
    lda.z usinx_1+1
    adc.z usinx+1
    sta.z usinx_1+1
    // if(isUpper!=0)
    cpy #0
    beq __b3
    // sinx = -(signed word)usinx
    sec
    lda #0
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  __b3:
    // }
    rts
}
// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zp($14) v1, word zp($10) v2, byte register(X) select)
mulu16_sel: {
    .label __0 = 8
    .label __1 = 8
    .label v1 = $14
    .label v2 = $10
    .label return = $14
    .label return_1 = $24
    .label return_2 = $22
    // mul16u(v1, v2)
    jsr mul16u
    // mul16u(v1, v2)
    // mul16u(v1, v2)<<select
    cpx #0
    beq !e+
  !:
    asl.z __1
    rol.z __1+1
    rol.z __1+2
    rol.z __1+3
    dex
    bne !-
  !e:
    // >mul16u(v1, v2)<<select
    lda.z __1+2
    sta.z return
    lda.z __1+3
    sta.z return+1
    // }
    rts
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $24
    .label quotient_lo = $1a
    .label return = $16
    // divr16u(>dividend, divisor, 0)
    lda #<PI2_u4f28>>$10
    sta.z divr16u.dividend
    lda #>PI2_u4f28>>$10
    sta.z divr16u.dividend+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    // divr16u(>dividend, divisor, 0)
    // quotient_hi = divr16u(>dividend, divisor, 0)
    lda.z divr16u.return
    sta.z quotient_hi
    lda.z divr16u.return+1
    sta.z quotient_hi+1
    // divr16u(<dividend, divisor, rem16u)
    lda #<PI2_u4f28&$ffff
    sta.z divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta.z divr16u.dividend+1
    jsr divr16u
    // divr16u(<dividend, divisor, rem16u)
    // quotient_lo = divr16u(<dividend, divisor, rem16u)
    // quotient = { quotient_hi, quotient_lo}
    lda.z quotient_hi
    sta.z return+2
    lda.z quotient_hi+1
    sta.z return+3
    lda.z quotient_lo
    sta.z return
    lda.z quotient_lo+1
    sta.z return+1
    // }
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp($14) dividend, word zp($10) rem)
divr16u: {
    .label rem = $10
    .label dividend = $14
    .label quotient = $1a
    .label return = $1a
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
  __b1:
    // rem = rem << 1
    asl.z rem
    rol.z rem+1
    // >dividend
    lda.z dividend+1
    // >dividend & $80
    and #$80
    // if( (>dividend & $80) != 0 )
    cmp #0
    beq __b2
    // rem = rem | 1
    lda #1
    ora.z rem
    sta.z rem
  __b2:
    // dividend = dividend << 1
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    lda.z rem+1
    cmp #>SIN_SIZE
    bcc __b3
    bne !+
    lda.z rem
    cmp #<SIN_SIZE
    bcc __b3
  !:
    // quotient++;
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    lda.z rem
    sec
    sbc #<SIN_SIZE
    sta.z rem
    lda.z rem+1
    sbc #>SIN_SIZE
    sta.z rem+1
  __b3:
    // for( byte i : 0..15)
    inx
    cpx #$10
    bne __b1
    // rem16u = rem
    // }
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE*$10
    // memset(bitmap_screen, col, 1000uw)
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
    // memset(bitmap_gfx, 0, 8000uw)
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
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($14) str, byte register(X) c, word zp($12) num)
memset: {
    .label end = $12
    .label dst = $14
    .label num = $12
    .label str = $14
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // end = (char*)str + num
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label __7 = $26
    .label yoffs = $12
    ldx #0
    lda #$80
  __b1:
    // bitmap_plot_bit[x] = bits
    sta bitmap_plot_bit,x
    // bits >>= 1
    lsr
    // if(bits==0)
    cmp #0
    bne __b2
    lda #$80
  __b2:
    // for(byte x : 0..255)
    inx
    cpx #0
    bne __b1
    lda #<BITMAP
    sta.z yoffs
    lda #>BITMAP
    sta.z yoffs+1
    ldx #0
  __b3:
    // y&$7
    lda #7
    sax.z __7
    // <yoffs
    lda.z yoffs
    // y&$7 | <yoffs
    ora.z __7
    // bitmap_plot_ylo[y] = y&$7 | <yoffs
    sta bitmap_plot_ylo,x
    // >yoffs
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = >yoffs
    sta bitmap_plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __7
    bne __b4
    // yoffs = yoffs + 40*8
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    // for(byte y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
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

