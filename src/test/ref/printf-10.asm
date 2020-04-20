// Tests printf function call rewriting
// A simple string - with the printf-sub cuntions in the same file.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 2
main: {
    .label age = $2e
    // printf("Hello, I am %s. who are you?", "Jesper")
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("Hello, I am %s. who are you?", "Jesper")
    jsr printf_string
    // printf("Hello, I am %s. who are you?", "Jesper")
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("I am %x years old", age)
    lda #<str3
    sta.z printf_str.str
    lda #>str3
    sta.z printf_str.str+1
    jsr printf_str
    // printf("I am %x years old", age)
    jsr printf_uint
    // printf("I am %x years old", age)
    lda #<str4
    sta.z printf_str.str
    lda #>str4
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
    str: .text "Hello, I am "
    .byte 0
    str1: .text "Jesper"
    .byte 0
    str2: .text ". who are you?"
    .byte 0
    str3: .text "I am "
    .byte 0
    str4: .text " years old"
    .byte 0
}
// printf_str(byte* zp(4) str)
printf_str: {
    .label str = 4
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *screen++ = *str++
    ldy #0
    lda (str),y
    sta (screen),y
    // *screen++ = *str++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print an unsigned int using a specific format
// Always prints hexadecimals - ignores min_length and flags
printf_uint: {
    // *screen++ = printf_hextab[(>uvalue)>>4]
    lda printf_hextab
    ldy #0
    sta (screen),y
    // *screen++ = printf_hextab[(>uvalue)>>4];
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *screen++ = printf_hextab[(>uvalue)&0xf]
    lda printf_hextab
    ldy #0
    sta (screen),y
    // *screen++ = printf_hextab[(>uvalue)&0xf];
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *screen++ = printf_hextab[(<uvalue)>>4]
    lda printf_hextab+((<main.age)>>4)
    ldy #0
    sta (screen),y
    // *screen++ = printf_hextab[(<uvalue)>>4];
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *screen++ = printf_hextab[(<uvalue)&0xf]
    lda printf_hextab+((<main.age)&$f)
    ldy #0
    sta (screen),y
    // *screen++ = printf_hextab[(<uvalue)&0xf];
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // }
    rts
}
// Print a string value using a specific format
// Handles justification and min length
printf_string: {
    // printf_str(str)
    lda #<main.str1
    sta.z printf_str.str
    lda #>main.str1
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
}
  printf_hextab: .text "0123456789abcdef"
