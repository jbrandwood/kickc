// Generates a 16-bit signed sine
/// @file
/// Sine Generator functions using only multiplication, addition and bit shifting
///
/// Uses a single division for converting the wavelength to a reciprocal.
/// Generates sine using the series sin(x) = x - x^/3! + x^-5! - x^7/7! ...
/// Uses the approximation sin(x) = x - x^/6 + x^/128
/// Optimization possibility: Use symmetries when generating sine tables. wavelength%2==0 -> mirror symmetry over PI, wavelength%4==0 -> mirror symmetry over PI/2.
  // Commodore 64 PRG executable file
.file [name="sinusgen16b.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  // PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  // PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  // PI in u[4.12] format
  .const PI_u4f12 = $3244
  // PI/2 in u[4.12] format
  .const PI_HALF_u4f12 = $1922
  .const SIZEOF_INT = 2
  .label print_screen = $400
  .label print_char_cursor = $e
  // Remainder after unsigned 16-bit division
  .label rem16u = $c
.segment Code
main: {
    .label wavelength = $78
    .label sw = $18
    .label st1 = $29
    .label st2 = $27
    .label i = $26
    // sin16s_gen(sintab1, wavelength)
    jsr sin16s_gen
    // sin16s_genb(sintab2, wavelength)
    jsr sin16s_genb
    // print_cls()
    jsr print_cls
    lda #0
    sta.z i
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<sintab2
    sta.z st2
    lda #>sintab2
    sta.z st2+1
    lda #<sintab1
    sta.z st1
    lda #>sintab1
    sta.z st1+1
  __b1:
    // signed word sw = *st1 - *st2
    ldy #0
    lda (st1),y
    sec
    sbc (st2),y
    sta.z sw
    iny
    lda (st1),y
    sbc (st2),y
    sta.z sw+1
    // if(sw>=0)
    bmi __b2
    // print_str(" ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
  __b2:
    // print_sint(sw)
    jsr print_sint
    // print_str("   ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // st1++;
    lda #SIZEOF_INT
    clc
    adc.z st1
    sta.z st1
    bcc !+
    inc.z st1+1
  !:
    // st2++;
    lda #SIZEOF_INT
    clc
    adc.z st2
    sta.z st2
    bcc !+
    inc.z st2+1
  !:
    // for( byte i: 0..119)
    inc.z i
    lda #$78
    cmp.z i
    bne __b1
    // }
    rts
  .segment Data
    sintab1: .fill 2*$78, 0
    sintab2: .fill 2*$78, 0
    str: .text "   "
    .byte 0
    str1: .text " "
    .byte 0
}
.segment Code
// Generate signed (large) unsigned int sine table - on the full -$7fff - $7fff range
// sintab - the table to generate into
// wavelength - the number of sine points in a total sine wavelength (the size of the table)
// void sin16s_gen(__zp($20) int *sintab, unsigned int wavelength)
sin16s_gen: {
    .label __2 = $10
    .label step = $22
    .label sintab = $20
    // u[4.28]
    // Iterate over the table
    .label x = $1c
    .label i = $18
    // unsigned long step = div32u16u(PI2_u4f28, wavelength)
  // u[4.28] step = PI*2/wavelength
    jsr div32u16u
    // unsigned long step = div32u16u(PI2_u4f28, wavelength)
    lda #<main.sintab1
    sta.z sintab
    lda #>main.sintab1
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
    lda #SIZEOF_INT
    clc
    adc.z sintab
    sta.z sintab
    bcc !+
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
// Generate signed (large) word sine table - on the full -$7fff - $7fff range
// sintab - the table to generate into
// wavelength - the number of sine points in a total sine wavelength (the size of the table)
// void sin16s_genb(__zp($20) int *sintab, unsigned int wavelength)
sin16s_genb: {
    .label __3 = $e
    .label step = $22
    .label sintab = $20
    // u[4.28]
    // Iterate over the table
    .label x = $1c
    .label i = $18
    // dword step = div32u16u(PI2_u4f28, wavelength)
  // u[4.28] step = PI*2/wavelength
    jsr div32u16u
    // dword step = div32u16u(PI2_u4f28, wavelength)
    lda #<main.sintab2
    sta.z sintab
    lda #>main.sintab2
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
    // sin16sb(WORD1(x))
    lda.z x+2
    sta.z sin16sb.x
    lda.z x+3
    sta.z sin16sb.x+1
    jsr sin16sb
    // *sintab++ = sin16sb(WORD1(x))
    ldy #0
    lda.z __3
    sta (sintab),y
    iny
    lda.z __3+1
    sta (sintab),y
    // *sintab++ = sin16sb(WORD1(x));
    lda #SIZEOF_INT
    clc
    adc.z sintab
    sta.z sintab
    bcc !+
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
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Print a zero-terminated string
// void print_str(__zp($10) char *str)
print_str: {
    .label str = $10
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
// Print a signed int as HEX
// void print_sint(__zp($18) int w)
print_sint: {
    .label w = $18
    // if(w<0)
    lda.z w+1
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_uint((unsigned int)w)
    jsr print_uint
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // w = -w
    lda #0
    sec
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
    jmp __b2
}
// Divide unsigned 32-bit unsigned long dividend with a 16-bit unsigned int divisor
// The 16-bit unsigned int remainder can be found in rem16u after the division
// __zp($22) unsigned long div32u16u(unsigned long dividend, unsigned int divisor)
div32u16u: {
    .label return = $22
    .label quotient_hi = $1a
    .label quotient_lo = $a
    // unsigned int quotient_hi = divr16u(WORD1(dividend), divisor, 0)
    lda #<PI2_u4f28>>$10
    sta.z divr16u.dividend
    lda #>PI2_u4f28>>$10
    sta.z divr16u.dividend+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    // unsigned int quotient_hi = divr16u(WORD1(dividend), divisor, 0)
    lda.z divr16u.return
    sta.z quotient_hi
    lda.z divr16u.return+1
    sta.z quotient_hi+1
    // unsigned int quotient_lo = divr16u(WORD0(dividend), divisor, rem16u)
    lda #<PI2_u4f28&$ffff
    sta.z divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta.z divr16u.dividend+1
    jsr divr16u
    // unsigned int quotient_lo = divr16u(WORD0(dividend), divisor, rem16u)
    // unsigned long quotient = MAKELONG( quotient_hi, quotient_lo )
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
// Calculate signed int sine sin(x)
// x: unsigned long input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed int sin(x) s[0.15] - using the full range  -$7fff - $7fff
// __zp($10) int sin16s(__zp($14) unsigned long x)
sin16s: {
    .label __4 = 2
    .label x = $14
    .label return = $10
    .label x1 = $1a
    .label x2 = $c
    .label x3 = $c
    .label x3_6 = $a
    .label usinx = $10
    .label x4 = $c
    .label x5 = $a
    .label x5_128 = $a
    .label sinx = $10
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
    // unsigned int x1 = WORD1(x<<3)
    // sinx = x - x^3/6 + x5/128;
    lda.z __4+2
    sta.z x1
    lda.z __4+3
    sta.z x1+1
    // unsigned int x2 = mulu16_sel(x1, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v1
    lda.z x1+1
    sta.z mulu16_sel.v1+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[1.15]
    ldx #0
    jsr mulu16_sel
    // unsigned int x2 = mulu16_sel(x1, x1, 0)
    lda.z mulu16_sel.return
    sta.z x2
    lda.z mulu16_sel.return+1
    sta.z x2+1
    // unsigned int x3 = mulu16_sel(x2, x1, 1)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[2.14] x^2
    ldx #1
    jsr mulu16_sel
    // unsigned int x3 = mulu16_sel(x2, x1, 1)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // unsigned int x3_6 = mulu16_sel(x3, $10000/6, 1)
  // u[2.14] x^3
    ldx #1
    lda #<$10000/6
    sta.z mulu16_sel.v2
    lda #>$10000/6
    sta.z mulu16_sel.v2+1
    jsr mulu16_sel
    // unsigned int x3_6 = mulu16_sel(x3, $10000/6, 1)
    // unsigned int usinx = x1 - x3_6
    // u[1.15] x^3/6;
    lda.z x1
    sec
    sbc.z x3_6
    sta.z usinx
    lda.z x1+1
    sbc.z x3_6+1
    sta.z usinx+1
    // unsigned int x4 = mulu16_sel(x3, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[1.15] x - x^3/6
    ldx #0
    jsr mulu16_sel
    // unsigned int x4 = mulu16_sel(x3, x1, 0)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // unsigned int x5 = mulu16_sel(x4, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[3.13] x^4
    ldx #0
    jsr mulu16_sel
    // unsigned int x5 = mulu16_sel(x4, x1, 0)
    // unsigned int x5_128 = x5>>4
    // u[4.12] x^5
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    // usinx = usinx + x5_128
    clc
    lda.z usinx
    adc.z x5_128
    sta.z usinx
    lda.z usinx+1
    adc.z x5_128+1
    sta.z usinx+1
    // if(isUpper!=0)
    cpy #0
    beq __b3
    // sinx = -(signed int)usinx
    lda #0
    sec
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  __b3:
    // }
    rts
}
// Calculate signed word sine sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// __zp($e) int sin16sb(__zp($10) unsigned int x)
sin16sb: {
    .label x = $10
    .label return = $e
    .label x1 = $10
    .label x2 = $c
    .label x3 = $c
    .label x3_6 = $a
    .label usinx = $e
    .label x4 = $c
    .label x5 = $a
    .label x5_128 = $a
    .label sinx = $e
    // if(x >= PI_u4f12 )
    lda.z x+1
    cmp #>PI_u4f12
    bcc __b4
    bne !+
    lda.z x
    cmp #<PI_u4f12
    bcc __b4
  !:
    // x = x - PI_u4f12
    lda.z x
    sec
    sbc #<PI_u4f12
    sta.z x
    lda.z x+1
    sbc #>PI_u4f12
    sta.z x+1
    ldy #1
    jmp __b1
  __b4:
    ldy #0
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
    // word x1 = x*8
    // sinx = x - x^3/6 + x5/128;
    asl.z x1
    rol.z x1+1
    asl.z x1
    rol.z x1+1
    asl.z x1
    rol.z x1+1
    // word x2 = mulu16_sel(x1, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v1
    lda.z x1+1
    sta.z mulu16_sel.v1+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[1.15]
    ldx #0
    jsr mulu16_sel
    // word x2 = mulu16_sel(x1, x1, 0)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // word x3 = mulu16_sel(x2, x1, 1)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[2.14] x^2
    ldx #1
    jsr mulu16_sel
    // word x3 = mulu16_sel(x2, x1, 1)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // word x3_6 = mulu16_sel(x3, $10000/6, 1)
  // u[2.14] x^3
    ldx #1
    lda #<$10000/6
    sta.z mulu16_sel.v2
    lda #>$10000/6
    sta.z mulu16_sel.v2+1
    jsr mulu16_sel
    // word x3_6 = mulu16_sel(x3, $10000/6, 1)
    // word usinx = x1 - x3_6
    // u[1.15] x^3/6;
    lda.z x1
    sec
    sbc.z x3_6
    sta.z usinx
    lda.z x1+1
    sbc.z x3_6+1
    sta.z usinx+1
    // word x4 = mulu16_sel(x3, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[1.15] x - x^3/6
    ldx #0
    jsr mulu16_sel
    // word x4 = mulu16_sel(x3, x1, 0)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // word x5 = mulu16_sel(x4, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[3.13] x^4
    ldx #0
    jsr mulu16_sel
    // word x5 = mulu16_sel(x4, x1, 0)
    // word x5_128 = x5/$10
    // u[4.12] x^5
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    // usinx = usinx + x5_128
    clc
    lda.z usinx
    adc.z x5_128
    sta.z usinx
    lda.z usinx+1
    adc.z x5_128+1
    sta.z usinx+1
    // if(isUpper!=0)
    cpy #0
    beq __b3
    // sinx = -(signed word)usinx
    lda #0
    sec
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  __b3:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $10
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
// Print a unsigned int as HEX
// void print_uint(__zp($18) unsigned int w)
print_uint: {
    .label w = $18
    // print_uchar(BYTE1(w))
    ldx.z w+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($a) unsigned int divr16u(__zp($12) unsigned int dividend, unsigned int divisor, __zp($c) unsigned int rem)
divr16u: {
    .label rem = $c
    .label dividend = $12
    .label quotient = $a
    .label return = $a
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
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
// Calculate val*val for two unsigned int values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// __zp($a) unsigned int mulu16_sel(__zp($c) unsigned int v1, __zp($12) unsigned int v2, __register(X) char select)
mulu16_sel: {
    .label __0 = 2
    .label __1 = 2
    .label v1 = $c
    .label v2 = $12
    .label return = $a
    .label return_1 = $c
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
    // WORD1(mul16u(v1, v2)<<select)
    lda.z __1+2
    sta.z return
    lda.z __1+3
    sta.z return+1
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
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// __zp(2) unsigned long mul16u(__zp($a) unsigned int a, __zp($12) unsigned int b)
mul16u: {
    .label a = $a
    .label b = $12
    .label return = 2
    .label mb = 6
    .label res = 2
    // unsigned long mb = b
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
    ora.z a+1
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
    clc
    lda.z res
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
.segment Data
  print_hextab: .text "0123456789abcdef"
