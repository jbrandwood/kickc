.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const COUNT = $4000
  /* Up to what number? */
  .const SQRT_COUNT = $80
  /* Sqrt of COUNT */
  .label sieve = $1000
  .label print_char_cursor = 8
main: {
    .label i = 8
    .label sieve_i = $a
    .label j = 4
    .label s = 6
    .label i_3 = 2
    .label i_10 = 2
    .label _18 = $c
    jsr memset
    lda #<sieve+2
    sta sieve_i
    lda #>sieve+2
    sta sieve_i+1
    lda #<2
    sta i
    lda #>2
    sta i+1
  b1:
    lda i+1
    cmp #>SQRT_COUNT
    bcc b2
    bne !+
    lda i
    cmp #<SQRT_COUNT
    bcc b2
  !:
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<2
    sta i_10
    lda #>2
    sta i_10+1
  b7:
    lda i_10+1
    cmp #>$4c7
    bcc b8
    bne !+
    lda i_10
    cmp #<$4c7
    bcc b8
  !:
  b11:
    inc SCREEN+$3e7
    jmp b11
  b8:
    lda i_10
    clc
    adc #<sieve
    sta _18
    lda i_10+1
    adc #>sieve
    sta _18+1
    ldy #0
    lda (_18),y
    cmp #0
    bne b9
    jsr print_word
    lda #' '
    jsr print_char
  b9:
    inc i_3
    bne !+
    inc i_3+1
  !:
    jmp b7
  b2:
    ldy #0
    lda (sieve_i),y
    cmp #0
    bne b3
    lda i
    asl
    sta j
    lda i+1
    rol
    sta j+1
    lda j
    clc
    adc #<sieve
    sta s
    lda j+1
    adc #>sieve
    sta s+1
  b4:
    lda j+1
    cmp #>COUNT
    bcc b5
    bne !+
    lda j
    cmp #<COUNT
    bcc b5
  !:
  b3:
    inc i
    bne !+
    inc i+1
  !:
    inc sieve_i
    bne !+
    inc sieve_i+1
  !:
    jmp b1
  b5:
    lda #1
    ldy #0
    sta (s),y
    lda s
    clc
    adc i
    sta s
    lda s+1
    adc i+1
    sta s+1
    lda j
    clc
    adc i
    sta j
    lda j+1
    adc i+1
    sta j+1
    jmp b4
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
// print_word(word zeropage(2) w)
print_word: {
    .label w = 2
    lda w+1
    tax
    jsr print_byte
    lda w
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = 0
    .label str = sieve
    .label end = str+COUNT
    .label dst = $a
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b1:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    jmp b1
}
  print_hextab: .text "0123456789abcdef"
