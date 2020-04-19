// Tests printf implementation
// Format a number
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .label printf_screen = $400
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .label printf_line_cursor = $e
  .label printf_char_cursor = $10
__bbegin:
  // printf_line_cursor = PRINTF_SCREEN_ADDRESS
  lda #<$400
  sta.z printf_line_cursor
  lda #>$400
  sta.z printf_line_cursor+1
  // printf_char_cursor = PRINTF_SCREEN_ADDRESS
  lda #<$400
  sta.z printf_char_cursor
  lda #>$400
  sta.z printf_char_cursor+1
  jsr main
  rts
main: {
    // printf_cls()
    jsr printf_cls
    // printf_schar(-77, format)
    lda #0
    sta.z printf_schar.format_zero_padding
    lda #DECIMAL
    sta.z printf_schar.format_radix
    ldy #0
    ldx #-$4d
    jsr printf_schar
    // printf_ln()
    jsr printf_ln
    // printf_schar(99, format)
    lda #1
    sta.z printf_schar.format_zero_padding
    lda #OCTAL
    sta.z printf_schar.format_radix
    ldy #1
    ldx #$63
    jsr printf_schar
    // printf_ln()
    jsr printf_ln
    // printf_uint(3456, format)
    jsr printf_uint
    // printf_ln()
    jsr printf_ln
    // }
    rts
}
// Print a newline
printf_ln: {
  __b1:
    // printf_line_cursor +=  PRINTF_SCREEN_WIDTH
    lda #$28
    clc
    adc.z printf_line_cursor
    sta.z printf_line_cursor
    bcc !+
    inc.z printf_line_cursor+1
  !:
    // while (printf_line_cursor<printf_char_cursor)
    lda.z printf_line_cursor+1
    cmp.z printf_char_cursor+1
    bcc __b1
    bne !+
    lda.z printf_line_cursor
    cmp.z printf_char_cursor
    bcc __b1
  !:
    // printf_char_cursor = printf_line_cursor
    lda.z printf_line_cursor
    sta.z printf_char_cursor
    lda.z printf_line_cursor+1
    sta.z printf_char_cursor+1
    // }
    rts
}
// Print an unsigned int using a specific format
printf_uint: {
    .label uvalue = $d80
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr utoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #0
    sta.z printf_number_buffer.format_zero_padding
    lda #1
    sta.z printf_number_buffer.format_justify_left
    ldx #$a
    jsr printf_number_buffer
    // }
    rts
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp(8) buffer_sign, byte* zp(4) buffer_digits, byte register(X) format_min_length, byte zp(3) format_justify_left, byte zp(2) format_zero_padding)
printf_number_buffer: {
    .label __18 = $a
    .label buffer_sign = 8
    .label format_zero_padding = 2
    .label padding = 9
    .label format_justify_left = 3
    .label buffer_digits = 4
    // if(format.min_length)
    cpx #0
    beq __b5
    // strlen(buffer.digits)
    lda.z buffer_digits
    sta.z strlen.str
    lda.z buffer_digits+1
    sta.z strlen.str+1
    jsr strlen
    // strlen(buffer.digits)
    // len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    lda.z __18
    tay
    // if(buffer.sign)
    lda #0
    cmp.z buffer_sign
    beq __b11
    // len++;
    iny
  __b11:
    // padding = (signed char)format.min_length - len
    txa
    sty.z $ff
    sec
    sbc.z $ff
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
  __b5:
    lda #0
    sta.z padding
  __b1:
    // if(!format.justify_left && !format.zero_padding && padding)
    lda #0
    cmp.z format_justify_left
    bne __b2
    cmp.z format_zero_padding
    bne __b2
    cmp.z padding
    bne __b7
    jmp __b2
  __b7:
    // printf_padding(' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // if(buffer.sign)
    lda #0
    cmp.z buffer_sign
    beq __b3
    // printf_char(buffer.sign)
    lda.z buffer_sign
    jsr printf_char
  __b3:
    // if(format.zero_padding && padding)
    lda #0
    cmp.z format_zero_padding
    beq __b4
    cmp.z padding
    bne __b9
    jmp __b4
  __b9:
    // printf_padding('0',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #'0'
    sta.z printf_padding.pad
    jsr printf_padding
  __b4:
    // printf_str(buffer.digits)
    jsr printf_str
    // if(format.justify_left && !format.zero_padding && padding)
    lda #0
    cmp.z format_justify_left
    beq __breturn
    cmp.z format_zero_padding
    bne __breturn
    cmp.z padding
    bne __b10
    rts
  __b10:
    // printf_padding(' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __breturn:
    // }
    rts
}
// Print a padding char a number of times
// printf_padding(byte zp($d) pad, byte zp($c) length)
printf_padding: {
    .label i = $14
    .label length = $c
    .label pad = $d
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<length; i++)
    lda.z i
    cmp.z length
    bcc __b2
    // }
    rts
  __b2:
    // printf_char(pad)
    lda.z pad
    jsr printf_char
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Print a single char
// If the end of the screen is reached scroll it up one char and place the cursor at the
// printf_char(byte register(A) ch)
printf_char: {
    .label __8 = $10
    // *(printf_char_cursor++) = ch
    ldy #0
    sta (printf_char_cursor),y
    // *(printf_char_cursor++) = ch;
    inc.z printf_char_cursor
    bne !+
    inc.z printf_char_cursor+1
  !:
    // if(printf_char_cursor==printf_screen+PRINTF_SCREEN_BYTES)
    lda.z printf_char_cursor+1
    cmp #>printf_screen+$28*$19
    bne __breturn
    lda.z printf_char_cursor
    cmp #<printf_screen+$28*$19
    bne __breturn
    // memcpy(printf_screen, printf_screen+PRINTF_SCREEN_WIDTH, PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH)
    jsr memcpy
    // memset(printf_screen+PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH, ' ', PRINTF_SCREEN_WIDTH)
    ldx #' '
    lda #<printf_screen+$28*$19-$28
    sta.z memset.str
    lda #>printf_screen+$28*$19-$28
    sta.z memset.str+1
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
    jsr memset
    // printf_char_cursor-PRINTF_SCREEN_WIDTH
    lda.z __8
    sec
    sbc #<$28
    sta.z __8
    lda.z __8+1
    sbc #>$28
    sta.z __8+1
    // printf_char_cursor = printf_char_cursor-PRINTF_SCREEN_WIDTH
    // printf_line_cursor = printf_char_cursor
    lda.z printf_char_cursor
    sta.z printf_line_cursor
    lda.z printf_char_cursor+1
    sta.z printf_line_cursor+1
  __breturn:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($a) str, byte register(X) c, word zp(6) num)
