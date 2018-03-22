.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const PI2_u4f28 = $6487ed51
  .const PI_u4f28 = $3243f6a9
  .const PI_HALF_u4f28 = $1921fb54
  .const PI_u4f12 = $3244
  .const PI_HALF_u4f12 = $1922
  .label SCREEN = $400
  .label char_cursor = $b
  .label rem16u = 4
  jsr main
main: {
    .label wavelength = $78
    .label sw = 8
    .label st1 = 2
    .label st2 = 4
    jsr sin16s_gen
    jsr sin16s_genb
    jsr print_cls
    ldx #0
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    lda #<sintab2
    sta st2
    lda #>sintab2
    sta st2+1
    lda #<sintab1
    sta st1
    lda #>sintab1
    sta st1+1
  b1:
    ldy #0
    sec
    lda (st1),y
    sbc (st2),y
    sta sw
    iny
    lda (st1),y
    sbc (st2),y
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
    clc
    lda st2
    adc #<2
    sta st2
    lda st2+1
    adc #>2
    sta st2+1
    inx
    cpx #$78
    bne b1
    rts
    str: .text "   @"
    str1: .text " @"
    sintab1: .fill $f0, 0
    sintab2: .fill $f0, 0
}
print_str: {
    .label str = 6
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
    .label w = 8
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
    sta print_byte.b
    jsr print_byte
    lda print_sword.w
    sta print_byte.b
    jsr print_byte
    rts
}
print_byte: {
    .label b = $a
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
sin16s_genb: {
    .label _2 = 8
    .label step = $1d
    .label sintab = 2
    .label x = $d
    .label i = 4
    lda #<main.wavelength
    sta div32u16u.divisor
    lda #>main.wavelength
    sta div32u16u.divisor+1
    lda #<PI2_u4f28
    sta div32u16u.dividend
    lda #>PI2_u4f28
    sta div32u16u.dividend+1
    lda #<PI2_u4f28>>$10
    sta div32u16u.dividend+2
    lda #>PI2_u4f28>>$10
    sta div32u16u.dividend+3
    jsr div32u16u
    lda #<0
    sta i
    sta i+1
    lda #<main.sintab2
    sta sintab
    lda #>main.sintab2
    sta sintab+1
    lda #0
    sta x
    sta x+1
    sta x+2
    sta x+3
  b1:
    lda x+2
    sta sin16sb.x
    lda x+3
    sta sin16sb.x+1
    jsr sin16sb
    ldy #0
    lda _2
    sta (sintab),y
    iny
    lda _2+1
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
sin16sb: {
    .label x = 6
    .label return = 8
    .label x1 = 6
    .label x2 = $b
    .label x3 = $b
    .label x3_6 = $11
    .label usinx = 8
    .label x4 = $b
    .label x5 = $11
    .label x5_128 = $11
    .label sinx = 8
    .label isUpper = $a
    lda x+1
    cmp #>PI_u4f12
    bcc b4
    bne !+
    lda x
    cmp #<PI_u4f12
    bcc b4
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
  b4:
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
    asl x1
    rol x1+1
    asl x1
    rol x1+1
    asl x1
    rol x1+1
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
    lda mulu16_sel.return_18
    sta x2
    lda mulu16_sel.return_18+1
    sta x2+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    lda mulu16_sel.return_17
    sta mulu16_sel.return
    lda mulu16_sel.return_17+1
    sta mulu16_sel.return+1
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
    lda mulu16_sel.return_17
    sta mulu16_sel.return
    lda mulu16_sel.return_17+1
    sta mulu16_sel.return+1
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
    .label _0 = $15
    .label _1 = $15
    .label v1 = $b
    .label v2 = $11
    .label return = $b
    .label return_11 = $11
    .label return_14 = $11
    .label return_16 = $11
    .label return_17 = $11
    .label return_18 = $11
    .label return_20 = $11
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
    sta return_17
    lda _1+3
    sta return_17+1
    rts
}
mul16u: {
    .label mb = $19
    .label a = $13
    .label res = $15
    .label b = $11
    .label return = $15
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
    .label quotient_hi = $b
    .label quotient_lo = 8
    .label return = $1d
    .label dividend = $d
    .label divisor = 2
    lda dividend+2
    sta divr16u.dividend
    lda dividend+3
    sta divr16u.dividend+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    lda divr16u.return
    sta quotient_hi
    lda divr16u.return+1
    sta quotient_hi+1
    lda dividend
    sta divr16u.dividend
    lda dividend+1
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
sin16s_gen: {
    .label _1 = 8
    .label step = $1d
    .label sintab = 2
    .label x = $d
    .label i = 6
    lda #<0
    sta rem16u
    sta rem16u+1
    lda #<main.wavelength
    sta div32u16u.divisor
    lda #>main.wavelength
    sta div32u16u.divisor+1
    lda #<PI2_u4f28
    sta div32u16u.dividend
    lda #>PI2_u4f28
    sta div32u16u.dividend+1
    lda #<PI2_u4f28>>$10
    sta div32u16u.dividend+2
    lda #>PI2_u4f28>>$10
    sta div32u16u.dividend+3
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
    .label _6 = $15
    .label x = $15
    .label return = 8
    .label x1 = $21
    .label x2 = $b
    .label x3 = $b
    .label x3_6 = $11
    .label usinx = 8
    .label x4 = $b
    .label x5 = $11
    .label x5_128 = $11
    .label sinx = 8
    .label isUpper = $a
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
    lda mulu16_sel.return_17
    sta mulu16_sel.return
    lda mulu16_sel.return_17+1
    sta mulu16_sel.return+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    lda mulu16_sel.return_17
    sta mulu16_sel.return
    lda mulu16_sel.return_17+1
    sta mulu16_sel.return+1
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
    lda mulu16_sel.return_17
    sta mulu16_sel.return
    lda mulu16_sel.return_17+1
    sta mulu16_sel.return+1
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