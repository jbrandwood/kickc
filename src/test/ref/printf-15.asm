// Tests printf function call rewriting
// A few strings with newlines
  // Commodore 64 PRG executable file
.file [name="printf-15.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const LIGHT_BLUE = $e
  // Color Ram
  .label COLORRAM = $d800
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = 8
  // The current cursor y-position
  .label conio_cursor_y = 9
  // The current text cursor line start
  .label conio_line_text = $a
  // The current color cursor line start
  .label conio_line_color = $c
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
main: {
    // clrscr()
    jsr clrscr
    // printf("Lone 1\n")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("Lone 2\n")
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  .segment Data
    s: .text @"Lone 1\n"
    .byte 0
    s1: .text @"Lone 2\n"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .const x = 0
    .label __5 = $12
    .label __6 = $e
    .label __7 = $e
    .label line_offset = $e
    .label __8 = $10
    .label __9 = $e
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
    // unsigned int line_offset = (unsigned int)y*CONIO_WIDTH
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
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp(2) s)
cputs: {
    .label s = 2
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
// memcpy(void* zp(6) destination, void* zp(4) source)
memcpy: {
    .label src_end = $14
    .label dst = 6
    .label src = 4
    .label source = 4
    .label destination = 6
    // char* src_end = (char*)source+num
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
// memset(void* zp(6) str, byte register(X) c)
memset: {
    .label end = $14
    .label dst = 6
    .label str = 6
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
