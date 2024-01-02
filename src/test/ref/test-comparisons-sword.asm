// Test signed word comparisons
  // Commodore 64 PRG executable file
.file [name="test-comparisons-sword.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const LT = 0
  .const LE = 1
  .const GT = 2
  .const GE = 3
  .const EQ = 4
  .const NE = 5
  // empty circle
  .const FF = $57
  // filled circle
  .const TT = $51
  .label print_screen = $400
  .label print_line_cursor = 6
  .label print_char_cursor = 2
.segment Code
main: {
    .label w1 = $10
    .label w2 = $b
    .label s = $d
    .label op = $e
    .label j = $f
    .label i = $12
    // print_cls()
    jsr print_cls
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    lda #0
    sta.z s
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #0
    sta.z i
  __b1:
    // signed word w1 = swords[i]
    lda.z i
    asl
    tay
    lda swords,y
    sta.z w1
    lda swords+1,y
    sta.z w1+1
    lda #0
    sta.z j
  __b2:
    // signed word w2 = swords[j]
    lda.z j
    asl
    tay
    lda swords,y
    sta.z w2
    lda swords+1,y
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
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Compare two words using an operator
// void compare(__zp(8) int w1, __zp($b) int w2, __register(A) char op)
compare: {
    .label w1 = 8
    .label w2 = $b
    .label ops = 4
    .label r = $a
    // if(op==LT)
    cmp #LT
    bne !__b1+
    jmp __b1
  !__b1:
    // if(op==LE)
    cmp #LE
    bne !__b2+
    jmp __b2
  !__b2:
    // if(op==GT)
    cmp #GT
    bne !__b3+
    jmp __b3
  !__b3:
    // if(op==GE)
    cmp #GE
    beq __b4
    // if(op==EQ)
    cmp #EQ
    beq __b5
    // if(op==NE)
    cmp #NE
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
    // print_sint(w1)
    jsr print_sint
    // print_str(ops)
    jsr print_str
    // print_sint(w2)
    lda.z w2
    sta.z print_sint.w
    lda.z w2+1
    sta.z print_sint.w+1
    jsr print_sint
    // print_char(r)
    lda.z r
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
    lda.z w1
    cmp.z w2
    lda.z w1+1
    sbc.z w2+1
    bvc !+
    eor #$80
  !:
    bmi __b10
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
    lda.z w2
    cmp.z w1
    lda.z w2+1
    sbc.z w1+1
    bvc !+
    eor #$80
  !:
    bpl __b11
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
    lda.z w2
    cmp.z w1
    lda.z w2+1
    sbc.z w1+1
    bvc !+
    eor #$80
  !:
    bmi __b12
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
    lda.z w1
    cmp.z w2
    lda.z w1+1
    sbc.z w2+1
    bvc !+
    eor #$80
  !:
    bpl __b13
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
  .segment Data
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
.segment Code
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + 0x28
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
// Print a signed int as HEX
// void print_sint(__zp(8) int w)
print_sint: {
    .label w = 8
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
// Print a unsigned int as HEX
// void print_uint(__zp(8) unsigned int w)
print_uint: {
    .label w = 8
    // print_uchar(BYTE1(w))
    ldx.z w+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
    // }
    rts
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
    // b&0xf
    lda #$f
    axs #0
    // print_char(print_hextab[b&0xf])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
.segment Data
  print_hextab: .text "0123456789abcdef"
  swords: .word -$6fed, $12, $7fed
