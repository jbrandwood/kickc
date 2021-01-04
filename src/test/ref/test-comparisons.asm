// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
  // Commodore 64 PRG executable file
.file [name="test-comparisons.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label print_screen = $400
  .label print_line_cursor = 6
  .label print_char_cursor = $a
.segment Code
main: {
    .label b = $c
    .label a = 2
    .label i = 3
    .label r = 4
    // print_cls()
    jsr print_cls
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    lda #0
    sta.z i
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #7
    sta.z a
  __b1:
    // b = $ce-a
    lda #$ce
    sec
    sbc.z a
    sta.z b
    // if(a<b)
    lda.z a
    cmp.z b
    bcs __b22
    ldy #'+'
    jmp __b2
  __b22:
    ldy #'-'
  __b2:
    // printu(a, "< ", b, r)
    ldx.z a
    lda.z b
    sta.z printu.b
    sty.z printu.res
    lda #<op
    sta.z printu.op
    lda #>op
    sta.z printu.op+1
    jsr printu
    // if(a<$37)
    lda.z a
    cmp #$37
    bcs __b23
    lda #'+'
    jmp __b3
  __b23:
    lda #'-'
  __b3:
    // printu(a, "< ", $37, r)
    ldx.z a
    sta.z printu.res
    lda #$37
    sta.z printu.b
    lda #<op
    sta.z printu.op
    lda #>op
    sta.z printu.op+1
    jsr printu
    // if(a<cs[i])
    lda.z a
    ldy.z i
    cmp cs,y
    bcs __b24
    lda #'+'
    sta.z r
    jmp __b4
  __b24:
    lda #'-'
    sta.z r
  __b4:
    // printu(a, "< ", cs[i], r)
    ldx.z a
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op
    sta.z printu.op
    lda #>op
    sta.z printu.op+1
    jsr printu
    // if(a<a)
    lda.z a
    cmp.z a
    bcs __b25
    ldy #'+'
    jmp __b5
  __b25:
    ldy #'-'
  __b5:
    // printu(a, "< ", a, r)
    ldx.z a
    txa
    sta.z printu.b
    sty.z printu.res
    lda #<op
    sta.z printu.op
    lda #>op
    sta.z printu.op+1
    jsr printu
    // print_ln()
    jsr print_ln
    // if(a>b)
    lda.z b
    cmp.z a
    bcs __b26
    ldy #'+'
    jmp __b6
  __b26:
    ldy #'-'
  __b6:
    // printu(a, "> ", b, r)
    ldx.z a
    lda.z b
    sta.z printu.b
    sty.z printu.res
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // printu(a, "> ", b, r)
    lda #<op4
    sta.z printu.op
    lda #>op4
    sta.z printu.op+1
    jsr printu
    // if(a>$37)
    lda.z a
    cmp #$37+1
    bcc __b27
    lda #'+'
    jmp __b7
  __b27:
    lda #'-'
  __b7:
    // printu(a, "> ", $37, r)
    ldx.z a
    sta.z printu.res
    lda #$37
    sta.z printu.b
    lda #<op4
    sta.z printu.op
    lda #>op4
    sta.z printu.op+1
    jsr printu
    // if(a>cs[i])
    ldy.z i
    lda cs,y
    cmp.z a
    bcs __b28
    lda #'+'
    sta.z r
    jmp __b8
  __b28:
    lda #'-'
    sta.z r
  __b8:
    // printu(a, "> ", cs[i], r)
    ldx.z a
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op4
    sta.z printu.op
    lda #>op4
    sta.z printu.op+1
    jsr printu
    // if(a>a)
    lda.z a
    cmp.z a
    bcs __b29
    ldy #'+'
    jmp __b9
  __b29:
    ldy #'-'
  __b9:
    // printu(a, "> ", a, r)
    ldx.z a
    txa
    sta.z printu.b
    sty.z printu.res
    lda #<op4
    sta.z printu.op
    lda #>op4
    sta.z printu.op+1
    jsr printu
    // print_ln()
    jsr print_ln
    // if(a<=b)
    lda.z b
    cmp.z a
    bcc __b30
    ldy #'+'
    jmp __b10
  __b30:
    ldy #'-'
  __b10:
    // printu(a, "<=", b, r)
    ldx.z a
    lda.z b
    sta.z printu.b
    sty.z printu.res
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // printu(a, "<=", b, r)
    lda #<op8
    sta.z printu.op
    lda #>op8
    sta.z printu.op+1
    jsr printu
    // if(a<=$37)
    lda.z a
    cmp #$37+1
    bcs __b31
    lda #'+'
    jmp __b11
  __b31:
    lda #'-'
  __b11:
    // printu(a, "<=", $37, r)
    ldx.z a
    sta.z printu.res
    lda #$37
    sta.z printu.b
    lda #<op8
    sta.z printu.op
    lda #>op8
    sta.z printu.op+1
    jsr printu
    // if(a<=cs[i])
    ldy.z i
    lda cs,y
    cmp.z a
    bcc __b32
    lda #'+'
    sta.z r
    jmp __b12
  __b32:
    lda #'-'
    sta.z r
  __b12:
    // printu(a, "<=", cs[i], r)
    ldx.z a
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op8
    sta.z printu.op
    lda #>op8
    sta.z printu.op+1
    jsr printu
    // if(a<=a)
    lda.z a
    cmp.z a
    bcc __b33
    ldy #'+'
    jmp __b13
  __b33:
    ldy #'-'
  __b13:
    // printu(a, "<=", a, r)
    ldx.z a
    txa
    sta.z printu.b
    sty.z printu.res
    lda #<op8
    sta.z printu.op
    lda #>op8
    sta.z printu.op+1
    jsr printu
    // print_ln()
    jsr print_ln
    // if(a>=b)
    lda.z a
    cmp.z b
    bcc __b34
    ldy #'+'
    jmp __b14
  __b34:
    ldy #'-'
  __b14:
    // printu(a, ">=", b, r)
    ldx.z a
    lda.z b
    sta.z printu.b
    sty.z printu.res
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // printu(a, ">=", b, r)
    lda #<op12
    sta.z printu.op
    lda #>op12
    sta.z printu.op+1
    jsr printu
    // if(a>=$37)
    lda.z a
    cmp #$37
    bcc __b35
    lda #'+'
    jmp __b15
  __b35:
    lda #'-'
  __b15:
    // printu(a, ">=", $37, r)
    ldx.z a
    sta.z printu.res
    lda #$37
    sta.z printu.b
    lda #<op12
    sta.z printu.op
    lda #>op12
    sta.z printu.op+1
    jsr printu
    // if(a>=cs[i])
    lda.z a
    ldy.z i
    cmp cs,y
    bcc __b36
    lda #'+'
    sta.z r
    jmp __b16
  __b36:
    lda #'-'
    sta.z r
  __b16:
    // printu(a, ">=", cs[i], r)
    ldx.z a
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op12
    sta.z printu.op
    lda #>op12
    sta.z printu.op+1
    jsr printu
    // if(a>=a)
    lda.z a
    cmp.z a
    bcc __b37
    ldy #'+'
    jmp __b17
  __b37:
    ldy #'-'
  __b17:
    // printu(a, ">=", a, r)
    ldx.z a
    txa
    sta.z printu.b
    sty.z printu.res
    lda #<op12
    sta.z printu.op
    lda #>op12
    sta.z printu.op+1
    jsr printu
    // print_ln()
    jsr print_ln
    // if(a==b)
    lda.z a
    cmp.z b
    bne __b38
    ldy #'+'
    jmp __b18
  __b38:
    ldy #'-'
  __b18:
    // printu(a, "==", b, r)
    ldx.z a
    lda.z b
    sta.z printu.b
    sty.z printu.res
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // printu(a, "==", b, r)
    lda #<op16
    sta.z printu.op
    lda #>op16
    sta.z printu.op+1
    jsr printu
    // if(a==$37)
    lda #$37
    cmp.z a
    bne __b39
    lda #'+'
    jmp __b19
  __b39:
    lda #'-'
  __b19:
    // printu(a, "==", $37, r)
    ldx.z a
    sta.z printu.res
    lda #$37
    sta.z printu.b
    lda #<op16
    sta.z printu.op
    lda #>op16
    sta.z printu.op+1
    jsr printu
    // if(a==cs[i])
    lda.z a
    ldy.z i
    cmp cs,y
    bne __b40
    lda #'+'
    sta.z r
    jmp __b20
  __b40:
    lda #'-'
    sta.z r
  __b20:
    // printu(a, "==", cs[i], r)
    ldx.z a
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op16
    sta.z printu.op
    lda #>op16
    sta.z printu.op+1
    jsr printu
    // if(a==a)
    lda.z a
    cmp.z a
    bne __b41
    ldy #'+'
    jmp __b21
  __b41:
    ldy #'-'
  __b21:
    // printu(a, "==", a, r)
    ldx.z a
    txa
    sta.z printu.b
    sty.z printu.res
    lda #<op16
    sta.z printu.op
    lda #>op16
    sta.z printu.op+1
    jsr printu
    // print_ln()
    jsr print_ln
    // a=a+$30
    lax.z a
    axs #-[$30]
    stx.z a
    // for( byte i : 0..4 )
    inc.z i
    lda #5
    cmp.z i
    bne __b68
  __b42:
    jmp __b42
  __b68:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
  .segment Data
    cs: .byte 7, $c7, $37, $97, $67
    op: .text "< "
    .byte 0
    op4: .text "> "
    .byte 0
    op8: .text "<="
    .byte 0
    op12: .text ">="
    .byte 0
    op16: .text "=="
    .byte 0
}
.segment Code
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// printu(byte register(X) a, byte* zp(8) op, byte zp(5) b, byte zp(4) res)
printu: {
    .label b = 5
    .label res = 4
    .label op = 8
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_uchar(a)
    jsr print_uchar
    // print_str(op)
    jsr print_str
    // print_uchar(b)
    ldx.z b
    jsr print_uchar
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_char(res)
    lda.z res
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = 8
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
    txa
    and #$f
    // print_char(print_hextab[b&$f])
    tay
    lda print_hextab,y
    jsr print_char
    // }
    rts
}
// Print a zero-terminated string
// print_str(byte* zp(8) str)
print_str: {
    .label str = 8
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
.segment Data
  print_hextab: .text "0123456789abcdef"
