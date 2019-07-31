.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = 8
  .label print_char_cursor = 6
main: {
    .label _2 = $a
    .label _5 = $10
    .label _15 = $12
    .label _19 = $14
    .label _23 = $16
    .label _27 = $18
    .label _32 = $a
    .label _33 = $10
    .label dw2 = $c
    .label dw = 2
    jsr print_cls
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<$12345678
    sta dw
    lda #>$12345678
    sta dw+1
    lda #<$12345678>>$10
    sta dw+2
    lda #>$12345678>>$10
    sta dw+3
  b1:
    lda dw+2
    sta _2
    lda dw+3
    sta _2+1
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
    sta _5
    lda dw+1
    sta _5+1
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
    sta _15
    lda dw2+3
    sta _15+1
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda dw2+2
    sta _19
    lda dw2+3
    sta _19+1
    lda _19
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda dw2
    sta _23
    lda dw2+1
    sta _23+1
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda dw2
    sta _27
    lda dw2+1
    sta _27+1
    lda _27
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
    bne b16
    lda dw+2
    cmp #<$12345690>>$10
    bne b16
    lda dw+1
    cmp #>$12345690
    bne b16
    lda dw
    cmp #<$12345690
    bne b16
    rts
  b16:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b1
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
// print_word(word zeropage($a) w)
print_word: {
    .label w = $a
    lda w+1
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
    rts
}
// Print a dword as HEX
// print_dword(dword zeropage($c) dw)
print_dword: {
    .label dw = $c
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
    .label dst = 8
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b1:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b1
    lda dst
    cmp #<end
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
