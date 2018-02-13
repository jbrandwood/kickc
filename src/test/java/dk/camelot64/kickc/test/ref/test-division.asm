.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label char_cursor = 8
  .label line_cursor = 3
  .label rem8s = $e
  .label rem16u = $a
  jsr main
main: {
    jsr print_cls
    jsr test_8s
    jsr test_8u
    jsr test_16u
    rts
}
test_16u: {
    .label dividend = 5
    .label divisor = $12
    .label res = $c
    .label i = 2
    lda #0
    sta rem16u
    sta rem16u+1
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
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
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
    lda div16u.rem
    sta print_word.w
    lda div16u.rem+1
    sta print_word.w+1
    jsr print_word
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
    dividends: .word $ffff, $ffff, $ffff, $ffff, $ffff, $ffff
    divisors: .word 5, 7, $b, $d, $11, $13
}
print_ln: {
  b1:
    lda line_cursor
    clc
    adc #$28
    sta line_cursor
    bcc !+
    inc line_cursor+1
  !:
    lda line_cursor+1
    cmp char_cursor+1
    bcc b1
    bne !+
    lda line_cursor
    cmp char_cursor
    bcc b1
  !:
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
    sta (char_cursor),y
    inc char_cursor
    bne !+
    inc char_cursor+1
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
    sta (char_cursor),y
    inc char_cursor
    bne !+
    inc char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
div16u: {
    .label rem = $a
    .label dividend = 8
    .label quotient = $c
    .label return = $c
    .label divisor = $12
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
    inc rem
    bne !+
    inc rem+1
  !:
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
test_8u: {
    .label dividend = 7
    .label divisor = $e
    .label res = $f
    .label i = 2
    lda #0
    sta i
  b1:
    ldy i
    lda dividends,y
    sta dividend
    lda divisors,y
    sta divisor
    lda dividend
    sta div8u.dividend
    jsr div8u
    lda div8u.return
    sta res
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
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
    bne b1
    rts
    str: .text " / @"
    str1: .text " = @"
    str2: .text " @"
    dividends: .byte $ff, $ff, $ff, $ff, $ff, $ff
    divisors: .byte 5, 7, $b, $d, $11, $13
}
div8u: {
    .label dividend = $f
    .label quotient = $10
    .label return = $10
    .label divisor = $e
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
    iny
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
test_8s: {
    .label dividend = 7
    .label divisor = $14
    .label res = $f
    .label i = 2
    lda #<SCREEN
    sta line_cursor
    lda #>SCREEN
    sta line_cursor+1
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    lda #0
    sta rem8s
    tax
    sta i
  b1:
    ldy i
    lda dividends,y
    sta dividend
    lda divisors,y
    sta divisor
    lda dividend
    ldx divisor
    jsr div8s
    sta res
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
    lda rem8s
    sta print_sbyte.b
    jsr print_sbyte
    jsr print_ln
    inc i
    lda i
    cmp #6
    bne b12
    rts
  b12:
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp b1
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
    .label neg = $11
    cmp #0
    bpl b16
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
    sty div8u.dividend
    stx div8u.divisor
    jsr div8u
    lda div8u.return
    tay
    lda neg
    bne b5
    tya
    stx rem8s
  breturn:
    rts
  b5:
    txa
    eor #$ff
    clc
    adc #1
    sta rem8s
    tya
    eor #$ff
    clc
    adc #1
    jmp breturn
  b16:
    tay
    lda #0
    sta neg
    jmp b2
}
print_cls: {
    .label sc = 3
    lda #<SCREEN
    sta sc
    lda #>SCREEN
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
    cmp #>SCREEN+$3e8
    bne b1
    lda sc
    cmp #<SCREEN+$3e8
    bne b1
    rts
}
