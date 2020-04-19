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
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  // The background color register address
  .label CONIO_BGCOLOR = $d021
  // The border color register address
  .label CONIO_BORDERCOLOR = $d020
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CONIO_CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CONIO_CIA1_PORT_B = $dc01
  // The screen width
  .const CONIO_WIDTH = $28
  // The screen height
  .const CONIO_HEIGHT = $19
  .const COLOR_GRAY3 = $f
  .const COLOR_BLACK = 0
  .label VIC_MEMORY = $d018
  .label XSize = $f
  .label YSize = $10
  // The current cursor x-position
  .label conio_cursor_x = $a
  // The current cursor y-position
  .label conio_cursor_y = 5
  // The current cursor address
  .label conio_cursor_text = 6
  // The current cursor address
  .label conio_cursor_color = 8
__bbegin:
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
    .label line_cols = $b
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
    cpx #CONIO_HEIGHT
    bcc __b4
    // }
    rts
  __b4:
    ldy #0
  __b2:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    cpy #CONIO_WIDTH
    bcc __b3
    // line_text += CONIO_WIDTH
    lda #CONIO_WIDTH
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // line_cols += CONIO_WIDTH
    lda #CONIO_WIDTH
    clc
    adc.z line_cols
    sta.z line_cols
    bcc !+
    inc.z line_cols+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    inx
    jmp __b1
  __b3:
    // line_text[c] = ' '
    lda #' '
    sta (line_text),y
    // line_cols[c] = conio_textcolor
    lda #COLOR_GRAY3
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b2
}
// Return true if there's a key waiting, return false if not
kbhit: {
    // *CONIO_CIA1_PORT_A = 0
    lda #0
    sta CONIO_CIA1_PORT_A
    // ~*CONIO_CIA1_PORT_B
    lda CONIO_CIA1_PORT_B
    eor #$ff
    // }
    rts
}
MakeNiceScreen: {
    .label __21 = $b
    .label T = 3
    .label I = 2
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
    lda.z __21
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
// cputsxy(byte register(X) x, byte register(A) y, byte* zp($b) s)
cputsxy: {
    .label s = $b
    // gotoxy(x, y)
    jsr gotoxy
    // cputs(s)
    jsr cputs
    // }
    rts
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($b) s)
cputs: {
    .label s = $b
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
// Moves the cursor forward
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
    lda #COLOR_GRAY3
    ldy #0
    sta (conio_cursor_color),y
    // *conio_cursor_color++ = conio_textcolor;
    inc.z conio_cursor_color
    bne !+
    inc.z conio_cursor_color+1
  !:
    // if(++conio_cursor_x==CONIO_WIDTH)
    inc.z conio_cursor_x
    lda #CONIO_WIDTH
    cmp.z conio_cursor_x
    bne __breturn
    // if(++conio_cursor_y==CONIO_HEIGHT)
    inc.z conio_cursor_y
    lda #CONIO_HEIGHT
    cmp.z conio_cursor_y
    bne __b3
    // gotoxy(0,0)
    lda #0
    tax
    jsr gotoxy
    rts
  __b3:
    lda #0
    sta.z conio_cursor_x
  __breturn:
    // }
    rts
  __b1:
    // gotoxy(0, conio_cursor_y+1)
    lda.z conio_cursor_y
    clc
    adc #1
    ldx #0
    jsr gotoxy
    rts
}
// Set the cursor to the specified position
// gotoxy(byte register(X) x, byte register(A) y)
gotoxy: {
    .label __4 = 8
    .label __8 = 8
    .label offset = 8
    .label __9 = $11
    .label __10 = 8
    // if(x>=CONIO_WIDTH)
    cpx #CONIO_WIDTH
    bcc __b1
    ldx #0
  __b1:
    // if(y>=CONIO_HEIGHT)
    cmp #CONIO_HEIGHT
    bcc __b2
    lda #0
  __b2:
    // conio_cursor_x = x
    stx.z conio_cursor_x
    // conio_cursor_y = y
    sta.z conio_cursor_y
    // (unsigned int)y*CONIO_WIDTH
    sta.z __8
    lda #0
    sta.z __8+1
    lda.z __8
    asl
    sta.z __9
    lda.z __8+1
    rol
    sta.z __9+1
    asl.z __9
    rol.z __9+1
    lda.z __10
    clc
    adc.z __9
    sta.z __10
    lda.z __10+1
    adc.z __9+1
    sta.z __10+1
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    // offset = (unsigned int)y*CONIO_WIDTH + x
    txa
    clc
    adc.z offset
    sta.z offset
    bcc !+
    inc.z offset+1
  !:
    // CONIO_SCREEN_TEXT + offset
    lda.z offset
    clc
    adc #<CONIO_SCREEN_TEXT
    sta.z conio_cursor_text
    lda.z offset+1
    adc #>CONIO_SCREEN_TEXT
    sta.z conio_cursor_text+1
    // CONIO_SCREEN_COLORS + offset
    clc
    lda.z conio_cursor_color
    adc #<CONIO_SCREEN_COLORS
    sta.z conio_cursor_color
    lda.z conio_cursor_color+1
    adc #>CONIO_SCREEN_COLORS
    sta.z conio_cursor_color+1
    // }
    rts
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($11) str)
strlen: {
    .label len = $b
    .label str = $11
    .label return = $b
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
// chline(byte zp($d) length)
chline: {
    .label i = $e
    .label length = $d
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
    .label x = $13
    .label y = $e
    .label i = $d
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
    // *CONIO_BGCOLOR = color
    lda #COLOR_BLACK
    sta CONIO_BGCOLOR
    // }
    rts
}
// Set the color for the border. The old color setting is returned.
bordercolor: {
    // *CONIO_BORDERCOLOR = color
    lda #COLOR_BLACK
    sta CONIO_BORDERCOLOR
    // }
    rts
}
// Set the color for text output. The old color setting is returned.
textcolor: {
    rts
}
// Return the current screen size.
screensize: {
    .label x = XSize
    .label y = YSize
    // *x = CONIO_WIDTH
    lda #CONIO_WIDTH
    sta.z x
    // *y = CONIO_HEIGHT
    lda #CONIO_HEIGHT
    sta.z y
    // }
    rts
}
