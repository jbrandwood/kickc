// Tests printf function call rewriting
// A few strings with newlines
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label printf_cursor_x = 8
  .label printf_cursor_y = 9
  .label printf_cursor_ptr = $a
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
    // printf("Lone 1\n")
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("Lone 2\n")
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
    str: .text @"Lone 1\n"
    .byte 0
    str1: .text @"Lone 2\n"
    .byte 0
}
// Print a zero-terminated string
// Handles escape codes such as newline
// printf_str(byte* zp(2) str)
printf_str: {
    .label str = 2
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
    .label __0 = $a
    .label __1 = $a
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
    // }
    rts
}
// Print a single char
// If the end of the screen is reached scroll it up one char and place the cursor at the
// printf_char(byte register(A) ch)
printf_char: {
    .label __6 = $a
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
    lda.z __6
    sec
    sbc #<$28
    sta.z __6
    lda.z __6+1
    sbc #>$28
    sta.z __6+1
    // printf_cursor_ptr = printf_cursor_ptr-PRINTF_SCREEN_WIDTH
    // printf_cursor_y--;
    dec.z printf_cursor_y
  __breturn:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(6) str, byte register(X) c, word zp(4) num)
memset: {
    .label end = 4
    .label dst = 6
    .label num = 4
    .label str = 6
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
    .label dst = 6
    .label src = 4
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
