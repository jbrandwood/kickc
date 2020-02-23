// Test the binary division library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 5
  .label print_line_cursor = $f
  // Remainder after unsigned 16-bit division
  .label rem16u = $b
  // Remainder after signed 16 bit division
  .label rem16s = $b
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
    .label dividend = 3
    .label divisor = $11
    .label res = 9
    .label i = $d
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
    // print_sword(dividend)
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_sword(dividend)
    jsr print_sword
    // print_str(" / ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_sword(divisor)
    lda.z divisor
    sta.z print_sword.w
    lda.z divisor+1
    sta.z print_sword.w+1
    jsr print_sword
    // print_str(" = ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_sword(res)
    lda.z res
    sta.z print_sword.w
    lda.z res+1
    sta.z print_sword.w+1
    jsr print_sword
    // print_str(" ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_sword(rem16s)
    lda.z rem16s
    sta.z print_sword.w
    lda.z rem16s+1
    sta.z print_sword.w+1
    jsr print_sword
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
// Print a signed word as HEX
// print_sword(signed word zp(3) w)
print_sword: {
    .label w = 3
    // if(w<0)
    lda.z w+1
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_word((word)w)
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
// print_word(word zp(3) w)
print_word: {
    .label w = 3
    // print_byte(>w)
    lda.z w+1
    sta.z print_byte.b
    jsr print_byte
    // print_byte(<w)
    lda.z w
    sta.z print_byte.b
    jsr print_byte
    // }
    rts
}
// Print a byte as HEX
// print_byte(byte zp(2) b)
print_byte: {
    .label b = 2
    // b>>4
    lda.z b
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
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
// print_str(byte* zp(3) str)
print_str: {
    .label str = 3
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
// Perform division on two signed 16-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// div16s(signed word zp(3) dividend, signed word zp($11) divisor)
div16s: {
    .label return = 9
    .label dividend = 3
    .label divisor = $11
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
// divr16s(signed word zp(5) dividend, signed word zp(7) divisor)
divr16s: {
    .label __16 = $b
    .label dividendu = 5
    .label divisoru = 7
    .label resultu = 9
    .label return = 9
    .label dividend = 5
    .label divisor = 7
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
    // (signed word)rem16u
    // rem16s = -(signed word)rem16u
    sec
    lda #0
    sbc.z rem16s
    sta.z rem16s
    lda #0
    sbc.z rem16s+1
    sta.z rem16s+1
    // return -(signed word)resultu;
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
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp(5) dividend, word zp(7) divisor, word zp($b) rem)
divr16u: {
    .label rem = $b
    .label dividend = 5
    .label quotient = 9
    .label return = 9
    .label divisor = 7
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
    // for( byte i : 0..15)
    inx
    cpx #$10
    bne __b1
    // rem16u = rem
    // }
    rts
}
test_8s: {
    .label dividend = 2
    .label divisor = $13
    .label res = $14
    .label i = $d
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
    ldy.z dividend
    tax
    jsr div8s
    // res = div8s(dividend, divisor)
    sta.z res
    // print_sbyte(dividend)
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_sbyte(dividend)
    jsr print_sbyte
    // print_str(" / ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_sbyte(divisor)
    lda.z divisor
    sta.z print_sbyte.b
    jsr print_sbyte
    // print_str(" = ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_sbyte(res)
    lda.z res
    sta.z print_sbyte.b
    jsr print_sbyte
    // print_str(" ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_sbyte(rem8s)
    stx.z print_sbyte.b
    jsr print_sbyte
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
// Print a signed byte as HEX
// print_sbyte(signed byte zp(2) b)
print_sbyte: {
    .label b = 2
    // if(b<0)
    lda.z b
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_byte((byte)b)
    jsr print_byte
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
// div8s(signed byte register(Y) dividend, signed byte register(X) divisor)
div8s: {
    .label neg = $e
    // if(dividend<0)
    cpy #0
    bmi __b1
    lda #0
    sta.z neg
  __b2:
    // if(divisor<0)
    cpx #0
    bmi __b3
  __b4:
    // div8u(dividendu, divisoru)
    tya
    jsr div8u
    // div8u(dividendu, divisoru)
    // resultu = div8u(dividendu, divisoru)
    tay
    // if(neg==0)
    lda.z neg
    cmp #0
    beq __b5
    // (signed byte)rem8u
    txa
    // rem8s = -(signed byte)rem8u
    eor #$ff
    clc
    adc #1
    tax
    // return -(signed byte)resultu;
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
    txa
    eor #$ff
    clc
    adc #1
    tax
    // neg = neg ^ 1
    lda #1
    eor.z neg
    sta.z neg
    jmp __b4
  __b1:
    // -dividend
    tya
    eor #$ff
    clc
    adc #1
    tay
    lda #1
    sta.z neg
    jmp __b2
}
// Performs division on two 8 bit unsigned bytes
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8u
// Implemented using simple binary division
// div8u(byte register(A) dividend, byte register(X) divisor)
div8u: {
    // divr8u(dividend, divisor, 0)
    sta.z divr8u.dividend
    stx.z divr8u.divisor
    jsr divr8u
    // divr8u(dividend, divisor, 0)
    lda.z divr8u.return
    // }
    rts
}
// Performs division on two 8 bit unsigned bytes and an initial remainder
// Returns dividend/divisor.
// The final remainder will be set into the global variable rem8u
// Implemented using simple binary division
// divr8u(byte zp($14) dividend, byte zp($15) divisor, byte register(Y) rem)
divr8u: {
    .label dividend = $14
    .label divisor = $15
    .label quotient = $16
    .label return = $16
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
    // for( byte i : 0..7)
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
    .label dividend = 3
    .label divisor = 7
    .label res = 9
    .label i = $e
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
    // print_word(dividend)
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_word(dividend)
    jsr print_word
    // print_str(" / ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_word(divisor)
    lda.z divisor
    sta.z print_word.w
    lda.z divisor+1
    sta.z print_word.w+1
    jsr print_word
    // print_str(" = ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_word(res)
    lda.z res
    sta.z print_word.w
    lda.z res+1
    sta.z print_word.w+1
    jsr print_word
    // print_str(" ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_word(rem16u)
    lda.z rem16u
    sta.z print_word.w
    lda.z rem16u+1
    sta.z print_word.w+1
    jsr print_word
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
// Performs division on two 16 bit unsigned words
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
// div16u(word zp(3) dividend, word zp(7) divisor)
div16u: {
    .label return = 9
    .label dividend = 3
    .label divisor = 7
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
    .label dividend = 2
    .label divisor = $15
    .label res = $16
    .label i = $13
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
    lda.z dividend
    ldx.z divisor
    jsr div8u
    // div8u(dividend, divisor)
    // res = div8u(dividend, divisor)
    sta.z res
    // print_byte(dividend)
    jsr print_byte
    // print_str(" / ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_byte(divisor)
    lda.z divisor
    sta.z print_byte.b
    jsr print_byte
    // print_str(" = ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_byte(res)
    lda.z res
    sta.z print_byte.b
    jsr print_byte
    // print_str(" ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_byte(rem8u)
    stx.z print_byte.b
    jsr print_byte
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
    .label dst = $f
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
