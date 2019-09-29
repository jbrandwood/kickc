// Tests the different standard C types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 6
  .label print_line_cursor = $a
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
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    lda #<u
    sta.z print_dword.dw
    lda #>u
    sta.z print_dword.dw+1
    lda #<u>>$10
    sta.z print_dword.dw+2
    lda #>u>>$10
    sta.z print_dword.dw+3
    jsr print_dword
    lda #' '
    jsr print_char
    lda #<n
    sta.z print_sdword.dw
    lda #>n
    sta.z print_sdword.dw+1
    lda #<n>>$10
    sta.z print_sdword.dw+2
    lda #>n>>$10
    sta.z print_sdword.dw+3
    jsr print_sdword
    lda #' '
    jsr print_char
    lda #<s
    sta.z print_sdword.dw
    lda #>s
    sta.z print_sdword.dw+1
    lda #<s>>$10
    sta.z print_sdword.dw+2
    lda #>s>>$10
    sta.z print_sdword.dw+3
    jsr print_sdword
    jsr print_ln
    rts
    str: .text "long: "
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
// Print a signed dword as HEX
// print_sdword(signed dword zeropage(2) dw)
print_sdword: {
    .label dw = 2
    lda.z dw+3
    bmi __b1
    lda #' '
    jsr print_char
  __b2:
    jsr print_dword
    rts
  __b1:
    lda #'-'
    jsr print_char
    sec
    lda.z dw
    eor #$ff
    adc #0
    sta.z dw
    lda.z dw+1
    eor #$ff
    adc #0
    sta.z dw+1
    lda.z dw+2
    eor #$ff
    adc #0
    sta.z dw+2
    lda.z dw+3
    eor #$ff
    adc #0
    sta.z dw+3
    jmp __b2
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
// Print a dword as HEX
// print_dword(dword zeropage(2) dw)
print_dword: {
    .label dw = 2
    lda.z dw+2
    sta.z print_word.w
    lda.z dw+3
    sta.z print_word.w+1
    jsr print_word
    lda.z dw
    sta.z print_word.w
    lda.z dw+1
    sta.z print_word.w+1
    jsr print_word
    rts
}
// Print a word as HEX
// print_word(word zeropage(8) w)
print_word: {
    .label w = 8
    lda.z w+1
    tax
    jsr print_byte
    lda.z w
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
// Print a zero-terminated string
// print_str(byte* zeropage(8) str)
print_str: {
    .label str = 8
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
testInt: {
    .const u = $578
    .const n = -$578
    .const s = -$578
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    lda #<u
    sta.z print_word.w
    lda #>u
    sta.z print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda #<n
    sta.z print_sword.w
    lda #>n
    sta.z print_sword.w+1
    jsr print_sword
    lda #' '
    jsr print_char
    lda #<s
    sta.z print_sword.w
    lda #>s
    sta.z print_sword.w+1
    jsr print_sword
    jsr print_ln
    rts
    str: .text "int: "
    .byte 0
}
// Print a signed word as HEX
// print_sword(signed word zeropage(8) w)
print_sword: {
    .label w = 8
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
testShort: {
    .const u = $578
    .const n = -$578
    .const s = -$578
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    lda #<u
    sta.z print_word.w
    lda #>u
    sta.z print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda #<n
    sta.z print_sword.w
    lda #>n
    sta.z print_sword.w+1
    jsr print_sword
    lda #' '
    jsr print_char
    lda #<s
    sta.z print_sword.w
    lda #>s
    sta.z print_sword.w+1
    jsr print_sword
    jsr print_ln
    rts
    str: .text "short: "
    .byte 0
}
testChar: {
    .const u = $e
    .const n = $e
    .label s = -$e
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    ldx #u
    jsr print_byte
    lda #' '
    jsr print_char
    ldx #n
    jsr print_byte
    lda #' '
    jsr print_char
    jsr print_sbyte
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    rts
    str: .text "char: "
    .byte 0
}
// Print a signed byte as HEX
print_sbyte: {
    .const b = -testChar.s
    lda #'-'
    jsr print_char
    ldx #b
    jsr print_byte
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
    .label dst = $a
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
