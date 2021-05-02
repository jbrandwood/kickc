// A lightweight library for printing on the C64.
// Printing with this library is done by calling print_ function for each element
  // Commodore 64 PRG executable file
.file [name="multiply-16bit-const.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label print_screen = $400
  .label print_char_cursor = $11
  .label print_line_cursor = 8
  .label print_char_cursor_1 = 8
  .label print_line_cursor_1 = 6
.segment Code
main: {
    .label i = 2
    .label __5 = $b
    .label __6 = $b
    .label __7 = $b
    .label __8 = $b
    .label __9 = $b
    .label __10 = $b
    .label __11 = $b
    // print_cls()
    jsr print_cls
    lda #<print_screen
    sta.z print_char_cursor_1
    lda #>print_screen
    sta.z print_char_cursor_1+1
    lda #<print_screen
    sta.z print_line_cursor_1
    lda #>print_screen
    sta.z print_line_cursor_1+1
    lda #<0
    sta.z i
    sta.z i+1
    lda #<0>>$10
    sta.z i+2
    lda #>0>>$10
    sta.z i+3
  __b1:
    // for(unsigned long i=0;i<3330;i+=333)
    lda.z i+3
    cmp #>$d02>>$10
    bcc __b2
    bne !+
    lda.z i+2
    cmp #<$d02>>$10
    bcc __b2
    bne !+
    lda.z i+1
    cmp #>$d02
    bcc __b2
    bne !+
    lda.z i
    cmp #<$d02
    bcc __b2
  !:
    // }
    rts
  __b2:
    // print_ulong_decimal(i*555)
    lda.z i
    asl
    sta.z __5
    lda.z i+1
    rol
    sta.z __5+1
    lda.z i+2
    rol
    sta.z __5+2
    lda.z i+3
    rol
    sta.z __5+3
    asl.z __5
    rol.z __5+1
    rol.z __5+2
    rol.z __5+3
    asl.z __5
    rol.z __5+1
    rol.z __5+2
    rol.z __5+3
    asl.z __5
    rol.z __5+1
    rol.z __5+2
    rol.z __5+3
    lda.z __6
    clc
    adc.z i
    sta.z __6
    lda.z __6+1
    adc.z i+1
    sta.z __6+1
    lda.z __6+2
    adc.z i+2
    sta.z __6+2
    lda.z __6+3
    adc.z i+3
    sta.z __6+3
    asl.z __7
    rol.z __7+1
    rol.z __7+2
    rol.z __7+3
    asl.z __7
    rol.z __7+1
    rol.z __7+2
    rol.z __7+3
    lda.z __8
    clc
    adc.z i
    sta.z __8
    lda.z __8+1
    adc.z i+1
    sta.z __8+1
    lda.z __8+2
    adc.z i+2
    sta.z __8+2
    lda.z __8+3
    adc.z i+3
    sta.z __8+3
    asl.z __9
    rol.z __9+1
    rol.z __9+2
    rol.z __9+3
    asl.z __9
    rol.z __9+1
    rol.z __9+2
    rol.z __9+3
    lda.z __10
    clc
    adc.z i
    sta.z __10
    lda.z __10+1
    adc.z i+1
    sta.z __10+1
    lda.z __10+2
    adc.z i+2
    sta.z __10+2
    lda.z __10+3
    adc.z i+3
    sta.z __10+3
    asl.z __11
    rol.z __11+1
    rol.z __11+2
    rol.z __11+3
    lda.z print_ulong_decimal.w
    clc
    adc.z i
    sta.z print_ulong_decimal.w
    lda.z print_ulong_decimal.w+1
    adc.z i+1
    sta.z print_ulong_decimal.w+1
    lda.z print_ulong_decimal.w+2
    adc.z i+2
    sta.z print_ulong_decimal.w+2
    lda.z print_ulong_decimal.w+3
    adc.z i+3
    sta.z print_ulong_decimal.w+3
    jsr print_ulong_decimal
    // print_ln()
    jsr print_ln
    // i+=333
    lda.z i
    clc
    adc #<$14d
    sta.z i
    lda.z i+1
    adc #>$14d
    sta.z i+1
    lda.z i+2
    adc #0
    sta.z i+2
    lda.z i+3
    adc #0
    sta.z i+3
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    jmp __b1
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Print a unsigned long as DECIMAL
// print_ulong_decimal(dword zp($b) w)
print_ulong_decimal: {
    .label w = $b
    // ultoa(w, decimal_digits_long, DECIMAL)
    jsr ultoa
    // print_str(decimal_digits_long)
    jsr print_str
    // }
    rts
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor_1
    sta.z print_line_cursor
    lda #0
    adc.z print_line_cursor_1+1
    sta.z print_line_cursor+1
    // while (print_line_cursor<print_char_cursor)
    cmp.z print_char_cursor+1
    bcc __b2
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b2
  !:
    // }
    rts
  __b2:
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = 8
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zp($b) value, byte* zp($f) buffer)
ultoa: {
    .const max_digits = $a
    .label digit_value = $13
    .label buffer = $f
    .label digit = $a
    .label value = $b
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
    // *buffer++ = DIGITS[(char)value]
    lda.z value
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
    // unsigned long digit_value = digit_values[digit]
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
// Print a zero-terminated string
// print_str(byte* zp($f) str)
print_str: {
    .label str = $f
    lda.z print_char_cursor_1
    sta.z print_char_cursor
    lda.z print_char_cursor_1+1
    sta.z print_char_cursor+1
    lda #<decimal_digits_long
    sta.z str
    lda #>decimal_digits_long
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
// ultoa_append(byte* zp($f) buffer, dword zp($b) value, dword zp($13) sub)
ultoa_append: {
    .label buffer = $f
    .label value = $b
    .label sub = $13
    .label return = $b
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
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // Digits used for storing the decimal unsigned int
  decimal_digits_long: .fill $b, 0
