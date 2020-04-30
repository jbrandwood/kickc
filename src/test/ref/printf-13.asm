// Tests printf function call rewriting
// Print using different formats
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .label printf_cursor_x = $10
  .label printf_cursor_y = $11
  .label printf_cursor_ptr = $12
__bbegin:
  // printf_cursor_x = 0
  // X-position of cursor
  lda #0
  sta.z printf_cursor_x
  // printf_cursor_y = 0
  // Y-position of cursor
  sta.z printf_cursor_y
  // printf_cursor_ptr = PRINTF_SCREEN_ADDRESS
  // Pointer to cursor address
  lda #<$400
  sta.z printf_cursor_ptr
  lda #>$400
  sta.z printf_cursor_ptr+1
  jsr main
  rts
main: {
    // printf_cls()
    jsr printf_cls
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #'%'
    jsr printf_char
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str
    sta.z printf_str.str
    lda #>str
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str5
    sta.z printf_string.str
    lda #>str5
    sta.z printf_string.str+1
    lda #0
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str7
    sta.z printf_string.str
    lda #>str7
    sta.z printf_string.str+1
    lda #0
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%3s  '%3s' '%3s' '%3s' '%3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #'%'
    jsr printf_char
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str9
    sta.z printf_str.str
    lda #>str9
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str5
    sta.z printf_string.str
    lda #>str5
    sta.z printf_string.str+1
    lda #1
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str7
    sta.z printf_string.str
    lda #>str7
    sta.z printf_string.str+1
    lda #1
    sta.z printf_string.format_justify_left
    jsr printf_string
    // printf("%%-3s '%-3s' '%-3s' '%-3s' '%-3s'\n", "x", "xx", "xxx", "xxxx")
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr printf_char
    // printf("%%3d  '%3d' '%3d' '%3d' '%3d'\n", 1, 11, 111, 1111)
    lda #<str18
    sta.z printf_str.str
    lda #>str18
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #'%'
    jsr printf_char
    // printf("%%-3d '%-3d' '%-3d' '%-3d' '%-3d'\n", -2, -22, -222, -2222)
    lda #<str23
    sta.z printf_str.str
    lda #>str23
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #'%'
    jsr printf_char
    // printf("%%+3d  '%+3d' '%+3d' '%+3d' '%+3d'\n", 3, -44, 555, -6666)
    lda #<str28
    sta.z printf_str.str
    lda #>str28
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr printf_char
    // printf("%%03d '%03d' '%03d' '%03d' '%3d'\n", 1, 11, 111, 1111)
    lda #<str33
    sta.z printf_str.str
    lda #>str33
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr printf_char
    // printf("%%o   '%o' '%o' '%o' '%o'\n", 1, 11, 111, 1111)
    lda #<str38
    sta.z printf_str.str
    lda #>str38
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr printf_char
    // printf("%%x   '%x' '%x' '%x' '%x'\n", 1, 11, 111, 1111)
    lda #<str43
    sta.z printf_str.str
    lda #>str43
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #'%'
    jsr printf_char
    // printf("%%X   '%X' '%X' '%X' '%X'\n", 1, 11, 111, 1111)
    lda #<str48
    sta.z printf_str.str
    lda #>str48
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str2
    sta.z printf_str.str
    lda #>str2
    sta.z printf_str.str+1
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
    lda #<str8
    sta.z printf_str.str
    lda #>str8
    sta.z printf_str.str+1
    jsr printf_str
    // }
    rts
    str: .text "3s  '"
    .byte 0
    str1: .text "x"
    .byte 0
    str2: .text "' '"
    .byte 0
    str3: .text "xx"
    .byte 0
    str5: .text "xxx"
    .byte 0
    str7: .text "xxxx"
    .byte 0
    str8: .text @"'\n"
    .byte 0
    str9: .text "-3s '"
    .byte 0
    str18: .text "3d  '"
    .byte 0
    str23: .text "-3d '"
    .byte 0
    str28: .text "+3d  '"
    .byte 0
    str33: .text "03d '"
    .byte 0
    str38: .text "o   '"
    .byte 0
    str43: .text "x   '"
    .byte 0
    str48: .text "X   '"
    .byte 0
}
// Print a zero-terminated string
// Handles escape codes such as newline
// printf_str(byte* zp(2) str)
printf_str: {
    .label str = 2
  __b2:
    // ch = *str++
    ldy #0
    lda (str),y
    inc.z str
    bne !+
    inc.z str+1
  !:
    // if(ch==0)
    cmp #0
    bne __b3
    // }
    rts
  __b3:
    // if(ch=='\n')
    cmp #'\n'
    beq __b4
    // printf_char(ch)
    jsr printf_char
    jmp __b2
  __b4:
    // printf_ln()
    jsr printf_ln
    jmp __b2
}
// Print a newline
printf_ln: {
    .label __0 = $12
    .label __1 = $12
    // printf_cursor_ptr - printf_cursor_x
    sec
    lda.z __0
    sbc.z printf_cursor_x
    sta.z __0
    bcs !+
    dec.z __0+1
  !:
    // printf_cursor_ptr - printf_cursor_x + PRINTF_SCREEN_WIDTH
    lda #$28
    clc
    adc.z __1
    sta.z __1
    bcc !+
    inc.z __1+1
  !:
    // printf_cursor_ptr =  printf_cursor_ptr - printf_cursor_x + PRINTF_SCREEN_WIDTH
    // printf_cursor_x = 0
    lda #0
    sta.z printf_cursor_x
    // printf_cursor_y++;
    inc.z printf_cursor_y
    // printf_scroll()
    jsr printf_scroll
    // }
    rts
}
// Scroll the entire screen if the cursor is on the last line
printf_scroll: {
    .label __4 = $12
    // if(printf_cursor_y==PRINTF_SCREEN_HEIGHT)
    lda #$19
    cmp.z printf_cursor_y
    bne __breturn
    // memcpy(PRINTF_SCREEN_ADDRESS, PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_WIDTH, PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH)
    jsr memcpy
    // memset(PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH, ' ', PRINTF_SCREEN_WIDTH)
    ldx #' '
    lda #<$400+$28*$19-$28
    sta.z memset.str
    lda #>$400+$28*$19-$28
    sta.z memset.str+1
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
    jsr memset
    // printf_cursor_ptr-PRINTF_SCREEN_WIDTH
    lda.z __4
    sec
    sbc #<$28
    sta.z __4
    lda.z __4+1
    sbc #>$28
    sta.z __4+1
    // printf_cursor_ptr = printf_cursor_ptr-PRINTF_SCREEN_WIDTH
    // printf_cursor_y--;
    dec.z printf_cursor_y
  __breturn:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(9) str, byte register(X) c, word zp($c) num)
