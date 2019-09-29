/*
 * Find greatest common denominator using subtraction-based Euclidian algorithm
 * See https://en.wikipedia.org/wiki/Euclidean_algorithm
 * Based on facebook post from
 */
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_line_cursor = 6
  .label print_char_cursor = 4
main: {
    jsr print_cls
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #2
    sta.z print_euclid.b
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #$80
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #$45
    sta.z print_euclid.b
    lda #$a9
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #$37
    sta.z print_euclid.b
    lda #$9b
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #3
    sta.z print_euclid.b
    lda #$c7
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #$1a
    sta.z print_euclid.b
    lda #$5b
    sta.z print_euclid.a
    jsr print_euclid
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #$bb
    sta.z print_euclid.b
    lda #$77
    sta.z print_euclid.a
    jsr print_euclid
    rts
}
// print_euclid(byte zeropage(2) a, byte zeropage(3) b)
print_euclid: {
    .label b = 3
    .label a = 2
    ldx.z a
    jsr print_byte
    lda #' '
    jsr print_char
    ldx.z b
    jsr print_byte
    lda #' '
    jsr print_char
    ldx.z b
    jsr euclid
    lda.z euclid.a
    tax
    jsr print_byte
    jsr print_ln
    rts
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
// euclid(byte zeropage(2) a, byte register(X) b)
euclid: {
    .label a = 2
  __b1:
    cpx.z a
    bne __b2
    rts
  __b2:
    cpx.z a
    bcc __b3
    txa
    sec
    sbc.z a
    tax
    jmp __b1
  __b3:
    txa
    eor #$ff
    sec
    adc.z a
    sta.z a
    jmp __b1
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
