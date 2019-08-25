// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const jesper_id = $1b244
  .const henry_id = $4466d
  .label print_char_cursor = $a
  .label print_line_cursor = 8
main: {
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<jesper_initials
    sta.z print_person.person_initials
    lda #>jesper_initials
    sta.z print_person.person_initials+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<jesper_id
    sta.z print_person.person_id
    lda #>jesper_id
    sta.z print_person.person_id+1
    lda #<jesper_id>>$10
    sta.z print_person.person_id+2
    lda #>jesper_id>>$10
    sta.z print_person.person_id+3
    jsr print_person
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<henry_initials
    sta.z print_person.person_initials
    lda #>henry_initials
    sta.z print_person.person_initials+1
    lda #<henry_id
    sta.z print_person.person_id
    lda #>henry_id
    sta.z print_person.person_id+1
    lda #<henry_id>>$10
    sta.z print_person.person_id+2
    lda #>henry_id>>$10
    sta.z print_person.person_id+3
    jsr print_person
    rts
}
// print_person(dword zeropage(2) person_id, byte[2] zeropage(6) person_initials)
print_person: {
    .label person_id = 2
    .label person_initials = 6
    jsr print_dword_decimal
    jsr print_char
    lda.z person_initials
    sta.z print_str.str
    lda.z person_initials+1
    sta.z print_str.str+1
    jsr print_str
    jsr print_ln
    rts
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
// Print a dword as DECIMAL
// print_dword_decimal(dword zeropage(2) w)
print_dword_decimal: {
    .label w = 2
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
// ultoa(dword zeropage(2) value, byte* zeropage($d) buffer)
ultoa: {
    .const max_digits = $a
    .label digit_value = $f
    .label buffer = $d
    .label digit = $c
    .label value = 2
    lda #<decimal_digits_long
    sta.z buffer
    lda #>decimal_digits_long
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  b1:
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
    jmp b1
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
// ultoa_append(byte* zeropage($d) buffer, dword zeropage(2) value, dword zeropage($f) sub)
ultoa_append: {
    .label buffer = $d
    .label value = 2
    .label sub = $f
    .label return = 2
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
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // Digits used for storing the decimal word
  decimal_digits_long: .fill $b, 0
  jesper_initials: .text "jg"
  .byte 0
  henry_initials: .text "hg"
  .byte 0
