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
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<$1024
    sta.z b
    lda #>$1024
    sta.z b+1
    lda #<-$3ff
    sta.z a
    lda #>-$3ff
    sta.z a+1
  __b1:
    // a += -7
    lda.z a
    clc
    adc #<-7
    sta.z a
    lda.z a+1
    adc #>-7
    sta.z a+1
    // b += 321
    clc
    lda.z b
    adc #<$141
    sta.z b
    lda.z b+1
    adc #>$141
    sta.z b+1
    // print_sword(a)
    lda.z a
    sta.z print_sword.w
    lda.z a+1
    sta.z print_sword.w+1
    jsr print_sword
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_word(b)
    lda.z b
    sta.z print_word.w
    lda.z b+1
    sta.z print_word.w+1
    jsr print_word
    // print_ln()
    jsr print_ln
    // for( byte i : 0..5 )
    inx
    cpx #6
    bne __b6
    // }
    rts
  __b6:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Print a word as HEX
// print_word(word zp(8) w)
print_word: {
    .label w = 8
    // print_byte(>w)
    lda.z w+1
    sta.z print_byte.b
    jsr print_byte
    // print_byte(<w)
    lda.z w
    sta.z print_byte.b
    jsr print_byte
    // }
    rts
}
// Print a byte as HEX
// print_byte(byte zp($a) b)
print_byte: {
    .label b = $a
    // b>>4
    lda.z b
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
    and.z b
    // print_char(print_hextab[b&$f])
    tay
    lda print_hextab,y
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
// Print a signed word as HEX
// print_sword(signed word zp(8) w)
print_sword: {
    .label w = 8
    // if(w<0)
    lda.z w+1
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_word((word)w)
    jsr print_word
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // w = -w
    sec
    lda #0
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
    jmp __b2
}
  print_hextab: .text "0123456789abcdef"
