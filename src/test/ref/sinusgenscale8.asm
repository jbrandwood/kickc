.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // PI*2 in u[4.12] format
  .const PI2_u4f12 = $6488
  // PI in u[4.12] format
  .const PI_u4f12 = $3244
  // PI/2 in u[4.12] format
  .const PI_HALF_u4f12 = $1922
  .label print_char_cursor = 6
  .label print_line_cursor = 2
main: {
    .label tabsize = $14
    jsr print_cls
    jsr sin8u_table
    rts
    sintab: .fill $14, 0
}
// Generate unsigned byte sinus table in a min-max range
// sintab - the table to generate into
// tabsize - the number of sinus points (the size of the table)
// min - the minimal value
// max - the maximal value
// sin8u_table(byte* zeropage($11) sintab)
sin8u_table: {
    .const min = $a
    .const max = $ff
    .label amplitude = max-min
    .const sum = min+max
    .const mid = sum/2+1
    .label step = $f
    .label sinx = $13
    .label sinx_sc = 9
    .label sintab = $11
    // Iterate over the table
    .label x = $d
    .label i = $b
    jsr div16u
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    lda.z step
    sta.z print_word.w
    lda.z step+1
    sta.z print_word.w+1
    jsr print_word
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    lda #min
    sta.z print_byte.b
    jsr print_byte
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    lda #max
    sta.z print_byte.b
    jsr print_byte
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    lda #amplitude
    sta.z print_byte.b
    jsr print_byte
    lda #<str4
    sta.z print_str.str
    lda #>str4
    sta.z print_str.str+1
    jsr print_str
    lda #mid
    sta.z print_byte.b
    jsr print_byte
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    lda #<main.sintab
    sta.z sintab
    lda #>main.sintab
    sta.z sintab+1
    lda #<0
    sta.z x
    sta.z x+1
    sta.z i
    sta.z i+1
  // u[4.12]
  __b1:
    lda.z i+1
    cmp #>main.tabsize
    bcc __b2
    bne !+
    lda.z i
    cmp #<main.tabsize
    bcc __b2
  !:
    rts
  __b2:
    lda.z x
    sta.z sin8s.x
    lda.z x+1
    sta.z sin8s.x+1
    jsr sin8s
    sta.z sinx
    tay
    jsr mul8su
    lda.z sinx_sc+1
    tax
    axs #-[mid]
    txa
    ldy #0
    sta (sintab),y
    inc.z sintab
    bne !+
    inc.z sintab+1
  !:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    lda.z x
    sta.z print_word.w
    lda.z x+1
    sta.z print_word.w+1
    jsr print_word
    lda #<str6
    sta.z print_str.str
    lda #>str6
    sta.z print_str.str+1
    jsr print_str
    lda.z sinx
    sta.z print_sbyte.b
    jsr print_sbyte
    lda #<str7
    sta.z print_str.str
    lda #>str7
    sta.z print_str.str+1
    jsr print_str
    lda.z sinx_sc
    sta.z print_sword.w
    lda.z sinx_sc+1
    sta.z print_sword.w+1
    jsr print_sword
    lda #<str8
    sta.z print_str.str
    lda #>str8
    sta.z print_str.str+1
    jsr print_str
    stx.z print_byte.b
    jsr print_byte
    jsr print_ln
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
    jmp __b1
    str: .text "step:"
    .byte 0
    str1: .text " min:"
    .byte 0
    str2: .text " max:"
    .byte 0
    str3: .text " ampl:"
    .byte 0
    str4: .text " mid:"
    .byte 0
    str5: .text "x: "
    .byte 0
    str6: .text " sin: "
    .byte 0
    str7: .text " scaled: "
    .byte 0
    str8: .text " trans: "
    .byte 0
}
// Print a newline
print_ln: {
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage(8) b)
print_byte: {
    .label b = 8
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
// Print a zero-terminated string
// print_str(byte* zeropage(4) str)
print_str: {
    .label str = 4
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
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
    jmp __b1
}
// Print a signed word as HEX
// print_sword(signed word zeropage(4) w)
print_sword: {
    .label w = 4
    lda.z w+1
    bmi __b1
    lda #' '
    jsr print_char
  __b2:
    jsr print_word
    rts
  __b1:
    lda #'-'
    jsr print_char
    sec
    lda #0
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
    jmp __b2
}
// Print a word as HEX
// print_word(word zeropage(4) w)
print_word: {
    .label w = 4
    lda.z w+1
    sta.z print_byte.b
    jsr print_byte
    lda.z w
    sta.z print_byte.b
    jsr print_byte
    rts
}
// Print a signed byte as HEX
// print_sbyte(signed byte zeropage(8) b)
print_sbyte: {
    .label b = 8
    lda.z b
    bmi __b1
    lda #' '
    jsr print_char
  __b2:
    jsr print_byte
    rts
  __b1:
    lda #'-'
    jsr print_char
    lda.z b
    eor #$ff
    clc
    adc #1
    sta.z b
    jmp __b2
}
// Multiply a signed byte and an unsigned byte (into a signed word)
// Fixes offsets introduced by using unsigned multiplication
// mul8su(signed byte register(Y) a)
mul8su: {
    .const b = sin8u_table.amplitude+1
    .label m = 9
    tya
    tax
    lda #<b
    sta.z mul8u.mb
    lda #>b
    sta.z mul8u.mb+1
    jsr mul8u
    cpy #0
    bpl __b1
    lda.z m+1
    sec
    sbc #b
    sta.z m+1
  __b1:
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = 6
    .label res = 9
    .label return = 9
    lda #<0
    sta.z res
    sta.z res+1
  __b1:
    cpx #0
    bne __b2
    rts
  __b2:
    txa
    and #1
    cmp #0
    beq __b3
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
  __b3:
    txa
    lsr
    tax
    asl.z mb
    rol.z mb+1
    jmp __b1
}
// Calculate signed byte sinus sin(x)
// x: unsigned word input u[4.12] in the interval $0000 - PI2_u4f12
// result: signed byte sin(x) s[0.7] - using the full range  -$7f - $7f
// sin8s(word zeropage(9) x)
sin8s: {
    // u[2.6] x^3
    .const DIV_6 = $2b
    .label __4 = 9
    .label x = 9
    .label x1 = $14
    .label x3 = $15
    .label usinx = $16
    // Move x1 into the range 0-PI/2 using sinus mirror symmetries
    .label isUpper = 8
    lda.z x+1
    cmp #>PI_u4f12
    bcc b1
    bne !+
    lda.z x
    cmp #<PI_u4f12
    bcc b1
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
    jmp __b1
  b1:
    lda #0
    sta.z isUpper
  __b1:
    lda.z x+1
    cmp #>PI_HALF_u4f12
    bcc __b2
    bne !+
    lda.z x
    cmp #<PI_HALF_u4f12
    bcc __b2
  !:
    sec
    lda #<PI_u4f12
    sbc.z x
    sta.z x
    lda #>PI_u4f12
    sbc.z x+1
    sta.z x+1
  __b2:
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    lda.z __4+1
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
    bcc __b3
    dex
  __b3:
    lda.z isUpper
    cmp #0
    beq __b14
    txa
    eor #$ff
    clc
    adc #1
    rts
  __b14:
    txa
    rts
}
// Calculate val*val for two unsigned byte values - the result is 8 selected bits of the 16-bit result.
// The select parameter indicates how many of the highest bits of the 16-bit result to skip
// mulu8_sel(byte register(X) v1, byte register(Y) v2, byte zeropage($13) select)
mulu8_sel: {
    .label __0 = 9
    .label __1 = 9
    .label select = $13
    tya
    sta.z mul8u.mb
    lda #0
    sta.z mul8u.mb+1
    jsr mul8u
    ldy.z select
    beq !e+
  !:
    asl.z __1
    rol.z __1+1
    dey
    bne !-
  !e:
    lda.z __1+1
    rts
}
// Performs division on two 16 bit unsigned words
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
div16u: {
    .label return = $f
    jsr divr16u
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($d) dividend, word zeropage($b) rem)
divr16u: {
    .label rem = $b
    .label dividend = $d
    .label quotient = $f
    .label return = $f
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
  __b1:
    asl.z rem
    rol.z rem+1
    lda.z dividend+1
    and #$80
    cmp #0
    beq __b2
    lda #1
    ora.z rem
    sta.z rem
  __b2:
    asl.z dividend
    rol.z dividend+1
    asl.z quotient
    rol.z quotient+1
    lda.z rem+1
    cmp #>main.tabsize
    bcc __b3
    bne !+
    lda.z rem
    cmp #<main.tabsize
    bcc __b3
  !:
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    lda.z rem
    sec
    sbc #<main.tabsize
    sta.z rem
    lda.z rem+1
    sbc #>main.tabsize
    sta.z rem+1
  __b3:
    inx
    cpx #$10
    bne __b1
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
    .label str = $400
    .label end = str+num
    .label dst = $11
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    rts
  __b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
  print_hextab: .text "0123456789abcdef"
