// Tests printf function call rewriting
// Print a bunch of different stuff using printf
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  // The default text color
  .const CONIO_TEXTCOLOR_DEFAULT = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // The screen width
  // The screen height
  // The screen bytes
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  .label conio_cursor_x = $11
  .label conio_cursor_y = $12
  .label conio_cursor_text = $13
  .label conio_cursor_color = $15
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
  jsr main
  rts
main: {
    .const ui = $162e
    .label sc = -$c
    .label uc = $22
    .label si = -$4d2
    .label sl = -$1e240
    .label ul = $8aa52
    .label c = $17
    // clrscr()
    jsr clrscr
    // c = 'x'
    lda #'x'
    sta.z c
    // printf("A char: %c\n", c)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("A char: %c\n", c)
    lda.z c
    jsr cputc
    // printf("A char: %c\n", c)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("A pointer: %p\n", &c)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("A pointer: %p\n", &c)
    ldx #HEXADECIMAL
    lda #<c
    sta.z printf_uint.uvalue
    lda #>c
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("A pointer: %p\n", &c)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("A percent: %%\n")
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("A percent: %%\n")
    lda #'%'
    jsr cputc
    // printf("A percent: %%\n")
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("A signed char: %hhd\n", sc)
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // printf("A signed char: %hhd\n", sc)
    jsr printf_schar
    // printf("A signed char: %hhd\n", sc)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("An unsigned char: %hhu\n", uc)
    lda #<s8
    sta.z cputs.s
    lda #>s8
    sta.z cputs.s+1
    jsr cputs
    // printf("An unsigned char: %hhu\n", uc)
    jsr printf_uchar
    // printf("An unsigned char: %hhu\n", uc)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("A signed int: %d\n", si)
    lda #<s10
    sta.z cputs.s
    lda #>s10
    sta.z cputs.s+1
    jsr cputs
    // printf("A signed int: %d\n", si)
    jsr printf_sint
    // printf("A signed int: %d\n", si)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("An unsigned int: %u\n", ui)
    lda #<s12
    sta.z cputs.s
    lda #>s12
    sta.z cputs.s+1
    jsr cputs
    // printf("An unsigned int: %u\n", ui)
    ldx #DECIMAL
    lda #<ui
    sta.z printf_uint.uvalue
    lda #>ui
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("An unsigned int: %u\n", ui)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("A signed long: %ld\n", sl)
    lda #<s14
    sta.z cputs.s
    lda #>s14
    sta.z cputs.s+1
    jsr cputs
    // printf("A signed long: %ld\n", sl)
    jsr printf_slong
    // printf("A signed long: %ld\n", sl)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("An unsigned long: %lu\n", ul)
    lda #<s16
    sta.z cputs.s
    lda #>s16
    sta.z cputs.s+1
    jsr cputs
    // printf("An unsigned long: %lu\n", ul)
    jsr printf_ulong
    // printf("An unsigned long: %lu\n", ul)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
    s: .text "A char: "
    .byte 0
    s1: .text @"\n"
    .byte 0
    s2: .text "A pointer: "
    .byte 0
    s4: .text "A percent: "
    .byte 0
    s6: .text "A signed char: "
    .byte 0
    s8: .text "An unsigned char: "
    .byte 0
    s10: .text "A signed int: "
    .byte 0
    s12: .text "An unsigned int: "
    .byte 0
    s14: .text "A signed long: "
    .byte 0
    s16: .text "An unsigned long: "
    .byte 0
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($d) s)
cputs: {
    .label s = $d
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
    // *conio_cursor_text++ = c
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
    .label __0 = $13
    .label __1 = $13
    .label __2 = $15
    .label __3 = $15
    // conio_cursor_text - conio_cursor_x
    sec
    lda.z __0
    sbc.z conio_cursor_x
    sta.z __0
    bcs !+
    dec.z __0+1
  !:
    // conio_cursor_text - conio_cursor_x + CONIO_WIDTH
    lda #$28
    clc
    adc.z __1
    sta.z __1
    bcc !+
    inc.z __1+1
  !:
    // conio_cursor_text =  conio_cursor_text - conio_cursor_x + CONIO_WIDTH
    // conio_cursor_color - conio_cursor_x
    sec
    lda.z __2
    sbc.z conio_cursor_x
    sta.z __2
    bcs !+
    dec.z __2+1
  !:
    // conio_cursor_color - conio_cursor_x + CONIO_WIDTH
    lda #$28
    clc
    adc.z __3
    sta.z __3
    bcc !+
    inc.z __3+1
  !:
    // conio_cursor_color = conio_cursor_color - conio_cursor_x + CONIO_WIDTH
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
    .label __7 = $13
    .label __8 = $15
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
// memset(void* zp($1e) str, byte register(X) c)
memset: {
    .label end = $18
    .label dst = $1e
    .label str = $1e
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
// memcpy(void* zp($f) destination, void* zp($1e) source)
memcpy: {
    .label src_end = $18
    .label dst = $f
    .label src = $1e
    .label source = $1e
    .label destination = $f
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
// Print an unsigned int using a specific format
printf_ulong: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
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
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($a) buffer_sign, byte register(X) format_min_length, byte zp(4) format_justify_left, byte zp(9) format_zero_padding, byte zp($b) format_upper_case)
printf_number_buffer: {
    .label __19 = $1e
    .label buffer_sign = $a
    .label padding = $c
    .label format_justify_left = 4
    .label format_zero_padding = 9
    .label format_upper_case = $b
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
// printf_padding(byte zp(2) pad, byte zp($20) length)
printf_padding: {
    .label i = 3
    .label length = $20
    .label pad = 2
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
    .label src = $d
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
// strlen(byte* zp($f) str)
strlen: {
    .label len = $1e
    .label str = $f
    .label return = $1e
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
// ultoa(dword zp(5) value, byte* zp($1e) buffer)
ultoa: {
    .label digit_value = $1a
    .label buffer = $1e
    .label digit = 4
    .label value = 5
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
// ultoa_append(byte* zp($1e) buffer, dword zp(5) value, dword zp($1a) sub)
ultoa_append: {
    .label buffer = $1e
    .label value = 5
    .label sub = $1a
    .label return = 5
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
    .const format_upper_case = 0
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
// Print an unsigned int using a specific format
// printf_uint(word zp($d) uvalue, byte register(X) format_radix)
printf_uint: {
    .label uvalue = $d
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
// utoa(word zp($d) value, byte* zp($18) buffer, byte register(X) radix)
utoa: {
    .label digit_value = $1e
    .label buffer = $18
    .label digit = $a
    .label value = $d
    .label max_digits = 9
    .label digit_values = $f
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
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
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
// utoa_append(byte* zp($18) buffer, word zp($d) value, word zp($1e) sub)
utoa_append: {
    .label buffer = $18
    .label value = $d
    .label sub = $1e
    .label return = $d
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
    .const format_upper_case = 0
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
// Print an unsigned char using a specific format
printf_uchar: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    ldx #main.uc
    jsr uctoa
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
// uctoa(byte register(X) value, byte* zp($d) buffer)
uctoa: {
    .label digit_value = $20
    .label buffer = $d
    .label digit = $b
    .label started = $c
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
// uctoa_append(byte* zp($d) buffer, byte register(X) value, byte zp($20) sub)
uctoa_append: {
    .label buffer = $d
    .label sub = $20
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
    .const format_upper_case = 0
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
    ldx #uvalue
    jsr uctoa
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
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = $f
    .label line_cols = $18
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
