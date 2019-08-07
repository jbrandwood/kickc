.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = $10
  .label print_char_cursor = 8
  .label print_line_cursor_9 = 6
  .label print_line_cursor_37 = 6
  .label print_char_cursor_74 = $10
  .label print_line_cursor_53 = 6
  .label print_line_cursor_54 = 6
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
    sta print_char_cursor_74
    lda #>$400
    sta print_char_cursor_74+1
    lda #<$400
    sta print_line_cursor_37
    lda #>$400
    sta print_line_cursor_37+1
    lda #<$12345678
    sta dw
    lda #>$12345678
    sta dw+1
    lda #<$12345678>>$10
    sta dw+2
    lda #>$12345678>>$10
    sta dw+3
  b2:
    lda dw+2
    sta _3
    lda dw+3
    sta _3+1
    clc
    lda _32
    adc #<$1111
    sta _32
    lda _32+1
    adc #>$1111
    sta _32+1
    lda dw
    sta dw2
    lda dw+1
    sta dw2+1
    lda _32
    sta dw2+2
    lda _32+1
    sta dw2+3
    lda dw
    sta _6
    lda dw+1
    sta _6+1
    clc
    lda _33
    adc #<$1111
    sta _33
    lda _33+1
    adc #>$1111
    sta _33+1
    lda _33
    sta dw2
    lda _33+1
    sta dw2+1
    jsr print_dword
    lda #' '
    jsr print_char
    lda dw2+2
    sta print_word.w
    lda dw2+3
    sta print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda dw2
    sta print_word.w
    lda dw2+1
    sta print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda dw2+2
    sta _16
    lda dw2+3
    sta _16+1
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda dw2+2
    sta _20
    lda dw2+3
    sta _20+1
    lda _20
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda dw2
    sta _24
    lda dw2+1
    sta _24+1
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda dw2
    sta _28
    lda dw2+1
    sta _28+1
    lda _28
    tax
    jsr print_byte
    jsr print_ln
    inc dw
    bne !+
    inc dw+1
    bne !+
    inc dw+2
    bne !+
    inc dw+3
  !:
    lda dw+3
    cmp #>$12345690>>$10
    bne b17
    lda dw+2
    cmp #<$12345690>>$10
    bne b17
    lda dw+1
    cmp #>$12345690
    bne b17
    lda dw
    cmp #<$12345690
    bne b17
    rts
  b17:
    lda print_line_cursor
    sta print_line_cursor_54
    lda print_line_cursor+1
    sta print_line_cursor_54+1
    jmp b2
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor_9
    sta print_line_cursor
    lda #0
    adc print_line_cursor_9+1
    sta print_line_cursor+1
    cmp print_char_cursor+1
    bcc b2
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b2
  !:
    rts
  b2:
    lda print_line_cursor
    sta print_line_cursor_53
    lda print_line_cursor+1
    sta print_line_cursor_53+1
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
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// Print a word as HEX
// print_word(word zeropage($e) w)
print_word: {
    .label w = $e
    lda w+1
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
    rts
}
// Print a dword as HEX
// print_dword(dword zeropage($a) dw)
print_dword: {
    .label dw = $a
    lda dw+2
    sta print_word.w
    lda dw+3
    sta print_word.w+1
    lda print_char_cursor_74
    sta print_char_cursor
    lda print_char_cursor_74+1
    sta print_char_cursor+1
    jsr print_word
    lda dw
    sta print_word.w
    lda dw+1
    sta print_word.w+1
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
