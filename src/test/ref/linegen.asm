// Linear table generator
// Work in progress towards a sinus generator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  // Remainder after unsigned 16-bit division
  .label rem16u = $13
  .label print_char_cursor = 5
  .label print_line_cursor = 3
main: {
    .label i = 2
    // lin16u_gen(557, 29793, lintab1, 20)
    lda #<lintab1
    sta.z lin16u_gen.lintab
    lda #>lintab1
    sta.z lin16u_gen.lintab+1
    lda #<$22d
    sta.z lin16u_gen.min
    lda #>$22d
    sta.z lin16u_gen.min+1
    lda #<$7461
    sta.z lin16u_gen.max
    lda #>$7461
    sta.z lin16u_gen.max+1
    jsr lin16u_gen
    // lin16u_gen(31179, 63361, lintab2, 20)
    lda #<lintab2
    sta.z lin16u_gen.lintab
    lda #>lintab2
    sta.z lin16u_gen.lintab+1
    lda #<$79cb
    sta.z lin16u_gen.min
    lda #>$79cb
    sta.z lin16u_gen.min+1
    lda #<$f781
    sta.z lin16u_gen.max
    lda #>$f781
    sta.z lin16u_gen.max+1
    jsr lin16u_gen
    // lin16u_gen(0, $6488, lintab3, 20)
    lda #<lintab3
    sta.z lin16u_gen.lintab
    lda #>lintab3
    sta.z lin16u_gen.lintab+1
    lda #<0
    sta.z lin16u_gen.min
    sta.z lin16u_gen.min+1
    lda #<$6488
    sta.z lin16u_gen.max
    lda #>$6488
    sta.z lin16u_gen.max+1
    jsr lin16u_gen
    // print_cls()
    jsr print_cls
    // print_str("   ")
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uint(557)
    lda #<$22d
    sta.z print_uint.w
    lda #>$22d
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint(31179)
    lda #<$79cb
    sta.z print_uint.w
    lda #>$79cb
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint(0)
    lda #<0
    sta.z print_uint.w
    sta.z print_uint.w+1
    jsr print_uint
    // print_ln()
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    lda #0
    sta.z i
  __b1:
    // for(byte i=0; i<20; i++)
    lda.z i
    cmp #$14
    bcc __b2
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("   ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uint(29793)
    lda #<$7461
    sta.z print_uint.w
    lda #>$7461
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint(63361)
    lda #<$f781
    sta.z print_uint.w
    lda #>$f781
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint($6488)
    lda #<$6488
    sta.z print_uint.w
    lda #>$6488
    sta.z print_uint.w+1
    jsr print_uint
    // print_ln()
    jsr print_ln
    // }
    rts
  __b2:
    // print_uchar(i)
    ldx.z i
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_uchar(i)
    jsr print_uchar
    // print_str(" ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint(lintab1[i])
    lda.z i
    asl
    tay
    lda lintab1,y
    sta.z print_uint.w
    lda lintab1+1,y
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint(lintab2[i])
    lda.z i
    asl
    tay
    lda lintab2,y
    sta.z print_uint.w
    lda lintab2+1,y
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint(lintab3[i])
    lda.z i
    asl
    tay
    lda lintab3,y
    sta.z print_uint.w
    lda lintab3+1,y
    sta.z print_uint.w+1
    jsr print_uint
    // print_ln()
    jsr print_ln
    // for(byte i=0; i<20; i++)
    inc.z i
    jmp __b1
    lintab1: .fill 2*$14, 0
    lintab2: .fill 2*$14, 0
    lintab3: .fill 2*$14, 0
    str: .text "   "
    .byte 0
    str1: .text " "
    .byte 0
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
// Print a unsigned int as HEX
// print_uint(word zp(7) w)
print_uint: {
    .label w = 7
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
    .label dst = 7
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
// Generate word linear table
// lintab - the table to generate into
// length - the number of points in a total sinus wavelength (the size of the table)
// lin16u_gen(word zp(9) min, word zp(7) max, word* zp($11) lintab)
lin16u_gen: {
    .label __6 = $1d
    .label ampl = 7
    .label stepi = $17
    .label stepf = $15
    .label step = $19
    .label val = $d
    .label lintab = $11
    .label i = $b
    .label max = 7
    .label min = 9
    // ampl = max-min
    lda.z ampl
    sec
    sbc.z min
    sta.z ampl
    lda.z ampl+1
    sbc.z min+1
    sta.z ampl+1
    // divr16u(ampl, length-1, 0)
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    // divr16u(ampl, length-1, 0)
    // stepi = divr16u(ampl, length-1, 0)
    lda.z divr16u.return
    sta.z stepi
    lda.z divr16u.return+1
    sta.z stepi+1
    // divr16u(0, length-1, rem16u)
    lda #<0
    sta.z divr16u.dividend
    sta.z divr16u.dividend+1
    jsr divr16u
    // divr16u(0, length-1, rem16u)
    // stepf = divr16u(0, length-1, rem16u)
    // step = { stepi, stepf }
    lda.z stepi
    sta.z step+2
    lda.z stepi+1
    sta.z step+3
    lda.z stepf
    sta.z step
    lda.z stepf+1
    sta.z step+1
    // val = { min, 0 }
    lda #<0
    sta.z val
    sta.z val+1
    lda.z min
    sta.z val+2
    lda.z min+1
    sta.z val+3
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(word i=0; i<length; i++)
    lda.z i+1
    cmp #>$14
    bcc __b2
    bne !+
    lda.z i
    cmp #<$14
    bcc __b2
  !:
    // }
    rts
  __b2:
    // >val
    lda.z val+2
    sta.z __6
    lda.z val+3
    sta.z __6+1
    // *lintab = >val
    ldy #0
    lda.z __6
    sta (lintab),y
    iny
    lda.z __6+1
    sta (lintab),y
    // val = val + step
    lda.z val
    clc
    adc.z step
    sta.z val
    lda.z val+1
    adc.z step+1
    sta.z val+1
    lda.z val+2
    adc.z step+2
    sta.z val+2
    lda.z val+3
    adc.z step+3
    sta.z val+3
    // lintab++;
    lda #SIZEOF_WORD
    clc
    adc.z lintab
    sta.z lintab
    bcc !+
    inc.z lintab+1
  !:
    // for(word i=0; i<length; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp(7) dividend, word zp($13) rem)
divr16u: {
    .label rem = $13
    .label dividend = 7
    .label quotient = $15
    .label return = $15
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
    cmp #>$14-1
    bcc __b3
    bne !+
    lda.z rem
    cmp #<$14-1
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
    sbc #<$14-1
    sta.z rem
    lda.z rem+1
    sbc #>$14-1
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
  print_hextab: .text "0123456789abcdef"
