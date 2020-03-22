.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 8
  .label print_line_cursor = 5
main: {
    .label b = $d
    .label a = 2
    .label i = 3
    .label r = 4
    // print_cls()
    jsr print_cls
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #0
    sta.z i
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
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
    bcs b1
    ldy #'+'
    jmp __b2
  b1:
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
    bcs b2
    lda #'+'
    jmp __b3
  b2:
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
    bcs b3
    lda #'+'
    sta.z r
    jmp __b4
  b3:
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
    bcs b4
    ldy #'+'
    jmp __b5
  b4:
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
    bcs b5
    ldy #'+'
    jmp __b6
  b5:
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
    bcc b6
    lda #'+'
    jmp __b7
  b6:
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
    bcs b7
    lda #'+'
    sta.z r
    jmp __b8
  b7:
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
    bcs b8
    ldy #'+'
    jmp __b9
  b8:
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
    bcc b9
    ldy #'+'
    jmp __b10
  b9:
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
    bcs b10
    lda #'+'
    jmp __b11
  b10:
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
    bcc b11
    lda #'+'
    sta.z r
    jmp __b12
  b11:
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
    bcc b12
    ldy #'+'
    jmp __b13
  b12:
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
    bcc b13
    ldy #'+'
    jmp __b14
  b13:
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
    bcc b14
    lda #'+'
    jmp __b15
  b14:
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
    bcc b15
    lda #'+'
    sta.z r
    jmp __b16
  b15:
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
    bcc b16
    ldy #'+'
    jmp __b17
  b16:
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
    bne b17
    ldy #'+'
    jmp __b18
  b17:
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
    bne b18
    lda #'+'
    jmp __b19
  b18:
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
    bne b19
    lda #'+'
    sta.z r
    jmp __b20
  b19:
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
    bne b20
    ldy #'+'
    jmp __b21
  b20:
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
// printu(byte register(X) a, byte* zp($b) op, byte zp(7) b, byte zp(4) res)
printu: {
    .label b = 7
    .label res = 4
    .label op = $b
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_byte(a)
    stx.z print_byte.b
    jsr print_byte
    // print_str(op)
    jsr print_str
    // print_byte(b)
    lda.z b
    sta.z print_byte.b
    jsr print_byte
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_char(res)
    lda.z res
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
// Print a byte as HEX
// print_byte(byte zp($a) b)
print_byte: {
    .label b = $a
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
// Print a zero-terminated string
// print_str(byte* zp($b) str)
print_str: {
    .label str = $b
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(print_char_cursor++) = *(str++)
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    // *(print_char_cursor++) = *(str++);
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
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
    .label dst = $b
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
