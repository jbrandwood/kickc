// A lightweight library for printing on the C64.
// Printing with this library is done by calling print_ function for each element
  // Commodore 64 PRG executable file
.file [name="test-lowhigh.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label print_screen = $400
  .label print_line_cursor = $10
  .label print_char_cursor = $e
  .label print_char_cursor_1 = $10
  .label print_line_cursor_1 = 6
.segment Code
main: {
    .label __3 = 8
    .label __6 = $e
    .label __16 = $10
    .label __20 = $12
    .label __24 = $14
    .label __28 = $16
    .label __32 = 8
    .label __33 = $e
    .label dw2 = $a
    .label dw = 2
    // print_cls()
    jsr print_cls
    lda #<print_screen
    sta.z print_char_cursor_1
    lda #>print_screen
    sta.z print_char_cursor_1+1
    lda #<print_screen
    sta.z print_line_cursor_1
    lda #>print_screen
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
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Print a unsigned long as HEX
// print_ulong(dword zp($a) dw)
print_ulong: {
    .label dw = $a
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
// print_uint(word zp(8) w)
print_uint: {
    .label w = 8
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $10
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
.segment Data
  print_hextab: .text "0123456789abcdef"
