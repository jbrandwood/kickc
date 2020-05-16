// N Queens Problem in C Using Backtracking
//
// N Queens Problem is a famous puzzle in which n-queens are to be placed on a nxn chess board such that no two queens are in the same row, column or diagonal.  
//
// This is a recursive solution
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // The default text color
  .const CONIO_TEXTCOLOR_DEFAULT = $e
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
  // The screen width
  // The screen height
  // The screen bytes
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  .label conio_cursor_x = $14
  .label conio_cursor_y = $15
  .label conio_cursor_text = $16
  .label conio_cursor_color = $18
  .label count = 2
__bbegin:
  // conio_cursor_x = 0
  // The current cursor x-position
  lda #0
  sta.z conio_cursor_x
  // conio_cursor_y = 0
  // The current cursor y-position
  sta.z conio_cursor_y
  // conio_cursor_text = CONIO_SCREEN_TEXT
  // The current cursor address
  lda #<CONIO_SCREEN_TEXT
  sta.z conio_cursor_text
  lda #>CONIO_SCREEN_TEXT
  sta.z conio_cursor_text+1
  // conio_cursor_color = CONIO_SCREEN_COLORS
  // The current cursor address
  lda #<CONIO_SCREEN_COLORS
  sta.z conio_cursor_color
  lda #>CONIO_SCREEN_COLORS
  sta.z conio_cursor_color+1
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
    // clrscr()
    jsr clrscr
    // printf(" - n queens problem using backtracking -")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("\nnumber of queens:%u",QUEENS)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    // printf("\n\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("\n\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    jsr printf_ulong
    // printf("\n\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("\n\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    jsr printf_string
    // printf("\n\nsolutions: %lu time: %s.\n",count,tod_str(tod_read()))
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
    s: .text " - n queens problem using backtracking -"
    .byte 0
    s1: .text @"\nnumber of queens:"
    .byte 0
    s2: .text @"\n\nsolutions: "
    .byte 0
    s3: .text " time: "
    .byte 0
    s4: .text @".\n"
    .byte 0
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($c) s)
cputs: {
    .label c = $11
    .label s = $c
  __b1:
    // c=*s++
    ldy #0
    lda (s),y
    sta.z c
    // while(c=*s++)
    inc.z s
    bne !+
    inc.z s+1
  !:
    lda #0
    cmp.z c
    bne __b2
    // }
    rts
  __b2:
    // cputc(c)
    jsr cputc
    jmp __b1
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($11) c)
cputc: {
    .label c = $11
    // if(c=='\n')
    lda #'\n'
    cmp.z c
    beq __b1
    // *conio_cursor_text++ = c
    lda.z c
    ldy #0
    sta (conio_cursor_text),y
    // *conio_cursor_text++ = c;
    inc.z conio_cursor_text
    bne !+
    inc.z conio_cursor_text+1
  !:
    // *conio_cursor_color++ = conio_textcolor
    lda #CONIO_TEXTCOLOR_DEFAULT
    ldy #0
    sta (conio_cursor_color),y
    // *conio_cursor_color++ = conio_textcolor;
    inc.z conio_cursor_color
    bne !+
    inc.z conio_cursor_color+1
  !:
    // if(++conio_cursor_x==CONIO_WIDTH)
    inc.z conio_cursor_x
    lda #$28
    cmp.z conio_cursor_x
    bne __breturn
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // ++conio_cursor_y;
    inc.z conio_cursor_y
    // cscroll()
    jsr cscroll
  __breturn:
    // }
    rts
  __b1:
    // cputln()
    jsr cputln
    rts
}
// Print a newline
cputln: {
    .label __1 = $16
    .label __2 = $18
    .label ln_offset = $23
    // ln_offset = CONIO_WIDTH - conio_cursor_x
    sec
    lda #$28
    sbc.z conio_cursor_x
    sta.z ln_offset
    lda #0
    sbc #0
    sta.z ln_offset+1
    // conio_cursor_text  + ln_offset
    lda.z __1
    clc
    adc.z ln_offset
    sta.z __1
    lda.z __1+1
    adc.z ln_offset+1
    sta.z __1+1
    // conio_cursor_text =  conio_cursor_text  + ln_offset
    // conio_cursor_color + ln_offset
    lda.z __2
    clc
    adc.z ln_offset
    sta.z __2
    lda.z __2+1
    adc.z ln_offset+1
    sta.z __2+1
    // conio_cursor_color = conio_cursor_color + ln_offset
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y++;
    inc.z conio_cursor_y
    // cscroll()
    jsr cscroll
    // }
    rts
}
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    .label __7 = $16
    .label __8 = $18
    // if(conio_cursor_y==CONIO_HEIGHT)
    lda #$19
    cmp.z conio_cursor_y
    bne __breturn
    // memcpy(CONIO_SCREEN_TEXT, CONIO_SCREEN_TEXT+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<CONIO_SCREEN_TEXT
    sta.z memcpy.destination
    lda #>CONIO_SCREEN_TEXT
    sta.z memcpy.destination+1
    lda #<CONIO_SCREEN_TEXT+$28
    sta.z memcpy.source
    lda #>CONIO_SCREEN_TEXT+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(CONIO_SCREEN_COLORS, CONIO_SCREEN_COLORS+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<CONIO_SCREEN_COLORS
    sta.z memcpy.destination
    lda #>CONIO_SCREEN_COLORS
    sta.z memcpy.destination+1
    lda #<CONIO_SCREEN_COLORS+$28
    sta.z memcpy.source
    lda #>CONIO_SCREEN_COLORS+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    lda #' '
    sta.z memset.c
    lda #<CONIO_SCREEN_TEXT+$19*$28-$28
    sta.z memset.str
    lda #>CONIO_SCREEN_TEXT+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    lda #CONIO_TEXTCOLOR_DEFAULT
    sta.z memset.c
    lda #<CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str
    lda #>CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // conio_cursor_text-CONIO_WIDTH
    lda.z __7
    sec
    sbc #<$28
    sta.z __7
    lda.z __7+1
    sbc #>$28
    sta.z __7+1
    // conio_cursor_text = conio_cursor_text-CONIO_WIDTH
    // conio_cursor_color-CONIO_WIDTH
    lda.z __8
    sec
    sbc #<$28
    sta.z __8
    lda.z __8+1
    sbc #>$28
    sta.z __8+1
    // conio_cursor_color = conio_cursor_color-CONIO_WIDTH
    // conio_cursor_y--;
    dec.z conio_cursor_y
  __breturn:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($a) str, byte zp($12) c)
