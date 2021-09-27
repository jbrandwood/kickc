// Test the binary division library
/// @file
/// A lightweight library for printing on the C64.
///
/// Printing with this library is done by calling print_ function for each element
  // Commodore 64 PRG executable file
.file [name="test-division.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label print_screen = $400
  .label print_line_cursor = $f
  .label print_char_cursor = 7
  // Remainder after unsigned 16-bit division
  .label rem16u = 2
  // Remainder after signed 16 bit division
  .label rem16s = 2
.segment Code
main: {
    // print_cls()
    jsr print_cls
    // test_8u()
    jsr test_8u
    // test_16u()
    jsr test_16u
    // test_8s()
    jsr test_8s
    // test_16s()
    jsr test_16s
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
test_8u: {
    .label dividend = $11
    .label divisor = $12
    .label res = 9
    .label i = $13
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #0
    sta.z i
  __b1:
    // byte dividend = dividends[i]
    ldy.z i
    lda dividends,y
    sta.z dividend
    // byte divisor = divisors[i]
    lda divisors,y
    sta.z divisor
    // byte res = div8u(dividend, divisor)
    ldx.z dividend
    jsr div8u
    // byte res = div8u(dividend, divisor)
    sta.z res
    // print_uchar(dividend)
    jsr print_uchar
    // print_str(" / ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(divisor)
    lda.z divisor
    sta.z print_uchar.b
    jsr print_uchar
    // print_str(" = ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(res)
    lda.z res
    sta.z print_uchar.b
    jsr print_uchar
    // print_str(" ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(rem8u)
    stx.z print_uchar.b
    jsr print_uchar
    // print_ln()
    jsr print_ln
    // for( byte i: 0..5 )
    inc.z i
    lda #6
    cmp.z i
    bne __b11
    // }
    rts
  __b11:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
  .segment Data
    dividends: .byte $ff, $ff, $ff, $ff, $ff, $ff
    divisors: .byte 5, 7, $b, $d, $11, $13
}
.segment Code
test_16u: {
    .label dividend = $d
    .label divisor = $a
    .label res = 5
    .label i = $13
    lda #0
    sta.z i
  __b1:
    // word dividend = dividends[i]
    lda.z i
    asl
    tax
    lda dividends,x
    sta.z dividend
    lda dividends+1,x
    sta.z dividend+1
    // word divisor = divisors[i]
    lda divisors,x
    sta.z divisor
    lda divisors+1,x
    sta.z divisor+1
    // word res = div16u(dividend, divisor)
    lda.z dividend
    sta.z div16u.dividend
    lda.z dividend+1
    sta.z div16u.dividend+1
    jsr div16u
    // print_uint(dividend)
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_uint(dividend)
    jsr print_uint
    // print_str(" / ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uint(divisor)
    lda.z divisor
    sta.z print_uint.w
    lda.z divisor+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" = ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint(res)
    lda.z res
    sta.z print_uint.w
    lda.z res+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_uint(rem16u)
    lda.z rem16u
    sta.z print_uint.w
    lda.z rem16u+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_ln()
    jsr print_ln
    // for( byte i : 0..5)
    inc.z i
    lda #6
    cmp.z i
    bne __b1
    // }
    rts
  .segment Data
    dividends: .word $ffff, $ffff, $ffff, $ffff, $ffff, $ffff
    divisors: .word 5, 7, $b, $d, $11, $13
}
.segment Code
test_8s: {
    .label dividend = $11
    .label divisor = $16
    .label res = 4
    .label i = $13
    lda #0
    sta.z i
  __b1:
    // signed byte dividend = dividends[i]
    ldy.z i
    lda dividends,y
    sta.z dividend
    // signed byte divisor = divisors[i]
    lda divisors,y
    sta.z divisor
    // signed byte res = div8s(dividend, divisor)
    ldx.z dividend
    tay
    jsr div8s
    sta.z res
    // print_schar(dividend)
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_schar(dividend)
    jsr print_schar
    // print_str(" / ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_schar(divisor)
    lda.z divisor
    sta.z print_schar.b
    jsr print_schar
    // print_str(" = ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_schar(res)
    lda.z res
    sta.z print_schar.b
    jsr print_schar
    // print_str(" ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_schar(rem8s)
    stx.z print_schar.b
    jsr print_schar
    // print_ln()
    jsr print_ln
    // for( byte i: 0..5 )
    inc.z i
    lda #6
    cmp.z i
    bne __b1
    // }
    rts
  .segment Data
    dividends: .byte $7f, -$7f, -$7f, $7f, $7f, $7f
    divisors: .byte 5, 7, -$b, -$d, $11, $13
}
.segment Code
test_16s: {
    .label dividend = $d
    .label divisor = $14
    .label res = 5
    .label i = $13
    lda #0
    sta.z i
  __b1:
    // signed word dividend = dividends[i]
    lda.z i
    asl
    tax
    lda dividends,x
    sta.z dividend
    lda dividends+1,x
    sta.z dividend+1
    // signed word divisor = divisors[i]
    lda divisors,x
    sta.z divisor
    lda divisors+1,x
    sta.z divisor+1
    // signed word res = div16s(dividend, divisor)
    jsr div16s
    // print_sint(dividend)
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_sint(dividend)
    jsr print_sint
    // print_str(" / ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_sint(divisor)
    lda.z divisor
    sta.z print_sint.w
    lda.z divisor+1
    sta.z print_sint.w+1
    jsr print_sint
    // print_str(" = ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_sint(res)
    lda.z res
    sta.z print_sint.w
    lda.z res+1
    sta.z print_sint.w+1
    jsr print_sint
    // print_str(" ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_sint(rem16s)
    lda.z rem16s
    sta.z print_sint.w
    lda.z rem16s+1
    sta.z print_sint.w+1
    jsr print_sint
    // print_ln()
    jsr print_ln
    // for( byte i: 0..5)
    inc.z i
    lda #6
    cmp.z i
    bne __b1
    // }
    rts
  .segment Data
    dividends: .word $7fff, $7fff, -$7fff, -$7fff, $7fff, -$7fff
    divisors: .word 5, -7, $b, -$d, -$11, $13
}
.segment Code
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $d
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
// Performs division on two 8 bit unsigned chars
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8u
// Implemented using simple binary division
// __register(A) char div8u(__register(X) char dividend, __register(A) char divisor)
div8u: {
    // divr8u(dividend, divisor, 0)
    stx.z divr8u.dividend
    sta.z divr8u.divisor
    jsr divr8u
    // divr8u(dividend, divisor, 0)
    lda.z divr8u.return
    // }
    rts
}
// Print a char as HEX
// void print_uchar(__zp($11) char b)
print_uchar: {
    .label b = $11
    // b>>4
    lda.z b
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
    and.z b
    // print_char(print_hextab[b&$f])
    tay
    lda print_hextab,y
    jsr print_char
    // }
    rts
}
// Print a zero-terminated string
// void print_str(__zp($d) char *str)
print_str: {
    .label str = $d
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
// Performs division on two 16 bit unsigned ints
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp(5) unsigned int div16u(__zp(7) unsigned int dividend, __zp($a) unsigned int divisor)
div16u: {
    .label return = 5
    .label dividend = 7
    .label divisor = $a
    // divr16u(dividend, divisor, 0)
    jsr divr16u
    // divr16u(dividend, divisor, 0)
    // }
    rts
}
// Print a unsigned int as HEX
// void print_uint(__zp($d) unsigned int w)
print_uint: {
    .label w = $d
    // print_uchar(BYTE1(w))
    lda.z w+1
    sta.z print_uchar.b
    jsr print_uchar
    // print_uchar(BYTE0(w))
    lda.z w
    sta.z print_uchar.b
    jsr print_uchar
    // }
    rts
}
// Perform division on two signed 8-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// __register(A) signed char div8s(__register(X) signed char dividend, __register(Y) signed char divisor)
div8s: {
    .label neg = $12
    // if(dividend<0)
    cpx #0
    bmi __b1
    lda #0
    sta.z neg
  __b2:
    // if(divisor<0)
    cpy #0
    bmi __b3
    tya
  __b4:
    // char resultu = div8u(dividendu, divisoru)
    jsr div8u
    // char resultu = div8u(dividendu, divisoru)
    tay
    // if(neg==0)
    lda.z neg
    beq __b5
    // rem8s = -(signed char)rem8u
    txa
    eor #$ff
    clc
    adc #1
    tax
    // return -(signed char)resultu;
    tya
    eor #$ff
    clc
    adc #1
    // }
    rts
  __b5:
    tya
    rts
  __b3:
    // -divisor
    tya
    eor #$ff
    clc
    adc #1
    tay
    // neg = neg ^ 1
    lda #1
    eor.z neg
    sta.z neg
    tya
    jmp __b4
  __b1:
    // -dividend
    txa
    eor #$ff
    clc
    adc #1
    tax
    lda #1
    sta.z neg
    jmp __b2
}
// Print a signed char as HEX
// void print_schar(__zp($11) signed char b)
print_schar: {
    .label b = $11
    // if(b<0)
    lda.z b
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
    lda.z b
    eor #$ff
    clc
    adc #1
    sta.z b
    jmp __b2
}
// Perform division on two signed 16-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// __zp(5) int div16s(__zp($d) int dividend, __zp($14) int divisor)
div16s: {
    .label return = 5
    .label dividend = $d
    .label divisor = $14
    // divr16s(dividend, divisor, 0)
    lda.z dividend
    sta.z divr16s.dividend
    lda.z dividend+1
    sta.z divr16s.dividend+1
    lda.z divisor
    sta.z divr16s.divisor
    lda.z divisor+1
    sta.z divr16s.divisor+1
    jsr divr16s
    // }
    rts
}
// Print a signed int as HEX
// void print_sint(__zp($d) int w)
print_sint: {
    .label w = $d
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
// Performs division on two 8 bit unsigned chars and an initial remainder
// Returns dividend/divisor.
// The final remainder will be set into the global variable rem8u
// Implemented using simple binary division
// __zp(4) char divr8u(__zp(9) char dividend, __zp($c) char divisor, __register(Y) char rem)
divr8u: {
    .label dividend = 9
    .label divisor = $c
    .label quotient = 4
    .label return = 4
    ldx #0
    txa
    sta.z quotient
    tay
  __b1:
    // rem = rem << 1
    tya
    asl
    tay
    // dividend & $80
    lda #$80
    and.z dividend
    // if( (dividend & $80) != 0 )
    cmp #0
    beq __b2
    // rem = rem | 1
    tya
    ora #1
    tay
  __b2:
    // dividend = dividend << 1
    asl.z dividend
    // quotient = quotient << 1
    asl.z quotient
    // if(rem>=divisor)
    cpy.z divisor
    bcc __b3
    // quotient++;
    inc.z quotient
    // rem = rem - divisor
    tya
    sec
    sbc.z divisor
    tay
  __b3:
    // for( char i : 0..7)
    inx
    cpx #8
    bne __b1
    // rem8u = rem
    tya
    tax
    // }
    rts
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
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp(5) unsigned int divr16u(__zp(7) unsigned int dividend, __zp($a) unsigned int divisor, __zp(2) unsigned int rem)
divr16u: {
    .label rem = 2
    .label dividend = 7
    .label quotient = 5
    .label return = 5
    .label divisor = $a
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
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
    cmp.z divisor+1
    bcc __b3
    bne !+
    lda.z rem
    cmp.z divisor
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
    sbc.z divisor
    sta.z rem
    lda.z rem+1
    sbc.z divisor+1
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
// Perform division on two signed 16-bit numbers with an initial remainder.
// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// __zp(5) int divr16s(__zp(7) int dividend, __zp($a) int divisor, int rem)
divr16s: {
    .label dividendu = 7
    .label divisoru = $a
    .label resultu = 5
    .label return = 5
    .label dividend = 7
    .label divisor = $a
    // if(dividend<0 || rem<0)
    lda.z dividend+1
    bmi __b1
    ldy #0
  __b2:
    // if(divisor<0)
    lda.z divisor+1
    bmi __b3
  __b4:
    // unsigned int resultu = divr16u(dividendu, divisoru, remu)
    jsr divr16u
    // unsigned int resultu = divr16u(dividendu, divisoru, remu)
    // if(neg==0)
    cpy #0
    beq __breturn
    // rem16s = -(signed int)rem16u
    lda #0
    sec
    sbc.z rem16s
    sta.z rem16s
    lda #0
    sbc.z rem16s+1
    sta.z rem16s+1
    // return -(signed int)resultu;
    lda #0
    sec
    sbc.z return
    sta.z return
    lda #0
    sbc.z return+1
    sta.z return+1
  __breturn:
    // }
    rts
  __b3:
    // -divisor
    lda #0
    sec
    sbc.z divisoru
    sta.z divisoru
    lda #0
    sbc.z divisoru+1
    sta.z divisoru+1
    // neg = neg ^ 1
    tya
    eor #1
    tay
    jmp __b4
  __b1:
    // -dividend
    lda #0
    sec
    sbc.z dividendu
    sta.z dividendu
    lda #0
    sbc.z dividendu+1
    sta.z dividendu+1
    ldy #1
    jmp __b2
}
.segment Data
  print_hextab: .text "0123456789abcdef"
  str: .text " / "
  .byte 0
  str1: .text " = "
  .byte 0
  str2: .text " "
  .byte 0
