// Time of Day / RTOS test using the 6526 CIA on C64
// Provides provide console input/output
// Implements similar functions as conio.h from CC65 for compatibility
// See https://github.com/cc65/cc65/blob/master/include/conio.h
//
// Currently C64/PLUS4/VIC20 platforms are supported
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // The default text color
  .const CONIO_TEXTCOLOR_DEFAULT = $e
  .const OFFSET_STRUCT_TIME_OF_DAY_SEC = 1
  .const OFFSET_STRUCT_TIME_OF_DAY_MIN = 2
  .const OFFSET_STRUCT_TIME_OF_DAY_HOURS = 3
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL = $e
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL = $f
  .const OFFSET_STRUCT_MOS6526_CIA_TOD_HOURS = $b
  .const OFFSET_STRUCT_MOS6526_CIA_TOD_MIN = $a
  .const OFFSET_STRUCT_MOS6526_CIA_TOD_SEC = 9
  .const OFFSET_STRUCT_MOS6526_CIA_TOD_10THS = 8
  // The screen width
  // The screen height
  // The screen bytes
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  .label conio_cursor_x = 6
  .label conio_cursor_y = 7
  .label conio_line_text = 8
  .label conio_line_color = $a
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
  jsr main
  rts
main: {
    // tod_init(TOD_ZERO)
    lda TOD_ZERO
    sta.z tod_init.tod_TENTHS
    lda TOD_ZERO+OFFSET_STRUCT_TIME_OF_DAY_SEC
    sta.z tod_init.tod_SEC
    ldx TOD_ZERO+OFFSET_STRUCT_TIME_OF_DAY_MIN
    ldy TOD_ZERO+OFFSET_STRUCT_TIME_OF_DAY_HOURS
    jsr tod_init
  __b1:
    // gotoxy(0,0)
    jsr gotoxy
    // tod_read()
    jsr tod_read
    sta.z tod_read.return_MIN
    lda.z tod_read.return_HOURS
    // tod_str(tod_read())
    sty.z tod_str.tod_TENTHS
    stx.z tod_str.tod_SEC
    ldy.z tod_read.return_MIN
    tax
    jsr tod_str
    // cputs(tod_str(tod_read()))
    jsr cputs
    jmp __b1
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(2) s)
cputs: {
    .label s = 2
    lda #<tod_buffer
    sta.z s
    lda #>tod_buffer
    sta.z s+1
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
    lda #CONIO_TEXTCOLOR_DEFAULT
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(4) str, byte register(X) c)
memset: {
    .label end = $e
    .label dst = 4
    .label str = 4
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
// memcpy(void* zp($e) destination, void* zp(4) source)
memcpy: {
    .label src_end = $10
    .label dst = $e
    .label src = 4
    .label source = 4
    .label destination = $e
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
// Convert time of day to a human-readable string "hh:mm:ss:10"
// tod_str(byte zp($d) tod_TENTHS, byte zp($12) tod_SEC, byte register(Y) tod_MIN, byte register(X) tod_HOURS)
tod_str: {
    .label tod_TENTHS = $d
    .label tod_SEC = $12
    // tod.HOURS>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // '0'+(tod.HOURS>>4)
    clc
    adc #'0'
    // tod_buffer[0] = '0'+(tod.HOURS>>4)
    sta tod_buffer
    // tod.HOURS&0x0f
    txa
    and #$f
    // '0'+(tod.HOURS&0x0f)
    clc
    adc #'0'
    // tod_buffer[1] = '0'+(tod.HOURS&0x0f)
    sta tod_buffer+1
    // tod.MIN>>4
    tya
    lsr
    lsr
    lsr
    lsr
    // '0'+(tod.MIN>>4)
    clc
    adc #'0'
    // tod_buffer[3] = '0'+(tod.MIN>>4)
    sta tod_buffer+3
    // tod.MIN&0x0f
    tya
    and #$f
    // '0'+(tod.MIN&0x0f)
    clc
    adc #'0'
    // tod_buffer[4] = '0'+(tod.MIN&0x0f)
    sta tod_buffer+4
    // tod.SEC>>4
    lda.z tod_SEC
    lsr
    lsr
    lsr
    lsr
    // '0'+(tod.SEC>>4)
    clc
    adc #'0'
    // tod_buffer[6] = '0'+(tod.SEC>>4)
    sta tod_buffer+6
    // tod.SEC&0x0f
    lda #$f
    and.z tod_SEC
    // '0'+(tod.SEC&0x0f)
    clc
    adc #'0'
    // tod_buffer[7] = '0'+(tod.SEC&0x0f)
    sta tod_buffer+7
    // tod.TENTHS>>4
    lda.z tod_TENTHS
    lsr
    lsr
    lsr
    lsr
    // '0'+(tod.TENTHS>>4)
    clc
    adc #'0'
    // tod_buffer[9] = '0'+(tod.TENTHS>>4)
    sta tod_buffer+9
    // tod.TENTHS&0x0f
    lda #$f
    and.z tod_TENTHS
    // '0'+(tod.TENTHS&0x0f)
    clc
    adc #'0'
    // tod_buffer[10] = '0'+(tod.TENTHS&0x0f)
    sta tod_buffer+$a
    // }
    rts
}
// Read time of day
tod_read: {
    .label return_HOURS = $12
    .label return_MIN = $c
    // hours = CIA1->TOD_HOURS
    // Reading sequence is important. TOD latches on reading hours until 10ths is read.
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_HOURS
    sta.z return_HOURS
    // mins = CIA1->TOD_MIN
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_MIN
    // secs = CIA1->TOD_SEC
    ldx CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_SEC
    // tenths = CIA1->TOD_10THS
    ldy CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_10THS
    // }
    rts
}
// Set the cursor to the specified position
gotoxy: {
    .const x = 0
    .const y = 0
    // conio_cursor_x = x
    lda #x
    sta.z conio_cursor_x
    // conio_cursor_y = y
    lda #y
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    lda #<CONIO_SCREEN_TEXT
    sta.z conio_line_text
    lda #>CONIO_SCREEN_TEXT
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS + line_offset
    lda #<CONIO_SCREEN_COLORS
    sta.z conio_line_color
    lda #>CONIO_SCREEN_COLORS
    sta.z conio_line_color+1
    // }
    rts
}
// Initialize time-of-day clock
// This uses the MOS6526 CIA#1
// tod_init(byte zp($c) tod_TENTHS, byte zp($d) tod_SEC, byte register(X) tod_MIN, byte register(Y) tod_HOURS)
tod_init: {
    .label tod_TENTHS = $c
    .label tod_SEC = $d
    // CIA1->TIMER_A_CONTROL |= 0x80
    // Set 50hz (this assumes PAL!) (bit7=1)
    lda #$80
    ora CIA1+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // CIA1->TIMER_B_CONTROL &= 0x7f
    // Writing TOD clock (bit7=0)
    lda #$7f
    and CIA1+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    // CIA1->TOD_HOURS = tod.HOURS
    // Reset TOD clock
    // Writing sequence is important. TOD stops when hours is written and starts when 10ths is written.
    sty CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_HOURS
    // CIA1->TOD_MIN = tod.MIN
    stx CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_MIN
    // CIA1->TOD_SEC = tod.SEC
    lda.z tod_SEC
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_SEC
    // CIA1->TOD_10THS = tod.TENTHS
    lda.z tod_TENTHS
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_TOD_10THS
    // }
    rts
}
  // The buffer used by tod_str()
  tod_buffer: .text "00:00:00:00"
  .byte 0
  // Time of Day 00:00:00:00
  TOD_ZERO: .byte 0, 0, 0, 0
