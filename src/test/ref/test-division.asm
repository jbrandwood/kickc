// Test the binary division library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 5
  .label print_line_cursor = $f
  .label rem16u = $b
  .label rem16s = $b
main: {
    jsr print_cls
    jsr test_8u
    jsr test_16u
    jsr test_8s
    jsr test_16s
    rts
}
test_16s: {
    .label dividend = 3
    .label divisor = $11
    .label res = 9
    .label i = $d
    lda #0
    sta i
  b1:
    lda i
    asl
    tax
    lda dividends,x
    sta dividend
    lda dividends+1,x
    sta dividend+1
    lda divisors,x
    sta divisor
    lda divisors+1,x
    sta divisor+1
    jsr div16s
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_sword
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda divisor
    sta print_sword.w
    lda divisor+1
    sta print_sword.w+1
    jsr print_sword
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda res
    sta print_sword.w
    lda res+1
    sta print_sword.w+1
    jsr print_sword
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda rem16s
    sta print_sword.w
    lda rem16s+1
    sta print_sword.w+1
    jsr print_sword
    jsr print_ln
    inc i
    lda #6
    cmp i
    bne b1
    rts
    dividends: .word $7fff, $7fff, -$7fff, -$7fff, $7fff, -$7fff
    divisors: .word 5, -7, $b, -$d, -$11, $13
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
// print_sword(signed word zeropage(3) w)
print_sword: {
    .label w = 3
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
// print_word(word zeropage(3) w)
print_word: {
    .label w = 3
    lda w+1
    sta print_byte.b
    jsr print_byte
    lda w
    sta print_byte.b
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage(2) b)
print_byte: {
    .label b = 2
    lda b
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    and b
    tay
    lda print_hextab,y
    jsr print_char
    rts
}
// Print a zero-terminated string
// print_str(byte* zeropage(3) str)
print_str: {
    .label str = 3
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
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
// Perform division on two signed 16-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// div16s(signed word zeropage(3) dividend, signed word zeropage($11) divisor)
div16s: {
    .label return = 9
    .label dividend = 3
    .label divisor = $11
    lda dividend
    sta divr16s.dividend
    lda dividend+1
    sta divr16s.dividend+1
    lda divisor
    sta divr16s.divisor
    lda divisor+1
    sta divr16s.divisor+1
    jsr divr16s
    rts
}
// Perform division on two signed 16-bit numbers with an initial remainder.
// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// divr16s(signed word zeropage(5) dividend, signed word zeropage(7) divisor)
divr16s: {
    .label _16 = $b
    .label dividendu = 5
    .label divisoru = 7
    .label resultu = 9
    .label return = 9
    .label dividend = 5
    .label divisor = 7
    lda dividend+1
    bmi b1
    ldy #0
  b2:
    lda divisor+1
    bmi b3
  b4:
    jsr divr16u
    cpy #0
    beq breturn
    sec
    lda #0
    sbc rem16s
    sta rem16s
    lda #0
    sbc rem16s+1
    sta rem16s+1
    sec
    lda #0
    sbc return
    sta return
    lda #0
    sbc return+1
    sta return+1
  breturn:
    rts
  b3:
    sec
    lda #0
    sbc divisoru
    sta divisoru
    lda #0
    sbc divisoru+1
    sta divisoru+1
    tya
    eor #1
    tay
    jmp b4
  b1:
    sec
    lda #0
    sbc dividendu
    sta dividendu
    lda #0
    sbc dividendu+1
    sta dividendu+1
    ldy #1
    jmp b2
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage(5) dividend, word zeropage(7) divisor, word zeropage($b) rem)
divr16u: {
    .label rem = $b
    .label dividend = 5
    .label quotient = 9
    .label return = 9
    .label divisor = 7
    ldx #0
    txa
    sta quotient
    sta quotient+1
    sta rem
    sta rem+1
  b1:
    asl rem
    rol rem+1
    lda dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora rem
    sta rem
  b2:
    asl dividend
    rol dividend+1
    asl quotient
    rol quotient+1
    lda rem+1
    cmp divisor+1
    bcc b3
    bne !+
    lda rem
    cmp divisor
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc divisor
    sta rem
    lda rem+1
    sbc divisor+1
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
test_8s: {
    .label dividend = 2
    .label divisor = $13
    .label res = $14
    .label i = $d
    lda #0
    sta i
  b1:
    ldy i
    lda dividends,y
    sta dividend
    lda divisors,y
    sta divisor
    ldy dividend
    tax
    jsr div8s
    sta res
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_sbyte
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda divisor
    sta print_sbyte.b
    jsr print_sbyte
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda res
    sta print_sbyte.b
    jsr print_sbyte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    stx print_sbyte.b
    jsr print_sbyte
    jsr print_ln
    inc i
    lda #6
    cmp i
    bne b1
    rts
    dividends: .byte $7f, -$7f, -$7f, $7f, $7f, $7f
    divisors: .byte 5, 7, -$b, -$d, $11, $13
}
// Print a signed byte as HEX
// print_sbyte(signed byte zeropage(2) b)
print_sbyte: {
    .label b = 2
    lda b
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_byte
    rts
  b1:
    lda #'-'
    jsr print_char
    lda b
    eor #$ff
    clc
    adc #1
    sta b
    jmp b2
}
// Perform division on two signed 8-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// div8s(signed byte register(Y) dividend, signed byte register(X) divisor)
div8s: {
    .label neg = $e
    cpy #0
    bmi b1
    lda #0
    sta neg
  b2:
    cpx #0
    bmi b3
  b4:
    tya
    jsr div8u
    tay
    lda neg
    cmp #0
    beq b5
    txa
    eor #$ff
    clc
    adc #1
    tax
    tya
    eor #$ff
    clc
    adc #1
    rts
  b5:
    tya
    rts
  b3:
    txa
    eor #$ff
    clc
    adc #1
    tax
    lda #1
    eor neg
    sta neg
    jmp b4
  b1:
    tya
    eor #$ff
    clc
    adc #1
    tay
    lda #1
    sta neg
    jmp b2
}
// Performs division on two 8 bit unsigned bytes
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8u
// Implemented using simple binary division
// div8u(byte register(A) dividend, byte register(X) divisor)
div8u: {
    sta divr8u.dividend
    stx divr8u.divisor
    jsr divr8u
    lda divr8u.return
    rts
}
// Performs division on two 8 bit unsigned bytes and an initial remainder
// Returns dividend/divisor.
// The final remainder will be set into the global variable rem8u
// Implemented using simple binary division
// divr8u(byte zeropage($14) dividend, byte zeropage($15) divisor, byte register(Y) rem)
divr8u: {
    .label dividend = $14
    .label divisor = $15
    .label quotient = $16
    .label return = $16
    ldx #0
    txa
    sta quotient
    tay
  b1:
    tya
    asl
    tay
    lda #$80
    and dividend
    cmp #0
    beq b2
    tya
    ora #1
    tay
  b2:
    asl dividend
    asl quotient
    cpy divisor
    bcc b3
    inc quotient
    tya
    sec
    sbc divisor
    tay
  b3:
    inx
    cpx #8
    bne b1
    tya
    tax
    rts
}
test_16u: {
    .label dividend = 3
    .label divisor = 7
    .label res = 9
    .label i = $e
    lda #0
    sta i
  b1:
    lda i
    asl
    tax
    lda dividends,x
    sta dividend
    lda dividends+1,x
    sta dividend+1
    lda divisors,x
    sta divisor
    lda divisors+1,x
    sta divisor+1
    jsr div16u
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_word
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda divisor
    sta print_word.w
    lda divisor+1
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda res
    sta print_word.w
    lda res+1
    sta print_word.w+1
    jsr print_word
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda rem16u
    sta print_word.w
    lda rem16u+1
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    inc i
    lda #6
    cmp i
    bne b1
    rts
    dividends: .word $ffff, $ffff, $ffff, $ffff, $ffff, $ffff
    divisors: .word 5, 7, $b, $d, $11, $13
}
// Performs division on two 16 bit unsigned words
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
// div16u(word zeropage(3) dividend, word zeropage(7) divisor)
div16u: {
    .label return = 9
    .label dividend = 3
    .label divisor = 7
    lda dividend
    sta divr16u.dividend
    lda dividend+1
    sta divr16u.dividend+1
    jsr divr16u
    rts
}
test_8u: {
    .label dividend = 2
    .label divisor = $15
    .label res = $16
    .label i = $13
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #0
    sta i
  b1:
    ldy i
    lda dividends,y
    sta dividend
    lda divisors,y
    sta divisor
    lda dividend
    ldx divisor
    jsr div8u
    sta res
    jsr print_byte
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda divisor
    sta print_byte.b
    jsr print_byte
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda res
    sta print_byte.b
    jsr print_byte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    stx print_byte.b
    jsr print_byte
    jsr print_ln
    inc i
    lda #6
    cmp i
    bne b11
    rts
  b11:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b1
    dividends: .byte $ff, $ff, $ff, $ff, $ff, $ff
    divisors: .byte 5, 7, $b, $d, $11, $13
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
    .label dst = $f
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b1:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    jmp b1
}
  print_hextab: .text "0123456789abcdef"
  str: .text " / @"
  str1: .text " = @"
  str2: .text " @"
