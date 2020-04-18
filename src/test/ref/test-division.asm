// Test the binary division library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = 2
  .label print_char_cursor = 4
  // Remainder after unsigned 16-bit division
  .label rem16u = $d
  // Remainder after signed 16 bit division
  .label rem16s = $d
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
test_16s: {
    .label dividend = $11
    .label divisor = $13
    .label res = $b
    .label i = $f
    lda #0
    sta.z i
  __b1:
    // dividend = dividends[i]
    lda.z i
    asl
    tax
    lda dividends,x
    sta.z dividend
    lda dividends+1,x
    sta.z dividend+1
    // divisor = divisors[i]
    lda divisors,x
    sta.z divisor
    lda divisors+1,x
    sta.z divisor+1
    // div16s(dividend, divisor)
    jsr div16s
    // res = div16s(dividend, divisor)
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
    dividends: .word $7fff, $7fff, -$7fff, -$7fff, $7fff, -$7fff
    divisors: .word 5, -7, $b, -$d, -$11, $13
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
// Print a signed int as HEX
// print_sint(signed word zp($11) w)
print_sint: {
    .label w = $11
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
// Print a unsigned int as HEX
// print_uint(word zp($11) w)
print_uint: {
    .label w = $11
    // print_uchar(>w)
    lda.z w+1
    sta.z print_uchar.b
    jsr print_uchar
    // print_uchar(<w)
    lda.z w
    sta.z print_uchar.b
    jsr print_uchar
    // }
    rts
}
// Print a char as HEX
// print_uchar(byte zp(6) b)
print_uchar: {
    .label b = 6
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
// print_str(byte* zp(7) str)
print_str: {
    .label str = 7
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
// Perform division on two signed 16-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// div16s(signed word zp($11) dividend, signed word zp($13) divisor)
div16s: {
    .label return = $b
    .label dividend = $11
    .label divisor = $13
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
// Perform division on two signed 16-bit numbers with an initial remainder.
// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// divr16s(signed word zp(7) dividend, signed word zp(9) divisor)
divr16s: {
    .label __16 = $d
    .label dividendu = 7
    .label divisoru = 9
    .label resultu = $b
    .label return = $b
    .label dividend = 7
    .label divisor = 9
    // if(dividend<0 || rem<0)
    lda.z dividend+1
    bmi __b1
    ldy #0
  __b2:
    // if(divisor<0)
    lda.z divisor+1
    bmi __b3
  __b4:
    // divr16u(dividendu, divisoru, remu)
    jsr divr16u
    // divr16u(dividendu, divisoru, remu)
    // resultu = divr16u(dividendu, divisoru, remu)
    // if(neg==0)
    cpy #0
    beq __breturn
    // (signed int)rem16u
    // rem16s = -(signed int)rem16u
    sec
    lda #0
    sbc.z rem16s
    sta.z rem16s
    lda #0
    sbc.z rem16s+1
    sta.z rem16s+1
    // return -(signed int)resultu;
    sec
    lda #0
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
    sec
    lda #0
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
    sec
    lda #0
    sbc.z dividendu
    sta.z dividendu
    lda #0
    sbc.z dividendu+1
    sta.z dividendu+1
    ldy #1
    jmp __b2
}
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp(7) dividend, word zp(9) divisor, word zp($d) rem)
divr16u: {
    .label rem = $d
    .label dividend = 7
    .label quotient = $b
    .label return = $b
    .label divisor = 9
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
test_8s: {
    .label dividend = 6
    .label divisor = $15
    .label res = $16
    .label i = $f
    lda #0
    sta.z i
  __b1:
    // dividend = dividends[i]
    ldy.z i
    lda dividends,y
    sta.z dividend
    // divisor = divisors[i]
    lda divisors,y
    sta.z divisor
    // div8s(dividend, divisor)
    ldx.z dividend
    tay
    jsr div8s
    // res = div8s(dividend, divisor)
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
    dividends: .byte $7f, -$7f, -$7f, $7f, $7f, $7f
    divisors: .byte 5, 7, -$b, -$d, $11, $13
}
// Print a signed char as HEX
// print_schar(signed byte zp(6) b)
print_schar: {
    .label b = 6
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
// Perform division on two signed 8-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// div8s(signed byte register(X) dividend, signed byte register(Y) divisor)
div8s: {
    .label neg = $10
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
    // div8u(dividendu, divisoru)
    jsr div8u
    // div8u(dividendu, divisoru)
    // resultu = div8u(dividendu, divisoru)
    tay
    // if(neg==0)
    lda.z neg
    cmp #0
    beq __b5
    // (signed char)rem8u
    txa
    // rem8s = -(signed char)rem8u
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
// Performs division on two 8 bit unsigned chars
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8u
// Implemented using simple binary division
// div8u(byte register(X) dividend, byte register(A) divisor)
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
// Performs division on two 8 bit unsigned chars and an initial remainder
// Returns dividend/divisor.
// The final remainder will be set into the global variable rem8u
// Implemented using simple binary division
// divr8u(byte zp($16) dividend, byte zp($17) divisor, byte register(Y) rem)
divr8u: {
    .label dividend = $16
    .label divisor = $17
    .label quotient = $18
    .label return = $18
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
test_16u: {
    .label dividend = $11
    .label divisor = 9
    .label res = $b
    .label i = $10
    lda #0
    sta.z i
  __b1:
    // dividend = dividends[i]
    lda.z i
    asl
    tax
    lda dividends,x
    sta.z dividend
    lda dividends+1,x
    sta.z dividend+1
    // divisor = divisors[i]
    lda divisors,x
    sta.z divisor
    lda divisors+1,x
    sta.z divisor+1
    // div16u(dividend, divisor)
    jsr div16u
    // res = div16u(dividend, divisor)
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
    dividends: .word $ffff, $ffff, $ffff, $ffff, $ffff, $ffff
    divisors: .word 5, 7, $b, $d, $11, $13
}
// Performs division on two 16 bit unsigned ints
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
// div16u(word zp($11) dividend, word zp(9) divisor)
div16u: {
    .label return = $b
    .label dividend = $11
    .label divisor = 9
    // divr16u(dividend, divisor, 0)
    lda.z dividend
    sta.z divr16u.dividend
    lda.z dividend+1
    sta.z divr16u.dividend+1
    jsr divr16u
    // divr16u(dividend, divisor, 0)
    // }
    rts
}
test_8u: {
    .label dividend = 6
    .label divisor = $17
    .label res = $18
    .label i = $15
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #0
    sta.z i
  __b1:
    // dividend = dividends[i]
    ldy.z i
    lda dividends,y
    sta.z dividend
    // divisor = divisors[i]
    lda divisors,y
    sta.z divisor
    // div8u(dividend, divisor)
    ldx.z dividend
    jsr div8u
    // div8u(dividend, divisor)
    // res = div8u(dividend, divisor)
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
    dividends: .byte $ff, $ff, $ff, $ff, $ff, $ff
    divisors: .byte 5, 7, $b, $d, $11, $13
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
    .label str = $400
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
  print_hextab: .text "0123456789abcdef"
  str: .text " / "
  .byte 0
  str1: .text " = "
  .byte 0
  str2: .text " "
  .byte 0
