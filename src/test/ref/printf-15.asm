// Tests printf function call rewriting
// A few strings with newlines
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // The default text color
  .const CONIO_TEXTCOLOR_DEFAULT = $e
  // The screen width
  // The screen height
  // The screen bytes
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  .label conio_cursor_x = 8
  .label conio_cursor_y = 9
  .label conio_cursor_text = $a
  .label conio_cursor_color = $c
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
    s: .text @"Lone 1\n"
    .byte 0
    s1: .text @"Lone 2\n"
    .byte 0
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
    .label __0 = $a
    .label __1 = $a
    .label __2 = $c
    .label __3 = $c
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
    .label __7 = $a
    .label __8 = $c
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
// memset(void* zp(2) str, byte register(X) c)
memset: {
    .label end = $e
    .label dst = 2
    .label str = 2
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
// memcpy(void* zp(6) destination, void* zp(2) source)
memcpy: {
    .label src_end = $e
    .label dst = 6
    .label src = 2
    .label source = 2
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
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 4
    .label line_cols = 6
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
