// Linear table generator
// Work in progress towards a sinus generator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  .label rem16u = $1b
  .label print_char_cursor = 7
  .label print_line_cursor = 2
main: {
    lda #<lintab1
    sta lin16u_gen.lintab
    lda #>lintab1
    sta lin16u_gen.lintab+1
    lda #<$22d
    sta lin16u_gen.min
    lda #>$22d
    sta lin16u_gen.min+1
    lda #<$7461
    sta lin16u_gen.max
    lda #>$7461
    sta lin16u_gen.max+1
    jsr lin16u_gen
    lda #<lintab2
    sta lin16u_gen.lintab
    lda #>lintab2
    sta lin16u_gen.lintab+1
    lda #<$79cb
    sta lin16u_gen.min
    lda #>$79cb
    sta lin16u_gen.min+1
    lda #<$f781
    sta lin16u_gen.max
    lda #>$f781
    sta lin16u_gen.max+1
    jsr lin16u_gen
    lda #<lintab3
    sta lin16u_gen.lintab
    lda #>lintab3
    sta lin16u_gen.lintab+1
    lda #<0
    sta lin16u_gen.min
    sta lin16u_gen.min+1
    lda #<$6488
    sta lin16u_gen.max
    lda #>$6488
    sta lin16u_gen.max+1
    jsr lin16u_gen
    jsr print_cls
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<$22d
    sta print_word.w
    lda #>$22d
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda #<$79cb
    sta print_word.w
    lda #>$79cb
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda #<0
    sta print_word.w
    sta print_word.w+1
    jsr print_word
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    ldx #0
  b1:
    stx print_byte.b
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_byte
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    txa
    asl
    tay
    lda lintab1,y
    sta print_word.w
    lda lintab1+1,y
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    txa
    asl
    tay
    lda lintab2,y
    sta print_word.w
    lda lintab2+1,y
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    txa
    asl
    tay
    lda lintab3,y
    sta print_word.w
    lda lintab3+1,y
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    inx
    cpx #$14
    bcc b1
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<$7461
    sta print_word.w
    lda #>$7461
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda #<$f781
    sta print_word.w
    lda #>$f781
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda #<$6488
    sta print_word.w
    lda #>$6488
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    rts
    str: .text "   @"
    str1: .text " @"
    lintab1: .fill 2*$14, 0
    lintab2: .fill 2*$14, 0
    lintab3: .fill 2*$14, 0
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
  !:
    rts
}
// Print a word as HEX
// print_word(word zeropage(4) w)
print_word: {
    .label w = 4
    lda w+1
    sta print_byte.b
    jsr print_byte
    lda w
    sta print_byte.b
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage(6) b)
print_byte: {
    .label b = 6
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
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// Print a zero-terminated string
// print_str(byte* zeropage(9) str)
print_str: {
    .label str = 9
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
    sta dst
    lda #>str
    sta dst+1
  b1:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b1
    lda dst
    cmp #<end
    bne b1
    rts
}
// Generate word linear table
// lintab - the table to generate into
// length - the number of points in a total sinus wavelength (the size of the table)
// lin16u_gen(word zeropage($f) min, word zeropage($d) max, word* zeropage($15) lintab)
lin16u_gen: {
    .label _5 = $25
    .label ampl = $d
    .label stepi = $1f
    .label stepf = $1d
    .label step = $21
    .label val = $11
    .label lintab = $15
    .label i = $17
    .label max = $d
    .label min = $f
    lda ampl
    sec
    sbc min
    sta ampl
    lda ampl+1
    sbc min+1
    sta ampl+1
    lda #<$14-1
    sta divr16u.divisor
    lda #>$14-1
    sta divr16u.divisor+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    lda divr16u.return
    sta stepi
    lda divr16u.return+1
    sta stepi+1
    lda #<$14-1
    sta divr16u.divisor
    lda #>$14-1
    sta divr16u.divisor+1
    lda #<0
    sta divr16u.dividend
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
    sta val
    sta val+1
    lda min
    sta val+2
    lda min+1
    sta val+3
    lda #<0
    sta i
    sta i+1
  b1:
    lda val+2
    sta _5
    lda val+3
    sta _5+1
    ldy #0
    lda _5
    sta (lintab),y
    iny
    lda _5+1
    sta (lintab),y
    lda val
    clc
    adc step
    sta val
    lda val+1
    adc step+1
    sta val+1
    lda val+2
    adc step+2
    sta val+2
    lda val+3
    adc step+3
    sta val+3
    lda #SIZEOF_WORD
    clc
    adc lintab
    sta lintab
    bcc !+
    inc lintab+1
  !:
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>$14
    bcc b1
    bne !+
    lda i
    cmp #<$14
    bcc b1
  !:
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($d) dividend, word zeropage($19) divisor, word zeropage($1b) rem)
divr16u: {
    .label rem = $1b
    .label dividend = $d
    .label quotient = $1d
    .label return = $1d
    .label divisor = $19
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
  print_hextab: .text "0123456789abcdef"
