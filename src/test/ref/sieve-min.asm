.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const COUNT = $4000
  /* Up to what number? */
  .const SQRT_COUNT = $80
  /* Sqrt of COUNT */
  .label sieve = $1000
  .label print_char_cursor = $a
main: {
    .label i = $a
    .label sieve_i = 2
    .label j = 6
    .label s = 8
    .label i_1 = 4
    .label __16 = $c
    // memset(sieve, 0, COUNT)
  // Fill sieve with zeros
    jsr memset
    lda #<sieve+2
    sta.z sieve_i
    lda #>sieve+2
    sta.z sieve_i+1
    lda #<2
    sta.z i
    lda #>2
    sta.z i+1
  __b1:
    // while (i < SQRT_COUNT)
    lda.z i+1
    cmp #>SQRT_COUNT
    bcc __b2
    bne !+
    lda.z i
    cmp #<SQRT_COUNT
    bcc __b2
  !:
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<2
    sta.z i_1
    lda #>2
    sta.z i_1+1
  __b7:
    // for (i = 2; i < 0x04c7; ++i)
    lda.z i_1+1
    cmp #>$4c7
    bcc __b8
    bne !+
    lda.z i_1
    cmp #<$4c7
    bcc __b8
  !:
  __b11:
    // (*(SCREEN+999))++;
    inc SCREEN+$3e7
    jmp __b11
  __b8:
    // if (!sieve[i])
    lda.z i_1
    clc
    adc #<sieve
    sta.z __16
    lda.z i_1+1
    adc #>sieve
    sta.z __16+1
    ldy #0
    lda (__16),y
    cmp #0
    bne __b9
    // print_word(i)
    jsr print_word
    // print_char(' ')
    lda #' '
    jsr print_char
  __b9:
    // for (i = 2; i < 0x04c7; ++i)
    inc.z i_1
    bne !+
    inc.z i_1+1
  !:
    jmp __b7
  __b2:
    // if (!*sieve_i)
    ldy #0
    lda (sieve_i),y
    cmp #0
    bne __b3
    // j = i*2
    lda.z i
    asl
    sta.z j
    lda.z i+1
    rol
    sta.z j+1
    // s = &sieve[j]
    lda.z j
    clc
    adc #<sieve
    sta.z s
    lda.z j+1
    adc #>sieve
    sta.z s+1
  __b4:
    // while (j < COUNT)
    lda.z j+1
    cmp #>COUNT
    bcc __b5
    bne !+
    lda.z j
    cmp #<COUNT
    bcc __b5
  !:
  __b3:
    // i++;
    inc.z i
    bne !+
    inc.z i+1
  !:
    // sieve_i++;
    inc.z sieve_i
    bne !+
    inc.z sieve_i+1
  !:
    jmp __b1
  __b5:
    // *s = 1
    lda #1
    ldy #0
    sta (s),y
    // s += i
    lda.z s
    clc
    adc.z i
    sta.z s
    lda.z s+1
    adc.z i+1
    sta.z s+1
    // j += i
    lda.z j
    clc
    adc.z i
    sta.z j
    lda.z j+1
    adc.z i+1
    sta.z j+1
    jmp __b4
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
// Print a word as HEX
// print_word(word zp(4) w)
print_word: {
    .label w = 4
    // print_byte(>w)
    lda.z w+1
    tax
    jsr print_byte
    // print_byte(<w)
    lda.z w
    tax
    jsr print_byte
    // }
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .label str = sieve
    .const c = 0
    .label end = str+COUNT
    .label dst = $c
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
  print_hextab: .text "0123456789abcdef"
