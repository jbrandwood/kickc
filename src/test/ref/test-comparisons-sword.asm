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
  __b1:
    lda.z i
    asl
    tay
    lda swords,y
    sta.z w1
    lda swords+1,y
    sta.z w1+1
    lda #0
    sta.z j
  __b2:
    lda.z j
    asl
    tay
    lda swords,y
    sta.z w2
    lda swords+1,y
    sta.z w2+1
    ldx #0
  __b3:
    lda.z w1
    sta.z compare.w1
    lda.z w1+1
    sta.z compare.w1+1
    jsr compare
    inc.z s
    lda #3
    cmp.z s
    bne __b4
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #0
    sta.z s
  __b4:
    inx
    cpx #6
    bne __b3
    inc.z j
    lda #3
    cmp.z j
    bne __b2
    inc.z i
    cmp.z i
    bne __b1
  b1:
  // loop forever
    jmp b1
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
// Compare two words using an operator
// compare(signed word zp($a) w1, signed word zp($11) w2, byte register(X) op)
compare: {
    .label w1 = $a
    .label w2 = $11
    .label ops = 5
    .label r = 7
    cpx #LT
    bne !__b1+
    jmp __b1
  !__b1:
    cpx #LE
    bne !__b2+
    jmp __b2
  !__b2:
    cpx #GT
    bne !__b3+
    jmp __b3
  !__b3:
    cpx #GE
    beq __b4
    cpx #EQ
    beq __b5
    cpx #NE
    bne b2
    lda.z w1
    cmp.z w2
    bne !+
    lda.z w1+1
    cmp.z w2+1
    beq b1
  !:
    lda #TT
    sta.z r
    jmp __b19
  b1:
    lda #FF
    sta.z r
  __b19:
    lda #<ops_1
    sta.z ops
    lda #>ops_1
    sta.z ops+1
    jmp __b6
  b2:
    lda #FF
    sta.z r
    lda #<0
    sta.z ops
    sta.z ops+1
  __b6:
    jsr print_sword
    jsr print_str
    lda.z w2
    sta.z print_sword.w
    lda.z w2+1
    sta.z print_sword.w+1
    jsr print_sword
    lda.z r
    jsr print_char
    rts
  __b5:
    lda.z w1+1
    cmp.z w2+1
    bne b3
    lda.z w1
    cmp.z w2
    bne b3
    lda #TT
    sta.z r
    jmp __b20
  b3:
    lda #FF
    sta.z r
  __b20:
    lda #<ops_2
    sta.z ops
    lda #>ops_2
    sta.z ops+1
    jmp __b6
  __b4:
    lda.z w1
    cmp.z w2
    lda.z w1+1
    sbc.z w2+1
    bvc !+
    eor #$80
  !:
    bmi b4
  !e:
    lda #TT
    sta.z r
    jmp __b21
  b4:
    lda #FF
    sta.z r
  __b21:
    lda #<ops_3
    sta.z ops
    lda #>ops_3
    sta.z ops+1
    jmp __b6
  __b3:
    lda.z w2
    cmp.z w1
    lda.z w2+1
    sbc.z w1+1
    bvc !+
    eor #$80
  !:
    bpl b5
    lda #TT
    sta.z r
    jmp __b22
  b5:
    lda #FF
    sta.z r
  __b22:
    lda #<ops_4
    sta.z ops
    lda #>ops_4
    sta.z ops+1
    jmp __b6
  __b2:
    lda.z w2
    cmp.z w1
    lda.z w2+1
    sbc.z w1+1
    bvc !+
    eor #$80
  !:
    bmi b6
  !e:
    lda #TT
    sta.z r
    jmp __b23
  b6:
    lda #FF
    sta.z r
  __b23:
    lda #<ops_5
    sta.z ops
    lda #>ops_5
    sta.z ops+1
    jmp __b6
  __b1:
    lda.z w1
    cmp.z w2
    lda.z w1+1
    sbc.z w2+1
    bvc !+
    eor #$80
  !:
    bpl b7
    lda #TT
    sta.z r
    jmp __b24
  b7:
    lda #FF
    sta.z r
  __b24:
    lda #<ops_6
    sta.z ops
    lda #>ops_6
    sta.z ops+1
    jmp __b6
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
// print_sword(signed word zp($a) w)
print_sword: {
    .label w = $a
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
// print_word(word zp($a) w)
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
// print_byte(byte zp($c) b)
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
    .label dst = $d
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
  swords: .word -$6fed, $12, $7fed
