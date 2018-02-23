.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const PI2_u4f28 = $6487ed51
  .const PI_u4f28 = $3243f6a9
  .const PI_HALF_u4f28 = $1921fb54
  .label rem16u = 4
  .label char_cursor = 8
  jsr main
main: {
    .label wavelength = $78
    .label sw = 6
    .label st1 = 2
    jsr sin16s_gen
    jsr print_cls
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    lda #<sintab1
    sta st1
    lda #>sintab1
    sta st1+1
  b1:
    ldy #0
    lda (st1),y
    sta sw
    iny
    lda (st1),y
    sta sw+1
    bmi b2
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
  b2:
    jsr print_sword
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    clc
    lda st1
    adc #<2
    sta st1
    lda st1+1
    adc #>2
    sta st1+1
    cmp #>sintab1+wavelength*2
    bcc b1
    bne !+
    lda st1
    cmp #<sintab1+wavelength*2
    bcc b1
  !:
    rts
    str: .text "   @"
    str1: .text " @"
    sintab1: .fill $f0, 0
}
print_str: {
    .label str = 4
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
print_sword: {
    .label w = 6
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
    lda print_sword.w+1
    tax
    jsr print_byte
    lda print_sword.w
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
print_cls: {
    .label sc = 2
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
sin16s_gen: {
    .label _7 = $e
    .label step = $1a
    .label xp = $e
    .label x1 = $1e
    .label x2 = 8
    .label x3 = 8
    .label x3_6 = 6
    .label usinx = 6
    .label x4 = 8
    .label x5 = 8
    .label x5_128 = $12
    .label sintab = 2
    .label x = $a
    .label i = 4
    .label sinx = 6
    jsr div32u16u
    lda #<0
    sta i
    sta i+1
    lda #<main.sintab1
    sta sintab
    lda #>main.sintab1
    sta sintab+1
    lda #0
    sta x
    sta x+1
    sta x+2
    sta x+3
  b1:
    lda x+3
    cmp #>PI_u4f28>>$10
    bcs !b17+
    jmp b17
  !b17:
    bne !+
    lda x+2
    cmp #<PI_u4f28>>$10
    bcs !b17+
    jmp b17
  !b17:
    bne !+
    lda x+1
    cmp #>PI_u4f28
    bcs !b17+
    jmp b17
  !b17:
    bne !+
    lda x
    cmp #<PI_u4f28
    bcs !b17+
    jmp b17
  !b17:
  !:
    lda x
    sec
    sbc #<PI_u4f28
    sta xp
    lda x+1
    sbc #>PI_u4f28
    sta xp+1
    lda x+2
    sbc #<PI_u4f28>>$10
    sta xp+2
    lda x+3
    sbc #>PI_u4f28>>$10
    sta xp+3
    ldy #1
  b2:
    lda xp+3
    cmp #>PI_HALF_u4f28>>$10
    bcc b3
    bne !+
    lda xp+2
    cmp #<PI_HALF_u4f28>>$10
    bcc b3
    bne !+
    lda xp+1
    cmp #>PI_HALF_u4f28
    bcc b3
    bne !+
    lda xp
    cmp #<PI_HALF_u4f28
    bcc b3
  !:
    lda #<PI_u4f28
    sec
    sbc xp
    sta xp
    lda #>PI_u4f28
    sbc xp+1
    sta xp+1
    lda #<PI_u4f28>>$10
    sbc xp+2
    sta xp+2
    lda #>PI_u4f28>>$10
    sbc xp+3
    sta xp+3
  b3:
    ldx #3
  !:
    asl _7
    rol _7+1
    rol _7+2
    rol _7+3
    dex
    bne !-
    lda _7+2
    sta x1
    lda _7+3
    sta x1+1
    lda x1
    sta mul_u16_sel.v1
    lda x1+1
    sta mul_u16_sel.v1+1
    lda x1
    sta mul_u16_sel.v2
    lda x1+1
    sta mul_u16_sel.v2+1
    ldx #0
    jsr mul_u16_sel
    lda mul_u16_sel.return_14
    sta mul_u16_sel.return
    lda mul_u16_sel.return_14+1
    sta mul_u16_sel.return+1
    lda x1
    sta mul_u16_sel.v2
    lda x1+1
    sta mul_u16_sel.v2+1
    ldx #1
    jsr mul_u16_sel
    lda mul_u16_sel.return_14
    sta mul_u16_sel.return
    lda mul_u16_sel.return_14+1
    sta mul_u16_sel.return+1
    ldx #1
    lda #<$10000/6
    sta mul_u16_sel.v2
    lda #>$10000/6
    sta mul_u16_sel.v2+1
    jsr mul_u16_sel
    lda mul_u16_sel.return_14
    sta mul_u16_sel.return_10
    lda mul_u16_sel.return_14+1
    sta mul_u16_sel.return_10+1
    lda x1
    sec
    sbc usinx
    sta usinx
    lda x1+1
    sbc usinx+1
    sta usinx+1
    lda x1
    sta mul_u16_sel.v2
    lda x1+1
    sta mul_u16_sel.v2+1
    ldx #0
    jsr mul_u16_sel
    lda mul_u16_sel.return_14
    sta mul_u16_sel.return
    lda mul_u16_sel.return_14+1
    sta mul_u16_sel.return+1
    lda x1
    sta mul_u16_sel.v2
    lda x1+1
    sta mul_u16_sel.v2+1
    ldx #0
    jsr mul_u16_sel
    lda mul_u16_sel.return_14
    sta mul_u16_sel.return
    lda mul_u16_sel.return_14+1
    sta mul_u16_sel.return+1
    ldx #3
    lda #<$10000/$80
    sta mul_u16_sel.v2
    lda #>$10000/$80
    sta mul_u16_sel.v2+1
    jsr mul_u16_sel
    lda usinx
    clc
    adc x5_128
    sta usinx
    lda usinx+1
    adc x5_128+1
    sta usinx+1
    cpy #0
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
    cmp #>main.wavelength
    bcs !b1+
    jmp b1
  !b1:
    bne !+
    lda i
    cmp #<main.wavelength
    bcs !b1+
    jmp b1
  !b1:
  !:
    rts
  b17:
    lda x
    sta xp
    lda x+1
    sta xp+1
    lda x+2
    sta xp+2
    lda x+3
    sta xp+3
    ldy #0
    jmp b2
}
mul_u16_sel: {
    .label _0 = $e
    .label _1 = $e
    .label v1 = 8
    .label v2 = $12
    .label return = 8
    .label return_10 = 6
    .label return_13 = $12
    .label return_14 = $12
    lda v1
    sta mul16u.a
    lda v1+1
    sta mul16u.a+1
    jsr mul16u
    cpx #0
    beq !e+
  !:
    asl _1
    rol _1+1
    rol _1+2
    rol _1+3
    dex
    bne !-
  !e:
    lda _1+2
    sta return_14
    lda _1+3
    sta return_14+1
    rts
}
mul16u: {
    .label mb = $16
    .label a = $14
    .label res = $e
    .label b = $12
    .label return = $e
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
div32u16u: {
    .label return = $1a
    .label quotient_hi = $12
    .label quotient_lo = 8
    lda #<main.wavelength
    sta divr16u.divisor
    lda #>main.wavelength
    sta divr16u.divisor+1
    lda #<PI2_u4f28>>16
    sta divr16u.dividend
    lda #>PI2_u4f28>>16
    sta divr16u.dividend+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    lda divr16u.return
    sta quotient_hi
    lda divr16u.return+1
    sta quotient_hi+1
    lda #<main.wavelength
    sta divr16u.divisor
    lda #>main.wavelength
    sta divr16u.divisor+1
    lda #<PI2_u4f28&$ffff
    sta divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta divr16u.dividend+1
    jsr divr16u
    lda quotient_hi
    sta return+2
    lda quotient_hi+1
    sta return+3
    lda quotient_lo
    sta return
    lda quotient_lo+1
    sta return+1
    rts
}
divr16u: {
    .label rem = 4
    .label dividend = 6
    .label quotient = 8
    .label return = 8
    .label divisor = 2
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
