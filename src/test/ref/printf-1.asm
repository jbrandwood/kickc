// Tests printf implementation
// Format a string
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label printf_screen = $400
  .label printf_line_cursor = $d
  .label printf_char_cursor = $f
__bbegin:
  // printf_line_cursor = PRINTF_SCREEN_ADDRESS
  lda #<$400
  sta.z printf_line_cursor
  lda #>$400
  sta.z printf_line_cursor+1
  // printf_char_cursor = PRINTF_SCREEN_ADDRESS
  lda #<$400
  sta.z printf_char_cursor
  lda #>$400
  sta.z printf_char_cursor+1
  jsr main
  rts
main: {
    .label format_min_length = $a
    // printf_cls()
    jsr printf_cls
    // printf_string( "cml", format)
    lda #<str
    sta.z printf_string.str
    lda #>str
    sta.z printf_string.str+1
    lda #0
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf_ln()
    jsr printf_ln
    // printf_string( "rules", format)
    lda #<str1
    sta.z printf_string.str
    lda #>str1
    sta.z printf_string.str+1
    lda #0
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf_ln()
    jsr printf_ln
    // printf_string( "cml", format)
    lda #<str
    sta.z printf_string.str
    lda #>str
    sta.z printf_string.str+1
    lda #1
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf_ln()
    jsr printf_ln
    // printf_string( "rules", format)
    lda #<str1
    sta.z printf_string.str
    lda #>str1
    sta.z printf_string.str+1
    lda #1
    sta.z printf_string.format_justify_left
    jsr printf_string
    // }
    rts
    str: .text "cml"
    .byte 0
    str1: .text "rules"
    .byte 0
}
// Print a string value using a specific format
// Handles justification and min length 
// printf_string(byte* zp(3) str, byte zp(2) format_justify_left)
printf_string: {
    .label __9 = $b
    .label padding = 5
    .label str = 3
    .label format_justify_left = 2
    // strlen(str)
    lda.z str
    sta.z strlen.str
    lda.z str+1
    sta.z strlen.str+1
    jsr strlen
    // strlen(str)
    // len = (signed char)strlen(str)
    lda.z __9
    // padding = (signed char)format.min_length  - len
    eor #$ff
    clc
    adc #main.format_min_length+1
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
    lda #0
    sta.z padding
  __b1:
    // if(!format.justify_left && padding)
    lda #0
    cmp.z format_justify_left
    bne __b2
    cmp.z padding
    bne __b4
    jmp __b2
  __b4:
    // printf_padding(' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // printf_str(str)
    jsr printf_str
    // if(format.justify_left && padding)
    lda #0
    cmp.z format_justify_left
    beq __breturn
    cmp.z padding
    bne __b5
    rts
  __b5:
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
// printf_padding(byte zp(7) pad, byte zp(6) length)
printf_padding: {
    .label i = 8
    .label length = 6
    .label pad = 7
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
    .label __8 = $f
    // *(printf_char_cursor++) = ch
    ldy #0
    sta (printf_char_cursor),y
    // *(printf_char_cursor++) = ch;
    inc.z printf_char_cursor
    bne !+
    inc.z printf_char_cursor+1
  !:
    // if(printf_char_cursor==printf_screen+PRINTF_SCREEN_BYTES)
    lda.z printf_char_cursor+1
    cmp #>printf_screen+$28*$19
    bne __breturn
    lda.z printf_char_cursor
    cmp #<printf_screen+$28*$19
    bne __breturn
    // memcpy(printf_screen, printf_screen+PRINTF_SCREEN_WIDTH, PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH)
    jsr memcpy
    // memset(printf_screen+PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH, ' ', PRINTF_SCREEN_WIDTH)
    ldx #' '
    lda #<printf_screen+$28*$19-$28
    sta.z memset.str
    lda #>printf_screen+$28*$19-$28
    sta.z memset.str+1
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
    jsr memset
    // printf_char_cursor-PRINTF_SCREEN_WIDTH
    lda.z __8
    sec
    sbc #<$28
    sta.z __8
    lda.z __8+1
    sbc #>$28
    sta.z __8+1
    // printf_char_cursor = printf_char_cursor-PRINTF_SCREEN_WIDTH
    // printf_line_cursor = printf_char_cursor
    lda.z printf_char_cursor
    sta.z printf_line_cursor
    lda.z printf_char_cursor+1
    sta.z printf_line_cursor+1
  __breturn:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($b) str, byte register(X) c, word zp(9) num)
memset: {
    .label end = 9
    .label dst = $b
    .label num = 9
    .label str = $b
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
    .label destination = printf_screen
    .const num = $28*$19-$28
    .label source = printf_screen+$28
    .label src_end = source+num
    .label dst = $b
    .label src = 9
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
// printf_str(byte* zp(3) str)
printf_str: {
    .label str = 3
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // printf_char(*str++)
    ldy #0
    lda (str),y
    jsr printf_char
    // printf_char(*str++);
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp(9) str)
strlen: {
    .label len = $b
    .label str = 9
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
// Print a newline
printf_ln: {
  __b1:
    // printf_line_cursor +=  PRINTF_SCREEN_WIDTH
    lda #$28
    clc
    adc.z printf_line_cursor
    sta.z printf_line_cursor
    bcc !+
    inc.z printf_line_cursor+1
  !:
    // while (printf_line_cursor<printf_char_cursor)
    lda.z printf_line_cursor+1
    cmp.z printf_char_cursor+1
    bcc __b1
    bne !+
    lda.z printf_line_cursor
    cmp.z printf_char_cursor
    bcc __b1
  !:
    // printf_char_cursor = printf_line_cursor
    lda.z printf_line_cursor
    sta.z printf_char_cursor
    lda.z printf_line_cursor+1
    sta.z printf_char_cursor+1
    // }
    rts
}
// Clear the screen. Also resets current line/char cursor.
printf_cls: {
    // memset(printf_screen, ' ', PRINTF_SCREEN_BYTES)
    ldx #' '
    lda #<printf_screen
    sta.z memset.str
    lda #>printf_screen
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // printf_line_cursor = printf_screen
    lda #<printf_screen
    sta.z printf_line_cursor
    lda #>printf_screen
    sta.z printf_line_cursor+1
    // printf_char_cursor = printf_line_cursor
    lda.z printf_line_cursor
    sta.z printf_char_cursor
    lda.z printf_line_cursor+1
    sta.z printf_char_cursor+1
    // }
    rts
}
