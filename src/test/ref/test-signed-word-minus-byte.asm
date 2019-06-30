// Tests subtracting bytes from signed words
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = 4
  .label print_char_cursor = 8
main: {
    .label w2 = $d
    .label w1 = 2
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
    lda #<$4d2
    sta w1
    lda #>$4d2
    sta w1+1
  b1:
    lda w1
    sec
    sbc #$5b
    sta w2
    lda w1+1
    sbc #>$5b
    sta w2+1
    lda w2
    sec
    sbc #$29
    sta w1
    lda w2+1
    sbc #>$29
    sta w1+1
    lda w1
    sta print_sword.w
    lda w1+1
    sta print_sword.w+1
    jsr print_sword
    lda #' '
    jsr print_char
    lda w2
    sta print_sword.w
    lda w2+1
    sta print_sword.w+1
    jsr print_sword
    jsr print_ln
    inx
    cpx #$b
    bne b6
    rts
  b6:
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
// Print a signed word as HEX
// print_sword(signed word zeropage(6) w)
print_sword: {
    .label w = 6
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
// print_word(word zeropage(6) w)
print_word: {
    .label w = 6
    lda w+1
    sta print_byte.b
    jsr print_byte
    lda w
    sta print_byte.b
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage($a) b)
print_byte: {
    .label b = $a
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
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    .label sc = $b
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
