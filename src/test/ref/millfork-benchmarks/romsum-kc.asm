/// @file
/// A lightweight library for printing on the C64.
///
/// Printing with this library is done by calling print_ function for each element
  // Commodore 64 PRG executable file
.file [name="romsum-kc.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label rom = $e000
  .label print_screen = $400
  .label last_time = $f
  .label print_char_cursor = 6
  .label print_line_cursor = $b
  .label Ticks = $d
  .label Ticks_1 = 2
.segment Code
__start: {
    // unsigned int last_time
    lda #<0
    sta.z last_time
    sta.z last_time+1
    jsr main
    rts
}
main: {
    .label i = $d
    // start()
    jsr start
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(i=0;i<6;i++)
    lda.z i+1
    bne !+
    lda.z i
    cmp #6
    bcc __b2
  !:
    // end()
    jsr end
    // }
    rts
  __b2:
    // sum()
    jsr sum
    // sum()
    // print_uint_decimal(sum())
    jsr print_uint_decimal
    // print_ln()
    jsr print_ln
    // for(i=0;i<6;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
}
start: {
    .label LAST_TIME = last_time
    // asm
    jsr $ffde
    sta LAST_TIME
    stx LAST_TIME+1
    // }
    rts
}
end: {
    // Ticks = last_time
    lda.z last_time
    sta.z Ticks
    lda.z last_time+1
    sta.z Ticks+1
    // start()
    jsr start
    // last_time -= Ticks
    lda.z last_time
    sec
    sbc.z Ticks
    sta.z last_time
    lda.z last_time+1
    sbc.z Ticks+1
    sta.z last_time+1
    // Ticks = last_time
    lda.z last_time
    sta.z Ticks_1
    lda.z last_time+1
    sta.z Ticks_1+1
    // print_uint(Ticks)
    jsr print_uint
    // print_ln()
    jsr print_ln
    // }
    rts
}
sum: {
    .label s = 2
    .label p = 8
    .label return = 2
    lda #<rom
    sta.z p
    lda #>rom
    sta.z p+1
    lda #<0
    sta.z s
    sta.z s+1
    tax
  /* doing it page-by-page is faster than doing just one huge loop */
  __b1:
    // for (page = 0; page < 0x20; page++)
    cpx #$20
    bcc __b3
    // }
    rts
  __b3:
    ldy #0
  __b2:
    // tmp = p[i]
    lda (p),y
    // s += tmp
    clc
    adc.z s
    sta.z s
    bcc !+
    inc.z s+1
  !:
    // i++;
    iny
    // while (i)
    cpy #0
    bne __b2
    // p += 0x100
    lda.z p
    clc
    adc #<$100
    sta.z p
    lda.z p+1
    adc #>$100
    sta.z p+1
    // for (page = 0; page < 0x20; page++)
    inx
    jmp __b1
}
// Print a unsigned int as DECIMAL
// void print_uint_decimal(__zp(2) unsigned int w)
print_uint_decimal: {
    .label w = 2
    // utoa(w, decimal_digits, DECIMAL)
    jsr utoa
    // print_str(decimal_digits)
    jsr print_str
    // }
    rts
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + 0x28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Print a unsigned int as HEX
// void print_uint(__zp(2) unsigned int w)
print_uint: {
    .label w = 2
    // print_uchar(BYTE1(w))
    ldx.z w+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__zp(2) unsigned int value, __zp(8) char *buffer, char radix)
utoa: {
    .const max_digits = 5
    .label value = 2
    .label digit_value = 4
    .label buffer = 8
    .label digit = $a
    lda #<decimal_digits
    sta.z buffer
    lda #>decimal_digits
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
    // }
    rts
  __b2:
    // unsigned int digit_value = digit_values[digit]
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
// Print a zero-terminated string
// void print_str(__zp(4) char *str)
print_str: {
    .label str = 4
    lda #<decimal_digits
    sta.z str
    lda #>decimal_digits
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
    // print_char(*(str++))
    ldy #0
    lda (str),y
    jsr print_char
    // print_char(*(str++));
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a char as HEX
// void print_uchar(__register(X) char b)
print_uchar: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda DIGITS,y
  // Table of hexadecimal digits
    jsr print_char
    // b&0xf
    lda #$f
    axs #0
    // print_char(print_hextab[b&0xf])
    lda DIGITS,x
    jsr print_char
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
// __zp(2) unsigned int utoa_append(__zp(8) char *buffer, __zp(2) unsigned int value, __zp(4) unsigned int sub)
utoa_append: {
    .label buffer = 8
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
// Print a single char
// void print_char(__register(A) char ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Digits used for storing the decimal unsigned int
  decimal_digits: .fill 6, 0
