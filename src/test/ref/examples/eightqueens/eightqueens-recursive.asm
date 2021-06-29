// N Queens Problem in C Using Backtracking
//
// N Queens Problem is a famous puzzle in which n-queens are to be placed on a nxn chess board such that no two queens are in the same row, column or diagonal.  
//
// This is a recursive solution
  // Commodore 64 PRG executable file
.file [name="eightqueens-recursive.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const LIGHT_BLUE = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// Color Ram
  .label COLORRAM = $d800
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $11
  // The current cursor y-position
  .label conio_cursor_y = $12
  // The current text cursor line start
  .label conio_line_text = $13
  // The current color cursor line start
  .label conio_line_color = $15
  // The number of found solutions
  .label count = $17
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
    // unsigned long count = 0
    lda #<0
    sta.z count
    sta.z count+1
    lda #<0>>$10
    sta.z count+2
    lda #>0>>$10
    sta.z count+3
    // #pragma constructor_for(conio_c64_init, cputc, clrscr, cscroll)
    jsr conio_c64_init
    jsr main
    rts
}
// Generates all valid placements of queens on a NxN board recursively
// Works by generating all legal placements af a queen for a specific row taking into consideration the queens already placed on the rows below 
// and then recursively generating all legal placements on the rows above.  
// queen(byte zp($1b) row)
queen: {
    .const OFFSET_STACK_ROW = 0
    .label r = $1c
    .label column = $1d
    .label __1 = 4
    .label __4 = $1e
    .label row = $1b
    tsx
    lda STACK_BASE+OFFSET_STACK_ROW,x
    sta.z row
    // __ma char r = row
    sta.z r
    // __ma char column=1
    lda #1
    sta.z column
  __b1:
    // for(__ma char column=1;column<=QUEENS;++column)
    lda.z column
    cmp #8+1
    bcc __b2
    // }
    rts
  __b2:
    // legal(r,column)
    lda.z r
    sta.z legal.row
    lda.z column
    sta.z legal.column
    jsr legal
    // legal(r,column)
    // if(legal(r,column))
    lda.z __1
    beq __b3
    // board[r]=column
    //no conflicts so place queen
    lda.z column
    ldy.z r
    sta board,y
    // if(r==QUEENS)
    lda #8
    cmp.z r
    beq __b4
    // asm
    // Perform recussive placement on rows above
    // Push the local vars on the stack (waiting for proper recursion support)
    lda column
    pha
    tya
    pha
    // r+1
    tay
    iny
    sty.z __4
    // queen(r+1)
    // Do recursion        
    tya
    pha
    jsr queen
    pla
    // asm
    // Pop the local vars on the stack (waiting for proper recursion support)
    pla
    sta r
    pla
    sta column
  __b3:
    // for(__ma char column=1;column<=QUEENS;++column)
    inc.z column
    jmp __b1
  __b4:
    // count++;
    inc.z count
    bne !+
    inc.z count+1
    bne !+
    inc.z count+2
    bne !+
    inc.z count+3
  !:
    // print()
    jsr print
    jmp __b3
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = 2
    // char line = *BASIC_CURSOR_LINE
    lda BASIC_CURSOR_LINE
    sta.z line
    // if(line>=CONIO_HEIGHT)
    cmp #$19
    bcc __b1
    lda #$19-1
    sta.z line
  __b1:
    // gotoxy(0, line)
    jsr gotoxy
    // }
    rts
}
main: {
    // clrscr()
    jsr clrscr
    // printf(" - n queens problem using backtracking -")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("\nnumber of queens:%u",QUEENS)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("\nnumber of queens:%u",QUEENS)
    jsr printf_uint
    // queen(1)
    lda #1
    pha
    jsr queen
    pla
    // printf("\n\nsolutions: %lu.\n",count)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("\n\nsolutions: %lu.\n",count)
    lda.z count
    sta.z printf_ulong.uvalue
    lda.z count+1
    sta.z printf_ulong.uvalue+1
    lda.z count+2
    sta.z printf_ulong.uvalue+2
    lda.z count+3
    sta.z printf_ulong.uvalue+3
    jsr printf_ulong
    // printf("\n\nsolutions: %lu.\n",count)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  .segment Data
    s: .text " - n queens problem using backtracking -"
    .byte 0
    s1: .text @"\nnumber of queens:"
    .byte 0
    s2: .text @"\n\nsolutions: "
    .byte 0
    s3: .text @".\n"
    .byte 0
}
.segment Code
// Checks is a placement of the queen on the board is legal.
// Checks the passed (row, column) against all queens placed on the board on lower rows.
// If no conflict for desired position returns 1 otherwise returns 0
// legal(byte zp($1e) row, byte zp($25) column)
legal: {
    .label __0 = $26
    .label __3 = $29
    .label __4 = $d
    .label row = $1e
    .label column = $25
    // Placement is legal
    // The same column is a conflict.
    // The same diagonal is a conflict.
    .label return = 4
    .label i = 3
    lda #1
    sta.z i
  __b1:
    // row-1
    ldx.z row
    dex
    stx.z __0
    // for(char i=1;i<=row-1;++i)
    txa
    cmp.z i
    bcs __b2
    lda #1
    sta.z return
    rts
  __b4:
    lda #0
    sta.z return
    // }
    rts
  __b2:
    // if(board[i]==column)
    ldy.z i
    lda board,y
    cmp.z column
    beq __b4
    // diff(board[i],column)
    lda board,y
    sta.z diff.a
    lda.z column
    sta.z diff.b
    jsr diff
    // diff(board[i],column)
    lda.z diff.return_1
    sta.z diff.return
    // diff(i,row)
    lda.z i
    sta.z diff.a
    lda.z row
    sta.z diff.b
    jsr diff
    // diff(i,row)
    // if(diff(board[i],column)==diff(i,row))
    lda.z __3
    cmp.z __4
    bne __b3
    jmp __b4
  __b3:
    // for(char i=1;i<=row-1;++i)
    inc.z i
    jmp __b1
}
// Print the board with a legal placement. Also increments the solution count.
print: {
    .label i = 3
    .label i1 = 3
    .label j = 9
    // gotoxy(0,5)
    lda #5
    sta.z gotoxy.y
    jsr gotoxy
    // printf("\n#%lu:\n ",count)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("\n#%lu:\n ",count)
    lda.z count
    sta.z printf_ulong.uvalue
    lda.z count+1
    sta.z printf_ulong.uvalue+1
    lda.z count+2
    sta.z printf_ulong.uvalue+2
    lda.z count+3
    sta.z printf_ulong.uvalue+3
    jsr printf_ulong
    // printf("\n#%lu:\n ",count)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    lda #1
    sta.z i
  __b1:
    // for(char i=1;i<=QUEENS;++i)
    lda.z i
    cmp #8+1
    bcc __b2
    lda #1
    sta.z i1
  __b3:
    // for(char i=1;i<=QUEENS;++i)
    lda.z i1
    cmp #8+1
    bcc __b4
    // }
    rts
  __b4:
    // printf("\n%x",i)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("\n%x",i)
    jsr printf_uchar
    lda #1
    sta.z j
  __b5:
    // for(char j=1;j<=QUEENS;++j)
    lda.z j
    cmp #8+1
    bcc __b6
    // for(char i=1;i<=QUEENS;++i)
    inc.z i1
    jmp __b3
  __b6:
    // if(board[i]==j)
    ldy.z i1
    lda board,y
    cmp.z j
    beq __b8
    // printf("-")
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
  __b9:
    // for(char j=1;j<=QUEENS;++j)
    inc.z j
    jmp __b5
  __b8:
    // printf("Q")
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    jmp __b9
  __b2:
    // printf("%x",i)
    jsr printf_uchar
    // for(char i=1;i<=QUEENS;++i)
    inc.z i
    jmp __b1
  .segment Data
    s: .text @"\n#"
    .byte 0
    s1: .text @":\n "
    .byte 0
    s2: .text @"\n"
    .byte 0
    s3: .text "Q"
    .byte 0
    s4: .text "-"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// gotoxy(byte zp(2) y)
gotoxy: {
    .label __5 = $23
    .label __6 = $1f
    .label __7 = $1f
    .label line_offset = $1f
    .label y = 2
    .label __8 = $21
    .label __9 = $1f
    // if(y>CONIO_HEIGHT)
    lda.z y
    cmp #$19+1
    bcc __b2
    lda #0
    sta.z y
  __b2:
    // conio_cursor_x = x
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = y
    lda.z y
    sta.z conio_cursor_y
    // (unsigned int)y*CONIO_WIDTH
    lda.z y
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
    .label c = 9
    .label line_text = $a
    .label line_cols = $f
    .label l = 4
    lda #<COLORRAM
    sta.z line_cols
    lda #>COLORRAM
    sta.z line_cols+1
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    lda #0
    sta.z l
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    lda.z l
    cmp #$19
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
    lda #0
    sta.z c
  __b3:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    lda.z c
    cmp #$28
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
    inc.z l
    jmp __b1
  __b4:
    // line_text[c] = ' '
    lda #' '
    ldy.z c
    sta (line_text),y
    // line_cols[c] = conio_textcolor
    lda #LIGHT_BLUE
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    inc.z c
    jmp __b3
}
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp($a) s)
cputs: {
    .label c = $d
    .label s = $a
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    sta.z c
    inc.z s
    bne !+
    inc.z s+1
  !:
    lda.z c
    bne __b2
    // }
    rts
  __b2:
    // cputc(c)
    jsr cputc
    jmp __b1
}
// Print an unsigned int using a specific format
printf_uint: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    .label uvalue = 8
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr utoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #format_upper_case
    sta.z printf_number_buffer.format_upper_case
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    lda #format_min_length
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Print an unsigned int using a specific format
// printf_ulong(dword zp(5) uvalue)
printf_ulong: {
    .label uvalue = 5
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr ultoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_upper_case
    sta.z printf_number_buffer.format_zero_padding
    sta.z printf_number_buffer.format_justify_left
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Find the absolute difference between two unsigned chars
// diff(byte zp($d) a, byte zp(9) b)
diff: {
    .label a = $d
    .label b = 9
    .label return = $29
    .label return_1 = $d
    // if(a<b)
    lda.z a
    cmp.z b
    bcc __b1
    // return a-b;
    lda.z return_1
    sec
    sbc.z b
    sta.z return_1
    // }
    rts
  __b1:
    // return b-a;
    lda.z b
    sec
    sbc.z return_1
    sta.z return_1
    rts
}
// Print an unsigned char using a specific format
// printf_uchar(byte zp(3) uvalue)
printf_uchar: {
    .label uvalue = 3
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    lda.z uvalue
    sta.z uctoa.value
  // Format number into buffer
    jsr uctoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_upper_case
    sta.z printf_number_buffer.format_zero_padding
    sta.z printf_number_buffer.format_justify_left
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($d) c)
cputc: {
    .label c = $d
    // if(c=='\n')
    lda #'\n'
    cmp.z c
    beq __b1
    // conio_line_text[conio_cursor_x] = c
    lda.z c
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($f) value, byte* zp($a) buffer)
utoa: {
    .const max_digits = 5
    .label __10 = $26
    .label __11 = $25
    .label digit_value = $27
    .label buffer = $a
    .label digit = 9
    .label value = $f
    .label started = $1e
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    lda #<printf_uint.uvalue
    sta.z value
    lda #>printf_uint.uvalue
    sta.z value+1
    lda #0
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda.z value
    sta.z __11
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
    // }
    rts
  __b2:
    // unsigned int digit_value = digit_values[digit]
    lda.z digit
    asl
    sta.z __10
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    lda.z started
    bne __b5
    lda.z digit_value+1
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // utoa_append(buffer++, value, digit_value)
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #1
    sta.z started
    jmp __b4
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($29) buffer_sign, byte zp($1e) format_min_length, byte zp($25) format_justify_left, byte zp($26) format_zero_padding, byte zp($c) format_upper_case)
printf_number_buffer: {
    .label __19 = $27
    .label buffer_sign = $29
    .label len = $d
    .label padding = $1e
    .label format_min_length = $1e
    .label format_zero_padding = $26
    .label format_justify_left = $25
    .label format_upper_case = $c
    // if(format.min_length)
    lda.z format_min_length
    beq __b6
    // strlen(buffer.digits)
    jsr strlen
    // strlen(buffer.digits)
    // signed char len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    lda.z __19
    sta.z len
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b13
    // len++;
    inc.z len
  __b13:
    // padding = (signed char)format.min_length - len
    lda.z padding
    sec
    sbc.z len
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
  __b6:
    lda #0
    sta.z padding
  __b1:
    // if(!format.justify_left && !format.zero_padding && padding)
    lda.z format_justify_left
    bne __b2
    lda.z format_zero_padding
    bne __b2
    lda.z padding
    cmp #0
    bne __b8
    jmp __b2
  __b8:
    // printf_padding(' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b3
    // cputc(buffer.sign)
    sta.z cputc.c
    jsr cputc
  __b3:
    // if(format.zero_padding && padding)
    lda.z format_zero_padding
    beq __b4
    lda.z padding
    cmp #0
    bne __b10
    jmp __b4
  __b10:
    // printf_padding('0',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #'0'
    sta.z printf_padding.pad
    jsr printf_padding
  __b4:
    // if(format.upper_case)
    lda.z format_upper_case
    beq __b5
    // strupr(buffer.digits)
    jsr strupr
  __b5:
    // cputs(buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s+1
    jsr cputs
    // if(format.justify_left && !format.zero_padding && padding)
    lda.z format_justify_left
    beq __breturn
    lda.z format_zero_padding
    bne __breturn
    lda.z padding
    cmp #0
    bne __b12
    rts
  __b12:
    // printf_padding(' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __breturn:
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zp(5) value, byte* zp($a) buffer)
ultoa: {
    .label __10 = $2e
    .label __11 = $29
    .label digit_value = $2a
    .label buffer = $a
    .label digit = $25
    .label value = 5
    .label started = $26
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
    cmp #$a-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda.z value
    sta.z __11
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
    // }
    rts
  __b2:
    // unsigned long digit_value = digit_values[digit]
    lda.z digit
    asl
    asl
    sta.z __10
    tay
    lda RADIX_DECIMAL_VALUES_LONG,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES_LONG+1,y
    sta.z digit_value+1
    lda RADIX_DECIMAL_VALUES_LONG+2,y
    sta.z digit_value+2
    lda RADIX_DECIMAL_VALUES_LONG+3,y
    sta.z digit_value+3
    // if (started || value >= digit_value)
    lda.z started
    bne __b5
    lda.z value+3
    cmp.z digit_value+3
    bcc !+
    bne __b5
    lda.z value+2
    cmp.z digit_value+2
    bcc !+
    bne __b5
    lda.z value+1
    cmp.z digit_value+1
    bcc !+
    bne __b5
    lda.z value
    cmp.z digit_value
    bcs __b5
  !:
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // ultoa_append(buffer++, value, digit_value)
    jsr ultoa_append
    // ultoa_append(buffer++, value, digit_value)
    // value = ultoa_append(buffer++, value, digit_value)
    // value = ultoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #1
    sta.z started
    jmp __b4
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte zp($c) value, byte* zp($f) buffer)
uctoa: {
    .label digit_value = $2e
    .label buffer = $f
    .label digit = $29
    .label value = $c
    .label started = $d
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
    ldy.z value
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
    // }
    rts
  __b2:
    // unsigned char digit_value = digit_values[digit]
    ldy.z digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    lda.z started
    bne __b5
    lda.z value
    cmp.z digit_value
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
// utoa_append(byte* zp($a) buffer, word zp($f) value, word zp($27) sub)
utoa_append: {
    .label buffer = $a
    .label value = $f
    .label sub = $27
    .label return = $f
    .label digit = $e
    lda #0
    sta.z digit
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
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inc.z digit
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
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($f) str)
strlen: {
    .label len = $27
    .label str = $f
    .label return = $27
    lda #<0
    sta.z len
    sta.z len+1
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
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
// Print a padding char a number of times
// printf_padding(byte zp($d) pad, byte zp($e) length)
printf_padding: {
    .label i = $2e
    .label length = $e
    .label pad = $d
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
    jsr cputc
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Converts a string to uppercase.
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label __0 = $e
    .label src = $27
    lda #<str
    sta.z src
    lda #>str
    sta.z src+1
  __b1:
    // while(*src)
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // toupper(*src)
    ldy #0
    lda (src),y
    sta.z toupper.ch
    jsr toupper
    // *src = toupper(*src)
    lda.z __0
    ldy #0
    sta (src),y
    // src++;
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// ultoa_append(byte* zp($a) buffer, dword zp(5) value, dword zp($2a) sub)
ultoa_append: {
    .label buffer = $a
    .label value = 5
    .label sub = $2a
    .label return = 5
    .label digit = $2e
    lda #0
    sta.z digit
  __b1:
    // while (value >= sub)
    lda.z value+3
    cmp.z sub+3
    bcc !+
    bne __b2
    lda.z value+2
    cmp.z sub+2
    bcc !+
    bne __b2
    lda.z value+1
    cmp.z sub+1
    bcc !+
    bne __b2
    lda.z value
    cmp.z sub
    bcs __b2
  !:
    // *buffer = DIGITS[digit]
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inc.z digit
    // value -= sub
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    lda.z value+2
    sbc.z sub+2
    sta.z value+2
    lda.z value+3
    sbc.z sub+3
    sta.z value+3
    jmp __b1
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// uctoa_append(byte* zp($f) buffer, byte zp($c) value, byte zp($2e) sub)
uctoa_append: {
    .label buffer = $f
    .label value = $c
    .label sub = $2e
    .label return = $c
    .label digit = $e
    lda #0
    sta.z digit
  __b1:
    // while (value >= sub)
    lda.z value
    cmp.z sub
    bcs __b2
    // *buffer = DIGITS[digit]
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inc.z digit
    // value -= sub
    lda.z value
    sec
    sbc.z sub
    sta.z value
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
    lda #' '
    sta.z memset.c
    lda #<DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str
    lda #>DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    lda #LIGHT_BLUE
    sta.z memset.c
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
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// toupper(byte zp($e) ch)
toupper: {
    .label return = $e
    .label ch = $e
    // if(ch>='a' && ch<='z')
    lda.z ch
    cmp #'a'
    bcc __breturn
    lda #'z'
    cmp.z ch
    bcs __b1
    rts
  __b1:
    // return ch + ('A'-'a');
    lax.z return
    axs #-['A'-'a']
    stx.z return
  __breturn:
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($f) destination, void* zp($27) source)
memcpy: {
    .label src_end = $2f
    .label dst = $f
    .label src = $27
    .label source = $27
    .label destination = $f
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
// memset(void* zp($f) str, byte zp($1b) c)
memset: {
    .label end = $2f
    .label dst = $f
    .label str = $f
    .label c = $1b
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
    lda.z c
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
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // The board. board[i] holds the column position of the queen on row i. 
  board: .fill $14, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
