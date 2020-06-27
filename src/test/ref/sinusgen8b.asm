// Sinus Generator functions using only multiplication, addition and bit shifting
// Uses a single division for converting the wavelength to a reciprocal.
// Generates sinus using the series sin(x) = x - x^/3! + x^-5! - x^7/7! ...
// Uses the approximation sin(x) = x - x^/6 + x^/128
// Optimization possibility: Use symmetries when generating sinustables. wavelength%2==0 -> mirror symmetry over PI, wavelength%4==0 -> mirror symmetry over PI/2.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  // PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  // PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  // PI*2 in u[4.12] format
  .const PI2_u4f12 = $6488
  // PI in u[4.12] format
  .const PI_u4f12 = $3244
  // PI/2 in u[4.12] format
  .const PI_HALF_u4f12 = $1922
  .const SIZEOF_SIGNED_WORD = 2
  .label print_screen = $400
  // Remainder after unsigned 16-bit division
  .label rem16u = $11
  .label print_char_cursor = 3
main: {
    .label wavelength = $c0
    .label __3 = $1b
    .label __9 = $1b
    .label __10 = $1b
    .label sb = $1a
    .label sw = $1b
    .label i = 2
    // sin8s_gen(sintabb, wavelength)
    jsr sin8s_gen
    // sin16s_gen(sintabw, wavelength)
    jsr sin16s_gen
    // print_cls()
    jsr print_cls
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #0
    sta.z i
  __b1:
    // sb = sintabb[i]
    ldy.z i
    lda sintabb,y
    sta.z sb
    // sintabw+(word)i
    tya
    sta.z __10
    lda #0
    sta.z __10+1
    asl.z __9
    rol.z __9+1
    clc
    lda.z __3
    adc #<sintabw
    sta.z __3
    lda.z __3+1
    adc #>sintabw
    sta.z __3+1
    // sw = *(sintabw+(word)i)
    ldy #0
    lda (sw),y
    pha
    iny
    lda (sw),y
    sta.z sw+1
    pla
    sta.z sw
    // >sw
    lda.z sw+1
    // sd = sb-(signed byte)>sw
    eor #$ff
    sec
    adc.z sb
    // print_schar(sd)
    tax
    jsr print_schar
    // print_str("  ")
    jsr print_str
    // for(byte i: 0..191)
    inc.z i
    lda #$c0
    cmp.z i
    bne __b1
    // }
    rts
    sintabb: .fill $c0, 0
    sintabw: .fill 2*$c0, 0
    str: .text "  "
    .byte 0
}
// Print a zero-terminated string
// print_str(byte* zp($11) str)
print_str: {
    .label str = $11
    lda #<main.str
    sta.z str
    lda #>main.str
    sta.z str+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // print_char(*(str++))
    ldy #0
    lda (str),y
    jsr print_char
    // print_char(*(str++));
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
// Print a signed char as HEX
// print_schar(signed byte register(X) b)
print_schar: {
    // if(b<0)
    cpx #0
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_uchar((char)b)
    jsr print_uchar
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // b = -b
    txa
    eor #$ff
    clc
    adc #1
    tax
    jmp __b2
}
// Print a char as HEX
// print_uchar(byte register(X) b)
print_uchar: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
  // Table of hexadecimal digits
    jsr print_char
    // b&$f
    lda #$f
    axs #0
    // print_char(print_hextab[b&$f])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $11
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Generate signed (large) unsigned int sinus table - on the full -$7fff - $7fff range
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen(signed word* zp($15) sintab)
sin16s_gen: {
    .label __2 = $17
    .label step = $1d
    .label sintab = $15
    // u[4.28]
    // Iterate over the table
    .label x = 5
    .label i = 3
    // div32u16u(PI2_u4f28, wavelength)
    jsr div32u16u
    // div32u16u(PI2_u4f28, wavelength)
    // step = div32u16u(PI2_u4f28, wavelength)
    lda #<main.sintabw
    sta.z sintab
    lda #>main.sintabw
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
    // for( unsigned int i=0; i<wavelength; i++)
    lda.z i+1
    cmp #>main.wavelength
    bcc __b2
    bne !+
    lda.z i
    cmp #<main.wavelength
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
    // *sintab++ = sin16s(x)
    ldy #0
    lda.z __2
    sta (sintab),y
    iny
    lda.z __2+1
    sta (sintab),y
    // *sintab++ = sin16s(x);
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
    // for( unsigned int i=0; i<wavelength; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Calculate signed int sinus sin(x)
// x: unsigned long input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed int sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zp(9) x)
sin16s: {
    .label __4 = $21
    .label x = 9
    .label return = $17
    .label x1 = $25
    .label x2 = $11
    .label x3 = $11
    .label x3_6 = $27
    .label usinx = $17
    .label x4 = $11
    .label x5 = $27
    .label x5_128 = $27
    .label sinx = $17
    // if(x >= PI_u4f28 )
    lda.z x+3
    cmp #>PI_u4f28>>$10
    bcc __b4
    bne !+
    lda.z x+2
    cmp #<PI_u4f28>>$10
    bcc __b4
    bne !+
    lda.z x+1
    cmp #>PI_u4f28
    bcc __b4
    bne !+
    lda.z x
    cmp #<PI_u4f28
    bcc __b4
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
  __b4:
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
    lda.z mulu16_sel.return
    sta.z x2
    lda.z mulu16_sel.return+1
    sta.z x2+1
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
    ldx #1
    lda #<$10000/6
    sta.z mulu16_sel.v2
    lda #>$10000/6
    sta.z mulu16_sel.v2+1
    jsr mulu16_sel
    // mulu16_sel(x3, $10000/6, 1)
    // x3_6 = mulu16_sel(x3, $10000/6, 1)
    // usinx = x1 - x3_6
    lda.z x1
    sec
    sbc.z x3_6
    sta.z usinx
    lda.z x1+1
    sbc.z x3_6+1
    sta.z usinx+1
    // mulu16_sel(x3, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    // mulu16_sel(x3, x1, 0)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
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
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    // usinx = usinx + x5_128
    lda.z usinx
    clc
    adc.z x5_128
    sta.z usinx
    lda.z usinx+1
    adc.z x5_128+1
    sta.z usinx+1
    // if(isUpper!=0)
    cpy #0
    beq __b3
    // sinx = -(signed int)usinx
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
// Calculate val*val for two unsigned int values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zp($11) v1, word zp($1b) v2, byte register(X) select)
mulu16_sel: {
    .label __0 = $21
    .label __1 = $21
    .label v1 = $11
    .label v2 = $1b
    .label return = $27
    .label return_1 = $11
    // mul16u(v1, v2)
    lda.z v1
    sta.z mul16u.a
    lda.z v1+1
    sta.z mul16u.a+1
    jsr mul16u
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
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// mul16u(word zp($13) a, word zp($1b) b)
mul16u: {
    .label mb = $d
    .label a = $13
    .label res = $21
    .label b = $1b
    .label return = $21
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
// Divide unsigned 32-bit unsigned long dividend with a 16-bit unsigned int divisor
// The 16-bit unsigned int remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $29
    .label quotient_lo = $13
    .label return = $1d
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
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp($1b) dividend, word zp($11) rem)
divr16u: {
    .label rem = $11
    .label dividend = $1b
    .label quotient = $13
    .label return = $13
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
    cmp #>main.wavelength
    bcc __b3
    bne !+
    lda.z rem
    cmp #<main.wavelength
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
    sbc #<main.wavelength
    sta.z rem
    lda.z rem+1
    sbc #>main.wavelength
    sta.z rem+1
  __b3:
    // for( char i : 0..15)
    inx
    cpx #$10
    bne __b1
    // rem16u = rem
    // }
    rts
}
// Generate signed char sinus table - on the full -$7f - $7f range
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin8s_gen(signed byte* zp($1b) sintab)
sin8s_gen: {
    .label step = $13
    .label sintab = $1b
    // u[4.12]
    // Iterate over the table
    .label x = $17
    .label i = $15
    // div16u(PI2_u4f12, wavelength)
    jsr div16u
    // div16u(PI2_u4f12, wavelength)
    // step = div16u(PI2_u4f12, wavelength)
    lda #<main.sintabb
    sta.z sintab
    lda #>main.sintabb
    sta.z sintab+1
    lda #<0
    sta.z x
    sta.z x+1
    sta.z i
    sta.z i+1
  // u[4.12]
  __b1:
    // for( unsigned int i=0; i<wavelength; i++)
    lda.z i+1
    cmp #>main.wavelength
    bcc __b2
    bne !+
    lda.z i
    cmp #<main.wavelength
    bcc __b2
  !:
    // }
    rts
  __b2:
    // sin8s(x)
    lda.z x
    sta.z sin8s.x
    lda.z x+1
    sta.z sin8s.x+1
    jsr sin8s
    // *sintab++ = sin8s(x)
    ldy #0
    sta (sintab),y
    // *sintab++ = sin8s(x);
    inc.z sintab
    bne !+
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
    // for( unsigned int i=0; i<wavelength; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Calculate signed char sinus sin(x)
// x: unsigned int input u[4.12] in the interval $0000 - PI2_u4f12
// result: signed char sin(x) s[0.7] - using the full range  -$7f - $7f
// sin8s(word zp($25) x)
sin8s: {
    // u[2.6] x^3
    .const DIV_6 = $2b
    .label __4 = $25
    .label x = $25
    .label x1 = $2b
    .label x3 = $2c
    .label usinx = $2d
    // Move x1 into the range 0-PI/2 using sinus mirror symmetries
    .label isUpper = $1a
    // if(x >= PI_u4f12 )
    lda.z x+1
    cmp #>PI_u4f12
    bcc __b5
    bne !+
    lda.z x
    cmp #<PI_u4f12
    bcc __b5
  !:
    // x = x - PI_u4f12
    lda.z x
    sec
    sbc #<PI_u4f12
    sta.z x
    lda.z x+1
    sbc #>PI_u4f12
    sta.z x+1
    lda #1
    sta.z isUpper
    jmp __b1
  __b5:
    lda #0
    sta.z isUpper
  __b1:
    // if(x >= PI_HALF_u4f12 )
    lda.z x+1
    cmp #>PI_HALF_u4f12
    bcc __b2
    bne !+
    lda.z x
    cmp #<PI_HALF_u4f12
    bcc __b2
  !:
    // x = PI_u4f12 - x
    sec
    lda #<PI_u4f12
    sbc.z x
    sta.z x
    lda #>PI_u4f12
    sbc.z x+1
    sta.z x+1
  __b2:
    // x<<3
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    // x1 = >x<<3
    lda.z __4+1
    sta.z x1
    // mulu8_sel(x1, x1, 0)
    tax
    tay
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // mulu8_sel(x1, x1, 0)
    // x2 = mulu8_sel(x1, x1, 0)
    // mulu8_sel(x2, x1, 1)
    tax
    ldy.z x1
    lda #1
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // mulu8_sel(x2, x1, 1)
    // x3 = mulu8_sel(x2, x1, 1)
    sta.z x3
    // mulu8_sel(x3, DIV_6, 1)
    tax
    lda #1
    sta.z mulu8_sel.select
    ldy #DIV_6
    jsr mulu8_sel
    // mulu8_sel(x3, DIV_6, 1)
    // x3_6 = mulu8_sel(x3, DIV_6, 1)
    // usinx = x1 - x3_6
    eor #$ff
    sec
    adc.z x1
    sta.z usinx
    // mulu8_sel(x3, x1, 0)
    ldx.z x3
    ldy.z x1
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // mulu8_sel(x3, x1, 0)
    // x4 = mulu8_sel(x3, x1, 0)
    // mulu8_sel(x4, x1, 0)
    tax
    ldy.z x1
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // mulu8_sel(x4, x1, 0)
    // x5 = mulu8_sel(x4, x1, 0)
    // x5_128 = x5>>4
    lsr
    lsr
    lsr
    lsr
    // usinx = usinx + x5_128
    clc
    adc.z usinx
    tax
    // if(usinx>=128)
    cpx #$80
    bcc __b3
    // usinx--;
    dex
  __b3:
    // if(isUpper!=0)
    lda.z isUpper
    cmp #0
    beq __b14
    // sinx = -(signed char)usinx
    txa
    eor #$ff
    clc
    adc #1
    // }
    rts
  __b14:
    txa
    rts
}
// Calculate val*val for two unsigned char values - the result is 8 selected bits of the 16-bit result.
// The select parameter indicates how many of the highest bits of the 16-bit result to skip
// mulu8_sel(byte register(X) v1, byte register(Y) v2, byte zp($19) select)
mulu8_sel: {
    .label __0 = $27
    .label __1 = $27
    .label select = $19
    // mul8u(v1, v2)
    tya
    jsr mul8u
    // mul8u(v1, v2)<<select
    ldy.z select
    beq !e+
  !:
    asl.z __1
    rol.z __1+1
    dey
    bne !-
  !e:
    // >mul8u(v1, v2)<<select
    lda.z __1+1
    // }
    rts
}
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = $29
    .label res = $27
    .label return = $27
    // mb = b
    sta.z mb
    lda #0
    sta.z mb+1
    sta.z res
    sta.z res+1
  __b1:
    // while(a!=0)
    cpx #0
    bne __b2
    // }
    rts
  __b2:
    // a&1
    txa
    and #1
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
  __b3:
    // a = a>>1
    txa
    lsr
    tax
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    jmp __b1
}
// Performs division on two 16 bit unsigned ints
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
div16u: {
    .label return = $13
    // divr16u(dividend, divisor, 0)
    lda #<PI2_u4f12
    sta.z divr16u.dividend
    lda #>PI2_u4f12
    sta.z divr16u.dividend+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    // divr16u(dividend, divisor, 0)
    // }
    rts
}
  print_hextab: .text "0123456789abcdef"
