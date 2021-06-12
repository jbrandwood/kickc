// Calculates the 1000 first primes
// From A Comparison of Language Speed, The Transactor, March 1987, Volume 7, Issue 5
// http://csbruce.com/cbm/transactor/pdfs/trans_v7_i05.pdf
  // Commodore 64 PRG executable file
.file [name="primes-1000-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
  .label print_screen = $400
  .label print_char_cursor = $f
  // The number currently being tested for whether it is a prime
  .label potential = 5
  // The last index to test. It is the smallest index where PRIMES[test_last] > sqr(potential)
  .label test_last = 2
  // The index into PRIMES[] used for prime testing. It runs from 2 to test_last for each number tested.
  .label test_idx = $c
  // The index of the last prime we put into the PRIME[] table
  .label prime_idx = 3
.segment Code
main: {
    .label __0 = 7
    .label __14 = $11
    .label __15 = $11
    // PRIMES[1] = 2
    lda #0
    sta PRIMES+1*SIZEOF_WORD+1
    lda #<2
    sta PRIMES+1*SIZEOF_WORD
    // PRIMES[2] = 3
    lda #0
    sta PRIMES+2*SIZEOF_WORD+1
    lda #<3
    sta PRIMES+2*SIZEOF_WORD
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<2
    sta.z prime_idx
    lda #>2
    sta.z prime_idx+1
    lda #<3
    sta.z potential
    lda #>3
    sta.z potential+1
    lda #2
    sta.z test_last
  __b1:
    // char p = (char)PRIMES[test_last]
    lda.z test_last
    asl
    tay
    lda PRIMES,y
    // mul8u(p, p)
    tax
    jsr mul8u
    // if(potential > mul8u(p, p))
    lda.z potential+1
    cmp.z __0+1
    bne !+
    lda.z potential
    cmp.z __0
    beq __b2
  !:
    bcc __b2
    // test_last++;
    inc.z test_last
  __b2:
    // potential +=2
    lda #2
    clc
    adc.z potential
    sta.z potential
    bcc !+
    inc.z potential+1
  !:
    lda #2
    sta.z test_idx
  __b3:
    // div16u8u(potential, (char)PRIMES[test_idx++])
    lda.z test_idx
    asl
    tax
    lda PRIMES,x
    sta.z div16u8u.divisor
    jsr div16u8u
    // div16u8u(potential, (char)PRIMES[test_idx++]);
    inc.z test_idx
    // if(rem8u == 0)
    cpy #0
    bne __b4
    // potential +=2
    lda #2
    clc
    adc.z potential
    sta.z potential
    bcc !+
    inc.z potential+1
  !:
    lda #2
    sta.z test_idx
  __b4:
    // while (test_idx<=test_last)
    lda.z test_last
    cmp.z test_idx
    bcs __b3
    // PRIMES[++prime_idx] = potential;
    inc.z prime_idx
    bne !+
    inc.z prime_idx+1
  !:
    // PRIMES[++prime_idx] = potential
    lda.z prime_idx
    asl
    sta.z __14
    lda.z prime_idx+1
    rol
    sta.z __14+1
    clc
    lda.z __15
    adc #<PRIMES
    sta.z __15
    lda.z __15+1
    adc #>PRIMES
    sta.z __15+1
    ldy #0
    lda.z potential
    sta (__15),y
    iny
    lda.z potential+1
    sta (__15),y
    // print_uint_decimal(potential)
    jsr print_uint_decimal
    // print_char(' ')
    lda #' '
    jsr print_char
    // while(prime_idx<totalprimes)
    lda.z prime_idx+1
    cmp #>$3e8
    bcs !__b1+
    jmp __b1
  !__b1:
    bne !+
    lda.z prime_idx
    cmp #<$3e8
    bcs !__b1+
    jmp __b1
  !__b1:
  !:
    // }
    rts
}
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = $11
    .label res = 7
    .label return = 7
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
// Divide unsigned 16-bit unsigned long dividend with a 8-bit unsigned char divisor
// The 8-bit unsigned char remainder can be found in rem8u after the division
// div16u8u(word zp(5) dividend, byte zp(9) divisor)
div16u8u: {
    .label dividend = 5
    .label divisor = 9
    // divr8u(BYTE1(dividend), divisor, 0)
    lda.z dividend+1
    sta.z divr8u.dividend
    ldy #0
    jsr divr8u
    // divr8u(BYTE0(dividend), divisor, rem8u)
    lda.z dividend
    sta.z divr8u.dividend
    jsr divr8u
    // }
    rts
}
// Print a unsigned int as DECIMAL
// print_uint_decimal(word zp(5) w)
print_uint_decimal: {
    .label w = 5
    // utoa(w, decimal_digits, DECIMAL)
    lda.z w
    sta.z utoa.value
    lda.z w+1
    sta.z utoa.value+1
    jsr utoa
    // print_str(decimal_digits)
    jsr print_str
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
// Performs division on two 8 bit unsigned chars and an initial remainder
// Returns dividend/divisor.
// The final remainder will be set into the global variable rem8u
// Implemented using simple binary division
// divr8u(byte zp($a) dividend, byte zp(9) divisor, byte register(Y) rem)
divr8u: {
    .label dividend = $a
    .label quotient = $b
    .label return = $b
    .label divisor = 9
    ldx #0
    txa
    sta.z quotient
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
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($11) value, byte* zp($d) buffer)
utoa: {
    .const max_digits = 5
    .label value = $11
    .label digit_value = $13
    .label buffer = $d
    .label digit = $c
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
// print_str(byte* zp($d) str)
print_str: {
    .label str = $d
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($d) buffer, word zp($11) value, word zp($13) sub)
utoa_append: {
    .label buffer = $d
    .label value = $11
    .label sub = $13
    .label return = $11
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
  // Table that is filled with the primes we are finding
  PRIMES: .fill 2*$3e8, 0
