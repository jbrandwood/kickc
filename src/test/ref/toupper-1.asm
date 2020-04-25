// Test toupper()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  // The screen width
  .const CONIO_WIDTH = $28
  // The screen height
  .const CONIO_HEIGHT = $19
  // The default text color
  .const CONIO_TEXTCOLOR_DEFAULT = $e
  // The current cursor x-position
  .label conio_cursor_x = 7
  // The current cursor y-position
  .label conio_cursor_y = 2
  // The current cursor address
  .label conio_cursor_text = 3
  // The current cursor address
  .label conio_cursor_color = 5
main: {
    // *((char*)0xd018) = 0x17
    // Show mixed chars on screen
    lda #$17
    sta $d018
    // clrscr()
  // Clear screen
    jsr clrscr
    lda #<CONIO_SCREEN_COLORS
    sta.z conio_cursor_color
    lda #>CONIO_SCREEN_COLORS
    sta.z conio_cursor_color+1
    lda #<CONIO_SCREEN_TEXT
    sta.z conio_cursor_text
    lda #>CONIO_SCREEN_TEXT
    sta.z conio_cursor_text+1
    lda #0
    sta.z conio_cursor_y
    sta.z conio_cursor_x
    tax
  // Output un-modified chars
  __b1:
    // cputc(c)
    txa
    jsr cputc
    // for(char c:0..0xff)
    inx
    cpx #0
    bne __b1
    // return conio_cursor_y;
    lda.z conio_cursor_y
    // gotoxy(0, wherey()+2)
    clc
    adc #2
    jsr gotoxy
    lda #0
    sta.z conio_cursor_x
    tax
  // Output toupper-chars chars
  __b2:
    // toupper(c)
    txa
    jsr toupper
    // cputc(toupper(c))
    jsr cputc
    // for(char c:0..0xff)
    inx
    cpx #0
    bne __b2
    // }
    rts
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
    lda #CONIO_WIDTH
    cmp.z conio_cursor_x
    bne __breturn
    // if(++conio_cursor_y==CONIO_HEIGHT)
    inc.z conio_cursor_y
    lda #CONIO_HEIGHT
    cmp.z conio_cursor_y
    bne __b2
    // gotoxy(0,0)
    lda #0
    jsr gotoxy
  __b2:
    lda #0
    sta.z conio_cursor_x
    rts
  __breturn:
    // }
    rts
  __b1:
    // gotoxy(0, conio_cursor_y+1)
    lda.z conio_cursor_y
    clc
    adc #1
    jsr gotoxy
    jmp __b2
}
// Set the cursor to the specified position
// gotoxy(byte register(A) y)
gotoxy: {
    .label __8 = 5
    .label offset = 5
    .label __9 = $a
    .label __10 = 5
    // if(y>=CONIO_HEIGHT)
    cmp #CONIO_HEIGHT
    bcc __b2
    lda #0
  __b2:
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
    // offset = (unsigned int)y*CONIO_WIDTH + x
    asl.z offset
    rol.z offset+1
    asl.z offset
    rol.z offset+1
    asl.z offset
    rol.z offset+1
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
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// toupper(byte register(A) ch)
toupper: {
    // if(ch>='a' && ch<='z')
    cmp #'a'
    bcc __breturn
    cmp #'z'
    bcc __b1
    beq __b1
    rts
  __b1:
    // return ch + ('A'-'a');
    clc
    adc #'A'-'a'
  __breturn:
    // }
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = $a
    .label line_cols = 8
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
    lda #CONIO_TEXTCOLOR_DEFAULT
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b2
}