memset: {
    .label end = $c
    .label dst = 9
    .label num = $c
    .label str = 9
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // end = (char*)str + num
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
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
  __breturn:
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
memcpy: {
    .const num = $28*$19-$28
    .label destination = $400
    .label source = $400+$28
    .label src_end = source+num
    .label dst = 9
    .label src = $c
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    lda #<source
    sta.z src
    lda #>source
    sta.z src+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp #>src_end
    bne __b2
    lda.z src
    cmp #<src_end
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
// Print a single char
// If the end of the screen is reached scroll it up one char and place the cursor at the
// printf_char(byte register(A) ch)
printf_char: {
    // *(printf_cursor_ptr++) = ch
    ldy #0
    sta (printf_cursor_ptr),y
    // *(printf_cursor_ptr++) = ch;
    inc.z printf_cursor_ptr
    bne !+
    inc.z printf_cursor_ptr+1
  !:
    // if(++printf_cursor_x==PRINTF_SCREEN_WIDTH)
    inc.z printf_cursor_x
    lda #$28
    cmp.z printf_cursor_x
    bne __breturn
    // printf_cursor_x = 0
    lda #0
    sta.z printf_cursor_x
    // ++printf_cursor_y;
    inc.z printf_cursor_y
    // printf_scroll()
    jsr printf_scroll
  __breturn:
    // }
    rts
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
    .label __19 = 9
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
    // printf_char(buffer.sign)
    lda.z buffer_sign
    jsr printf_char
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
    // printf_str(buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.str+1
    jsr printf_str
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
    // printf_char(pad)
    lda.z pad
    jsr printf_char
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
// strlen(byte* zp($c) str)
strlen: {
    .label len = 9
    .label str = $c
    .label return = 9
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
    .label digit_value = $14
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
// utoa_append(byte* zp($c) buffer, word zp(2) value, word zp($14) sub)
utoa_append: {
    .label buffer = $c
    .label value = 2
    .label sub = $14
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
    .label __9 = 9
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
    // printf_str(str)
    jsr printf_str
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
// Clear the screen. Also resets current line/char cursor.
printf_cls: {
    // memset(PRINTF_SCREEN_ADDRESS, ' ', PRINTF_SCREEN_BYTES)
    ldx #' '
    lda #<$400
    sta.z memset.str
    lda #>$400
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // printf_cursor_ptr = PRINTF_SCREEN_ADDRESS
    lda #<$400
    sta.z printf_cursor_ptr
    lda #>$400
    sta.z printf_cursor_ptr+1
    // printf_cursor_x = 0
    lda #0
    sta.z printf_cursor_x
    // printf_cursor_y = 0
    sta.z printf_cursor_y
    // }
    rts
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
