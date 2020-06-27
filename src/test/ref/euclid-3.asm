/*
 * Find greatest common denominator using subtraction-based Euclidian algorithm
 * See https://en.wikipedia.org/wiki/Euclidean_algorithm
 * Based on facebook post from
 */
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_screen = $400
  .label print_line_cursor = 6
  .label print_char_cursor = 4
main: {
    // print_cls()
    jsr print_cls
    // print_euclid(128,2)
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    lda #2
    sta.z print_euclid.b
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #$80
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_euclid(169,69)
    lda #$45
    sta.z print_euclid.b
    lda #$a9
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_euclid(155,55)
    lda #$37
    sta.z print_euclid.b
    lda #$9b
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_euclid(199,3)
    lda #3
    sta.z print_euclid.b
    lda #$c7
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_euclid(91,26)
    lda #$1a
    sta.z print_euclid.b
    lda #$5b
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_euclid(119,187)
    lda #$bb
    sta.z print_euclid.b
    lda #$77
    sta.z print_euclid.a
    jsr print_euclid
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
// print_euclid(byte zp(2) a, byte zp(3) b)
print_euclid: {
    .label b = 3
    .label a = 2
    // print_uchar(a)
    ldx.z a
    jsr print_uchar
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_uchar(b)
    ldx.z b
    jsr print_uchar
    // print_char(' ')
    lda #' '
    jsr print_char
    // euclid(a,b)
    ldx.z b
    jsr euclid
    // euclid(a,b)
    lda.z euclid.a
    // print_uchar(euclid(a,b))
    tax
    jsr print_uchar
    // print_ln()
    jsr print_ln
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = 4
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
// euclid(byte zp(2) a, byte register(X) b)
euclid: {
    .label a = 2
  __b1:
    // while (a!=b)
    cpx.z a
    bne __b2
    // }
    rts
  __b2:
    // if(a>b)
    cpx.z a
    bcc __b3
    // b=b-a
    txa
    sec
    sbc.z a
    tax
    jmp __b1
  __b3:
    // a=a-b
    txa
    eor #$ff
    sec
    adc.z a
    sta.z a
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
  print_hextab: .text "0123456789abcdef"
