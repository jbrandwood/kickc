// Tests snprintf function call rewriting
// Test simple formats
  // Commodore 64 PRG executable file
.file [name="printf-17.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// Current position in the buffer being filled ( initially *s passed to snprintf()
  /// Used to hold state while printing
  .label __snprintf_buffer = $14
  .label screen = $e
.segment Code
__start: {
    // char * __snprintf_buffer
    lda #<0
    sta.z __snprintf_buffer
    sta.z __snprintf_buffer+1
    jsr main
    rts
}
/// Print a character into snprintf buffer
/// Used by snprintf()
/// @param c The character to print
// void snputc(__register(X) char c)
snputc: {
    .const OFFSET_STACK_C = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    tax
    // ++__snprintf_size;
    inc __snprintf_size
    bne !+
    inc __snprintf_size+1
  !:
    // if(__snprintf_size > __snprintf_capacity)
    lda __snprintf_size+1
    cmp __snprintf_capacity+1
    bne !+
    lda __snprintf_size
    cmp __snprintf_capacity
    beq __b1
  !:
    bcc __b1
    // }
    rts
  __b1:
    // if(__snprintf_size==__snprintf_capacity)
    lda __snprintf_size+1
    cmp __snprintf_capacity+1
    bne __b2
    lda __snprintf_size
    cmp __snprintf_capacity
    bne __b2
    ldx #0
  __b2:
    // *(__snprintf_buffer++) = c
    // Append char
    txa
    ldy #0
    sta (__snprintf_buffer),y
    // *(__snprintf_buffer++) = c;
    inc.z __snprintf_buffer
    bne !+
    inc.z __snprintf_buffer+1
  !:
    rts
}
main: {
    // snprintf(BUF, 20, "hello world! ")
    lda #<$14
    sta.z snprintf_init.n
    lda #>$14
    sta.z snprintf_init.n+1
    jsr snprintf_init
    // snprintf(BUF, 20, "hello world! ")
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF, 20, "hello world! ")
    lda #0
    pha
    jsr snputc
    pla
    // print(BUF)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    jsr print
    // snprintf(BUF, 20, "hello %s%c ", "world", '!')
    lda #<$14
    sta.z snprintf_init.n
    lda #>$14
    sta.z snprintf_init.n+1
    jsr snprintf_init
    // snprintf(BUF, 20, "hello %s%c ", "world", '!')
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF, 20, "hello %s%c ", "world", '!')
    jsr printf_string
    // snprintf(BUF, 20, "hello %s%c ", "world", '!')
    lda #'!'
    pha
    jsr snputc
    pla
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF, 20, "hello %s%c ", "world", '!')
    lda #0
    pha
    jsr snputc
    pla
    // print(BUF)
    jsr print
    // snprintf(BUF, 20, "hello %d+%x! ", 3,11)
    lda #<$14
    sta.z snprintf_init.n
    lda #>$14
    sta.z snprintf_init.n+1
    jsr snprintf_init
    // snprintf(BUF, 20, "hello %d+%x! ", 3,11)
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF, 20, "hello %d+%x! ", 3,11)
    lda #<3
    sta.z printf_sint.value
    lda #>3
    sta.z printf_sint.value+1
    jsr printf_sint
    // snprintf(BUF, 20, "hello %d+%x! ", 3,11)
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF, 20, "hello %d+%x! ", 3,11)
    jsr printf_uint
    // snprintf(BUF, 20, "hello %d+%x! ", 3,11)
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF, 20, "hello %d+%x! ", 3,11)
    lda #0
    pha
    jsr snputc
    pla
    // print(BUF)
    jsr print
    // snprintf(BUF, 6, "hi %d! ", 22222)
    lda #<6
    sta.z snprintf_init.n
    lda #>6
    sta.z snprintf_init.n+1
    jsr snprintf_init
    // snprintf(BUF, 6, "hi %d! ", 22222)
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF, 6, "hi %d! ", 22222)
    lda #<$56ce
    sta.z printf_sint.value
    lda #>$56ce
    sta.z printf_sint.value+1
    jsr printf_sint
    // snprintf(BUF, 6, "hi %d! ", 22222)
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // snprintf(BUF, 6, "hi %d! ", 22222)
    lda #0
    pha
    jsr snputc
    pla
    // print(BUF)
    jsr print
    // }
    rts
  .segment Data
    s: .text "hello world! "
    .byte 0
    s1: .text "hello "
    .byte 0
    str: .text "world"
    .byte 0
    s2: .text " "
    .byte 0
    s4: .text "+"
    .byte 0
    s5: .text "! "
    .byte 0
    s6: .text "hi "
    .byte 0
}
.segment Code
/// Initialize the snprintf() state
// void snprintf_init(char *s, __zp(2) unsigned int n)
snprintf_init: {
    .label n = 2
    // __snprintf_capacity = n
    lda.z n
    sta __snprintf_capacity
    lda.z n+1
    sta __snprintf_capacity+1
    // __snprintf_size = 0
    lda #<0
    sta __snprintf_size
    sta __snprintf_size+1
    // __snprintf_buffer = s
    lda #<BUF
    sta.z __snprintf_buffer
    lda #>BUF
    sta.z __snprintf_buffer+1
    // }
    rts
}
/// Print a NUL-terminated string
// void printf_str(__zp(2) void (*putc)(char), __zp(6) const char *s)
printf_str: {
    .label s = 6
    .label putc = 2
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // putc(c)
    pha
    jsr icall6
    pla
    jmp __b1
  icall6:
    jmp (putc)
}
// void print(__zp(6) char *msg)
print: {
    .label msg = 6
    lda #<BUF
    sta.z msg
    lda #>BUF
    sta.z msg+1
  __b1:
    // while(*msg)
    ldy #0
    lda (msg),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(screen++) = *(msg++)
    ldy #0
    lda (msg),y
    sta (screen),y
    // *(screen++) = *(msg++);
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    jmp __b1
}
// Print a string value using a specific format
// Handles justification and min length 
// void printf_string(void (*putc)(char), char *str, char format_min_length, char format_justify_left)
printf_string: {
    .label putc = snputc
    // printf_str(putc, str)
    lda #<putc
    sta.z printf_str.putc
    lda #>putc
    sta.z printf_str.putc+1
    lda #<main.str
    sta.z printf_str.s
    lda #>main.str
    sta.z printf_str.s+1
    jsr printf_str
    // }
    rts
}
// Print a signed integer using a specific format
// void printf_sint(void (*putc)(char), __zp(2) int value, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_sint: {
    .label value = 2
    // printf_buffer.sign = 0
    // Handle any sign
    lda #0
    sta printf_buffer
    // if(value<0)
    lda.z value+1
    bmi __b1
    jmp __b2
  __b1:
    // value = -value
    lda #0
    sec
    sbc.z value
    sta.z value
    lda #0
    sbc.z value+1
    sta.z value+1
    // printf_buffer.sign = '-'
    lda #'-'
    sta printf_buffer
  __b2:
    // utoa(uvalue, printf_buffer.digits, format.radix)
    ldx #DECIMAL
    jsr utoa
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_upper_case
    lda #<snputc
    sta.z printf_number_buffer.putc
    lda #>snputc
    sta.z printf_number_buffer.putc+1
    lda #0
    sta.z printf_number_buffer.format_zero_padding
    sta.z printf_number_buffer.format_justify_left
    tax
    jsr printf_number_buffer
    // }
    rts
}
// Print an unsigned int using a specific format
// void printf_uint(void (*putc)(char), unsigned int uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uint: {
    .const uvalue = $b
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    .label putc = snputc
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    lda #<uvalue
    sta.z utoa.value
    lda #>uvalue
    sta.z utoa.value+1
    ldx #HEXADECIMAL
    jsr utoa
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #format_upper_case
    sta.z printf_number_buffer.format_upper_case
    lda #<putc
    sta.z printf_number_buffer.putc
    lda #>putc
    sta.z printf_number_buffer.putc+1
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
// void utoa(__zp(2) unsigned int value, __zp(9) char *buffer, __register(X) char radix)
utoa: {
    .label digit_value = 4
    .label buffer = 9
    .label digit = $c
    .label value = 2
    .label max_digits = $11
    .label digit_values = 6
    // if(radix==DECIMAL)
    cpx #DECIMAL
    beq __b2
    // if(radix==HEXADECIMAL)
    cpx #HEXADECIMAL
    beq __b3
    // if(radix==OCTAL)
    cpx #OCTAL
    beq __b4
    // if(radix==BINARY)
    cpx #BINARY
    beq __b5
    // *buffer++ = 'e'
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // }
    rts
  __b2:
    lda #<RADIX_DECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES
    sta.z digit_values+1
    lda #5
    sta.z max_digits
    jmp __b1
  __b3:
    lda #<RADIX_HEXADECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES
    sta.z digit_values+1
    lda #4
    sta.z max_digits
    jmp __b1
  __b4:
    lda #<RADIX_OCTAL_VALUES
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES
    sta.z digit_values+1
    lda #6
    sta.z max_digits
    jmp __b1
  __b5:
    lda #<RADIX_BINARY_VALUES
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES
    sta.z digit_values+1
    lda #$10
    sta.z max_digits
  __b1:
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b6:
    // max_digits-1
    lda.z max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    cmp.z digit
    beq !+
    bcs __b7
  !:
    // *buffer++ = DIGITS[(char)value]
    ldx.z value
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
    rts
  __b7:
    // unsigned int digit_value = digit_values[digit]
    lda.z digit
    asl
    tay
    lda (digit_values),y
    sta.z digit_value
    iny
    lda (digit_values),y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    cpx #0
    bne __b10
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b10
  !:
    bcc __b10
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b6
  __b10:
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
    jmp __b9
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(__zp(2) void (*putc)(char), __zp($12) char buffer_sign, char *buffer_digits, __register(X) char format_min_length, __zp($11) char format_justify_left, char format_sign_always, __zp($c) char format_zero_padding, __zp($13) char format_upper_case, char format_radix)
printf_number_buffer: {
    .label __19 = 9
    .label buffer_sign = $12
    .label padding = $10
    .label putc = 2
    .label format_zero_padding = $c
    .label format_justify_left = $11
    .label format_upper_case = $13
    // if(format.min_length)
    cpx #0
    beq __b6
    // strlen(buffer.digits)
    jsr strlen
    // strlen(buffer.digits)
    // signed char len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    ldy.z __19
    // if(buffer.sign)
    lda.z buffer_sign
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
    lda.z format_justify_left
    bne __b2
    lda.z format_zero_padding
    bne __b2
    lda.z padding
    cmp #0
    bne __b8
    jmp __b2
  __b8:
    // printf_padding(putc, ' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b3
    // putc(buffer.sign)
    pha
    jsr icall7
    pla
  __b3:
    // if(format.zero_padding && padding)
    lda.z format_zero_padding
    beq __b4
    lda.z padding
    cmp #0
    bne __b10
    jmp __b4
  __b10:
    // printf_padding(putc, '0',(char)padding)
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
    // printf_str(putc, buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s+1
    jsr printf_str
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
    // printf_padding(putc, ' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __breturn:
    // }
    rts
  icall7:
    jmp (putc)
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __zp(2) unsigned int utoa_append(__zp(9) char *buffer, __zp(2) unsigned int value, __zp(4) unsigned int sub)
utoa_append: {
    .label buffer = 9
    .label value = 2
    .label sub = 4
    .label return = 2
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
// Computes the length of the string str up to but not including the terminating null character.
// __zp(9) unsigned int strlen(__zp(6) char *str)
strlen: {
    .label len = 9
    .label str = 6
    .label return = 9
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
// void printf_padding(__zp(2) void (*putc)(char), __zp($d) char pad, __zp($b) char length)
printf_padding: {
    .label i = 8
    .label putc = 2
    .label length = $b
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
    // putc(pad)
    lda.z pad
    pha
    jsr icall8
    pla
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
  icall8:
    jmp (putc)
}
// Converts a string to uppercase.
// char * strupr(char *str)
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = 4
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
// __register(A) char toupper(__register(A) char ch)
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
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of binary digits
  RADIX_BINARY_VALUES: .word $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES: .word $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  BUF: .fill $14, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
  /// The capacity of the buffer (n passed to snprintf())
  /// Used to hold state while printing
  __snprintf_capacity: .word 0
  // The number of chars that would have been filled when printing without capacity. Grows even after size>capacity.
  /// Used to hold state while printing
  __snprintf_size: .word 0
