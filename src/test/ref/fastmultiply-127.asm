// An implementation of seriously fast multiply for integer values in the interval [-1;1] with the best possible precision
// NOTE: So far unsuccessful - since the handling of sign and values where a+b>sqrt2) makes the code slower than regular fast multiply
// In this model 255 binary represents 1.0 - meaning that 255*255 = 255
// Uses principles from C=Hacking #16 https://codebase64.org/doku.php?id=magazines:chacking16
// Utilizes the fact that a*b = ((a+b)/2)^2 - ((a-b)/2)^2
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 7
  .label print_line_cursor = 5
main: {
    jsr print_cls
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    lda #0
    sta print_mulf8u127.b
    tay
    jsr print_mulf8u127
    lda #$7f
    sta print_mulf8u127.b
    tay
    jsr print_mulf8u127
    lda #$40
    sta print_mulf8u127.b
    tay
    jsr print_mulf8u127
    lda #$7f
    sta print_mulf8u127.b
    ldy #$40
    jsr print_mulf8u127
    lda #$c0
    sta print_mulf8u127.b
    ldy #$40
    jsr print_mulf8u127
    lda #$7f
    sta print_mulf8u127.b
    ldy #$ff
    jsr print_mulf8u127
    lda #$c0
    sta print_mulf8u127.b
    tay
    jsr print_mulf8u127
    lda #$ff
    sta print_mulf8u127.b
    tay
    jsr print_mulf8u127
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    lda #0
    sta print_mulf8s127.b
    tay
    jsr print_mulf8s127
    lda #$40
    sta print_mulf8s127.b
    tay
    jsr print_mulf8s127
    lda #$7f
    sta print_mulf8s127.b
    ldy #$40
    jsr print_mulf8s127
    lda #$40
    sta print_mulf8s127.b
    ldy #-$40
    jsr print_mulf8s127
    lda #-$40
    sta print_mulf8s127.b
    ldy #$40
    jsr print_mulf8s127
    lda #-$40
    sta print_mulf8s127.b
    tay
    jsr print_mulf8s127
    lda #$7f
    sta print_mulf8s127.b
    tay
    jsr print_mulf8s127
    lda #$7f
    sta print_mulf8s127.b
    ldy #-$7f
    jsr print_mulf8s127
    lda #-$7f
    sta print_mulf8s127.b
    ldy #$7f
    jsr print_mulf8s127
    lda #-$7f
    sta print_mulf8s127.b
    tay
    jsr print_mulf8s127
    rts
    str: .text "unsigned"
    .byte 0
    str1: .text "signed"
    .byte 0
}
// print_mulf8s127(signed byte register(Y) a, signed byte zeropage(4) b)
print_mulf8s127: {
    .label c = 2
    .label b = 4
    jsr mulf8s127
    tya
    tax
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_sbyte
    lda #'*'
    jsr print_char
    ldx b
    jsr print_sbyte
    lda #'='
    jsr print_char
    jsr print_sword
    jsr print_ln
    rts
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
  !:
    rts
}
// Print a signed word as HEX
// print_sword(signed word zeropage(2) w)
print_sword: {
    .label w = 2
    lda w+1
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_word
    rts
  b1:
    lda #'-'
    jsr print_char
    sec
    lda #0
    sbc w
    sta w
    lda #0
    sbc w+1
    sta w+1
    jmp b2
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// Print a word as HEX
// print_word(word zeropage(2) w)
print_word: {
    .label w = 2
    lda w+1
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    axs #0
    lda print_hextab,x
    jsr print_char
    rts
}
// Print a signed byte as HEX
// print_sbyte(signed byte register(X) b)
print_sbyte: {
    cpx #0
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_byte
    rts
  b1:
    lda #'-'
    jsr print_char
    txa
    eor #$ff
    clc
    adc #1
    tax
    jmp b2
}
// mulf8s127(signed byte register(Y) a, signed byte zeropage(4) b)
mulf8s127: {
    .label _12 = 7
    .label _13 = 7
    .label _14 = 9
    .label _15 = 9
    .label b = 4
    .label return = 2
    .label c = 2
    tya
    ldx b
    jsr mulf8u127
    cpy #0
    bpl b1
    lda b
    sta _12
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _12+1
    asl _13
    rol _13+1
    lda c
    sec
    sbc _13
    sta c
    lda c+1
    sbc _13+1
    sta c+1
  b1:
    lda b
    cmp #0
    bpl b2
    tya
    sta _14
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _14+1
    asl _15
    rol _15+1
    lda c
    sec
    sbc _15
    sta c
    lda c+1
    sbc _15+1
    sta c+1
  b2:
    cpy #0
    bpl b3
    lda b
    cmp #0
    bpl b3
    lda c
    sec
    sbc #<$200
    sta c
    lda c+1
    sbc #>$200
    sta c+1
    rts
  b3:
    rts
}
// mulf8u127(byte register(A) a, byte register(X) b)
mulf8u127: {
    .label memA = $fc
    .label memB = $fd
    .label res = $fe
    .label resL = $fe
    .label resH = $ff
    .label return = 2
    sta memA
    stx memB
    sta sm1+1
    sta sm3+1
    eor #$ff
    sta sm2+1
    sta sm4+1
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
    lda res
    sta return
    lda res+1
    sta return+1
    rts
}
// Print a zero-terminated string
// print_str(byte* zeropage(2) str)
print_str: {
    .label str = 2
  b1:
    ldy #0
    lda (str),y
    cmp #0
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
// print_mulf8u127(byte register(Y) a, byte zeropage(4) b)
print_mulf8u127: {
    .label c = 2
    .label b = 4
    tya
    ldx b
    jsr mulf8u127
    tya
    tax
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_byte
    lda #'*'
    jsr print_char
    ldx b
    jsr print_byte
    lda #'='
    jsr print_char
    jsr print_word
    jsr print_ln
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = $400
    .label end = str+num
    .label dst = 5
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
}
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
