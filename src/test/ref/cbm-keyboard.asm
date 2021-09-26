  // Commodore 64 PRG executable file
.file [name="cbm-keyboard.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const LIGHT_BLUE = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_MOS6569_VICII_MEMORY = $18
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// Color Ram
  .label COLORRAM = $d800
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  /// Default address of the chargen font (mixed case)
  .label DEFAULT_FONT_MIXED = $1800
  // The current text cursor line start
  .label conio_line_text = $e
  // The current color cursor line start
  .label conio_line_color = $c
.segment Code
__start: {
    // __ma char *conio_line_text = CONIO_SCREEN_TEXT
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // __ma char *conio_line_color = CONIO_SCREEN_COLORS
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
    sta.z conio_line_color+1
    // #pragma constructor_for(conio_c64_init, cputc, clrscr, cscroll)
    jsr conio_c64_init
    jsr main
    rts
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    // char line = *BASIC_CURSOR_LINE
    ldx BASIC_CURSOR_LINE
    // if(line>=CONIO_HEIGHT)
    cpx #$19
    bcc __b1
    ldx #$19-1
  __b1:
    // gotoxy(0, line)
    jsr gotoxy
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__register(A) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    // if(c=='\n')
    cmp #'\n'
    beq __b1
    // conio_line_text[conio_cursor_x] = c
    ldy conio_cursor_x
    sta (conio_line_text),y
    // conio_line_color[conio_cursor_x] = conio_textcolor
    lda conio_textcolor
    sta (conio_line_color),y
    // if(++conio_cursor_x==CONIO_WIDTH)
    inc conio_cursor_x
    lda #$28
    cmp conio_cursor_x
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
// Show the currently pressed key
main: {
    .const toD0181_return = (>(DEFAULT_SCREEN&$3fff)*4)|(>DEFAULT_FONT_MIXED)/4&$f
    // VICII->MEMORY = toD018(DEFAULT_SCREEN, DEFAULT_FONT_MIXED)
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // clrscr()
    jsr clrscr
    lda #0
    sta current
  __b1:
    // char ch = GETIN()
    jsr GETIN
    sta ch
    // if(ch && ch!=current)
    beq __b1
    cmp current
    bne __b2
    jmp __b1
  __b2:
    // petscii_to_screencode(ch)
    lda ch
    jsr petscii_to_screencode
    sta __6
    // printf("'%c'($%2x) ", petscii_to_screencode(ch), ch)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // printf("'%c'($%2x) ", petscii_to_screencode(ch), ch)
    lda __6
    pha
    jsr cputc
    pla
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("'%c'($%2x) ", petscii_to_screencode(ch), ch)
    ldx ch
    jsr printf_uchar
    // printf("'%c'($%2x) ", petscii_to_screencode(ch), ch)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    lda ch
    sta current
    jmp __b1
  .segment Data
    s: .text "'"
    .byte 0
    s1: .text "'($"
    .byte 0
    s2: .text ") "
    .byte 0
    __6: .byte 0
    ch: .byte 0
    current: .byte 0
}
.segment Code
// Set the cursor to the specified position
// void gotoxy(char x, __register(X) char y)
gotoxy: {
    .label __5 = 8
    .label __6 = $a
    // if(y>CONIO_HEIGHT)
    cpx #$19+1
    bcc __b2
    ldx #0
  __b2:
    // conio_cursor_x = x
    lda #0
    sta conio_cursor_x
    // conio_cursor_y = y
    stx conio_cursor_y
    // unsigned int line_offset = (unsigned int)y*CONIO_WIDTH
    txa
    sta __7
    lda #0
    sta __7+1
    lda __7
    asl
    sta __8
    lda __7+1
    rol
    sta __8+1
    asl __8
    rol __8+1
    clc
    lda __9
    adc __8
    sta __9
    lda __9+1
    adc __8+1
    sta __9+1
    asl line_offset
    rol line_offset+1
    asl line_offset
    rol line_offset+1
    asl line_offset
    rol line_offset+1
    // CONIO_SCREEN_TEXT + line_offset
    lda line_offset
    clc
    adc #<DEFAULT_SCREEN
    sta.z __5
    lda line_offset+1
    adc #>DEFAULT_SCREEN
    sta.z __5+1
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    lda.z __5
    sta.z conio_line_text
    lda.z __5+1
    sta.z conio_line_text+1
    // CONIO_SCREEN_COLORS + line_offset
    lda line_offset
    clc
    adc #<COLORRAM
    sta.z __6
    lda line_offset+1
    adc #>COLORRAM
    sta.z __6+1
    // conio_line_color = CONIO_SCREEN_COLORS + line_offset
    lda.z __6
    sta.z conio_line_color
    lda.z __6+1
    sta.z conio_line_color+1
    // }
    rts
  .segment Data
    __7: .word 0
    .label line_offset = __7
    __8: .word 0
    .label __9 = __7
}
.segment Code
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
    sta conio_cursor_x
    // conio_cursor_y++;
    inc conio_cursor_y
    // cscroll()
    jsr cscroll
    // }
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = $10
    .label line_cols = $12
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
    sta conio_cursor_x
    // conio_cursor_y = 0
    sta conio_cursor_y
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
    lda conio_textcolor
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b3
}
// GETIN. Read byte from default input. (If not keyboard, must call OPEN and CHKIN beforehands.)
// Return: next byte in buffer or 0 if buffer is empty.
GETIN: {
    .label ch = $ff
    // asm
    jsr $ffe4
    sta ch
    // return *ch;
    // }
    rts
}
// Convert a PETSCII char to screencode
// __register(A) char petscii_to_screencode(__register(A) char petscii)
petscii_to_screencode: {
    // if(petscii<32)
    cmp #$20
    bcc __b1
    // if(petscii<64)
    cmp #$40
    bcc __breturn
    // if(petscii<96)
    cmp #$60
    bcc __b2
    // if(petscii<128)
    cmp #$80
    bcc __b3
    // if(petscii<160)
    cmp #$a0
    bcc __b4
    // if(petscii<255)
    cmp #$ff
    bcc __b5
    lda #$5e
    rts
  __b5:
    // return petscii-128;
    sec
    sbc #$80
  __breturn:
    // }
    rts
  __b4:
    // return petscii+64;
    clc
    adc #$40
    rts
  __b3:
    // return petscii-32;
    sec
    sbc #$20
    rts
  __b2:
    // return petscii-64;
    sec
    sbc #$40
    rts
  __b1:
    // return petscii+128;
    clc
    adc #$80
    rts
}
/// Print a NUL-terminated string
// void printf_str(__zp($10) void (*putc)(char), __zp($12) const char *s)
printf_str: {
    .label s = $12
    .label putc = $10
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
    jsr icall2
    pla
    jmp __b1
  icall2:
    jmp (putc)
}
// Print an unsigned char using a specific format
// void printf_uchar(void (*putc)(char), __register(X) char uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uchar: {
    .label putc = cputc
    .label format_min_length = 2
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr uctoa
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
    sta printf_number_buffer.buffer_sign
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y==CONIO_HEIGHT)
    lda #$19
    cmp conio_cursor_y
    bne __breturn
    // if(conio_scroll_enable)
    lda conio_scroll_enable
    bne __b3
    // gotoxy(0,0)
    ldx #0
    jsr gotoxy
  __breturn:
    // }
    rts
  __b3:
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
    ldx conio_textcolor
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
    dec conio_cursor_y
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__register(X) char value, __zp($10) char *buffer, char radix)
uctoa: {
    .const max_digits = 2
    .label buffer = $10
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta started
    sta digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda digit
    cmp #max_digits-1
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
    // unsigned char digit_value = digit_values[digit]
    ldy digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta digit_value
    // if (started || value >= digit_value)
    lda started
    bne __b5
    cpx digit_value
    bcs __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc digit
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
    sta started
    jmp __b4
  .segment Data
    digit_value: .byte 0
    digit: .byte 0
    started: .byte 0
}
.segment Code
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __mem() char buffer_sign, char *buffer_digits, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // strlen(buffer.digits)
    jsr strlen
    // strlen(buffer.digits)
    // signed char len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    ldx __19
    // if(buffer.sign)
    lda buffer_sign
    beq __b8
    // len++;
    inx
  __b8:
    // padding = (signed char)format.min_length - len
    txa
    eor #$ff
    sec
    adc #printf_uchar.format_min_length
    // if(padding<0)
    cmp #0
    bpl __b1
    lda #0
  __b1:
    // if(!format.justify_left && !format.zero_padding && padding)
    cmp #0
    bne __b6
    jmp __b2
  __b6:
    // printf_padding(putc, ' ',(char)padding)
    sta printf_padding.length
    jsr printf_padding
  __b2:
    // if(buffer.sign)
    lda buffer_sign
    beq __b3
    // putc(buffer.sign)
    pha
    jsr cputc
    pla
  __b3:
    // printf_str(putc, buffer.digits)
    lda #<printf_uchar.putc
    sta.z printf_str.putc
    lda #>printf_uchar.putc
    sta.z printf_str.putc+1
    lda #<buffer_digits
    sta.z printf_str.s
    lda #>buffer_digits
    sta.z printf_str.s+1
    jsr printf_str
    // }
    rts
  .segment Data
    .label __19 = strlen.len
    buffer_sign: .byte 0
}
.segment Code
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(__zp(4) void *destination, __zp(2) void *source, unsigned int num)
memcpy: {
    .label src_end = 6
    .label dst = 4
    .label src = 2
    .label source = 2
    .label destination = 4
    // char* src_end = (char*)source+num
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
// void * memset(__zp(2) void *str, __register(X) char c, unsigned int num)
memset: {
    .label end = 4
    .label dst = 2
    .label str = 2
    // char* end = (char*)str + num
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __register(X) char uctoa_append(__zp($10) char *buffer, __register(X) char value, __mem() char sub)
uctoa_append: {
    .label buffer = $10
    ldy #0
  __b1:
    // while (value >= sub)
    cpx sub
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
    sbc sub
    tax
    jmp __b1
  .segment Data
    .label sub = uctoa.digit_value
}
.segment Code
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp($10) char *str)
strlen: {
    .label str = $10
    lda #<0
    sta len
    sta len+1
    lda #<printf_number_buffer.buffer_digits
    sta.z str
    lda #>printf_number_buffer.buffer_digits
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
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
  .segment Data
    len: .word 0
    .label return = len
}
.segment Code
// Print a padding char a number of times
// void printf_padding(void (*putc)(char), char pad, __mem() char length)
printf_padding: {
    .const pad = ' '
    lda #0
    sta i
  __b1:
    // for(char i=0;i<length; i++)
    lda i
    cmp length
    bcc __b2
    // }
    rts
  __b2:
    // putc(pad)
    lda #pad
    pha
    jsr cputc
    pla
    // for(char i=0;i<length; i++)
    inc i
    jmp __b1
  .segment Data
    i: .byte 0
    length: .byte 0
}
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // The number of bytes on the screen
  // The current cursor x-position
  conio_cursor_x: .byte 0
  // The current cursor y-position
  conio_cursor_y: .byte 0
  // The current text color
  conio_textcolor: .byte LIGHT_BLUE
  // Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
  // If disabled the cursor just moves back to (0,0) instead
  conio_scroll_enable: .byte 1
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
