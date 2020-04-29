// N Queens Problem in C Using Backtracking
//
// N Queens Problem is a famous puzzle in which n-queens are to be placed on a nxn chess board such that no two queens are in the same row, column or diagonal.  
//
// This is a recursive solution
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_TIME_OF_DAY_SEC = 1
  .const OFFSET_STRUCT_TIME_OF_DAY_MIN = 2
  .const OFFSET_STRUCT_TIME_OF_DAY_HOURS = 3
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL = $e
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL = $f
  .const OFFSET_STRUCT_MOS6526_CIA_TOD_HOURS = $b
  .const OFFSET_STRUCT_MOS6526_CIA_TOD_MIN = $a
  .const OFFSET_STRUCT_MOS6526_CIA_TOD_SEC = 9
  .const OFFSET_STRUCT_MOS6526_CIA_TOD_10THS = 8
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .label printf_cursor_x = $11
  .label printf_cursor_y = $12
  .label printf_cursor_ptr = $13
  .label count = 2
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
  // count = 0
  // The number of found solutions
  lda #<0
  sta.z count
  sta.z count+1
  lda #<0>>$10
  sta.z count+2
  lda #>0>>$10
  sta.z count+3
  jsr main
  rts
main: {
    // printf_cls()
    jsr printf_cls
    // printf(" - n queens problem using backtracking -")
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\nnumber of queens:%u",QUEENS)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\nnumber of queens:%u",QUEENS)
    jsr printf_uint
    // tod_init(TOD_ZERO)
    lda TOD_ZERO
    sta.z tod_init.tod_TENTHS
    lda TOD_ZERO+OFFSET_STRUCT_TIME_OF_DAY_SEC
    sta.z tod_init.tod_SEC
    lda TOD_ZERO+OFFSET_STRUCT_TIME_OF_DAY_MIN
    sta.z tod_init.tod_MIN
    lda TOD_ZERO+OFFSET_STRUCT_TIME_OF_DAY_HOURS
    sta.z tod_init.tod_HOURS
    jsr tod_init
    // queen(1)
    lda #1
    pha
    jsr queen
    pla
    // tod_read()
    jsr tod_read
    // tod_str(tod_read())
    jsr tod_str
    // printf("\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    jsr printf_ulong
    // printf("\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    lda #<str3
    sta.z printf_str.str
    lda #>str3
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    jsr printf_string
    // printf("\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    lda #<str4
    sta.z printf_str.str
    lda #>str4
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
    str: .text " - n queens problem using backtracking -"
    .byte 0
    str1: .text @"\nnumber of queens:"
    .byte 0
    str2: .text @"\nsolutions: "
    .byte 0
    str3: .text " time: "
    .byte 0
    str4: .text @".\n"
    .byte 0
}
// Print a zero-terminated string
// Handles escape codes such as newline
// printf_str(byte* zp($c) str)
printf_str: {
    .label ch = $f
    .label str = $c
  __b2:
    // ch = *str++
    ldy #0
    lda (str),y
    sta.z ch
    inc.z str
    bne !+
    inc.z str+1
  !:
    // if(ch==0)
    lda.z ch
    cmp #0
    bne __b3
    // }
    rts
  __b3:
    // if(ch=='\n')
    lda #'\n'
    cmp.z ch
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
    .label __0 = $13
    .label __1 = $13
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
    .label __4 = $13
    // if(printf_cursor_y==PRINTF_SCREEN_HEIGHT)
    lda #$19
    cmp.z printf_cursor_y
    bne __breturn
    // memcpy(PRINTF_SCREEN_ADDRESS, PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_WIDTH, PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH)
    jsr memcpy
    // memset(PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH, ' ', PRINTF_SCREEN_WIDTH)
    lda #' '
    sta.z memset.c
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
// memset(void* zp($a) str, byte zp($e) c, word zp($1f) num)
memset: {
    .label end = $1f
    .label dst = $a
    .label num = $1f
    .label str = $a
    .label c = $e
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
    lda.z c
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
    .label dst = $a
    .label src = $1f
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
// printf_char(byte zp($f) ch)
printf_char: {
    .label ch = $f
    // *(printf_cursor_ptr++) = ch
    lda.z ch
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
// Print a string value using a specific format
// Handles justification and min length 
printf_string: {
    // printf_str(str)
    lda #<tod_buffer
    sta.z printf_str.str
    lda #>tod_buffer
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
}
// Print an unsigned int using a specific format
// printf_ulong(dword zp(2) uvalue)
printf_ulong: {
    .label uvalue = 2
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
    lda.z uvalue
    sta.z ultoa.value
    lda.z uvalue+1
    sta.z ultoa.value+1
    lda.z uvalue+2
    sta.z ultoa.value+2
    lda.z uvalue+3
    sta.z ultoa.value+3
  // Format number into buffer
    jsr ultoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_upper_case
    sta.z printf_number_buffer.format_zero_padding
    sta.z printf_number_buffer.format_justify_left
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($16) buffer_sign, byte zp($10) format_min_length, byte zp($24) format_justify_left, byte zp($15) format_zero_padding, byte zp($17) format_upper_case)
printf_number_buffer: {
    .label __19 = $a
    .label buffer_sign = $16
    .label len = $e
    .label padding = $10
    .label format_min_length = $10
    .label format_zero_padding = $15
    .label format_justify_left = $24
    .label format_upper_case = $17
    // if(format.min_length)
    lda #0
    cmp.z format_min_length
    beq __b6
    // strlen(buffer.digits)
    jsr strlen
    // strlen(buffer.digits)
    // len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    lda.z __19
    sta.z len
    // if(buffer.sign)
    lda #0
    cmp.z buffer_sign
    beq __b13
    // len++;
    inc.z len
  __b13:
    // padding = (signed char)format.min_length - len
    lda.z padding
    sec
    sbc.z len
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
  __b6:
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
    bne __b8
    jmp __b2
  __b8:
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
    sta.z printf_char.ch
    jsr printf_char
  __b3:
    // if(format.zero_padding && padding)
    lda #0
    cmp.z format_zero_padding
    beq __b4
    cmp.z padding
    bne __b10
    jmp __b4
  __b10:
    // printf_padding('0',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #'0'
    sta.z printf_padding.pad
    jsr printf_padding
  __b4:
    // if(format.upper_case)
    lda #0
    cmp.z format_upper_case
    beq __b5
    // strupr(buffer.digits)
    jsr strupr
  __b5:
    // printf_str(buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.str+1
    jsr printf_str
    // if(format.justify_left && !format.zero_padding && padding)
    lda #0
    cmp.z format_justify_left
    beq __breturn
    cmp.z format_zero_padding
    bne __breturn
    cmp.z padding
    bne __b12
    rts
  __b12:
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
// printf_padding(byte zp($f) pad, byte zp($18) length)
printf_padding: {
    .label i = $1d
    .label length = $18
    .label pad = $f
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
    jsr printf_char
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Converts a string to uppercase.
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label __0 = $f
    .label src = $c
    lda #<str
    sta.z src
    lda #>str
    sta.z src+1
  __b1:
    // while(*src)
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // toupper(*src)
    ldy #0
    lda (src),y
    sta.z toupper.ch
    jsr toupper
    // *src = toupper(*src)
    lda.z __0
    ldy #0
    sta (src),y
    // src++;
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// toupper(byte zp($f) ch)
toupper: {
    .label return = $f
    .label ch = $f
    // if(ch>='a' && ch<='z')
    lda.z ch
    cmp #'a'
    bcc __breturn
    lda #'z'
    cmp.z ch
    bcs __b1
    rts
  __b1:
    // return ch + ('A'-'a');
    lax.z return
    axs #-['A'-'a']
    stx.z return
  __breturn:
    // }
    rts
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($1f) str)
strlen: {
    .label len = $a
    .label str = $1f
    .label return = $a
    lda #<0
    sta.z len
    sta.z len+1
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
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
// ultoa(dword zp(6) value, byte* zp($1f) buffer)
ultoa: {
    .label __10 = $23
    .label __11 = $18
    .label digit_value = $19
    .label buffer = $1f
    .label digit = $10
    .label value = 6
    .label started = $24
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #$a-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda.z value
    sta.z __11
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
    sta.z __10
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
    lda #0
    cmp.z started
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
// ultoa_append(byte* zp($1f) buffer, dword zp(6) value, dword zp($19) sub)
ultoa_append: {
    .label buffer = $1f
    .label value = 6
    .label sub = $19
    .label return = 6
    .label digit = $15
    lda #0
    sta.z digit
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
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inc.z digit
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
// Convert time of day to a human-readable string "hh:mm:ss:10"
// tod_str(byte zp($15) tod_TENTHS, byte zp($16) tod_SEC, byte zp($17) tod_MIN, byte zp($18) tod_HOURS)
tod_str: {
    .label __0 = $23
    .label __1 = $23
    .label __2 = $18
    .label __3 = $18
    .label __4 = $1d
    .label __5 = $1d
    .label __6 = $17
    .label __7 = $17
    .label __8 = $1e
    .label __9 = $1e
    .label __10 = $16
    .label __11 = $16
    .label __12 = $21
    .label __13 = $21
    .label __14 = $15
    .label __15 = $15
    .label tod_TENTHS = $15
    .label tod_SEC = $16
    .label tod_MIN = $17
    .label tod_HOURS = $18
    // tod.HOURS>>4
    lda.z tod_HOURS
    lsr
    lsr
    lsr
    lsr
    sta.z __0
    // '0'+(tod.HOURS>>4)
    lax.z __1
    axs #-['0']
    stx.z __1
    // tod_buffer[0] = '0'+(tod.HOURS>>4)
    txa
    sta tod_buffer
    // tod.HOURS&0x0f
    lda #$f
    and.z __2
    sta.z __2
    // '0'+(tod.HOURS&0x0f)
    lax.z __3
    axs #-['0']
    stx.z __3
    // tod_buffer[1] = '0'+(tod.HOURS&0x0f)
    txa
    sta tod_buffer+1
    // tod.MIN>>4
    lda.z tod_MIN
    lsr
    lsr
    lsr
    lsr
    sta.z __4
    // '0'+(tod.MIN>>4)
    lax.z __5
    axs #-['0']
    stx.z __5
    // tod_buffer[3] = '0'+(tod.MIN>>4)
    txa
    sta tod_buffer+3
    // tod.MIN&0x0f
    lda #$f
    and.z __6
    sta.z __6
    // '0'+(tod.MIN&0x0f)
    lax.z __7
    axs #-['0']
    stx.z __7
    // tod_buffer[4] = '0'+(tod.MIN&0x0f)
    txa
    sta tod_buffer+4
    // tod.SEC>>4
    lda.z tod_SEC
    lsr
    lsr
    lsr
    lsr
    sta.z __8
    // '0'+(tod.SEC>>4)
    lax.z __9
    axs #-['0']
    stx.z __9
    // tod_buffer[6] = '0'+(tod.SEC>>4)
    txa
    sta tod_buffer+6
    // tod.SEC&0x0f
    lda #$f
    and.z __10
    sta.z __10
    // '0'+(tod.SEC&0x0f)
    lax.z __11
    axs #-['0']
    stx.z __11
    // tod_buffer[7] = '0'+(tod.SEC&0x0f)
    txa
    sta tod_buffer+7
    // tod.TENTHS>>4
    lda.z tod_TENTHS
    lsr
    lsr
    lsr
    lsr
    sta.z __12
    // '0'+(tod.TENTHS>>4)
    lax.z __13
    axs #-['0']
    stx.z __13
    // tod_buffer[9] = '0'+(tod.TENTHS>>4)
    txa
    sta tod_buffer+9
    // tod.TENTHS&0x0f
    lda #$f
    and.z __14
    sta.z __14
    // '0'+(tod.TENTHS&0x0f)
    lax.z __15
    axs #-['0']
    stx.z __15
    // tod_buffer[10] = '0'+(tod.TENTHS&0x0f)
    txa
    sta tod_buffer+$a
    // }
    rts
}
// Read time of day
tod_read: {
    .label return_TENTHS = $15
    .label return_SEC = $16
    .label return_MIN = $17
    .label return_HOURS = $18
    // hours = CIA1->TOD_HOURS
    // Reading sequence is important. TOD latches on reading hours until 10ths is read.
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_HOURS
    sta.z return_HOURS
    // mins = CIA1->TOD_MIN
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_MIN
    sta.z return_MIN
    // secs = CIA1->TOD_SEC
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_SEC
    sta.z return_SEC
    // tenths = CIA1->TOD_10THS
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_10THS
    sta.z return_TENTHS
    // }
    rts
}
// Initialize time-of-day clock
// This uses the MOS6526 CIA#1
// tod_init(byte zp($24) tod_TENTHS, byte zp($15) tod_SEC, byte zp($16) tod_MIN, byte zp($17) tod_HOURS)
tod_init: {
    .label tod_TENTHS = $24
    .label tod_SEC = $15
    .label tod_MIN = $16
    .label tod_HOURS = $17
    // CIA1->TIMER_A_CONTROL |= 0x80
    // Set 50hz (this assumes PAL!) (bit7=1)
    lda #$80
    ora CIA1+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // CIA1->TIMER_B_CONTROL &= 0x7f
    // Writing TOD clock (bit7=0)
    lda #$7f
    and CIA1+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    // CIA1->TOD_HOURS = tod.HOURS
    // Reset TOD clock
    // Writing sequence is important. TOD stops when hours is written and starts when 10ths is written.
    lda.z tod_HOURS
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_HOURS
    // CIA1->TOD_MIN = tod.MIN
    lda.z tod_MIN
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_MIN
    // CIA1->TOD_SEC = tod.SEC
    lda.z tod_SEC
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_SEC
    // CIA1->TOD_10THS = tod.TENTHS
    lda.z tod_TENTHS
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_10THS
    // }
    rts
}
// Print an unsigned int using a specific format
printf_uint: {
    .label uvalue = 8
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
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
    lda #format_upper_case
    sta.z printf_number_buffer.format_upper_case
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    lda #format_min_length
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($a) value, byte* zp($c) buffer)
utoa: {
    .const max_digits = 5
    .label __10 = $1e
    .label __11 = $1d
    .label digit_value = $1f
    .label buffer = $c
    .label digit = $16
    .label value = $a
    .label started = $17
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    lda #<printf_uint.uvalue
    sta.z value
    lda #>printf_uint.uvalue
    sta.z value+1
    lda #0
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda.z value
    sta.z __11
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
    sta.z __10
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    lda #0
    cmp.z started
    bne __b5
    lda.z digit_value+1
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
// utoa_append(byte* zp($c) buffer, word zp($a) value, word zp($1f) sub)
utoa_append: {
    .label buffer = $c
    .label value = $a
    .label sub = $1f
    .label return = $a
    .label digit = $18
    lda #0
    sta.z digit
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
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inc.z digit
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
    lda #' '
    sta.z memset.c
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
// Generates all valid placements of queens on a NxN board recursively
// Works by generating all legal placements af a queen for a specific row taking into consideration the queens already placed on the rows below 
// and then recursively generating all legal placements on the rows above.  
// queen(byte zp($21) row)
queen: {
    .const OFFSET_STACK_ROW = 0
    .label r = $21
    .label column = $22
    .label __1 = $e
    .label __4 = $21
    .label row = $21
    tsx
    lda STACK_BASE+OFFSET_STACK_ROW,x
    sta.z row
    // r = row
    // column=1
    lda #1
    sta.z column
  __b1:
    // for(__ma char column=1;column<=QUEENS;++column)
    lda.z column
    cmp #8+1
    bcc __b2
    // }
    rts
  __b2:
    // legal(r,column)
    jsr legal
    // legal(r,column)
    // if(legal(r,column))
    lda #0
    cmp.z __1
    beq __b3
    // board[r]=column
    //no conflicts so place queen
    lda.z column
    ldy.z r
    sta board,y
    // if(r==QUEENS)
    lda #8
    cmp.z r
    beq __b4
    // asm
    // Perform recussive placement on rows above
    // Push the local vars on the stack (waiting for proper recursion support)
    lda column
    pha
    tya
    pha
    // r+1
    inc.z __4
    // queen(r+1)
    // Do recursion        
    lda.z __4
    pha
    jsr queen
    pla
    // asm
    // Pop the local vars on the stack (waiting for proper recursion support)
    pla
    sta r
    pla
    sta column
  __b3:
    // for(__ma char column=1;column<=QUEENS;++column)
    inc.z column
    jmp __b1
  __b4:
    // count++;
    inc.z count
    bne !+
    inc.z count+1
    bne !+
    inc.z count+2
    bne !+
    inc.z count+3
  !:
    // print()
    jsr print
    jmp __b3
}
// Print the board with a legal placement. Also increments the solution count.
print: {
    .label i = $1e
    .label i1 = $1e
    .label j = $1d
    // printf("\n#%lu:\n ",count)
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\n#%lu:\n ",count)
    jsr printf_ulong
    // printf("\n#%lu:\n ",count)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    lda #1
    sta.z i
  __b1:
    // for(char i=1;i<=QUEENS;++i)
    lda.z i
    cmp #8+1
    bcc __b2
    lda #1
    sta.z i1
  __b3:
    // for(char i=1;i<=QUEENS;++i)
    lda.z i1
    cmp #8+1
    bcc __b4
    // }
    rts
  __b4:
    // printf("\n%x",i)
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\n%x",i)
    jsr printf_uchar
    lda #1
    sta.z j
  __b5:
    // for(char j=1;j<=QUEENS;++j)
    lda.z j
    cmp #8+1
    bcc __b6
    // for(char i=1;i<=QUEENS;++i)
    inc.z i1
    jmp __b3
  __b6:
    // if(board[i]==j)
    ldy.z i1
    lda board,y
    cmp.z j
    beq __b8
    // printf("-")
    lda #<str4
    sta.z printf_str.str
    lda #>str4
    sta.z printf_str.str+1
    jsr printf_str
  __b9:
    // for(char j=1;j<=QUEENS;++j)
    inc.z j
    jmp __b5
  __b8:
    // printf("Q")
    lda #<str3
    sta.z printf_str.str
    lda #>str3
    sta.z printf_str.str+1
    jsr printf_str
    jmp __b9
  __b2:
    // printf("%x",i)
    jsr printf_uchar
    // for(char i=1;i<=QUEENS;++i)
    inc.z i
    jmp __b1
    str: .text @"\n#"
    .byte 0
    str1: .text @":\n "
    .byte 0
    str2: .text @"\n"
    .byte 0
    str3: .text "Q"
    .byte 0
    str4: .text "-"
    .byte 0
}
// Print an unsigned char using a specific format
// printf_uchar(byte zp($1e) uvalue)
printf_uchar: {
    .label uvalue = $1e
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    lda.z uvalue
    sta.z uctoa.value
  // Format number into buffer
    jsr uctoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_upper_case
    sta.z printf_number_buffer.format_zero_padding
    sta.z printf_number_buffer.format_justify_left
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte zp($f) value, byte* zp($c) buffer)
uctoa: {
    .label digit_value = $23
    .label buffer = $c
    .label digit = $e
    .label value = $f
    .label started = $10
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #2-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    ldy.z value
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
    ldy.z digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    lda #0
    cmp.z started
    bne __b5
    lda.z value
    cmp.z digit_value
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
// uctoa_append(byte* zp($c) buffer, byte zp($f) value, byte zp($23) sub)
uctoa_append: {
    .label buffer = $c
    .label value = $f
    .label sub = $23
    .label return = $f
    .label digit = $24
    lda #0
    sta.z digit
  __b1:
    // while (value >= sub)
    lda.z value
    cmp.z sub
    bcs __b2
    // *buffer = DIGITS[digit]
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inc.z digit
    // value -= sub
    lda.z value
    sec
    sbc.z sub
    sta.z value
    jmp __b1
}
// Checks is a placement of the queen on the board is legal.
// Checks the passed (row, column) against all queens placed on the board on lower rows.
// If no conflict for desired position returns 1 otherwise returns 0
// legal(byte zp($21) row, byte zp($22) column)
legal: {
    .label __0 = $23
    .label __3 = $24
    .label __4 = $f
    .label row = $21
    .label column = $22
    // Placement is legal
    // The same column is a conflict.
    // The same diagonal is a conflict.
    .label return = $e
    .label i = $1e
    lda #1
    sta.z i
  __b1:
    // row-1
    ldx.z row
    dex
    stx.z __0
    // for(char i=1;i<=row-1;++i)
    txa
    cmp.z i
    bcs __b2
    lda #1
    sta.z return
    rts
  __b4:
    lda #0
    sta.z return
    // }
    rts
  __b2:
    // if(board[i]==column)
    ldy.z i
    lda board,y
    cmp.z column
    beq __b4
    // diff(board[i],column)
    lda board,y
    sta.z diff.a
    lda.z column
    sta.z diff.b
    jsr diff
    // diff(board[i],column)
    lda.z diff.return_1
    sta.z diff.return
    // diff(i,row)
    lda.z i
    sta.z diff.a
    lda.z row
    sta.z diff.b
    jsr diff
    // diff(i,row)
    // if(diff(board[i],column)==diff(i,row))
    lda.z __3
    cmp.z __4
    bne __b3
    jmp __b4
  __b3:
    // for(char i=1;i<=row-1;++i)
    inc.z i
    jmp __b1
}
// Find the absolute difference between two unsigned chars
// diff(byte zp($f) a, byte zp($10) b)
diff: {
    .label a = $f
    .label b = $10
    .label return = $24
    .label return_1 = $f
    // if(a<b)
    lda.z a
    cmp.z b
    bcc __b1
    // return a-b;
    lda.z return_1
    sec
    sbc.z b
    sta.z return_1
    // }
    rts
  __b1:
    // return b-a;
    lda.z b
    sec
    sbc.z return_1
    sta.z return_1
    rts
}
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // The buffer used by tod_str()
  tod_buffer: .text "00:00:00:00"
  .byte 0
  // The board. board[i] holds the column position of the queen on row i. 
  board: .fill $14, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
  // Time of Day 00:00:00:00
  TOD_ZERO: .byte 0, 0, 0, 0
