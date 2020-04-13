// Tests that signed indexed subtract works as intended
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = 3
  .label print_char_cursor = 5
main: {
    .label j = 2
    ldy #0
  __b1:
    // sub(i, $80)
    tya
    ldx #$80
    jsr sub
    // sub(i, $40)
    tya
    ldx #$40
    jsr sub
    // sub(i, $40)
    tya
    ldx #$40
    jsr sub
    // for(byte i: 0..8)
    iny
    cpy #9
    bne __b1
    // print_cls()
    jsr print_cls
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #0
    sta.z j
  __b3:
    // print_sint(words[j])
    lda.z j
    asl
    tay
    lda words,y
    sta.z print_sint.w
    lda words+1,y
    sta.z print_sint.w+1
    jsr print_sint
    // print_ln()
    jsr print_ln
    // for(byte j: 0..8)
    inc.z j
    lda #9
    cmp.z j
    bne __b9
    // }
    rts
  __b9:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b3
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
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
// Print a signed int as HEX
// print_sint(signed word zp(7) w)
print_sint: {
    .label w = 7
    // if(w<0)
    lda.z w+1
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_uint((unsigned int)w)
    jsr print_uint
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // w = -w
    sec
    lda #0
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
    jmp __b2
}
// Print a single char
// print_char(byte register(A) ch)
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
// Print a unsigned int as HEX
// print_uint(word zp(7) w)
print_uint: {
    .label w = 7
    // print_uchar(>w)
    ldx.z w+1
    jsr print_uchar
    // print_uchar(<w)
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Print a char as HEX
// print_uchar(byte register(X) b)
print_uchar: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
  // Table of hexadecimal digits
    jsr print_char
    // b&$f
    lda #$f
    axs #0
    // print_char(print_hextab[b&$f])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = $400
    .label end = str+num
    .label dst = 7
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// sub(byte register(A) idx, byte register(X) s)
sub: {
    // words[idx] -= s
    asl
    sec
    stx.z $ff
    tax
    lda words,x
    sbc.z $ff
    sta words,x
    bcs !+
    dec words+1,x
  !:
    // }
    rts
}
  print_hextab: .text "0123456789abcdef"
  words: .word -$6000, -$600, -$60, -6, 0, 6, $60, $600, $6000
