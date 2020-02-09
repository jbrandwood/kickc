// Linear table generator
// Work in progress towards a sinus generator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  // Remainder after unsigned 16-bit division
  .label rem16u = $17
  .label print_char_cursor = 3
  .label print_line_cursor = $b
main: {
    lda #<lintab1
    sta.z lin16u_gen.lintab
    lda #>lintab1
    sta.z lin16u_gen.lintab+1
    lda #<$22d
    sta.z lin16u_gen.min
    lda #>$22d
    sta.z lin16u_gen.min+1
    lda #<$7461
    sta.z lin16u_gen.max
    lda #>$7461
    sta.z lin16u_gen.max+1
    jsr lin16u_gen
    lda #<lintab2
    sta.z lin16u_gen.lintab
    lda #>lintab2
    sta.z lin16u_gen.lintab+1
    lda #<$79cb
    sta.z lin16u_gen.min
    lda #>$79cb
    sta.z lin16u_gen.min+1
    lda #<$f781
    sta.z lin16u_gen.max
    lda #>$f781
    sta.z lin16u_gen.max+1
    jsr lin16u_gen
    lda #<lintab3
    sta.z lin16u_gen.lintab
    lda #>lintab3
    sta.z lin16u_gen.lintab+1
    lda #<0
    sta.z lin16u_gen.min
    sta.z lin16u_gen.min+1
    lda #<$6488
    sta.z lin16u_gen.max
    lda #>$6488
    sta.z lin16u_gen.max+1
    jsr lin16u_gen
    jsr print_cls
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    lda #<$22d
    sta.z print_word.w
    lda #>$22d
    sta.z print_word.w+1
    jsr print_word
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    lda #<$79cb
    sta.z print_word.w
    lda #>$79cb
    sta.z print_word.w+1
    jsr print_word
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    lda #<0
    sta.z print_word.w
    sta.z print_word.w+1
    jsr print_word
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    ldx #0
  __b1:
    cpx #$14
    bcc __b2
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    lda #<$7461
    sta.z print_word.w
    lda #>$7461
    sta.z print_word.w+1
    jsr print_word
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    lda #<$f781
    sta.z print_word.w
    lda #>$f781
    sta.z print_word.w+1
    jsr print_word
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    lda #<$6488
    sta.z print_word.w
    lda #>$6488
    sta.z print_word.w+1
    jsr print_word
    jsr print_ln
    rts
  __b2:
    stx.z print_byte.b
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jsr print_byte
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    txa
    asl
    tay
    lda lintab1,y
    sta.z print_word.w
    lda lintab1+1,y
    sta.z print_word.w+1
    jsr print_word
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    txa
    asl
    tay
    lda lintab2,y
    sta.z print_word.w
    lda lintab2+1,y
    sta.z print_word.w+1
    jsr print_word
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    txa
    asl
    tay
    lda lintab3,y
    sta.z print_word.w
    lda lintab3+1,y
    sta.z print_word.w+1
    jsr print_word
    jsr print_ln
    inx
    jmp __b1
    lintab1: .fill 2*$14, 0
    lintab2: .fill 2*$14, 0
    lintab3: .fill 2*$14, 0
    str: .text "   "
    .byte 0
    str1: .text " "
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
// Print a word as HEX
// print_word(word zp(5) w)
print_word: {
    .label w = 5
    lda.z w+1
    sta.z print_byte.b
    jsr print_byte
    lda.z w
    sta.z print_byte.b
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte zp(2) b)
print_byte: {
    .label b = 2
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
// print_str(byte* zp(5) str)
print_str: {
    .label str = 5
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
    .label dst = $b
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
// Generate word linear table
// lintab - the table to generate into
// length - the number of points in a total sinus wavelength (the size of the table)
// lin16u_gen(word zp(5) min, word zp(3) max, word* zp($b) lintab)
lin16u_gen: {
    .label __6 = $17
    .label ampl = 3
    .label stepi = $11
    .label stepf = $f
    .label step = $13
    .label val = 7
    .label lintab = $b
    .label i = $d
    .label max = 3
    .label min = 5
    lda.z ampl
    sec
    sbc.z min
    sta.z ampl
    lda.z ampl+1
    sbc.z min+1
    sta.z ampl+1
    lda #<$14-1
    sta.z divr16u.divisor
    lda #>$14-1
    sta.z divr16u.divisor+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    lda.z divr16u.return
    sta.z stepi
    lda.z divr16u.return+1
    sta.z stepi+1
    lda #<$14-1
    sta.z divr16u.divisor
    lda #>$14-1
    sta.z divr16u.divisor+1
    lda #<0
    sta.z divr16u.dividend
    sta.z divr16u.dividend+1
    jsr divr16u
    lda.z stepi
    sta.z step+2
    lda.z stepi+1
    sta.z step+3
    lda.z stepf
    sta.z step
    lda.z stepf+1
    sta.z step+1
    lda #<0
    sta.z val
    sta.z val+1
    lda.z min
    sta.z val+2
    lda.z min+1
    sta.z val+3
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    lda.z i+1
    cmp #>$14
    bcc __b2
    bne !+
    lda.z i
    cmp #<$14
    bcc __b2
  !:
    rts
  __b2:
    lda.z val+2
    sta.z __6
    lda.z val+3
    sta.z __6+1
    ldy #0
    lda.z __6
    sta (lintab),y
    iny
    lda.z __6+1
    sta (lintab),y
    lda.z val
    clc
    adc.z step
    sta.z val
    lda.z val+1
    adc.z step+1
    sta.z val+1
    lda.z val+2
    adc.z step+2
    sta.z val+2
    lda.z val+3
    adc.z step+3
    sta.z val+3
    lda #SIZEOF_WORD
    clc
    adc.z lintab
    sta.z lintab
    bcc !+
    inc.z lintab+1
  !:
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp(3) dividend, word zp($d) divisor, word zp($17) rem)
divr16u: {
    .label rem = $17
    .label dividend = 3
    .label quotient = $f
    .label return = $f
    .label divisor = $d
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
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
    cmp.z divisor+1
    bcc __b3
    bne !+
    lda.z rem
    cmp.z divisor
    bcc __b3
  !:
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    lda.z rem
    sec
    sbc.z divisor
    sta.z rem
    lda.z rem+1
    sbc.z divisor+1
    sta.z rem+1
  __b3:
    inx
    cpx #$10
    bne __b1
    rts
}
  print_hextab: .text "0123456789abcdef"
