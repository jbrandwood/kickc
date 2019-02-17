//  Generates a 16-bit signed sinus
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  //  PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  //  PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  //  PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  //  PI in u[4.12] format
  .const PI_u4f12 = $3244
  //  PI/2 in u[4.12] format
  .const PI_HALF_u4f12 = $1922
  .label print_line_cursor = $400
  .label rem16u = 2
  .label print_char_cursor = $b
main: {
    .label wavelength = $78
    .label sw = 8
    .label st1 = 2
    .label st2 = 4
    jsr sin16s_gen
    jsr sin16s_genb
    jsr print_cls
    ldx #0
    lda #<print_line_cursor
    sta print_char_cursor
    lda #>print_line_cursor
    sta print_char_cursor+1
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
    lda st1
    clc
    adc #2
    sta st1
    bcc !+
    inc st1+1
  !:
    lda st2
    clc
    adc #2
    sta st2
    bcc !+
    inc st2+1
  !:
    inx
    cpx #$78
    bne b1
    rts
    str: .text "   @"
    str1: .text " @"
    sintab1: .fill 2*$78, 0
    sintab2: .fill 2*$78, 0
}
//  Print a zero-terminated string
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
//  Print a signed word as HEX
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
//  Print a word as HEX
print_word: {
    lda print_sword.w+1
    sta print_byte.b
    jsr print_byte
    lda print_sword.w
    sta print_byte.b
    jsr print_byte
    rts
}
//  Print a byte as HEX
print_byte: {
    .label b = $a
    lda b
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    and b
    tay
    lda print_hextab,y
    jsr print_char
    rts
}
//  Print a single char
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
//  Clear the screen. Also resets current line/char cursor.
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
//  Generate signed (large) word sinus table - on the full -$7fff - $7fff range
//  sintab - the table to generate into
//  wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
sin16s_genb: {
    .label _2 = 8
    .label step = $1d
    .label sintab = 2
    .label x = $d
    .label i = 4
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
  //  u[4.28]
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
    lda sintab
    clc
    adc #2
    sta sintab
    bcc !+
    inc sintab+1
  !:
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
//  Calculate signed word sinus sin(x)
//  x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
//  result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
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
    cmp #0
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
//  Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
//  The select parameter indicates how many of the highest bits of the 32-bit result to skip
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
//  Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
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
//  Divide unsigned 32-bit dword dividend with a 16-bit word divisor
//  The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = 8
    .label quotient_lo = 6
    .label return = $1d
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
//  Performs division on two 16 bit unsigned words and an initial remainder
//  Returns the quotient dividend/divisor.
//  The final remainder will be set into the global variable rem16u
//  Implemented using simple binary division
divr16u: {
    .label rem = 2
    .label dividend = 4
    .label quotient = 6
    .label return = 6
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
//  Generate signed (large) word sinus table - on the full -$7fff - $7fff range
//  sintab - the table to generate into
//  wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
sin16s_gen: {
    .label _1 = 6
    .label step = $1d
    .label sintab = 2
    .label x = $d
    .label i = 4
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
  //  u[4.28]
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
    lda sintab
    clc
    adc #2
    sta sintab
    bcc !+
    inc sintab+1
  !:
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
//  Calculate signed word sinus sin(x)
//  x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
//  result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
sin16s: {
    .label _6 = $15
    .label x = $15
    .label return = 6
    .label x1 = 8
    .label x2 = $b
    .label x3 = $b
    .label x3_6 = $11
    .label usinx = 6
    .label x4 = $b
    .label x5 = $11
    .label x5_128 = $11
    .label sinx = 6
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
    cmp #0
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
  print_hextab: .text "0123456789abcdef"
