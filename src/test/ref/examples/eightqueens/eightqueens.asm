// N Queens Problem in C Using Backtracking
//
// N Queens Problem is a famous puzzle in which n-queens are to be placed on a nxn chess board such that no two queens are in the same row, column or diagonal.
//
// This is an iterative solution.
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .label printf_cursor_x = $17
  .label printf_cursor_y = $18
  .label printf_cursor_ptr = $19
  // The number of found solutions
  .label count = 2
__bbegin:
  // printf_cursor_x = 0
  // X-position of cursor
  lda #0
  sta.z printf_cursor_x
  // printf_cursor_y = 0
  // Y-position of cursor
  sta.z printf_cursor_y
  // printf_cursor_ptr = PRINTF_SCREEN_ADDRESS
  // Pointer to cursor address
  lda #<$400
  sta.z printf_cursor_ptr
  lda #>$400
  sta.z printf_cursor_ptr+1
  jsr main
  rts
main: {
    // printf_cls()
    jsr printf_cls
    // printf(" - n queens problem using backtracking -")
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\nNumber of queens:%u",QUEENS)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\nNumber of queens:%u",QUEENS)
    jsr printf_uint
    // queens()
    jsr queens
    // }
    rts
    str: .text " - n queens problem using backtracking -"
    .byte 0
    str1: .text @"\nNumber of queens:"
    .byte 0
}
// Generates all valid placements of queens on a NxN board without recursion
// Works exactly like the recursive solution by generating all legal placements af a queen for a specific row taking into consideration the queens already placed on the rows below 
// and then moving on to generating all legal placements on the rows above.
// In practice this works like a depth first tree search where the level in the tree is the row on the board and each branch in the tree is the legal placement of a queen on that row. 
// The solution uses the board itself as a "cursor" moving through all possibilities
// When all columns on a row is exhausted move back down to the lower level and move forward one position until we are done with the last position on the first row
queens: {
    // The current row where the queen is moving
    .label row = $12
    lda #<0
    sta.z count
    sta.z count+1
    lda #<0>>$10
    sta.z count+2
    lda #>0>>$10
    sta.z count+3
    lda #1
    sta.z row
  __b2:
    // board[row]++;
    ldx.z row
    inc board,x
    // if(board[row]==QUEENS+1)
    ldy.z row
    lda board,y
    cmp #8+1
    beq __b3
    // legal(row, board[row])
    lda board,y
    sta.z legal.column
    jsr legal
    // legal(row, board[row])
    // if(legal(row, board[row]))
    // check if the current position on row 1-row is legal  
    cmp #0
    bne __b4
    jmp __b2
  __b4:
    // if(row==QUEENS)
    // position is legal - move up to the next row
    lda #8
    cmp.z row
    beq __b5
    // row++;
    inc.z row
    jmp __b2
  __b5:
    // print()
    // We have a complete legal board - print it!
    jsr print
    jmp __b2
  __b3:
    // board[row] = 0
    // We moved past the end of the row - reset position and go down to the lower row
    lda #0
    ldy.z row
    sta board,y
    // if(row==1)
    lda #1
    cmp.z row
    beq __breturn
    // row--;
    dec.z row
    jmp __b2
  __breturn:
    // }
    rts
}
// Print the board with a legal placement. Also increments the solution count.
print: {
    .label i = $1b
    .label i1 = $21
    .label j = 6
    // printf("\n#%lu:\n ",++count);
    inc.z count
    bne !+
    inc.z count+1
    bne !+
    inc.z count+2
    bne !+
    inc.z count+3
  !:
    // printf("\n#%lu:\n ",++count)
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\n#%lu:\n ",++count)
    jsr printf_ulong
    // printf("\n#%lu:\n ",++count)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\n%x",i)
    ldx.z i1
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
    lda #<str4
    sta.z printf_str.str
    lda #>str4
    sta.z printf_str.str+1
    jsr printf_str
  __b9:
    // for(char j=1;j<=QUEENS;++j)
    inc.z j
    jmp __b5
  __b8:
    // printf("Q")
    lda #<str3
    sta.z printf_str.str
    lda #>str3
    sta.z printf_str.str+1
    jsr printf_str
    jmp __b9
  __b2:
    // printf("%x",i)
    ldx.z i
    jsr printf_uchar
    // for(char i=1;i<=QUEENS;++i)
    inc.z i
    jmp __b1
    str: .text @"\n#"
    .byte 0
    str1: .text @":\n "
    .byte 0
    str2: .text @"\n"
    .byte 0
    str3: .text "Q"
    .byte 0
    str4: .text "-"
    .byte 0
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
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_upper_case
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #0
    sta.z printf_number_buffer.format_zero_padding
    sta.z printf_number_buffer.format_justify_left
    tax
    jsr printf_number_buffer
    // }
    rts
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($d) buffer_sign, byte* zp($13) buffer_digits, byte register(X) format_min_length, byte zp($b) format_justify_left, byte zp($c) format_zero_padding, byte zp($1c) format_upper_case)
printf_number_buffer: {
    .label __19 = $22
    .label buffer_sign = $d
    .label padding = 7
    .label format_zero_padding = $c
    .label format_justify_left = $b
    .label buffer_digits = $13
    .label format_upper_case = $1c
    // if(format.min_length)
    cpx #0
    beq __b6
    // strlen(buffer.digits)
    lda.z buffer_digits
    sta.z strlen.str
    lda.z buffer_digits+1
    sta.z strlen.str+1
    jsr strlen
    // strlen(buffer.digits)
    // len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    lda.z __19
    tay
    // if(buffer.sign)
    lda #0
    cmp.z buffer_sign
    beq __b13
    // len++;
    iny
  __b13:
    // padding = (signed char)format.min_length - len
    txa
    sty.z $ff
    sec
    sbc.z $ff
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
  __b6:
    lda #0
    sta.z padding
  __b1:
    // if(!format.justify_left && !format.zero_padding && padding)
    lda #0
    cmp.z format_justify_left
    bne __b2
    cmp.z format_zero_padding
    bne __b2
    cmp.z padding
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
    lda #0
    cmp.z buffer_sign
    beq __b3
    // printf_char(buffer.sign)
    lda.z buffer_sign
    jsr printf_char
  __b3:
    // if(format.zero_padding && padding)
    lda #0
    cmp.z format_zero_padding
    beq __b4
    cmp.z padding
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
    lda #0
    cmp.z format_upper_case
    beq __b5
    // strupr(buffer.digits)
    lda.z buffer_digits
    sta.z strupr.str
    lda.z buffer_digits+1
    sta.z strupr.str+1
    jsr strupr
  __b5:
    // printf_str(buffer.digits)
    jsr printf_str
    // if(format.justify_left && !format.zero_padding && padding)
    lda #0
    cmp.z format_justify_left
    beq __breturn
    cmp.z format_zero_padding
    bne __breturn
    cmp.z padding
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
// Print a padding char a number of times
// printf_padding(byte zp(9) pad, byte zp(8) length)
printf_padding: {
    .label i = $a
    .label length = 8
    .label pad = 9
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
    // printf_char(pad)
    lda.z pad
    jsr printf_char
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Print a single char
// If the end of the screen is reached scroll it up one char and place the cursor at the
// printf_char(byte register(A) ch)
printf_char: {
    // *(printf_cursor_ptr++) = ch
    ldy #0
    sta (printf_cursor_ptr),y
    // *(printf_cursor_ptr++) = ch;
    inc.z printf_cursor_ptr
    bne !+
    inc.z printf_cursor_ptr+1
  !:
    // if(++printf_cursor_x==PRINTF_SCREEN_WIDTH)
    inc.z printf_cursor_x
    lda #$28
    cmp.z printf_cursor_x
    bne __breturn
    // printf_cursor_x = 0
    lda #0
    sta.z printf_cursor_x
    // ++printf_cursor_y;
    inc.z printf_cursor_y
    // printf_scroll()
    jsr printf_scroll
  __breturn:
    // }
    rts
}
// Scroll the entire screen if the cursor is on the last line
printf_scroll: {
    .label __4 = $19
    // if(printf_cursor_y==PRINTF_SCREEN_HEIGHT)
    lda #$19
    cmp.z printf_cursor_y
    bne __breturn
    // memcpy(PRINTF_SCREEN_ADDRESS, PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_WIDTH, PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH)
    jsr memcpy
    // memset(PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH, ' ', PRINTF_SCREEN_WIDTH)
    ldx #' '
    lda #<$400+$28*$19-$28
    sta.z memset.str
    lda #>$400+$28*$19-$28
    sta.z memset.str+1
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
    jsr memset
    // printf_cursor_ptr-PRINTF_SCREEN_WIDTH
    lda.z __4
    sec
    sbc #<$28
    sta.z __4
    lda.z __4+1
    sbc #>$28
    sta.z __4+1
    // printf_cursor_ptr = printf_cursor_ptr-PRINTF_SCREEN_WIDTH
    // printf_cursor_y--;
    dec.z printf_cursor_y
  __breturn:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($22) str, byte register(X) c, word zp($15) num)
memset: {
    .label end = $15
    .label dst = $22
    .label num = $15
    .label str = $22
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
memcpy: {
    .label destination = $400
    .label source = $400+$28
    .const num = $28*$19-$28
    .label src_end = source+num
    .label dst = $22
    .label src = $15
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    lda #<source
    sta.z src
    lda #>source
    sta.z src+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp #>src_end
    bne __b2
    lda.z src
    cmp #<src_end
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
// Print a zero-terminated string
// Handles escape codes such as newline
// printf_str(byte* zp($13) str)
printf_str: {
    .label str = $13
  __b2:
    // ch = *str++
    ldy #0
    lda (str),y
    inc.z str
    bne !+
    inc.z str+1
  !:
    // if(ch==0)
    cmp #0
    bne __b3
    // }
    rts
  __b3:
    // if(ch=='\n')
    cmp #'\n'
    beq __b4
    // printf_char(ch)
    jsr printf_char
    jmp __b2
  __b4:
    // printf_ln()
    jsr printf_ln
    jmp __b2
}
// Print a newline
printf_ln: {
    .label __0 = $19
    .label __1 = $19
    // printf_cursor_ptr - printf_cursor_x
    sec
    lda.z __0
    sbc.z printf_cursor_x
    sta.z __0
    bcs !+
    dec.z __0+1
  !:
    // printf_cursor_ptr - printf_cursor_x + PRINTF_SCREEN_WIDTH
    lda #$28
    clc
    adc.z __1
    sta.z __1
    bcc !+
    inc.z __1+1
  !:
    // printf_cursor_ptr =  printf_cursor_ptr - printf_cursor_x + PRINTF_SCREEN_WIDTH
    // printf_cursor_x = 0
    lda #0
    sta.z printf_cursor_x
    // printf_cursor_y++;
    inc.z printf_cursor_y
    // printf_scroll()
    jsr printf_scroll
    // }
    rts
}
// Converts a string to uppercase.
// strupr(byte* zp($15) str)
strupr: {
    .label src = $15
    .label str = $15
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
    jsr toupper
    // *src = toupper(*src)
    ldy #0
    sta (src),y
    // src++;
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
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
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($15) str)
strlen: {
    .label len = $22
    .label str = $15
    .label return = $22
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($13) buffer)
uctoa: {
    .label digit_value = $1c
    .label buffer = $13
    .label digit = $b
    .label started = $c
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
// uctoa_append(byte* zp($13) buffer, byte register(X) value, byte zp($1c) sub)
uctoa_append: {
    .label buffer = $13
    .label sub = $1c
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
// Print an unsigned int using a specific format
// printf_ulong(dword zp(2) uvalue)
printf_ulong: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    .label uvalue = 2
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
    lda.z uvalue
    sta.z ultoa.value
    lda.z uvalue+1
    sta.z ultoa.value+1
    lda.z uvalue+2
    sta.z ultoa.value+2
    lda.z uvalue+3
    sta.z ultoa.value+3
  // Format number into buffer
    jsr ultoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #format_upper_case
    sta.z printf_number_buffer.format_upper_case
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    ldx #format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zp($e) value, byte* zp($22) buffer)
ultoa: {
    .const max_digits = $a
    .label digit_value = $1d
    .label buffer = $22
    .label digit = $d
    .label value = $e
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda.z value
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
    // digit_value = digit_values[digit]
    lda.z digit
    asl
    asl
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
    cpx #0
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
    ldx #1
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
// ultoa_append(byte* zp($22) buffer, dword zp($e) value, dword zp($1d) sub)
ultoa_append: {
    .label buffer = $22
    .label value = $e
    .label sub = $1d
    .label return = $e
    ldx #0
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
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inx
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
// Checks is a placement of the queen on the board is legal.
// Checks the passed (row, column) against all queens placed on the board on lower rows.
// If no conflict for desired position returns 1 otherwise returns 0
// legal(byte zp($12) row, byte zp($1b) column)
legal: {
    .label __3 = $21
    .label row = $12
    .label column = $1b
    ldy #1
  __b1:
    // row-1
    ldx.z row
    dex
    // for(char i=1;i<=row-1;++i)
    sty.z $ff
    cpx.z $ff
    bcs __b2
    lda #1
    rts
  __b4:
    lda #0
    // }
    rts
  __b2:
    // if(board[i]==column)
    lda board,y
    cmp.z column
    beq __b4
    // diff(board[i],column)
    lda board,y
    ldx.z column
    jsr diff
    // diff(board[i],column)
    sta.z __3
    // diff(i,row)
    tya
    ldx.z row
    jsr diff
    // diff(i,row)
    // if(diff(board[i],column)==diff(i,row))
    cmp.z __3
    bne __b3
    jmp __b4
  __b3:
    // for(char i=1;i<=row-1;++i)
    iny
    jmp __b1
}
// Find the absolute difference between two unsigned chars
// diff(byte register(A) a, byte register(X) b)
diff: {
    // if(a<b)
    stx.z $ff
    cmp.z $ff
    bcc __b1
    // return a-b;
    stx.z $ff
    sec
    sbc.z $ff
    // }
    rts
  __b1:
    // return b-a;
    sta.z $ff
    txa
    sec
    sbc.z $ff
    rts
}
// Print an unsigned int using a specific format
printf_uint: {
    .label uvalue = 8
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
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
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    ldx #format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($13) value, byte* zp($15) buffer)
utoa: {
    .const max_digits = 5
    .label digit_value = $22
    .label buffer = $15
    .label digit = $12
    .label value = $13
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    lda #<printf_uint.uvalue
    sta.z value
    lda #>printf_uint.uvalue
    sta.z value+1
    txa
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda.z value
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
    // digit_value = digit_values[digit]
    lda.z digit
    asl
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    cpx #0
    bne __b5
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
    ldx #1
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
// utoa_append(byte* zp($15) buffer, word zp($13) value, word zp($22) sub)
utoa_append: {
    .label buffer = $15
    .label value = $13
    .label sub = $22
    .label return = $13
    ldx #0
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
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inx
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
// Clear the screen. Also resets current line/char cursor.
printf_cls: {
    // memset(PRINTF_SCREEN_ADDRESS, ' ', PRINTF_SCREEN_BYTES)
    ldx #' '
    lda #<$400
    sta.z memset.str
    lda #>$400
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // printf_cursor_ptr = PRINTF_SCREEN_ADDRESS
    lda #<$400
    sta.z printf_cursor_ptr
    lda #>$400
    sta.z printf_cursor_ptr+1
    // printf_cursor_x = 0
    lda #0
    sta.z printf_cursor_x
    // printf_cursor_y = 0
    sta.z printf_cursor_y
    // }
    rts
}
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
