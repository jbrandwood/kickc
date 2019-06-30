// Tests the special "signed" / "unsigned" without a simple type name
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = 6
  .label print_char_cursor = $b
main: {
    .label a = 2
    .label b = 4
    ldx #0
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<$1024
    sta b
    lda #>$1024
    sta b+1
    lda #<-$3ff
    sta a
    lda #>-$3ff
    sta a+1
  b1:
    lda #-7
    sta $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta $ff
    clc
    lda a
    adc $fe
    sta a
    lda a+1
    adc $ff
    sta a+1
    clc
    lda b
    adc #<$141
    sta b
    lda b+1
    adc #>$141
    sta b+1
    lda a
    sta print_sword.w
    lda a+1
    sta print_sword.w+1
    jsr print_sword
    lda #' '
    jsr print_char
    lda b
    sta print_word.w
    lda b+1
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    inx
    cpx #6
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
// Print a word as HEX
// print_word(word zeropage(8) w)
print_word: {
    .label w = 8
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
// print_sword(signed word zeropage(8) w)
print_sword: {
    .label w = 8
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
  print_hextab: .text "0123456789abcdef"
