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
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #0
    sta.z s
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #0
    sta.z i
  b1:
    lda.z i
    asl
    tay
    lda swords,y
    sta.z w1
    lda swords+1,y
    sta.z w1+1
    lda #0
    sta.z j
  b2:
    lda.z j
    asl
    tay
    lda swords,y
    sta.z w2
    lda swords+1,y
    sta.z w2+1
    ldx #0
  b3:
    lda.z w1
    sta.z compare.w1
    lda.z w1+1
    sta.z compare.w1+1
    jsr compare
    inc.z s
    lda #3
    cmp.z s
    bne b4
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #0
    sta.z s
  b4:
    inx
    cpx #6
    bne b3
    inc.z j
    lda #3
    cmp.z j
    bne b2
    inc.z i
    cmp.z i
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
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
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
    beq b4
    cpx #EQ
    beq b5
    cpx #NE
    bne b10
    lda.z w1
    cmp.z w2
    bne !+
    lda.z w1+1
    cmp.z w2+1
    beq b9
  !:
    lda #TT
    sta.z r
    jmp b23
  b9:
    lda #FF
    sta.z r
  b23:
    lda #<ops_1
    sta.z ops
    lda #>ops_1
    sta.z ops+1
    jmp b6
  b10:
    lda #FF
    sta.z r
    lda #<0
    sta.z ops
    sta.z ops+1
  b6:
    lda.z w1+1
    bmi b7
    lda #' '
    jsr print_char
  b7:
    jsr print_sword
    jsr print_str
    lda.z w2+1
    bmi b8
    lda #' '
    jsr print_char
  b8:
    lda.z w2
    sta.z print_sword.w
    lda.z w2+1
    sta.z print_sword.w+1
    jsr print_sword
    lda.z r
    jsr print_char
    rts
  b5:
    lda.z w1+1
    cmp.z w2+1
    bne b11
    lda.z w1
    cmp.z w2
    bne b11
    lda #TT
    sta.z r
    jmp b24
  b11:
    lda #FF
    sta.z r
  b24:
    lda #<ops_2
    sta.z ops
    lda #>ops_2
    sta.z ops+1
    jmp b6
  b4:
    lda.z w2
    cmp.z w1
    lda.z w2+1
    sbc.z w1+1
    bvc !+
    eor #$80
  !:
    beq !e+
    bpl b12
  !e:
    lda #TT
    sta.z r
    jmp b25
  b12:
    lda #FF
    sta.z r
  b25:
    lda #<ops_3
    sta.z ops
    lda #>ops_3
    sta.z ops+1
    jmp b6
  b3:
    lda.z w2
    cmp.z w1
    lda.z w2+1
    sbc.z w1+1
    bvc !+
    eor #$80
  !:
    bpl b13
    lda #TT
    sta.z r
    jmp b26
  b13:
    lda #FF
    sta.z r
  b26:
    lda #<ops_4
    sta.z ops
    lda #>ops_4
    sta.z ops+1
    jmp b6
  b2:
    lda.z w1
    cmp.z w2
    lda.z w1+1
    sbc.z w2+1
    bvc !+
    eor #$80
  !:
    beq !e+
    bpl b14
  !e:
    lda #TT
    sta.z r
    jmp b27
  b14:
    lda #FF
    sta.z r
  b27:
    lda #<ops_5
    sta.z ops
    lda #>ops_5
    sta.z ops+1
    jmp b6
  b1:
    lda.z w1
    cmp.z w2
    lda.z w1+1
    sbc.z w2+1
    bvc !+
    eor #$80
  !:
    bpl b15
    lda #TT
    sta.z r
    jmp b28
  b15:
    lda #FF
    sta.z r
  b28:
    lda #<ops_6
    sta.z ops
    lda #>ops_6
    sta.z ops+1
    jmp b6
    ops_1: .text "!="
    .byte 0
    ops_2: .text "=="
    .byte 0
    ops_3: .text ">="
    .byte 0
    ops_4: .text "> "
    .byte 0
    ops_5: .text "<="
    .byte 0
    ops_6: .text "< "
    .byte 0
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
// Print a signed word as HEX
// print_sword(signed word zeropage($a) w)
print_sword: {
    .label w = $a
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
// Print a word as HEX
// print_word(word zeropage($a) w)
print_word: {
    .label w = $a
    lda.z w+1
    sta.z print_byte.b
    jsr print_byte
    lda.z w
    sta.z print_byte.b
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage($c) b)
print_byte: {
    .label b = $c
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
// Print a zero-terminated string
// print_str(byte* zeropage(5) str)
print_str: {
    .label str = 5
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
  print_hextab: .text "0123456789abcdef"
  swords: .word -$6fed, $12, $7fed
