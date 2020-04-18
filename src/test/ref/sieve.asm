.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Clock cycles per frame (on a C64 PAL)
  .const CLOCKS_PER_FRAME = $4cc8
  // Frames per second (on a C64 PAL)
  .const FRAMES_PER_SEC = $3c
  // Clock cycles per second (on a C64 PAL)
  .const CLOCKS_PER_SEC = CLOCKS_PER_FRAME*FRAMES_PER_SEC
  // Clock cycles used to start & read the cycle clock by calling clock_start() and clock() once. Can be subtracted when calculating the number of cycles used by a routine.
  // To make precise cycle measurements interrupts and the display must be disabled so neither steals any cycles from the code.
  .const CLOCKS_PER_INIT = $12
  .label D018 = $d018
  // CIA #2 Timer A+B Value (32-bit)
  .label CIA2_TIMER_AB = $dd04
  // CIA #2 Timer A Control Register
  .label CIA2_TIMER_A_CONTROL = $dd0e
  // CIA #2 Timer B Control Register
  .label CIA2_TIMER_B_CONTROL = $dd0f
  // Timer Control - Start/stop timer (0:stop, 1: start)
  .const CIA_TIMER_CONTROL_START = 1
  // Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
  .const CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A = $40
  .label SCREEN = $400
  .const COUNT = $4000
  /* Up to what number? */
  .const SQRT_COUNT = $80
  /* Sqrt of COUNT */
  .label sieve = $1000
  // Remainder after unsigned 16-bit division
  .label rem16u = $13
  .label print_char_cursor = $a
  .label print_line_cursor = $c
  .label print_char_cursor_1 = $c
