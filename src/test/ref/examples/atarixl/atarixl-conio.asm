// Example usages of conio for Atari XL target.
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="atarixl-conio.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=__start]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
  .const DARK_ORANGE = $30
  .const MEDIUM_BLUE = $80
  .const WHITE = $fe
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// 2-byte saved memory scan counter
  .label SAVMSC = $58
  /// data under cursor
  .label OLDCHR = $5d
  /// 2-byte saved cursor memory address
  .label OLDADR = $5e
  /// Shadow for 53271 ($D017). Text color in Gr.0
  .label COLOR1 = $2c5
  /// Shadow for 53272 ($D018). Background color in GR.0
  .label COLOR2 = $2c6
  /// Shadow for 53274 ($D01A). Border color in GR.0
  .label COLOR4 = $2c8
  /// Cursor inhibit flag, 0 turns on, any other number turns off. Cursor doesn't change until it moves next.
  .label CRSINH = $2f0
  /// Internal hardware value for the last key pressed. Set to 0xFF to clear.
  .label CH = $2fc
  /// Atari ZP registers
  /// 1-byte cursor row
  .label ROWCRS = $54
  /// 2-byte cursor column
  .label COLCRS = $55
  // The screen width
  // The screen height
  // The current reverse value indicator. Values 0 or 0x80 for reverse text
  .label conio_reverse_value = $91
  // The current cursor enable flag. 1 = on, 0 = off.
  .label conio_display_cursor = $8f
  // The current scroll enable flag. 1 = on, 0 = off.
  .label conio_scroll_enable = $92
