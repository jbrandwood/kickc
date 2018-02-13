.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label char_cursor = 6
  .label line_cursor = 3
  jsr main
main: {
    jsr print_cls
    jsr test_8s
    jsr test_8u
    rts
}
test_8u: {
    .label rem = $e
    .label dividend = 5
    .label divisor = $a
    .label i = 2
    lda #0
    sta rem
    sta i
  b1:
    ldy i
    lda dividends,y
    sta dividend
    lda divisors,y
    sta divisor
    lda dividend
    sta div8u.dividend
    lda #<rem
    sta div8u.remainder
    lda #>rem
    sta div8u.remainder+1
    jsr div8u
    lda div8u.return
    tax
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
    stx print_byte.b
    jsr print_byte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda rem
    sta print_byte.b
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
print_byte: {
    .label b = 5
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
    .label str = 8
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
div8u: {
    .label dividend = $b
    .label quotient = $c
    .label return = $c
    .label divisor = $a
    .label remainder = 8
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
    ldy #0
    sta (remainder),y
    rts
}
test_8s: {
    .label dividend = 5
    .label divisor = $f
    .label res = $a
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
    stx print_sbyte.b
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
    .label b = 5
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
    .label neg = $d
    .label rem8u = $10
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
    lda #0
    sta rem8u
    sty div8u.dividend
    stx div8u.divisor
    lda #<rem8u
    sta div8u.remainder
    lda #>rem8u
    sta div8u.remainder+1
    jsr div8u
    lda div8u.return
    tay
    lda neg
    bne b5
    tya
    ldx rem8u
  breturn:
    rts
  b5:
    lda rem8u
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
