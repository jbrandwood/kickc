// Tests that signed indexed subtract works as intended
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = 2
  .label print_char_cursor = 7
main: {
    ldy #0
  b1:
    tya
    asl
    tax
    lda #$80
    jsr sub
    lda #$40
    jsr sub
    lda #$40
    jsr sub
    iny
    cpy #9
    bne b1
    jsr print_cls
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    ldx #0
  b3:
    txa
    asl
    tay
    lda words,y
    sta print_sword.w
    lda words+1,y
    sta print_sword.w+1
    jsr print_sword
    jsr print_ln
    inx
    cpx #9
    bne b9
    rts
  b9:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b3
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
// print_sword(signed word zeropage(4) w)
print_sword: {
    .label w = 4
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
// print_byte(byte zeropage(6) b)
print_byte: {
    .label b = 6
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
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    .label sc = 2
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
// sub(byte register(X) idx, byte register(A) s)
sub: {
    clc
    sbc words,x
    eor #$ff
    sta words,x
    bcc !+
    lda words+1,x
    sbc #1
    sta words+1,x
  !:
    rts
}
  print_hextab: .text "0123456789abcdef"
  words: .word -$6000, -$600, -$60, -6, 0, 6, $60, $600, $6000