.segment Code
__start: {
    // __ma char conio_reverse_value = 0
    lda #0
    sta.z conio_reverse_value
    // __ma char conio_display_cursor = 1
    lda #1
    sta.z conio_display_cursor
    // __ma char conio_scroll_enable = 1
    sta.z conio_scroll_enable
    jsr main
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($90) volatile char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label convertToScreenCode1_v = c
    .label c = $90
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // if (c == '\r')
  .encoding "ascii"
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
main: {
    .label i = $93
    .label i1 = $95
    // cursor(0)
    // hide the cursor
    jsr cursor
    // bgcolor(DARK_ORANGE)
    // change colors
    jsr bgcolor
    // bordercolor(MEDIUM_BLUE)
    jsr bordercolor
    // textcolor(WHITE)
    jsr textcolor
    // cputsxy(0, 1, "Hello, World!\n")
  // print some text at a location
    jsr cputsxy
    // gotoxy(0, 3)
  // skip a line
    ldx #3
    lda #0
    jsr gotoxy
    // revers(1)
  // set inverse text and use printf to output a string
    lda #1
    jsr revers
    // printf("Hello, %s - press a key!\n", name)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("Hello, %s - press a key!\n", name)
    jsr printf_string
    // printf("Hello, %s - press a key!\n", name)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // waitkey()
  // wait for user keypress
    jsr waitkey
    // clrscr()
    // clear screen
    jsr clrscr
    // revers(0)
  // reset reverse and do some scrolling lines.
    lda #0
    jsr revers
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // printf("Scrolling lines ... %d\n", i)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // printf("Scrolling lines ... %d\n", i)
    lda.z i
    sta.z printf_sint.value
    lda.z i+1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("Scrolling lines ... %d\n", i)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // for(int i: 0..50)
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$33
    bne __b1
    lda.z i
    cmp #<$33
    bne __b1
    // waitkey()
    jsr waitkey
    // scroll(0)
    // turn scroll off and do more lines
    jsr scroll
    lda #<$33
    sta.z i1
    lda #>$33
    sta.z i1+1
  __b3:
    // printf("Some wrapping lines ... %d\n", i)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // printf("Some wrapping lines ... %d\n", i)
    lda.z i1
    sta.z printf_sint.value
    lda.z i1+1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("Some wrapping lines ... %d\n", i)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // for(int i: 51..200)
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    lda.z i1+1
    cmp #>$c9
    bne __b3
    lda.z i1
    cmp #<$c9
    bne __b3
    // waitkey()
    jsr waitkey
    // }
    rts
  .segment Data
    name: .text "Mark"
    .byte 0
    s: .text @"Hello, World!\$9b"
    .byte 0
    s1: .text "Hello, "
    .byte 0
    s2: .text @" - press a key!\$9b"
    .byte 0
    s3: .text "Scrolling lines ... "
    .byte 0
    s4: .text @"\$9b"
    .byte 0
    s5: .text "Some wrapping lines ... "
    .byte 0
}
.segment Code
// Puts a character to the screen a the current location. Uses internal screencode. Deals with storing the old cursor value
// void putchar(char code)
putchar: {
    .label loc = $82
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
    ora.z conio_reverse_value
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
    .label loc = $82
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
    // if (conio_display_cursor == 0)
    lda.z conio_display_cursor
    beq __b1
    // *CRSINH = 0
    // cursor is on, so invert the inverse bit and turn cursor on
    tya
    sta CRSINH
    // c = c ^ 0x80
    txa
    eor #$80
    tax
  __b2:
    // **OLDADR = c
    txa
    ldy.z OLDADR
    sty.z $fe
    ldy.z OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // }
    rts
  __b1:
    // *CRSINH = 1
    // cursor is off, don't affect the character at all, but do turn off cursor
    lda #1
    sta CRSINH
    jmp __b2
}
newline: {
    .label start = $84
    // if ((*ROWCRS)++ == CONIO_HEIGHT)
    inc.z ROWCRS
    lda #$18
    cmp.z ROWCRS
    bne __b1
    // if (conio_scroll_enable == 1)
    lda #1
    cmp.z conio_scroll_enable
    beq __b4
    // gotoxy(0, 0)
    ldx #0
    txa
    jsr gotoxy
  __b1:
    // setcursor()
    jsr setcursor
    // }
    rts
  __b4:
    // if (conio_display_cursor == 1)
    lda #1
    cmp.z conio_display_cursor
    bne __b5
    // **OLDADR ^= 0x80
    ldy.z OLDADR
    sty.z $fe
    ldy.z OLDADR+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    eor #$80
    sta ($fe),y
  __b5:
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
    lda #0
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
    jmp __b1
}
// If onoff is 1, a cursor is displayed when any text is output.
// If onoff is 0, the cursor is hidden instead.
// char cursor(char onoff)
cursor: {
    .const onoff = 0
    // conio_display_cursor = onoff
    lda #onoff
    sta.z conio_display_cursor
    // }
    rts
}
// Set the color for the background. The old color setting is returned.
// char bgcolor(char color)
bgcolor: {
    // *COLOR2 = color
    lda #DARK_ORANGE
    sta COLOR2
    // }
    rts
}
// Set the color for the border. The old color setting is returned.
// char bordercolor(char color)
bordercolor: {
    // *COLOR4 = color
    lda #MEDIUM_BLUE
    sta COLOR4
    // }
    rts
}
// Set the color for the text. The old color setting is returned.
// char textcolor(char color)
textcolor: {
    // *COLOR1 = color
    lda #WHITE
    sta COLOR1
    // }
    rts
}
// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
// void cputsxy(char x, char y, const char *s)
cputsxy: {
    .const x = 0
    .const y = 1
    // gotoxy(x, y)
    ldx #y
    lda #x
    jsr gotoxy
    // cputs(s)
    jsr cputs
    // }
    rts
}
// Set the cursor to the specified position
// void gotoxy(__register(A) char x, __register(X) char y)
gotoxy: {
    // *COLCRS = x
    sta.z COLCRS
    lda #0
    sta.z COLCRS+1
    // *ROWCRS = y
    stx.z ROWCRS
    // setcursor()
    jsr setcursor
    // }
    rts
}
// Sets reverse mode for text. 1 enables reverse, 0 disables. Returns the old value.
// char revers(__register(A) char onoff)
revers: {
    // if (onoff == 0)
    cmp #0
    beq __b1
    // conio_reverse_value = 0x80
    lda #$80
    sta.z conio_reverse_value
    // }
    rts
  __b1:
    // conio_reverse_value = 0
    lda #0
    sta.z conio_reverse_value
    rts
}
/// Print a NUL-terminated string
// void printf_str(__zp($80) void (*putc)(char), __zp($8c) const char *s)
printf_str: {
    .label s = $8c
    .label putc = $80
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
// Print a string value using a specific format
// Handles justification and min length 
// void printf_string(void (*putc)(char), char *str, char format_min_length, char format_justify_left)
printf_string: {
    .label putc = cputc
    // printf_str(putc, str)
    lda #<putc
    sta.z printf_str.putc
    lda #>putc
    sta.z printf_str.putc+1
    lda #<main.name
    sta.z printf_str.s
    lda #>main.name
    sta.z printf_str.s+1
    jsr printf_str
    // }
    rts
}
waitkey: {
  __b1:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b1
    // *CH = 0xff
    lda #$ff
    sta CH
    // }
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
    tax
    txa
    jsr gotoxy
    // }
    rts
}
// Print a signed integer using a specific format
// void printf_sint(void (*putc)(char), __zp($80) int value, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_sint: {
    .label value = $80
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
    lda #0
    sec
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
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
// char scroll(char onoff)
scroll: {
    .const onoff = 0
    // conio_scroll_enable = onoff
    lda #onoff
    sta.z conio_scroll_enable
    // }
    rts
}
// Return a pointer to the location of the cursor
cursorLocation: {
    .label __0 = $82
    .label __1 = $82
    .label __3 = $82
    .label return = $82
    .label __4 = $8a
    .label __5 = $82
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
// void * memcpy(__zp($82) void *destination, __zp($88) char *source, unsigned int num)
memcpy: {
    .const num = $28*$17
    .label src_end = $8a
    .label dst = $82
    .label src = $88
    .label destination = $82
    .label source = $88
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp($84) char *str, char c, __zp($88) unsigned int num)
memset: {
    .label end = $88
    .label dst = $84
    .label str = $84
    .label num = $88
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
// Output a NUL-terminated string at the current cursor position
// void cputs(__zp($8c) const char *s)
cputs: {
    .label s = $8c
    lda #<main.s
    sta.z s
    lda #>main.s
    sta.z s+1
  __b1:
    // while (c = *s++)
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
    // cputc(c)
    pha
    jsr cputc
    pla
    jmp __b1
}
// Return 1 if there's a key waiting, return 0 if not
kbhit: {
    // if (*CH == 0xff)
    lda #$ff
    cmp CH
    beq __b1
    lda #1
    rts
  __b1:
    lda #0
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__zp($80) unsigned int value, __zp($8c) char *buffer, char radix)
utoa: {
    .label digit_value = $86
    .label buffer = $8c
    .label digit = $8e
    .label value = $80
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __zp($80) unsigned int utoa_append(__zp($8c) char *buffer, __zp($80) unsigned int value, __zp($86) unsigned int sub)
utoa_append: {
    .label buffer = $8c
    .label value = $80
    .label sub = $86
    .label return = $80
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

  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