memset: {
    .label end = 6
    .label dst = $a
    .label num = 6
    .label str = $a
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
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
memcpy: {
    .label destination = printf_screen
    .const num = $28*$19-$28
    .label source = printf_screen+$28
    .label src_end = source+num
    .label dst = $a
    .label src = 6
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    lda #<source
    sta.z src
    lda #>source
    sta.z src+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp #>src_end
    bne __b2
    lda.z src
    cmp #<src_end
    bne __b2
    // }
    rts
  __b2:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
// Print a zero-terminated string
// printf_str(byte* zp(4) str)
printf_str: {
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
    // printf_char(*str++)
    ldy #0
    lda (str),y
    jsr printf_char
    // printf_char(*str++);
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp(6) str)
strlen: {
    .label len = $a
    .label str = 6
    .label return = $a
    lda #<0
    sta.z len
    sta.z len+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // len++;
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
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
// utoa(word zp(4) value, byte* zp(6) buffer)
utoa: {
    .const max_digits = 4
    .label digit_value = $12
    .label buffer = 6
    .label digit = 3
    .label value = 4
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    lda #<printf_uint.uvalue
    sta.z value
    lda #>printf_uint.uvalue
    sta.z value+1
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
    // digit_value = digit_values[digit]
    lda.z digit
    asl
    tay
    lda RADIX_HEXADECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_HEXADECIMAL_VALUES+1,y
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
// utoa_append(byte* zp(6) buffer, word zp(4) value, word zp($12) sub)
utoa_append: {
    .label buffer = 6
    .label value = 4
    .label sub = $12
    .label return = 4
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
// Print a signed char using a specific format
// printf_schar(signed byte register(X) value, byte register(Y) format_sign_always, byte zp(2) format_zero_padding, byte zp(8) format_radix)
printf_schar: {
    .label format_radix = 8
    .label format_zero_padding = 2
    // printf_buffer.sign = 0
    // Handle any sign
    lda #0
    sta printf_buffer
    // if(value<0)
    cpx #0
    bmi __b1
    // if(format.sign_always)
    cpy #0
    beq __b2
    // printf_buffer.sign = '+'
    lda #'+'
    sta printf_buffer
  __b2:
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    lda.z format_radix
    jsr uctoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #0
    sta.z printf_number_buffer.format_justify_left
    ldx #6
    jsr printf_number_buffer
    // }
    rts
  __b1:
    // value = -value
    txa
    eor #$ff
    clc
    adc #1
    tax
    // printf_buffer.sign = '-'
    lda #'-'
    sta printf_buffer
    jmp __b2
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($12) buffer, byte register(A) radix)
uctoa: {
    .label buffer = $12
    .label digit = $c
    .label started = $d
    .label max_digits = 9
    .label digit_values = $a
    // if(radix==DECIMAL)
    cmp #DECIMAL
    beq __b2
    // if(radix==HEXADECIMAL)
    cmp #HEXADECIMAL
    beq __b3
    // if(radix==OCTAL)
    cmp #OCTAL
    beq __b4
    // if(radix==BINARY)
    cmp #BINARY
    beq __b5
    // *buffer++ = 'e'
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // }
    rts
  __b2:
    lda #<RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values+1
    lda #3
    sta.z max_digits
    jmp __b1
  __b3:
    lda #<RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values+1
    lda #2
    sta.z max_digits
    jmp __b1
  __b4:
    lda #<RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values+1
    lda #3
    sta.z max_digits
    jmp __b1
  __b5:
    lda #<RADIX_BINARY_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_CHAR
    sta.z digit_values+1
    lda #8
    sta.z max_digits
  __b1:
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    sta.z digit
  __b6:
    // max_digits-1
    lda.z max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    cmp.z digit
    beq !+
    bcs __b7
  !:
    // *buffer++ = DIGITS[(char)value]
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
    rts
  __b7:
    // digit_value = digit_values[digit]
    ldy.z digit
    lda (digit_values),y
    tay
    // if (started || value >= digit_value)
    lda #0
    cmp.z started
    bne __b10
    sty.z $ff
    cpx.z $ff
    bcs __b10
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b6
  __b10:
    // uctoa_append(buffer++, value, digit_value)
    sty.z uctoa_append.sub
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #1
    sta.z started
    jmp __b9
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// uctoa_append(byte* zp($12) buffer, byte register(X) value, byte zp($14) sub)
uctoa_append: {
    .label buffer = $12
    .label sub = $14
    ldy #0
  __b1:
    // while (value >= sub)
    cpx.z sub
    bcs __b2
    // *buffer = DIGITS[digit]
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    iny
    // value -= sub
    txa
    sec
    sbc.z sub
    tax
    jmp __b1
}
// Clear the screen. Also resets current line/char cursor.
printf_cls: {
    // memset(printf_screen, ' ', PRINTF_SCREEN_BYTES)
    ldx #' '
    lda #<printf_screen
    sta.z memset.str
    lda #>printf_screen
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // printf_line_cursor = printf_screen
    lda #<printf_screen
    sta.z printf_line_cursor
    lda #>printf_screen
    sta.z printf_line_cursor+1
    // printf_char_cursor = printf_line_cursor
    lda.z printf_line_cursor
    sta.z printf_char_cursor
    lda.z printf_line_cursor+1
    sta.z printf_char_cursor+1
    // }
    rts
}
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of binary digits
  RADIX_BINARY_VALUES_CHAR: .byte $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES_CHAR: .byte $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
