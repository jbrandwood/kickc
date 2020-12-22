// Tests printf function call rewriting
// A simple number - with the printf-sub funtions in the same file.
  // Commodore 64 PRG executable file
.file [name="printf-11.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = 4
.segment Code
main: {
    .label pct = $156
    // printf("Commodore is %x cool", pct)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<str
    sta.z cputs.str
    lda #>str
    sta.z cputs.str+1
    jsr cputs
    // printf("Commodore is %x cool", pct)
    jsr printf_uint
    // printf("Commodore is %x cool", pct)
    lda #<str1
    sta.z cputs.str
    lda #>str1
    sta.z cputs.str+1
    jsr cputs
    // }
    rts
  .segment Data
    str: .text "Commodore is "
    .byte 0
    str1: .text " cool"
    .byte 0
}
.segment Code
// cputs(byte* zp(2) str)
cputs: {
    .label str = 2
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
    lda printf_hextab+((>main.pct)&$f)
    ldy #0
    sta (screen),y
    // *screen++ = printf_hextab[(>uvalue)&0xf];
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *screen++ = printf_hextab[(<uvalue)>>4]
    lda printf_hextab+((<main.pct)>>4)
    ldy #0
    sta (screen),y
    // *screen++ = printf_hextab[(<uvalue)>>4];
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *screen++ = printf_hextab[(<uvalue)&0xf]
    lda printf_hextab+((<main.pct)&$f)
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
.segment Data
  printf_hextab: .text "0123456789abcdef"
