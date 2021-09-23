// Tests the different standard C types
  // Commodore 64 PRG executable file
.file [name="c-types.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label print_screen = $400
  .label print_char_cursor = 2
  .label print_line_cursor = 6
.segment Code
main: {
    // print_cls()
    jsr print_cls
    // testChar()
    jsr testChar
    // testShort()
    jsr testShort
    // testInt()
    jsr testInt
    // testLong()
    jsr testLong
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
testChar: {
    .const u = $e
    .const n = $e
    .label s = -$e
    // print_str("char: ")
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(u)
    ldx #u
    jsr print_uchar
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_uchar(n)
    ldx #n
    jsr print_uchar
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_schar(s)
    jsr print_schar
    // print_ln()
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    jsr print_ln
    // }
    rts
  .segment Data
    str: .text "char: "
    .byte 0
}
.segment Code
testShort: {
    .const u = $578
    .const n = -$578
    .const s = -$578
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("short: ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uint(u)
    lda #<u
    sta.z print_uint.w
    lda #>u
    sta.z print_uint.w+1
    jsr print_uint
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_sint(n)
    lda #<n
    sta.z print_sint.w
    lda #>n
    sta.z print_sint.w+1
    jsr print_sint
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_sint(s)
    lda #<s
    sta.z print_sint.w
    lda #>s
    sta.z print_sint.w+1
    jsr print_sint
    // print_ln()
    jsr print_ln
    // }
    rts
  .segment Data
    str: .text "short: "
    .byte 0
}
.segment Code
testInt: {
    .const u = $578
    .const n = -$578
    .const s = -$578
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("int: ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uint(u)
    lda #<u
    sta.z print_uint.w
    lda #>u
    sta.z print_uint.w+1
    jsr print_uint
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_sint(n)
    lda #<n
    sta.z print_sint.w
    lda #>n
    sta.z print_sint.w+1
    jsr print_sint
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_sint(s)
    lda #<s
    sta.z print_sint.w
    lda #>s
    sta.z print_sint.w+1
    jsr print_sint
    // print_ln()
    jsr print_ln
    // }
    rts
  .segment Data
    str: .text "int: "
    .byte 0
}
.segment Code
testLong: {
    .const u = $222e0
    .const n = -$222e0
    .const s = -$222e0
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("long: ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_ulong(u)
    lda #<u
    sta.z print_ulong.dw
    lda #>u
    sta.z print_ulong.dw+1
    lda #<u>>$10
    sta.z print_ulong.dw+2
    lda #>u>>$10
    sta.z print_ulong.dw+3
    jsr print_ulong
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_slong(n)
    lda #<n
    sta.z print_slong.dw
    lda #>n
    sta.z print_slong.dw+1
    lda #<n>>$10
    sta.z print_slong.dw+2
    lda #>n>>$10
    sta.z print_slong.dw+3
    jsr print_slong
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_slong(s)
    lda #<s
    sta.z print_slong.dw
    lda #>s
    sta.z print_slong.dw+1
    lda #<s>>$10
    sta.z print_slong.dw+2
    lda #>s>>$10
    sta.z print_slong.dw+3
    jsr print_slong
    // print_ln()
    jsr print_ln
    // }
    rts
  .segment Data
    str: .text "long: "
    .byte 0
}
.segment Code
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
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
// Print a zero-terminated string
// void print_str(__zp(4) char *str)
print_str: {
    .label str = 4
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
// Print a signed char as HEX
// void print_schar(signed char b)
print_schar: {
    .const b = -testChar.s
    // print_char('-')
    lda #'-'
    jsr print_char
    // print_uchar((char)b)
    ldx #b
    jsr print_uchar
    // }
    rts
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
// Print a unsigned int as HEX
// void print_uint(__zp(4) unsigned int w)
print_uint: {
    .label w = 4
    // print_uchar(BYTE1(w))
    ldx.z w+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Print a signed int as HEX
// void print_sint(__zp(4) int w)
print_sint: {
    .label w = 4
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
    lda #0
    sec
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
    jmp __b2
}
// Print a unsigned long as HEX
// void print_ulong(__zp(8) unsigned long dw)
print_ulong: {
    .label dw = 8
    // print_uint(WORD1(dw))
    lda.z dw+2
    sta.z print_uint.w
    lda.z dw+3
    sta.z print_uint.w+1
    jsr print_uint
    // print_uint(WORD0(dw))
    lda.z dw
    sta.z print_uint.w
    lda.z dw+1
    sta.z print_uint.w+1
    jsr print_uint
    // }
    rts
}
// Print a signed long as HEX
// void print_slong(__zp(8) long dw)
print_slong: {
    .label dw = 8
    // if(dw<0)
    lda.z dw+3
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_ulong((unsigned long)dw)
    jsr print_ulong
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // dw = -dw
    sec
    lda.z dw
    eor #$ff
    adc #0
    sta.z dw
    lda.z dw+1
    eor #$ff
    adc #0
    sta.z dw+1
    lda.z dw+2
    eor #$ff
    adc #0
    sta.z dw+2
    lda.z dw+3
    eor #$ff
    adc #0
    sta.z dw+3
    jmp __b2
}
.segment Data
  print_hextab: .text "0123456789abcdef"
