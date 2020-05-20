// Show a nice screen using conio.h
// From CC65 sample "Eine kleine Nachtmusik" by Ullrich von Bassewitz
// https://github.com/cc65/cc65/blob/master/samples/nachtm.c
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // The horizontal line character
  .const CH_HLINE = $40
  // The vertical line character
  .const CH_VLINE = $5d
  // The upper left corner character
  .const CH_ULCORNER = $70
  // The upper right corner character
  .const CH_URCORNER = $6e
  // The lower left corner character
  .const CH_LLCORNER = $6d
  // The lower right corner character
  .const CH_LRCORNER = $7d
  // The left T character
  .const CH_LTEE = $6b
  // The right T character
  .const CH_RTEE = $73
  // The default text color
  .const CONIO_TEXTCOLOR_DEFAULT = $e
  .const COLOR_GRAY3 = $f
  .const COLOR_BLACK = 0
  // The screen width
  // The screen height
  // The screen bytes
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  .label VIC_MEMORY = $d018
  .label conio_cursor_x = $b
  .label conio_cursor_y = $c
  .label conio_line_text = $d
  .label conio_line_color = $f
  .label conio_textcolor = $11
  .label conio_scroll_enable = $12
  .label XSize = $13
  .label YSize = $14
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
  // conio_textcolor = CONIO_TEXTCOLOR_DEFAULT
  // The current text color
  lda #CONIO_TEXTCOLOR_DEFAULT
  sta.z conio_textcolor
  // conio_scroll_enable = 1
  // Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
  // If disabled the cursor just moves back to (0,0) instead
  lda #1
  sta.z conio_scroll_enable
  // XSize
  lda #0
  sta.z XSize
  // YSize
  sta.z YSize
  jsr main
  rts
