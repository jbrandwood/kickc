// Generates a 16-bit signed sinus
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
  .const SIZEOF_SIGNED_WORD = 2
  .label print_line_cursor = $400
  // Remainder after unsigned 16-bit division
  .label rem16u = $14
  .label print_char_cursor = 9
main: {
    .label wavelength = $78
    .label sw = 7
    .label st1 = 2
    .label st2 = 4
    .label i = 6
    // sin16s_gen(sintab1, wavelength)
    jsr sin16s_gen
    // sin16s_genb(sintab2, wavelength)
    jsr sin16s_genb
    // print_cls()
    jsr print_cls
    lda #0
    sta.z i
    lda #<print_line_cursor
    sta.z print_char_cursor
    lda #>print_line_cursor
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
    // sw = *st1 - *st2
    ldy #0
    sec
    lda (st1),y
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
    // print_sword(sw)
    jsr print_sword
    // print_str("   ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // st1++;
    lda #SIZEOF_SIGNED_WORD
    clc
    adc.z st1
    sta.z st1
    bcc !+
    inc.z st1+1
  !:
    // st2++;
    lda #SIZEOF_SIGNED_WORD
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
    sintab1: .fill 2*$78, 0
    sintab2: .fill 2*$78, 0
    str: .text "   "
    .byte 0
    str1: .text " "
    .byte 0
}
// Print a zero-terminated string
// print_str(byte* zp($b) str)
print_str: {
    .label str = $b
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(print_char_cursor++) = *(str++)
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    // *(print_char_cursor++) = *(str++);
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a signed word as HEX
// print_sword(signed word zp(7) w)
print_sword: {
    .label w = 7
    // if(w<0)
    lda.z w+1
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_word((word)w)
    lda.z w
    sta.z print_word.w
    lda.z w+1
    sta.z print_word.w+1
    jsr print_word
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // w = -w
    sec
    lda #0
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
    jmp __b2
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
// Print a word as HEX
// print_word(word zp($28) w)
print_word: {
    .label w = $28
    // print_byte(>w)
    ldx.z w+1
    jsr print_byte
    // print_byte(<w)
    ldx.z w
    jsr print_byte
    // }
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
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
    .label str = print_line_cursor
    .label end = str+num
    .label dst = $b
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
// Generate signed (large) word sinus table - on the full -$7fff - $7fff range
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_genb(signed word* zp($b) sintab)
sin16s_genb: {
    .label __3 = $e
    .label step = $2a
    .label sintab = $b
    // u[4.28]
    // Iterate over the table
    .label x = $22
    .label i = $28
    // div32u16u(PI2_u4f28, wavelength)
    jsr div32u16u
    // div32u16u(PI2_u4f28, wavelength)
    // step = div32u16u(PI2_u4f28, wavelength)
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
    // sin16sb(>x)
    lda.z x+2
    sta.z sin16sb.x
    lda.z x+3
    sta.z sin16sb.x+1
    jsr sin16sb
    // *sintab++ = sin16sb(>x)
    ldy #0
    lda.z __3
    sta (sintab),y
    iny
    lda.z __3+1
    sta (sintab),y
    // *sintab++ = sin16sb(>x);
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
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16sb(word zp($14) x)
sin16sb: {
    .label x = $14
    .label return = $e
    .label x1 = $14
    .label x2 = $16
    .label x3 = $2e
    .label x3_6 = $e
    .label usinx = $e
    .label x4 = $16
    .label x5 = $16
    .label x5_128 = $16
    .label sinx = $e
    // Move x1 into the range 0-PI/2 using sinus mirror symmetries
    .label isUpper = $d
    // if(x >= PI_u4f12 )
    lda.z x+1
    cmp #>PI_u4f12
    bcc b1
    bne !+
    lda.z x
    cmp #<PI_u4f12
    bcc b1
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
  b1:
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
    // x1 = x*8
    asl.z x1
    rol.z x1+1
    asl.z x1
    rol.z x1+1
    asl.z x1
    rol.z x1+1
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
    sta.z mulu16_sel.return_2
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_2+1
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
    sta.z mulu16_sel.return_3
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_3+1
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
    // x5_128 = x5/$10
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
    lda.z isUpper
    cmp #0
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
// mulu16_sel(word zp($16) v1, word zp($18) v2, byte register(X) select)
mulu16_sel: {
    .label __0 = $34
    .label __1 = $34
    .label v1 = $16
    .label v2 = $18
    .label return = $16
    .label return_1 = $3a
    .label return_2 = $2e
    .label return_3 = $e
    // mul16u(v1, v2)
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
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zp($16) a, word zp($18) b)
mul16u: {
    .label mb = $10
    .label a = $16
    .label res = $34
    .label b = $18
    .label return = $34
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
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $2e
    .label quotient_lo = $18
    .label return = $2a
    .label return_1 = $30
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
// divr16u(word zp($16) dividend, word zp($14) rem)
divr16u: {
    .label rem = $14
    .label dividend = $16
    .label quotient = $18
    .label return = $18
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
    // for( byte i : 0..15)
    inx
    cpx #$10
    bne __b1
    // rem16u = rem
    // }
    rts
}
// Generate signed (large) word sinus table - on the full -$7fff - $7fff range
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen(signed word* zp($20) sintab)
sin16s_gen: {
    .label __2 = $26
    .label step = $30
    .label sintab = $20
    // u[4.28]
    // Iterate over the table
    .label x = $1c
    .label i = $1a
    // div32u16u(PI2_u4f28, wavelength)
    jsr div32u16u
    // div32u16u(PI2_u4f28, wavelength)
    lda.z div32u16u.return
    sta.z div32u16u.return_1
    lda.z div32u16u.return+1
    sta.z div32u16u.return_1+1
    lda.z div32u16u.return+2
    sta.z div32u16u.return_1+2
    lda.z div32u16u.return+3
    sta.z div32u16u.return_1+3
    // step = div32u16u(PI2_u4f28, wavelength)
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
    // for( word i=0; i<wavelength; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zp($22) x)
sin16s: {
    .label __4 = $34
    .label x = $22
    .label return = $26
    .label x1 = $38
    .label x2 = $16
    .label x3 = $3a
    .label x3_6 = $16
    .label usinx = $26
    .label x4 = $16
    .label x5 = $16
    .label x5_128 = $16
    .label sinx = $26
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
  print_hextab: .text "0123456789abcdef"
