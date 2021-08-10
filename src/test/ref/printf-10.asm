// Tests printf function call rewriting
// A simple string - with the printf-sub cuntions in the same file.
  // Commodore 64 PRG executable file
.file [name="printf-10.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = 2
.segment Code
main: {
    // printf("Hello, I am %s. who are you?", name)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<str
    sta.z cputs.str
    lda #>str
    sta.z cputs.str+1
    jsr cputs
    // printf("Hello, I am %s. who are you?", name)
    jsr printf_string
    // printf("Hello, I am %s. who are you?", name)
    lda #<str1
    sta.z cputs.str
    lda #>str1
    sta.z cputs.str+1
    jsr cputs
    // }
    rts
  .segment Data
    name: .text "Jesper"
    .byte 0
    str: .text "Hello, I am "
    .byte 0
    str1: .text ". who are you?"
    .byte 0
}
.segment Code
// void cputs(__zp(4) char *str)
cputs: {
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
// void printf_string(char *str, char format_min_length, char format_justify_left)
printf_string: {
    // cputs(str)
    lda #<main.name
    sta.z cputs.str
    lda #>main.name
    sta.z cputs.str+1
    jsr cputs
    // }
    rts
}
