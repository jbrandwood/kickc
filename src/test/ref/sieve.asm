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
  .label rem16u = $1e
  .label print_char_cursor = $c
  .label print_line_cursor = $15
  .label print_char_cursor_62 = $15
  .label print_char_cursor_99 = $15
main: {
    .label toD0181_gfx = $1800
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>toD0181_gfx)/4&$f
    .label _10 = $18
    .label _14 = $28
    .label cyclecount = $18
    .label sec100s = 6
    .label i = 2
    .label sieve_i = 4
    .label j = 8
    .label s = $a
    .label i_3 = 6
    .label i_10 = 6
    .label _38 = $2c
    //Show lower case font
    lda #toD0181_return
    sta D018
    jsr print_cls
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda #<COUNT
    sta print_word_decimal.w
    lda #>COUNT
    sta print_word_decimal.w+1
    jsr print_word_decimal
    jsr print_ln
    ldx #0
    lda #<sieve
    sta memset.str
    lda #>sieve
    sta memset.str+1
    lda #<COUNT
    sta memset.num
    lda #>COUNT
    sta memset.num+1
    jsr memset
    jsr clock_start
    lda #<sieve+2
    sta sieve_i
    lda #>sieve+2
    sta sieve_i+1
    lda #<2
    sta i
    lda #>2
    sta i+1
  b1:
    lda i+1
    cmp #>SQRT_COUNT
    bcs !b2+
    jmp b2
  !b2:
    bne !+
    lda i
    cmp #<SQRT_COUNT
    bcs !b2+
    jmp b2
  !b2:
  !:
    jsr clock
    lda cyclecount
    sec
    sbc #<CLOCKS_PER_INIT
    sta cyclecount
    lda cyclecount+1
    sbc #>CLOCKS_PER_INIT
    sta cyclecount+1
    lda cyclecount+2
    sbc #<CLOCKS_PER_INIT>>$10
    sta cyclecount+2
    lda cyclecount+3
    sbc #>CLOCKS_PER_INIT>>$10
    sta cyclecount+3
    jsr div32u16u
    lda _14
    sta sec100s
    lda _14+1
    sta sec100s+1
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    jsr print_word_decimal
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    jsr print_dword_decimal
    jsr print_ln
    lda #<2
    sta i_10
    lda #>2
    sta i_10+1
  b8:
    lda i_10
    clc
    adc #<sieve
    sta _38
    lda i_10+1
    adc #>sieve
    sta _38+1
    ldy #0
    lda (_38),y
    cmp #0
    bne b29
    lda print_char_cursor_62
    sta print_char_cursor
    lda print_char_cursor_62+1
    sta print_char_cursor+1
    jsr print_word_decimal
    jsr print_char
  b9:
    inc i_3
    bne !+
    inc i_3+1
  !:
    lda i_3+1
    cmp #>$514
    bcc b28
    bne !+
    lda i_3
    cmp #<$514
    bcc b28
  !:
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
  b12:
    inc SCREEN+$3e7
    jmp b12
  b28:
    lda print_char_cursor
    sta print_char_cursor_99
    lda print_char_cursor+1
    sta print_char_cursor_99+1
    jmp b8
  b29:
    lda print_char_cursor_62
    sta print_char_cursor
    lda print_char_cursor_62+1
    sta print_char_cursor+1
    jmp b9
  b2:
    ldy #0
    lda (sieve_i),y
    cmp #0
    bne b4
    lda i
    asl
    sta j
    lda i+1
    rol
    sta j+1
    lda j
    clc
    adc #<sieve
    sta s
    lda j+1
    adc #>sieve
    sta s+1
  b5:
    lda j+1
    cmp #>COUNT
    bcc b6
    bne !+
    lda j
    cmp #<COUNT
    bcc b6
  !:
  b4:
    inc i
    bne !+
    inc i+1
  !:
    inc sieve_i
    bne !+
    inc sieve_i+1
  !:
    jmp b1
  b6:
    lda #1
    ldy #0
    sta (s),y
    lda s
    clc
    adc i
    sta s
    lda s+1
    adc i+1
    sta s+1
    lda j
    clc
    adc i
    sta j
    lda j+1
    adc i+1
    sta j+1
    jmp b5
    str: .text "Sieve benchmark - calculating primes@"
    str1: .text "between 2 and @"
    str2: .text "100ths seconds used: @"
    str3: .text " cycles: @"
    str4: .text "...@"
}
// Print a zero-terminated string
// print_str(byte* zeropage($e) str)
print_str: {
    .label str = $e
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
// Print a single char
print_char: {
    .const ch = ' '
    lda #ch
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// Print a word as DECIMAL
// print_word_decimal(word zeropage(6) w)
print_word_decimal: {
    .label w = 6
    lda w
    sta utoa.value
    lda w+1
    sta utoa.value+1
    jsr utoa
    lda #<decimal_digits
    sta print_str.str
    lda #>decimal_digits
    sta print_str.str+1
    jsr print_str
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zeropage($11) value, byte* zeropage($13) buffer)
utoa: {
    .const max_digits = 5
    .label digit_value = $2e
    .label digit = $10
    .label value = $11
    .label buffer = $13
    lda #<decimal_digits
    sta buffer
    lda #>decimal_digits
    sta buffer+1
    ldx #0
    txa
    sta digit
  b1:
    lda digit
    asl
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta digit_value+1
    cpx #0
    bne b3
    cmp value+1
    bne !+
    lda digit_value
    cmp value
    beq b3
  !:
    bcc b3
  b2:
    inc digit
    lda digit
    cmp #max_digits-1
    bcc b1
    lda value
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    inc buffer
    bne !+
    inc buffer+1
  !:
    lda #0
    tay
    sta (buffer),y
    rts
  b3:
    jsr utoa_append
    inc buffer
    bne !+
    inc buffer+1
  !:
    ldx #1
    jmp b2
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zeropage($13) buffer, word zeropage($11) value, word zeropage($2e) sub)
utoa_append: {
    .label buffer = $13
    .label value = $11
    .label sub = $2e
    .label return = $11
    ldx #0
  b1:
    lda sub+1
    cmp value+1
    bne !+
    lda sub
    cmp value
    beq b2
  !:
    bcc b2
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    rts
  b2:
    inx
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    jmp b1
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
  !:
    rts
}
// Print a dword as DECIMAL
// print_dword_decimal(dword zeropage($18) w)
print_dword_decimal: {
    .label w = $18
    jsr ultoa
    lda #<decimal_digits_long
    sta print_str.str
    lda #>decimal_digits_long
    sta print_str.str+1
    jsr print_str
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zeropage($18) value, byte* zeropage($1c) buffer)
ultoa: {
    .const max_digits = $a
    .label digit_value = $30
    .label digit = $17
    .label value = $18
    .label buffer = $1c
    lda #<decimal_digits_long
    sta buffer
    lda #>decimal_digits_long
    sta buffer+1
    ldx #0
    txa
    sta digit
  b1:
    lda digit
    asl
    asl
    tay
    lda RADIX_DECIMAL_VALUES_LONG,y
    sta digit_value
    lda RADIX_DECIMAL_VALUES_LONG+1,y
    sta digit_value+1
    lda RADIX_DECIMAL_VALUES_LONG+2,y
    sta digit_value+2
    lda RADIX_DECIMAL_VALUES_LONG+3,y
    sta digit_value+3
    cpx #0
    bne b3
    lda value+3
    cmp digit_value+3
    bcc !+
    bne b3
    lda value+2
    cmp digit_value+2
    bcc !+
    bne b3
    lda value+1
    cmp digit_value+1
    bcc !+
    bne b3
    lda value
    cmp digit_value
    bcs b3
  !:
  b2:
    inc digit
    lda digit
    cmp #max_digits-1
    bcc b1
    lda value
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    inc buffer
    bne !+
    inc buffer+1
  !:
    lda #0
    tay
    sta (buffer),y
    rts
  b3:
    jsr ultoa_append
    inc buffer
    bne !+
    inc buffer+1
  !:
    ldx #1
    jmp b2
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// ultoa_append(byte* zeropage($1c) buffer, dword zeropage($18) value, dword zeropage($30) sub)
ultoa_append: {
    .label buffer = $1c
    .label value = $18
    .label sub = $30
    .label return = $18
    ldx #0
  b1:
    lda value+3
    cmp sub+3
    bcc !+
    bne b2
    lda value+2
    cmp sub+2
    bcc !+
    bne b2
    lda value+1
    cmp sub+1
    bcc !+
    bne b2
    lda value
    cmp sub
    bcs b2
  !:
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    rts
  b2:
    inx
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    lda value+2
    sbc sub+2
    sta value+2
    lda value+3
    sbc sub+3
    sta value+3
    jmp b1
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
// div32u16u(dword zeropage($18) dividend)
div32u16u: {
    .label divisor = CLOCKS_PER_SEC/$64
    .label quotient_hi = $34
    .label quotient_lo = $22
    .label return = $28
    .label dividend = $18
    lda dividend+2
    sta divr16u.dividend
    lda dividend+3
    sta divr16u.dividend+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    lda divr16u.return
    sta quotient_hi
    lda divr16u.return+1
    sta quotient_hi+1
    lda dividend
    sta divr16u.dividend
    lda dividend+1
    sta divr16u.dividend+1
    jsr divr16u
    lda quotient_hi
    sta return+2
    lda quotient_hi+1
    sta return+3
    lda quotient_lo
    sta return
    lda quotient_lo+1
    sta return+1
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($20) dividend, word zeropage($1e) rem)
divr16u: {
    .label rem = $1e
    .label dividend = $20
    .label quotient = $22
    .label return = $22
    ldx #0
    txa
    sta quotient
    sta quotient+1
  b1:
    asl rem
    rol rem+1
    lda dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora rem
    sta rem
  b2:
    asl dividend
    rol dividend+1
    asl quotient
    rol quotient+1
    lda rem+1
    cmp #>div32u16u.divisor
    bcc b3
    bne !+
    lda rem
    cmp #<div32u16u.divisor
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc #<div32u16u.divisor
    sta rem
    lda rem+1
    sbc #>div32u16u.divisor
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    .label return = $18
    lda #<$ffffffff
    sec
    sbc CIA2_TIMER_AB
    sta return
    lda #>$ffffffff
    sbc CIA2_TIMER_AB+1
    sta return+1
    lda #<$ffffffff>>$10
    sbc CIA2_TIMER_AB+2
    sta return+2
    lda #>$ffffffff>>$10
    sbc CIA2_TIMER_AB+3
    sta return+3
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
// memset(void* zeropage($26) str, byte register(X) c, word zeropage($24) num)
memset: {
    .label end = $24
    .label dst = $26
    .label num = $24
    .label str = $26
    lda num
    bne !+
    lda num+1
    beq breturn
  !:
    lda end
    clc
    adc str
    sta end
    lda end+1
    adc str+1
    sta end+1
  b2:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp end+1
    bne b2
    lda dst
    cmp end
    bne b2
  breturn:
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    ldx #' '
    lda #<$400
    sta memset.str
    lda #>$400
    sta memset.str+1
    lda #<$3e8
    sta memset.num
    lda #>$3e8
    sta memset.num+1
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
