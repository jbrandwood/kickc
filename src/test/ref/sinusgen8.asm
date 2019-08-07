.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // PI*2 in u[4.12] format
  .const PI2_u4f12 = $6488
  // PI in u[4.12] format
  .const PI_u4f12 = $3244
  // PI/2 in u[4.12] format
  .const PI_HALF_u4f12 = $1922
  .label print_line_cursor = $400
  .label print_char_cursor = 2
main: {
    .label wavelength = $c0
    .label sb = 4
    jsr sin8s_gen
    jsr print_cls
    lda #<print_line_cursor
    sta.z print_char_cursor
    lda #>print_line_cursor
    sta.z print_char_cursor+1
    ldx #0
  b1:
    lda sintab2,x
    sec
    sbc sintabref,x
    sta.z sb
    bmi b2
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
  b2:
    jsr print_sbyte
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    inx
    cpx #$c0
    bne b1
    rts
    str: .text "  "
    .byte 0
    str1: .text " "
    .byte 0
    sintab2: .fill $c0, 0
    // .fill $c0, round(127.5*sin(i*2*PI/$c0))
    sintabref: .byte 0, 4, 8, $c, $11, $15, $19, $1d, $21, $25, $29, $2d, $31, $35, $38, $3c, $40, $43, $47, $4a, $4e, $51, $54, $57, $5a, $5d, $60, $63, $65, $68, $6a, $6c, $6e, $70, $72, $74, $76, $77, $79, $7a, $7b, $7c, $7d, $7e, $7e, $7f, $7f, $7f, $80, $7f, $7f, $7f, $7e, $7e, $7d, $7c, $7b, $7a, $79, $77, $76, $74, $72, $70, $6e, $6c, $6a, $68, $65, $63, $60, $5d, $5a, $57, $54, $51, $4e, $4a, $47, $43, $40, $3c, $38, $35, $31, $2d, $29, $25, $21, $1d, $19, $15, $11, $c, 8, 4, 0, $fc, $f8, $f4, $ef, $eb, $e7, $e3, $df, $db, $d7, $d3, $cf, $cb, $c8, $c4, $c0, $bd, $b9, $b6, $b2, $af, $ac, $a9, $a6, $a3, $a0, $9d, $9b, $98, $96, $94, $92, $90, $8e, $8c, $8a, $89, $87, $86, $85, $84, $83, $82, $82, $81, $81, $81, $81, $81, $81, $81, $82, $82, $83, $84, $85, $86, $87, $89, $8a, $8c, $8e, $90, $92, $94, $96, $98, $9b, $9d, $a0, $a3, $a6, $a9, $ac, $af, $b2, $b6, $b9, $bd, $c0, $c4, $c8, $cb, $cf, $d3, $d7, $db, $df, $e3, $e7, $eb, $ef, $f4, $f8, $fc
}
// Print a zero-terminated string
// print_str(byte* zeropage(6) str)
print_str: {
    .label str = 6
  b1:
    ldy #0
    lda (str),y
    cmp #0
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp b1
}
// Print a signed byte as HEX
// print_sbyte(signed byte zeropage(4) b)
print_sbyte: {
    .label b = 4
    lda.z b
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_byte
    rts
  b1:
    lda #'-'
    jsr print_char
    lda.z b
    eor #$ff
    clc
    adc #1
    sta.z b
    jmp b2
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage(4) b)
print_byte: {
    .label b = 4
    lda.z b
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    and.z b
    tay
    lda print_hextab,y
    jsr print_char
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_line_cursor
    .label end = str+num
    .label dst = 6
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    lda.z dst+1
    cmp #>end
    bne b2
    lda.z dst
    cmp #<end
    bne b2
    rts
}
// Generate signed byte sinus table - on the full -$7f - $7f range
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin8s_gen(signed byte* zeropage($c) sintab)
sin8s_gen: {
    .label step = $e
    .label sintab = $c
    .label x = $a
    .label i = 2
    jsr div16u
    lda #<main.sintab2
    sta.z sintab
    lda #>main.sintab2
    sta.z sintab+1
    lda #<0
    sta.z x
    sta.z x+1
    sta.z i
    sta.z i+1
  b2:
    lda.z x
    sta.z sin8s.x
    lda.z x+1
    sta.z sin8s.x+1
    jsr sin8s
    ldy #0
    sta (sintab),y
    inc.z sintab
    bne !+
    inc.z sintab+1
  !:
    lda.z x
    clc
    adc.z step
    sta.z x
    lda.z x+1
    adc.z step+1
    sta.z x+1
    inc.z i
    bne !+
    inc.z i+1
  !:
  // u[4.12]
    lda.z i+1
    cmp #>main.wavelength
    bcc b2
    bne !+
    lda.z i
    cmp #<main.wavelength
    bcc b2
  !:
    rts
}
// Calculate signed byte sinus sin(x)
// x: unsigned word input u[4.12] in the interval $0000 - PI2_u4f12
// result: signed byte sin(x) s[0.7] - using the full range  -$7f - $7f
// sin8s(word zeropage(6) x)
sin8s: {
    // u[2.6] x^3
    .const DIV_6 = $2b
    .label _4 = 6
    .label x = 6
    .label x1 = $10
    .label x3 = $11
    .label usinx = $12
    .label isUpper = 4
    lda.z x+1
    cmp #>PI_u4f12
    bcc b5
    bne !+
    lda.z x
    cmp #<PI_u4f12
    bcc b5
  !:
    lda.z x
    sec
    sbc #<PI_u4f12
    sta.z x
    lda.z x+1
    sbc #>PI_u4f12
    sta.z x+1
    lda #1
    sta.z isUpper
    jmp b1
  b5:
    lda #0
    sta.z isUpper
  b1:
    lda.z x+1
    cmp #>PI_HALF_u4f12
    bcc b2
    bne !+
    lda.z x
    cmp #<PI_HALF_u4f12
    bcc b2
  !:
    sec
    lda #<PI_u4f12
    sbc.z x
    sta.z x
    lda #>PI_u4f12
    sbc.z x+1
    sta.z x+1
  b2:
    asl.z _4
    rol.z _4+1
    asl.z _4
    rol.z _4+1
    asl.z _4
    rol.z _4+1
    lda.z _4+1
    sta.z x1
    tax
    tay
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    tax
    ldy.z x1
    lda #1
    sta.z mulu8_sel.select
    jsr mulu8_sel
    sta.z x3
    tax
    lda #1
    sta.z mulu8_sel.select
    ldy #DIV_6
    jsr mulu8_sel
    eor #$ff
    sec
    adc.z x1
    sta.z usinx
    ldx.z x3
    ldy.z x1
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    tax
    ldy.z x1
    lda #0
    sta.z mulu8_sel.select
    jsr mulu8_sel
    lsr
    lsr
    lsr
    lsr
    clc
    adc.z usinx
    tax
    cpx #$80
    bcc b3
    dex
  b3:
    lda.z isUpper
    cmp #0
    beq b14
    txa
    eor #$ff
    clc
    adc #1
    rts
  b14:
    txa
    rts
}
// Calculate val*val for two unsigned byte values - the result is 8 selected bits of the 16-bit result.
// The select parameter indicates how many of the highest bits of the 16-bit result to skip
// mulu8_sel(byte register(X) v1, byte register(Y) v2, byte zeropage(5) select)
mulu8_sel: {
    .label _0 = 6
    .label _1 = 6
    .label select = 5
    tya
    jsr mul8u
    ldy.z select
    beq !e+
  !:
    asl.z _1
    rol.z _1+1
    dey
    bne !-
  !e:
    lda.z _1+1
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = 8
    .label res = 6
    .label return = 6
    sta.z mb
    lda #0
    sta.z mb+1
    sta.z res
    sta.z res+1
  b1:
    cpx #0
    bne b2
    rts
  b2:
    txa
    and #1
    cmp #0
    beq b3
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
  b3:
    txa
    lsr
    tax
    asl.z mb
    rol.z mb+1
    jmp b1
}
// Performs division on two 16 bit unsigned words
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
div16u: {
    .label return = $e
    jsr divr16u
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($c) dividend, word zeropage($a) rem)
divr16u: {
    .label rem = $a
    .label dividend = $c
    .label quotient = $e
    .label return = $e
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
    lda #<PI2_u4f12
    sta.z dividend
    lda #>PI2_u4f12
    sta.z dividend+1
    txa
    sta.z rem
    sta.z rem+1
  b1:
    asl.z rem
    rol.z rem+1
    lda.z dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora.z rem
    sta.z rem
  b2:
    asl.z dividend
    rol.z dividend+1
    asl.z quotient
    rol.z quotient+1
    lda.z rem+1
    cmp #>main.wavelength
    bcc b3
    bne !+
    lda.z rem
    cmp #<main.wavelength
    bcc b3
  !:
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    lda.z rem
    sec
    sbc #<main.wavelength
    sta.z rem
    lda.z rem+1
    sbc #>main.wavelength
    sta.z rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
