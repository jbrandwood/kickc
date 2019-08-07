.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 4
  .label print_line_cursor = 6
main: {
    jsr print_cls
    ldx #0
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
  b1:
    jsr print_str
    jsr print_ln
    lda txt+1
    clc
    adc #1
    sta txt+1
    inx
    cpx #$b
    bne b4
    rts
  b4:
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
// Print a zero-terminated string
// print_str(byte* zeropage(2) str)
print_str: {
    .label str = 2
    lda #<txt
    sta str
    lda #>txt
    sta str+1
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
    .label dst = 6
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
  txt: .text "camelot"
  .byte 0
