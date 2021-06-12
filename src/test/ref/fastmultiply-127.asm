// An implementation of seriously fast multiply for integer values in the interval [-1;1] with the best possible precision
// NOTE: So far unsuccessful - since the handling of sign and values where a+b>sqrt2) makes the code slower than regular fast multiply
// In this model 255 binary represents 1.0 - meaning that 255*255 = 255
// Uses principles from C=Hacking #16 https://codebase64.org/doku.php?id=magazines:chacking16
// Utilizes the fact that a*b = ((a+b)/2)^2 - ((a-b)/2)^2
  // Commodore 64 PRG executable file
.file [name="fastmultiply-127.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label print_screen = $400
  .label print_char_cursor = 8
  .label print_line_cursor = 2
.segment Code
main: {
    // print_cls()
    jsr print_cls
    // print_str("unsigned")
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    jsr print_ln
    // print_mulf8u127(0,0)
    lda #0
    sta.z print_mulf8u127.b
    tay
    jsr print_mulf8u127
    // print_mulf8u127(127,127)
    lda #$7f
    sta.z print_mulf8u127.b
    tay
    jsr print_mulf8u127
    // print_mulf8u127(64,64)
    lda #$40
    sta.z print_mulf8u127.b
    tay
    jsr print_mulf8u127
    // print_mulf8u127(64,127)
    lda #$7f
    sta.z print_mulf8u127.b
    ldy #$40
    jsr print_mulf8u127
    // print_mulf8u127(64,192)
    lda #$c0
    sta.z print_mulf8u127.b
    ldy #$40
    jsr print_mulf8u127
    // print_mulf8u127(255,127)
    lda #$7f
    sta.z print_mulf8u127.b
    ldy #$ff
    jsr print_mulf8u127
    // print_mulf8u127(192,192)
    lda #$c0
    sta.z print_mulf8u127.b
    tay
    jsr print_mulf8u127
    // print_mulf8u127(255,255)
    lda #$ff
    sta.z print_mulf8u127.b
    tay
    jsr print_mulf8u127
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("signed")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    jsr print_ln
    // print_mulf8s127(0,0)
    lda #0
    sta.z print_mulf8s127.b
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // print_mulf8s127(64,64)
    lda #$40
    sta.z print_mulf8s127.b
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // print_mulf8s127(64,127)
    lda #$7f
    sta.z print_mulf8s127.b
    lda #$40
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // print_mulf8s127(-64,64)
    lda #$40
    sta.z print_mulf8s127.b
    lda #-$40
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // print_mulf8s127(64,-64)
    lda #-$40
    sta.z print_mulf8s127.b
    lda #$40
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // print_mulf8s127(-64,-64)
    lda #-$40
    sta.z print_mulf8s127.b
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // print_mulf8s127(127,127)
    lda #$7f
    sta.z print_mulf8s127.b
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // print_mulf8s127(-127,127)
    lda #$7f
    sta.z print_mulf8s127.b
    lda #-$7f
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // print_mulf8s127(127,-127)
    lda #-$7f
    sta.z print_mulf8s127.b
    lda #$7f
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // print_mulf8s127(-127,-127)
    lda #-$7f
    sta.z print_mulf8s127.b
    sta.z print_mulf8s127.a
    jsr print_mulf8s127
    // }
    rts
  .segment Data
    str: .text "unsigned"
    .byte 0
    str1: .text "signed"
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
// Print a zero-terminated string
// print_str(byte* zp(6) str)
print_str: {
    .label str = 6
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
// print_mulf8u127(byte register(Y) a, byte zp(4) b)
print_mulf8u127: {
    .label c = 6
    .label b = 4
    // mulf8u127(a,b)
    tya
    tax
    lda.z b
    jsr mulf8u127
    // mulf8u127(a,b)
    // unsigned word c = mulf8u127(a,b)
    // print_uchar(a)
    tya
    tax
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_uchar(a)
    jsr print_uchar
    // print_char('*')
    lda #'*'
    jsr print_char
    // print_uchar(b)
    ldx.z b
    jsr print_uchar
    // print_char('=')
    lda #'='
    jsr print_char
    // print_uint(c)
    jsr print_uint
    // print_ln()
    jsr print_ln
    // }
    rts
}
// print_mulf8s127(signed byte zp(4) a, signed byte zp(5) b)
print_mulf8s127: {
    .label c = 6
    .label a = 4
    .label b = 5
    // mulf8s127(a,b)
    ldy.z b
    jsr mulf8s127
    // signed word c = mulf8s127(a,b)
    // print_schar(a)
    ldx.z a
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_schar(a)
    jsr print_schar
    // print_char('*')
    lda #'*'
    jsr print_char
    // print_schar(b)
    ldx.z b
    jsr print_schar
    // print_char('=')
    lda #'='
    jsr print_char
    // print_sint(c)
    jsr print_sint
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
    .label dst = 6
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
// mulf8u127(byte register(X) a, byte register(A) b)
mulf8u127: {
    .label memA = $fc
    .label memB = $fd
    .label res = $fe
    .label resL = $fe
    .label resH = $ff
    .label return = 6
    // *memA = a
    stx memA
    // *memB = b
    sta memB
    // asm
    txa
    sta sm1+1
    sta sm3+1
    eor #$ff
    sta sm2+1
    sta sm4+1
    ldx memB
    sec
  sm1:
    lda mulf127_sqr1_lo,x
  sm2:
    sbc mulf127_sqr2_lo,x
    sta resL
  sm3:
    lda mulf127_sqr1_hi,x
  sm4:
    sbc mulf127_sqr2_hi,x
    sta resH
    // return *res;
    lda res
    sta.z return
    lda res+1
    sta.z return+1
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
// Print a unsigned int as HEX
// print_uint(word zp(6) w)
print_uint: {
    .label w = 6
    // print_uchar(BYTE1(w))
    ldx.z w+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// mulf8s127(signed byte zp(4) a, signed byte register(Y) b)
mulf8s127: {
    .label __9 = 8
    .label __10 = $a
    .label __11 = 8
    .label __12 = $a
    .label a = 4
    .label return = 6
    .label c = 6
    // mulf8u127((unsigned char)a, (unsigned char)b)
    ldx.z a
    tya
    jsr mulf8u127
    // mulf8u127((unsigned char)a, (unsigned char)b)
    // if(a<0)
    lda.z a
    cmp #0
    bpl __b1
    // (signed word)b*2
    tya
    sta.z __11
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z __11+1
    asl.z __9
    rol.z __9+1
    // c -= (signed word)b*2
    lda.z c
    sec
    sbc.z __9
    sta.z c
    lda.z c+1
    sbc.z __9+1
    sta.z c+1
  __b1:
    // if(b<0)
    cpy #0
    bpl __b2
    // (signed word)a*2
    lda.z a
    sta.z __12
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z __12+1
    asl.z __10
    rol.z __10+1
    // c -= (signed word)a*2
    lda.z c
    sec
    sbc.z __10
    sta.z c
    lda.z c+1
    sbc.z __10+1
    sta.z c+1
  __b2:
    // if(a<0 && b<0)
    lda.z a
    cmp #0
    bpl __b3
    cpy #0
    bpl __b3
    // c -= 0x200
    lda.z c
    sec
    sbc #<$200
    sta.z c
    lda.z c+1
    sbc #>$200
    sta.z c+1
    rts
  __b3:
    // }
    rts
}
// Print a signed char as HEX
// print_schar(signed byte register(X) b)
print_schar: {
    // if(b<0)
    cpx #0
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_uchar((char)b)
    jsr print_uchar
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // b = -b
    txa
    eor #$ff
    clc
    adc #1
    tax
    jmp __b2
}
// Print a signed int as HEX
// print_sint(signed word zp(6) w)
print_sint: {
    .label w = 6
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
.segment Data
  print_hextab: .text "0123456789abcdef"
  // mulf_sqr tables will contain f(x)=int(x*x/4) and g(x) = f(x-255).
  // f(x) = ( x * x )/4
  .align $100
mulf127_sqr1_lo:
.fill 512, <round((i/127*i/127)*127/4) 
  .align $100
mulf127_sqr1_hi:
.fill 512, >round((i/127*i/127)*127/4) 
  // g(x) =  <((( x - 255) * ( x - 255 ))/4)
  .align $100
mulf127_sqr2_lo:
.fill 512, <round(((i-255)/127*(i-255)/127)*127/4) 
  .align $100
mulf127_sqr2_hi:
.fill 512, >round(((i-255)/127*(i-255)/127)*127/4) 
