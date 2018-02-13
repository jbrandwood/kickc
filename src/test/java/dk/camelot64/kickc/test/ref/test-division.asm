.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label char_cursor = 7
  .label line_cursor = 3
  .label rem16u = $b
  jsr main
main: {
    jsr print_cls
    jsr test_8u
    jsr test_16u
    rts
}
test_16u: {
    .label dividend = 5
    .label divisor = $16
    .label res = $f
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
    beq !b+
    jmp b1
  !b:
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
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
    rts
}
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda hextab,y
    jsr print_char
    txa
    and #$f
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
    .label str = 9
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
    .label rem = $b
    .label dividend = $d
    .label quotient = $f
    .label return = $f
    .label divisor = $16
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
    .label rem = $18
    .label dividend = $19
    .label divisor = $1a
    .label res = $1b
    .label i = $11
    lda #0
    sta rem
    lda #<$400
    sta line_cursor
    lda #>$400
    sta line_cursor+1
    lda #<$400
    sta char_cursor
    lda #>$400
    sta char_cursor+1
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
    ldx dividend
    jsr print_byte
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    ldx divisor
    jsr print_byte
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    ldx res
    jsr print_byte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    ldx rem
    jsr print_byte
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
    dividends: .byte $ff, $ff, $ff, $ff, $ff, $ff
    divisors: .byte 5, 7, $b, $d, $11, $13
}
div8u: {
    .label remainder = test_8u.rem
    .label dividend = $12
    .label quotient = $13
    .label return = $13
    .label divisor = $1a
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
    sty remainder
    rts
}
print_cls: {
    .label sc = $14
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
