/// C standard library string.h
/// Functions to manipulate C strings and arrays.
  // Commodore 64 PRG executable file
.file [name="sieve-min.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const COUNT = $4000
  /* Up to what number? */
  .const SQRT_COUNT = $80
  .label SCREEN = $400
  /* Sqrt of COUNT */
  .label sieve = $1000
  .label print_screen = $400
  .label print_char_cursor = $a
.segment Code
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
    bne !+
    lda.z i
    cmp #SQRT_COUNT
    bcc __b2
  !:
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
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
    clc
    lda.z i_1
    adc #<sieve
    sta.z __16
    lda.z i_1+1
    adc #>sieve
    sta.z __16+1
    ldy #0
    lda (__16),y
    cmp #0
    bne __b9
    // print_uint(i)
    jsr print_uint
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
    // unsigned int j = i*2
    lda.z i
    asl
    sta.z j
    lda.z i+1
    rol
    sta.z j+1
    // unsigned char* s = &sieve[j]
    clc
    lda.z j
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = 0
    .label str = sieve
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
// Print a unsigned int as HEX
// print_uint(word zp(4) w)
print_uint: {
    .label w = 4
    // print_uchar(BYTE1(w))
    ldx.z w+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
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
.segment Data
  print_hextab: .text "0123456789abcdef"
