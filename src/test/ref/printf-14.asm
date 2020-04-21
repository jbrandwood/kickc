// Tests printf function call rewriting
// Print a char using %d
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .label printf_screen = $400
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .label printf_line_cursor = 8
  .label printf_char_cursor = $a
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
    .label c = 7
    // printf_cls()
    jsr printf_cls
    // printf("%hhu", c)
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%hhu", c)
    jsr printf_uchar
    // printf("%hhu", c)
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
    str: .text ""
    .byte 0
}
// Print a zero-terminated string
// Handles escape codes such as newline
// printf_str(byte* zp(6) str)
printf_str: {
    .label str = 6
  __b2:
    // ch = *str++
    ldy #0
    lda (str),y
    inc.z str
    bne !+
    inc.z str+1
  !:
    // if(ch==0)
    cmp #0
    bne __b3
    // }
    rts
  __b3:
    // if(ch=='\n')
    cmp #'\n'
    beq __b4
    // printf_char(ch)
    jsr printf_char
    jmp __b2
  __b4:
    // printf_ln()
    jsr printf_ln
    jmp __b2
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
// Print a single char
// If the end of the screen is reached scroll it up one char and place the cursor at the
// printf_char(byte register(A) ch)
printf_char: {
    .label __8 = $a
    // *(printf_char_cursor++) = ch
    ldy #0
    sta (printf_char_cursor),y
    // *(printf_char_cursor++) = ch;
    inc.z printf_char_cursor
    bne !+
    inc.z printf_char_cursor+1
  !:
    // if(printf_char_cursor>=(printf_screen+PRINTF_SCREEN_BYTES))
    lda.z printf_char_cursor+1
    cmp #>printf_screen+$28*$19
    bcc __breturn
    bne !+
    lda.z printf_char_cursor
    cmp #<printf_screen+$28*$19
    bcc __breturn
  !:
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
// memset(void* zp(2) str, byte register(X) c, word zp(8) num)
memset: {
    .label end = 8
    .label dst = 2
    .label num = 8
    .label str = 2
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
    .label dst = 2
    .label src = 8
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
// Print an unsigned char using a specific format
printf_uchar: {
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr uctoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte register(A) buffer_sign)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // if(buffer.sign)
    cmp #0
    beq __b2
    // printf_char(buffer.sign)
    jsr printf_char
  __b2:
    // printf_str(buffer.digits)
    lda #<buffer_digits
    sta.z printf_str.str
    lda #>buffer_digits
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp(6) buffer)
uctoa: {
    .const max_digits = 3
    .label digit_value = $c
    .label buffer = 6
    .label digit = 4
    .label started = 5
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    ldx #main.c
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #max_digits-1
    bcc __b2
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
    // }
    rts
  __b2:
    // digit_value = digit_values[digit]
    ldy.z digit
    lda RADIX_DECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    lda #0
    cmp.z started
    bne __b5
    cpx.z digit_value
    bcs __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // uctoa_append(buffer++, value, digit_value)
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
// uctoa_append(byte* zp(6) buffer, byte register(X) value, byte zp($c) sub)
uctoa_append: {
    .label buffer = 6
    .label sub = $c
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
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
