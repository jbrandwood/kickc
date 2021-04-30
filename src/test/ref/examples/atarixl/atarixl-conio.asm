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
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // 2-byte saved memory scan counter
  .label SAVMSC = $58
  // data under cursor
  .label OLDCHR = $5d
  // 2-byte saved cursor memory address
  .label OLDADR = $5e
  // Shadow for 53271 ($D017). Text color in Gr.0
  .label COLOR1 = $2c5
  // Shadow for 53272 ($D018). Background color in GR.0
  .label COLOR2 = $2c6
  // Shadow for 53274 ($D01A). Border color in GR.0
  .label COLOR4 = $2c8
  // Cursor inhibit flag, 0 turns on, any other number turns off. Cursor doesn't change until it moves next.
  .label CRSINH = $2f0
  // Internal hardware value for the last key pressed. Set to 0xFF to clear.
  .label CH = $2fc
  // Atari ZP registers
  // 1-byte cursor row
  .label ROWCRS = $54
  // 2-byte cursor column
  .label COLCRS = $55
  // The screen width
  // The screen height
  // The current reverse value indicator. Values 0 or 0x80 for reverse text
  .label conio_reverse_value = $87
  // The current cursor enable flag. 1 = on, 0 = off.
  .label conio_display_cursor = $88
  // The current scroll enable flag. 1 = on, 0 = off.
  .label conio_scroll_enable = $89
