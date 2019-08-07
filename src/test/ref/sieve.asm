.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label D018 = $d018
  // CIA #2 Timer A+B Value (32-bit)
  .label CIA2_TIMER_AB = $dd04
  // CIA #2 Timer A Control Register
  .label CIA2_TIMER_A_CONTROL = $dd0e
  // CIA #2 Timer B Control Register
  .label CIA2_TIMER_B_CONTROL = $dd0f
  // Timer Control - Start/stop timer (0:stop, 1: start)
  .const CIA_TIMER_CONTROL_START = 1
  // Timer Control - Time CONTINUOUS/ONE-SHOT (0:CONTINUOUS, 1: ONE-SHOT)
  .const CIA_TIMER_CONTROL_CONTINUOUS = 0
  // Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
  .const CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A = $40
  // Clock cycles per frame (on a C64 PAL)
  .const CLOCKS_PER_FRAME = $4cc8
  // Frames per second (on a C64 PAL)
  .const FRAMES_PER_SEC = $3c
  // Clock cycles used to start & read the cycle clock by calling clock_start() and clock() once. Can be subtracted when calculating the number of cycles used by a routine.
  // To make precise cycle measurements interrupts and the display must be disabled so neither steals any cycles from the code.
  .const CLOCKS_PER_INIT = $12
  .label SCREEN = $400
  .const COUNT = $4000
  /* Up to what number? */
  .const SQRT_COUNT = $80
  /* Sqrt of COUNT */
  .label sieve = $1000
  // Clock cycles per second (on a C64 PAL)
  .const CLOCKS_PER_SEC = CLOCKS_PER_FRAME*FRAMES_PER_SEC
  .label rem16u = $d
  .label print_char_cursor = $f
  .label print_line_cursor = 4
  .label print_char_cursor_90 = 4
  .label print_char_cursor_104 = 4
