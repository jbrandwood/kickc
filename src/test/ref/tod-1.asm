// Time of Day / RTOS test using the 6526 CIA on C64
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The screen width
  .const CONIO_WIDTH = $28
  // The screen height
  .const CONIO_HEIGHT = $19
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
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The current cursor y-position
  .label conio_cursor_y = 4
  // The current cursor address
  .label conio_cursor_text = 5
  // The current cursor address
  .label conio_cursor_color = 7
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
    lda #0
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
    ldx #0
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
    inx
    cpx #CONIO_WIDTH
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
    ldx #0
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
    .label __8 = 7
    .label offset = 7
    .label __9 = $b
    .label __10 = 7
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
// Convert time of day to a human-readable string "hh:mm:ss:10"
// tod_str(byte zp($a) tod_TENTHS, byte zp($d) tod_SEC, byte register(Y) tod_MIN, byte register(X) tod_HOURS)
tod_str: {
    .label tod_TENTHS = $a
    .label tod_SEC = $d
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
    .label return_HOURS = $d
    .label return_MIN = 9
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
// Initialize time-of-day clock
// This uses the MOS6526 CIA#1
// tod_init(byte zp(9) tod_TENTHS, byte zp($a) tod_SEC, byte register(X) tod_MIN, byte register(Y) tod_HOURS)
tod_init: {
    .label tod_TENTHS = 9
    .label tod_SEC = $a
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