.segment Code
__start: {
    // conio_reverse_value = 0
    lda #0
    sta.z conio_reverse_value
    // conio_display_cursor = 1
    lda #1
    sta.z conio_display_cursor
    // conio_scroll_enable = 1
    sta.z conio_scroll_enable
    jsr main
    rts
}
main: {
    .label i = $80
    .label i1 = $82
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
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("Hello, %s - press a key!\n", name)
    jsr printf_string
    // printf("Hello, %s - press a key!\n", name)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
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
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("Scrolling lines ... %d\n", i)
    lda.z i
    sta.z printf_sint.value
    lda.z i+1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("Scrolling lines ... %d\n", i)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
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
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // printf("Some wrapping lines ... %d\n", i)
    lda.z i1
    sta.z printf_sint.value
    lda.z i1+1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("Some wrapping lines ... %d\n", i)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
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
  .encoding "ascii"
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
// If onoff is 1, a cursor is displayed when any text is output.
// If onoff is 0, the cursor is hidden instead.
cursor: {
    .const onoff = 0
    // conio_display_cursor = onoff
    lda #onoff
    sta.z conio_display_cursor
    // }
    rts
}
// Set the color for the background. The old color setting is returned.
bgcolor: {
    // *COLOR2 = color
    lda #DARK_ORANGE
    sta COLOR2
    // }
    rts
}
// Set the color for the border. The old color setting is returned.
bordercolor: {
    // *COLOR4 = color
    lda #MEDIUM_BLUE
    sta COLOR4
    // }
    rts
}
// Set the color for the text. The old color setting is returned.
textcolor: {
    // *COLOR1 = color
    lda #WHITE
    sta COLOR1
    // }
    rts
}
// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
cputsxy: {
    .const x = 0
    .const y = 1
    // gotoxy(x, y)
    ldx #y
    lda #x
    jsr gotoxy
    // cputs(s)
    lda #<main.s
    sta.z cputs.s
    lda #>main.s
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
}
// Set the cursor to the specified position
// gotoxy(byte register(A) x, byte register(X) y)
gotoxy: {
    // *COLCRS = x
    sta COLCRS
    lda #0
    sta COLCRS+1
    // *ROWCRS = y
    stx ROWCRS
    // setcursor()
    jsr setcursor
    // }
    rts
}
// Sets reverse mode for text. 1 enables reverse, 0 disables. Returns the old value.
// revers(byte register(A) onoff)
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
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp($84) s)
cputs: {
    .label s = $84
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
    sta.z cputc.c
    jsr cputc
    jmp __b1
}
// Print a string value using a specific format
// Handles justification and min length 
printf_string: {
    // cputs(str)
    lda #<main.name
    sta.z cputs.s
    lda #>main.name
    sta.z cputs.s+1
    jsr cputs
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
    lda SAVMSC
    sta.z memset.str
    lda SAVMSC+1
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
    sta OLDCHR
    // gotoxy(0,0)
    tax
    txa
    jsr gotoxy
    // }
    rts
}
// Print a signed integer using a specific format
// printf_sint(signed word zp($84) value)
printf_sint: {
    .label value = $84
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
// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
scroll: {
    .const onoff = 0
    // conio_scroll_enable = onoff
    lda #onoff
    sta.z conio_scroll_enable
    // }
    rts
}
// Handles cursor movement, displaying it if required, and inverting character it is over if there is one (and enabled)
setcursor: {
    .label loc = $8b
    // **OLDADR = *OLDCHR
    // save the current oldchr into oldadr
    lda OLDCHR
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // cursorLocation()
    jsr cursorLocation
    // loc = cursorLocation()
    // c = *loc
    ldy #0
    lda (loc),y
    tax
    // *OLDCHR = c
    stx OLDCHR
    // *OLDADR = loc
    lda.z loc
    sta OLDADR
    lda.z loc+1
    sta OLDADR+1
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
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
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
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($8a) c)
cputc: {
    .label convertToScreenCode1_v = c
    .label c = $8a
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
    inc COLCRS
    bne !+
    inc COLCRS+1
  !:
    // if (*COLCRS == CONIO_WIDTH)
    lda COLCRS+1
    bne !+
    lda COLCRS
    cmp #$28
    beq __b5
  !:
    // setcursor()
    jsr setcursor
    // }
    rts
  __b5:
    // *COLCRS = 0
    lda #0
    sta COLCRS+1
    sta COLCRS
    // newline()
    jsr newline
    rts
  __b2:
    // *COLCRS = 0
    // 0x0a LF, or atascii EOL
    lda #0
    sta COLCRS+1
    sta COLCRS
    // newline()
    jsr newline
    rts
  __b1:
    // *COLCRS = 0
    // 0x0d, CR = just set the cursor x value to 0
    lda #0
    sta COLCRS+1
    sta COLCRS
    // setcursor()
    jsr setcursor
    rts
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(byte* zp($8d) str, word zp($8b) num)
memset: {
    .label end = $8b
    .label dst = $8d
    .label str = $8d
    .label num = $8b
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($84) value, byte* zp($8b) buffer)
utoa: {
    .label digit_value = $8d
    .label buffer = $8b
    .label digit = $86
    .label value = $84
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
    sta.z cputc.c
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
// Return a pointer to the location of the cursor
cursorLocation: {
    .label __0 = $8b
    .label __1 = $8b
    .label __3 = $8b
    .label return = $8b
    .label __4 = $8f
    .label __5 = $8b
    // (word)(*ROWCRS)*CONIO_WIDTH
    lda ROWCRS
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
    lda.z __5
    clc
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
    adc SAVMSC
    sta.z __1
    lda.z __1+1
    adc SAVMSC+1
    sta.z __1+1
    // *SAVMSC + (word)(*ROWCRS)*CONIO_WIDTH + *COLCRS
    clc
    lda COLCRS
    adc.z return
    sta.z return
    lda COLCRS+1
    adc.z return+1
    sta.z return+1
    // }
    rts
}
// Puts a character to the screen a the current location. Uses internal screencode. Deals with storing the old cursor value
putchar: {
    .label loc = $8b
    // **OLDADR = *OLDCHR
    lda OLDCHR
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // cursorLocation()
    jsr cursorLocation
    // loc = cursorLocation()
    // newChar = code | conio_reverse_value
    txa
    ora.z conio_reverse_value
    // *loc = newChar
    ldy #0
    sta (loc),y
    // *OLDCHR = newChar
    sta OLDCHR
    // setcursor()
    jsr setcursor
    // }
    rts
}
newline: {
    .label start = $8d
    // if ((*ROWCRS)++ == CONIO_HEIGHT)
    inc ROWCRS
    lda #$18
    cmp ROWCRS
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
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    eor #$80
    sta ($fe),y
  __b5:
    // start = *SAVMSC
    // move screen up 1 line
    lda SAVMSC
    sta.z start
    lda SAVMSC+1
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
    clc
    lda.z memset.str
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
    sta ROWCRS
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
// utoa_append(byte* zp($8b) buffer, word zp($84) value, word zp($8d) sub)
utoa_append: {
    .label buffer = $8b
    .label value = $84
    .label sub = $8d
    .label return = $84
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
// memcpy(void* zp($8f) destination, byte* zp($8b) source)
memcpy: {
    .const num = $28*$17
    .label src_end = $91
    .label dst = $8f
    .label src = $8b
    .label destination = $8f
    .label source = $8b
    // src_end = (char*)source+num
    clc
    lda.z source
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
