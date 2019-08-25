// Generates a 16-bit signed sinus
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
  // PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  // PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  // PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  .label print_line_cursor = $400
  .label rem16u = $15
  .label print_char_cursor = $b
main: {
    .label wavelength = $78
    .label sw = 8
    .label st1 = $15
    jsr sin16s_gen
    jsr print_cls
    lda #<print_line_cursor
    sta.z print_char_cursor
    lda #>print_line_cursor
    sta.z print_char_cursor+1
    lda #<sintab1
    sta.z st1
    lda #>sintab1
    sta.z st1+1
  b1:
    lda.z st1+1
    cmp #>sintab1+wavelength*SIZEOF_SIGNED_WORD
    bcc b2
    bne !+
    lda.z st1
    cmp #<sintab1+wavelength*SIZEOF_SIGNED_WORD
    bcc b2
  !:
    rts
  b2:
    ldy #0
    lda (st1),y
    sta.z sw
    iny
    lda (st1),y
    sta.z sw+1
    bmi b3
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
  b3:
    jsr print_sword
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    lda #SIZEOF_SIGNED_WORD
    clc
    adc.z st1
    sta.z st1
    bcc !+
    inc.z st1+1
  !:
    jmp b1
    str: .text "   "
    .byte 0
    str1: .text " "
    .byte 0
    sintab1: .fill 2*$78, 0
}
// Print a zero-terminated string
// print_str(byte* zeropage(2) str)
print_str: {
    .label str = 2
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
// Print a signed word as HEX
// print_sword(signed word zeropage(8) w)
print_sword: {
    .label w = 8
    lda.z w+1
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_word
    rts
  b1:
    lda #'-'
    jsr print_char
    sec
    lda #0
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
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
// Print a word as HEX
// print_word(word zeropage(8) w)
print_word: {
    .label w = 8
    lda.z w+1
    tax
    jsr print_byte
    lda.z w
    tax
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    axs #0
    lda print_hextab,x
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
    .label dst = $15
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  b1:
    lda.z dst+1
    cmp #>end
    bne b2
    lda.z dst
    cmp #<end
    bne b2
    rts
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp b1
}
// Generate signed (large) word sinus table - on the full -$7fff - $7fff range
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen(signed word* zeropage(8) sintab)
sin16s_gen: {
    .label _2 = $b
    .label step = $19
    .label sintab = 8
    .label x = 4
    .label i = 2
    jsr div32u16u
    lda #<main.sintab1
    sta.z sintab
    lda #>main.sintab1
    sta.z sintab+1
    lda #0
    sta.z x
    sta.z x+1
    sta.z x+2
    sta.z x+3
    sta.z i
    sta.z i+1
  // u[4.28]
  b1:
    lda.z i+1
    cmp #>main.wavelength
    bcc b2
    bne !+
    lda.z i
    cmp #<main.wavelength
    bcc b2
  !:
    rts
  b2:
    lda.z x
    sta.z sin16s.x
    lda.z x+1
    sta.z sin16s.x+1
    lda.z x+2
    sta.z sin16s.x+2
    lda.z x+3
    sta.z sin16s.x+3
    jsr sin16s
    ldy #0
    lda.z _2
    sta (sintab),y
    iny
    lda.z _2+1
    sta (sintab),y
    lda #SIZEOF_SIGNED_WORD
    clc
    adc.z sintab
    sta.z sintab
    bcc !+
    inc.z sintab+1
  !:
    lda.z x
    clc
    adc.z step
    sta.z x
    lda.z x+1
    adc.z step+1
    sta.z x+1
    lda.z x+2
    adc.z step+2
    sta.z x+2
    lda.z x+3
    adc.z step+3
    sta.z x+3
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp b1
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zeropage($d) x)
sin16s: {
    .label _4 = $d
    .label x = $d
    .label return = $b
    .label x1 = $1f
    .label x2 = $15
    .label x3 = $15
    .label x3_6 = $1d
    .label usinx = $b
    .label x4 = $15
    .label x5 = $1d
    .label x5_128 = $1d
    .label sinx = $b
    .label isUpper = $a
    lda.z x+3
    cmp #>PI_u4f28>>$10
    bcc b4
    bne !+
    lda.z x+2
    cmp #<PI_u4f28>>$10
    bcc b4
    bne !+
    lda.z x+1
    cmp #>PI_u4f28
    bcc b4
    bne !+
    lda.z x
    cmp #<PI_u4f28
    bcc b4
  !:
    lda.z x
    sec
    sbc #<PI_u4f28
    sta.z x
    lda.z x+1
    sbc #>PI_u4f28
    sta.z x+1
    lda.z x+2
    sbc #<PI_u4f28>>$10
    sta.z x+2
    lda.z x+3
    sbc #>PI_u4f28>>$10
    sta.z x+3
    lda #1
    sta.z isUpper
    jmp b1
  b4:
    lda #0
    sta.z isUpper
  b1:
    lda.z x+3
    cmp #>PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda.z x+2
    cmp #<PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda.z x+1
    cmp #>PI_HALF_u4f28
    bcc b2
    bne !+
    lda.z x
    cmp #<PI_HALF_u4f28
    bcc b2
  !:
    lda #<PI_u4f28
    sec
    sbc.z x
    sta.z x
    lda #>PI_u4f28
    sbc.z x+1
    sta.z x+1
    lda #<PI_u4f28>>$10
    sbc.z x+2
    sta.z x+2
    lda #>PI_u4f28>>$10
    sbc.z x+3
    sta.z x+3
  b2:
    ldy #3
  !:
    asl.z _4
    rol.z _4+1
    rol.z _4+2
    rol.z _4+3
    dey
    bne !-
    lda.z _4+2
    sta.z x1
    lda.z _4+3
    sta.z x1+1
    lda.z x1
    sta.z mulu16_sel.v1
    lda.z x1+1
    sta.z mulu16_sel.v1+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda.z mulu16_sel.return
    sta.z x2
    lda.z mulu16_sel.return+1
    sta.z x2+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    ldx #1
    lda #<$10000/6
    sta.z mulu16_sel.v2
    lda #>$10000/6
    sta.z mulu16_sel.v2+1
    jsr mulu16_sel
    lda.z x1
    sec
    sbc.z x3_6
    sta.z usinx
    lda.z x1+1
    sbc.z x3_6+1
    sta.z usinx+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_10
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_10+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lda.z usinx
    clc
    adc.z x5_128
    sta.z usinx
    lda.z usinx+1
    adc.z x5_128+1
    sta.z usinx+1
    lda.z isUpper
    cmp #0
    beq b3
    sec
    lda #0
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  b3:
    rts
}
// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zeropage($15) v1, word zeropage($17) v2, byte register(X) select)
mulu16_sel: {
    .label _0 = $d
    .label _1 = $d
    .label v1 = $15
    .label v2 = $17
    .label return = $1d
    .label return_1 = $15
    .label return_10 = $15
    lda.z v1
    sta.z mul16u.a
    lda.z v1+1
    sta.z mul16u.a+1
    jsr mul16u
    cpx #0
    beq !e+
  !:
    asl.z _1
    rol.z _1+1
    rol.z _1+2
    rol.z _1+3
    dex
    bne !-
  !e:
    lda.z _1+2
    sta.z return
    lda.z _1+3
    sta.z return+1
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zeropage($1d) a, word zeropage($17) b)
mul16u: {
    .label a = $1d
    .label mb = $11
    .label res = $d
    .label b = $17
    .label return = $d
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    sta.z res
    sta.z res+1
    sta.z res+2
    sta.z res+3
  b1:
    lda.z a
    bne b2
    lda.z a+1
    bne b2
    rts
  b2:
    lda #1
    and.z a
    cmp #0
    beq b3
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
  b3:
    lsr.z a+1
    ror.z a
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp b1
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $1f
    .label quotient_lo = $1d
    .label return = $19
    lda #<PI2_u4f28>>$10
    sta.z divr16u.dividend
    lda #>PI2_u4f28>>$10
    sta.z divr16u.dividend+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    lda.z divr16u.return
    sta.z quotient_hi
    lda.z divr16u.return+1
    sta.z quotient_hi+1
    lda #<PI2_u4f28&$ffff
    sta.z divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta.z divr16u.dividend+1
    jsr divr16u
    lda.z quotient_hi
    sta.z return+2
    lda.z quotient_hi+1
    sta.z return+3
    lda.z quotient_lo
    sta.z return
    lda.z quotient_lo+1
    sta.z return+1
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($17) dividend, word zeropage($15) rem)
divr16u: {
    .label rem = $15
    .label dividend = $17
    .label quotient = $1d
    .label return = $1d
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
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
