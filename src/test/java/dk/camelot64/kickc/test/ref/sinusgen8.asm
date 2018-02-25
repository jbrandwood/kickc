.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const PI2_u4f12 = $6488
  .const PI_u4f12 = $3244
  .const PI_HALF_u4f12 = $1922
  .label SCREEN = $400
  .label char_cursor = 5
  jsr main
main: {
    .label wavelength = $78
    .label sb = 4
    jsr sin8s_gen
    jsr print_cls
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    ldx #0
  b1:
    lda sintab2,x
    sta sb
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
    cpx #$78
    bne b1
    rts
    str: .text "  @"
    str1: .text " @"
    sintab2: .fill $78, 0
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
sin8s_gen: {
    .label step = $e
    .label sintab = 5
    .label x = 2
    .label i = 7
    jsr div16u
    lda #<0
    sta i
    sta i+1
    lda #<main.sintab2
    sta sintab
    lda #>main.sintab2
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
    .label _6 = 9
    .label x = 9
    .label x1 = $10
    .label x3 = $11
    .label usinx = $12
    .label isUpper = 4
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
    ldy #$100/6
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
    lda isUpper
    beq b15
    txa
    eor #$ff
    clc
    adc #1
  b3:
    rts
  b15:
    txa
    jmp b3
}
mulu8_sel: {
    .label _0 = 9
    .label _1 = 9
    .label select = $b
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
    .label mb = $c
    .label res = 9
    .label return = 9
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
    .label return = $e
    jsr divr16u
    rts
}
divr16u: {
    .label rem = 2
    .label dividend = 5
    .label quotient = $e
    .label return = $e
    ldx #0
    txa
    sta quotient
    sta quotient+1
    lda #<PI2_u4f12
    sta dividend
    lda #>PI2_u4f12
    sta dividend+1
    txa
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
    cmp #>main.wavelength
    bcc b3
    bne !+
    lda rem
    cmp #<main.wavelength
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc #<main.wavelength
    sta rem
    lda rem+1
    sbc #>main.wavelength
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
