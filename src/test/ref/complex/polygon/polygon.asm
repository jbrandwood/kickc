// Filling a simple 16x16 2D polygon using EOR-filling
// - Clearing canvas
// - Trivial 2D rotation using sine tables
// - Line-drawing polygon edges (fill-ready lines)
// - Up-to-down EOR filling 
// - Double buffering
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // Timer Control - Start/stop timer (0:stop, 1: start)
  .const CIA_TIMER_CONTROL_START = 1
  // Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
  .const CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A = $40
  .const BORDER_YPOS_BOTTOM = $fa
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  // The default text color
  .const CONIO_TEXTCOLOR_DEFAULT = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL = $e
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL = $f
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL1 = $11
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE = $1a
  .const OFFSET_STRUCT_MOS6569_VICII_MEMORY = $18
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS = $19
  .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CANVAS2)/4&$f
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Color Ram
  .label COLS = $d800
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  // CIA#2 timer A&B as one single 32-bit value
  .label CIA2_TIMER_AB = $dd04
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  // The screen width
  // The screen height
  // The screen bytes
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CONIO_CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CONIO_CIA1_PORT_B = $dc01
  // The screen matrix
  .label SCREEN = $2c00
  // The two charsets used for double buffering
  .label CANVAS1 = $3000
  .label CANVAS2 = $3800
  // The screen console
  .label CONSOLE = $400
  // The default charset address
  .label PETSCII = $1000
  .label COSTAB = SINTAB+$40
  .label conio_cursor_x = $13
  .label conio_cursor_y = $14
  .label conio_cursor_text = $15
  .label conio_cursor_color = $17
  .label conio_textcolor = $19
  .label canvas_show_memory = $1a
  .label canvas_show_flag = $1b
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
  // conio_textcolor = CONIO_TEXTCOLOR_DEFAULT
  // The current text color
  lda #CONIO_TEXTCOLOR_DEFAULT
  sta.z conio_textcolor
  // canvas_show_memory = toD018(SCREEN, CANVAS2)
  // The current canvas being rendered to the screen - in D018 format.
  lda #toD0181_return
  sta.z canvas_show_memory
  // canvas_show_flag = 0
  // Flag signalling that the canvas on screen needs to be updated. 
  // Set to 1 by the renderer when a new canvas is ready for showing, and to 0 by the raster when the canvas is shown on screen.
  lda #0
  sta.z canvas_show_flag
  jsr main
  rts
