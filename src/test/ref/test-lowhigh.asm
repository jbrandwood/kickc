.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = $10
  .label print_char_cursor = 8
  .label print_char_cursor_31 = $10
  .label print_line_cursor_9 = 6
  .label print_line_cursor_15 = 6
  .label print_line_cursor_37 = 6
  .label print_line_cursor_38 = 6
main: {
    .label _3 = 8
    .label _6 = $e
    .label _16 = $10
    .label _20 = $12
    .label _24 = $14
    .label _28 = $16
    .label _32 = 8
    .label _33 = $e
    .label dw2 = $a
    .label dw = 2
    jsr print_cls
    lda #<$400
    sta.z print_char_cursor_31
    lda #>$400
    sta.z print_char_cursor_31+1
    lda #<$400
    sta.z print_line_cursor_15
    lda #>$400
    sta.z print_line_cursor_15+1
    lda #<$12345678
    sta.z dw
    lda #>$12345678
    sta.z dw+1
    lda #<$12345678>>$10
    sta.z dw+2
    lda #>$12345678>>$10
    sta.z dw+3
  b1:
    lda.z dw+3
    cmp #>$12345690>>$10
    bne b2
    lda.z dw+2
    cmp #<$12345690>>$10
    bne b2
    lda.z dw+1
    cmp #>$12345690
    bne b2
    lda.z dw
    cmp #<$12345690
    bne b2
    rts
  b2:
    lda.z dw+2
    sta.z _3
    lda.z dw+3
    sta.z _3+1
    clc
    lda.z _32
    adc #<$1111
    sta.z _32
    lda.z _32+1
    adc #>$1111
    sta.z _32+1
    lda.z dw
    sta.z dw2
    lda.z dw+1
    sta.z dw2+1
    lda.z _32
    sta.z dw2+2
    lda.z _32+1
    sta.z dw2+3
    lda.z dw
    sta.z _6
    lda.z dw+1
    sta.z _6+1
    clc
    lda.z _33
    adc #<$1111
    sta.z _33
    lda.z _33+1
    adc #>$1111
    sta.z _33+1
    lda.z _33
    sta.z dw2
    lda.z _33+1
    sta.z dw2+1
    jsr print_dword
    lda #' '
    jsr print_char
    lda.z dw2+2
    sta.z print_word.w
    lda.z dw2+3
    sta.z print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda.z dw2
    sta.z print_word.w
    lda.z dw2+1
    sta.z print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda.z dw2+2
    sta.z _16
    lda.z dw2+3
    sta.z _16+1
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda.z dw2+2
    sta.z _20
    lda.z dw2+3
    sta.z _20+1
    lda.z _20
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda.z dw2
    sta.z _24
    lda.z dw2+1
    sta.z _24+1
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda.z dw2
    sta.z _28
    lda.z dw2+1
    sta.z _28+1
    lda.z _28
    tax
    jsr print_byte
    jsr print_ln
    inc.z dw
    bne !+
    inc.z dw+1
    bne !+
    inc.z dw+2
    bne !+
    inc.z dw+3
  !:
    lda.z print_line_cursor
    sta.z print_line_cursor_38
    lda.z print_line_cursor+1
    sta.z print_line_cursor_38+1
    jmp b1
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc.z print_line_cursor_9
    sta.z print_line_cursor
    lda #0
    adc.z print_line_cursor_9+1
    sta.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc b2
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc b2
  !:
    rts
  b2:
    lda.z print_line_cursor
    sta.z print_line_cursor_37
    lda.z print_line_cursor+1
    sta.z print_line_cursor_37+1
    jmp b1
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
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
// Print a word as HEX
// print_word(word zeropage($e) w)
print_word: {
    .label w = $e
    lda.z w+1
    tax
    jsr print_byte
    lda.z w
    tax
    jsr print_byte
    rts
}
// Print a dword as HEX
// print_dword(dword zeropage($a) dw)
print_dword: {
    .label dw = $a
    lda.z dw+2
    sta.z print_word.w
    lda.z dw+3
    sta.z print_word.w+1
    lda.z print_char_cursor_31
    sta.z print_char_cursor
    lda.z print_char_cursor_31+1
    sta.z print_char_cursor+1
    jsr print_word
    lda.z dw
    sta.z print_word.w
    lda.z dw+1
    sta.z print_word.w+1
    jsr print_word
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
    .label dst = $10
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  b1:
    lda.z dst+1
    cmp #>end
    bne b2
    lda.z dst
    cmp #<end
    bne b2
    rts
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp b1
}
  print_hextab: .text "0123456789abcdef"
