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
    .label sieve_i = $a
    .label j = 2
    .label s = 4
    .label i = 6
    .label i_12 = 8
    .label _19 = $c
    .label i_17 = 8
    jsr memset
    lda #<sieve+2
    sta.z sieve_i
    lda #>sieve+2
    sta.z sieve_i+1
    lda #<2
    sta.z i_17
    lda #>2
    sta.z i_17+1
  b2:
    ldy #0
    lda (sieve_i),y
    cmp #0
    bne b3
    lda.z i_17
    asl
    sta.z j
    lda.z i_17+1
    rol
    sta.z j+1
    lda.z j
    clc
    adc #<sieve
    sta.z s
    lda.z j+1
    adc #>sieve
    sta.z s+1
  b4:
    lda.z j+1
    cmp #>COUNT
    bcc b5
    bne !+
    lda.z j
    cmp #<COUNT
    bcc b5
  !:
  b3:
    inc.z i_12
    bne !+
    inc.z i_12+1
  !:
    inc.z sieve_i
    bne !+
    inc.z sieve_i+1
  !:
    lda.z i_12+1
    cmp #>SQRT_COUNT
    bcc b2
    bne !+
    lda.z i_12
    cmp #<SQRT_COUNT
    bcc b2
  !:
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<2
    sta.z i
    lda #>2
    sta.z i+1
  b8:
    lda.z i
    clc
    adc #<sieve
    sta.z _19
    lda.z i+1
    adc #>sieve
    sta.z _19+1
    ldy #0
    lda (_19),y
    cmp #0
    bne b9
    jsr print_word
    lda #' '
    jsr print_char
  b9:
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$4c7
    bcc b8
    bne !+
    lda.z i
    cmp #<$4c7
    bcc b8
  !:
  b11:
    inc SCREEN+$3e7
    jmp b11
  b5:
    lda #1
    ldy #0
    sta (s),y
    lda.z s
    clc
    adc.z i_17
    sta.z s
    lda.z s+1
    adc.z i_17+1
    sta.z s+1
    lda.z j
    clc
    adc.z i_17
    sta.z j
    lda.z j+1
    adc.z i_17+1
    sta.z j+1
    jmp b4
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
// print_word(word zeropage(6) w)
print_word: {
    .label w = 6
    lda.z w+1
    tax
    jsr print_byte
    lda.z w
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
    sta.z dst
    lda #>str
    sta.z dst+1
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    lda.z dst+1
    cmp #>end
    bne b2
    lda.z dst
    cmp #<end
    bne b2
    rts
}
  print_hextab: .text "0123456789abcdef"
