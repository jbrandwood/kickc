// Tests the different standard C types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = $a
  .label print_line_cursor = 2
main: {
    jsr print_cls
    jsr testChar
    jsr testShort
    jsr testInt
    jsr testLong
    rts
}
testLong: {
    .const u = $222e0
    .const n = -$222e0
    .const s = -$222e0
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<u
    sta print_dword.dw
    lda #>u
    sta print_dword.dw+1
    lda #<u>>$10
    sta print_dword.dw+2
    lda #>u>>$10
    sta print_dword.dw+3
    jsr print_dword
    lda #' '
    jsr print_char
    lda #<n
    sta print_sdword.dw
    lda #>n
    sta print_sdword.dw+1
    lda #<n>>$10
    sta print_sdword.dw+2
    lda #>n>>$10
    sta print_sdword.dw+3
    jsr print_sdword
    lda #' '
    jsr print_char
    lda #<s
    sta print_sdword.dw
    lda #>s
    sta print_sdword.dw+1
    lda #<s>>$10
    sta print_sdword.dw+2
    lda #>s>>$10
    sta print_sdword.dw+3
    jsr print_sdword
    jsr print_ln
    rts
    str: .text "long: @"
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
// Print a signed dword as HEX
// print_sdword(signed dword zeropage(4) dw)
print_sdword: {
    .label dw = 4
    lda dw+3
    bpl b1
    lda #'-'
    jsr print_char
    sec
    lda dw
    eor #$ff
    adc #0
    sta dw
    lda dw+1
    eor #$ff
    adc #0
    sta dw+1
    lda dw+2
    eor #$ff
    adc #0
    sta dw+2
    lda dw+3
    eor #$ff
    adc #0
    sta dw+3
  b1:
    jsr print_dword
    rts
}
// Print a dword as HEX
// print_dword(dword zeropage(4) dw)
print_dword: {
    .label dw = 4
    lda dw+2
    sta print_word.w
    lda dw+3
    sta print_word.w+1
    jsr print_word
    lda dw
    sta print_word.w
    lda dw+1
    sta print_word.w+1
    jsr print_word
    rts
}
// Print a word as HEX
// print_word(word zeropage(8) w)
print_word: {
    .label w = 8
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
    lda #$f
    axs #0
    lda print_hextab,x
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
// print_str(byte* zeropage($c) str)
print_str: {
    .label str = $c
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
testInt: {
    .const u = $578
    .const n = -$578
    .const s = -$578
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<u
    sta print_word.w
    lda #>u
    sta print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda #<n
    sta print_sword.w
    lda #>n
    sta print_sword.w+1
    jsr print_sword
    lda #' '
    jsr print_char
    lda #<s
    sta print_sword.w
    lda #>s
    sta print_sword.w+1
    jsr print_sword
    jsr print_ln
    rts
    str: .text "int: @"
}
// Print a signed word as HEX
// print_sword(signed word zeropage(8) w)
print_sword: {
    .label w = 8
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
testShort: {
    .const u = $578
    .const n = -$578
    .const s = -$578
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<u
    sta print_word.w
    lda #>u
    sta print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda #<n
    sta print_sword.w
    lda #>n
    sta print_sword.w+1
    jsr print_sword
    lda #' '
    jsr print_char
    lda #<s
    sta print_sword.w
    lda #>s
    sta print_sword.w+1
    jsr print_sword
    jsr print_ln
    rts
    str: .text "short: @"
}
testChar: {
    .const u = $e
    .const n = -$e
    .const s = -$e
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    ldx #u
    jsr print_byte
    lda #' '
    jsr print_char
    ldx #n
    jsr print_sbyte
    lda #' '
    jsr print_char
    ldx #s
    jsr print_sbyte
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    rts
    str: .text "char: @"
}
// Print a signed byte as HEX
// print_sbyte(signed byte register(X) b)
print_sbyte: {
    cpx #0
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_byte
    rts
  b1:
    lda #'-'
    jsr print_char
    txa
    eor #$ff
    clc
    adc #1
    tax
    jmp b2
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    .label sc = $e
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
