// Test standard library <string.h> memchr()
  // Commodore 64 PRG executable file
.file [name="stdlib-string-memchr-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const RED = 2
  .const GREEN = 5
  .const LIGHT_BLUE = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // Color Ram
  .label COLORRAM = $d800
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $c
  // The current cursor y-position
  .label conio_cursor_y = $d
  // The current text cursor line start
  .label conio_line_text = $e
  // The current color cursor line start
  .label conio_line_color = $10
  // The current text color
  .label conio_textcolor = $12
.segment Code
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
    // conio_textcolor = CONIO_TEXTCOLOR_DEFAULT
    lda #LIGHT_BLUE
    sta.z conio_textcolor
    // #pragma constructor_for(conio_c64_init, cputc, clrscr, cscroll)
    jsr conio_c64_init
    jsr main
    rts
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    // line = *BASIC_CURSOR_LINE
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
main: {
    .label ptr = 2
    .label ptr2 = 2
    // clrscr()
    jsr clrscr
    // memchr( str, 'a', 14)
    lda #'a'
    sta.z memchr.c
    lda #<$e
    sta.z memchr.n
    lda #>$e
    sta.z memchr.n+1
    jsr memchr
    // memchr( str, 'a', 14)
    // assert_uint(8, (ptr-str), "finding a")
    lda.z assert_uint.actual
    sec
    sbc #<str
    sta.z assert_uint.actual
    lda.z assert_uint.actual+1
    sbc #>str
    sta.z assert_uint.actual+1
    jsr assert_uint
    // memchr( str, 'a', 7)
    lda #'a'
    sta.z memchr.c
    lda #<7
    sta.z memchr.n
    lda #>7
    sta.z memchr.n+1
    jsr memchr
    // memchr( str, 'a', 7)
    // assert_ptr((void*)0, ptr2, "not finding a")
    jsr assert_ptr
    // }
    rts
  .segment Data
    str: .text "this is a test"
    .byte 0
    message: .text "finding a"
    .byte 0
    message1: .text "not finding a"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .const x = 0
    .label __5 = $17
    .label __6 = $13
    .label __7 = $13
    .label line_offset = $13
    .label __8 = $15
    .label __9 = $13
    // if(y>CONIO_HEIGHT)
    cpx #$19+1
    bcc __b2
    ldx #0
  __b2:
    // conio_cursor_x = x
    lda #x
    sta.z conio_cursor_x
    // conio_cursor_y = y
    stx.z conio_cursor_y
    // (unsigned int)y*CONIO_WIDTH
    txa
    sta.z __7
    lda #0
    sta.z __7+1
    // line_offset = (unsigned int)y*CONIO_WIDTH
    lda.z __7
    asl
    sta.z __8
    lda.z __7+1
    rol
    sta.z __8+1
    asl.z __8
    rol.z __8+1
    lda.z __9
    clc
    adc.z __8
    sta.z __9
    lda.z __9+1
    adc.z __8+1
    sta.z __9+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    // CONIO_SCREEN_TEXT + line_offset
    clc
    lda.z line_offset
    adc #<DEFAULT_SCREEN
    sta.z __5
    lda.z line_offset+1
    adc #>DEFAULT_SCREEN
    sta.z __5+1
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    lda.z __5
    sta.z conio_line_text
    lda.z __5+1
    sta.z conio_line_text+1
    // CONIO_SCREEN_COLORS + line_offset
    clc
    lda.z __6
    adc #<COLORRAM
    sta.z __6
    lda.z __6+1
    adc #>COLORRAM
    sta.z __6+1
    // conio_line_color = CONIO_SCREEN_COLORS + line_offset
    lda.z __6
    sta.z conio_line_color
    lda.z __6+1
    sta.z conio_line_color+1
    // }
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 4
    .label line_cols = 8
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
    lda.z conio_textcolor
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b3
}
// Searches for the first occurrence of the character c (an unsigned char) in the first n bytes of the string pointed to, by the argument str.
// - str: The memory to search
// - c: A character to search for
// - n: The number of bytes to look through
// Return: A pointer to the matching byte or NULL if the character does not occur in the given memory area.
// memchr(byte zp(6) c, word zp(4) n)
memchr: {
    .label ptr = 2
    .label i = 8
    .label return = 2
    .label n = 4
    .label c = 6
    lda #<main.str
    sta.z ptr
    lda #>main.str
    sta.z ptr+1
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(size_t i=0;i<n;i++)
    lda.z i+1
    cmp.z n+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z n
    bcc __b2
  !:
    lda #<0
    sta.z return
    sta.z return+1
    // }
    rts
  __b2:
    // if(*ptr==c)
    ldy #0
    lda (ptr),y
    cmp.z c
    bne __b3
    rts
  __b3:
    // ptr++;
    inc.z ptr
    bne !+
    inc.z ptr+1
  !:
    // for(size_t i=0;i<n;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// assert_uint(word zp(2) actual)
assert_uint: {
    .const expect = 8
    .label actual = 2
    // if(expect!=actual)
    lda.z actual+1
    cmp #>expect
    bne __b1
    lda.z actual
    cmp #<expect
    bne __b1
    // textcolor(GREEN)
    lda #GREEN
    jsr textcolor
    // printf("ok! %s\n", message)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("ok! %s\n", message)
    lda #<main.message
    sta.z printf_string.str
    lda #>main.message
    sta.z printf_string.str+1
    jsr printf_string
    // printf("ok! %s\n", message)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  __b1:
    // textcolor(RED)
    lda #RED
    jsr textcolor
    // printf("Assert failed. expected:%u actual:%u. %s\n", expect, actual, message)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("Assert failed. expected:%u actual:%u. %s\n", expect, actual, message)
    ldx #DECIMAL
    lda #<expect
    sta.z printf_uint.uvalue
    lda #>expect
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("Assert failed. expected:%u actual:%u. %s\n", expect, actual, message)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("Assert failed. expected:%u actual:%u. %s\n", expect, actual, message)
    lda.z actual
    sta.z printf_uint.uvalue
    lda.z actual+1
    sta.z printf_uint.uvalue+1
    ldx #DECIMAL
    jsr printf_uint
    // printf("Assert failed. expected:%u actual:%u. %s\n", expect, actual, message)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("Assert failed. expected:%u actual:%u. %s\n", expect, actual, message)
    lda #<main.message
    sta.z printf_string.str
    lda #>main.message
    sta.z printf_string.str+1
    jsr printf_string
    // printf("Assert failed. expected:%u actual:%u. %s\n", expect, actual, message)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    rts
  .segment Data
    s: .text "Assert failed. expected:"
    .byte 0
    s1: .text " actual:"
    .byte 0
}
.segment Code
assert_ptr: {
    .label expect = 0
    // if(expect!=actual)
    lda.z main.ptr2+1
    cmp #>expect
    bne __b1
    lda.z main.ptr2
    cmp #<expect
    bne __b1
    // textcolor(GREEN)
    lda #GREEN
    jsr textcolor
    // printf("ok! %s\n", message)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("ok! %s\n", message)
    lda #<main.message1
    sta.z printf_string.str
    lda #>main.message1
    sta.z printf_string.str+1
    jsr printf_string
    // printf("ok! %s\n", message)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  __b1:
    // textcolor(RED)
    lda #RED
    jsr textcolor
    // printf("Assert failed. expected:0x%x actual:0x%x. %s\n", (unsigned int)expect, (unsigned int)actual, message)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("Assert failed. expected:0x%x actual:0x%x. %s\n", (unsigned int)expect, (unsigned int)actual, message)
    ldx #HEXADECIMAL
    lda #<0
    sta.z printf_uint.uvalue
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("Assert failed. expected:0x%x actual:0x%x. %s\n", (unsigned int)expect, (unsigned int)actual, message)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    lda.z main.ptr2
    sta.z printf_uint.uvalue
    lda.z main.ptr2+1
    sta.z printf_uint.uvalue+1
    // printf("Assert failed. expected:0x%x actual:0x%x. %s\n", (unsigned int)expect, (unsigned int)actual, message)
    ldx #HEXADECIMAL
    jsr printf_uint
    // printf("Assert failed. expected:0x%x actual:0x%x. %s\n", (unsigned int)expect, (unsigned int)actual, message)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("Assert failed. expected:0x%x actual:0x%x. %s\n", (unsigned int)expect, (unsigned int)actual, message)
    lda #<main.message1
    sta.z printf_string.str
    lda #>main.message1
    sta.z printf_string.str+1
    jsr printf_string
    // printf("Assert failed. expected:0x%x actual:0x%x. %s\n", (unsigned int)expect, (unsigned int)actual, message)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    rts
  .segment Data
    s: .text "Assert failed. expected:0x"
    .byte 0
    s1: .text " actual:0x"
    .byte 0
}
.segment Code
// Set the color for text output. The old color setting is returned.
// textcolor(byte register(A) color)
textcolor: {
    // conio_textcolor = color
    sta.z conio_textcolor
    // }
    rts
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(4) s)
cputs: {
    .label s = 4
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
    // cputc(c)
    jsr cputc
    jmp __b1
}
// Print a string value using a specific format
// Handles justification and min length 
// printf_string(byte* zp(4) str)
printf_string: {
    .label str = 4
    // cputs(str)
    jsr cputs
    // }
    rts
}
// Print an unsigned int using a specific format
// printf_uint(word zp(4) uvalue, byte register(X) format_radix)
printf_uint: {
    .label uvalue = 4
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
    lda.z conio_textcolor
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(4) value, byte* zp($a) buffer, byte register(X) radix)
utoa: {
    .label digit_value = $19
    .label buffer = $a
    .label digit = 7
    .label value = 4
    .label max_digits = 6
    .label digit_values = 8
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($a) buffer, word zp(4) value, word zp($19) sub)
utoa_append: {
    .label buffer = $a
    .label value = 4
    .label sub = $19
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
    ldx.z conio_textcolor
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
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($a) destination, void* zp(8) source)
memcpy: {
    .label src_end = $1b
    .label dst = $a
    .label src = 8
    .label source = 8
    .label destination = $a
    // src_end = (char*)source+num
    clc
    lda.z source
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
// memset(void* zp($19) str, byte register(X) c)
memset: {
    .label end = $1b
    .label dst = $19
    .label str = $19
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
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of binary digits
  RADIX_BINARY_VALUES: .word $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES: .word $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  s2: .text ". "
  .byte 0
  s3: .text @"\n"
  .byte 0
  s4: .text "ok! "
  .byte 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
