.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const PI2_u4f28 = $6487ed51
  .const PI_u4f12 = $3244
  .const PI_HALF_u4f12 = $1922
  .label rem16u = 4
  .label char_cursor = 6
  jsr main
main: {
    .label wavelength = $80
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
    sta print_sword.w
    iny
    lda (st1),y
    sta print_sword.w+1
    jsr print_sword
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
    str: .text " @"
    sintab1: .fill $100, 0
}
print_str: {
    .label str = 4
    lda #<main.str
    sta str
    lda #>main.str
    sta str+1
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
    .label w = 4
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
    .label _14 = $12
    .label _20 = $12
    .label stepi = $e
    .label stepf = $c
    .label step = $1a
    .label x1 = 6
    .label x2 = $10
    .label x3 = $1e
    .label usinx = $c
    .label x4 = $10
    .label x5 = $10
    .label sinx = $c
    .label sintab = 2
    .label x = 8
    .label i = 4
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
    sta stepi
    lda divr16u.return+1
    sta stepi+1
    lda #<main.wavelength
    sta divr16u.divisor
    lda #>main.wavelength
    sta divr16u.divisor+1
    lda #<PI2_u4f28&$ffff
    sta divr16u.dividend
    lda #>PI2_u4f28&$ffff
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
    lda x+2
    sta x1
    lda x+3
    sta x1+1
    cmp #>PI_u4f12
    bcc b4
    bne !+
    lda x1
    cmp #<PI_u4f12
    bcc b4
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
  b4:
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
    sta mul16u.a
    lda x3+1
    sta mul16u.a+1
    lda #<$10000/6
    sta mul16u.b
    lda #>$10000/6
    sta mul16u.b+1
    jsr mul16u
    lda x1
    sec
    sbc _14+2
    sta usinx
    lda x1+1
    sbc _14+3
    sta usinx+1
    lda x3
    sta mul_u4f12.v1
    lda x3+1
    sta mul_u4f12.v1+1
    jsr mul_u4f12
    jsr mul_u4f12
    lda #<$10000/$80
    sta mul16u.b
    lda #>$10000/$80
    sta mul16u.b+1
    jsr mul16u
    lda usinx
    clc
    adc _20+2
    sta usinx
    lda usinx+1
    adc _20+3
    sta usinx+1
    cpx #0
    beq b5
    sec
    lda sinx
    eor #$ff
    adc #0
    sta sinx
    lda sinx+1
    eor #$ff
    adc #0
    sta sinx+1
  b5:
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
}
mul16u: {
    .label mb = $16
    .label a = $10
    .label res = $12
    .label return = $12
    .label b = $e
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
    .label _0 = $12
    .label _1 = $12
    .label v1 = $10
    .label v2 = 6
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
    .label rem = 4
    .label dividend = 6
    .label quotient = $c
    .label return = $c
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
