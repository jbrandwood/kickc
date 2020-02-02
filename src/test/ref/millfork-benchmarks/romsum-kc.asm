.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label rom = $e000
  .label print_char_cursor = 9
  .label print_line_cursor = 2
  .label last_time = $b
  .label rand_seed = $d
  .label Ticks = $f
  .label Ticks_1 = $11
__b1:
  lda #<0
  sta.z last_time
  sta.z last_time+1
  sta.z rand_seed
  sta.z rand_seed+1
  jsr main
  rts
main: {
    .label i = $f
    jsr start
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    lda.z i+1
    cmp #>6
    bcc __b2
    bne !+
    lda.z i
    cmp #<6
    bcc __b2
  !:
    jsr end
    rts
  __b2:
    jsr sum
    jsr print_word_decimal
    jsr print_ln
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
}
// Print a newline
print_ln: {
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// Print a word as DECIMAL
// print_word_decimal(word zp(5) w)
print_word_decimal: {
    .label w = 5
    jsr utoa
    jsr print_str
    rts
}
// Print a zero-terminated string
// print_str(byte* zp(5) str)
print_str: {
    .label str = 5
    lda #<decimal_digits
    sta.z str
    lda #>decimal_digits
    sta.z str+1
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
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
    jmp __b1
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(5) value, byte* zp(7) buffer)
utoa: {
    .const max_digits = 5
    .label digit_value = $11
    .label buffer = 7
    .label digit = 4
    .label value = 5
    lda #<decimal_digits
    sta.z buffer
    lda #>decimal_digits
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b1:
    lda.z digit
    cmp #max_digits-1
    bcc __b2
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
  __b2:
    lda.z digit
    asl
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
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
    inc.z digit
    jmp __b1
  __b5:
    jsr utoa_append
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
// utoa_append(byte* zp(7) buffer, word zp(5) value, word zp($11) sub)
utoa_append: {
    .label buffer = 7
    .label value = 5
    .label sub = $11
    .label return = 5
    ldx #0
  __b1:
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    rts
  __b2:
    inx
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    jmp __b1
}
sum: {
    .label s = 5
    .label p = 7
    .label return = 5
    lda #<rom
    sta.z p
    lda #>rom
    sta.z p+1
    lda #<0
    sta.z s
    sta.z s+1
    tax
  /* doing it page-by-page is faster than doing just one huge loop */
  __b1:
    cpx #$20
    bcc b1
    rts
  b1:
    ldy #0
  __b2:
    lda (p),y
    clc
    adc.z s
    sta.z s
    bcc !+
    inc.z s+1
  !:
    iny
    cpy #0
    bne __b2
    clc
    lda.z p
    adc #<$100
    sta.z p
    lda.z p+1
    adc #>$100
    sta.z p+1
    inx
    jmp __b1
}
end: {
    lda.z last_time
    sta.z Ticks
    lda.z last_time+1
    sta.z Ticks+1
    jsr start
    lda.z last_time
    sec
    sbc.z Ticks
    sta.z last_time
    lda.z last_time+1
    sbc.z Ticks+1
    sta.z last_time+1
    lda.z last_time
    sta.z Ticks_1
    lda.z last_time+1
    sta.z Ticks_1+1
    jsr print_word
    jsr print_ln
    rts
}
// Print a word as HEX
// print_word(word zp($11) w)
print_word: {
    .label w = $11
    lda.z w+1
    tax
    jsr print_byte
    lda.z w
    tax
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda DIGITS,y
    jsr print_char
    lda #$f
    axs #0
    lda DIGITS,x
    jsr print_char
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
start: {
    .label LAST_TIME = last_time
    jsr $ffde
    sta LAST_TIME
    stx LAST_TIME+1
    lda #<$194a
    sta.z rand_seed
    lda #>$194a
    sta.z rand_seed+1
    rts
}
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Digits used for storing the decimal word
  decimal_digits: .fill 6, 0
