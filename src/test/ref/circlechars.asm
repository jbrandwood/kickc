// Plot a r=9 circle on the screen using chars - count how many chars are used
// C standard library string.h
// Functions to manipulate C strings and arrays.
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
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
  .label SCREEN = $400
  .label conio_cursor_x = 9
  .label conio_cursor_y = $a
  .label conio_line_text = $b
  .label conio_line_color = $d
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
    .label __9 = $10
    .label __10 = $d
    .label yd = $f
    .label dist_sq = $10
    .label y = 9
    .label sc = $b
    .label x = $a
    .label count = 2
    // memset(SCREEN, ' ', 1000)
    ldx #' '
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
    lda #<0
    sta.z count
    sta.z count+1
    sta.z y
  __b1:
    // for(signed char y=0;y<25;y++)
    lda.z y
    sec
    sbc #$19
    bvc !+
    eor #$80
  !:
    bmi __b2
    // gotoxy(0,0)
    jsr gotoxy
    // printf("%u chars",count)
    jsr printf_uint
    // printf("%u chars",count)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  __b2:
    lda #0
    sta.z x
  __b3:
    // for(signed char x=0;x<40;x++)
    lda.z x
    sec
    sbc #$28
    bvc !+
    eor #$80
  !:
    bmi __b4
    // for(signed char y=0;y<25;y++)
    inc.z y
    jmp __b1
  __b4:
    // x*2
    lda.z x
    asl
    // xd = x*2-39
    tax
    axs #$27
    // y*2
    lda.z y
    asl
    // yd = y*2-24
    sec
    sbc #$18
    sta.z yd
    // mul8s(xd,xd)
    stx.z mul8s.a
    txa
    tay
    jsr mul8s
    // mul8s(xd,xd)
    lda.z mul8s.m
    sta.z __9
    lda.z mul8s.m+1
    sta.z __9+1
    // mul8s(yd,yd)
    lda.z yd
    sta.z mul8s.a
    ldy.z yd
    jsr mul8s
    // mul8s(yd,yd)
    // dist_sq = mul8s(xd,xd) + mul8s(yd,yd)
    lda.z dist_sq
    clc
    adc.z __10
    sta.z dist_sq
    lda.z dist_sq+1
    adc.z __10+1
    sta.z dist_sq+1
    // if(dist_sq<2*9*2*9)
    lda.z dist_sq
    cmp #<2*9*2*9
    lda.z dist_sq+1
    sbc #>2*9*2*9
    bvc !+
    eor #$80
  !:
    bpl __b6
    // *sc = '*'
    lda #'*'
    ldy #0
    sta (sc),y
    // count++;
    inc.z count
    bne !+
    inc.z count+1
  !:
  __b6:
    // sc++;
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    // for(signed char x=0;x<40;x++)
    inc.z x
    jmp __b3
    s: .text " chars"
    .byte 0
}
// Multiply of two signed chars to a signed int
// Fixes offsets introduced by using unsigned multiplication
// mul8s(signed byte zp(8) a, signed byte register(Y) b)
mul8s: {
    .label m = $d
    .label a = 8
    // mul8u((char)a, (char) b)
    ldx.z a
    tya
    jsr mul8u
    // m = mul8u((char)a, (char) b)
    // if(a<0)
    lda.z a
    cmp #0
    bpl __b1
    // >m
    lda.z m+1
    // >m = (>m)-(char)b
    sty.z $ff
    sec
    sbc.z $ff
    sta.z m+1
  __b1:
    // if(b<0)
    cpy #0
    bpl __b2
    // >m
    lda.z m+1
    // >m = (>m)-(char)a
    sec
    sbc.z a
    sta.z m+1
  __b2:
    // }
    rts
}
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = 4
    .label res = $d
    .label return = $d
    // mb = b
    sta.z mb
    lda #0
    sta.z mb+1
    sta.z res
    sta.z res+1
  __b1:
    // while(a!=0)
    cpx #0
    bne __b2
    // }
    rts
  __b2:
    // a&1
    txa
    and #1
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
  __b3:
    // a = a>>1
    txa
    lsr
    tax
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    jmp __b1
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(4) s)
cputs: {
    .label s = 4
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
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    ldx #CONIO_TEXTCOLOR_DEFAULT
    lda #<CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str
    lda #>CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str+1
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(6) str, byte register(X) c, word zp($10) num)
memset: {
    .label end = $10
    .label dst = 6
    .label num = $10
    .label str = 6
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
// memcpy(void* zp(6) destination, void* zp($10) source)
memcpy: {
    .label src_end = $12
    .label dst = 6
    .label src = $10
    .label source = $10
    .label destination = 6
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
// printf_uint(word zp(2) uvalue)
printf_uint: {
    .label uvalue = 2
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(2) value, byte* zp($10) buffer)
utoa: {
    .const max_digits = 5
    .label digit_value = $12
    .label buffer = $10
    .label digit = 8
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
// utoa_append(byte* zp($10) buffer, word zp(2) value, word zp($12) sub)
utoa_append: {
    .label buffer = $10
    .label value = 2
    .label sub = $12
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
// Set the cursor to the specified position
gotoxy: {
    .const x = 0
    .const y = 0
    // conio_cursor_x = x
    lda #x
    sta.z conio_cursor_x
    // conio_cursor_y = y
    lda #y
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    lda #<CONIO_SCREEN_TEXT
    sta.z conio_line_text
    lda #>CONIO_SCREEN_TEXT
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS + line_offset
    lda #<CONIO_SCREEN_COLORS
    sta.z conio_line_color
    lda #>CONIO_SCREEN_COLORS
    sta.z conio_line_color+1
    // }
    rts
}
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
