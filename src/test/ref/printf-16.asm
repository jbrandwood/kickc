// Tests printf function call rewriting
// Test parameter field syntax %2$d
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .label printf_cursor_x = 7
  .label printf_cursor_y = 8
  .label printf_cursor_ptr = 9
__bbegin:
  // printf_cursor_x = 0
  // X-position of cursor
  lda #0
  sta.z printf_cursor_x
  // printf_cursor_y = 0
  // Y-position of cursor
  sta.z printf_cursor_y
  // printf_cursor_ptr = PRINTF_SCREEN_ADDRESS
  // Pointer to cursor address
  lda #<$400
  sta.z printf_cursor_ptr
  lda #>$400
  sta.z printf_cursor_ptr+1
  jsr main
  rts
main: {
    // printf_cls()
    jsr printf_cls
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<str3
    sta.z printf_str.str
    lda #>str3
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<str4
    sta.z printf_str.str
    lda #>str4
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<str5
    sta.z printf_str.str
    lda #>str5
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<str3
    sta.z printf_str.str
    lda #>str3
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<str4
    sta.z printf_str.str
    lda #>str4
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<str9
    sta.z printf_str.str
    lda #>str9
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<str3
    sta.z printf_str.str
    lda #>str3
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<str12
    sta.z printf_str.str
    lda #>str12
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<str5
    sta.z printf_str.str
    lda #>str5
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<str3
    sta.z printf_str.str
    lda #>str3
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<str12
    sta.z printf_str.str
    lda #>str12
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #'%'
    jsr printf_char
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<str9
    sta.z printf_str.str
    lda #>str9
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<str3
    sta.z printf_str.str
    lda #>str3
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
    str: .text "d "
    .byte 0
    str1: .text "d:     "
    .byte 0
    str2: .text " "
    .byte 0
    str3: .text @"\n"
    .byte 0
    str4: .text "1$d "
    .byte 0
    str5: .text "2$d: "
    .byte 0
    str9: .text "1$d: "
    .byte 0
    str12: .text "2$d "
    .byte 0
}
// Print a zero-terminated string
// Handles escape codes such as newline
// printf_str(byte* zp(2) str)
printf_str: {
    .label str = 2
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
    .label __0 = 9
    .label __1 = 9
    // printf_cursor_ptr - printf_cursor_x
    sec
    lda.z __0
    sbc.z printf_cursor_x
    sta.z __0
    bcs !+
    dec.z __0+1
  !:
    // printf_cursor_ptr - printf_cursor_x + PRINTF_SCREEN_WIDTH
    lda #$28
    clc
    adc.z __1
    sta.z __1
    bcc !+
    inc.z __1+1
  !:
    // printf_cursor_ptr =  printf_cursor_ptr - printf_cursor_x + PRINTF_SCREEN_WIDTH
    // printf_cursor_x = 0
    lda #0
    sta.z printf_cursor_x
    // printf_cursor_y++;
    inc.z printf_cursor_y
    // printf_scroll()
    jsr printf_scroll
    // }
    rts
}
// Scroll the entire screen if the cursor is on the last line
printf_scroll: {
    .label __4 = 9
    // if(printf_cursor_y==PRINTF_SCREEN_HEIGHT)
    lda #$19
    cmp.z printf_cursor_y
    bne __breturn
    // memcpy(PRINTF_SCREEN_ADDRESS, PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_WIDTH, PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH)
    jsr memcpy
    // memset(PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH, ' ', PRINTF_SCREEN_WIDTH)
    ldx #' '
    lda #<$400+$28*$19-$28
    sta.z memset.str
    lda #>$400+$28*$19-$28
    sta.z memset.str+1
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
    jsr memset
    // printf_cursor_ptr-PRINTF_SCREEN_WIDTH
    lda.z __4
    sec
    sbc #<$28
    sta.z __4
    lda.z __4+1
    sbc #>$28
    sta.z __4+1
    // printf_cursor_ptr = printf_cursor_ptr-PRINTF_SCREEN_WIDTH
    // printf_cursor_y--;
    dec.z printf_cursor_y
  __breturn:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($b) str, byte register(X) c, word zp(5) num)
memset: {
    .label end = 5
    .label dst = $b
    .label num = 5
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
    .label destination = $400
    .label source = $400+$28
    .const num = $28*$19-$28
    .label src_end = source+num
    .label dst = $b
    .label src = 5
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
// Print a single char
// If the end of the screen is reached scroll it up one char and place the cursor at the
// printf_char(byte register(A) ch)
printf_char: {
    // *(printf_cursor_ptr++) = ch
    ldy #0
    sta (printf_cursor_ptr),y
    // *(printf_cursor_ptr++) = ch;
    inc.z printf_cursor_ptr
    bne !+
    inc.z printf_cursor_ptr+1
  !:
    // if(++printf_cursor_x==PRINTF_SCREEN_WIDTH)
    inc.z printf_cursor_x
    lda #$28
    cmp.z printf_cursor_x
    bne __breturn
    // printf_cursor_x = 0
    lda #0
    sta.z printf_cursor_x
    // ++printf_cursor_y;
    inc.z printf_cursor_y
    // printf_scroll()
    jsr printf_scroll
  __breturn:
    // }
    rts
}
// Print a signed integer using a specific format
// printf_sint(signed word zp(2) value)
printf_sint: {
    .label value = 2
    // printf_buffer.sign = 0
    // Handle any sign
    lda #0
    sta printf_buffer
    // if(value<0)
    lda.z value+1
    bmi __b1
    jmp __b2
  __b1:
    // value = -value
    sec
    lda #0
    sbc.z value
    sta.z value
    lda #0
    sbc.z value+1
    sta.z value+1
    // printf_buffer.sign = '-'
    lda #'-'
    sta printf_buffer
  __b2:
    // utoa(uvalue, printf_buffer.digits, format.radix)
    jsr utoa
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
// utoa(word zp(2) value, byte* zp(5) buffer)
utoa: {
    .label digit_value = $b
    .label buffer = 5
    .label digit = 4
    .label value = 2
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #5-1
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
// utoa_append(byte* zp(5) buffer, word zp(2) value, word zp($b) sub)
utoa_append: {
    .label buffer = 5
    .label value = 2
    .label sub = $b
    .label return = 2
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
// Clear the screen. Also resets current line/char cursor.
printf_cls: {
    // memset(PRINTF_SCREEN_ADDRESS, ' ', PRINTF_SCREEN_BYTES)
    ldx #' '
    lda #<$400
    sta.z memset.str
    lda #>$400
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // printf_cursor_ptr = PRINTF_SCREEN_ADDRESS
    lda #<$400
    sta.z printf_cursor_ptr
    lda #>$400
    sta.z printf_cursor_ptr+1
    // printf_cursor_x = 0
    lda #0
    sta.z printf_cursor_x
    // printf_cursor_y = 0
    sta.z printf_cursor_y
    // }
    rts
}
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
