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
  .label rem16u = $c
  .label xsin_idx = $23
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>LOGO)/4&$f
    sei
    lda #WHITE
    sta BORDERCOL
    lda #DARK_GREY
    sta BGCOL2
    sta BGCOL
    lda #BLACK
    sta BGCOL3
    lda #toD0181_return
    sta D018
    lda #VIC_MCM
    sta D016
    ldx #BLACK
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    jsr memset
    ldx #WHITE|8
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    jsr memset
    ldx #0
  __b1:
    txa
    sta SCREEN,x
    inx
    cpx #$f0
    bne __b1
    jsr sin16s_gen2
    jsr loop
    rts
}
loop: {
    .label __2 = $12
    .label __7 = $12
    .label xpos = $12
    lda #<0
    sta.z xsin_idx
    sta.z xsin_idx+1
  __b1:
  // Wait for the raster to reach the bottom of the screen
  __b2:
    lda #$ff
    cmp RASTER
    bne __b2
    inc BORDERCOL
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
    ldy #0
    lda (xpos),y
    pha
    iny
    lda (xpos),y
    sta.z xpos+1
    pla
    sta.z xpos
    jsr render_logo
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
    dec BORDERCOL
    jmp __b1
}
// render_logo(signed word zeropage($12) xpos)
render_logo: {
    .label __3 = $19
    .label xpos = $12
    .label x_char = $14
    .label logo_idx = 2
    .label logo_idx_1 = 3
    lda.z xpos
    and #7
    ora #VIC_MCM
    sta D016
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
    lda.z __3
    sta.z x_char
    lda.z xpos+1
    bmi __b1
    ldy #0
  __b2:
    cpy.z x_char
    bne __b3
    lda #0
    sta.z logo_idx
  __b5:
    cpy #$28
    bne __b6
    rts
  __b6:
    lda.z logo_idx
    sta SCREEN,y
    lda #$28*1
    clc
    adc.z logo_idx
    sta SCREEN+$28*1,y
    lda #$28*2
    clc
    adc.z logo_idx
    sta SCREEN+$28*2,y
    lda #$28*3
    clc
    adc.z logo_idx
    sta SCREEN+$28*3,y
    lda #$28*4
    clc
    adc.z logo_idx
    sta SCREEN+$28*4,y
    lda #$28*5
    clc
    adc.z logo_idx
    sta SCREEN+$28*5,y
    iny
    inc.z logo_idx
    jmp __b5
  __b3:
    lda #0
    sta SCREEN,y
    sta SCREEN+$28*1,y
    sta SCREEN+$28*2,y
    sta SCREEN+$28*3,y
    sta SCREEN+$28*4,y
    sta SCREEN+$28*5,y
    iny
    jmp __b2
  __b1:
    lda.z x_char
    eor #$ff
    clc
    adc #1
    sta.z logo_idx_1
    ldy #0
  __b8:
    lda #$28
    cmp.z logo_idx_1
    bne __b9
  __b11:
    cpy #$28
    bne __b12
    rts
  __b12:
    lda #0
    sta SCREEN,y
    sta SCREEN+$28*1,y
    sta SCREEN+$28*2,y
    sta SCREEN+$28*3,y
    sta SCREEN+$28*4,y
    sta SCREEN+$28*5,y
    iny
    jmp __b11
  __b9:
    lda.z logo_idx_1
    sta SCREEN,y
    lda #$28*1
    clc
    adc.z logo_idx_1
    sta SCREEN+$28*1,y
    lda #$28*2
    clc
    adc.z logo_idx_1
    sta SCREEN+$28*2,y
    lda #$28*3
    clc
    adc.z logo_idx_1
    sta SCREEN+$28*3,y
    lda #$28*4
    clc
    adc.z logo_idx_1
    sta SCREEN+$28*4,y
    lda #$28*5
    clc
    adc.z logo_idx_1
    sta SCREEN+$28*5,y
    iny
    inc.z logo_idx_1
    jmp __b8
}
// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen2(signed word* zeropage($c) sintab)
sin16s_gen2: {
    .const min = -$140
    .const max = $140
    .label ampl = max-min
    .label __6 = 8
    .label __9 = $19
    .label step = $15
    .label sintab = $c
    // u[4.28]
    // Iterate over the table
    .label x = 4
    .label i = $23
    jsr div32u16u
    lda #<xsin
    sta.z sintab
    lda #>xsin
    sta.z sintab+1
    lda #0
    sta.z x
    sta.z x+1
    sta.z x+2
    sta.z x+3
    sta.z i
    sta.z i+1
  // u[4.28]
  __b1:
    lda.z i+1
    cmp #>XSIN_SIZE
    bcc __b2
    bne !+
    lda.z i
    cmp #<XSIN_SIZE
    bcc __b2
  !:
    rts
  __b2:
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
    lda.z __6+2
    sta.z __9
    lda.z __6+3
    sta.z __9+1
    ldy #0
    lda.z __9
    sta (sintab),y
    iny
    lda.z __9+1
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
    jmp __b1
}
// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
// mul16s(signed word zeropage($10) a)
mul16s: {
    .label __9 = $1f
    .label __16 = $1f
    .label m = 8
    .label return = 8
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
    bpl __b2
    lda.z m+2
    sta.z __9
    lda.z m+3
    sta.z __9+1
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
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zeropage($e) a, word zeropage($19) b)
mul16u: {
    .label mb = $1b
    .label a = $e
    .label res = 8
    .label return = 8
    .label b = $19
    lda #0
    sta.z res
    sta.z res+1
    sta.z res+2
    sta.z res+3
  __b1:
    lda.z a
    bne __b2
    lda.z a+1
    bne __b2
    rts
  __b2:
    lda #1
    and.z a
    cmp #0
    beq __b3
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
    lsr.z a+1
    ror.z a
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp __b1
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zeropage(8) x)
sin16s: {
    .label __4 = $1b
    .label x = 8
    .label return = $10
    .label x1 = $1f
    .label x2 = $12
    .label x3 = $12
    .label x3_6 = $21
    .label usinx = $10
    .label x4 = $12
    .label x5 = $21
    .label x5_128 = $21
    .label sinx = $10
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
    lda.z __4+2
    sta.z x1
    lda.z __4+3
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
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
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
    cpy #0
    beq __b3
    sec
    lda #0
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  __b3:
    rts
}
// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zeropage($12) v1, word zeropage($19) v2, byte register(X) select)
mulu16_sel: {
    .label __0 = 8
    .label __1 = 8
    .label v1 = $12
    .label v2 = $19
    .label return = $21
    .label return_1 = $12
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
    asl.z __1
    rol.z __1+1
    rol.z __1+2
    rol.z __1+3
    dex
    bne !-
  !e:
    lda.z __1+2
    sta.z return
    lda.z __1+3
    sta.z return+1
    rts
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $21
    .label quotient_lo = $e
    .label return = $15
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
// divr16u(word zeropage($19) dividend, word zeropage($c) rem)
divr16u: {
    .label rem = $c
    .label dividend = $19
    .label quotient = $e
    .label return = $e
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
  __b1:
    asl.z rem
    rol.z rem+1
    lda.z dividend+1
    and #$80
    cmp #0
    beq __b2
    lda #1
    ora.z rem
    sta.z rem
  __b2:
    asl.z dividend
    rol.z dividend+1
    asl.z quotient
    rol.z quotient+1
    lda.z rem+1
    cmp #>XSIN_SIZE
    bcc __b3
    bne !+
    lda.z rem
    cmp #<XSIN_SIZE
    bcc __b3
  !:
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    lda.z rem
    sec
    sbc #<XSIN_SIZE
    sta.z rem
    lda.z rem+1
    sbc #>XSIN_SIZE
    sta.z rem+1
  __b3:
    inx
    cpx #$10
    bne __b1
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($10) str, byte register(X) c)
memset: {
    .label end = $23
    .label dst = $10
    .label str = $10
    lda.z str
    clc
    adc #<$3e8
    sta.z end
    lda.z str+1
    adc #>$3e8
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
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
  .align $100
  xsin: .fill 2*XSIN_SIZE, 0
.pc = LOGO "LOGO"
  .var logoPic = LoadPicture("logo.png", List().add($444444, $808080, $000000, $ffffff))
    .for (var y=0; y<6	; y++)
        .for (var x=0;x<40; x++)
            .for(var cp=0; cp<8; cp++)
                .byte logoPic.getMulticolorByte(x,cp+y*8)

