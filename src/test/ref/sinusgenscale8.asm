// Sine Generator functions using only multiplication, addition and bit shifting
// Uses a single division for converting the wavelength to a reciprocal.
// Generates sine using the series sin(x) = x - x^/3! + x^-5! - x^7/7! ...
// Uses the approximation sin(x) = x - x^/6 + x^/128
// Optimization possibility: Use symmetries when generating sine tables. wavelength%2==0 -> mirror symmetry over PI, wavelength%4==0 -> mirror symmetry over PI/2.
  // Commodore 64 PRG executable file
.file [name="sinusgenscale8.prg", type="prg", segments="Program"]
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
  .label print_screen = $400
  .label print_char_cursor = $10
  .label print_line_cursor = $a
.segment Code
main: {
    .label tabsize = $14
    // print_cls()
    jsr print_cls
    // sin8u_table(sintab, tabsize, 10, 255)
    jsr sin8u_table
    // }
    rts
  .segment Data
    sintab: .fill $14, 0
}
.segment Code
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Generate unsigned byte sine table in a min-max range
// sintab - the table to generate into
// tabsize - the number of sine points (the size of the table)
// min - the minimal value
// max - the maximal value
// sin8u_table(byte* zp(4) sintab)
sin8u_table: {
    .const min = $a
    .const max = $ff
    .const sum = min+max
    .const mid = sum/2+1
    .label amplitude = max-min
    .label step = $e
    .label sinx = $12
    .label sinx_sc = 8
    .label sinx_tr = $13
    .label sintab = 4
    // Iterate over the table
    .label x = 2
    .label i = 6
    // div16u(PI2_u4f12, tabsize)
    jsr div16u
    // div16u(PI2_u4f12, tabsize)
    // word step = div16u(PI2_u4f12, tabsize)
    // print_str("step:")
  // u[4.12]
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uint(step)
    lda.z step
    sta.z print_uint.w
    lda.z step+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" min:")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(min)
    ldx #min
    jsr print_uchar
    // print_str(" max:")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(max)
    ldx #max
    jsr print_uchar
    // print_str(" ampl:")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(amplitude)
    ldx #amplitude
    jsr print_uchar
    // print_str(" mid:")
    lda #<str4
    sta.z print_str.str
    lda #>str4
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(mid)
    ldx #mid
    jsr print_uchar
    // print_ln()
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    jsr print_ln
    lda #<main.sintab
    sta.z sintab
    lda #>main.sintab
    sta.z sintab+1
    lda #<0
    sta.z x
    sta.z x+1
    sta.z i
    sta.z i+1
  // u[4.12]
  __b1:
    // for( word i=0; i<tabsize; i++)
    lda.z i+1
    cmp #>main.tabsize
    bcc __b2
    bne !+
    lda.z i
    cmp #<main.tabsize
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
    // signed byte sinx = sin8s(x)
    sta.z sinx
    // mul8su(sinx, amplitude+1)
    tay
    jsr mul8su
    // signed word sinx_sc = mul8su(sinx, amplitude+1)
    // >sinx_sc
    lda.z sinx_sc+1
    // byte sinx_tr = mid+>sinx_sc
    clc
    adc #mid
    sta.z sinx_tr
    // *sintab++ = sinx_tr
    ldy #0
    sta (sintab),y
    // *sintab++ = sinx_tr;
    inc.z sintab
    bne !+
    inc.z sintab+1
  !:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("x: ")
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    // print_uint(x)
    lda.z x
    sta.z print_uint.w
    lda.z x+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" sin: ")
    lda #<str6
    sta.z print_str.str
    lda #>str6
    sta.z print_str.str+1
    jsr print_str
    // print_schar(sinx)
    ldx.z sinx
    jsr print_schar
    // print_str(" scaled: ")
    lda #<str7
    sta.z print_str.str
    lda #>str7
    sta.z print_str.str+1
    jsr print_str
    // print_sint(sinx_sc)
    lda.z sinx_sc
    sta.z print_sint.w
    lda.z sinx_sc+1
    sta.z print_sint.w+1
    jsr print_sint
    // print_str(" trans: ")
    lda #<str8
    sta.z print_str.str
    lda #>str8
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(sinx_tr)
    ldx.z sinx_tr
    jsr print_uchar
    // print_ln()
    jsr print_ln
    // x = x + step
    lda.z x
    clc
    adc.z step
    sta.z x
    lda.z x+1
    adc.z step+1
    sta.z x+1
    // for( word i=0; i<tabsize; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
  .segment Data
    str: .text "step:"
    .byte 0
    str1: .text " min:"
    .byte 0
    str2: .text " max:"
    .byte 0
    str3: .text " ampl:"
    .byte 0
    str4: .text " mid:"
    .byte 0
    str5: .text "x: "
    .byte 0
    str6: .text " sin: "
    .byte 0
    str7: .text " scaled: "
    .byte 0
    str8: .text " trans: "
    .byte 0
}
.segment Code
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = 6
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
// Performs division on two 16 bit unsigned ints
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
div16u: {
    .label return = $e
    // divr16u(dividend, divisor, 0)
    jsr divr16u
    // divr16u(dividend, divisor, 0)
    // }
    rts
}
// Print a zero-terminated string
// print_str(byte* zp($c) str)
print_str: {
    .label str = $c
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
// Print a unsigned int as HEX
// print_uint(word zp($c) w)
print_uint: {
    .label w = $c
    // print_uchar(>w)
    ldx.z w+1
    jsr print_uchar
    // print_uchar(<w)
    ldx.z w
    jsr print_uchar
    // }
    rts
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
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Calculate signed char sine sin(x)
// x: unsigned int input u[4.12] in the interval $0000 - PI2_u4f12
// result: signed char sin(x) s[0.7] - using the full range  -$7f - $7f
// sin8s(word zp($c) x)
sin8s: {
    // u[2.6] x^3
    .const DIV_6 = $2b
    .label __4 = $c
    .label x = $c
    .label x1 = $14
    .label x3 = $15
    .label usinx = $16
    // Move x1 into the range 0-PI/2 using sine mirror symmetries
    .label isUpper = $12
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
    // char x1 = >x<<3
    lda.z __4+1
    sta.z x1
    // mulu8_sel(x1, x1, 0)
    tax
    tay
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // mulu8_sel(x1, x1, 0)
    // char x2 = mulu8_sel(x1, x1, 0)
    // mulu8_sel(x2, x1, 1)
    tax
    ldy.z x1
    lda #1
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // mulu8_sel(x2, x1, 1)
    // char x3 = mulu8_sel(x2, x1, 1)
    sta.z x3
    // mulu8_sel(x3, DIV_6, 1)
    tax
    lda #1
    sta.z mulu8_sel.select
    ldy #DIV_6
    jsr mulu8_sel
    // mulu8_sel(x3, DIV_6, 1)
    // char x3_6 = mulu8_sel(x3, DIV_6, 1)
    // char usinx = x1 - x3_6
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
    // char x4 = mulu8_sel(x3, x1, 0)
    // mulu8_sel(x4, x1, 0)
    tax
    ldy.z x1
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    // mulu8_sel(x4, x1, 0)
    // char x5 = mulu8_sel(x4, x1, 0)
    // char x5_128 = x5>>4
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
// Multiply a signed char and an unsigned char (into a signed int)
// Fixes offsets introduced by using unsigned multiplication
// mul8su(signed byte register(Y) a)
mul8su: {
    .const b = sin8u_table.amplitude+1
    .label m = 8
    // mul8u((char)a, (char) b)
    tya
    tax
    lda #b
    jsr mul8u
    // mul8u((char)a, (char) b)
    // unsigned int m = mul8u((char)a, (char) b)
    // if(a<0)
    cpy #0
    bpl __b1
    // >m
    lda.z m+1
    // >m = (>m)-(char)b
    sec
    sbc #b
    sta.z m+1
  __b1:
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
// Print a signed int as HEX
// print_sint(signed word zp($c) w)
print_sint: {
    .label w = $c
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
    sec
    lda #0
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
    jmp __b2
}
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp($c) dividend, word zp($a) rem)
divr16u: {
    .label rem = $a
    .label dividend = $c
    .label quotient = $e
    .label return = $e
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
    cmp #>main.tabsize
    bcc __b3
    bne !+
    lda.z rem
    cmp #<main.tabsize
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
    sbc #<main.tabsize
    sta.z rem
    lda.z rem+1
    sbc #>main.tabsize
    sta.z rem+1
  __b3:
    // for( char i : 0..15)
    inx
    cpx #$10
    bne __b1
    // }
    rts
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
// Calculate val*val for two unsigned char values - the result is 8 selected bits of the 16-bit result.
// The select parameter indicates how many of the highest bits of the 16-bit result to skip
// mulu8_sel(byte register(X) v1, byte register(Y) v2, byte zp($13) select)
mulu8_sel: {
    .label __0 = 8
    .label __1 = 8
    .label select = $13
    // mul8u(v1, v2)
    tya
    jsr mul8u
    // mul8u(v1, v2)
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
    .label return = 8
    .label mb = $10
    .label res = 8
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
.segment Data
  print_hextab: .text "0123456789abcdef"
