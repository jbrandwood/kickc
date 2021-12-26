// https://adventofcode.com/2020/day/3
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="2020-03.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=main]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// 2-byte saved memory scan counter
  .label SAVMSC = $58
  /// data under cursor
  .label OLDCHR = $5d
  /// 2-byte saved cursor memory address
  .label OLDADR = $5e
  /// Cursor inhibit flag, 0 turns on, any other number turns off. Cursor doesn't change until it moves next.
  .label CRSINH = $2f0
  /// Atari ZP registers
  /// 1-byte cursor row
  .label ROWCRS = $54
  /// 2-byte cursor column
  .label COLCRS = $55
.segment Code
main: {
    // clrscr()
    jsr clrscr
    // test_slope(3,1)
    lda #1
    sta.z test_slope.y_inc
    lda #3
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(3,1)
    // printf("1: encountered %u trees\n",test_slope(3,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // printf("1: encountered %u trees\n",test_slope(3,1))
    jsr printf_uint
    // printf("1: encountered %u trees\n",test_slope(3,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // test_slope(1,1)
    lda #1
    sta.z test_slope.y_inc
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(1,1)
    // printf("2a: encountered %u trees\n",test_slope(1,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // printf("2a: encountered %u trees\n",test_slope(1,1))
    jsr printf_uint
    // printf("2a: encountered %u trees\n",test_slope(1,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // test_slope(3,1)
    lda #1
    sta.z test_slope.y_inc
    lda #3
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(3,1)
    // printf("2b: encountered %u trees\n",test_slope(3,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("2b: encountered %u trees\n",test_slope(3,1))
    jsr printf_uint
    // printf("2b: encountered %u trees\n",test_slope(3,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // test_slope(5,1)
    lda #1
    sta.z test_slope.y_inc
    lda #5
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(5,1)
    // printf("2c: encountered %u trees\n",test_slope(5,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // printf("2c: encountered %u trees\n",test_slope(5,1))
    jsr printf_uint
    // printf("2c: encountered %u trees\n",test_slope(5,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // test_slope(7,1)
    lda #1
    sta.z test_slope.y_inc
    lda #7
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(7,1)
    // printf("2d: encountered %u trees\n",test_slope(7,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s8
    sta.z printf_str.s
    lda #>s8
    sta.z printf_str.s+1
    jsr printf_str
    // printf("2d: encountered %u trees\n",test_slope(7,1))
    jsr printf_uint
    // printf("2d: encountered %u trees\n",test_slope(7,1))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // test_slope(1,2)
    lda #2
    sta.z test_slope.y_inc
    lda #1
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(1,2)
    // printf("2e: encountered %u trees\n",test_slope(1,2))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s10
    sta.z printf_str.s
    lda #>s10
    sta.z printf_str.s+1
    jsr printf_str
    // printf("2e: encountered %u trees\n",test_slope(1,2))
    jsr printf_uint
    // printf("2e: encountered %u trees\n",test_slope(1,2))
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
  __b1:
    jmp __b1
  .segment Data
  .encoding "ascii"
    s: .text "1: encountered "
    .byte 0
    s1: .text @" trees\$9b"
    .byte 0
    s2: .text "2a: encountered "
    .byte 0
    s4: .text "2b: encountered "
    .byte 0
    s6: .text "2c: encountered "
    .byte 0
    s8: .text "2d: encountered "
    .byte 0
    s10: .text "2e: encountered "
    .byte 0
}
.segment Code
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($8f) volatile char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label convertToScreenCode1_v = c
    .label c = $8f
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // if (c == '\r')
    lda #'\r'
    cmp.z c
    beq __b1
    // if(c == '\n' || c == 0x9b)
    lda #'\$9b'
    cmp.z c
    beq __b2
    lda #$9b
    cmp.z c
    beq __b2
    // return rawmap[*v];
    ldy.z convertToScreenCode1_v
    ldx rawmap,y
    // putchar(convertToScreenCode(&c))
    jsr putchar
    // (*COLCRS)++;
    inc.z COLCRS
    bne !+
    inc.z COLCRS+1
  !:
    // if (*COLCRS == CONIO_WIDTH)
    lda.z COLCRS+1
    bne !+
    lda.z COLCRS
    cmp #$28
    beq __b5
  !:
    // setcursor()
    jsr setcursor
    // }
    rts
  __b5:
    // *COLCRS = 0
    lda #<0
    sta.z COLCRS
    sta.z COLCRS+1
    // newline()
    jsr newline
    rts
  __b2:
    // *COLCRS = 0
    // 0x0a LF, or atascii EOL
    lda #<0
    sta.z COLCRS
    sta.z COLCRS+1
    // newline()
    jsr newline
    rts
  __b1:
    // *COLCRS = 0
    // 0x0d, CR = just set the cursor x value to 0
    lda #<0
    sta.z COLCRS
    sta.z COLCRS+1
    // setcursor()
    jsr setcursor
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    lda.z SAVMSC
    sta.z memset.str
    lda.z SAVMSC+1
    sta.z memset.str+1
    // memset(*SAVMSC, 0x00, CONIO_WIDTH * CONIO_HEIGHT)
  // Fill entire screen with spaces
    lda #<$28*$18
    sta.z memset.num
    lda #>$28*$18
    sta.z memset.num+1
    jsr memset
    // *OLDCHR = 0x00
    // 0x00 is screencode for space character
    // set the old character to a space so the cursor doesn't reappear at the last position it was at
    lda #0
    sta.z OLDCHR
    // gotoxy(0,0)
    jsr gotoxy
    // }
    rts
}
// Count the number of trees on a specific slope
// __zp($86) unsigned int test_slope(__zp($8e) char x_inc, __zp($90) char y_inc)
test_slope: {
    .label return = $86
    .label trees = $86
    .label mapline = $8a
    .label y = $8c
    .label x_inc = $8e
    .label y_inc = $90
    lda #<0
    sta.z trees
    sta.z trees+1
    tax
    lda #<map
    sta.z mapline
    lda #>map
    sta.z mapline+1
    txa
    sta.z y
    sta.z y+1
  __b1:
    // for(unsigned int y=0; y<MAP_HEIGHT; y+=y_inc)
    lda.z y+1
    cmp #>$143
    bcc __b2
    bne !+
    lda.z y
    cmp #<$143
    bcc __b2
  !:
    // }
    rts
  __b2:
    // if(mapline[x]=='#')
    txa
    tay
    lda (mapline),y
    cmp #'#'
    bne __b3
    // trees++;
    inc.z trees
    bne !+
    inc.z trees+1
  !:
  __b3:
    // x += x_inc
    txa
    clc
    adc.z x_inc
    tax
    // if(x>=MAP_WIDTH)
    cpx #$1f
    bcc __b4
    // x -= MAP_WIDTH
    txa
    axs #$1f
  __b4:
    // y_inc*MAP_WIDTH
    lda.z y_inc
    asl
    clc
    adc.z y_inc
    asl
    clc
    adc.z y_inc
    asl
    clc
    adc.z y_inc
    asl
    clc
    adc.z y_inc
    // mapline += y_inc*MAP_WIDTH
    clc
    adc.z mapline
    sta.z mapline
    bcc !+
    inc.z mapline+1
  !:
    // y+=y_inc
    lda.z y_inc
    clc
    adc.z y
    sta.z y
    bcc !+
    inc.z y+1
  !:
    jmp __b1
}
/// Print a NUL-terminated string
// void printf_str(__zp($8c) void (*putc)(char), __zp($8a) const char *s)
printf_str: {
    .label s = $8a
    .label putc = $8c
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // putc(c)
    pha
    jsr icall1
    pla
    jmp __b1
  icall1:
    jmp (putc)
}
// Print an unsigned int using a specific format
// void printf_uint(void (*putc)(char), __zp($86) unsigned int uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uint: {
    .label uvalue = $86
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr utoa
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Puts a character to the screen a the current location. Uses internal screencode. Deals with storing the old cursor value
// void putchar(char code)
putchar: {
    .label loc = $80
    // **OLDADR = *OLDCHR
    lda.z OLDCHR
    ldy.z OLDADR
    sty.z $fe
    ldy.z OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // char * loc = cursorLocation()
    jsr cursorLocation
    // char newChar = code | conio_reverse_value
    txa
    // *loc = newChar
    ldy #0
    sta (loc),y
    // *OLDCHR = newChar
    sta.z OLDCHR
    // setcursor()
    jsr setcursor
    // }
    rts
}
// Handles cursor movement, displaying it if required, and inverting character it is over if there is one (and enabled)
setcursor: {
    .label loc = $80
    // **OLDADR = *OLDCHR
    // save the current oldchr into oldadr
    lda.z OLDCHR
    ldy.z OLDADR
    sty.z $fe
    ldy.z OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // char * loc = cursorLocation()
    // work out the new location for oldadr based on new column/row
    jsr cursorLocation
    // char c = *loc
    ldy #0
    lda (loc),y
    tax
    // *OLDCHR = c
    stx.z OLDCHR
    // *OLDADR = loc
    lda.z loc
    sta.z OLDADR
    lda.z loc+1
    sta.z OLDADR+1
    // *CRSINH = 0
    // cursor is on, so invert the inverse bit and turn cursor on
    tya
    sta CRSINH
    // c = c ^ 0x80
    txa
    eor #$80
    // **OLDADR = c
    ldy.z OLDADR
    sty.z $fe
    ldy.z OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // }
    rts
}
newline: {
    .label start = $82
    // if ((*ROWCRS)++ == CONIO_HEIGHT)
    inc.z ROWCRS
    lda #$18
    cmp.z ROWCRS
    bne __b1
    // **OLDADR ^= 0x80
    ldy.z OLDADR
    sty.z $fe
    ldy.z OLDADR+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    eor #$80
    sta ($fe),y
    // char * start = *SAVMSC
    // move screen up 1 line
    lda.z SAVMSC
    sta.z start
    lda.z SAVMSC+1
    sta.z start+1
    // start + CONIO_WIDTH
    lda #$28
    clc
    adc.z start
    sta.z memcpy.source
    tya
    adc.z start+1
    sta.z memcpy.source+1
    // memcpy(start, start + CONIO_WIDTH, CONIO_WIDTH * 23)
    lda.z start
    sta.z memcpy.destination
    lda.z start+1
    sta.z memcpy.destination+1
    jsr memcpy
    // start + CONIO_WIDTH * 23
    lda.z memset.str
    clc
    adc #<$28*$17
    sta.z memset.str
    lda.z memset.str+1
    adc #>$28*$17
    sta.z memset.str+1
    // memset(start + CONIO_WIDTH * 23, 0x00, CONIO_WIDTH)
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
    jsr memset
    // *ROWCRS = CONIO_HEIGHT - 1
    lda #$18-1
    sta.z ROWCRS
  __b1:
    // setcursor()
    jsr setcursor
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp($82) char *str, char c, __zp($84) unsigned int num)
memset: {
    .label end = $84
    .label dst = $82
    .label str = $82
    .label num = $84
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // char* end = (char*)str + num
    clc
    lda.z end
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
    lda #0
    tay
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Set the cursor to the specified position
// void gotoxy(char x, char y)
gotoxy: {
    .const x = 0
    .const y = 0
    // *COLCRS = x
    lda #<x
    sta.z COLCRS
    lda #>x
    sta.z COLCRS+1
    // *ROWCRS = y
    lda #y
    sta.z ROWCRS
    // setcursor()
    jsr setcursor
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__zp($86) unsigned int value, __zp($8c) char *buffer, char radix)
utoa: {
    .label digit_value = $8a
    .label buffer = $8c
    .label digit = $8e
    .label value = $86
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
    ldx.z value
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
    // unsigned int digit_value = digit_values[digit]
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
// void printf_number_buffer(void (*putc)(char), __register(A) char buffer_sign, char *buffer_digits, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label putc = cputc
    // if(buffer.sign)
    cmp #0
    beq __b2
    // putc(buffer.sign)
    pha
    jsr cputc
    pla
  __b2:
    // printf_str(putc, buffer.digits)
    lda #<putc
    sta.z printf_str.putc
    lda #>putc
    sta.z printf_str.putc+1
    lda #<buffer_digits
    sta.z printf_str.s
    lda #>buffer_digits
    sta.z printf_str.s+1
    jsr printf_str
    // }
    rts
}
// Return a pointer to the location of the cursor
cursorLocation: {
    .label __0 = $80
    .label __1 = $80
    .label __3 = $80
    .label return = $80
    .label __4 = $88
    .label __5 = $80
    // (word)(*ROWCRS)*CONIO_WIDTH
    lda.z ROWCRS
    sta.z __3
    lda #0
    sta.z __3+1
    lda.z __3
    asl
    sta.z __4
    lda.z __3+1
    rol
    sta.z __4+1
    asl.z __4
    rol.z __4+1
    clc
    lda.z __5
    adc.z __4
    sta.z __5
    lda.z __5+1
    adc.z __4+1
    sta.z __5+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    // *SAVMSC + (word)(*ROWCRS)*CONIO_WIDTH
    clc
    lda.z __1
    adc.z SAVMSC
    sta.z __1
    lda.z __1+1
    adc.z SAVMSC+1
    sta.z __1+1
    // *SAVMSC + (word)(*ROWCRS)*CONIO_WIDTH + *COLCRS
    clc
    lda.z return
    adc.z COLCRS
    sta.z return
    lda.z return+1
    adc.z COLCRS+1
    sta.z return+1
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(__zp($80) void *destination, __zp($84) char *source, unsigned int num)
memcpy: {
    .const num = $28*$17
    .label src_end = $88
    .label dst = $80
    .label src = $84
    .label destination = $80
    .label source = $84
    // char* src_end = (char*)source+num
    lda.z source
    clc
    adc #<num
    sta.z src_end
    lda.z source+1
    adc #>num
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __zp($86) unsigned int utoa_append(__zp($8c) char *buffer, __zp($86) unsigned int value, __zp($8a) unsigned int sub)
utoa_append: {
    .label buffer = $8c
    .label value = $86
    .label sub = $8a
    .label return = $86
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
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // create a static table to map char value to screen value
  // use KickAsm functions to create a table of code -> screen code values, using cc65 algorithm
rawmap:
.var ht = Hashtable().put(0,64, 1,0, 2,32, 3,96) // the table for converting bit 6,7 into ora value
	.for(var i=0; i<256; i++) {
		.var idx = (i & $60) / 32
		.var mask = i & $9f
		.byte mask | ht.get(idx)
	}

  map: .text ".#......##..#.....#....#.#.#....#.#...#.##.#..........#...##...........#.....#.####........#........#.#...#.#.................#....#...#.#...#.#...#.#........#...........#..#.........#.#....#..#....#..#..#.#...#..##..#...........#..#.....#.......#.#..#...#...#.###...#...#.#...#.#...#.#.......#...#...#...##.##..#..................#.#.#....#..#.##....#........##...............#....#....#.#.......#.....##.#..##.#.....###.......#...........#...###....#..#.#...#..................#.........#.##...#......#.............#....#...#.#..#......#.###....#...#.....#..#........#.....#.....#...#..#.......#...#..............#..#...#...#........#...##........#..#........#....#......#......#.....#..#.###.......##....#.#..#..#..###..#..........................#...#....#.........#.#.......#.##................#..#.......#......######.....#.........#......##.......#....#..##.###..#...##.###..#.......#....#.......#.###...#.#.#........#........###...#.......#..........#.#..........#...#..........##.#....#....#........#.....#....#..#..#...#.#....##..#...##....#...........##...#..##.....#.......###.......#.#...#...#.......#.#....#.#....##.###........#..........#..............#....##..###......#.#....#.#......#.....##.....#....#..#......#...#........#.##..#.....#..#....#......#......#.#.#..........##....#.............#..#..........#.#......##..#...#......#.#..#....#....#.#..##.......#.#......##........#.#....#.#.....#..............#.........#.......#..#.#......##.........#..##.#......#......#..#.....#...#.....#.........#...........#..##..##.#..##...###..##.....#...#..##...##.#.#......#..........#.#.....##.#....#..##..#..#.........###.......#........##....#...##....##............#.#.##...............#....#..#......#.....#..#..#.#.....#.....##.#....#.#.....#.#.#.........#..#.#..##....#.....#....#.#...#.....#....#....#.#.#...........#................#.......#.......#..#.#...#.#......#..#.#...........#....#....###...#.#.#.##....##..###.#.#......#.##.#..##...#.#..#..#...#.....#.#.#.#.....###.#..#.#...#.#......#.#..##.#...#...#.#.....#.#.......#....#...#.##......#.#......#....#.....##.....#....................###...##.#...........#.......#..##.....##....#................#..#......#..........#........##..##.#...#...#.#.....#.##.#.....###..###.#...#.#..#....#.#..........#...#..#.#.#..#...#.##.##..#..#....#....####..........#..#.#..........#..........###...#.#..#..#...#..###.......####.#...#....#..#...#..#...........##....#.#...#....##....##.....#.#.##....#.##..#....#.#.#.#......#..#.###....#####.##......##..#.#.#..#........##.##..###.#...#..#..#......#..#.....#...###.....#.#....#.#..##.....#.#....#......#.#...#...#.#....#.#.....#.###.##...................#..........#........#.#...##.#.##......#.#.#..#....##.###..#...#.##....#....#.........#.#..#........#..#..#.#.####.....##..#..#.##.#......#.#..##.#...#..#..#.#.##..#.##..........#......##.#.....#.#.##..#..##.....##.#.##........#..#.....#...#.##.##...#....#.#.#.........##.....#....#....#.#....#...#..#.............#...#..#...#.##......##...##.........#......#..........##.#......#.....##....#.#.#.....#..#.###......#..#.#....#.....#..#.......#...#...#.#.#.#..##......#..............#...###.....#...##......#.#..#.#........#.#...##.#....#..........##...#.#....#...#.....#.######...##...#..#...#...#............#.....#....###..###.##..#.........#.......#........##..#....#...#.#..##.#.#.##.#.#...###.................#.#.#......#.#.#....#.....#.#.#...........#.##.#..#.###......###.#....#...........##.#.#....#...#...........#..##..........#...#.#...........#..###....#..##.......#.....#.....##....#..#.......#........#...##.##..#.#....#..###..#.....##.......#.........###.#...#..#....#.#...#....#..#.......##...#.#.#...#..........#..#.......#.......##.#..#.#....###.....#...#..#...#....#...#.##.#........#..........##.....#.#.##.#.#..#..##.......##.#.#.......##....#.#...........#..##.............##...#.#..#..#...........#.#......#.##.##..#...#...#...........#....###.#.#.##..#.#.#....#....#####.........#...#.....#.#....#............#..#........#.....#.#......#...#.........#...#...#.#.#..#.....##.##......#.#...#.......#...#.##...#..#..........#...#.....##..........#..#...#.#......#.......##......#...##..##..#....#..##.......#...#.#..##..#..#.....#.#................#....#.......#..#..###.......#...............##.....#..#......#....#.........#...###...#....#..##...#.#.#.........#.......#...#....#....#.#...#.#....##....#.#..##.#.....#..#..#....#..#.#..##.....##..#..#.#.#....#...#....#..#..........###.....#...##.#..#.#...#.#.#.#..#.##........#.#....#....#..........#....#.#.......#...#.....#........#........#....#..#.#..#...#...................#....####..#..#..#..#....#..#.#...##.#..........#.##..#.....##...................##..........#....##....###.....#..#...#.#....##.........#..#...................##..###....#.##............#.#...###.#..##...#...........#.....#..#......#.....#...........#..##...#.....#.....#.#............#....###.#..#.#.#....#..##...#.......#.##.....#..........#.#..#...#.............##...........#..............#.....#..#......#......###....#...#...........#.....#...#.......###.....#..........##......##.#.#.....#....#.......#..#......#.......#..#...#.###...........#..#.###......#...#.#...........#.#...##........#.#.#........#.#.....#.....##..##.#.#..#.#....#.#.##....#.#.#......##.....#...#.#...###...#..#......#.#.#..#...#........#..##...........#..#..#..#..#..##...#...#...##.#..#.#....#.#.....####.#..#..#....##..#.#..#....#..#......#.....#.#.#........#..#.....#......#............#.#..###.....#...#...#.....##..#.#...##..#...........####....#.##....##.#......#.....##.#..#.##..#....#.###..........##....###...#......#.#....##...........................#..#.....#..#.#...#.#..#.....#...#..####.##....#.##..##...##.##.....#......#...#.##...........#.......##.###..#.....##...#.........##....###....##...###................#....#####........#.#.#.##.....#.#....####.##........#............#......#........................###.....##......#..##.#......#.#...........##.#....##.#....................#.#.#.......#.#.#........#..#.......##.......#...#...#....#......#....##.##..#..............#......#....#......#.........##..................#.#....##..#.......#............#.......#...........#........#....#.#..##.#....#...#....#.#.#..#..#.#.#.#...#....#....#.#.#....#...#.#..#......#.....#.#...........#.#....##.....#...........#...#....#....##.....###..#..........#..#..#.....#....#.#.###..........#.##....#...##..#................#.##.##.......#...#.##...##...#.........#..#....#......#......#.........#.##...#...##.#.........#......#........#.....#....................#...#.....##.........#.#..#...#......#...#.......#......#.##.......#...#.##.#..##..#.......#.#............#...###..#........#.......##.......#....#..#.......#..#.#....#.#.............#....#...##.##....#....##..............#......#.......#....#....#..#..##......##.#..#.#..##......##......#.##.##......#.............##.#...#.....#.......#...##.#....#..#......#.##.........##.####.#...#.#....#..........#........#.....#..#....#...#.####....##......#..#..#.##..#.............###.#..#..#....#.......#.........#....#.....#....#.#.#...#.#.....##.#...#...#.#..#.....##......##.##.#.....#..#.......#.##...##.......#..##......#..........#..#....#.......#.#...#.....#.................#..............#.#.#.....#.#....#..#.......#..........#.##....#....#..#.....#.......#........#....#.....##..#.........##..#..#.#..##.#...#..........#....#..........#..#.#......#.##..#..#.##.....##.####....#.....#.#...##.....#.#....#.#........#..........#...#.#.##.##....##..#...#...#....#.#.......#..#...#..#..##..#.....#....#........###.....#..........#..#.##....#.#.....#........##....#....#.......#.....#..........#........###...##.....#.#..#...##.........#.#..#....#...##...........#.........#...#......#.#.#.........#..#.#.#...........##.###....#..#.......#.....#.#...#......#..#........##.#....##....#...#.##.........#.####.#..#...........##.#.#........#....#..#.....#..##.####.#...##...#...........#.#.........##.#..#..#...#.#.#.........#..#.#......###............#...#......#.......#....#...#...#..#...##.#.#...##..#...#...#.......##.......#.#.......#..........#.#................#...#..#...#.#...#.#...##.####..##.##....#..##.#..####.......##.#........#...#......###....##...#.#..#.##.....##.....###..#...#.###.###.......#...#.....#...#..#..##..#.......#...##.....##........#.#.##..#...#..#....#....#..###....#.#..#.#.#.#.#..........#.#..#..##.......###.....................##.#......#.##.....#.........#.......................#.#.....##..#........##.......#..##..#.##.#.#.....##.#.##.##.#....##....#...#.....#.........#.....#.....#.........#.##.#.###.#......#.........#..#.##...#.......###......##........#......#...........#.#...##...#........#.##.............##............#.####..#....#...#...#..#....#..#.#.#.#..#.........#......#.##............#.....#........#........#.#.##.#..#.#..#..###......###....#.###.....#.#.#.##........#..###.#..#...##.....#....#...#.#.........#....#.....#...#............#........##.......#.##..####..#..#....#....#..#..#...#.##...##.....#............#...#...........#.......#.....#...#.#.#...........#.....#...##...............#........##...........#...#.#..##.#...#....#....#........#.##..#.#.......#...#......#..............#.#..#..#.....##.#..#....#.##.......#......#.##..#......#........#.##.#...#.....#......###..#.......##....................#.#.#.....#.##.......#.......#....#......#.#.....#...##........#...#..#.#.........#.##...........#.##...##......#....#.###.#.#.#...####..#....###..........#...#.....##....#.#.##.###..###.#.#.....#.##.........#..#...#.#.................##.###.........#.#....#.#...#.###..#.#....#..............#.##.#......#..#....##.#..#.......#..##..#..#.###......##..........#..#.##....#.#....#....#.#..#.............#.....#..#....#.##...#..#.#.#.........###..#..#.....#.....##..##...##....#..#......#............#....#..........#....#..##..#...#......#.....#.#....#..##..#....#.#.#...#................##..#.........#........#..##..#..#......###.....#..#.........#..#.##..........#.#..#..."
  .byte 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