main: {
    .label toD0181_gfx = $1800
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>toD0181_gfx)/4&$f
    .label _10 = 7
    .label _14 = $13
    .label cyclecount = 7
    .label sec100s = $b
    .label sieve_i = $d
    .label j = $11
    .label s = 2
    .label i = $b
    .label i_12 = $f
    .label _38 = $17
    .label i_17 = $f
    //Show lower case font
    lda #toD0181_return
    sta D018
    jsr print_cls
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    lda #<COUNT
    sta.z print_word_decimal.w
    lda #>COUNT
    sta.z print_word_decimal.w+1
    jsr print_word_decimal
    jsr print_ln
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
    jsr clock_start
    lda #<sieve+2
    sta.z sieve_i
    lda #>sieve+2
    sta.z sieve_i+1
    lda #<2
    sta.z i_17
    lda #>2
    sta.z i_17+1
  b2:
    ldy #0
    lda (sieve_i),y
    cmp #0
    bne b4
    lda.z i_17
    asl
    sta.z j
    lda.z i_17+1
    rol
    sta.z j+1
    lda.z j
    clc
    adc #<sieve
    sta.z s
    lda.z j+1
    adc #>sieve
    sta.z s+1
  b5:
    lda.z j+1
    cmp #>COUNT
    bcs !b6+
    jmp b6
  !b6:
    bne !+
    lda.z j
    cmp #<COUNT
    bcs !b6+
    jmp b6
  !b6:
  !:
  b4:
    inc.z i_12
    bne !+
    inc.z i_12+1
  !:
    inc.z sieve_i
    bne !+
    inc.z sieve_i+1
  !:
    lda.z i_12+1
    cmp #>SQRT_COUNT
    bcc b2
    bne !+
    lda.z i_12
    cmp #<SQRT_COUNT
    bcc b2
  !:
    jsr clock
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
    jsr div32u16u
    lda.z _14
    sta.z sec100s
    lda.z _14+1
    sta.z sec100s+1
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    jsr print_word_decimal
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    jsr print_dword_decimal
    jsr print_ln
    lda #<2
    sta.z i
    lda #>2
    sta.z i+1
  b9:
    lda.z i
    clc
    adc #<sieve
    sta.z _38
    lda.z i+1
    adc #>sieve
    sta.z _38+1
    ldy #0
    lda (_38),y
    cmp #0
    bne b30
    lda.z print_char_cursor_90
    sta.z print_char_cursor
    lda.z print_char_cursor_90+1
    sta.z print_char_cursor+1
    jsr print_word_decimal
    jsr print_char
  b11:
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$514
    bcc b29
    bne !+
    lda.z i
    cmp #<$514
    bcc b29
  !:
    lda #<str4
    sta.z print_str.str
    lda #>str4
    sta.z print_str.str+1
    jsr print_str
  b13:
    inc SCREEN+$3e7
    jmp b13
  b29:
    lda.z print_char_cursor
    sta.z print_char_cursor_104
    lda.z print_char_cursor+1
    sta.z print_char_cursor_104+1
    jmp b9
  b30:
    lda.z print_char_cursor_90
    sta.z print_char_cursor
    lda.z print_char_cursor_90+1
    sta.z print_char_cursor+1
    jmp b11
  b6:
    lda #1
    ldy #0
    sta (s),y
    lda.z s
    clc
    adc.z i_17
    sta.z s
    lda.z s+1
    adc.z i_17+1
    sta.z s+1
    lda.z j
    clc
    adc.z i_17
    sta.z j
    lda.z j+1
    adc.z i_17+1
    sta.z j+1
    jmp b5
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
// Print a zero-terminated string
// print_str(byte* zeropage($d) str)
print_str: {
    .label str = $d
  b1:
    ldy #0
    lda (str),y
    cmp #0
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp b1
}
// Print a single char
print_char: {
    .const ch = ' '
    lda #ch
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
// Print a word as DECIMAL
// print_word_decimal(word zeropage($b) w)
print_word_decimal: {
    .label w = $b
    lda.z w
    sta.z utoa.value
    lda.z w+1
    sta.z utoa.value+1
    jsr utoa
    lda #<decimal_digits
    sta.z print_str.str
    lda #>decimal_digits
    sta.z print_str.str+1
    jsr print_str
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zeropage($11) value, byte* zeropage(2) buffer)
utoa: {
    .const max_digits = 5
    .label digit_value = $d
    .label buffer = 2
    .label digit = 6
    .label value = $11
    lda RADIX_DECIMAL_VALUES
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1
    sta.z digit_value+1
    lda #<decimal_digits
    sta.z buffer
    lda #>decimal_digits
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  b7:
    lda.z digit_value+1
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq b5
  !:
    bcc b5
  b4:
    inc.z digit
    lda.z digit
    cmp #max_digits-1
    bcc b2
    lda.z value
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #0
    tay
    sta (buffer),y
    rts
  b2:
    lda.z digit
    asl
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    cpx #0
    bne b5
    jmp b7
  b5:
    jsr utoa_append
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    ldx #1
    jmp b4
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zeropage(2) buffer, word zeropage($11) value, word zeropage($d) sub)
utoa_append: {
    .label buffer = 2
    .label value = $11
    .label sub = $d
    .label return = $11
    ldx #0
  b1:
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq b2
  !:
    bcc b2
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    rts
  b2:
    inx
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    jmp b1
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc b1
  !:
    rts
}
// Print a dword as DECIMAL
// print_dword_decimal(dword zeropage(7) w)
print_dword_decimal: {
    .label w = 7
    jsr ultoa
    lda #<decimal_digits_long
    sta.z print_str.str
    lda #>decimal_digits_long
    sta.z print_str.str+1
    jsr print_str
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zeropage(7) value, byte* zeropage($b) buffer)
ultoa: {
    .const max_digits = $a
    .label digit_value = $13
    .label buffer = $b
    .label digit = 6
    .label value = 7
    lda RADIX_DECIMAL_VALUES_LONG
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES_LONG+1
    sta.z digit_value+1
    lda RADIX_DECIMAL_VALUES_LONG+2
    sta.z digit_value+2
    lda RADIX_DECIMAL_VALUES_LONG+3
    sta.z digit_value+3
    lda #<decimal_digits_long
    sta.z buffer
    lda #>decimal_digits_long
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  b7:
    lda.z value+3
    cmp.z digit_value+3
    bcc !+
    bne b5
    lda.z value+2
    cmp.z digit_value+2
    bcc !+
    bne b5
    lda.z value+1
    cmp.z digit_value+1
    bcc !+
    bne b5
    lda.z value
    cmp.z digit_value
    bcs b5
  !:
  b4:
    inc.z digit
    lda.z digit
    cmp #max_digits-1
    bcc b2
    lda.z value
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #0
    tay
    sta (buffer),y
    rts
  b2:
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
    cpx #0
    bne b5
    jmp b7
  b5:
    jsr ultoa_append
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    ldx #1
    jmp b4
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// ultoa_append(byte* zeropage($b) buffer, dword zeropage(7) value, dword zeropage($13) sub)
ultoa_append: {
    .label buffer = $b
    .label value = 7
    .label sub = $13
    .label return = 7
    ldx #0
  b1:
    lda.z value+3
    cmp.z sub+3
    bcc !+
    bne b2
    lda.z value+2
    cmp.z sub+2
    bcc !+
    bne b2
    lda.z value+1
    cmp.z sub+1
    bcc !+
    bne b2
    lda.z value
    cmp.z sub
    bcs b2
  !:
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    rts
  b2:
    inx
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
    jmp b1
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
// div32u16u(dword zeropage(7) dividend)
div32u16u: {
    .label divisor = CLOCKS_PER_SEC/$64
    .label quotient_hi = $17
    .label quotient_lo = $11
    .label return = $13
    .label dividend = 7
    lda.z dividend+2
    sta.z divr16u.dividend
    lda.z dividend+3
    sta.z divr16u.dividend+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    lda.z divr16u.return
    sta.z quotient_hi
    lda.z divr16u.return+1
    sta.z quotient_hi+1
    lda.z dividend
    sta.z divr16u.dividend
    lda.z dividend+1
    sta.z divr16u.dividend+1
    jsr divr16u
    lda.z quotient_hi
    sta.z return+2
    lda.z quotient_hi+1
    sta.z return+3
    lda.z quotient_lo
    sta.z return
    lda.z quotient_lo+1
    sta.z return+1
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($f) dividend, word zeropage($d) rem)
divr16u: {
    .label rem = $d
    .label dividend = $f
    .label quotient = $11
    .label return = $11
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
  b1:
    asl.z rem
    rol.z rem+1
    lda.z dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora.z rem
    sta.z rem
  b2:
    asl.z dividend
    rol.z dividend+1
    asl.z quotient
    rol.z quotient+1
    lda.z rem+1
    cmp #>div32u16u.divisor
    bcc b3
    bne !+
    lda.z rem
    cmp #<div32u16u.divisor
    bcc b3
  !:
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    lda.z rem
    sec
    sbc #<div32u16u.divisor
    sta.z rem
    lda.z rem+1
    sbc #>div32u16u.divisor
    sta.z rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    .label return = 7
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
    rts
}
// Reset & start the processor clock time. The value can be read using clock().
// This uses CIA #2 Timer A+B on the C64
clock_start: {
    // Setup CIA#2 timer A to count (down) CPU cycles
    lda #CIA_TIMER_CONTROL_CONTINUOUS
    sta CIA2_TIMER_A_CONTROL
    lda #CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2_TIMER_B_CONTROL
    lda #<$ffffffff
    sta CIA2_TIMER_AB
    lda #>$ffffffff
    sta CIA2_TIMER_AB+1
    lda #<$ffffffff>>$10
    sta CIA2_TIMER_AB+2
    lda #>$ffffffff>>$10
    sta CIA2_TIMER_AB+3
    lda #CIA_TIMER_CONTROL_START|CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2_TIMER_B_CONTROL
    lda #CIA_TIMER_CONTROL_START
    sta CIA2_TIMER_A_CONTROL
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($11) str, byte register(X) c, word zeropage($f) num)
memset: {
    .label end = $f
    .label dst = $11
    .label num = $f
    .label str = $11
    lda.z num
    bne !+
    lda.z num+1
    beq breturn
  !:
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  b2:
    lda.z dst+1
    cmp.z end+1
    bne b3
    lda.z dst
    cmp.z end
    bne b3
  breturn:
    rts
  b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp b2
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
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
    rts
}
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // Digits used for storing the decimal word
  decimal_digits: .fill 6, 0
  // Digits used for storing the decimal word
  decimal_digits_long: .fill $b, 0
