// Calculates the 1000 first primes
// From A Comparison of Language Speed, The Transactor, March 1987, Volume 7, Issue 5
// http://csbruce.com/cbm/transactor/pdfs/trans_v7_i05.pdf
  // Commodore 64 PRG executable file
.file [name="primes-1000.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_INT = 2
  .label print_screen = $400
  // Remainder after unsigned 16-bit division
  .label rem16u = $19
  // Remainder after signed 16 bit division
  .label rem16s = $19
  .label testnum = 6
  .label lasttest = 2
  .label primeptr = $15
  .label lastprime = 4
  .label print_char_cursor = $c
.segment Code
main: {
    .label __0 = 8
    .label __12 = $15
    .label __13 = $12
    .label __14 = $19
    .label __15 = $17
    .label p = $15
    .label __16 = $15
    .label __17 = $12
    .label __18 = $19
    // primenum[1] = 2
    lda #<2
    sta primenum+1*SIZEOF_INT
    lda #>2
    sta primenum+1*SIZEOF_INT+1
    // primenum[2] = 3
    lda #<3
    sta primenum+2*SIZEOF_INT
    lda #>3
    sta primenum+2*SIZEOF_INT+1
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<2
    sta.z lastprime
    lda #>2
    sta.z lastprime+1
    lda #<3
    sta.z testnum
    lda #>3
    sta.z testnum+1
    lda #<2
    sta.z lasttest
    lda #>2
    sta.z lasttest+1
  __b1:
    // int p = primenum[lasttest]
    lda.z lasttest
    asl
    sta.z __12
    lda.z lasttest+1
    rol
    sta.z __12+1
    lda #<primenum
    clc
    adc.z __16
    sta.z __16
    lda #>primenum
    adc.z __16+1
    sta.z __16+1
    ldy #0
    lda (p),y
    pha
    iny
    lda (p),y
    sta.z p+1
    pla
    sta.z p
    // mul16s(p, p)
    jsr mul16s
    // testnum > (int)mul16s(p, p)
    lda.z __0
    sta.z __15
    lda.z __0+1
    sta.z __15+1
    // if(testnum > (int)mul16s(p, p))
    lda.z __15
    cmp.z testnum
    lda.z __15+1
    sbc.z testnum+1
    bvc !+
    eor #$80
  !:
    bpl __b2
    // lasttest++;
    inc.z lasttest
    bne !+
    inc.z lasttest+1
  !:
  __b2:
    // testnum +=2
    lda.z testnum
    clc
    adc #<2
    sta.z testnum
    lda.z testnum+1
    adc #>2
    sta.z testnum+1
    lda #<2
    sta.z primeptr
    lda #>2
    sta.z primeptr+1
  __b3:
    // div16s(testnum, primenum[primeptr++])
    lda.z primeptr
    asl
    sta.z __13
    lda.z primeptr+1
    rol
    sta.z __13+1
    lda #<primenum
    clc
    adc.z __17
    sta.z __17
    lda #>primenum
    adc.z __17+1
    sta.z __17+1
    ldy #0
    lda (div16s.divisor),y
    pha
    iny
    lda (div16s.divisor),y
    sta.z div16s.divisor+1
    pla
    sta.z div16s.divisor
    jsr div16s
    // div16s(testnum, primenum[primeptr++]);
    inc.z primeptr
    bne !+
    inc.z primeptr+1
  !:
    // if(rem16s == 0)
    lda.z rem16s+1
    ora.z rem16s
    bne __b4
    // testnum +=2
    lda.z testnum
    clc
    adc #<2
    sta.z testnum
    lda.z testnum+1
    adc #>2
    sta.z testnum+1
    lda #<2
    sta.z primeptr
    lda #>2
    sta.z primeptr+1
  __b4:
    // while (primeptr<=lasttest)
    lda.z lasttest
    cmp.z primeptr
    lda.z lasttest+1
    sbc.z primeptr+1
    bvc !+
    eor #$80
  !:
    bpl __b3
    // primenum[++lastprime] = testnum;
    inc.z lastprime
    bne !+
    inc.z lastprime+1
  !:
    // primenum[++lastprime] = testnum
    lda.z lastprime
    asl
    sta.z __14
    lda.z lastprime+1
    rol
    sta.z __14+1
    lda #<primenum
    clc
    adc.z __18
    sta.z __18
    lda #>primenum
    adc.z __18+1
    sta.z __18+1
    ldy #0
    lda.z testnum
    sta (__18),y
    iny
    lda.z testnum+1
    sta (__18),y
    // print_sint_decimal(testnum)
    lda.z testnum
    sta.z print_sint_decimal.w
    lda.z testnum+1
    sta.z print_sint_decimal.w+1
    jsr print_sint_decimal
    // print_char(' ')
    lda #' '
    jsr print_char
    // while(lastprime<totalprimes)
    lda.z lastprime
    cmp #<$3e8
    lda.z lastprime+1
    sbc #>$3e8
    bvc !+
    eor #$80
  !:
    bpl !__b1+
    jmp __b1
  !__b1:
    // }
    rts
}
// Multiply of two signed ints to a signed long
// Fixes offsets introduced by using unsigned multiplication
// __zp(8) long mul16s(__zp($15) int a, __zp($15) int b)
mul16s: {
    .label __6 = $1b
    .label __9 = $1d
    .label __11 = $1b
    .label __12 = $1d
    .label m = 8
    .label return = 8
    .label a = $15
    .label b = $15
    // unsigned long m = mul16u((unsigned int)a, (unsigned int) b)
    lda.z a
    sta.z mul16u.a
    lda.z a+1
    sta.z mul16u.a+1
    lda.z b
    sta.z mul16u.b
    lda.z b+1
    sta.z mul16u.b+1
    jsr mul16u
    // if(a<0)
    lda.z a+1
    bpl __b1
    // WORD1(m)
    lda.z m+2
    sta.z __6
    lda.z m+3
    sta.z __6+1
    // WORD1(m) = WORD1(m)-(unsigned int)b
    lda.z __11
    sec
    sbc.z b
    sta.z __11
    lda.z __11+1
    sbc.z b+1
    sta.z __11+1
    lda.z __11
    sta.z m+2
    lda.z __11+1
    sta.z m+3
  __b1:
    // if(b<0)
    lda.z b+1
    bpl __b2
    // WORD1(m)
    lda.z m+2
    sta.z __9
    lda.z m+3
    sta.z __9+1
    // WORD1(m) = WORD1(m)-(unsigned int)a
    lda.z __12
    sec
    sbc.z a
    sta.z __12
    lda.z __12+1
    sbc.z a+1
    sta.z __12+1
    lda.z __12
    sta.z m+2
    lda.z __12+1
    sta.z m+3
  __b2:
    // return (signed long)m;
    // }
    rts
}
// Perform division on two signed 16-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// int div16s(__zp(6) int dividend, __zp($12) int divisor)
div16s: {
    .label dividend = 6
    .label divisor = $12
    // divr16s(dividend, divisor, 0)
    lda.z dividend
    sta.z divr16s.dividend
    lda.z dividend+1
    sta.z divr16s.dividend+1
    jsr divr16s
    // }
    rts
}
// Print a signed int as DECIMAL
// void print_sint_decimal(__zp($15) int w)
print_sint_decimal: {
    .label w = $15
    // if(w<0)
    lda.z w+1
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // utoa((unsigned int)w, decimal_digits, DECIMAL)
    jsr utoa
    // print_str(decimal_digits)
    jsr print_str
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
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// __zp(8) unsigned long mul16u(__zp($17) unsigned int a, __zp($1b) unsigned int b)
mul16u: {
    .label mb = $e
    .label a = $17
    .label res = 8
    .label b = $1b
    .label return = 8
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
// Perform division on two signed 16-bit numbers with an initial remainder.
// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// int divr16s(__zp($17) int dividend, __zp($12) int divisor, int rem)
divr16s: {
    .label dividendu = $17
    .label divisoru = $12
    .label dividend = $17
    .label divisor = $12
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__zp($15) unsigned int value, __zp($19) char *buffer, char radix)
utoa: {
    .const max_digits = 5
    .label value = $15
    .label digit_value = $1d
    .label buffer = $19
    .label digit = $14
    lda #<decimal_digits
    sta.z buffer
    lda #>decimal_digits
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    ldx.z value
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    lda #0
    tay
    sta (buffer),y
    // }
    rts
  __b2:
    // unsigned int digit_value = digit_values[digit]
    lda.z digit
    asl
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    cpx #0
    bne __b5
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // utoa_append(buffer++, value, digit_value)
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    ldx #1
    jmp __b4
}
// Print a zero-terminated string
// void print_str(__zp($1b) char *str)
print_str: {
    .label str = $1b
    lda #<decimal_digits
    sta.z str
    lda #>decimal_digits
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
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($1b) unsigned int divr16u(__zp($17) unsigned int dividend, __zp($12) unsigned int divisor, __zp($19) unsigned int rem)
divr16u: {
    .label rem = $19
    .label dividend = $17
    .label quotient = $1b
    .label return = $1b
    .label divisor = $12
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __zp($15) unsigned int utoa_append(__zp($19) char *buffer, __zp($15) unsigned int value, __zp($1d) unsigned int sub)
utoa_append: {
    .label buffer = $19
    .label value = $15
    .label sub = $1d
    .label return = $15
    ldx #0
  __b1:
    // while (value >= sub)
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    // *buffer = DIGITS[digit]
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inx
    // value -= sub
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    jmp __b1
}
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Digits used for storing the decimal unsigned int
  decimal_digits: .fill 6, 0
  primenum: .fill 2*$3e8, 0
