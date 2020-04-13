.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // empty circle
  .const FF = $57
  // filled circle
  .const TT = $51
  .label print_char_cursor = $b
  .label print_line_cursor = 6
main: {
    .label w1 = $f
    .label w2 = $11
    .label s = 5
    .label op = 4
    .label j = 3
    .label i = 2
    // print_cls()
    jsr print_cls
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #0
    sta.z s
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #0
    sta.z i
  __b1:
    // w1 = words[i]
    lda.z i
    asl
    tay
    lda words,y
    sta.z w1
    lda words+1,y
    sta.z w1+1
    lda #0
    sta.z j
  __b2:
    // w2 = words[j]
    lda.z j
    asl
    tay
    lda words,y
    sta.z w2
    lda words+1,y
    sta.z w2+1
    lda #0
    sta.z op
  __b3:
    // compare(w1,w2,op)
    lda.z w1
    sta.z compare.w1
    lda.z w1+1
    sta.z compare.w1+1
    lda.z op
    jsr compare
    // if(++s==3)
    inc.z s
    lda #3
    cmp.z s
    bne __b4
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #0
    sta.z s
  __b4:
    // for( byte op: 0..5 )
    inc.z op
    lda #6
    cmp.z op
    bne __b3
    // for( byte j: 0..2)
    inc.z j
    lda #3
    cmp.z j
    bne __b2
    // for( byte i: 0..2)
    inc.z i
    cmp.z i
    bne __b1
  __b5:
  // loop forever
    jmp __b5
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
// Compare two words using an operator
// compare(word zp(9) w1, word zp($11) w2, byte register(A) op)
compare: {
    .label w1 = 9
    .label w2 = $11
    .label ops = $d
    .label r = 8
    // if(op==0)
    cmp #0
    bne !__b1+
    jmp __b1
  !__b1:
    // if(op==1)
    cmp #1
    bne !__b2+
    jmp __b2
  !__b2:
    // if(op==2)
    cmp #2
    bne !__b3+
    jmp __b3
  !__b3:
    // if(op==3)
    cmp #3
    beq __b4
    // if(op==4)
    cmp #4
    beq __b5
    // if(op==5)
    cmp #5
    bne __b8
    // if(w1!=w2)
    lda.z w1
    cmp.z w2
    bne !+
    lda.z w1+1
    cmp.z w2+1
    beq __b7
  !:
    lda #TT
    sta.z r
    jmp __b19
  __b7:
    lda #FF
    sta.z r
  __b19:
    lda #<ops_1
    sta.z ops
    lda #>ops_1
    sta.z ops+1
    jmp __b6
  __b8:
    lda #FF
    sta.z r
    lda #<0
    sta.z ops
    sta.z ops+1
  __b6:
    // print_uint(w1)
    jsr print_uint
    // print_str(ops)
    jsr print_str
    // print_uint(w2)
    lda.z w2
    sta.z print_uint.w
    lda.z w2+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_char(r)
    lda.z r
    jsr print_char
    // print_char(' ')
    lda #' '
    jsr print_char
    // }
    rts
  __b5:
    // if(w1==w2)
    lda.z w1+1
    cmp.z w2+1
    bne __b9
    lda.z w1
    cmp.z w2
    bne __b9
    lda #TT
    sta.z r
    jmp __b20
  __b9:
    lda #FF
    sta.z r
  __b20:
    lda #<ops_2
    sta.z ops
    lda #>ops_2
    sta.z ops+1
    jmp __b6
  __b4:
    // if(w1>=w2)
    lda.z w1+1
    cmp.z w2+1
    bcc __b10
    bne !+
    lda.z w1
    cmp.z w2
    bcc __b10
  !:
    lda #TT
    sta.z r
    jmp __b21
  __b10:
    lda #FF
    sta.z r
  __b21:
    lda #<ops_3
    sta.z ops
    lda #>ops_3
    sta.z ops+1
    jmp __b6
  __b3:
    // if(w1>w2)
    lda.z w1+1
    cmp.z w2+1
    bne !+
    lda.z w1
    cmp.z w2
    beq __b11
  !:
    bcc __b11
    lda #TT
    sta.z r
    jmp __b22
  __b11:
    lda #FF
    sta.z r
  __b22:
    lda #<ops_4
    sta.z ops
    lda #>ops_4
    sta.z ops+1
    jmp __b6
  __b2:
    // if(w1<=w2)
    lda.z w2+1
    cmp.z w1+1
    bcc __b12
    bne !+
    lda.z w2
    cmp.z w1
    bcc __b12
  !:
    lda #TT
    sta.z r
    jmp __b23
  __b12:
    lda #FF
    sta.z r
  __b23:
    lda #<ops_5
    sta.z ops
    lda #>ops_5
    sta.z ops+1
    jmp __b6
  __b1:
    // if(w1<w2)
    lda.z w2+1
    cmp.z w1+1
    bne !+
    lda.z w2
    cmp.z w1
    beq __b13
  !:
    bcc __b13
    lda #TT
    sta.z r
    jmp __b24
  __b13:
    lda #FF
    sta.z r
  __b24:
    lda #<ops_6
    sta.z ops
    lda #>ops_6
    sta.z ops+1
    jmp __b6
    ops_1: .text "!="
    .byte 0
    ops_2: .text "=="
    .byte 0
    ops_3: .text ">="
    .byte 0
    ops_4: .text "> "
    .byte 0
    ops_5: .text "<="
    .byte 0
    ops_6: .text "< "
    .byte 0
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
// print_uint(word zp(9) w)
print_uint: {
    .label w = 9
    // print_u8(>w)
    ldx.z w+1
    jsr print_u8
    // print_u8(<w)
    ldx.z w
    jsr print_u8
    // }
    rts
}
// Print a char as HEX
// print_u8(byte register(X) b)
print_u8: {
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
// Print a zero-terminated string
// print_str(byte* zp($d) str)
print_str: {
    .label str = $d
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
    .label dst = $d
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
  words: .word $12, $3f34, $cfed
