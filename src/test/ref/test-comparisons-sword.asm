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
  .label print_char_cursor = $c
  .label print_line_cursor = 5
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
    lda s
    cmp #3
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
    lda j
    cmp #3
    bne b2
    inc i
    lda i
    cmp #3
    bne b1
  b6:
    jmp b6
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
// Compare two words using an operator
// compare(signed word zeropage($a) w1, signed word zeropage($11) w2, byte register(X) op)
compare: {
    .label w1 = $a
    .label w2 = $11
    .label ops = 7
    .label r = 9
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
    bne b8
    lda w1
    cmp w2
    bne !+
    lda w1+1
    cmp w2+1
    beq b6
  !:
    lda #TT
    sta r
    jmp b7
  b6:
    lda #FF
    sta r
  b7:
    lda #<ops_1
    sta ops
    lda #>ops_1
    sta ops+1
    jmp b16
  b8:
    lda #FF
    sta r
    lda #<0
    sta ops
    sta ops+1
  b16:
    lda w1+1
    bmi b18
    lda #' '
    jsr print_char
  b18:
    jsr print_sword
    jsr print_str
    lda w2+1
    bmi b19
    lda #' '
    jsr print_char
  b19:
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
    bne b10
    lda w1
    cmp w2
    bne b10
    lda #TT
    sta r
    jmp b9
  b10:
    lda #FF
    sta r
  b9:
    lda #<ops_2
    sta ops
    lda #>ops_2
    sta ops+1
    jmp b16
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
    jmp b11
  b12:
    lda #FF
    sta r
  b11:
    lda #<ops_3
    sta ops
    lda #>ops_3
    sta ops+1
    jmp b16
  b3:
    lda w2
    cmp w1
    lda w2+1
    sbc w1+1
    bvc !+
    eor #$80
  !:
    bpl b14
    lda #TT
    sta r
    jmp b13
  b14:
    lda #FF
    sta r
  b13:
    lda #<ops_4
    sta ops
    lda #>ops_4
    sta ops+1
    jmp b16
  b2:
    lda w1
    cmp w2
    lda w1+1
    sbc w2+1
    bvc !+
    eor #$80
  !:
    beq !e+
    bpl b20
  !e:
    lda #TT
    sta r
    jmp b15
  b20:
    lda #FF
    sta r
  b15:
    lda #<ops_5
    sta ops
    lda #>ops_5
    sta ops+1
    jmp b16
  b1:
    lda w1
    cmp w2
    lda w1+1
    sbc w2+1
    bvc !+
    eor #$80
  !:
    bpl b21
    lda #TT
    sta r
    jmp b17
  b21:
    lda #FF
    sta r
  b17:
    lda #<ops_6
    sta ops
    lda #>ops_6
    sta ops+1
    jmp b16
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
    bpl b1
    lda #'-'
    jsr print_char
    sec
    lda w
    eor #$ff
    adc #0
    sta w
    lda w+1
    eor #$ff
    adc #0
    sta w+1
  b1:
    jsr print_word
    rts
}
// Print a word as HEX
print_word: {
    lda print_sword.w+1
    sta print_byte.b
    jsr print_byte
    lda print_sword.w
    sta print_byte.b
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage($e) b)
print_byte: {
    .label b = $e
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
// print_str(byte* zeropage(7) str)
print_str: {
    .label str = 7
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
    .label sc = 5
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
  swords: .word -$6fed, $12, $7fed