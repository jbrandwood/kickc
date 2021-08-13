// Tests printf function call rewriting
// Print using different formats
  // Commodore 64 PRG executable file
.file [name="printf-13.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const LIGHT_BLUE = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// Color Ram
  .label COLORRAM = $d800
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $12
  // The current cursor y-position
  .label conio_cursor_y = $13
  // The current text cursor line start
  .label conio_line_text = $14
  // The current color cursor line start
  .label conio_line_color = $16
.segment Code
__start: {
    // __ma char conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // __ma char conio_cursor_y = 0
    sta.z conio_cursor_y
    // __ma char *conio_line_text = CONIO_SCREEN_TEXT
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // __ma char *conio_line_color = CONIO_SCREEN_COLORS
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
    sta.z conio_line_color+1
    // #pragma constructor_for(conio_c64_init, cputc, clrscr, cscroll)
    jsr conio_c64_init
    jsr main
    rts
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    // char line = *BASIC_CURSOR_LINE
    ldx BASIC_CURSOR_LINE
    // if(line>=CONIO_HEIGHT)
    cpx #$19
    bcc __b1
    ldx #$19-1
  __b1:
    // gotoxy(0, line)
    jsr gotoxy
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__register(A) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    // if(c=='\n')
    cmp #'\n'
    beq __b1
    // conio_line_text[conio_cursor_x] = c
    ldy.z conio_cursor_x
    sta (conio_line_text),y
    // conio_line_color[conio_cursor_x] = conio_textcolor
    lda #LIGHT_BLUE
    sta (conio_line_color),y
    // if(++conio_cursor_x==CONIO_WIDTH)
    inc.z conio_cursor_x
    lda #$28
    cmp.z conio_cursor_x
    bne __breturn
    // cputln()
    jsr cputln
  __breturn:
    // }
    rts
  __b1:
    // cputln()
    jsr cputln
    rts
}
main: {
    // clrscr()
    jsr clrscr
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #'%'
    pha
    jsr cputc
    pla
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str
    sta.z printf_string.str
    lda #>str
    sta.z printf_string.str+1
    lda #0
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str1
    sta.z printf_string.str
    lda #>str1
    sta.z printf_string.str+1
    lda #0
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str2
    sta.z printf_string.str
    lda #>str2
    sta.z printf_string.str+1
    lda #0
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str3
    sta.z printf_string.str
    lda #>str3
    sta.z printf_string.str+1
    lda #0
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #'%'
    pha
    jsr cputc
    pla
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str
    sta.z printf_string.str
    lda #>str
    sta.z printf_string.str+1
    lda #1
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str1
    sta.z printf_string.str
    lda #>str1
    sta.z printf_string.str+1
    lda #1
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str2
    sta.z printf_string.str
    lda #>str2
    sta.z printf_string.str+1
    lda #1
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str3
    sta.z printf_string.str
    lda #>str3
    sta.z printf_string.str+1
    lda #1
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #'%'
    pha
    jsr cputc
    pla
    lda #<s10
    sta.z printf_str.s
    lda #>s10
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_justify_left
    tax
    lda #<1
    sta.z printf_sint.value
    txa
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_justify_left
    tax
    lda #<$b
    sta.z printf_sint.value
    lda #>$b
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_justify_left
    tax
    lda #<$6f
    sta.z printf_sint.value
    lda #>$6f
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_justify_left
    tax
    lda #<$457
    sta.z printf_sint.value
    lda #>$457
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #'%'
    pha
    jsr cputc
    pla
    lda #<s15
    sta.z printf_str.s
    lda #>s15
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #0
    sta.z printf_sint.format_zero_padding
    lda #1
    sta.z printf_sint.format_justify_left
    ldx #0
    lda #<-2
    sta.z printf_sint.value
    lda #>-2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #0
    sta.z printf_sint.format_zero_padding
    lda #1
    sta.z printf_sint.format_justify_left
    ldx #0
    lda #<-$16
    sta.z printf_sint.value
    lda #>-$16
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #0
    sta.z printf_sint.format_zero_padding
    lda #1
    sta.z printf_sint.format_justify_left
    ldx #0
    lda #<-$de
    sta.z printf_sint.value
    lda #>-$de
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #0
    sta.z printf_sint.format_zero_padding
    lda #1
    sta.z printf_sint.format_justify_left
    ldx #0
    lda #<-$8ae
    sta.z printf_sint.value
    lda #>-$8ae
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #'%'
    pha
    jsr cputc
    pla
    lda #<s20
    sta.z printf_str.s
    lda #>s20
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_justify_left
    ldx #1
    lda #<3
    sta.z printf_sint.value
    lda #>3
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_justify_left
    ldx #1
    lda #<-$2c
    sta.z printf_sint.value
    lda #>-$2c
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_justify_left
    ldx #1
    lda #<$22b
    sta.z printf_sint.value
    lda #>$22b
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_justify_left
    ldx #1
    lda #<-$1a0a
    sta.z printf_sint.value
    lda #>-$1a0a
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #'%'
    pha
    jsr cputc
    pla
    lda #<s25
    sta.z printf_str.s
    lda #>s25
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #1
    sta.z printf_sint.format_zero_padding
    lda #0
    sta.z printf_sint.format_justify_left
    tax
    lda #<1
    sta.z printf_sint.value
    txa
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #1
    sta.z printf_sint.format_zero_padding
    lda #0
    sta.z printf_sint.format_justify_left
    tax
    lda #<$b
    sta.z printf_sint.value
    lda #>$b
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #1
    sta.z printf_sint.format_zero_padding
    lda #0
    sta.z printf_sint.format_justify_left
    tax
    lda #<$6f
    sta.z printf_sint.value
    lda #>$6f
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_justify_left
    tax
    lda #<$457
    sta.z printf_sint.value
    lda #>$457
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #'%'
    pha
    jsr cputc
    pla
    lda #<s30
    sta.z printf_str.s
    lda #>s30
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_uint.format_upper_case
    ldx #OCTAL
    lda #<1
    sta.z printf_uint.uvalue
    lda #>1
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_uint.format_upper_case
    ldx #OCTAL
    lda #<$b
    sta.z printf_uint.uvalue
    lda #>$b
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_uint.format_upper_case
    ldx #OCTAL
    lda #<$6f
    sta.z printf_uint.uvalue
    lda #>$6f
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_uint.format_upper_case
    ldx #OCTAL
    lda #<$457
    sta.z printf_uint.uvalue
    lda #>$457
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #'%'
    pha
    jsr cputc
    pla
    lda #<s35
    sta.z printf_str.s
    lda #>s35
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_uint.format_upper_case
    ldx #HEXADECIMAL
    lda #<1
    sta.z printf_uint.uvalue
    lda #>1
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_uint.format_upper_case
    ldx #HEXADECIMAL
    lda #<$b
    sta.z printf_uint.uvalue
    lda #>$b
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_uint.format_upper_case
    ldx #HEXADECIMAL
    lda #<$6f
    sta.z printf_uint.uvalue
    lda #>$6f
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #0
    sta.z printf_uint.format_upper_case
    ldx #HEXADECIMAL
    lda #<$457
    sta.z printf_uint.uvalue
    lda #>$457
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #'%'
    pha
    jsr cputc
    pla
    lda #<s40
    sta.z printf_str.s
    lda #>s40
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #1
    sta.z printf_uint.format_upper_case
    ldx #HEXADECIMAL
    sta.z printf_uint.uvalue
    lda #>1
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #1
    sta.z printf_uint.format_upper_case
    ldx #HEXADECIMAL
    lda #<$b
    sta.z printf_uint.uvalue
    lda #>$b
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #1
    sta.z printf_uint.format_upper_case
    ldx #HEXADECIMAL
    lda #<$6f
    sta.z printf_uint.uvalue
    lda #>$6f
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #1
    sta.z printf_uint.format_upper_case
    ldx #HEXADECIMAL
    lda #<$457
    sta.z printf_uint.uvalue
    lda #>$457
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // }
    rts
  .segment Data
    s: .text "3s  '"
    .byte 0
    str: .text "x"
    .byte 0
    s1: .text "' '"
    .byte 0
    str1: .text "xx"
    .byte 0
    str2: .text "xxx"
    .byte 0
    str3: .text "xxxx"
    .byte 0
    s4: .text @"'\n"
    .byte 0
    s5: .text "-3s '"
    .byte 0
    s10: .text "3d  '"
    .byte 0
    s15: .text "-3d '"
    .byte 0
    s20: .text "+3d  '"
    .byte 0
    s25: .text "03d '"
    .byte 0
    s30: .text "o   '"
    .byte 0
    s35: .text "x   '"
    .byte 0
    s40: .text "X   '"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// void gotoxy(char x, __register(X) char y)
gotoxy: {
    .const x = 0
    .label __5 = $1c
    .label __6 = $18
    .label __7 = $18
    .label line_offset = $18
    .label __8 = $1a
    .label __9 = $18
    // if(y>CONIO_HEIGHT)
    cpx #$19+1
    bcc __b2
    ldx #0
  __b2:
    // conio_cursor_x = x
    lda #x
    sta.z conio_cursor_x
    // conio_cursor_y = y
    stx.z conio_cursor_y
    // unsigned int line_offset = (unsigned int)y*CONIO_WIDTH
    txa
    sta.z __7
    lda #0
    sta.z __7+1
    lda.z __7
    asl
    sta.z __8
    lda.z __7+1
    rol
    sta.z __8+1
    asl.z __8
    rol.z __8+1
    clc
    lda.z __9
    adc.z __8
    sta.z __9
    lda.z __9+1
    adc.z __8+1
    sta.z __9+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    // CONIO_SCREEN_TEXT + line_offset
    lda.z line_offset
    clc
    adc #<DEFAULT_SCREEN
    sta.z __5
    lda.z line_offset+1
    adc #>DEFAULT_SCREEN
    sta.z __5+1
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    lda.z __5
    sta.z conio_line_text
    lda.z __5+1
    sta.z conio_line_text+1
    // CONIO_SCREEN_COLORS + line_offset
    lda.z __6
    clc
    adc #<COLORRAM
    sta.z __6
    lda.z __6+1
    adc #>COLORRAM
    sta.z __6+1
    // conio_line_color = CONIO_SCREEN_COLORS + line_offset
    lda.z __6
    sta.z conio_line_color
    lda.z __6+1
    sta.z conio_line_color+1
    // }
    rts
}
// Print a newline
cputln: {
    // conio_line_text +=  CONIO_WIDTH
    lda #$28
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    // conio_line_color += CONIO_WIDTH
    lda #$28
    clc
    adc.z conio_line_color
    sta.z conio_line_color
    bcc !+
    inc.z conio_line_color+1
  !:
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y++;
    inc.z conio_cursor_y
    // cscroll()
    jsr cscroll
    // }
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 2
    .label line_cols = 6
    lda #<COLORRAM
    sta.z line_cols
    lda #>COLORRAM
    sta.z line_cols+1
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    ldx #0
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    cpx #$19
    bcc __b2
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
    sta.z conio_line_color+1
    // }
    rts
  __b2:
    ldy #0
  __b3:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    cpy #$28
    bcc __b4
    // line_text += CONIO_WIDTH
    lda #$28
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // line_cols += CONIO_WIDTH
    lda #$28
    clc
    adc.z line_cols
    sta.z line_cols
    bcc !+
    inc.z line_cols+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    inx
    jmp __b1
  __b4:
    // line_text[c] = ' '
    lda #' '
    sta (line_text),y
    // line_cols[c] = conio_textcolor
    lda #LIGHT_BLUE
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b3
}
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __zp(2) const char *s)
printf_str: {
    .label s = 2
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // putc(c)
    pha
    jsr cputc
    pla
    jmp __b1
}
// Print a string value using a specific format
// Handles justification and min length 
// void printf_string(void (*putc)(char), __zp(2) char *str, char format_min_length, __zp(4) char format_justify_left)
printf_string: {
    .label __9 = $c
    .label padding = 5
    .label format_justify_left = 4
    .label str = 2
    // strlen(str)
    lda.z str
    sta.z strlen.str
    lda.z str+1
    sta.z strlen.str+1
    jsr strlen
    // strlen(str)
    // signed char len = (signed char)strlen(str)
    lda.z __9
    // padding = (signed char)format.min_length  - len
    eor #$ff
    sec
    adc #3
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
    lda #0
    sta.z padding
  __b1:
    // if(!format.justify_left && padding)
    lda.z format_justify_left
    bne __b2
    lda.z padding
    cmp #0
    bne __b4
    jmp __b2
  __b4:
    // printf_padding(putc, ' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // printf_str(putc, str)
    jsr printf_str
    // if(format.justify_left && padding)
    lda.z format_justify_left
    beq __breturn
    lda.z padding
    cmp #0
    bne __b5
    rts
  __b5:
    // printf_padding(putc, ' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __breturn:
    // }
    rts
}
// Print a signed integer using a specific format
// void printf_sint(void (*putc)(char), __zp(6) int value, char format_min_length, __zp(4) char format_justify_left, __register(X) char format_sign_always, __zp(5) char format_zero_padding, char format_upper_case, char format_radix)
printf_sint: {
    .label value = 6
    .label format_justify_left = 4
    .label format_zero_padding = 5
    // printf_buffer.sign = 0
    // Handle any sign
    lda #0
    sta printf_buffer
    // if(value<0)
    lda.z value+1
    bmi __b1
    // if(format.sign_always)
    cpx #0
    beq __b2
    // printf_buffer.sign = '+'
    lda #'+'
    sta printf_buffer
  __b2:
    // utoa(uvalue, printf_buffer.digits, format.radix)
    ldx #DECIMAL
    jsr utoa
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_upper_case
    ldx #3
    jsr printf_number_buffer
    // }
    rts
  __b1:
    // value = -value
    lda #0
    sec
    sbc.z value
    sta.z value
    lda #0
    sbc.z value+1
    sta.z value+1
    // printf_buffer.sign = '-'
    lda #'-'
    sta printf_buffer
    jmp __b2
}
// Print an unsigned int using a specific format
// void printf_uint(void (*putc)(char), __zp(6) unsigned int uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, __zp(8) char format_upper_case, __register(X) char format_radix)
printf_uint: {
    .label uvalue = 6
    .label format_upper_case = 8
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr utoa
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_zero_padding
    sta.z printf_number_buffer.format_justify_left
    tax
    jsr printf_number_buffer
    // }
    rts
}
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y==CONIO_HEIGHT)
    lda #$19
    cmp.z conio_cursor_y
    bne __breturn
    // memcpy(CONIO_SCREEN_TEXT, CONIO_SCREEN_TEXT+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<DEFAULT_SCREEN
    sta.z memcpy.destination
    lda #>DEFAULT_SCREEN
    sta.z memcpy.destination+1
    lda #<DEFAULT_SCREEN+$28
    sta.z memcpy.source
    lda #>DEFAULT_SCREEN+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(CONIO_SCREEN_COLORS, CONIO_SCREEN_COLORS+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<COLORRAM
    sta.z memcpy.destination
    lda #>COLORRAM
    sta.z memcpy.destination+1
    lda #<COLORRAM+$28
    sta.z memcpy.source
    lda #>COLORRAM+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    ldx #' '
    lda #<DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str
    lda #>DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    ldx #LIGHT_BLUE
    lda #<COLORRAM+$19*$28-$28
    sta.z memset.str
    lda #>COLORRAM+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // conio_line_text -= CONIO_WIDTH
    sec
    lda.z conio_line_text
    sbc #$28
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    // conio_line_color -= CONIO_WIDTH
    sec
    lda.z conio_line_color
    sbc #$28
    sta.z conio_line_color
    lda.z conio_line_color+1
    sbc #0
    sta.z conio_line_color+1
    // conio_cursor_y--;
    dec.z conio_cursor_y
  __breturn:
    // }
    rts
}
// Computes the length of the string str up to but not including the terminating null character.
// __zp($c) unsigned int strlen(__zp($10) char *str)
strlen: {
    .label len = $c
    .label str = $10
    .label return = $c
    lda #<0
    sta.z len
    sta.z len+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // len++;
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a padding char a number of times
// void printf_padding(void (*putc)(char), __zp($b) char pad, __zp($a) char length)
printf_padding: {
    .label i = 9
    .label length = $a
    .label pad = $b
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<length; i++)
    lda.z i
    cmp.z length
    bcc __b2
    // }
    rts
  __b2:
    // putc(pad)
    lda.z pad
    pha
    jsr cputc
    pla
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__zp(6) unsigned int value, __zp($c) char *buffer, __register(X) char radix)
utoa: {
    .label digit_value = $1e
    .label buffer = $c
    .label digit = $b
    .label value = 6
    .label max_digits = $a
    .label digit_values = $10
    // if(radix==DECIMAL)
    cpx #DECIMAL
    beq __b2
    // if(radix==HEXADECIMAL)
    cpx #HEXADECIMAL
    beq __b3
    // if(radix==OCTAL)
    cpx #OCTAL
    beq __b4
    // if(radix==BINARY)
    cpx #BINARY
    beq __b5
    // *buffer++ = 'e'
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // }
    rts
  __b2:
    lda #<RADIX_DECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES
    sta.z digit_values+1
    lda #5
    sta.z max_digits
    jmp __b1
  __b3:
    lda #<RADIX_HEXADECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES
    sta.z digit_values+1
    lda #4
    sta.z max_digits
    jmp __b1
  __b4:
    lda #<RADIX_OCTAL_VALUES
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES
    sta.z digit_values+1
    lda #6
    sta.z max_digits
    jmp __b1
  __b5:
    lda #<RADIX_BINARY_VALUES
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES
    sta.z digit_values+1
    lda #$10
    sta.z max_digits
  __b1:
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b6:
    // max_digits-1
    lda.z max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    cmp.z digit
    beq !+
    bcs __b7
  !:
    // *buffer++ = DIGITS[(char)value]
    ldx.z value
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    lda #0
    tay
    sta (buffer),y
    rts
  __b7:
    // unsigned int digit_value = digit_values[digit]
    lda.z digit
    asl
    tay
    lda (digit_values),y
    sta.z digit_value
    iny
    lda (digit_values),y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    cpx #0
    bne __b10
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b10
  !:
    bcc __b10
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b6
  __b10:
    // utoa_append(buffer++, value, digit_value)
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    ldx #1
    jmp __b9
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __zp($e) char buffer_sign, char *buffer_digits, __register(X) char format_min_length, __zp(4) char format_justify_left, char format_sign_always, __zp(5) char format_zero_padding, __zp(8) char format_upper_case, char format_radix)
printf_number_buffer: {
    .label __19 = $c
    .label buffer_sign = $e
    .label format_justify_left = 4
    .label format_zero_padding = 5
    .label format_upper_case = 8
    .label padding = $f
    // if(format.min_length)
    cpx #0
    beq __b6
    // strlen(buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str+1
    jsr strlen
    // strlen(buffer.digits)
    // signed char len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    ldy.z __19
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b13
    // len++;
    iny
  __b13:
    // padding = (signed char)format.min_length - len
    txa
    sty.z $ff
    sec
    sbc.z $ff
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
  __b6:
    lda #0
    sta.z padding
  __b1:
    // if(!format.justify_left && !format.zero_padding && padding)
    lda.z format_justify_left
    bne __b2
    lda.z format_zero_padding
    bne __b2
    lda.z padding
    cmp #0
    bne __b8
    jmp __b2
  __b8:
    // printf_padding(putc, ' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b3
    // putc(buffer.sign)
    pha
    jsr cputc
    pla
  __b3:
    // if(format.zero_padding && padding)
    lda.z format_zero_padding
    beq __b4
    lda.z padding
    cmp #0
    bne __b10
    jmp __b4
  __b10:
    // printf_padding(putc, '0',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #'0'
    sta.z printf_padding.pad
    jsr printf_padding
  __b4:
    // if(format.upper_case)
    lda.z format_upper_case
    beq __b5
    // strupr(buffer.digits)
    jsr strupr
  __b5:
    // printf_str(putc, buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s+1
    jsr printf_str
    // if(format.justify_left && !format.zero_padding && padding)
    lda.z format_justify_left
    beq __breturn
    lda.z format_zero_padding
    bne __breturn
    lda.z padding
    cmp #0
    bne __b12
    rts
  __b12:
    // printf_padding(putc, ' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __breturn:
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(__zp($20) void *destination, __zp($10) void *source, unsigned int num)
memcpy: {
    .label src_end = $1e
    .label dst = $20
    .label src = $10
    .label source = $10
    .label destination = $20
    // char* src_end = (char*)source+num
    lda.z source
    clc
    adc #<$19*$28-$28
    sta.z src_end
    lda.z source+1
    adc #>$19*$28-$28
    sta.z src_end+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    // }
    rts
  __b2:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp($10) void *str, __register(X) char c, unsigned int num)
memset: {
    .label end = $20
    .label dst = $10
    .label str = $10
    // char* end = (char*)str + num
    lda #$28
    clc
    adc.z str
    sta.z end
    lda #0
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __zp(6) unsigned int utoa_append(__zp($c) char *buffer, __zp(6) unsigned int value, __zp($1e) unsigned int sub)
utoa_append: {
    .label buffer = $c
    .label value = 6
    .label sub = $1e
    .label return = 6
    ldx #0
  __b1:
    // while (value >= sub)
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    // *buffer = DIGITS[digit]
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inx
    // value -= sub
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    jmp __b1
}
// Converts a string to uppercase.
// char * strupr(char *str)
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = $20
    lda #<str
    sta.z src
    lda #>str
    sta.z src+1
  __b1:
    // while(*src)
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // toupper(*src)
    ldy #0
    lda (src),y
    jsr toupper
    // *src = toupper(*src)
    ldy #0
    sta (src),y
    // src++;
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// __register(A) char toupper(__register(A) char ch)
toupper: {
    // if(ch>='a' && ch<='z')
    cmp #'a'
    bcc __breturn
    cmp #'z'
    bcc __b1
    beq __b1
    rts
  __b1:
    // return ch + ('A'-'a');
    clc
    adc #'A'-'a'
  __breturn:
    // }
    rts
}
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of binary digits
  RADIX_BINARY_VALUES: .word $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES: .word $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
