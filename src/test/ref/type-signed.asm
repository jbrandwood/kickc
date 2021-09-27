// Tests the special "signed" / "unsigned" without a simple type name
  // Commodore 64 PRG executable file
.file [name="type-signed.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label print_screen = $400
  .label print_line_cursor = 4
  .label print_char_cursor = 2
.segment Code
main: {
    .label a = 8
    .label b = $a
    .label i = $c
    lda #0
    sta.z i
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
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
    lda.z b
    clc
    adc #<$141
    sta.z b
    lda.z b+1
    adc #>$141
    sta.z b+1
    // print_sint(a)
    lda.z a
    sta.z print_sint.w
    lda.z a+1
    sta.z print_sint.w+1
    jsr print_sint
    // print_char(' ')
    lda #' '
    jsr print_char
    // print_uint(b)
    lda.z b
    sta.z print_uint.w
    lda.z b+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_ln()
    jsr print_ln
    // for( byte i : 0..5 )
    inc.z i
    lda #6
    cmp.z i
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
// Print a signed int as HEX
// void print_sint(__zp(6) int w)
print_sint: {
    .label w = 6
    // if(w<0)
    lda.z w+1
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_uint((unsigned int)w)
    jsr print_uint
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // w = -w
    lda #0
    sec
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
    jmp __b2
}
// Print a single char
// void print_char(__register(A) char ch)
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
// Print a unsigned int as HEX
// void print_uint(__zp(6) unsigned int w)
print_uint: {
    .label w = 6
    // print_uchar(BYTE1(w))
    ldx.z w+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
    // }
    rts
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
// Print a char as HEX
// void print_uchar(__register(X) char b)
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
.segment Data
  print_hextab: .text "0123456789abcdef"
