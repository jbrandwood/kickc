// Tests printf function call rewriting
// Print a bunch of different stuff using printf
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
  .label printf_line_cursor = $12
  .label printf_char_cursor = $14
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
    .label sc = -$c
    .label uc = $22
    .label si = -$4d2
    .const ui = $162e
    .label sl = -$1e240
    .label ul = $8aa52
    .label c = $16
    // printf_cls()
    jsr printf_cls
    // c = 'x'
    lda #'x'
    sta.z c
    // printf("A char: %c\n", c)
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A char: %c\n", c)
    lda.z c
    jsr printf_char
    // printf("A char: %c\n", c)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A pointer: %p\n", &c)
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A pointer: %p\n", &c)
    ldx #HEXADECIMAL
    lda #<c
    sta.z printf_uint.uvalue
    lda #>c
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("A pointer: %p\n", &c)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A percent: %%\n")
    lda #<str4
    sta.z printf_str.str
    lda #>str4
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A percent: %%\n")
    lda #'%'
    jsr printf_char
    // printf("A percent: %%\n")
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A signed char: %hhd\n", sc)
    lda #<str6
    sta.z printf_str.str
    lda #>str6
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A signed char: %hhd\n", sc)
    jsr printf_schar
    // printf("A signed char: %hhd\n", sc)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("An unsigned char: %hhu\n", uc)
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // printf("An unsigned char: %hhu\n", uc)
    jsr printf_uchar
    // printf("An unsigned char: %hhu\n", uc)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A signed int: %d\n", si)
    lda #<str10
    sta.z printf_str.str
    lda #>str10
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A signed int: %d\n", si)
    jsr printf_sint
    // printf("A signed int: %d\n", si)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("An unsigned int: %u\n", ui)
    lda #<str12
    sta.z printf_str.str
    lda #>str12
    sta.z printf_str.str+1
    jsr printf_str
    // printf("An unsigned int: %u\n", ui)
    ldx #DECIMAL
    lda #<ui
    sta.z printf_uint.uvalue
    lda #>ui
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("An unsigned int: %u\n", ui)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A signed long: %ld\n", sl)
    lda #<str14
    sta.z printf_str.str
    lda #>str14
    sta.z printf_str.str+1
    jsr printf_str
    // printf("A signed long: %ld\n", sl)
    jsr printf_slong
    // printf("A signed long: %ld\n", sl)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("An unsigned long: %lu\n", ul)
    lda #<str16
    sta.z printf_str.str
    lda #>str16
    sta.z printf_str.str+1
    jsr printf_str
    // printf("An unsigned long: %lu\n", ul)
    jsr printf_ulong
    // printf("An unsigned long: %lu\n", ul)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
    str: .text "A char: "
    .byte 0
    str1: .text @"\n"
    .byte 0
    str2: .text "A pointer: "
    .byte 0
    str4: .text "A percent: "
    .byte 0
    str6: .text "A signed char: "
    .byte 0
    str8: .text "An unsigned char: "
    .byte 0
    str10: .text "A signed int: "
    .byte 0
    str12: .text "An unsigned int: "
    .byte 0
    str14: .text "A signed long: "
    .byte 0
    str16: .text "An unsigned long: "
    .byte 0
}
// Print a zero-terminated string
// Handles escape codes such as newline
// printf_str(byte* zp($10) str)
printf_str: {
    .label str = $10
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
    .label __8 = $14
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
// memset(void* zp($b) str, byte register(X) c, word zp(8) num)
memset: {
    .label end = 8
    .label dst = $b
    .label num = 8
    .label str = $b
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
    .label dst = $b
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
// Print an unsigned int using a specific format
printf_ulong: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z ultoa.buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z ultoa.buffer+1
    lda #<main.ul
    sta.z ultoa.value
    lda #>main.ul
    sta.z ultoa.value+1
    lda #<main.ul>>$10
    sta.z ultoa.value+2
    lda #>main.ul>>$10
    sta.z ultoa.value+3
    jsr ultoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    ldx #format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($d) buffer_sign, byte* zp($10) buffer_digits, byte register(X) format_min_length, byte zp(3) format_justify_left, byte zp($a) format_zero_padding)
printf_number_buffer: {
    .label __18 = $b
    .label buffer_sign = $d
    .label padding = $e
    .label format_justify_left = 3
    .label format_zero_padding = $a
    .label buffer_digits = $10
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
// printf_padding(byte zp($1d) pad, byte zp($f) length)
printf_padding: {
    .label i = 2
    .label length = $f
    .label pad = $1d
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
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp(8) str)
strlen: {
    .label len = $b
    .label str = 8
    .label return = $b
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
// ultoa(dword zp(4) value, byte* zp($10) buffer)
ultoa: {
    .label digit_value = $17
    .label buffer = $10
    .label digit = 3
    .label value = 4
    ldx #0
    txa
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #$a-1
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
// ultoa_append(byte* zp($10) buffer, dword zp(4) value, dword zp($17) sub)
ultoa_append: {
    .label buffer = $10
    .label value = 4
    .label sub = $17
    .label return = 4
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
// Print a signed long using a specific format
printf_slong: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const value = -main.sl
    // Format number into buffer
    .const uvalue = value
    // printf_buffer.sign = 0
    // Handle any sign
    lda #0
    sta printf_buffer
    // printf_buffer.sign = '-'
    lda #'-'
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z ultoa.buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z ultoa.buffer+1
    lda #<uvalue
    sta.z ultoa.value
    lda #>uvalue
    sta.z ultoa.value+1
    lda #<uvalue>>$10
    sta.z ultoa.value+2
    lda #>uvalue>>$10
    sta.z ultoa.value+3
    jsr ultoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    ldx #format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Print an unsigned int using a specific format
// printf_uint(word zp(8) uvalue, byte register(X) format_radix)
printf_uint: {
    .label uvalue = 8
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z utoa.buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z utoa.buffer+1
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
    sta.z printf_number_buffer.format_justify_left
    tax
    jsr printf_number_buffer
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(8) value, byte* zp($10) buffer, byte register(X) radix)
utoa: {
    .label buffer = $10
    .label digit_value = $1b
    .label digit = $d
    .label value = 8
    .label max_digits = $a
    .label digit_values = $b
    // if(radix==DECIMAL)
    cpx #DECIMAL
    beq __b2
    // if(radix==HEXADECIMAL)
    cpx #HEXADECIMAL
    beq __b3
    // if(radix==OCTAL)
    cpx #OCTAL
    beq __b4
    // if(radix==BINARY)
    cpx #BINARY
    beq __b5
    // *buffer++ = 'e'
    // Unknown radix
    lda #'e'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'e';
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer++ = 'r'
    lda #'r'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'r';
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer++ = 'r'
    lda #'r'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'r';
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
    lda #<RADIX_DECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES
    sta.z digit_values+1
    lda #5
    sta.z max_digits
    jmp __b1
  __b3:
    lda #<RADIX_HEXADECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES
    sta.z digit_values+1
    lda #4
    sta.z max_digits
    jmp __b1
  __b4:
    lda #<RADIX_OCTAL_VALUES
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES
    sta.z digit_values+1
    lda #6
    sta.z max_digits
    jmp __b1
  __b5:
    lda #<RADIX_BINARY_VALUES
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES
    sta.z digit_values+1
    lda #$10
    sta.z max_digits
  __b1:
    ldx #0
    txa
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
    rts
  __b7:
    // digit_value = digit_values[digit]
    lda.z digit
    asl
    tay
    lda (digit_values),y
    sta.z digit_value
    iny
    lda (digit_values),y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    cpx #0
    bne __b10
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b10
  !:
    bcc __b10
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b6
  __b10:
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
// utoa_append(byte* zp($10) buffer, word zp(8) value, word zp($1b) sub)
utoa_append: {
    .label buffer = $10
    .label value = 8
    .label sub = $1b
    .label return = 8
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
// Print a signed integer using a specific format
printf_sint: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const value = -main.si
    // Format number into buffer
    .const uvalue = value
    // printf_buffer.sign = 0
    // Handle any sign
    lda #0
    sta printf_buffer
    // printf_buffer.sign = '-'
    lda #'-'
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z utoa.buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z utoa.buffer+1
    lda #<uvalue
    sta.z utoa.value
    lda #>uvalue
    sta.z utoa.value+1
    ldx #DECIMAL
    jsr utoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    ldx #format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Print an unsigned char using a specific format
printf_uchar: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z uctoa.buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z uctoa.buffer+1
    ldx #main.uc
    jsr uctoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    ldx #format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($10) buffer)
uctoa: {
    .label digit_value = $1d
    .label buffer = $10
    .label digit = $e
    .label started = $f
    lda #0
    sta.z started
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #3-1
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
// uctoa_append(byte* zp($10) buffer, byte register(X) value, byte zp($1d) sub)
uctoa_append: {
    .label buffer = $10
    .label sub = $1d
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
// Print a signed char using a specific format
printf_schar: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const value = -main.sc
    // Format number into buffer
    .const uvalue = value
    // printf_buffer.sign = 0
    // Handle any sign
    lda #0
    sta printf_buffer
    // printf_buffer.sign = '-'
    lda #'-'
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z uctoa.buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z uctoa.buffer+1
    ldx #uvalue
    jsr uctoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    ldx #format_min_length
    jsr printf_number_buffer
    // }
    rts
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
  // Values of binary digits
  RADIX_BINARY_VALUES: .word $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES: .word $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
