.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // PI*2 in u[4.12] format
  .const PI2_u4f12 = $6488
  // PI in u[4.12] format
  .const PI_u4f12 = $3244
  // PI/2 in u[4.12] format
  .const PI_HALF_u4f12 = $1922
  .label print_char_cursor = $f
  .label print_line_cursor = 8
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
// sin8u_table(byte* zeropage(4) sintab)
sin8u_table: {
    .const min = $a
    .const max = $ff
    .label amplitude = max-min
    .const sum = min+max
    .const mid = sum/2+1
    .label step = $1d
    .label sinx = $21
    .label sintab = 4
    .label x = 2
    .label i = 6
    jsr div16u
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda step
    sta print_word.w
    lda step+1
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda #min
    sta print_byte.b
    jsr print_byte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda #max
    sta print_byte.b
    jsr print_byte
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    lda #amplitude
    sta print_byte.b
    jsr print_byte
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    lda #mid
    sta print_byte.b
    jsr print_byte
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    lda #0
    sta i
    sta i+1
    lda #<main.sintab
    sta sintab
    lda #>main.sintab
    sta sintab+1
    lda #0
    sta x
    sta x+1
  // u[4.12]
  b1:
    lda x
    sta sin8s.x
    lda x+1
    sta sin8s.x+1
    jsr sin8s
    sta sinx
    tay
    jsr mul8su
    lda mul8su.m+1
    tax
    axs #-[mid]
    txa
    ldy #0
    sta (sintab),y
    inc sintab
    bne !+
    inc sintab+1
  !:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str5
    sta print_str.str
    lda #>str5
    sta print_str.str+1
    jsr print_str
    lda x
    sta print_word.w
    lda x+1
    sta print_word.w+1
    jsr print_word
    lda #<str6
    sta print_str.str
    lda #>str6
    sta print_str.str+1
    jsr print_str
    lda sinx
    sta print_sbyte.b
    jsr print_sbyte
    lda #<str7
    sta print_str.str
    lda #>str7
    sta print_str.str+1
    jsr print_str
    jsr print_sword
    lda #<str8
    sta print_str.str
    lda #>str8
    sta print_str.str+1
    jsr print_str
    stx print_byte.b
    jsr print_byte
    jsr print_ln
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
    cmp #>main.tabsize
    bcs !b1+
    jmp b1
  !b1:
    bne !+
    lda i
    cmp #<main.tabsize
    bcs !b1+
    jmp b1
  !b1:
  !:
    rts
    str: .text "step:@"
    str1: .text " min:@"
    str2: .text " max:@"
    str3: .text " ampl:@"
    str4: .text " mid:@"
    str5: .text "x: @"
    str6: .text " sin: @"
    str7: .text " scaled: @"
    str8: .text " trans: @"
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
// Print a byte as HEX
// print_byte(byte zeropage($a) b)
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
// print_str(byte* zeropage($b) str)
print_str: {
    .label str = $b
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
// Print a signed word as HEX
// print_sword(signed word zeropage($d) w)
print_sword: {
    .label w = $d
    lda mul8su.m+1
    bpl b1
    lda #'-'
    jsr print_char
    sec
    lda #0
    sbc w
    sta w
    lda #0
    sbc w+1
    sta w+1
  b1:
    lda w
    sta print_word.w
    lda w+1
    sta print_word.w+1
    jsr print_word
    rts
}
// Print a word as HEX
// print_word(word zeropage($11) w)
print_word: {
    .label w = $11
    lda w+1
    sta print_byte.b
    jsr print_byte
    lda w
    sta print_byte.b
    jsr print_byte
    rts
}
// Print a signed byte as HEX
// print_sbyte(signed byte zeropage($a) b)
print_sbyte: {
    .label b = $a
    lda b
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_byte
    rts
  b1:
    lda #'-'
    jsr print_char
    lda b
    eor #$ff
    clc
    adc #1
    sta b
    jmp b2
}
// Multiply a signed byte and an unsigned byte (into a signed word)
// Fixes offsets introduced by using unsigned multiplication
// mul8su(signed byte register(Y) a)
mul8su: {
    .const b = sin8u_table.amplitude+1
    .label m = $d
    tya
    tax
    lda #b
    sta mul8u.mb
    lda #0
    sta mul8u.mb+1
    jsr mul8u
    cpy #0
    bpl b1
    lda m+1
    sec
    sbc #b
    sta m+1
  b1:
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = $13
    .label res = $d
    .label return = $d
    lda #0
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
    beq b3
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
  b3:
    txa
    lsr
    tax
    asl mb
    rol mb+1
    jmp b1
}
// Calculate signed byte sinus sin(x)
// x: unsigned word input u[4.12] in the interval $0000 - PI2_u4f12
// result: signed byte sin(x) s[0.7] - using the full range  -$7f - $7f
// sin8s(word zeropage($16) x)
sin8s: {
    // u[2.6] x^3
    .const DIV_6 = $2b
    .label _4 = $16
    .label x = $16
    .label x1 = $22
    .label x3 = $23
    .label usinx = $24
    .label isUpper = $15
    lda x+1
    cmp #>PI_u4f12
    bcc b5
    bne !+
    lda x
    cmp #<PI_u4f12
    bcc b5
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
  b5:
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
    asl _4
    rol _4+1
    asl _4
    rol _4+1
    asl _4
    rol _4+1
    lda _4+1
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
    ldy #DIV_6
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
    cpx #$80
    bcc b3
    dex
  b3:
    lda isUpper
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
// mulu8_sel(byte register(X) v1, byte register(Y) v2, byte zeropage($18) select)
mulu8_sel: {
    .label _0 = $d
    .label _1 = $d
    .label select = $18
    tya
    sta mul8u.mb
    lda #0
    sta mul8u.mb+1
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
// Performs division on two 16 bit unsigned words
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
div16u: {
    .label return = $1d
    jsr divr16u
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($1b) dividend, word zeropage($19) rem)
divr16u: {
    .label rem = $19
    .label dividend = $1b
    .label quotient = $1d
    .label return = $1d
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
    cmp #>main.tabsize
    bcc b3
    bne !+
    lda rem
    cmp #<main.tabsize
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc #<main.tabsize
    sta rem
    lda rem+1
    sbc #>main.tabsize
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    .label sc = $1f
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
  print_hextab: .text "0123456789abcdef"
