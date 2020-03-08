// Tests subtracting bytes from signed words
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = 4
  .label print_char_cursor = 6
main: {
    .label w2 = $b
    .label w1 = 2
    // print_cls()
    jsr print_cls
    ldx #0
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<$4d2
    sta.z w1
    lda #>$4d2
    sta.z w1+1
  __b1:
    // w2 = w1 - 91
    lda.z w1
    sec
    sbc #$5b
    sta.z w2
    lda.z w1+1
    sbc #>$5b
    sta.z w2+1
    // w1 = w2 - 41
    lda.z w2
    sec
    sbc #$29
    sta.z w1
    lda.z w2+1
    sbc #>$29
    sta.z w1+1
    // print_sword(w1)
    lda.z w1
    sta.z print_sword.w
    lda.z w1+1
    sta.z print_sword.w+1
    jsr print_sword
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_sword(w2)
    lda.z w2
    sta.z print_sword.w
    lda.z w2+1
    sta.z print_sword.w+1
    jsr print_sword
    // print_ln()
    jsr print_ln
    // for( byte i: 0..10 )
    inx
    cpx #$b
    bne __b6
    // }
    rts
  __b6:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
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
// Print a signed word as HEX
// print_sword(signed word zp(9) w)
print_sword: {
    .label w = 9
    // if(w<0)
    lda.z w+1
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_word((word)w)
    jsr print_word
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
// Print a word as HEX
// print_word(word zp(9) w)
print_word: {
    .label w = 9
    // print_byte(>w)
    lda.z w+1
    sta.z print_byte.b
    jsr print_byte
    // print_byte(<w)
    lda.z w
    sta.z print_byte.b
    jsr print_byte
    // }
    rts
}
// Print a byte as HEX
// print_byte(byte zp(8) b)
print_byte: {
    .label b = 8
    // b>>4
    lda.z b
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
    and.z b
    // print_char(print_hextab[b&$f])
    tay
    lda print_hextab,y
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
    .label dst = 9
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
  print_hextab: .text "0123456789abcdef"
