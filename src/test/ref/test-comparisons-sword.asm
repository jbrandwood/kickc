// Test signed word comparisons
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const LT = 0
  .const LE = 1
  .const GT = 2
  .const GE = 3
  .const EQ = 4
  .const NE = 5
  // empty circle
  .const FF = $57
  // filled circle
  .const TT = $51
  .label print_char_cursor = 8
  .label print_line_cursor = $d
main: {
    .label w1 = $f
    .label w2 = $11
    .label s = 4
    .label j = 3
    .label i = 2
    jsr print_cls
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #0
    sta s
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #0
    sta i
  b1:
    lda i
    asl
    tay
    lda swords,y
    sta w1
    lda swords+1,y
    sta w1+1
    lda #0
    sta j
  b2:
    lda j
    asl
    tay
    lda swords,y
    sta w2
    lda swords+1,y
    sta w2+1
    ldx #0
  b3:
    lda w1
    sta compare.w1
    lda w1+1
    sta compare.w1+1
    jsr compare
    inc s
    lda #3
    cmp s
    bne b4
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #0
    sta s
  b4:
    inx
    cpx #6
    bne b3
    inc j
    lda #3
    cmp j
    bne b2
    inc i
    cmp i
    bne b1
  b5:
  // loop forever
    jmp b5
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
// Compare two words using an operator
// compare(signed word zeropage($a) w1, signed word zeropage($11) w2, byte register(X) op)
compare: {
    .label w1 = $a
    .label w2 = $11
    .label ops = 5
    .label r = 7
    cpx #LT
    bne !b1+
    jmp b1
  !b1:
    cpx #LE
    bne !b2+
    jmp b2
  !b2:
    cpx #GT
    bne !b3+
    jmp b3
  !b3:
    cpx #GE
    bne !b4+
    jmp b4
  !b4:
    cpx #EQ
    beq b5
    cpx #NE
    bne b10
    lda w1
    cmp w2
    bne !+
    lda w1+1
    cmp w2+1
    beq b9
  !:
    lda #TT
    sta r
    jmp b23
  b9:
    lda #FF
    sta r
  b23:
    lda #<ops_1
    sta ops
    lda #>ops_1
    sta ops+1
    jmp b6
  b10:
    lda #FF
    sta r
    lda #<0
    sta ops
    sta ops+1
  b6:
    lda w1+1
    bmi b7
    lda #' '
    jsr print_char
  b7:
    jsr print_sword
    jsr print_str
    lda w2+1
    bmi b8
    lda #' '
    jsr print_char
  b8:
    lda w2
    sta print_sword.w
    lda w2+1
    sta print_sword.w+1
    jsr print_sword
    lda r
    jsr print_char
    rts
  b5:
    lda w1+1
    cmp w2+1
    bne b11
    lda w1
    cmp w2
    bne b11
    lda #TT
    sta r
    jmp b24
  b11:
    lda #FF
    sta r
  b24:
    lda #<ops_2
    sta ops
    lda #>ops_2
    sta ops+1
    jmp b6
  b4:
    lda w2
    cmp w1
    lda w2+1
    sbc w1+1
    bvc !+
    eor #$80
  !:
    beq !e+
    bpl b12
  !e:
    lda #TT
    sta r
    jmp b25
  b12:
    lda #FF
    sta r
  b25:
    lda #<ops_3
    sta ops
    lda #>ops_3
    sta ops+1
    jmp b6
  b3:
    lda w2
    cmp w1
    lda w2+1
    sbc w1+1
    bvc !+
    eor #$80
  !:
    bpl b13
    lda #TT
    sta r
    jmp b26
  b13:
    lda #FF
    sta r
  b26:
    lda #<ops_4
    sta ops
    lda #>ops_4
    sta ops+1
    jmp b6
  b2:
    lda w1
    cmp w2
    lda w1+1
    sbc w2+1
    bvc !+
    eor #$80
  !:
    beq !e+
    bpl b14
  !e:
    lda #TT
    sta r
    jmp b27
  b14:
    lda #FF
    sta r
  b27:
    lda #<ops_5
    sta ops
    lda #>ops_5
    sta ops+1
    jmp b6
  b1:
    lda w1
    cmp w2
    lda w1+1
    sbc w2+1
    bvc !+
    eor #$80
  !:
    bpl b15
    lda #TT
    sta r
    jmp b28
  b15:
    lda #FF
    sta r
  b28:
    lda #<ops_6
    sta ops
    lda #>ops_6
    sta ops+1
    jmp b6
    ops_1: .text "!=@"
    ops_2: .text "==@"
    ops_3: .text ">=@"
    ops_4: .text "> @"
    ops_5: .text "<=@"
    ops_6: .text "< @"
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
// Print a signed word as HEX
// print_sword(signed word zeropage($a) w)
print_sword: {
    .label w = $a
    lda w+1
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
    sbc w
    sta w
    lda #0
    sbc w+1
    sta w+1
    jmp b2
}
// Print a word as HEX
// print_word(word zeropage($a) w)
print_word: {
    .label w = $a
    lda w+1
    sta print_byte.b
    jsr print_byte
    lda w
    sta print_byte.b
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage($c) b)
print_byte: {
    .label b = $c
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
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = $400
    .label end = str+num
    .label dst = $d
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
}
  print_hextab: .text "0123456789abcdef"
  swords: .word -$6fed, $12, $7fed