main: {
    // *VIC_MEMORY = 0x17
    lda #$17
    sta VIC_MEMORY
    // screensize(&XSize, &YSize)
    jsr screensize
    // MakeNiceScreen()
    jsr MakeNiceScreen
  __b1:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b1
    // clrscr ()
    jsr clrscr
    // }
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 3
    .label line_cols = 7
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
    // conio_line_text = CONIO_SCREEN_TEXT
    lda #<CONIO_SCREEN_TEXT
    sta.z conio_line_text
    lda #>CONIO_SCREEN_TEXT
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS
    lda #<CONIO_SCREEN_COLORS
    sta.z conio_line_color
    lda #>CONIO_SCREEN_COLORS
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
// Return true if there's a key waiting, return false if not
kbhit: {
    // CIA#1 Port A: keyboard matrix columns and joystick #2
    .label CIA1_PORT_A = $dc00
    // CIA#1 Port B: keyboard matrix rows and joystick #1.
    .label CIA1_PORT_B = $dc01
    // *CIA1_PORT_A = 0
    lda #0
    sta CIA1_PORT_A
    // ~*CIA1_PORT_B
    lda CIA1_PORT_B
    eor #$ff
    // }
    rts
}
MakeNiceScreen: {
    .label __22 = 7
    .label T = 3
    .label I = 2
    // scroll(0)
    // disable scrolling
    jsr scroll
    // textcolor (COLOR_GRAY3)
    /* Clear the screen hide the cursor, set colors */
    jsr textcolor
    // bordercolor (COLOR_BLACK)
    jsr bordercolor
    // bgcolor (COLOR_BLACK)
    jsr bgcolor
    // clrscr ()
    jsr clrscr
    // cursor (0)
    jsr cursor
    // cputcxy (0, 0, CH_ULCORNER)
  /* Top line */
    ldy #CH_ULCORNER
    lda #0
    jsr cputcxy
    // chline (XSize - 2)
    lda.z XSize
    sec
    sbc #2
    sta.z chline.length
    jsr chline
    // cputc (CH_URCORNER)
    lda #CH_URCORNER
    jsr cputc
    // cvlinexy (0, 1, 23)
  /* Left line */
    ldx #0
    jsr cvlinexy
    // cputc (CH_LLCORNER)
  /* Bottom line */
    lda #CH_LLCORNER
    jsr cputc
    // chline (XSize - 2)
    lda.z XSize
    sec
    sbc #2
    sta.z chline.length
    jsr chline
    // cputc (CH_LRCORNER)
    lda #CH_LRCORNER
    jsr cputc
    // cvlinexy (XSize - 1, 1, 23)
    ldx.z XSize
    dex
  /* Right line */
    jsr cvlinexy
    // MakeTeeLine (7)
  /* Several divider lines */
    lda #7
    jsr MakeTeeLine
    // MakeTeeLine (22)
    lda #$16
    jsr MakeTeeLine
    lda #<Text
    sta.z T
    lda #>Text
    sta.z T+1
    lda #0
    sta.z I
  /* Write something into the frame */
  __b1:
    // for (I = 0, T = Text; I < sizeof (Text) / sizeof (TextDesc); ++I)
    lda.z I
    cmp #$c*$29/$29
    bcc __b2
    // }
    rts
  __b2:
    // strlen (T->Msg)
    lda.z T
    clc
    adc #1
    sta.z strlen.str
    lda.z T+1
    adc #0
    sta.z strlen.str+1
    jsr strlen
    // strlen (T->Msg)
    // XSize - (char)strlen (T->Msg)
    lda.z __22
    eor #$ff
    sec
    adc.z XSize
    // X = (XSize - (char)strlen (T->Msg)) >> 1
    lsr
    tax
    // cputsxy (X, T->Y, T->Msg)
    lda.z T
    clc
    adc #1
    sta.z cputsxy.s
    lda.z T+1
    adc #0
    sta.z cputsxy.s+1
    ldy #0
    lda (T),y
    jsr cputsxy
    // ++T;
    lda #$29
    clc
    adc.z T
    sta.z T
    bcc !+
    inc.z T+1
  !:
    // for (I = 0, T = Text; I < sizeof (Text) / sizeof (TextDesc); ++I)
    inc.z I
    jmp __b1
    Text: .byte 2
    .text "Wolfgang Amadeus Mozart"
    .byte 0
    .fill $10, 0
    .byte 4
    .text @"\"Eine kleine Nachtmusik\""
    .byte 0
    .fill $f, 0
    .byte 5
    .text "(KV 525)"
    .byte 0
    .fill $1f, 0
    .byte 9
    .text "Ported to the SID in 1987 by"
    .byte 0
    .fill $b, 0
    .byte $b
    .text "Joachim von Bassewitz"
    .byte 0
    .fill $12, 0
    .byte $c
    .text "(joachim@von-bassewitz.de)"
    .byte 0
    .fill $d, 0
    .byte $d
    .text "and"
    .byte 0
    .fill $24, 0
    .byte $e
    .text "Ullrich von Bassewitz"
    .byte 0
    .fill $12, 0
    .byte $f
    .text "(ullrich@von-bassewitz.de)"
    .byte 0
    .fill $d, 0
    .byte $12
    .text "C Implementation by"
    .byte 0
    .fill $14, 0
    .byte $13
    .text "Ullrich von Bassewitz"
    .byte 0
    .fill $12, 0
    .byte $17
    .text "Press any key to quit..."
    .byte 0
    .fill $f, 0
}
// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
// cputsxy(byte register(X) x, byte register(A) y, byte* zp(7) s)
cputsxy: {
    .label s = 7
    // gotoxy(x, y)
    jsr gotoxy
    // cputs(s)
    jsr cputs
    // }
    rts
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(7) s)
cputs: {
    .label s = 7
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
    // if(conio_scroll_enable)
    lda #0
    cmp.z conio_scroll_enable
    bne __b3
    // gotoxy(0,0)
    tax
    txa
    jsr gotoxy
  __breturn:
    // }
    rts
  __b3:
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
    ldx.z conio_textcolor
    lda #<CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str
    lda #>CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // conio_line_text -= CONIO_WIDTH
    lda.z conio_line_text
    sec
    sbc #<$28
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #>$28
    sta.z conio_line_text+1
    // conio_line_color -= CONIO_WIDTH
    lda.z conio_line_color
    sec
    sbc #<$28
    sta.z conio_line_color
    lda.z conio_line_color+1
    sbc #>$28
    sta.z conio_line_color+1
    // conio_cursor_y--;
    dec.z conio_cursor_y
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($17) str, byte register(X) c)
memset: {
    .label end = $15
    .label dst = $17
    .label str = $17
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
// memcpy(void* zp(5) destination, void* zp($17) source)
memcpy: {
    .label src_end = $15
    .label dst = 5
    .label src = $17
    .label source = $17
    .label destination = 5
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
// Set the cursor to the specified position
// gotoxy(byte register(X) x, byte register(A) y)
gotoxy: {
    .label __5 = $d
    .label __6 = $f
    .label __7 = $f
    .label line_offset = $f
    .label __8 = $17
    .label __9 = $f
    // if(y>CONIO_HEIGHT)
    cmp #$19+1
    bcc __b1
    lda #0
  __b1:
    // if(x>=CONIO_WIDTH)
    cpx #$28
    bcc __b2
    ldx #0
  __b2:
    // conio_cursor_x = x
    stx.z conio_cursor_x
    // conio_cursor_y = y
    sta.z conio_cursor_y
    // (unsigned int)y*CONIO_WIDTH
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
    lda.z line_offset
    clc
    adc #<CONIO_SCREEN_TEXT
    sta.z __5
    lda.z line_offset+1
    adc #>CONIO_SCREEN_TEXT
    sta.z __5+1
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    // CONIO_SCREEN_COLORS + line_offset
    clc
    lda.z __6
    adc #<CONIO_SCREEN_COLORS
    sta.z __6
    lda.z __6+1
    adc #>CONIO_SCREEN_COLORS
    sta.z __6+1
    // conio_line_color = CONIO_SCREEN_COLORS + line_offset
    // }
    rts
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp(5) str)
strlen: {
    .label len = 7
    .label str = 5
    .label return = 7
    lda #<0
    sta.z len
    sta.z len+1
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
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// MakeTeeLine(byte register(A) Y)
MakeTeeLine: {
    // cputcxy (0, Y, CH_LTEE)
    ldy #CH_LTEE
    jsr cputcxy
    // chline (XSize - 2)
    lda.z XSize
    sec
    sbc #2
    sta.z chline.length
    jsr chline
    // cputc (CH_RTEE)
    lda #CH_RTEE
    jsr cputc
    // }
    rts
}
// Output a horizontal line with the given length starting at the current cursor position.
// chline(byte zp(9) length)
chline: {
    .label i = $a
    .label length = 9
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<length;i++)
    lda.z i
    cmp.z length
    bcc __b2
    // }
    rts
  __b2:
    // cputc(CH_HLINE)
    lda #CH_HLINE
    jsr cputc
    // for(char i=0;i<length;i++)
    inc.z i
    jmp __b1
}
// Move cursor and output one character
// Same as "gotoxy (x, y); cputc (c);"
// cputcxy(byte register(A) y, byte register(Y) c)
cputcxy: {
    // gotoxy(x, y)
    ldx #0
    jsr gotoxy
    // cputc(c)
    tya
    jsr cputc
    // }
    rts
}
// Move cursor and output a vertical line with the given length
// Same as "gotoxy (x, y); cvline (length);"
// cvlinexy(byte register(X) x)
cvlinexy: {
    // gotoxy(x,y)
    lda #1
    jsr gotoxy
    // cvline(length)
    jsr cvline
    // }
    rts
}
// Output a vertical line with the given length at the current cursor position.
cvline: {
    .const length = $17
    .label x = $19
    .label y = $a
    .label i = 9
    // x = conio_cursor_x
    lda.z conio_cursor_x
    sta.z x
    // y = conio_cursor_y
    lda.z conio_cursor_y
    sta.z y
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<length;i++)
    lda.z i
    cmp #length
    bcc __b2
    // }
    rts
  __b2:
    // cputc(CH_VLINE)
    lda #CH_VLINE
    jsr cputc
    // gotoxy(x, ++y);
    inc.z y
    // gotoxy(x, ++y)
    ldx.z x
    lda.z y
    jsr gotoxy
    // for(char i=0;i<length;i++)
    inc.z i
    jmp __b1
}
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
cursor: {
    // }
    rts
}
// Set the color for the background. The old color setting is returned.
bgcolor: {
    // The background color register address
    .label CONIO_BGCOLOR = $d021
    // *CONIO_BGCOLOR = color
    lda #COLOR_BLACK
    sta CONIO_BGCOLOR
    // }
    rts
}
// Set the color for the border. The old color setting is returned.
bordercolor: {
    // The border color register address
    .label CONIO_BORDERCOLOR = $d020
    // *CONIO_BORDERCOLOR = color
    lda #COLOR_BLACK
    sta CONIO_BORDERCOLOR
    // }
    rts
}
// Set the color for text output. The old color setting is returned.
textcolor: {
    // conio_textcolor = color
    lda #COLOR_GRAY3
    sta.z conio_textcolor
    // }
    rts
}
// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 1, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
scroll: {
    .const onoff = 0
    // conio_scroll_enable = onoff
    lda #onoff
    sta.z conio_scroll_enable
    // }
    rts
}
// Return the current screen size.
screensize: {
    .label x = XSize
    .label y = YSize
    // *x = CONIO_WIDTH
    lda #$28
    sta.z x
    // *y = CONIO_HEIGHT
    lda #$19
    sta.z y
    // }
    rts
}
