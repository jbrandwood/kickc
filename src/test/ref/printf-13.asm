// Tests printf function call rewriting
// Print using different formats
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  // The default text color
  .const CONIO_TEXTCOLOR_DEFAULT = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // The screen width
  // The screen height
  // The screen bytes
  // The text screen address
  .label CONIO_SCREEN_TEXT = $400
  // The color screen address
  .label CONIO_SCREEN_COLORS = $d800
  .label conio_cursor_x = $10
  .label conio_cursor_y = $11
  .label conio_line_text = $12
  .label conio_line_color = $14
__bbegin:
  // conio_cursor_x = 0
  // The current cursor x-position
  lda #0
  sta.z conio_cursor_x
  // conio_cursor_y = 0
  // The current cursor y-position
  sta.z conio_cursor_y
  // conio_line_text = CONIO_SCREEN_TEXT
  // The current text cursor line start
  lda #<CONIO_SCREEN_TEXT
  sta.z conio_line_text
  lda #>CONIO_SCREEN_TEXT
  sta.z conio_line_text+1
  // conio_line_color = CONIO_SCREEN_COLORS
  // The current color cursor line start
  lda #<CONIO_SCREEN_COLORS
  sta.z conio_line_color
  lda #>CONIO_SCREEN_COLORS
  sta.z conio_line_color+1
  jsr main
  rts
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
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(2) s)
cputs: {
    .label s = 2
  __b1:
    // c=*s++
    ldy #0
    lda (s),y
    // while(c=*s++)
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
    lda #CONIO_TEXTCOLOR_DEFAULT
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
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y==CONIO_HEIGHT)
    lda #$19
    cmp.z conio_cursor_y
    bne __breturn
    // memcpy(CONIO_SCREEN_TEXT, CONIO_SCREEN_TEXT+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<CONIO_SCREEN_TEXT
    sta.z memcpy.destination
    lda #>CONIO_SCREEN_TEXT
    sta.z memcpy.destination+1
    lda #<CONIO_SCREEN_TEXT+$28
    sta.z memcpy.source
    lda #>CONIO_SCREEN_TEXT+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(CONIO_SCREEN_COLORS, CONIO_SCREEN_COLORS+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<CONIO_SCREEN_COLORS
    sta.z memcpy.destination
    lda #>CONIO_SCREEN_COLORS
    sta.z memcpy.destination+1
    lda #<CONIO_SCREEN_COLORS+$28
    sta.z memcpy.source
    lda #>CONIO_SCREEN_COLORS+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    ldx #' '
    lda #<CONIO_SCREEN_TEXT+$19*$28-$28
    sta.z memset.str
    lda #>CONIO_SCREEN_TEXT+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    ldx #CONIO_TEXTCOLOR_DEFAULT
    lda #<CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str
    lda #>CONIO_SCREEN_COLORS+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // conio_line_text -= CONIO_WIDTH
    lda.z conio_line_text
    sec
    sbc #<$28
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #>$28
    sta.z conio_line_text+1
    // conio_line_color -= CONIO_WIDTH
    lda.z conio_line_color
    sec
    sbc #<$28
    sta.z conio_line_color
    lda.z conio_line_color+1
    sbc #>$28
    sta.z conio_line_color+1
    // conio_cursor_y--;
    dec.z conio_cursor_y
  __breturn:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(9) str, byte register(X) c)
memset: {
    .label end = $16
    .label dst = 9
    .label str = 9
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
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($c) destination, void* zp(9) source)
memcpy: {
    .label src_end = $16
    .label dst = $c
    .label src = 9
    .label source = 9
    .label destination = $c
    // src_end = (char*)source+num
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
// Print an unsigned int using a specific format
// printf_uint(word zp(2) uvalue, byte zp($e) format_upper_case, byte register(X) format_radix)
printf_uint: {
    .label uvalue = 2
    .label format_upper_case = $e
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
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($b) buffer_sign, byte zp(8) format_min_length, byte zp($f) format_justify_left, byte zp(4) format_zero_padding, byte zp($e) format_upper_case)
printf_number_buffer: {
    .label __19 = $c
    .label buffer_sign = $b
    .label format_justify_left = $f
    .label format_zero_padding = 4
    .label format_upper_case = $e
    .label padding = 8
    .label format_min_length = 8
    // if(format.min_length)
    lda #0
    cmp.z format_min_length
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
    lda.z __19
    tax
    // if(buffer.sign)
    lda #0
    cmp.z buffer_sign
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
    lda #0
    cmp.z format_justify_left
    bne __b2
    cmp.z format_zero_padding
    bne __b2
    cmp.z padding
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
    lda #0
    cmp.z buffer_sign
    beq __b3
    // cputc(buffer.sign)
    lda.z buffer_sign
    jsr cputc
  __b3:
    // if(format.zero_padding && padding)
    lda #0
    cmp.z format_zero_padding
    beq __b4
    cmp.z padding
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
    lda #0
    cmp.z format_upper_case
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
    lda #0
    cmp.z format_justify_left
    beq __breturn
    cmp.z format_zero_padding
    bne __breturn
    cmp.z padding
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
// Print a padding char a number of times
// printf_padding(byte zp(6) pad, byte zp(5) length)
printf_padding: {
    .label i = 7
    .label length = 5
    .label pad = 6
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
// Converts a string to uppercase.
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = $c
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
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp(9) str)
strlen: {
    .label len = $c
    .label str = 9
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(2) value, byte* zp($c) buffer, byte register(X) radix)
utoa: {
    .label digit_value = $16
    .label buffer = $c
    .label digit = $b
    .label value = 2
    .label max_digits = 8
    .label digit_values = 9
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($c) buffer, word zp(2) value, word zp($16) sub)
utoa_append: {
    .label buffer = $c
    .label value = 2
    .label sub = $16
    .label return = 2
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
// Print a signed integer using a specific format
// printf_sint(signed word zp(2) value, byte zp($f) format_justify_left, byte register(X) format_sign_always, byte zp(4) format_zero_padding)
printf_sint: {
    .label value = 2
    .label format_justify_left = $f
    .label format_zero_padding = 4
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
// Print a string value using a specific format
// Handles justification and min length 
// printf_string(byte* zp(2) str, byte zp($e) format_justify_left)
printf_string: {
    .label __9 = $c
    .label padding = $f
    .label format_justify_left = $e
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
    clc
    adc #3+1
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
    lda #0
    sta.z padding
  __b1:
    // if(!format.justify_left && padding)
    lda #0
    cmp.z format_justify_left
    bne __b2
    cmp.z padding
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
    lda #0
    cmp.z format_justify_left
    beq __breturn
    cmp.z padding
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
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = $12
    .label line_cols = $14
    lda #<CONIO_SCREEN_COLORS
    sta.z line_cols
    lda #>CONIO_SCREEN_COLORS
    sta.z line_cols+1
    lda #<CONIO_SCREEN_TEXT
    sta.z line_text
    lda #>CONIO_SCREEN_TEXT
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
    lda #<CONIO_SCREEN_TEXT
    sta.z conio_line_text
    lda #>CONIO_SCREEN_TEXT
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS
    lda #<CONIO_SCREEN_COLORS
    sta.z conio_line_color
    lda #>CONIO_SCREEN_COLORS
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
    lda #CONIO_TEXTCOLOR_DEFAULT
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b3
}
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