main: {
    .const p0_idx = $88
    .const p1_idx = p0_idx+$f
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CANVAS1)/4&$f
    .const toD0182_return = (>(SCREEN&$3fff)*4)|(>CANVAS2)/4&$f
    .label cols = 2
    // Setup 16x16 canvas for rendering
    .label screen = 4
    .label y = $13
    .label x0 = $1c
    .label y0 = $1d
    .label x1 = $1e
    .label y1 = $1f
    // The current canvas being rendered to
    .label canvas = 6
    // memset(CONSOLE, ' ', 40*25)
  // Clear the console
    ldx #' '
    lda #<CONSOLE
    sta.z memset.str
    lda #>CONSOLE
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // memset(SCREEN, 0, 40*25)
  // Clear the screen & canvasses
    ldx #0
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // memset(COLS, BLACK, 40*25)
    ldx #BLACK
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    lda #<SCREEN+$c
    sta.z screen
    lda #>SCREEN+$c
    sta.z screen+1
    lda #<COLS+$c
    sta.z cols
    lda #>COLS+$c
    sta.z cols+1
    lda #0
    sta.z y
  __b1:
    // for(char y=0;y<16;y++)
    lda.z y
    cmp #$10
    bcs !__b2+
    jmp __b2
  !__b2:
    // VICII->BORDER_COLOR = BLACK
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->BG_COLOR = BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // setup_irq()
    // Set-up the raster IRQ
    jsr setup_irq
    // textcolor(WHITE)
    // Set text color
    jsr textcolor
    lda #<CANVAS1
    sta.z canvas
    lda #>CANVAS1
    sta.z canvas+1
  __b8:
    // clock_start()
    jsr clock_start
    // memset(canvas, 0, 0x0800)
    lda.z canvas
    sta.z memset.str
    lda.z canvas+1
    sta.z memset.str+1
  // Clear canvas
    ldx #0
    lda #<$800
    sta.z memset.num
    lda #>$800
    sta.z memset.num+1
    jsr memset
    // x0 = COSTAB[p0_idx]
    // Plot on canvas
    lda COSTAB+p0_idx
    sta.z x0
    // y0 = SINTAB[p0_idx]
    lda SINTAB+p0_idx
    sta.z y0
    // x1 = COSTAB[p1_idx]
    lda COSTAB+p1_idx
    sta.z x1
    // y1 = SINTAB[p1_idx]
    lda SINTAB+p1_idx
    sta.z y1
    // line(canvas, x0, y0, x1, y1)
    lda.z x0
    sta.z line.x1
    lda.z y0
    sta.z line.y1
    lda.z y1
    sta.z line.y2
    jsr line
    // canvas_show_memory ^= toD018(SCREEN,CANVAS1)^toD018(SCREEN,CANVAS2)
    //line(canvas, x1, y1, x2, y2);
    //line(canvas, x2, y2, x0, y0);
    // Move idx
    //p0_idx++;
    //p1_idx++;
    //p2_idx++;
    // Fill canvas
    //eorfill(canvas);
    // Swap canvas to show on screen (using XOR)
    lda #toD0181_return^toD0182_return
    eor.z canvas_show_memory
    sta.z canvas_show_memory
    // canvas ^= (CANVAS1^CANVAS2)
    // swap canvas being rendered to (using XOR)
    lda #<CANVAS1^CANVAS2
    eor.z canvas
    sta.z canvas
    lda #>CANVAS1^CANVAS2
    eor.z canvas+1
    sta.z canvas+1
    // clock()
    jsr clock
    // gotoxy(0,24)
    ldx #0
    lda #$18
    jsr gotoxy
    // printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1)
    ldx.z x0
    jsr printf_uchar
    // printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1)
    ldx.z y0
    jsr printf_uchar
    // printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1)
    ldx.z x1
    jsr printf_uchar
    // printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1)
    ldx.z y1
    jsr printf_uchar
    // printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // canvas_show_flag = 1
    // Wait until the canvas on screen has been switched before starting work on the next frame
    lda #1
    sta.z canvas_show_flag
  __b9:
    // while(canvas_show_flag)
    lda #0
    cmp.z canvas_show_flag
    bne __b9
    jmp __b8
  __b2:
    ldx.z y
    ldy #0
  __b4:
    // for(char x=0;x<16;x++)
    cpy #$10
    bcc __b5
    // cols += 40
    lda #$28
    clc
    adc.z cols
    sta.z cols
    bcc !+
    inc.z cols+1
  !:
    // screen += 40
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // for(char y=0;y<16;y++)
    inc.z y
    jmp __b1
  __b5:
    // cols[x] = WHITE
    lda #WHITE
    sta (cols),y
    // screen[x] = c
    txa
    sta (screen),y
    // c+=0x10
    txa
    axs #-[$10]
    // for(char x=0;x<16;x++)
    iny
    jmp __b4
    s2: .text ")-("
    .byte 0
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($27) s)
cputs: {
    .label s = $27
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
    lda.z conio_textcolor
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
    .label __1 = $15
    .label __2 = $17
    .label ln_offset = $2b
    // ln_offset = CONIO_WIDTH - conio_cursor_x
    sec
    lda #$28
    sbc.z conio_cursor_x
    sta.z ln_offset
    lda #0
    sbc #0
    sta.z ln_offset+1
    // conio_cursor_text  + ln_offset
    lda.z __1
    clc
    adc.z ln_offset
    sta.z __1
    lda.z __1+1
    adc.z ln_offset+1
    sta.z __1+1
    // conio_cursor_text =  conio_cursor_text  + ln_offset
    // conio_cursor_color + ln_offset
    lda.z __2
    clc
    adc.z ln_offset
    sta.z __2
    lda.z __2+1
    adc.z ln_offset+1
    sta.z __2+1
    // conio_cursor_color = conio_cursor_color + ln_offset
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
    .label __7 = $15
    .label __8 = $17
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
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    ldx.z conio_textcolor
    lda #<CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str
    lda #>CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str+1
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
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
// memset(void* zp($2b) str, byte register(X) c, word zp($29) num)
memset: {
    .label end = $29
    .label dst = $2b
    .label str = $2b
    .label num = $29
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // end = (char*)str + num
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
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
  __breturn:
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
// memcpy(void* zp($2b) destination, void* zp($29) source)
memcpy: {
    .label src_end = $25
    .label dst = $2b
    .label src = $29
    .label source = $29
    .label destination = $2b
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
// Print an unsigned char using a specific format
// printf_uchar(byte register(X) uvalue)
printf_uchar: {
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr uctoa
    // printf_number_buffer(printf_buffer, format)
    ldx printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte register(X) buffer_sign)
printf_number_buffer: {
    .const format_min_length = 2
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label __19 = $29
    .label padding = 8
    // strlen(buffer.digits)
    jsr strlen
    // strlen(buffer.digits)
    // len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    lda.z __19
    // if(buffer.sign)
    cpx #0
    beq __b8
    // len++;
    clc
    adc #1
  __b8:
    // padding = (signed char)format.min_length - len
    eor #$ff
    clc
    adc #format_min_length+1
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b2
    lda #0
    sta.z padding
  __b2:
    // if(buffer.sign)
    cpx #0
    beq __b10
    // cputc(buffer.sign)
    txa
    jsr cputc
  __b10:
    // if(format.zero_padding && padding)
    lda #0
    cmp.z padding
    bne __b7
    jmp __b3
  __b7:
    // printf_padding('0',(char)padding)
    jsr printf_padding
  __b3:
    // cputs(buffer.digits)
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
}
// Print a padding char a number of times
// printf_padding(byte zp(8) length)
printf_padding: {
    .label i = 9
    .label length = 8
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<length; i++)
    lda.z i
    cmp.z length
    bcc __b2
    // }
    rts
  __b2:
    // cputc(pad)
    lda #'0'
    jsr cputc
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($27) str)
strlen: {
    .label len = $29
    .label str = $27
    .label return = $29
    lda #<0
    sta.z len
    sta.z len+1
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($29) buffer)
uctoa: {
    .label digit_value = $20
    .label buffer = $29
    .label digit = 8
    .label started = 9
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #2-1
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
    // digit_value = digit_values[digit]
    ldy.z digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    lda #0
    cmp.z started
    bne __b5
    cpx.z digit_value
    bcs __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
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
    sta.z started
    jmp __b4
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// uctoa_append(byte* zp($29) buffer, byte register(X) value, byte zp($20) sub)
uctoa_append: {
    .label buffer = $29
    .label sub = $20
    ldy #0
  __b1:
    // while (value >= sub)
    cpx.z sub
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
    sbc.z sub
    tax
    jmp __b1
}
// Set the cursor to the specified position
// gotoxy(byte register(X) x, byte register(A) y)
gotoxy: {
    .label __4 = $17
    .label __6 = $15
    .label __7 = $17
    .label __8 = $17
    .label offset = $17
    .label __9 = $2b
    .label __10 = $17
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
    sta.z __6
    lda.z offset+1
    adc #>CONIO_SCREEN_TEXT
    sta.z __6+1
    // conio_cursor_text = CONIO_SCREEN_TEXT + offset
    // CONIO_SCREEN_COLORS + offset
    clc
    lda.z __7
    adc #<CONIO_SCREEN_COLORS
    sta.z __7
    lda.z __7+1
    adc #>CONIO_SCREEN_COLORS
    sta.z __7+1
    // conio_cursor_color = CONIO_SCREEN_COLORS + offset
    // }
    rts
}
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    rts
}
// Draw a EOR friendly line between two points
// Uses bresenham line drawing routine
// line(byte* zp(6) canvas, byte zp($f) x1, byte zp($10) y1, byte zp($1e) x2, byte zp($a) y2)
line: {
    .label canvas = 6
    .label x1 = $f
    .label y1 = $10
    .label x2 = $1e
    .label y2 = $a
    .label dx = $21
    .label dy = $22
    .label sx = $23
    .label sy = $24
    .label y = $10
    .label e1 = $12
    .label e = $b
    .label plot1_y = $10
    .label plot1_column = $25
    .label plot2_x = $f
    .label plot2_column = $27
    .label print_row = $d
    .label print_col = $c
    .label plot3_column = $29
    .label print_row_1 = $11
    .label print_col_1 = $e
    .label plot4_column = $2b
    .label x = $f
    // abs_u8(x2-x1)
    lda.z x2
    sec
    sbc.z x1
    jsr abs_u8
    // abs_u8(x2-x1)
    // dx = abs_u8(x2-x1)
    sta.z dx
    // abs_u8(y2-y1)
    lda.z y2
    sec
    sbc.z y1
    jsr abs_u8
    // abs_u8(y2-y1)
    // dy = abs_u8(y2-y1)
    sta.z dy
    // sgn_u8(x2-x1)
    lda.z x2
    sec
    sbc.z x1
    jsr sgn_u8
    // sgn_u8(x2-x1)
    // sx = sgn_u8(x2-x1)
    sta.z sx
    // sgn_u8(y2-y1)
    lda.z y2
    sec
    sbc.z y1
    jsr sgn_u8
    // sgn_u8(y2-y1)
    // sy = sgn_u8(y2-y1)
    sta.z sy
    // if(sx==0xff)
    lda #$ff
    cmp.z sx
    bne __b1
    // y++;
    inc.z y
    // y2++;
    inc.z y2
  __b1:
    // gotoxy(0,0)
    ldx #0
    txa
    jsr gotoxy
    // printf("dx:%02x dy:%02x sx:%02x sy:%02x",dx,dy,sx,sy)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("dx:%02x dy:%02x sx:%02x sy:%02x",dx,dy,sx,sy)
    ldx.z dx
    jsr printf_uchar
    // printf("dx:%02x dy:%02x sx:%02x sy:%02x",dx,dy,sx,sy)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("dx:%02x dy:%02x sx:%02x sy:%02x",dx,dy,sx,sy)
    ldx.z dy
    jsr printf_uchar
    // printf("dx:%02x dy:%02x sx:%02x sy:%02x",dx,dy,sx,sy)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("dx:%02x dy:%02x sx:%02x sy:%02x",dx,dy,sx,sy)
    ldx.z sx
    jsr printf_uchar
    // printf("dx:%02x dy:%02x sx:%02x sy:%02x",dx,dy,sx,sy)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("dx:%02x dy:%02x sx:%02x sy:%02x",dx,dy,sx,sy)
    ldx.z sy
    jsr printf_uchar
    // if(dx > dy)
    lda.z dy
    cmp.z dx
    bcs !__b2+
    jmp __b2
  !__b2:
    // e = dy/2
    lsr
    sta.z e
    // gotoxy(print_col, print_row)
    ldx #0
    lda #1
    jsr gotoxy
    // printf("%02x %02x %02x",x,y,e)
    ldx.z x1
    jsr printf_uchar
    // printf("%02x %02x %02x",x,y,e)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%02x %02x %02x",x,y,e)
    ldx.z plot1_y
    jsr printf_uchar
    // printf("%02x %02x %02x",x,y,e)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%02x %02x %02x",x,y,e)
    ldx.z e
    jsr printf_uchar
    // x/8
    lda.z x1
    lsr
    lsr
    lsr
    // canvas + plot_column[x/8]
    asl
    // column = canvas + plot_column[x/8]
    tay
    clc
    lda.z canvas
    adc plot_column,y
    sta.z plot1_column
    lda.z canvas+1
    adc plot_column+1,y
    sta.z plot1_column+1
    // x&7
    lda #7
    and.z x1
    // column[y] |= plot_bit[x&7]
    ldy.z plot1_y
    tax
    lda (plot1_column),y
    ora plot_bit,x
    sta (plot1_column),y
    lda #2
    sta.z print_row
    lda #0
    sta.z print_col
  __b6:
    // y += sy
    lda.z y
    clc
    adc.z sy
    sta.z y
    // e += dx
    lda.z e
    clc
    adc.z dx
    sta.z e
    // if(dy<e)
    lda.z dy
    cmp.z e
    bcc __b7
    // printf("*")
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
  __b8:
    // while (y != y2)
    lda.z y
    cmp.z y2
    bne __b6
    // gotoxy(20,24)
    ldx #$14
    lda #$18
    jsr gotoxy
    // printf("(%02x,%02x)", x, y)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("(%02x,%02x)", x, y)
    ldx.z x
    jsr printf_uchar
    // printf("(%02x,%02x)", x, y)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("(%02x,%02x)", x, y)
    ldx.z y
    jsr printf_uchar
    // printf("(%02x,%02x)", x, y)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  __b7:
    // x += sx
    lda.z plot2_x
    clc
    adc.z sx
    sta.z plot2_x
    // e -= dy
    lda.z e
    sec
    sbc.z dy
    sta.z e
    // if(print_col<40-8)
    lda.z print_col
    cmp #$28-8
    bcs __b9
    // gotoxy(print_col, print_row)
    tax
    lda.z print_row
    jsr gotoxy
    // printf("%02x %02x %02x",x,y,e)
    ldx.z plot2_x
    jsr printf_uchar
    // printf("%02x %02x %02x",x,y,e)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%02x %02x %02x",x,y,e)
    ldx.z y
    jsr printf_uchar
    // printf("%02x %02x %02x",x,y,e)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%02x %02x %02x",x,y,e)
    ldx.z e
    jsr printf_uchar
    // if(++print_row==24)
    inc.z print_row
    lda #$18
    cmp.z print_row
    bne __b9
    // print_col +=9
    lax.z print_col
    axs #-[9]
    stx.z print_col
    lda #1
    sta.z print_row
  __b9:
    // x/8
    lda.z plot2_x
    lsr
    lsr
    lsr
    // canvas + plot_column[x/8]
    asl
    // column = canvas + plot_column[x/8]
    tay
    clc
    lda.z canvas
    adc plot_column,y
    sta.z plot2_column
    lda.z canvas+1
    adc plot_column+1,y
    sta.z plot2_column+1
    // x&7
    lda #7
    and.z plot2_x
    // column[y] |= plot_bit[x&7]
    ldy.z y
    tax
    lda (plot2_column),y
    ora plot_bit,x
    sta (plot2_column),y
    jmp __b8
  __b2:
    // e = dx/2
    lda.z dx
    lsr
    sta.z e1
    lda #1
    sta.z print_row_1
    lda #0
    sta.z print_col_1
  __b14:
    // if(print_col<40-8)
    lda.z print_col_1
    cmp #$28-8
    bcs plot3
    // gotoxy(print_col, print_row)
    tax
    lda.z print_row_1
    jsr gotoxy
    // printf("%02x %02x %02x",x,y,e)
    ldx.z x
    jsr printf_uchar
    // printf("%02x %02x %02x",x,y,e)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%02x %02x %02x",x,y,e)
    ldx.z y
    jsr printf_uchar
    // printf("%02x %02x %02x",x,y,e)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%02x %02x %02x",x,y,e)
    ldx.z e1
    jsr printf_uchar
    // if(++print_row==24)
    inc.z print_row_1
    lda #$18
    cmp.z print_row_1
    bne plot3
    // print_col +=9
    lax.z print_col_1
    axs #-[9]
    stx.z print_col_1
    lda #1
    sta.z print_row_1
  plot3:
    // x/8
    lda.z x
    lsr
    lsr
    lsr
    // canvas + plot_column[x/8]
    asl
    // column = canvas + plot_column[x/8]
    tay
    clc
    lda.z canvas
    adc plot_column,y
    sta.z plot3_column
    lda.z canvas+1
    adc plot_column+1,y
    sta.z plot3_column+1
    // x&7
    lda #7
    and.z x
    // column[y] |= plot_bit[x&7]
    ldy.z y
    tax
    lda (plot3_column),y
    ora plot_bit,x
    sta (plot3_column),y
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    // e += dy
    lda.z e1
    clc
    adc.z dy
    sta.z e1
    // if(dx < e)
    lda.z dx
    cmp.z e1
    bcs __b16
    // y += sy
    tya
    clc
    adc.z sy
    sta.z y
    // e -= dx
    lda.z e1
    sec
    sbc.z dx
    sta.z e1
  __b16:
    // while (x != x2)
    lda.z x
    cmp.z x2
    beq !__b14+
    jmp __b14
  !__b14:
    // x/8
    lsr
    lsr
    lsr
    // canvas + plot_column[x/8]
    asl
    // column = canvas + plot_column[x/8]
    tay
    clc
    lda.z canvas
    adc plot_column,y
    sta.z plot4_column
    lda.z canvas+1
    adc plot_column+1,y
    sta.z plot4_column+1
    // x&7
    lda #7
    and.z x
    // column[y] |= plot_bit[x&7]
    ldy.z y
    tax
    lda (plot4_column),y
    ora plot_bit,x
    sta (plot4_column),y
    rts
    s: .text "dx:"
    .byte 0
    s1: .text " dy:"
    .byte 0
    s2: .text " sx:"
    .byte 0
    s3: .text " sy:"
    .byte 0
    s4: .text " "
    .byte 0
    s6: .text "*"
    .byte 0
}
// Get the sign of a 8-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is negative
// sgn_u8(byte register(A) u)
sgn_u8: {
    // u & 0x80
    and #$80
    // if(u & 0x80)
    cmp #0
    bne __b1
    lda #1
    rts
  __b1:
    lda #-1
    // }
    rts
}
// Get the absolute value of a u-bit unsigned number treated as a signed number.
// abs_u8(byte register(A) u)
abs_u8: {
    // u & 0x80
    ldx #$80
    axs #0
    // if(u & 0x80)
    cpx #0
    bne __b1
    rts
  __b1:
    // return -u;
    eor #$ff
    clc
    adc #1
    // }
    rts
}
// Reset & start the processor clock time. The value can be read using clock().
// This uses CIA #2 Timer A+B on the C64
clock_start: {
    // CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    // Setup CIA#2 timer A to count (down) CPU cycles
    lda #0
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // CIA2->TIMER_B_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    // *CIA2_TIMER_AB = 0xffffffff
    lda #<$ffffffff
    sta CIA2_TIMER_AB
    lda #>$ffffffff
    sta CIA2_TIMER_AB+1
    lda #<$ffffffff>>$10
    sta CIA2_TIMER_AB+2
    lda #>$ffffffff>>$10
    sta CIA2_TIMER_AB+3
    // CIA2->TIMER_B_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_START|CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    // CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    lda #CIA_TIMER_CONTROL_START
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // }
    rts
}
// Set the color for text output. The old color setting is returned.
textcolor: {
    // conio_textcolor = color
    lda #WHITE
    sta.z conio_textcolor
    // }
    rts
}
// Setup raster IRQ to change charset at different lines
setup_irq: {
    // asm
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // VICII->CONTROL1 &= 0x7f
    // Set raster line to 8 pixels before the border
    lda #$7f
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->RASTER = BORDER_YPOS_BOTTOM-8
    lda #BORDER_YPOS_BOTTOM-8
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // VICII->IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE
    // *KERNEL_IRQ = &irq_bottom_1
    // Set the IRQ routine
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    // asm
    cli
    // }
    rts
}
// Interrupt Routine 2
irq_bottom_2: {
    // VICII->BORDER_COLOR = BLACK
    // Change border color
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // kbhit()
    jsr kbhit
    // if(!kbhit())
    cmp #0
    bne __b1
    // VICII->MEMORY = canvas_show_memory
    lda.z canvas_show_memory
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
  __b1:
    // canvas_show_flag = 0
    lda #0
    sta.z canvas_show_flag
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->RASTER = BORDER_YPOS_BOTTOM-8
    // Trigger IRQ 1 at 8 pixels before the border
    lda #BORDER_YPOS_BOTTOM-8
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *KERNEL_IRQ = &irq_bottom_1
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    // }
    jmp $ea31
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
// Interrupt Routine 1: Just above last text line.
irq_bottom_1: {
    .const toD0181_return = (>(CONSOLE&$3fff)*4)|(>PETSCII)/4&$f
    // VICII->BORDER_COLOR = WHITE
    // Change border color
    lda #WHITE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->MEMORY = toD018(CONSOLE, PETSCII)
    // Show the cycle counter
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->RASTER = BORDER_YPOS_BOTTOM
    // Trigger IRQ 2 at bottom of text-line
    lda #BORDER_YPOS_BOTTOM
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *KERNEL_IRQ = &irq_bottom_2
    lda #<irq_bottom_2
    sta KERNEL_IRQ
    lda #>irq_bottom_2
    sta KERNEL_IRQ+1
    // }
    jmp $ea81
}
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // SIN/COS tables
  .align $100
SINTAB:
.fill $200, 63 + 63*sin(i*2*PI/$100)

  // Column offsets
  plot_column: .word 0, 1*$80, 2*$80, 3*$80, 4*$80, 5*$80, 6*$80, 7*$80, 8*$80, 9*$80, $a*$80, $b*$80, $c*$80, $d*$80, $e*$80, $f*$80
  // The bits used for plotting a pixel
  plot_bit: .byte $80, $40, $20, $10, 8, 4, 2, 1
  s: .text "("
  .byte 0
  s1: .text ","
  .byte 0
  s4: .text ")"
  .byte 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
