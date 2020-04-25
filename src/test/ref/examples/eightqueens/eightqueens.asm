// N Queens Problem in C Using Backtracking
//
// N Queens Problem is a famous puzzle in which n-queens are to be placed on a nxn chess board such that no two queens are in the same row, column or diagonal. 
// In this tutorial I am sharing the C program to find solution for N Queens problem using backtracking. Below animation shows the solution for 8 queens problem using backtracking.
// 
// Author: Neeraj Mishra
// Source: https://www.thecrazyprogrammer.com/2015/03/c-program-for-n-queens-problem-using-backtracking.html
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .label printf_cursor_x = $c
  .label printf_cursor_y = $d
  .label printf_cursor_ptr = $e
  .label count = $10
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
  // count
  lda #0
  sta.z count
  jsr main
  rts
main: {
    // printf_cls()
    jsr printf_cls
    // printf(" - N Queens Problem Using Backtracking -")
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\n\nNumber of Queens:%u",N)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\n\nNumber of Queens:%u",N)
    jsr printf_uint
    // queen(1)
    lda #1
    pha
    jsr queen
    pla
    // }
    rts
    str: .text " - N Queens Problem Using Backtracking -"
    .byte 0
    str1: .text @"\n\nNumber of Queens:"
    .byte 0
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
    lda #format_min_length
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($12) buffer_sign, byte* zp(2) buffer_digits, byte zp($17) format_min_length, byte zp($18) format_justify_left, byte zp($11) format_zero_padding, byte zp(6) format_upper_case)
printf_number_buffer: {
    .label __19 = 4
    .label buffer_sign = $12
    .label len = 7
    .label padding = $17
    .label format_min_length = $17
    .label format_zero_padding = $11
    .label format_justify_left = $18
    .label buffer_digits = 2
    .label format_upper_case = 6
    // if(format.min_length)
    lda #0
    cmp.z format_min_length
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
    sta.z len
    // if(buffer.sign)
    lda #0
    cmp.z buffer_sign
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
    sta.z printf_char.ch
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
// printf_padding(byte zp(8) pad, byte zp(7) length)
printf_padding: {
    .label i = 9
    .label length = 7
    .label pad = 8
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
    jsr printf_char
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Print a single char
// If the end of the screen is reached scroll it up one char and place the cursor at the
// printf_char(byte zp(8) ch)
printf_char: {
    .label ch = 8
    // *(printf_cursor_ptr++) = ch
    lda.z ch
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
    .label __4 = $e
    // if(printf_cursor_y==PRINTF_SCREEN_HEIGHT)
    lda #$19
    cmp.z printf_cursor_y
    bne __breturn
    // memcpy(PRINTF_SCREEN_ADDRESS, PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_WIDTH, PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH)
    jsr memcpy
    // memset(PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH, ' ', PRINTF_SCREEN_WIDTH)
    lda #' '
    sta.z memset.c
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
// memset(void* zp(4) str, byte zp($a) c, word zp($13) num)
memset: {
    .label end = $13
    .label dst = 4
    .label num = $13
    .label str = 4
    .label c = $a
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
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
memcpy: {
    .label destination = $400
    .label source = $400+$28
    .const num = $28*$19-$28
    .label src_end = source+num
    .label dst = 4
    .label src = $13
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
// printf_str(byte* zp(2) str)
printf_str: {
    .label ch = 8
    .label str = 2
  __b2:
    // ch = *str++
    ldy #0
    lda (str),y
    sta.z ch
    inc.z str
    bne !+
    inc.z str+1
  !:
    // if(ch==0)
    lda.z ch
    cmp #0
    bne __b3
    // }
    rts
  __b3:
    // if(ch=='\n')
    lda #'\n'
    cmp.z ch
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
    .label __0 = $e
    .label __1 = $e
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
// strupr(byte* zp($13) str)
strupr: {
    .label __0 = 7
    .label src = $13
    .label str = $13
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
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// toupper(byte zp(7) ch)
toupper: {
    .label return = 7
    .label ch = 7
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
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($13) str)
strlen: {
    .label len = 4
    .label str = $13
    .label return = 4
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
// utoa(word zp(2) value, byte* zp(4) buffer)
utoa: {
    .const max_digits = 5
    .label __10 = $12
    .label __11 = $11
    .label digit_value = $13
    .label buffer = 4
    .label digit = $17
    .label value = 2
    .label started = $18
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
    // digit_value = digit_values[digit]
    lda.z digit
    asl
    sta.z __10
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    lda #0
    cmp.z started
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp(4) buffer, word zp(2) value, word zp($13) sub)
utoa_append: {
    .label buffer = 4
    .label value = 2
    .label sub = $13
    .label return = 2
    .label digit = $11
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
// Clear the screen. Also resets current line/char cursor.
printf_cls: {
    // memset(PRINTF_SCREEN_ADDRESS, ' ', PRINTF_SCREEN_BYTES)
    lda #' '
    sta.z memset.c
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
// Function to check for proper positioning of queen
// queen(byte zp($15) row)
queen: {
    .const OFFSET_STACK_ROW = 0
    .label r = $15
    .label column = $16
    .label __1 = $b
    .label __4 = $15
    .label row = $15
    tsx
    lda STACK_BASE+OFFSET_STACK_ROW,x
    sta.z row
    // r = row
    // column=1
    lda #1
    sta.z column
  __b1:
    // for(__ma char column=1;column<=N;++column)
    lda.z column
    cmp #8+1
    bcc __b2
    // }
    rts
  __b2:
    // place(r,column)
    jsr place
    // place(r,column)
    // if(place(r,column))
    lda #0
    cmp.z __1
    beq __b3
    // board[r]=column
    lda.z column
    ldy.z r
    sta board,y
    // if(r==N)
    //no conflicts so place queen
    lda #8
    cmp.z r
    beq __b4
    // asm
    // Push the local vars on the stack (waiting for proper recursion support)
    lda column
    pha
    tya
    pha
    // r+1
    inc.z __4
    // queen(r+1)
    //try queen with next position
    lda.z __4
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
    // for(__ma char column=1;column<=N;++column)
    inc.z column
    jmp __b1
  __b4:
    // print()
    //dead end
    jsr print
    jmp __b3
}
//function for printing the solution
print: {
    .label i = $b
    .label i1 = $b
    .label j = $12
    // printf("\nSolution %u:\n ",++count);
    inc.z count
    // printf("\nSolution %u:\n ",++count)
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\nSolution %u:\n ",++count)
    lda.z count
    sta.z printf_uchar.uvalue
    jsr printf_uchar
    // printf("\nSolution %u:\n ",++count)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    lda #1
    sta.z i
  __b1:
    // for(char i=1;i<=N;++i)
    lda.z i
    cmp #8+1
    bcc __b2
    lda #1
    sta.z i1
  __b3:
    // for(char i=1;i<=N;++i)
    lda.z i1
    cmp #8+1
    bcc __b4
    // }
    rts
  __b4:
    // printf("\n%u",i)
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("\n%u",i)
    jsr printf_uchar
    lda #1
    sta.z j
  __b5:
    // for(char j=1;j<=N;++j)
    lda.z j
    cmp #8+1
    bcc __b6
    // for(char i=1;i<=N;++i)
    inc.z i1
    jmp __b3
  __b6:
    // if(board[i]==j)
    //for nxn board
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
    // for(char j=1;j<=N;++j)
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
    // printf("%u",i)
    jsr printf_uchar
    // for(char i=1;i<=N;++i)
    inc.z i
    jmp __b1
    str: .text @"\nSolution "
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
// printf_uchar(byte zp($b) uvalue)
printf_uchar: {
    .label uvalue = $b
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
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_number_buffer.buffer_digits+1
    lda #0
    sta.z printf_number_buffer.format_zero_padding
    sta.z printf_number_buffer.format_justify_left
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte zp(7) value, byte* zp($13) buffer)
uctoa: {
    .label digit_value = $17
    .label buffer = $13
    .label digit = 6
    .label value = 7
    .label started = 8
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
    cmp #3-1
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
    // digit_value = digit_values[digit]
    ldy.z digit
    lda RADIX_DECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    lda #0
    cmp.z started
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// uctoa_append(byte* zp($13) buffer, byte zp(7) value, byte zp($17) sub)
uctoa_append: {
    .label buffer = $13
    .label value = 7
    .label sub = $17
    .label return = 7
    .label digit = 9
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
// function to check conflicts
// If no conflict for desired postion returns 1 otherwise returns 0
// place(byte zp($15) row, byte zp($16) column)
place: {
    .label __0 = $17
    .label __3 = $18
    .label __4 = $11
    .label row = $15
    .label column = $16
    .label return = $b
    .label i = $a
    lda #1
    sta.z i
  __b1:
    // row-1
    ldx.z row
    dex
    stx.z __0
    // for(i=1;i<=row-1;++i)
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
    //checking column and digonal conflicts
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
    // for(i=1;i<=row-1;++i)
    inc.z i
    jmp __b1
}
// Find the absolute difference between two unsigned chars
// diff(byte zp($11) a, byte zp($12) b)
diff: {
    .label a = $11
    .label b = $12
    .label return = $18
    .label return_1 = $11
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
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  board: .fill $14, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
