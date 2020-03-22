.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label BGCOL2 = $d022
  .label BGCOL3 = $d023
  .label D016 = $d016
  .const VIC_MCM = $10
  .label D018 = $d018
  // Color Ram
  .label COLS = $d800
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const DARK_GREY = $b
  // PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  // PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  // PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  .const XSIN_SIZE = $200
  .const SIZEOF_SIGNED_WORD = 2
  .label SCREEN = $400
  .label LOGO = $2000
  // Remainder after unsigned 16-bit division
  .label rem16u = $12
  .label xsin_idx = 2
  // kickasm
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>LOGO)/4&$f
    // asm
    sei
    // *BORDERCOL = WHITE
    lda #WHITE
    sta BORDERCOL
    // *BGCOL2 = DARK_GREY
    lda #DARK_GREY
    sta BGCOL2
    // *BGCOL = *BGCOL2 = DARK_GREY
    sta BGCOL
    // *BGCOL3 = BLACK
    lda #BLACK
    sta BGCOL3
    // *D018 = toD018(SCREEN, LOGO)
    lda #toD0181_return
    sta D018
    // *D016 = VIC_MCM
    lda #VIC_MCM
    sta D016
    // memset(SCREEN, BLACK, 1000)
    ldx #BLACK
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    jsr memset
    // memset(COLS, WHITE|8, 1000)
    ldx #WHITE|8
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    jsr memset
    ldx #0
  __b1:
    // SCREEN[ch] = ch
    txa
    sta SCREEN,x
    // for(byte ch: 0..239)
    inx
    cpx #$f0
    bne __b1
    // sin16s_gen2(xsin, XSIN_SIZE, -320, 320)
    jsr sin16s_gen2
    // loop()
    jsr loop
    // }
    rts
}
loop: {
    .label __2 = $18
    .label __7 = $18
    .label xpos = $18
    lda #<0
    sta.z xsin_idx
    sta.z xsin_idx+1
  __b1:
  // Wait for the raster to reach the bottom of the screen
  __b2:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b2
    // (*BORDERCOL)++;
    inc BORDERCOL
    // xsin+xsin_idx
    lda.z xsin_idx
    asl
    sta.z __7
    lda.z xsin_idx+1
    rol
    sta.z __7+1
    clc
    lda.z __2
    adc #<xsin
    sta.z __2
    lda.z __2+1
    adc #>xsin
    sta.z __2+1
    // xpos = *(xsin+xsin_idx)
    ldy #0
    lda (xpos),y
    pha
    iny
    lda (xpos),y
    sta.z xpos+1
    pla
    sta.z xpos
    // render_logo(xpos)
    jsr render_logo
    // if(++xsin_idx==XSIN_SIZE)
    inc.z xsin_idx
    bne !+
    inc.z xsin_idx+1
  !:
    lda.z xsin_idx+1
    cmp #>XSIN_SIZE
    bne __b4
    lda.z xsin_idx
    cmp #<XSIN_SIZE
    bne __b4
    lda #<0
    sta.z xsin_idx
    sta.z xsin_idx+1
  __b4:
    // (*BORDERCOL)--;
    dec BORDERCOL
    jmp __b1
}
// render_logo(signed word zp($18) xpos)
render_logo: {
    .label __3 = $1f
    .label xpos = $18
    .label x_char = $1a
    .label logo_idx = 4
    .label logo_idx_1 = 5
    // (byte)xpos
    lda.z xpos
    // (byte)xpos&7
    and #7
    // VIC_MCM|((byte)xpos&7)
    ora #VIC_MCM
    // *D016 = VIC_MCM|((byte)xpos&7)
    sta D016
    // xpos/8
    lda.z xpos+1
    cmp #$80
    ror
    sta.z __3+1
    lda.z xpos
    ror
    sta.z __3
    lda.z __3+1
    cmp #$80
    ror.z __3+1
    ror.z __3
    lda.z __3+1
    cmp #$80
    ror.z __3+1
    ror.z __3
    // x_char = (signed byte)(xpos/8)
    lda.z __3
    sta.z x_char
    // if(xpos<0)
    lda.z xpos+1
    bmi __b1
    ldy #0
  __b2:
    // while(screen_idx!=logo_start)
    cpy.z x_char
    bne __b3
    lda #0
    sta.z logo_idx
  __b5:
    // while(screen_idx!=40)
    cpy #$28
    bne __b6
    // }
    rts
  __b6:
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    lda.z logo_idx
    sta SCREEN,y
    // logo_idx+40*line
    lda #$28*1
    clc
    adc.z logo_idx
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*1,y
    // logo_idx+40*line
    lda #$28*2
    clc
    adc.z logo_idx
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*2,y
    // logo_idx+40*line
    lda #$28*3
    clc
    adc.z logo_idx
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*3,y
    // logo_idx+40*line
    lda #$28*4
    clc
    adc.z logo_idx
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*4,y
    // logo_idx+40*line
    lda #$28*5
    clc
    adc.z logo_idx
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*5,y
    // screen_idx++;
    iny
    // logo_idx++;
    inc.z logo_idx
    jmp __b5
  __b3:
    // (SCREEN+40*line)[screen_idx] = $00
    lda #0
    sta SCREEN,y
    sta SCREEN+$28*1,y
    sta SCREEN+$28*2,y
    sta SCREEN+$28*3,y
    sta SCREEN+$28*4,y
    sta SCREEN+$28*5,y
    // screen_idx++;
    iny
    jmp __b2
  __b1:
    // -x_char
    lda.z x_char
    eor #$ff
    clc
    adc #1
    sta.z logo_idx_1
    ldy #0
  __b8:
    // while(logo_idx!=40)
    lda #$28
    cmp.z logo_idx_1
    bne __b9
  __b11:
    // while(screen_idx!=40)
    cpy #$28
    bne __b12
    rts
  __b12:
    // (SCREEN+40*line)[screen_idx] = $00
    lda #0
    sta SCREEN,y
    sta SCREEN+$28*1,y
    sta SCREEN+$28*2,y
    sta SCREEN+$28*3,y
    sta SCREEN+$28*4,y
    sta SCREEN+$28*5,y
    // screen_idx++;
    iny
    jmp __b11
  __b9:
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    lda.z logo_idx_1
    sta SCREEN,y
    // logo_idx+40*line
    lda #$28*1
    clc
    adc.z logo_idx_1
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*1,y
    // logo_idx+40*line
    lda #$28*2
    clc
    adc.z logo_idx_1
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*2,y
    // logo_idx+40*line
    lda #$28*3
    clc
    adc.z logo_idx_1
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*3,y
    // logo_idx+40*line
    lda #$28*4
    clc
    adc.z logo_idx_1
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*4,y
    // logo_idx+40*line
    lda #$28*5
    clc
    adc.z logo_idx_1
    // (SCREEN+40*line)[screen_idx] = logo_idx+40*line
    sta SCREEN+$28*5,y
    // screen_idx++;
    iny
    // logo_idx++;
    inc.z logo_idx_1
    jmp __b8
}
// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen2(signed word* zp($18) sintab)
sin16s_gen2: {
    .const min = -$140
    .const max = $140
    .label ampl = max-min
    .label __6 = $a
    .label __9 = $1f
    .label step = $1b
    .label sintab = $18
    // u[4.28]
    // Iterate over the table
    .label x = 6
    .label i = $16
    // div32u16u(PI2_u4f28, wavelength)
    jsr div32u16u
    // div32u16u(PI2_u4f28, wavelength)
    // step = div32u16u(PI2_u4f28, wavelength)
    lda #<xsin
    sta.z sintab
    lda #>xsin
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
    cmp #>XSIN_SIZE
    bcc __b2
    bne !+
    lda.z i
    cmp #<XSIN_SIZE
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
// mul16s(signed word zp($14) a)
mul16s: {
    .label __9 = $25
    .label __16 = $25
    .label m = $a
    .label return = $a
    .label a = $14
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
// mul16u(word zp($1f) a, word zp($12) b)
mul16u: {
    .label mb = $e
    .label a = $1f
    .label res = $a
    .label return = $a
    .label b = $12
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
// sin16s(dword zp($e) x)
sin16s: {
    .label __4 = $21
    .label x = $e
    .label return = $14
    .label x1 = $25
    .label x2 = $1f
    .label x3 = $27
    .label x3_6 = $29
    .label usinx = $29
    .label x4 = $1f
    .label x5 = $1f
    .label x5_128 = $14
    .label usinx_1 = $14
    .label sinx = $14
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
// mulu16_sel(word zp($1f) v1, word zp($12) v2, byte register(X) select)
mulu16_sel: {
    .label __0 = $a
    .label __1 = $a
    .label v1 = $1f
    .label v2 = $12
    .label return = $1f
    .label return_1 = $27
    .label return_2 = $29
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
    .label quotient_hi = $27
    .label quotient_lo = $14
    .label return = $1b
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
// divr16u(word zp($1f) dividend, word zp($12) rem)
divr16u: {
    .label rem = $12
    .label dividend = $1f
    .label quotient = $14
    .label return = $14
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
    cmp #>XSIN_SIZE
    bcc __b3
    bne !+
    lda.z rem
    cmp #<XSIN_SIZE
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
    sbc #<XSIN_SIZE
    sta.z rem
    lda.z rem+1
    sbc #>XSIN_SIZE
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($16) str, byte register(X) c)
memset: {
    .label end = $29
    .label dst = $16
    .label str = $16
    // end = (char*)str + num
    lda.z str
    clc
    adc #<$3e8
    sta.z end
    lda.z str+1
    adc #>$3e8
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
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
  .align $100
  xsin: .fill 2*XSIN_SIZE, 0
.pc = LOGO "LOGO"
  .var logoPic = LoadPicture("logo.png", List().add($444444, $808080, $000000, $ffffff))
    .for (var y=0; y<6	; y++)
        .for (var x=0;x<40; x++)
            .for(var cp=0; cp<8; cp++)
                .byte logoPic.getMulticolorByte(x,cp+y*8)

