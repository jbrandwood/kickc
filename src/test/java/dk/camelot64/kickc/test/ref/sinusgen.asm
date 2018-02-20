.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const PI2_u4f12 = $6488
  .const PI_u4f12 = $3244
  .const PI_HALF_u4f12 = $1922
  .label rem16u = 8
  .label char_cursor = $12
  .label line_cursor = $e
  jsr main
main: {
    sei
    jsr print_cls
    jsr sin16s_gen
    cli
    rts
    sintab: .fill $28, 0
}
sin16s_gen: {
    .const wavelength = $14
    .const div6 = $10000/6
    .const div128 = $10000/$80
    .label _15 = $14
    .label _17 = $14
    .label _19 = $c
    .label stepi = $e
    .label stepf = $c
    .label step = $1c
    .label x1 = $a
    .label x2 = $10
    .label x3 = $20
    .label x4 = $10
    .label x5 = $22
    .label x3_6 = $20
    .label x5_128 = $22
    .label usinx = $c
    .label sintab = 6
    .label x = 2
    .label i = 8
    .label sinx = $c
    lda #<wavelength
    sta divr16u.divisor
    lda #>wavelength
    sta divr16u.divisor+1
    lda #<PI2_u4f12
    sta divr16u.dividend
    lda #>PI2_u4f12
    sta divr16u.dividend+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    lda divr16u.return
    sta stepi
    lda divr16u.return+1
    sta stepi+1
    lda #<wavelength
    sta divr16u.divisor
    lda #>wavelength
    sta divr16u.divisor+1
    lda #<0
    sta divr16u.dividend
    sta divr16u.dividend+1
    jsr divr16u
    lda stepi
    sta step+2
    lda stepi+1
    sta step+3
    lda stepf
    sta step
    lda stepf+1
    sta step+1
    lda #<SCREEN
    sta line_cursor
    lda #>SCREEN
    sta line_cursor+1
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    lda #<0
    sta i
    sta i+1
    lda #<main.sintab
    sta sintab
    lda #>main.sintab
    sta sintab+1
    lda #0
    sta x
    sta x+1
    sta x+2
    sta x+3
  b1:
    lda x+2
    sta x1
    lda x+3
    sta x1+1
    cmp #>PI_u4f12
    bcc b5
    bne !+
    lda x1
    cmp #<PI_u4f12
    bcc b5
  !:
    lda x1
    sec
    sbc #<PI_u4f12
    sta x1
    lda x1+1
    sbc #>PI_u4f12
    sta x1+1
    ldx #1
    jmp b2
  b5:
    ldx #0
  b2:
    lda x1+1
    cmp #>PI_HALF_u4f12
    bcc b3
    bne !+
    lda x1
    cmp #<PI_HALF_u4f12
    bcc b3
  !:
    sec
    lda #<PI_u4f12
    sbc x1
    sta x1
    lda #>PI_u4f12
    sbc x1+1
    sta x1+1
  b3:
    lda x1
    sta mul_u4f12.v1
    lda x1+1
    sta mul_u4f12.v1+1
    jsr mul_u4f12
    jsr mul_u4f12
    lda mul_u4f12.return
    sta x3
    lda mul_u4f12.return+1
    sta x3+1
    lda x3
    sta mul_u4f12.v1
    lda x3+1
    sta mul_u4f12.v1+1
    jsr mul_u4f12
    jsr mul_u4f12
    lda mul_u4f12.return
    sta x5
    lda mul_u4f12.return+1
    sta x5+1
    lda x3
    sta mul16u.a
    lda x3+1
    sta mul16u.a+1
    lda #<div6
    sta mul16u.b
    lda #>div6
    sta mul16u.b+1
    jsr mul16u
    lda _15+2
    sta x3_6
    lda _15+3
    sta x3_6+1
    lda x5
    sta mul16u.a
    lda x5+1
    sta mul16u.a+1
    lda #<div128
    sta mul16u.b
    lda #>div128
    sta mul16u.b+1
    jsr mul16u
    lda _17+2
    sta x5_128
    lda _17+3
    sta x5_128+1
    lda x1
    sec
    sbc x3_6
    sta _19
    lda x1+1
    sbc x3_6+1
    sta _19+1
    lda usinx
    clc
    adc x5_128
    sta usinx
    lda usinx+1
    adc x5_128+1
    sta usinx+1
    cpx #0
    beq b4
    sec
    lda sinx
    eor #$ff
    adc #0
    sta sinx
    lda sinx+1
    eor #$ff
    adc #0
    sta sinx+1
  b4:
    ldy #0
    lda sinx
    sta (sintab),y
    iny
    lda sinx+1
    sta (sintab),y
    clc
    lda sintab
    adc #<2
    sta sintab
    lda sintab+1
    adc #>2
    sta sintab+1
    lda i
    sta print_word.w
    lda i+1
    sta print_word.w+1
    jsr print_word
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_dword
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda x1
    sta print_word.w
    lda x1+1
    sta print_word.w+1
    jsr print_word
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda x3_6
    sta print_word.w
    lda x3_6+1
    sta print_word.w+1
    jsr print_word
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    lda x5_128
    sta print_word.w
    lda x5_128+1
    sta print_word.w+1
    jsr print_word
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    jsr print_sword
    jsr print_ln
    lda x
    clc
    adc step
    sta x
    lda x+1
    adc step+1
    sta x+1
    lda x+2
    adc step+2
    sta x+2
    lda x+3
    adc step+3
    sta x+3
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>wavelength
    bcc b29
    bne !+
    lda i
    cmp #<wavelength
    bcc b29
  !:
    rts
  b29:
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp b1
    str: .text " @"
    str1: .text " @"
    str2: .text " @"
    str3: .text " @"
    str4: .text " @"
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
print_sword: {
    .label w = $c
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
    lda w
    sta print_word.w
    lda w+1
    sta print_word.w+1
    jsr print_word
    rts
}
print_word: {
    .label w = $10
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
    .label str = $10
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
print_dword: {
    .label dw = 2
    lda dw+2
    sta print_word.w
    lda dw+3
    sta print_word.w+1
    jsr print_word
    lda dw
    sta print_word.w
    lda dw+1
    sta print_word.w+1
    jsr print_word
    rts
}
mul16u: {
    .label mb = $18
    .label a = $10
    .label res = $14
    .label return = $14
    .label b = $c
    lda b
    sta mb
    lda b+1
    sta mb+1
    lda #0
    sta mb+2
    sta mb+3
    sta res
    sta res+1
    sta res+2
    sta res+3
  b1:
    lda a
    bne b2
    lda a+1
    bne b2
    rts
  b2:
    lda a
    and #1
    cmp #0
    beq b4
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
    lda res+2
    adc mb+2
    sta res+2
    lda res+3
    adc mb+3
    sta res+3
  b4:
    clc
    ror a+1
    ror a
    asl mb
    rol mb+1
    rol mb+2
    rol mb+3
    jmp b1
}
mul_u4f12: {
    .label _0 = $14
    .label _1 = $14
    .label v1 = $10
    .label v2 = $a
    .label return = $10
    lda v2
    sta mul16u.b
    lda v2+1
    sta mul16u.b+1
    jsr mul16u
    asl _1
    rol _1+1
    rol _1+2
    rol _1+3
    asl _1
    rol _1+1
    rol _1+2
    rol _1+3
    asl _1
    rol _1+1
    rol _1+2
    rol _1+3
    asl _1
    rol _1+1
    rol _1+2
    rol _1+3
    lda _1+2
    sta return
    lda _1+3
    sta return+1
    rts
}
divr16u: {
    .label rem = 8
    .label dividend = $a
    .label quotient = $c
    .label return = $c
    .label divisor = 6
    ldx #0
    txa
    sta quotient
    sta quotient+1
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
print_cls: {
    .label sc = 6
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
