.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
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
  .label SCREEN = $400
  .label LOGO = $2000
  .const XSIN_SIZE = $200
  .label rem16u = $23
  .label xsin_idx = 2
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
    sta memset.str
    lda #>SCREEN
    sta memset.str+1
    jsr memset
    ldx #WHITE|8
    lda #<COLS
    sta memset.str
    lda #>COLS
    sta memset.str+1
    jsr memset
    ldx #0
  b1:
    txa
    sta SCREEN,x
    inx
    cpx #$f0
    bne b1
    jsr sin16s_gen2
    jsr loop
    rts
}
loop: {
    .label _1 = $2b
    .label _5 = $2b
    .label xpos = $2b
    lda #<0
    sta xsin_idx
    sta xsin_idx+1
  b1:
  // Wait for the raster to reach the bottom of the screen
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    inc BORDERCOL
    lda xsin_idx
    asl
    sta _5
    lda xsin_idx+1
    rol
    sta _5+1
    clc
    lda _1
    adc #<xsin
    sta _1
    lda _1+1
    adc #>xsin
    sta _1+1
    ldy #0
    lda (xpos),y
    tax
    iny
    lda (xpos),y
    stx xpos
    sta xpos+1
    jsr render_logo
    inc xsin_idx
    bne !+
    inc xsin_idx+1
  !:
    lda xsin_idx+1
    cmp #>XSIN_SIZE
    bne b4
    lda xsin_idx
    cmp #<XSIN_SIZE
    bne b4
    lda #<0
    sta xsin_idx
    sta xsin_idx+1
  b4:
    dec BORDERCOL
    jmp b1
}
// render_logo(signed word zeropage($2b) xpos)
render_logo: {
    .label _3 = $2d
    .label xpos = $2b
    .label x_char = $2f
    .label logo_idx = 4
    .label logo_idx_4 = 5
    .label logo_idx_11 = 5
    .label logo_idx_14 = 5
    lda xpos
    and #7
    ora #VIC_MCM
    sta D016
    lda xpos+1
    cmp #$80
    ror
    sta _3+1
    lda xpos
    ror
    sta _3
    lda _3+1
    cmp #$80
    ror _3+1
    ror _3
    lda _3+1
    cmp #$80
    ror _3+1
    ror _3
    lda _3
    sta x_char
    lda xpos+1
    bmi b1
    ldy #0
  b2:
    cpy x_char
    bne b3
    lda #0
    sta logo_idx
  b5:
    cpy #$28
    bne b6
    rts
  b6:
    lda logo_idx
    sta SCREEN,y
    lda #$28*1
    clc
    adc logo_idx
    sta SCREEN+$28*1,y
    lda #$28*2
    clc
    adc logo_idx
    sta SCREEN+$28*2,y
    lda #$28*3
    clc
    adc logo_idx
    sta SCREEN+$28*3,y
    lda #$28*4
    clc
    adc logo_idx
    sta SCREEN+$28*4,y
    lda #$28*5
    clc
    adc logo_idx
    sta SCREEN+$28*5,y
    iny
    inc logo_idx
    jmp b5
  b3:
    lda #0
    sta SCREEN,y
    sta SCREEN+$28*1,y
    sta SCREEN+$28*2,y
    sta SCREEN+$28*3,y
    sta SCREEN+$28*4,y
    sta SCREEN+$28*5,y
    iny
    jmp b2
  b1:
    lda x_char
    eor #$ff
    clc
    adc #1
    sta logo_idx_14
    ldy #0
  b8:
    lda #$28
    cmp logo_idx_11
    bne b9
  b11:
    cpy #$28
    bne b12
    rts
  b12:
    lda #0
    sta SCREEN,y
    sta SCREEN+$28*1,y
    sta SCREEN+$28*2,y
    sta SCREEN+$28*3,y
    sta SCREEN+$28*4,y
    sta SCREEN+$28*5,y
    iny
    jmp b11
  b9:
    lda logo_idx_11
    sta SCREEN,y
    lda #$28*1
    clc
    adc logo_idx_11
    sta SCREEN+$28*1,y
    lda #$28*2
    clc
    adc logo_idx_11
    sta SCREEN+$28*2,y
    lda #$28*3
    clc
    adc logo_idx_11
    sta SCREEN+$28*3,y
    lda #$28*4
    clc
    adc logo_idx_11
    sta SCREEN+$28*4,y
    lda #$28*5
    clc
    adc logo_idx_11
    sta SCREEN+$28*5,y
    iny
    inc logo_idx_4
    jmp b8
}
// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen2(signed word* zeropage($a) sintab)
sin16s_gen2: {
    .const min = -$140
    .const max = $140
    .label ampl = max-min
    .label _5 = $e
    .label _8 = $34
    .label step = $30
    .label sintab = $a
    .label x = 6
    .label i = $c
    jsr div32u16u
    lda #<0
    sta i
    sta i+1
    lda #<xsin
    sta sintab
    lda #>xsin
    sta sintab+1
    lda #0
    sta x
    sta x+1
    sta x+2
    sta x+3
  // u[4.28]
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
    sta _8
    lda _5+3
    sta _8+1
    ldy #0
    lda _8
    sta (sintab),y
    iny
    lda _8+1
    sta (sintab),y
    lda #SIZEOF_SIGNED_WORD
    clc
    adc sintab
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
    cmp #>XSIN_SIZE
    bcc b1
    bne !+
    lda i
    cmp #<XSIN_SIZE
    bcc b1
  !:
    rts
}
// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
// mul16s(signed word zeropage($1f) a)
mul16s: {
    .label _9 = $36
    .label _16 = $36
    .label m = $e
    .label return = $e
    .label a = $1f
    lda a
    sta mul16u.a
    lda a+1
    sta mul16u.a+1
    lda #<sin16s_gen2.ampl
    sta mul16u.mb
    lda #>sin16s_gen2.ampl
    sta mul16u.mb+1
    lda #<sin16s_gen2.ampl>>$10
    sta mul16u.mb+2
    lda #>sin16s_gen2.ampl>>$10
    sta mul16u.mb+3
    jsr mul16u
    lda a+1
    bpl b2
    lda m+2
    sta _9
    lda m+3
    sta _9+1
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
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zeropage($14) a, word zeropage($12) b)
mul16u: {
    .label mb = $16
    .label a = $14
    .label res = $e
    .label return = $e
    .label b = $12
    lda #0
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
    beq b3
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
  b3:
    lsr a+1
    ror a
    asl mb
    rol mb+1
    rol mb+2
    rol mb+3
    jmp b1
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zeropage($1b) x)
sin16s: {
    .label _4 = $1b
    .label x = $1b
    .label return = $1f
    .label x1 = $38
    .label x2 = $21
    .label x3 = $21
    .label x3_6 = $3a
    .label usinx = $1f
    .label x4 = $21
    .label x5 = $3a
    .label x5_128 = $3a
    .label sinx = $1f
    .label isUpper = $1a
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
    asl _4
    rol _4+1
    rol _4+2
    rol _4+3
    dey
    bne !-
    lda _4+2
    sta x1
    lda _4+3
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
    lsr x5_128+1
    ror x5_128
    lsr x5_128+1
    ror x5_128
    lsr x5_128+1
    ror x5_128
    lsr x5_128+1
    ror x5_128
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
    lda #0
    sbc sinx
    sta sinx
    lda #0
    sbc sinx+1
    sta sinx+1
  b3:
    rts
}
// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zeropage($21) v1, word zeropage($12) v2, byte register(X) select)
mulu16_sel: {
    .label _0 = $e
    .label _1 = $e
    .label v1 = $21
    .label v2 = $12
    .label return = $3a
    .label return_1 = $21
    .label return_10 = $21
    lda v1
    sta mul16u.a
    lda v1+1
    sta mul16u.a+1
    lda mul16u.b
    sta mul16u.mb
    lda mul16u.b+1
    sta mul16u.mb+1
    lda #0
    sta mul16u.mb+2
    sta mul16u.mb+3
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
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $3c
    .label quotient_lo = $27
    .label return = $30
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
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($25) dividend, word zeropage($23) rem)
divr16u: {
    .label rem = $23
    .label dividend = $25
    .label quotient = $27
    .label return = $27
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
    cmp #>XSIN_SIZE
    bcc b3
    bne !+
    lda rem
    cmp #<XSIN_SIZE
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc #<XSIN_SIZE
    sta rem
    lda rem+1
    sbc #>XSIN_SIZE
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($29) str, byte register(X) c)
memset: {
    .label end = $3e
    .label dst = $29
    .label str = $29
    lda str
    clc
    adc #<$3e8
    sta end
    lda str+1
    adc #>$3e8
    sta end+1
  b1:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp end+1
    bne b1
    lda dst
    cmp end
    bne b1
    rts
}
  .align $100
  xsin: .fill 2*XSIN_SIZE, 0
.pc = LOGO "LOGO"
  .var logoPic = LoadPicture("logo.png", List().add($444444, $808080, $000000, $ffffff))
    .for (var y=0; y<6	; y++)
        .for (var x=0;x<40; x++)
            .for(var cp=0; cp<8; cp++)
                .byte logoPic.getMulticolorByte(x,cp+y*8)

