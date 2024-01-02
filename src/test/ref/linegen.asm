// Linear table generator
// Work in progress towards a sine generator
/// @file
/// Simple binary division implementation
///
/// Follows the C99 standard by truncating toward zero on negative results.
/// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
  // Commodore 64 PRG executable file
.file [name="linegen.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNSIGNED_INT = 2
  .label print_screen = $400
  // Remainder after unsigned 16-bit division
  .label rem16u = 8
  .label print_char_cursor = 2
  .label print_line_cursor = 6
.segment Code
main: {
    .label __28 = $17
    .label i = $12
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
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
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
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
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
    sta.z __28
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
    ldy.z __28
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
    ldy.z __28
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
  .segment Data
    lintab1: .fill 2*$14, 0
    lintab2: .fill 2*$14, 0
    lintab3: .fill 2*$14, 0
    str: .text "   "
    .byte 0
    str1: .text " "
    .byte 0
}
.segment Code
// Generate word linear table
// lintab - the table to generate into
// length - the number of points in a total sine wavelength (the size of the table)
// void lin16u_gen(__zp($10) unsigned int min, __zp(4) unsigned int max, __zp($a) unsigned int *lintab, unsigned int length)
lin16u_gen: {
    .label __8 = 8
    .label ampl = 4
    .label stepi = $18
    .label stepf = 2
    .label step = $13
    .label val = $c
    .label lintab = $a
    .label i = 6
    .label max = 4
    .label min = $10
    // word ampl = max-min
    lda.z ampl
    sec
    sbc.z min
    sta.z ampl
    lda.z ampl+1
    sbc.z min+1
    sta.z ampl+1
    // word stepi = divr16u(ampl, length-1, 0)
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    // word stepi = divr16u(ampl, length-1, 0)
    lda.z divr16u.return
    sta.z stepi
    lda.z divr16u.return+1
    sta.z stepi+1
    // word stepf = divr16u(0, length-1, rem16u)
    lda #<0
    sta.z divr16u.dividend
    sta.z divr16u.dividend+1
    jsr divr16u
    // word stepf = divr16u(0, length-1, rem16u)
    // dword step = MAKELONG( stepi, stepf )
    lda.z stepi
    sta.z step+2
    lda.z stepi+1
    sta.z step+3
    lda.z stepf
    sta.z step
    lda.z stepf+1
    sta.z step+1
    // dword val = MAKELONG( min, 0 )
    lda.z min
    sta.z val+2
    lda.z min+1
    sta.z val+3
    lda #0
    sta.z val
    sta.z val+1
    sta.z i
    sta.z i+1
  __b1:
    // for(word i=0; i<length; i++)
    lda.z i+1
    bne !+
    lda.z i
    cmp #$14
    bcc __b2
  !:
    // }
    rts
  __b2:
    // WORD1(val)
    lda.z val+2
    sta.z __8
    lda.z val+3
    sta.z __8+1
    // *lintab = WORD1(val)
    ldy #0
    lda.z __8
    sta (lintab),y
    iny
    lda.z __8+1
    sta (lintab),y
    // val = val + step
    clc
    lda.z val
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
    lda #SIZEOF_UNSIGNED_INT
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
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Print a zero-terminated string
// void print_str(__zp(4) char *str)
print_str: {
    .label str = 4
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
// void print_uint(__zp($10) unsigned int w)
print_uint: {
    .label w = $10
    // print_uchar(BYTE1(w))
    ldx.z w+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + 0x28
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
    // b&0xf
    lda #$f
    axs #0
    // print_char(print_hextab[b&0xf])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp(2) unsigned int divr16u(__zp(4) unsigned int dividend, unsigned int divisor, __zp(8) unsigned int rem)
divr16u: {
    .label rem = 8
    .label dividend = 4
    .label quotient = 2
    .label return = 2
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
    // BYTE1(dividend) & 0x80
    and #$80
    // if( (BYTE1(dividend) & 0x80) != 0 )
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
    bne !+
    lda.z rem
    cmp #$14-1
    bcc __b3
  !:
    // quotient++;
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    sec
    lda.z rem
    sbc #$14-1
    sta.z rem
    lda.z rem+1
    sbc #0
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $a
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
.segment Data
  print_hextab: .text "0123456789abcdef"
