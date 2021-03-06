/// @file
/// Sine Generator functions using only multiplication, addition and bit shifting
///
/// Uses a single division for converting the wavelength to a reciprocal.
/// Generates sine using the series sin(x) = x - x^/3! + x^-5! - x^7/7! ...
/// Uses the approximation sin(x) = x - x^/6 + x^/128
/// Optimization possibility: Use symmetries when generating sine tables. wavelength%2==0 -> mirror symmetry over PI, wavelength%4==0 -> mirror symmetry over PI/2.
  // Commodore 64 PRG executable file
.file [name="sinusgen8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // PI*2 in u[4.12] format
  .const PI2_u4f12 = $6488
  // PI in u[4.12] format
  .const PI_u4f12 = $3244
  // PI/2 in u[4.12] format
  .const PI_HALF_u4f12 = $1922
  .const wavelength = $c0
  .label print_screen = $400
  .label print_char_cursor = 6
.segment Code
main: {
    .label i = $15
    // sin8s_gen(sintab2, wavelength)
    jsr sin8s_gen
    // print_cls()
    jsr print_cls
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #0
    sta.z i
  __b1:
    // signed byte sb = sintab2[i]-(signed byte)sintabref[i]
    ldy.z i
    lda sintab2,y
    sec
    sbc sintabref,y
    // print_schar(sb)
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
  .segment Data
    str: .text "  "
    .byte 0
}
.segment Code
// Generate signed char sine table - on the full -$7f - $7f range
// sintab - the table to generate into
// wavelength - the number of sine points in a total sine wavelength (the size of the table)
// void sin8s_gen(__zp(6) signed char *sintab, unsigned int wavelength)
sin8s_gen: {
    .label step = $a
    .label sintab = 6
    // u[4.12]
    // Iterate over the table
    .label x = $e
    .label i = $c
    // unsigned int step = div16u(PI2_u4f12, wavelength)
  // u[4.28] step = PI*2/wavelength
    jsr div16u
    // unsigned int step = div16u(PI2_u4f12, wavelength)
    lda #<sintab2
    sta.z sintab
    lda #>sintab2
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
    cmp #>@wavelength
    bcc __b2
    bne !+
    lda.z i
    cmp #<@wavelength
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
    clc
    lda.z x
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
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Print a signed char as HEX
// void print_schar(__register(X) signed char b)
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
// Print a zero-terminated string
// void print_str(__zp($c) char *str)
print_str: {
    .label str = $c
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
// Performs division on two 16 bit unsigned ints
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($a) unsigned int div16u(unsigned int dividend, unsigned int divisor)
div16u: {
    .label return = $a
    // divr16u(dividend, divisor, 0)
    jsr divr16u
    // divr16u(dividend, divisor, 0)
    // }
    rts
}
// Calculate signed char sine sin(x)
// x: unsigned int input u[4.12] in the interval $0000 - PI2_u4f12
// result: signed char sin(x) s[0.7] - using the full range  -$7f - $7f
// __register(A) signed char sin8s(__zp(8) unsigned int x)
sin8s: {
    // u[2.6] x^3
    .const DIV_6 = $2b
    .label __4 = 8
    .label x = 8
    .label x1 = $12
    .label x3 = $11
    .label usinx = $13
    // Move x1 into the range 0-PI/2 using sine mirror symmetries
    .label isUpper = $14
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
    lda #<PI_u4f12
    sec
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
    // char x1 = BYTE1(x<<3)
    // sinx = x - x^3/6 + x5/128;
    lda.z __4+1
    sta.z x1
    // char x2 = mulu8_sel(x1, x1, 0)
    tax
    tay
  // u[1.7]
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // char x2 = mulu8_sel(x1, x1, 0)
    // char x3 = mulu8_sel(x2, x1, 1)
    tax
    ldy.z x1
  // u[2.6] x^2
    lda #1
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // char x3 = mulu8_sel(x2, x1, 1)
    sta.z x3
    // char x3_6 = mulu8_sel(x3, DIV_6, 1)
    tax
  // u[0.7] - $2a.aa rounded to $2b
    lda #1
    sta.z mulu8_sel.select
    ldy #DIV_6
    jsr mulu8_sel
    // char x3_6 = mulu8_sel(x3, DIV_6, 1)
    // char usinx = x1 - x3_6
    // u[1.7] x^3/6;
    eor #$ff
    sec
    adc.z x1
    sta.z usinx
    // char x4 = mulu8_sel(x3, x1, 0)
    ldx.z x3
    ldy.z x1
  // u[1.7] x - x^3/6
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // char x4 = mulu8_sel(x3, x1, 0)
    // char x5 = mulu8_sel(x4, x1, 0)
    tax
    ldy.z x1
  // u[3.5] x^4
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // char x5 = mulu8_sel(x4, x1, 0)
    // char x5_128 = x5>>4
    // u[4.4] x^5
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $e
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
// Print a single char
// void print_char(__register(A) char ch)
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
// Print a char as HEX
// void print_uchar(__register(X) char b)
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
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($a) unsigned int divr16u(__zp(2) unsigned int dividend, unsigned int divisor, __zp(8) unsigned int rem)
divr16u: {
    .label rem = 8
    .label dividend = 2
    .label quotient = $a
    .label return = $a
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
    lda #<PI2_u4f12
    sta.z dividend
    lda #>PI2_u4f12
    sta.z dividend+1
    txa
    sta.z rem
    sta.z rem+1
  __b1:
    // rem = rem << 1
    asl.z rem
    rol.z rem+1
    // BYTE1(dividend)
    lda.z dividend+1
    // BYTE1(dividend) & $80
    and #$80
    // if( (BYTE1(dividend) & $80) != 0 )
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
    cmp #>wavelength
    bcc __b3
    bne !+
    lda.z rem
    cmp #<wavelength
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
    sbc #<wavelength
    sta.z rem
    lda.z rem+1
    sbc #>wavelength
    sta.z rem+1
  __b3:
    // for( char i : 0..15)
    inx
    cpx #$10
    bne __b1
    // }
    rts
}
// Calculate val*val for two unsigned char values - the result is 8 selected bits of the 16-bit result.
// The select parameter indicates how many of the highest bits of the 16-bit result to skip
// __register(A) char mulu8_sel(__register(X) char v1, __register(Y) char v2, __zp($10) char select)
mulu8_sel: {
    .label __0 = 2
    .label __1 = 2
    .label select = $10
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
    // BYTE1(mul8u(v1, v2)<<select)
    lda.z __1+1
    // }
    rts
}
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// __zp(2) unsigned int mul8u(__register(X) char a, __register(A) char b)
mul8u: {
    .label return = 2
    .label mb = 4
    .label res = 2
    // unsigned int mb = b
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
    clc
    lda.z res
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
.segment Data
  print_hextab: .text "0123456789abcdef"
  sintab2: .fill $c0, 0
  // .fill $c0, round(127.5*sin(i*2*PI/$c0))
  sintabref: .byte 0, 4, 8, $c, $11, $15, $19, $1d, $21, $25, $29, $2d, $31, $35, $38, $3c, $40, $43, $47, $4a, $4e, $51, $54, $57, $5a, $5d, $60, $63, $65, $68, $6a, $6c, $6e, $70, $72, $74, $76, $77, $79, $7a, $7b, $7c, $7d, $7e, $7e, $7f, $7f, $7f, $80, $7f, $7f, $7f, $7e, $7e, $7d, $7c, $7b, $7a, $79, $77, $76, $74, $72, $70, $6e, $6c, $6a, $68, $65, $63, $60, $5d, $5a, $57, $54, $51, $4e, $4a, $47, $43, $40, $3c, $38, $35, $31, $2d, $29, $25, $21, $1d, $19, $15, $11, $c, 8, 4, 0, $fc, $f8, $f4, $ef, $eb, $e7, $e3, $df, $db, $d7, $d3, $cf, $cb, $c8, $c4, $c0, $bd, $b9, $b6, $b2, $af, $ac, $a9, $a6, $a3, $a0, $9d, $9b, $98, $96, $94, $92, $90, $8e, $8c, $8a, $89, $87, $86, $85, $84, $83, $82, $82, $81, $81, $81, $81, $81, $81, $81, $82, $82, $83, $84, $85, $86, $87, $89, $8a, $8c, $8e, $90, $92, $94, $96, $98, $9b, $9d, $a0, $a3, $a6, $a9, $ac, $af, $b2, $b6, $b9, $bd, $c0, $c4, $c8, $cb, $cf, $d3, $d7, $db, $df, $e3, $e7, $eb, $ef, $f4, $f8, $fc
