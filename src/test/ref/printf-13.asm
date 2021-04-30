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
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // Color Ram
  .label COLORRAM = $d800
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $14
  // The current cursor y-position
  .label conio_cursor_y = $15
  // The current text cursor line start
  .label conio_line_text = $16
  // The current color cursor line start
  .label conio_line_color = $18
.segment Code
__start: {
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
    // #pragma constructor_for(conio_c64_init, cputc, clrscr, cscroll)
    jsr conio_c64_init
    jsr main
    rts
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    // line = *BASIC_CURSOR_LINE
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
main: {
    // clrscr()
    jsr clrscr
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #'%'
    jsr cputc
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #'%'
    jsr cputc
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr cputc
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s10
    sta.z cputs.s
    lda #>s10
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #'%'
    jsr cputc
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #<s15
    sta.z cputs.s
    lda #>s15
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #'%'
    jsr cputc
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #<s20
    sta.z cputs.s
    lda #>s20
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr cputc
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #<s25
    sta.z cputs.s
    lda #>s25
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr cputc
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #<s30
    sta.z cputs.s
    lda #>s30
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr cputc
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #<s35
    sta.z cputs.s
    lda #>s35
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr cputc
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #<s40
    sta.z cputs.s
    lda #>s40
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
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
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
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
// gotoxy(byte register(X) y)
gotoxy: {
    .const x = 0
    .label __5 = $1e
    .label __6 = $1a
    .label __7 = $1a
    .label line_offset = $1a
    .label __8 = $1c
    .label __9 = $1a
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
    // (unsigned int)y*CONIO_WIDTH
    txa
    sta.z __7
    lda #0
    sta.z __7+1
    // line_offset = (unsigned int)y*CONIO_WIDTH
    lda.z __7
    asl
    sta.z __8
    lda.z __7+1
    rol
    sta.z __8+1
    asl.z __8
    rol.z __8+1
    lda.z __9
    clc
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
    clc
    lda.z line_offset
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
    clc
    lda.z __6
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
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte register(A) c)
cputc: {
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
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp(2) s)
cputs: {
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
    // cputc(c)
    jsr cputc
    jmp __b1
}
// Print a string value using a specific format
// Handles justification and min length 
// printf_string(byte* zp(2) str, byte zp(4) format_justify_left)
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
    // len = (signed char)strlen(str)
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
    // printf_padding(' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // cputs(str)
    jsr cputs
    // if(format.justify_left && padding)
    lda.z format_justify_left
    beq __breturn
    lda.z padding
    cmp #0
    bne __b5
    rts
  __b5:
    // printf_padding(' ',(char)padding)
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
// printf_sint(signed word zp(6) value, byte zp(4) format_justify_left, byte register(X) format_sign_always, byte zp(5) format_zero_padding)
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
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_upper_case
    lda #3
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // }
    rts
  __b1:
    // value = -value
    sec
    lda #0
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
// printf_uint(word zp(6) uvalue, byte zp(8) format_upper_case, byte register(X) format_radix)
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
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_zero_padding
    sta.z printf_number_buffer.format_justify_left
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
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
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($10) str)
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
// printf_padding(byte zp($b) pad, byte zp($a) length)
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
    // cputc(pad)
    lda.z pad
    jsr cputc
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(6) value, byte* zp($c) buffer, byte register(X) radix)
utoa: {
    .label digit_value = $20
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
    lda.z value
    tay
    lda DIGITS,y
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
    // digit_value = digit_values[digit]
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
// printf_number_buffer(byte zp($f) buffer_sign, byte zp($e) format_min_length, byte zp(4) format_justify_left, byte zp(5) format_zero_padding, byte zp(8) format_upper_case)
printf_number_buffer: {
    .label __19 = $c
    .label buffer_sign = $f
    .label format_justify_left = 4
    .label format_zero_padding = 5
    .label format_upper_case = 8
    .label padding = $e
    .label format_min_length = $e
    // if(format.min_length)
    lda.z format_min_length
    beq __b6
    // strlen(buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str+1
    jsr strlen
    // strlen(buffer.digits)
    // len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    ldx.z __19
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b13
    // len++;
    inx
  __b13:
    // padding = (signed char)format.min_length - len
    txa
    eor #$ff
    sec
    adc.z padding
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
    // printf_padding(' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b3
    // cputc(buffer.sign)
    jsr cputc
  __b3:
    // if(format.zero_padding && padding)
    lda.z format_zero_padding
    beq __b4
    lda.z padding
    cmp #0
    bne __b10
    jmp __b4
  __b10:
    // printf_padding('0',(char)padding)
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
    // cputs(buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s+1
    jsr cputs
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
    // printf_padding(' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __breturn:
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($c) buffer, word zp(6) value, word zp($20) sub)
utoa_append: {
    .label buffer = $c
    .label value = 6
    .label sub = $20
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
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = $10
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
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($12) destination, void* zp($10) source)
memcpy: {
    .label src_end = $20
    .label dst = $12
    .label src = $10
    .label source = $10
    .label destination = $12
    // src_end = (char*)source+num
    clc
    lda.z source
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
// memset(void* zp($12) str, byte register(X) c)
memset: {
    .label end = $20
    .label dst = $12
    .label str = $12
    // end = (char*)str + num
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
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// toupper(byte register(A) ch)
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
