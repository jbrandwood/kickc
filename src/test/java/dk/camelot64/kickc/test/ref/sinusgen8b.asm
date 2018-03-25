.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const PI2_u4f28 = $6487ed51
  .const PI_u4f28 = $3243f6a9
  .const PI_HALF_u4f28 = $1921fb54
  .const PI2_u4f12 = $6488
  .const PI_u4f12 = $3244
  .const PI_HALF_u4f12 = $1922
  .label print_line_cursor = $400
  .label rem16u = 5
  .label print_char_cursor = 5
  jsr main
main: {
    .label wavelength = $c0
    .label _3 = 2
    .label _4 = 2
    .label _5 = 2
    .label sb = 4
    .label sw = $f
    .label sd = 4
    jsr sin8s_gen
    jsr sin16s_gen
    jsr print_cls
    lda #<print_line_cursor
    sta print_char_cursor
    lda #>print_line_cursor
    sta print_char_cursor+1
    ldx #0
  b1:
    lda sintabb,x
    sta sb
    txa
    sta _3
    lda #0
    sta _3+1
    asl _4
    rol _4+1
    clc
    lda _5
    adc #<sintabw
    sta _5
    lda _5+1
    adc #>sintabw
    sta _5+1
    ldy #0
    lda (_5),y
    sta sw
    iny
    lda (_5),y
    sta sw+1
    eor #$ff
    sec
    adc sd
    sta sd
    bmi b2
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
  b2:
    jsr print_sbyte
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    inx
    cpx #$c0
    bne b1
    rts
    str: .text "  @"
    str1: .text " @"
    sintabb: .fill $c0, 0
    sintabw: .fill $180, 0
}
print_str: {
    .label str = 2
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
print_sbyte: {
    .label b = 4
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
print_byte: {
    lda print_sbyte.b
    lsr
    lsr
    lsr
    lsr
    tay
    lda hextab,y
    jsr print_char
    lda #$f
    and print_sbyte.b
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
print_cls: {
    .label sc = 2
    lda #<print_line_cursor
    sta sc
    lda #>print_line_cursor
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
    cmp #>print_line_cursor+$3e8
    bne b1
    lda sc
    cmp #<print_line_cursor+$3e8
    bne b1
    rts
}
sin16s_gen: {
    .label _1 = $f
    .label step = $1c
    .label sintab = 2
    .label x = 7
    .label i = 5
    jsr div32u16u
    lda #<0
    sta i
    sta i+1
    lda #<main.sintabw
    sta sintab
    lda #>main.sintabw
    sta sintab+1
    lda #0
    sta x
    sta x+1
    sta x+2
    sta x+3
  b1:
    lda x
    sta sin16s.x
    lda x+1
    sta sin16s.x+1
    lda x+2
    sta sin16s.x+2
    lda x+3
    sta sin16s.x+3
    jsr sin16s
    ldy #0
    lda _1
    sta (sintab),y
    iny
    lda _1+1
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
    bcc b1
    bne !+
    lda i
    cmp #<main.wavelength
    bcc b1
  !:
    rts
}
sin16s: {
    .label _6 = $b
    .label x = $b
    .label return = $f
    .label x1 = $20
    .label x2 = $11
    .label x3 = $11
    .label x3_6 = $13
    .label usinx = $f
    .label x4 = $11
    .label x5 = $13
    .label x5_128 = $13
    .label sinx = $f
    .label isUpper = 4
    lda x+3
    cmp #>PI_u4f28>>$10
    bcc b4
    bne !+
    lda x+2
    cmp #<PI_u4f28>>$10
    bcc b4
    bne !+
    lda x+1
    cmp #>PI_u4f28
    bcc b4
    bne !+
    lda x
    cmp #<PI_u4f28
    bcc b4
  !:
    lda x
    sec
    sbc #<PI_u4f28
    sta x
    lda x+1
    sbc #>PI_u4f28
    sta x+1
    lda x+2
    sbc #<PI_u4f28>>$10
    sta x+2
    lda x+3
    sbc #>PI_u4f28>>$10
    sta x+3
    lda #1
    sta isUpper
    jmp b1
  b4:
    lda #0
    sta isUpper
  b1:
    lda x+3
    cmp #>PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda x+2
    cmp #<PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda x+1
    cmp #>PI_HALF_u4f28
    bcc b2
    bne !+
    lda x
    cmp #<PI_HALF_u4f28
    bcc b2
  !:
    lda #<PI_u4f28
    sec
    sbc x
    sta x
    lda #>PI_u4f28
    sbc x+1
    sta x+1
    lda #<PI_u4f28>>$10
    sbc x+2
    sta x+2
    lda #>PI_u4f28>>$10
    sbc x+3
    sta x+3
  b2:
    ldy #3
  !:
    asl _6
    rol _6+1
    rol _6+2
    rol _6+3
    dey
    bne !-
    lda _6+2
    sta x1
    lda _6+3
    sta x1+1
    lda x1
    sta mulu16_sel.v1
    lda x1+1
    sta mulu16_sel.v1+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda mulu16_sel.return
    sta x2
    lda mulu16_sel.return+1
    sta x2+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    lda mulu16_sel.return
    sta mulu16_sel.return_1
    lda mulu16_sel.return+1
    sta mulu16_sel.return_1+1
    ldx #1
    lda #<$10000/6
    sta mulu16_sel.v2
    lda #>$10000/6
    sta mulu16_sel.v2+1
    jsr mulu16_sel
    lda x1
    sec
    sbc x3_6
    sta usinx
    lda x1+1
    sbc x3_6+1
    sta usinx+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda mulu16_sel.return
    sta mulu16_sel.return_10
    lda mulu16_sel.return+1
    sta mulu16_sel.return_10+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    ldy #4
  !:
    lsr x5_128+1
    ror x5_128
    dey
    bne !-
    lda usinx
    clc
    adc x5_128
    sta usinx
    lda usinx+1
    adc x5_128+1
    sta usinx+1
    lda isUpper
    beq b3
    sec
    lda sinx
    eor #$ff
    adc #0
    sta sinx
    lda sinx+1
    eor #$ff
    adc #0
    sta sinx+1
  b3:
    rts
}
mulu16_sel: {
    .label _0 = $b
    .label _1 = $b
    .label v1 = $11
    .label v2 = $13
    .label return = $13
    .label return_1 = $11
    .label return_10 = $11
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
    sta return
    lda _1+3
    sta return+1
    rts
}
mul16u: {
    .label mb = $17
    .label a = $15
    .label res = $b
    .label b = $13
    .label return = $b
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
    .label quotient_hi = $13
    .label quotient_lo = $11
    .label return = $1c
    lda #<main.wavelength
    sta divr16u.divisor
    lda #>main.wavelength
    sta divr16u.divisor+1
    lda #<PI2_u4f28>>$10
    sta divr16u.dividend
    lda #>PI2_u4f28>>$10
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
    .label rem = 5
    .label dividend = $f
    .label quotient = $11
    .label return = $11
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
sin8s_gen: {
    .label step = $11
    .label sintab = 5
    .label x = 2
    .label i = $f
    jsr div16u
    lda #<0
    sta i
    sta i+1
    lda #<main.sintabb
    sta sintab
    lda #>main.sintabb
    sta sintab+1
    lda #<0
    sta x
    sta x+1
  b1:
    lda x
    sta sin8s.x
    lda x+1
    sta sin8s.x+1
    jsr sin8s
    ldy #0
    sta (sintab),y
    inc sintab
    bne !+
    inc sintab+1
  !:
    lda x
    clc
    adc step
    sta x
    lda x+1
    adc step+1
    sta x+1
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>main.wavelength
    bcc b1
    bne !+
    lda i
    cmp #<main.wavelength
    bcc b1
  !:
    rts
}
sin8s: {
    .const DIV_6 = $2b
    .label _6 = $13
    .label x = $13
    .label x1 = $22
    .label x3 = $23
    .label usinx = $24
    .label isUpper = 4
    lda x+1
    cmp #>PI_u4f12
    bcc b5
    bne !+
    lda x
    cmp #<PI_u4f12
    bcc b5
  !:
    lda x
    sec
    sbc #<PI_u4f12
    sta x
    lda x+1
    sbc #>PI_u4f12
    sta x+1
    lda #1
    sta isUpper
    jmp b1
  b5:
    lda #0
    sta isUpper
  b1:
    lda x+1
    cmp #>PI_HALF_u4f12
    bcc b2
    bne !+
    lda x
    cmp #<PI_HALF_u4f12
    bcc b2
  !:
    sec
    lda #<PI_u4f12
    sbc x
    sta x
    lda #>PI_u4f12
    sbc x+1
    sta x+1
  b2:
    asl _6
    rol _6+1
    asl _6
    rol _6+1
    asl _6
    rol _6+1
    lda _6+1
    sta x1
    tax
    tay
    lda #0
    sta mulu8_sel.select
    jsr mulu8_sel
    tax
    ldy x1
    lda #1
    sta mulu8_sel.select
    jsr mulu8_sel
    sta x3
    tax
    lda #1
    sta mulu8_sel.select
    ldy #DIV_6
    jsr mulu8_sel
    eor #$ff
    sec
    adc x1
    sta usinx
    ldx x3
    ldy x1
    lda #0
    sta mulu8_sel.select
    jsr mulu8_sel
    tax
    ldy x1
    lda #0
    sta mulu8_sel.select
    jsr mulu8_sel
    lsr
    lsr
    lsr
    lsr
    clc
    adc usinx
    tax
    cpx #$80
    bcc b3
    dex
  b3:
    lda isUpper
    beq b18
    txa
    eor #$ff
    clc
    adc #1
  b4:
    rts
  b18:
    txa
    jmp b4
}
mulu8_sel: {
    .label _0 = $13
    .label _1 = $13
    .label select = $1b
    tya
    jsr mul8u
    ldy select
    beq !e+
  !:
    asl _1
    rol _1+1
    dey
    bne !-
  !e:
    lda _1+1
    rts
}
mul8u: {
    .label mb = $15
    .label res = $13
    .label return = $13
    sta mb
    lda #0
    sta mb+1
    sta res
    sta res+1
  b1:
    cpx #0
    bne b2
    rts
  b2:
    txa
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
  b4:
    txa
    lsr
    tax
    asl mb
    rol mb+1
    jmp b1
}
div16u: {
    .label return = $11
    lda #<main.wavelength
    sta divr16u.divisor
    lda #>main.wavelength
    sta divr16u.divisor+1
    lda #<PI2_u4f12
    sta divr16u.dividend
    lda #>PI2_u4f12
    sta divr16u.dividend+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    rts
}
