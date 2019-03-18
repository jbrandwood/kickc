// Linear table generator
// Work in progress towards a sinus generator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label rem16u = $f
  .label print_char_cursor = 7
  .label print_line_cursor = 3
main: {
    .label i = 2
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
    lda #0
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
    lda #0
    sta print_word.w
    sta print_word.w+1
    jsr print_word
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    lda #0
    sta i
  b1:
    ldx i
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
    ldy i
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
    ldy i
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
    ldy i
    lda lintab3,y
    sta print_word.w
    lda lintab3+1,y
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    lda i
    clc
    adc #2
    sta i
    cmp #$14*2
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
    lda print_line_cursor
    clc
    adc #$28
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
// print_word(word zeropage(5) w)
print_word: {
    .label w = 5
    lda w+1
    tax
    jsr print_byte
    lda w
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
    txa
    and #$f
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
// print_str(byte* zeropage(5) str)
print_str: {
    .label str = 5
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
    .label sc = 3
    lda #<$400
    sta sc
    lda #>$400
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
    cmp #>$400+$3e8
    bne b1
    lda sc
    cmp #<$400+$3e8
    bne b1
    rts
}
// Generate word linear table
// lintab - the table to generate into
// length - the number of points in a total sinus wavelength (the size of the table)
// lin16u_gen(word zeropage(5) min, word zeropage(3) max, word* zeropage(7) lintab)
lin16u_gen: {
    .label _5 = 5
    .label ampl = 3
    .label stepi = $13
    .label stepf = $11
    .label step = $15
    .label val = 9
    .label lintab = 7
    .label i = 3
    .label max = 3
    .label min = 5
    lda ampl
    sec
    sbc min
    sta ampl
    lda ampl+1
    sbc min+1
    sta ampl+1
    lda #$14-1
    sta divr16u.divisor
    lda #0
    sta divr16u.divisor+1
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    lda divr16u.return
    sta stepi
    lda divr16u.return+1
    sta stepi+1
    lda #$14-1
    sta divr16u.divisor
    lda #0
    sta divr16u.divisor+1
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
    lda #0
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
    lda lintab
    clc
    adc #2
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
// divr16u(word zeropage(3) dividend, word zeropage($d) divisor, word zeropage($f) rem)
divr16u: {
    .label rem = $f
    .label dividend = 3
    .label quotient = $11
    .label return = $11
    .label divisor = $d
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
