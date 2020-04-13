.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = 6
  .label print_char_cursor = $a
  .label print_char_cursor_1 = 6
  .label print_line_cursor_1 = 8
main: {
    .label __3 = $c
    .label __6 = $12
    .label __16 = $14
    .label __20 = $16
    .label __24 = $18
    .label __28 = $1a
    .label __32 = $c
    .label __33 = $12
    .label dw2 = $e
    .label dw = 2
    // print_cls()
    jsr print_cls
    lda #<$400
    sta.z print_char_cursor_1
    lda #>$400
    sta.z print_char_cursor_1+1
    lda #<$400
    sta.z print_line_cursor_1
    lda #>$400
    sta.z print_line_cursor_1+1
    lda #<$12345678
    sta.z dw
    lda #>$12345678
    sta.z dw+1
    lda #<$12345678>>$10
    sta.z dw+2
    lda #>$12345678>>$10
    sta.z dw+3
  __b1:
    // for( dword dw = $12345678; dw != $12345690; dw++ )
    lda.z dw+3
    cmp #>$12345690>>$10
    bne __b2
    lda.z dw+2
    cmp #<$12345690>>$10
    bne __b2
    lda.z dw+1
    cmp #>$12345690
    bne __b2
    lda.z dw
    cmp #<$12345690
    bne __b2
    // }
    rts
  __b2:
    // >dw
    lda.z dw+2
    sta.z __3
    lda.z dw+3
    sta.z __3+1
    // >dw2 = (>dw) + $1111
    clc
    lda.z __32
    adc #<$1111
    sta.z __32
    lda.z __32+1
    adc #>$1111
    sta.z __32+1
    lda.z dw
    sta.z dw2
    lda.z dw+1
    sta.z dw2+1
    lda.z __32
    sta.z dw2+2
    lda.z __32+1
    sta.z dw2+3
    // <dw
    lda.z dw
    sta.z __6
    lda.z dw+1
    sta.z __6+1
    // <dw2 = (<dw) + $1111
    clc
    lda.z __33
    adc #<$1111
    sta.z __33
    lda.z __33+1
    adc #>$1111
    sta.z __33+1
    lda.z __33
    sta.z dw2
    lda.z __33+1
    sta.z dw2+1
    // print_ulong(dw2)
    // Test set/get low word of dword
    jsr print_ulong
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_uint(>dw2)
    lda.z dw2+2
    sta.z print_uint.w
    lda.z dw2+3
    sta.z print_uint.w+1
    jsr print_uint
    // print_char(' ')
  // Test get high word of dword
    lda #' '
    jsr print_char
    // print_uint(<dw2)
    lda.z dw2
    sta.z print_uint.w
    lda.z dw2+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_char(' ')
  // Test get low word of dword
    lda #' '
    jsr print_char
    // >dw2
    lda.z dw2+2
    sta.z __16
    lda.z dw2+3
    sta.z __16+1
    // print_uchar(> >dw2)
    tax
    jsr print_uchar
    // print_char(' ')
  // Test get high high byte of dword
    lda #' '
    jsr print_char
    // >dw2
    lda.z dw2+2
    sta.z __20
    lda.z dw2+3
    sta.z __20+1
    // print_uchar(< >dw2)
    ldx.z __20
    jsr print_uchar
    // print_char(' ')
  // Test get low high byte of dword
    lda #' '
    jsr print_char
    // <dw2
    lda.z dw2
    sta.z __24
    lda.z dw2+1
    sta.z __24+1
    // print_uchar(> <dw2)
    tax
    jsr print_uchar
    // print_char(' ')
  // Test get high low byte of dword
    lda #' '
    jsr print_char
    // <dw2
    lda.z dw2
    sta.z __28
    lda.z dw2+1
    sta.z __28+1
    // print_uchar(< <dw2)
    ldx.z __28
    jsr print_uchar
    // print_ln()
  // Test get low low byte of dword
    jsr print_ln
    // for( dword dw = $12345678; dw != $12345690; dw++ )
    inc.z dw
    bne !+
    inc.z dw+1
    bne !+
    inc.z dw+2
    bne !+
    inc.z dw+3
  !:
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    jmp __b1
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor_1
    sta.z print_line_cursor
    lda #0
    adc.z print_line_cursor_1+1
    sta.z print_line_cursor+1
    // while (print_line_cursor<print_char_cursor)
    cmp.z print_char_cursor+1
    bcc __b2
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b2
  !:
    // }
    rts
  __b2:
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
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
// Print a unsigned int as HEX
// print_uint(word zp($c) w)
print_uint: {
    .label w = $c
    // print_uchar(>w)
    ldx.z w+1
    jsr print_uchar
    // print_uchar(<w)
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Print a unsigned long as HEX
// print_ulong(dword zp($e) dw)
print_ulong: {
    .label dw = $e
    // print_uint(>dw)
    lda.z dw+2
    sta.z print_uint.w
    lda.z dw+3
    sta.z print_uint.w+1
    lda.z print_char_cursor_1
    sta.z print_char_cursor
    lda.z print_char_cursor_1+1
    sta.z print_char_cursor+1
    // print_uint(>dw)
    jsr print_uint
    // print_uint(<dw)
    lda.z dw
    sta.z print_uint.w
    lda.z dw+1
    sta.z print_uint.w+1
    jsr print_uint
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
    .label dst = $c
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
