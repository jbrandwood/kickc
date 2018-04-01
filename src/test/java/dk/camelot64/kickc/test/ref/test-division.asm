.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 8
  .label print_line_cursor = 3
  .label rem16u = $e
  .label rem16s = $e
  jsr main
main: {
    jsr print_cls
    jsr test_8u
    jsr test_16u
    jsr test_8s
    jsr test_16s
    rts
}
test_16s: {
    .label dividend = 5
    .label divisor = $13
    .label res = $c
    .label i = 2
    lda #0
    sta i
  b1:
    ldy i
    lda dividends,y
    sta dividend
    lda dividends+1,y
    sta dividend+1
    lda divisors,y
    sta divisor
    lda divisors+1,y
    sta divisor+1
    lda dividend
    sta div16s.dividend
    lda dividend+1
    sta div16s.dividend+1
    lda divisor
    sta div16s.divisor
    lda divisor+1
    sta div16s.divisor+1
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
    lda #2
    clc
    adc i
    sta i
    cmp #$c
    beq !b1+
    jmp b1
  !b1:
    rts
    str: .text " / @"
    str1: .text " = @"
    str2: .text " @"
    dividends: .word $7fff, $7fff, -$7fff, -$7fff, $7fff, -$7fff
    divisors: .word 5, -7, $b, -$d, -$11, $13
}
print_ln: {
  b1:
    lda print_line_cursor
    clc
    adc #$28
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
print_sword: {
    .label w = 5
    lda w+1
    bpl b1
    lda #'-'
    jsr print_char
    sec
    lda w
    eor #$ff
    adc #0
    sta w
    lda w+1
    eor #$ff
    adc #0
    sta w+1
  b1:
    jsr print_word
    rts
}
print_word: {
    .label w = 5
    lda w+1
    sta print_byte.b
    jsr print_byte
    lda w
    sta print_byte.b
    jsr print_byte
    rts
}
print_byte: {
    .label b = 7
    lda b
    lsr
    lsr
    lsr
    lsr
    tay
    lda hextab,y
    jsr print_char
    lda #$f
    and b
    tay
    lda hextab,y
    jsr print_char
    rts
    hextab: .text "0123456789abcdef"
}
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
print_str: {
    .label str = 5
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
div16s: {
    .label _2 = 8
    .label _7 = $a
    .label resultu = $c
    .label return = $c
    .label dividend = 8
    .label divisor = $a
    .label dividendu = 8
    .label divisoru = $a
    lda dividend+1
    bpl b16
    sec
    lda _2
    eor #$ff
    adc #0
    sta _2
    lda _2+1
    eor #$ff
    adc #0
    sta _2+1
    ldy #1
  b2:
    lda divisor+1
    bpl b4
    sec
    lda _7
    eor #$ff
    adc #0
    sta _7
    lda _7+1
    eor #$ff
    adc #0
    sta _7+1
    tya
    eor #1
    tay
  b4:
    jsr div16u
    cpy #0
    bne b5
  breturn:
    rts
  b5:
    sec
    lda rem16s
    eor #$ff
    adc #0
    sta rem16s
    lda rem16s+1
    eor #$ff
    adc #0
    sta rem16s+1
    sec
    lda return
    eor #$ff
    adc #0
    sta return
    lda return+1
    eor #$ff
    adc #0
    sta return+1
    jmp breturn
  b16:
    ldy #0
    jmp b2
}
div16u: {
    .label return = $c
    .label dividend = 8
    .label divisor = $a
    jsr divr16u
    rts
}
divr16u: {
    .label rem = $e
    .label dividend = 8
    .label quotient = $c
    .label return = $c
    .label divisor = $a
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
    .label dividend = 7
    .label divisor = $15
    .label res = $10
    .label i = 2
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
    lda i
    cmp #6
    bne b1
    rts
    str: .text " / @"
    str1: .text " = @"
    str2: .text " @"
    dividends: .byte $7f, -$7f, -$7f, $7f, $7f, $7f
    divisors: .byte 5, 7, -$b, -$d, $11, $13
}
print_sbyte: {
    .label b = 7
    lda b
    cmp #0
    bpl b1
    lda #'-'
    jsr print_char
    lda b
    eor #$ff
    clc
    adc #1
    sta b
  b1:
    jsr print_byte
    rts
}
div8s: {
    .label neg = $10
    cpy #0
    bpl b16
    tya
    eor #$ff
    clc
    adc #1
    tay
    lda #1
    sta neg
  b2:
    cpx #0
    bpl b4
    txa
    eor #$ff
    clc
    adc #1
    tax
    lda neg
    eor #1
    sta neg
  b4:
    tya
    jsr div8u
    tay
    lda neg
    bne b5
    tya
  breturn:
    rts
  b5:
    txa
    eor #$ff
    clc
    adc #1
    tax
    tya
    eor #$ff
    clc
    adc #1
    jmp breturn
  b16:
    lda #0
    sta neg
    jmp b2
}
div8u: {
    sta divr8u.dividend
    stx divr8u.divisor
    jsr divr8u
    lda divr8u.return
    rts
}
divr8u: {
    .label dividend = $11
    .label divisor = $16
    .label quotient = $12
    .label return = $12
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
    .label dividend = 5
    .label divisor = $a
    .label res = $c
    .label i = 2
    lda #0
    sta i
  b1:
    ldy i
    lda dividends,y
    sta dividend
    lda dividends+1,y
    sta dividend+1
    lda divisors,y
    sta divisor
    lda divisors+1,y
    sta divisor+1
    lda dividend
    sta div16u.dividend
    lda dividend+1
    sta div16u.dividend+1
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
    lda #2
    clc
    adc i
    sta i
    cmp #$c
    bne b1
    rts
    str: .text " / @"
    str1: .text " = @"
    str2: .text " @"
    dividends: .word $ffff, $ffff, $ffff, $ffff, $ffff, $ffff
    divisors: .word 5, 7, $b, $d, $11, $13
}
test_8u: {
    .label dividend = 7
    .label divisor = $10
    .label res = $11
    .label i = 2
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
    lda i
    cmp #6
    bne b12
    rts
  b12:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b1
    str: .text " / @"
    str1: .text " = @"
    str2: .text " @"
    dividends: .byte $ff, $ff, $ff, $ff, $ff, $ff
    divisors: .byte 5, 7, $b, $d, $11, $13
}
print_cls: {
    .label sc = 3
    lda #<$400
    sta sc
    lda #>$400
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>$400+$3e8
    bne b1
    lda sc
    cmp #<$400+$3e8
    bne b1
    rts
}
