// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_screen = $400
  .label print_char_cursor = 2
main: {
    .label file = $4000
    .label uSize = 4
    // file->bufEdit = 4
    lda #<4
    sta file
    lda #>4
    sta file+1
    // uSize = *ptrw
    ldy #$1e
    lda file
    sta.z $fe
    lda file+1
    sta.z $ff
    lda ($fe),y
    sta.z uSize
    iny
    lda ($fe),y
    sta.z uSize+1
    // print_uint(uSize)
    jsr print_uint
    // }
    rts
}
// Print a unsigned int as HEX
// print_uint(word zp(4) w)
print_uint: {
    .label w = 4
    // print_uchar(>w)
    ldx.z w+1
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    jsr print_uchar
    // print_uchar(<w)
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Print a char as HEX
// print_uchar(byte register(X) b)
print_uchar: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
  // Table of hexadecimal digits
    jsr print_char
    // b&$f
    lda #$f
    axs #0
    // print_char(print_hextab[b&$f])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
  print_hextab: .text "0123456789abcdef"
