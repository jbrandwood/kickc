// N Queens Problem in C Using Backtracking
//
// N Queens Problem is a famous puzzle in which n-queens are to be placed on a nxn chess board such that no two queens are in the same row, column or diagonal.
//
// This is an iterative solution.
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
  .label conio_line_text = $16
  .label conio_line_color = $18
  // The number of found solutions
  .label count = 2
__bbegin:
  // conio_cursor_x = 0
  // The current cursor x-position
  lda #0
  sta.z conio_cursor_x
  // conio_cursor_y = 0
  // The current cursor y-position
  sta.z conio_cursor_y
  // conio_line_text = CONIO_SCREEN_TEXT
  // The current text cursor line start
  lda #<CONIO_SCREEN_TEXT
  sta.z conio_line_text
  lda #>CONIO_SCREEN_TEXT
  sta.z conio_line_text+1
  // conio_line_color = CONIO_SCREEN_COLORS
  // The current color cursor line start
  lda #<CONIO_SCREEN_COLORS
  sta.z conio_line_color
  lda #>CONIO_SCREEN_COLORS
  sta.z conio_line_color+1
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
    ldx TOD_ZERO+OFFSET_STRUCT_TIME_OF_DAY_MIN
    ldy TOD_ZERO+OFFSET_STRUCT_TIME_OF_DAY_HOURS
    jsr tod_init
    // queens()
    jsr queens
    // tod_read()
    jsr tod_read
    sta.z tod_read.return_MIN
    lda.z tod_read.return_HOURS
    // tod_str(tod_read())
    sty.z tod_str.tod_TENTHS
    stx.z tod_str.tod_SEC
    ldy.z tod_read.return_MIN
    tax
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
// cputs(byte* zp($10) s)
cputs: {
    .label s = $10
  __b1:
    // c=*s++
    ldy #0
    lda (s),y
    // while(c=*s++)
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
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
// cputc(byte register(A) c)
cputc: {
    // if(c=='\n')
    cmp #'\n'
    beq __b1
    // conio_line_text[conio_cursor_x] = c
    ldy.z conio_cursor_x
    sta (conio_line_text),y
    // conio_line_color[conio_cursor_x] = conio_textcolor
    lda #CONIO_TEXTCOLOR_DEFAULT
    sta (conio_line_color),y
    // if(++conio_cursor_x==CONIO_WIDTH)
    inc.z conio_cursor_x
    lda #$28
    cmp.z conio_cursor_x
    bne __breturn
    // cputln()
    jsr cputln
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
    // conio_line_text +=  CONIO_WIDTH
    lda #$28
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    // conio_line_color += CONIO_WIDTH
    lda #$28
    clc
    adc.z conio_line_color
    sta.z conio_line_color
    bcc !+
    inc.z conio_line_color+1
  !:
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
    ldx #' '
    lda #<CONIO_SCREEN_TEXT+$19*$28-$28
    sta.z memset.str
    lda #>CONIO_SCREEN_TEXT+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    ldx #CONIO_TEXTCOLOR_DEFAULT
    lda #<CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str
    lda #>CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // conio_line_text -= CONIO_WIDTH
    lda.z conio_line_text
    sec
    sbc #<$28
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #>$28
    sta.z conio_line_text+1
    // conio_line_color -= CONIO_WIDTH
    lda.z conio_line_color
    sec
    sbc #<$28
    sta.z conio_line_color
    lda.z conio_line_color+1
    sbc #>$28
    sta.z conio_line_color+1
    // conio_cursor_y--;
    dec.z conio_cursor_y
  __breturn:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($a) str, byte register(X) c)
memset: {
    .label end = $25
    .label dst = $a
    .label str = $a
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
// memcpy(void* zp($12) destination, void* zp($a) source)
memcpy: {
    .label src_end = $25
    .label dst = $12
    .label src = $a
    .label source = $a
    .label destination = $12
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
    tax
    jsr printf_number_buffer
    // }
    rts
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($d) buffer_sign, byte register(X) format_min_length, byte zp($23) format_justify_left, byte zp($c) format_zero_padding, byte zp($e) format_upper_case)
printf_number_buffer: {
    .label __19 = $a
    .label buffer_sign = $d
    .label padding = $24
    .label format_zero_padding = $c
    .label format_justify_left = $23
    .label format_upper_case = $e
    // if(format.min_length)
    cpx #0
    beq __b6
    // strlen(buffer.digits)
    jsr strlen
    // strlen(buffer.digits)
    // len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    lda.z __19
    tay
    // if(buffer.sign)
    lda #0
    cmp.z buffer_sign
    beq __b13
    // len++;
    iny
  __b13:
    // padding = (signed char)format.min_length - len
    txa
    sty.z $ff
    sec
    sbc.z $ff
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
// printf_padding(byte zp($1a) pad, byte zp($f) length)
printf_padding: {
    .label i = $1b
    .label length = $f
    .label pad = $1a
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
    lda.z pad
    jsr cputc
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Converts a string to uppercase.
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = $10
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
    jsr toupper
    // *src = toupper(*src)
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
// toupper(byte register(A) ch)
toupper: {
    // if(ch>='a' && ch<='z')
    cmp #'a'
    bcc __breturn
    cmp #'z'
    bcc __b1
    beq __b1
    rts
  __b1:
    // return ch + ('A'-'a');
    clc
    adc #'A'-'a'
  __breturn:
    // }
    rts
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($12) str)
strlen: {
    .label len = $a
    .label str = $12
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
    .label digit_value = $1f
    .label buffer = $a
    .label digit = $23
    .label value = 6
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
// ultoa_append(byte* zp($a) buffer, dword zp(6) value, dword zp($1f) sub)
ultoa_append: {
    .label buffer = $a
    .label value = 6
    .label sub = $1f
    .label return = 6
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
// Convert time of day to a human-readable string "hh:mm:ss:10"
// tod_str(byte zp($1d) tod_TENTHS, byte zp($1e) tod_SEC, byte register(Y) tod_MIN, byte register(X) tod_HOURS)
tod_str: {
    .label tod_TENTHS = $1d
    .label tod_SEC = $1e
    // tod.HOURS>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // '0'+(tod.HOURS>>4)
    clc
    adc #'0'
    // tod_buffer[0] = '0'+(tod.HOURS>>4)
    sta tod_buffer
    // tod.HOURS&0x0f
    txa
    and #$f
    // '0'+(tod.HOURS&0x0f)
    clc
    adc #'0'
    // tod_buffer[1] = '0'+(tod.HOURS&0x0f)
    sta tod_buffer+1
    // tod.MIN>>4
    tya
    lsr
    lsr
    lsr
    lsr
    // '0'+(tod.MIN>>4)
    clc
    adc #'0'
    // tod_buffer[3] = '0'+(tod.MIN>>4)
    sta tod_buffer+3
    // tod.MIN&0x0f
    tya
    and #$f
    // '0'+(tod.MIN&0x0f)
    clc
    adc #'0'
    // tod_buffer[4] = '0'+(tod.MIN&0x0f)
    sta tod_buffer+4
    // tod.SEC>>4
    lda.z tod_SEC
    lsr
    lsr
    lsr
    lsr
    // '0'+(tod.SEC>>4)
    clc
    adc #'0'
    // tod_buffer[6] = '0'+(tod.SEC>>4)
    sta tod_buffer+6
    // tod.SEC&0x0f
    lda #$f
    and.z tod_SEC
    // '0'+(tod.SEC&0x0f)
    clc
    adc #'0'
    // tod_buffer[7] = '0'+(tod.SEC&0x0f)
    sta tod_buffer+7
    // tod.TENTHS>>4
    lda.z tod_TENTHS
    lsr
    lsr
    lsr
    lsr
    // '0'+(tod.TENTHS>>4)
    clc
    adc #'0'
    // tod_buffer[9] = '0'+(tod.TENTHS>>4)
    sta tod_buffer+9
    // tod.TENTHS&0x0f
    lda #$f
    and.z tod_TENTHS
    // '0'+(tod.TENTHS&0x0f)
    clc
    adc #'0'
    // tod_buffer[10] = '0'+(tod.TENTHS&0x0f)
    sta tod_buffer+$a
    // }
    rts
}
// Read time of day
tod_read: {
    .label return_HOURS = $23
    .label return_MIN = $1c
    // hours = CIA1->TOD_HOURS
    // Reading sequence is important. TOD latches on reading hours until 10ths is read.
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_HOURS
    sta.z return_HOURS
    // mins = CIA1->TOD_MIN
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_MIN
    // secs = CIA1->TOD_SEC
    ldx CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_SEC
    // tenths = CIA1->TOD_10THS
    ldy CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_10THS
    // }
    rts
}
// Generates all valid placements of queens on a NxN board without recursion
// Works exactly like the recursive solution by generating all legal placements af a queen for a specific row taking into consideration the queens already placed on the rows below 
// and then moving on to generating all legal placements on the rows above.
// In practice this works like a depth first tree search where the level in the tree is the row on the board and each branch in the tree is the legal placement of a queen on that row. 
// The solution uses the board itself as a "cursor" moving through all possibilities
// When all columns on a row is exhausted move back down to the lower level and move forward one position until we are done with the last position on the first row
queens: {
    // The current row where the queen is moving
    .label row = $1c
    lda #<0
    sta.z count
    sta.z count+1
    lda #<0>>$10
    sta.z count+2
    lda #>0>>$10
    sta.z count+3
    lda #1
    sta.z row
  __b2:
    // board[row]++;
    ldx.z row
    inc board,x
    // if(board[row]==QUEENS+1)
    ldy.z row
    lda board,y
    cmp #8+1
    beq __b3
    // legal(row, board[row])
    lda board,y
    sta.z legal.column
    jsr legal
    // legal(row, board[row])
    // if(legal(row, board[row]))
    cmp #0
    beq __b2
    // if(row==QUEENS)
    // position is legal - move up to the next row
    lda #8
    cmp.z row
    beq __b4
    // row++;
    inc.z row
    jmp __b2
  __b4:
    // ++count;
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
    jmp __b2
  __b3:
    // board[row] = 0
    // We moved past the end of the row - reset position and go down to the lower row
    lda #0
    ldy.z row
    sta board,y
    // if(row==1)
    lda #1
    cmp.z row
    beq __breturn
    // row--;
    dec.z row
    jmp __b2
  __breturn:
    // }
    rts
}
// Print the board with a legal placement.
print: {
    .label i = $1d
    .label i1 = $1e
    .label j = $c
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
    ldx.z i1
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
    ldx.z i
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
// printf_uchar(byte register(X) uvalue)
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
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_upper_case
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
// uctoa(byte register(X) value, byte* zp($10) buffer)
uctoa: {
    .label digit_value = $24
    .label buffer = $10
    .label digit = $d
    .label started = $e
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
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
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
// uctoa_append(byte* zp($10) buffer, byte register(X) value, byte zp($24) sub)
uctoa_append: {
    .label buffer = $10
    .label sub = $24
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
// Set the cursor to the specified position
gotoxy: {
    .const x = 0
    .const y = 5
    .const line_offset = y*$28
    // conio_cursor_x = x
    lda #x
    sta.z conio_cursor_x
    // conio_cursor_y = y
    lda #y
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    lda #<CONIO_SCREEN_TEXT+line_offset
    sta.z conio_line_text
    lda #>CONIO_SCREEN_TEXT+line_offset
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS + line_offset
    lda #<CONIO_SCREEN_COLORS+line_offset
    sta.z conio_line_color
    lda #>CONIO_SCREEN_COLORS+line_offset
    sta.z conio_line_color+1
    // }
    rts
}
// Checks is a placement of the queen on the board is legal.
// Checks the passed (row, column) against all queens placed on the board on lower rows.
// If no conflict for desired position returns 1 otherwise returns 0
// legal(byte zp($1c) row, byte zp($23) column)
legal: {
    .label row = $1c
    .label column = $23
    .label diff1_return = $24
    ldy #1
  __b1:
    // row-1
    ldx.z row
    dex
    // for(char i=1;i<=row-1;++i)
    sty.z $ff
    cpx.z $ff
    bcs __b2
    lda #1
    rts
  __b4:
    lda #0
    // }
    rts
  __b2:
    // if(board[i]==column)
    lda board,y
    cmp.z column
    beq __b4
    // diff(board[i],column)
    lda board,y
    // if(a<b)
    cmp.z column
    bcc diff1___b1
    // return a-b;
    sec
    sbc.z column
    sta.z diff1_return
  diff2:
    // if(a<b)
    cpy.z row
    bcc diff2___b1
    // return a-b;
    tya
    sec
    sbc.z row
  __b5:
    // if(diff(board[i],column)==diff(i,row))
    cmp.z diff1_return
    bne __b3
    jmp __b4
  __b3:
    // for(char i=1;i<=row-1;++i)
    iny
    jmp __b1
  diff2___b1:
    // return b-a;
    tya
    eor #$ff
    sec
    adc.z row
    jmp __b5
  diff1___b1:
    eor #$ff
    sec
    adc.z column
    sta.z diff1_return
    jmp diff2
}
// Initialize time-of-day clock
// This uses the MOS6526 CIA#1
// tod_init(byte zp($1a) tod_TENTHS, byte zp($1b) tod_SEC, byte register(X) tod_MIN, byte register(Y) tod_HOURS)
tod_init: {
    .label tod_TENTHS = $1a
    .label tod_SEC = $1b
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
    sty CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_HOURS
    // CIA1->TOD_MIN = tod.MIN
    stx CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_MIN
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
// utoa(word zp($10) value, byte* zp($12) buffer)
utoa: {
    .const max_digits = 5
    .label digit_value = $25
    .label buffer = $12
    .label digit = $f
    .label value = $10
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
// utoa_append(byte* zp($12) buffer, word zp($10) value, word zp($25) sub)
utoa_append: {
    .label buffer = $12
    .label value = $10
    .label sub = $25
    .label return = $10
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
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = $12
    .label line_cols = $16
    lda #<CONIO_SCREEN_COLORS
    sta.z line_cols
    lda #>CONIO_SCREEN_COLORS
    sta.z line_cols+1
    lda #<CONIO_SCREEN_TEXT
    sta.z line_text
    lda #>CONIO_SCREEN_TEXT
    sta.z line_text+1
    ldx #0
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    cpx #$19
    bcc __b2
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT
    lda #<CONIO_SCREEN_TEXT
    sta.z conio_line_text
    lda #>CONIO_SCREEN_TEXT
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS
    lda #<CONIO_SCREEN_COLORS
    sta.z conio_line_color
    lda #>CONIO_SCREEN_COLORS
    sta.z conio_line_color+1
    // }
    rts
  __b2:
    ldy #0
  __b3:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    cpy #$28
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
    inx
    jmp __b1
  __b4:
    // line_text[c] = ' '
    lda #' '
    sta (line_text),y
    // line_cols[c] = conio_textcolor
    lda #CONIO_TEXTCOLOR_DEFAULT
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b3
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