main: {
    .label toD0181_gfx = $1800
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>toD0181_gfx)/4&$f
    .label __10 = $f
    .label __12 = $17
    .label cyclecount = $f
    .label sec100s = 4
    .label i = $a
    .label sieve_i = 2
    .label j = 6
    .label s = 8
    .label i_1 = 4
    .label __34 = $1b
    // *D018 = toD018(SCREEN, 0x1800)
    //Show lower case font
    lda #toD0181_return
    sta D018
    // print_cls()
    jsr print_cls
    // print_str("Sieve benchmark - calculating primes")
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("between 2 and ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint_decimal(COUNT)
    lda #<COUNT
    sta.z print_uint_decimal.w
    lda #>COUNT
    sta.z print_uint_decimal.w+1
    jsr print_uint_decimal
    // print_ln()
    jsr print_ln
    // memset(sieve, 0, COUNT)
  // Fill sieve with zeros
    ldx #0
    lda #<sieve
    sta.z memset.str
    lda #>sieve
    sta.z memset.str+1
    lda #<COUNT
    sta.z memset.num
    lda #>COUNT
    sta.z memset.num+1
    jsr memset
    // clock_start()
    jsr clock_start
    lda #<sieve+2
    sta.z sieve_i
    lda #>sieve+2
    sta.z sieve_i+1
    lda #<2
    sta.z i
    lda #>2
    sta.z i+1
  __b1:
    // while (i < SQRT_COUNT)
    lda.z i+1
    cmp #>SQRT_COUNT
    bcs !__b2+
    jmp __b2
  !__b2:
    bne !+
    lda.z i
    cmp #<SQRT_COUNT
    bcs !__b2+
    jmp __b2
  !__b2:
  !:
    // clock()
    jsr clock
    // cyclecount = clock()-CLOCKS_PER_INIT
    lda.z cyclecount
    sec
    sbc #<CLOCKS_PER_INIT
    sta.z cyclecount
    lda.z cyclecount+1
    sbc #>CLOCKS_PER_INIT
    sta.z cyclecount+1
    lda.z cyclecount+2
    sbc #<CLOCKS_PER_INIT>>$10
    sta.z cyclecount+2
    lda.z cyclecount+3
    sbc #>CLOCKS_PER_INIT>>$10
    sta.z cyclecount+3
    // div32u16u(cyclecount, (unsigned int)(CLOCKS_PER_SEC/100))
    jsr div32u16u
    // sec100s = (unsigned int)div32u16u(cyclecount, (unsigned int)(CLOCKS_PER_SEC/100))
    lda.z __12
    sta.z sec100s
    lda.z __12+1
    sta.z sec100s+1
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("100ths seconds used: ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_uint_decimal(sec100s)
    jsr print_uint_decimal
    // print_str(" cycles: ")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // print_ulong_decimal(cyclecount)
    jsr print_ulong_decimal
    // print_ln()
    jsr print_ln
    lda #<2
    sta.z i_1
    lda #>2
    sta.z i_1+1
  __b8:
    // for (i = 2; i < 1300; ++i)
    lda.z i_1+1
    cmp #>$514
    bcc __b9
    bne !+
    lda.z i_1
    cmp #<$514
    bcc __b9
  !:
    lda.z print_char_cursor_1
    sta.z print_char_cursor
    lda.z print_char_cursor_1+1
    sta.z print_char_cursor+1
    // print_str("...")
    lda #<str4
    sta.z print_str.str
    lda #>str4
    sta.z print_str.str+1
    jsr print_str
  __b13:
    // (*(SCREEN+999))++;
    inc SCREEN+$3e7
    jmp __b13
  __b9:
    // if (!sieve[i])
    lda.z i_1
    clc
    adc #<sieve
    sta.z __34
    lda.z i_1+1
    adc #>sieve
    sta.z __34+1
    ldy #0
    lda (__34),y
    cmp #0
    bne __b11
    // print_uint_decimal(i)
    lda.z print_char_cursor_1
    sta.z print_char_cursor
    lda.z print_char_cursor_1+1
    sta.z print_char_cursor+1
    // print_uint_decimal(i)
    jsr print_uint_decimal
    // print_char(' ')
    lda #' '
    jsr print_char
  __b11:
    // for (i = 2; i < 1300; ++i)
    inc.z i_1
    bne !+
    inc.z i_1+1
  !:
    jmp __b8
  __b2:
    // if (!*sieve_i)
    ldy #0
    lda (sieve_i),y
    cmp #0
    bne __b4
    // j = i*2
    lda.z i
    asl
    sta.z j
    lda.z i+1
    rol
    sta.z j+1
    // s = &sieve[j]
    lda.z j
    clc
    adc #<sieve
    sta.z s
    lda.z j+1
    adc #>sieve
    sta.z s+1
  __b5:
    // while (j < COUNT)
    lda.z j+1
    cmp #>COUNT
    bcc __b6
    bne !+
    lda.z j
    cmp #<COUNT
    bcc __b6
  !:
  __b4:
    // i++;
    inc.z i
    bne !+
    inc.z i+1
  !:
    // sieve_i++;
    inc.z sieve_i
    bne !+
    inc.z sieve_i+1
  !:
    jmp __b1
  __b6:
    // *s = 1
    lda #1
    ldy #0
    sta (s),y
    // s += i
    lda.z s
    clc
    adc.z i
    sta.z s
    lda.z s+1
    adc.z i+1
    sta.z s+1
    // j += i
    lda.z j
    clc
    adc.z i
    sta.z j
    lda.z j+1
    adc.z i+1
    sta.z j+1
    jmp __b5
    str: .text "Sieve benchmark - calculating primes"
    .byte 0
    str1: .text "between 2 and "
    .byte 0
    str2: .text "100ths seconds used: "
    .byte 0
    str3: .text " cycles: "
    .byte 0
    str4: .text "..."
    .byte 0
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    lda.z print_char_cursor
    clc
    adc #1
    sta.z print_char_cursor_1
    lda.z print_char_cursor+1
    adc #0
    sta.z print_char_cursor_1+1
    // }
    rts
}
// Print a unsigned int as DECIMAL
// print_uint_decimal(word zp(4) w)
print_uint_decimal: {
    .label w = 4
    // utoa(w, decimal_digits, DECIMAL)
    lda.z w
    sta.z utoa.value
    lda.z w+1
    sta.z utoa.value+1
    jsr utoa
    // print_str(decimal_digits)
    lda #<decimal_digits
    sta.z print_str.str
    lda #>decimal_digits
    sta.z print_str.str+1
    jsr print_str
    // }
    rts
}
// Print a zero-terminated string
// print_str(byte* zp($13) str)
print_str: {
    .label str = $13
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
    lda.z print_char_cursor_1
    sta.z print_char_cursor
    lda.z print_char_cursor_1+1
    sta.z print_char_cursor+1
    jmp __b1
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($13) value, byte* zp($15) buffer)
utoa: {
    .const max_digits = 5
    .label digit_value = $21
    .label buffer = $15
    .label digit = $e
    .label value = $13
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
    // (char)value
    lda.z value
    // *buffer++ = DIGITS[(char)value]
    tay
    lda DIGITS,y
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
    // digit_value = digit_values[digit]
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($15) buffer, word zp($13) value, word zp($21) sub)
utoa_append: {
    .label buffer = $15
    .label value = $13
    .label sub = $21
    .label return = $13
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
// Print a unsigned long as DECIMAL
// print_ulong_decimal(dword zp($f) w)
print_ulong_decimal: {
    .label w = $f
    // ultoa(w, decimal_digits_long, DECIMAL)
    jsr ultoa
    // print_str(decimal_digits_long)
    lda #<decimal_digits_long
    sta.z print_str.str
    lda #>decimal_digits_long
    sta.z print_str.str+1
    jsr print_str
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zp($f) value, byte* zp($15) buffer)
ultoa: {
    .const max_digits = $a
    .label digit_value = $1d
    .label buffer = $15
    .label digit = $e
    .label value = $f
    lda #<decimal_digits_long
    sta.z buffer
    lda #>decimal_digits_long
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // (char)value
    lda.z value
    // *buffer++ = DIGITS[(char)value]
    tay
    lda DIGITS,y
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
    // digit_value = digit_values[digit]
    lda.z digit
    asl
    asl
    tay
    lda RADIX_DECIMAL_VALUES_LONG,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES_LONG+1,y
    sta.z digit_value+1
    lda RADIX_DECIMAL_VALUES_LONG+2,y
    sta.z digit_value+2
    lda RADIX_DECIMAL_VALUES_LONG+3,y
    sta.z digit_value+3
    // if (started || value >= digit_value)
    cpx #0
    bne __b5
    lda.z value+3
    cmp.z digit_value+3
    bcc !+
    bne __b5
    lda.z value+2
    cmp.z digit_value+2
    bcc !+
    bne __b5
    lda.z value+1
    cmp.z digit_value+1
    bcc !+
    bne __b5
    lda.z value
    cmp.z digit_value
    bcs __b5
  !:
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // ultoa_append(buffer++, value, digit_value)
    jsr ultoa_append
    // ultoa_append(buffer++, value, digit_value)
    // value = ultoa_append(buffer++, value, digit_value)
    // value = ultoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    ldx #1
    jmp __b4
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// ultoa_append(byte* zp($15) buffer, dword zp($f) value, dword zp($1d) sub)
ultoa_append: {
    .label buffer = $15
    .label value = $f
    .label sub = $1d
    .label return = $f
    ldx #0
  __b1:
    // while (value >= sub)
    lda.z value+3
    cmp.z sub+3
    bcc !+
    bne __b2
    lda.z value+2
    cmp.z sub+2
    bcc !+
    bne __b2
    lda.z value+1
    cmp.z sub+1
    bcc !+
    bne __b2
    lda.z value
    cmp.z sub
    bcs __b2
  !:
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
    lda.z value+2
    sbc.z sub+2
    sta.z value+2
    lda.z value+3
    sbc.z sub+3
    sta.z value+3
    jmp __b1
}
// Divide unsigned 32-bit unsigned long dividend with a 16-bit unsigned int divisor
// The 16-bit unsigned int remainder can be found in rem16u after the division
// div32u16u(dword zp($f) dividend)
div32u16u: {
    .label divisor = CLOCKS_PER_SEC/$64
    .label quotient_hi = $21
    .label quotient_lo = $1b
    .label return = $17
    .label dividend = $f
    // divr16u(>dividend, divisor, 0)
    lda.z dividend+2
    sta.z divr16u.dividend
    lda.z dividend+3
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
    lda.z dividend
    sta.z divr16u.dividend
    lda.z dividend+1
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
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp($15) dividend, word zp($13) rem)
divr16u: {
    .label rem = $13
    .label dividend = $15
    .label quotient = $1b
    .label return = $1b
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
    cmp #>div32u16u.divisor
    bcc __b3
    bne !+
    lda.z rem
    cmp #<div32u16u.divisor
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
    sbc #<div32u16u.divisor
    sta.z rem
    lda.z rem+1
    sbc #>div32u16u.divisor
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
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    .label return = $f
    // 0xffffffff - *CIA2_TIMER_AB
    lda #<$ffffffff
    sec
    sbc CIA2_TIMER_AB
    sta.z return
    lda #>$ffffffff
    sbc CIA2_TIMER_AB+1
    sta.z return+1
    lda #<$ffffffff>>$10
    sbc CIA2_TIMER_AB+2
    sta.z return+2
    lda #>$ffffffff>>$10
    sbc CIA2_TIMER_AB+3
    sta.z return+3
    // }
    rts
}
// Reset & start the processor clock time. The value can be read using clock().
// This uses CIA #2 Timer A+B on the C64
clock_start: {
    // *CIA2_TIMER_A_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    // Setup CIA#2 timer A to count (down) CPU cycles
    lda #0
    sta CIA2_TIMER_A_CONTROL
    // *CIA2_TIMER_B_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2_TIMER_B_CONTROL
    // *CIA2_TIMER_AB = 0xffffffff
    lda #<$ffffffff
    sta CIA2_TIMER_AB
    lda #>$ffffffff
    sta CIA2_TIMER_AB+1
    lda #<$ffffffff>>$10
    sta CIA2_TIMER_AB+2
    lda #>$ffffffff>>$10
    sta CIA2_TIMER_AB+3
    // *CIA2_TIMER_B_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_START|CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2_TIMER_B_CONTROL
    // *CIA2_TIMER_A_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    lda #CIA_TIMER_CONTROL_START
    sta CIA2_TIMER_A_CONTROL
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($1b) str, byte register(X) c, word zp($15) num)
memset: {
    .label end = $15
    .label dst = $1b
    .label num = $15
    .label str = $1b
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // end = (char*)str + num
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    ldx #' '
    lda #<$400
    sta.z memset.str
    lda #>$400
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    // }
    rts
}
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // Digits used for storing the decimal unsigned int
  decimal_digits: .fill 6, 0
  // Digits used for storing the decimal unsigned int
  decimal_digits_long: .fill $b, 0
