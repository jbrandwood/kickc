// Tests snprintf function call rewriting
// Test snprintf() and printf() in the same file
  // Commodore 64 PRG executable file
.file [name="printf-18.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const LIGHT_BLUE = $e
  .const STACK_BASE = $103
  /// Color Ram
  .label COLORRAM = $d800
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $12
  // The current cursor y-position
  .label conio_cursor_y = $15
  // The current text cursor line start
  .label conio_line_text = $18
  // The current color cursor line start
  .label conio_line_color = $1a
  /// The capacity of the buffer (n passed to snprintf())
  /// Used to hold state while printing
  .label __snprintf_capacity = $1c
  // The number of chars that would have been filled when printing without capacity. Grows even after size>capacity.
  /// Used to hold state while printing
  .label __snprintf_size = $13
  /// Current position in the buffer being filled ( initially *s passed to snprintf()
  /// Used to hold state while printing
  .label __snprintf_buffer = $16
.segment Code
__start: {
    // __ma char conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // __ma char conio_cursor_y = 0
    sta.z conio_cursor_y
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
    // volatile size_t __snprintf_capacity
    lda #<0
    sta.z __snprintf_capacity
    sta.z __snprintf_capacity+1
    // volatile size_t __snprintf_size
    sta.z __snprintf_size
    sta.z __snprintf_size+1
    // char * __snprintf_buffer
    sta.z __snprintf_buffer
    sta.z __snprintf_buffer+1
    // #pragma constructor_for(conio_c64_init, cputc, clrscr, cscroll)
    jsr conio_c64_init
    jsr main
    rts
}
/// Print a character into snprintf buffer
/// Used by snprintf()
/// @param c The character to print
// void snputc(__register(X) char c)
snputc: {
    .const OFFSET_STACK_C = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    tax
    // ++__snprintf_size;
    inc.z __snprintf_size
    bne !+
    inc.z __snprintf_size+1
  !:
    // if(__snprintf_size > __snprintf_capacity)
    lda.z __snprintf_size+1
    cmp.z __snprintf_capacity+1
    bne !+
    lda.z __snprintf_size
    cmp.z __snprintf_capacity
    beq __b1
  !:
    bcc __b1
    // }
    rts
  __b1:
    // if(__snprintf_size==__snprintf_capacity)
    lda.z __snprintf_size+1
    cmp.z __snprintf_capacity+1
    bne __b2
    lda.z __snprintf_size
    cmp.z __snprintf_capacity
    bne __b2
    ldx #0
  __b2:
    // *(__snprintf_buffer++) = c
    // Append char
    txa
    ldy #0
    sta (__snprintf_buffer),y
    // *(__snprintf_buffer++) = c;
    inc.z __snprintf_buffer
    bne !+
    inc.z __snprintf_buffer+1
  !:
    rts
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    // char line = *BASIC_CURSOR_LINE
    ldx.z BASIC_CURSOR_LINE
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
main: {
    // snprintf(BUF1, 20, "hello world!")
    lda #<BUF1
    sta.z snprintf_init.s
    lda #>BUF1
    sta.z snprintf_init.s+1
    jsr snprintf_init
    // snprintf(BUF1, 20, "hello world!")
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF1, 20, "hello world!")
    lda #0
    pha
    jsr snputc
    pla
    // snprintf(BUF2, 20, "hello %s%c", "world", '!')
    lda #<BUF2
    sta.z snprintf_init.s
    lda #>BUF2
    sta.z snprintf_init.s+1
    jsr snprintf_init
    // snprintf(BUF2, 20, "hello %s%c", "world", '!')
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF2, 20, "hello %s%c", "world", '!')
    lda #<snputc
    sta.z printf_string.putc
    lda #>snputc
    sta.z printf_string.putc+1
    lda #<str
    sta.z printf_string.str
    lda #>str
    sta.z printf_string.str+1
    jsr printf_string
    // snprintf(BUF2, 20, "hello %s%c", "world", '!')
    lda #'!'
    pha
    jsr snputc
    pla
    lda #0
    pha
    jsr snputc
    pla
    // printf("-%s- -%s-", BUF1, BUF2)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // printf("-%s- -%s-", BUF1, BUF2)
    lda #<cputc
    sta.z printf_string.putc
    lda #>cputc
    sta.z printf_string.putc+1
    lda #<BUF1
    sta.z printf_string.str
    lda #>BUF1
    sta.z printf_string.str+1
    jsr printf_string
    // printf("-%s- -%s-", BUF1, BUF2)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // printf("-%s- -%s-", BUF1, BUF2)
    lda #<cputc
    sta.z printf_string.putc
    lda #>cputc
    sta.z printf_string.putc+1
    lda #<BUF2
    sta.z printf_string.str
    lda #>BUF2
    sta.z printf_string.str+1
    jsr printf_string
    // printf("-%s- -%s-", BUF1, BUF2)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // }
    rts
  .segment Data
    s: .text "hello world!"
    .byte 0
    s1: .text "hello "
    .byte 0
    str: .text "world"
    .byte 0
    s2: .text "-"
    .byte 0
    s3: .text "- -"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// void gotoxy(char x, __register(X) char y)
gotoxy: {
    .const x = 0
    .label __5 = $10
    .label __6 = $c
    .label __7 = $c
    .label line_offset = $c
    .label __8 = $e
    .label __9 = $c
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
    // unsigned int line_offset = (unsigned int)y*CONIO_WIDTH
    txa
    sta.z __7
    lda #0
    sta.z __7+1
    lda.z __7
    asl
    sta.z __8
    lda.z __7+1
    rol
    sta.z __8+1
    asl.z __8
    rol.z __8+1
    clc
    lda.z __9
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
    lda.z line_offset
    clc
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
    lda.z __6
    clc
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
/// Initialize the snprintf() state
// void snprintf_init(__zp($a) char *s, unsigned int n)
snprintf_init: {
    .label s = $a
    // __snprintf_capacity = n
    lda #<$14
    sta.z __snprintf_capacity
    lda #>$14
    sta.z __snprintf_capacity+1
    // __snprintf_size = 0
    lda #<0
    sta.z __snprintf_size
    sta.z __snprintf_size+1
    // __snprintf_buffer = s
    lda.z s
    sta.z __snprintf_buffer
    lda.z s+1
    sta.z __snprintf_buffer+1
    // }
    rts
}
/// Print a NUL-terminated string
// void printf_str(__zp($a) void (*putc)(char), __zp(4) const char *s)
printf_str: {
    .label s = 4
    .label putc = $a
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
    jsr icall4
    pla
    jmp __b1
  icall4:
    jmp (putc)
}
// Print a string value using a specific format
// Handles justification and min length 
// void printf_string(__zp($a) void (*putc)(char), __zp(4) char *str, char format_min_length, char format_justify_left)
printf_string: {
    .label putc = $a
    .label str = 4
    // printf_str(putc, str)
    jsr printf_str
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
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(__zp(6) void *destination, __zp(2) void *source, unsigned int num)
memcpy: {
    .label src_end = 8
    .label dst = 6
    .label src = 2
    .label source = 2
    .label destination = 6
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
    .label end = 6
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
.segment Data
  BUF1: .fill $14, 0
  BUF2: .fill $14, 0
