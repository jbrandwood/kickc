// Tests printf function call rewriting
// Test parameter field syntax %2$d
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .const LIGHT_BLUE = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // Color Ram
  .label COLORRAM = $d800
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = 9
  // The current cursor y-position
  .label conio_cursor_y = $a
  // The current text cursor line start
  .label conio_line_text = $b
  // The current color cursor line start
  .label conio_line_color = $d
__start: {
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
    sta.z conio_line_color+1
    jsr main
    rts
}
main: {
    // clrscr()
    jsr clrscr
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%d %%d:     %d %d\n",1, 2)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%1$d %%2$d: %1$d %2$d\n",1, 2)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<s9
    sta.z cputs.s
    lda #>s9
    sta.z cputs.s+1
    jsr cputs
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%1$d %%1$d: %1$d %1$d\n",1, 2)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<s12
    sta.z cputs.s
    lda #>s12
    sta.z cputs.s+1
    jsr cputs
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%2$d %%2$d: %2$d %2$d\n",1, 2)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<s12
    sta.z cputs.s
    lda #>s12
    sta.z cputs.s+1
    jsr cputs
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #'%'
    jsr cputc
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<s9
    sta.z cputs.s
    lda #>s9
    sta.z cputs.s+1
    jsr cputs
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%2$d %%1$d: %2$d %1$d\n",1, 2)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
    s: .text "d "
    .byte 0
    s1: .text "d:     "
    .byte 0
    s2: .text " "
    .byte 0
    s3: .text @"\n"
    .byte 0
    s4: .text "1$d "
    .byte 0
    s5: .text "2$d: "
    .byte 0
    s9: .text "1$d: "
    .byte 0
    s12: .text "2$d "
    .byte 0
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 2
    .label line_cols = 4
    lda #<COLORRAM
    sta.z line_cols
    lda #>COLORRAM
    sta.z line_cols+1
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
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
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
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
    lda #LIGHT_BLUE
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b3
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
    lda #LIGHT_BLUE
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
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(2) s)
cputs: {
    .label s = 2
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
// Print a signed integer using a specific format
// printf_sint(signed word zp(4) value)
printf_sint: {
    .label value = 4
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(4) value, byte* zp($11) buffer)
utoa: {
    .label digit_value = $f
    .label buffer = $11
    .label digit = 6
    .label value = 4
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
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte register(A) buffer_sign)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // if(buffer.sign)
    cmp #0
    beq __b2
    // cputc(buffer.sign)
    jsr cputc
  __b2:
    // cputs(buffer.digits)
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
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
    lda #<DEFAULT_SCREEN
    sta.z memcpy.destination
    lda #>DEFAULT_SCREEN
    sta.z memcpy.destination+1
    lda #<DEFAULT_SCREEN+$28
    sta.z memcpy.source
    lda #>DEFAULT_SCREEN+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(CONIO_SCREEN_COLORS, CONIO_SCREEN_COLORS+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<COLORRAM
    sta.z memcpy.destination
    lda #>COLORRAM
    sta.z memcpy.destination+1
    lda #<COLORRAM+$28
    sta.z memcpy.source
    lda #>COLORRAM+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    ldx #' '
    lda #<DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str
    lda #>DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    ldx #LIGHT_BLUE
    lda #<COLORRAM+$19*$28-$28
    sta.z memset.str
    lda #>COLORRAM+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // conio_line_text -= CONIO_WIDTH
    sec
    lda.z conio_line_text
    sbc #$28
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    // conio_line_color -= CONIO_WIDTH
    sec
    lda.z conio_line_color
    sbc #$28
    sta.z conio_line_color
    lda.z conio_line_color+1
    sbc #0
    sta.z conio_line_color+1
    // conio_cursor_y--;
    dec.z conio_cursor_y
  __breturn:
    // }
    rts
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($11) buffer, word zp(4) value, word zp($f) sub)
utoa_append: {
    .label buffer = $11
    .label value = 4
    .label sub = $f
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
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp(7) destination, void* zp($11) source)
memcpy: {
    .label src_end = $f
    .label dst = 7
    .label src = $11
    .label source = $11
    .label destination = 7
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(7) str, byte register(X) c)
memset: {
    .label end = $11
    .label dst = 7
    .label str = 7
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
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
