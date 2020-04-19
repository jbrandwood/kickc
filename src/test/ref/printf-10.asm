// Tests printf function call rewriting
// A simple string - with the printf-sub cuntions in the same file.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 2
main: {
    // printf("Hello, I am %s. who are you?", name)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
    jsr printf_str
    // printf("Hello, I am %s. who are you?", name)
    jsr printf_string
    // printf("Hello, I am %s. who are you?", name)
    lda #<str1
    sta.z printf_str.str
    lda #>str1
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
    name: .text "Jesper"
    .byte 0
    str: .text "Hello, I am "
    .byte 0
    str1: .text ". who are you?"
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
// Print a string value using a specific format
// Handles justification and min length
printf_string: {
    // printf_str(str)
    lda #<main.name
    sta.z printf_str.str
    lda #>main.name
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
}
