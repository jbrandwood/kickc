.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 2
main: {
    .label file = $4000
    .label uSize = 4
    lda #<4
    sta file
    lda #>4
    sta file+1
    ldy #$1e
    ldx file
    stx.z $fe
    tax
    stx.z $ff
    lda ($fe),y
    sta.z uSize
    iny
    lda ($fe),y
    sta.z uSize+1
    jsr print_word
    rts
}
// Print a word as HEX
// print_word(word zeropage(4) w)
print_word: {
    .label w = 4
    lda.z w+1
    tax
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
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
  print_hextab: .text "0123456789abcdef"