memset: {
    .label end = $23
    .label dst = $a
    .label str = $a
    .label c = $12
    // end = (char*)str + num
    lda #$28
    clc
    adc.z str
    sta.z end
    lda #0
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
// memcpy(void* zp($e) destination, void* zp($a) source)
memcpy: {
    .label src_end = $23
    .label dst = $e
    .label src = $a
    .label source = $a
    .label destination = $e
    // src_end = (char*)source+num
    lda.z source
    clc
    adc #<$19*$28-$28
    sta.z src_end
    lda.z source+1
    adc #>$19*$28-$28
    sta.z src_end+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
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
// Print a string value using a specific format
// Handles justification and min length 
printf_string: {
    // cputs(str)
    lda #<tod_buffer
    sta.z cputs.s
    lda #>tod_buffer
    sta.z cputs.s+1
    jsr cputs
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
// printf_number_buffer(byte zp($1a) buffer_sign, byte zp($10) format_min_length, byte zp($13) format_justify_left, byte zp($28) format_zero_padding, byte zp($1b) format_upper_case)
printf_number_buffer: {
    .label __19 = $a
    .label buffer_sign = $1a
    .label len = $11
    .label padding = $10
    .label format_min_length = $10
    .label format_zero_padding = $28
    .label format_justify_left = $13
    .label format_upper_case = $1b
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
    // cputc(buffer.sign)
    lda.z buffer_sign
    sta.z cputc.c
    jsr cputc
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
    // cputs(buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s+1
    jsr cputs
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
// printf_padding(byte zp($11) pad, byte zp($1c) length)
printf_padding: {
    .label i = $1d
    .label length = $1c
    .label pad = $11
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
    // cputc(pad)
    jsr cputc
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Converts a string to uppercase.
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label __0 = $12
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
// toupper(byte zp($12) ch)
toupper: {
    .label return = $12
    .label ch = $12
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
// strlen(byte* zp($e) str)
strlen: {
    .label len = $a
    .label str = $e
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
// ultoa(dword zp(6) value, byte* zp($a) buffer)
ultoa: {
    .label __10 = $27
    .label __11 = $1d
    .label digit_value = $1e
    .label buffer = $a
    .label digit = $10
    .label value = 6
    .label started = $13
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
// ultoa_append(byte* zp($a) buffer, dword zp(6) value, dword zp($1e) sub)
ultoa_append: {
    .label buffer = $a
    .label value = 6
    .label sub = $1e
    .label return = 6
    .label digit = $28
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
// tod_str(byte zp($1a) tod_TENTHS, byte zp($1b) tod_SEC, byte zp($1c) tod_MIN, byte zp($1d) tod_HOURS)
tod_str: {
    .label __0 = $27
    .label __1 = $27
    .label __2 = $1d
    .label __3 = $1d
    .label __4 = $22
    .label __5 = $22
    .label __6 = $1c
    .label __7 = $1c
    .label __8 = $26
    .label __9 = $26
    .label __10 = $1b
    .label __11 = $1b
    .label __12 = $25
    .label __13 = $25
    .label __14 = $1a
    .label __15 = $1a
    .label tod_TENTHS = $1a
    .label tod_SEC = $1b
    .label tod_MIN = $1c
    .label tod_HOURS = $1d
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
    .label return_TENTHS = $1a
    .label return_SEC = $1b
    .label return_MIN = $1c
    .label return_HOURS = $1d
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
// tod_init(byte zp($28) tod_TENTHS, byte zp($1a) tod_SEC, byte zp($1b) tod_MIN, byte zp($1c) tod_HOURS)
tod_init: {
    .label tod_TENTHS = $28
    .label tod_SEC = $1a
    .label tod_MIN = $1b
    .label tod_HOURS = $1c
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
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    .label uvalue = 8
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
// utoa(word zp($c) value, byte* zp($e) buffer)
utoa: {
    .const max_digits = 5
    .label __10 = $26
    .label __11 = $22
    .label digit_value = $23
    .label buffer = $e
    .label digit = $1a
    .label value = $c
    .label started = $1b
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
// utoa_append(byte* zp($e) buffer, word zp($c) value, word zp($23) sub)
utoa_append: {
    .label buffer = $e
    .label value = $c
    .label sub = $23
    .label return = $c
    .label digit = $1c
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
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label c = $22
    .label line_text = $c
    .label line_cols = $e
    .label l = $1d
    lda #<CONIO_SCREEN_COLORS
    sta.z line_cols
    lda #>CONIO_SCREEN_COLORS
    sta.z line_cols+1
    lda #<CONIO_SCREEN_TEXT
    sta.z line_text
    lda #>CONIO_SCREEN_TEXT
    sta.z line_text+1
    lda #0
    sta.z l
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    lda.z l
    cmp #$19
    bcc __b2
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    sta.z conio_cursor_y
    // conio_cursor_text = CONIO_SCREEN_TEXT
    lda #<CONIO_SCREEN_TEXT
    sta.z conio_cursor_text
    lda #>CONIO_SCREEN_TEXT
    sta.z conio_cursor_text+1
    // conio_cursor_color = CONIO_SCREEN_COLORS
    lda #<CONIO_SCREEN_COLORS
    sta.z conio_cursor_color
    lda #>CONIO_SCREEN_COLORS
    sta.z conio_cursor_color+1
    // }
    rts
  __b2:
    lda #0
    sta.z c
  __b3:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    lda.z c
    cmp #$28
    bcc __b4
    // line_text += CONIO_WIDTH
    lda #$28
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // line_cols += CONIO_WIDTH
    lda #$28
    clc
    adc.z line_cols
    sta.z line_cols
    bcc !+
    inc.z line_cols+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    inc.z l
    jmp __b1
  __b4:
    // line_text[c] = ' '
    lda #' '
    ldy.z c
    sta (line_text),y
    // line_cols[c] = conio_textcolor
    lda #CONIO_TEXTCOLOR_DEFAULT
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    inc.z c
    jmp __b3
}
// Generates all valid placements of queens on a NxN board recursively
// Works by generating all legal placements af a queen for a specific row taking into consideration the queens already placed on the rows below 
// and then recursively generating all legal placements on the rows above.  
// queen(byte zp($25) row)
queen: {
    .const OFFSET_STACK_ROW = 0
    .label r = $25
    .label column = $26
    .label __1 = $11
    .label __4 = $25
    .label row = $25
    // }
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
    .label i = $22
    .label i1 = $22
    .label j = $10
    // gotoxy(0,5)
    jsr gotoxy
    // printf("\n#%lu:\n ",count)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("\n#%lu:\n ",count)
    jsr printf_ulong
    // printf("\n#%lu:\n ",count)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
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
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
  __b9:
    // for(char j=1;j<=QUEENS;++j)
    inc.z j
    jmp __b5
  __b8:
    // printf("Q")
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    jmp __b9
  __b2:
    // printf("%x",i)
    jsr printf_uchar
    // for(char i=1;i<=QUEENS;++i)
    inc.z i
    jmp __b1
    s: .text @"\n#"
    .byte 0
    s1: .text @":\n "
    .byte 0
    s2: .text @"\n"
    .byte 0
    s3: .text "Q"
    .byte 0
    s4: .text "-"
    .byte 0
}
// Print an unsigned char using a specific format
// printf_uchar(byte zp($22) uvalue)
printf_uchar: {
    .label uvalue = $22
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
// uctoa(byte zp($12) value, byte* zp($23) buffer)
uctoa: {
    .label digit_value = $27
    .label buffer = $23
    .label digit = $11
    .label value = $12
    .label started = $13
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
// uctoa_append(byte* zp($23) buffer, byte zp($12) value, byte zp($27) sub)
uctoa_append: {
    .label buffer = $23
    .label value = $12
    .label sub = $27
    .label return = $12
    .label digit = $28
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
// Set the cursor to the specified position
gotoxy: {
    .const x = 0
    .const y = 5
    .const offset = y*$28
    // conio_cursor_x = x
    lda #x
    sta.z conio_cursor_x
    // conio_cursor_y = y
    lda #y
    sta.z conio_cursor_y
    // conio_cursor_text = CONIO_SCREEN_TEXT + offset
    lda #<CONIO_SCREEN_TEXT+offset
    sta.z conio_cursor_text
    lda #>CONIO_SCREEN_TEXT+offset
    sta.z conio_cursor_text+1
    // conio_cursor_color = CONIO_SCREEN_COLORS + offset
    lda #<CONIO_SCREEN_COLORS+offset
    sta.z conio_cursor_color
    lda #>CONIO_SCREEN_COLORS+offset
    sta.z conio_cursor_color+1
    // }
    rts
}
// Checks is a placement of the queen on the board is legal.
// Checks the passed (row, column) against all queens placed on the board on lower rows.
// If no conflict for desired position returns 1 otherwise returns 0
// legal(byte zp($25) row, byte zp($26) column)
legal: {
    .label __0 = $27
    .label __3 = $28
    .label __4 = $12
    .label row = $25
    .label column = $26
    // Placement is legal
    // The same column is a conflict.
    // The same diagonal is a conflict.
    .label return = $11
    .label i = $10
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
// diff(byte zp($12) a, byte zp($13) b)
diff: {
    .label a = $12
    .label b = $13
    .label return = $28
    .label return_1 = $12
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