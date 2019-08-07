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
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #2
    sta print_euclid.b
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #$80
    sta print_euclid.a
    jsr print_euclid
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #$45
    sta print_euclid.b
    lda #$a9
    sta print_euclid.a
    jsr print_euclid
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #$37
    sta print_euclid.b
    lda #$9b
    sta print_euclid.a
    jsr print_euclid
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #3
    sta print_euclid.b
    lda #$c7
    sta print_euclid.a
    jsr print_euclid
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #$1a
    sta print_euclid.b
    lda #$5b
    sta print_euclid.a
    jsr print_euclid
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #$bb
    sta print_euclid.b
    lda #$77
    sta print_euclid.a
    jsr print_euclid
    rts
}
// print_euclid(byte zeropage(2) a, byte zeropage(3) b)
print_euclid: {
    .label b = 3
    .label a = 2
    ldx a
    jsr print_byte
    lda #' '
    jsr print_char
    ldx b
    jsr print_byte
    lda #' '
    jsr print_char
    ldx b
    jsr euclid
    lda euclid.a
    tax
    jsr print_byte
    jsr print_ln
    rts
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
// euclid(byte zeropage(2) a, byte register(X) b)
euclid: {
    .label a = 2
  b1:
    cpx a
    bne b2
    rts
  b2:
    cpx a
    bcc b3
    txa
    sec
    sbc a
    tax
    jmp b1
  b3:
    txa
    eor #$ff
    sec
    adc a
    sta a
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
  print_hextab: .text "0123456789abcdef"
