/// Test strcmp()
  // Commodore 64 PRG executable file
.file [name="strcmp-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const RED = 2
  .const GREEN = 5
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
  .label conio_cursor_x = $15
  // The current cursor y-position
  .label conio_cursor_y = $e
  // The current text cursor line start
  .label conio_line_text = $13
  // The current color cursor line start
  .label conio_line_color = $11
  // The current text color
  .label conio_textcolor = $f
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
    // __ma char conio_textcolor = CONIO_TEXTCOLOR_DEFAULT
    lda #LIGHT_BLUE
    sta.z conio_textcolor
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
    lda.z conio_textcolor
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
    // strcmp("a","b")
    lda #<str2
    sta.z strcmp.s2
    lda #>str2
    sta.z strcmp.s2+1
    lda #<str1
    sta.z strcmp.s1
    lda #>str1
    sta.z strcmp.s1+1
    jsr strcmp
    // strcmp("a","b")
    // assert_cmp(LESS_THAN, strcmp("a","b"), "a<b strcmp()")
    lda.z strcmp.return
    sta.z assert_cmp.actual
    lda #<message
    sta.z assert_cmp.message
    lda #>message
    sta.z assert_cmp.message+1
    lda #-1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strcmp("aaa","aab")
    lda #<str21
    sta.z strcmp.s2
    lda #>str21
    sta.z strcmp.s2+1
    lda #<str11
    sta.z strcmp.s1
    lda #>str11
    sta.z strcmp.s1+1
    jsr strcmp
    // strcmp("aaa","aab")
    // assert_cmp(LESS_THAN, strcmp("aaa","aab"), "aaa<aab strcmp()")
    lda.z strcmp.return
    sta.z assert_cmp.actual
    lda #<message1
    sta.z assert_cmp.message
    lda #>message1
    sta.z assert_cmp.message+1
    lda #-1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strcmp("aa","aaa")
    lda #<str11
    sta.z strcmp.s2
    lda #>str11
    sta.z strcmp.s2+1
    lda #<str12
    sta.z strcmp.s1
    lda #>str12
    sta.z strcmp.s1+1
    jsr strcmp
    // strcmp("aa","aaa")
    // assert_cmp(LESS_THAN, strcmp("aa","aaa"), "aa<aaa strcmp()")
    lda.z strcmp.return
    sta.z assert_cmp.actual
    lda #<message2
    sta.z assert_cmp.message
    lda #>message2
    sta.z assert_cmp.message+1
    lda #-1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strcmp("x","x")
    lda #<str13
    sta.z strcmp.s2
    lda #>str13
    sta.z strcmp.s2+1
    lda #<str13
    sta.z strcmp.s1
    lda #>str13
    sta.z strcmp.s1+1
    jsr strcmp
    // strcmp("x","x")
    // assert_cmp(EQUAL, strcmp("x","x"), "x=x strcmp()")
    lda.z strcmp.return
    sta.z assert_cmp.actual
    lda #<message3
    sta.z assert_cmp.message
    lda #>message3
    sta.z assert_cmp.message+1
    lda #0
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strcmp("qwez","qwez")
    lda #<str14
    sta.z strcmp.s2
    lda #>str14
    sta.z strcmp.s2+1
    lda #<str14
    sta.z strcmp.s1
    lda #>str14
    sta.z strcmp.s1+1
    jsr strcmp
    // strcmp("qwez","qwez")
    // assert_cmp(EQUAL, strcmp("qwez","qwez"), "qwez=qwez strcmp()")
    lda.z strcmp.return
    sta.z assert_cmp.actual
    lda #<message4
    sta.z assert_cmp.message
    lda #>message4
    sta.z assert_cmp.message+1
    lda #0
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strcmp("q","k")
    lda #<str25
    sta.z strcmp.s2
    lda #>str25
    sta.z strcmp.s2+1
    lda #<str15
    sta.z strcmp.s1
    lda #>str15
    sta.z strcmp.s1+1
    jsr strcmp
    // strcmp("q","k")
    // assert_cmp(GREATER_THAN, strcmp("q","k"), "q>k strcmp()")
    lda.z strcmp.return
    sta.z assert_cmp.actual
    lda #<message5
    sta.z assert_cmp.message
    lda #>message5
    sta.z assert_cmp.message+1
    lda #1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strcmp("kkkq","kkkp")
    lda #<str26
    sta.z strcmp.s2
    lda #>str26
    sta.z strcmp.s2+1
    lda #<str16
    sta.z strcmp.s1
    lda #>str16
    sta.z strcmp.s1+1
    jsr strcmp
    // strcmp("kkkq","kkkp")
    // assert_cmp(GREATER_THAN, strcmp("kkkq","kkkp"), "kkkq>kkkp strcmp()")
    lda.z strcmp.return
    sta.z assert_cmp.actual
    lda #<message6
    sta.z assert_cmp.message
    lda #>message6
    sta.z assert_cmp.message+1
    lda #1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strcmp("kkkq","kkk")
    lda #<str27
    sta.z strcmp.s2
    lda #>str27
    sta.z strcmp.s2+1
    lda #<str16
    sta.z strcmp.s1
    lda #>str16
    sta.z strcmp.s1+1
    jsr strcmp
    // strcmp("kkkq","kkk")
    // assert_cmp(GREATER_THAN, strcmp("kkkq","kkk"), "kkkq>kkk strcmp()")
    lda.z strcmp.return
    sta.z assert_cmp.actual
    lda #<message7
    sta.z assert_cmp.message
    lda #>message7
    sta.z assert_cmp.message+1
    lda #1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strncmp("aaax","aabx", 3)
    lda #<3
    sta.z strncmp.n
    lda #>3
    sta.z strncmp.n+1
    lda #<str28
    sta.z strncmp.s2
    lda #>str28
    sta.z strncmp.s2+1
    lda #<str18
    sta.z strncmp.s1
    lda #>str18
    sta.z strncmp.s1+1
    jsr strncmp
    // strncmp("aaax","aabx", 3)
    // assert_cmp(LESS_THAN, strncmp("aaax","aabx", 3), "aaax<aabx strncmp(3)")
    lda.z strncmp.return
    sta.z assert_cmp.actual
    lda #<message8
    sta.z assert_cmp.message
    lda #>message8
    sta.z assert_cmp.message+1
    lda #-1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strncmp("qwe","qee", 3)
    lda #<3
    sta.z strncmp.n
    lda #>3
    sta.z strncmp.n+1
    lda #<str29
    sta.z strncmp.s2
    lda #>str29
    sta.z strncmp.s2+1
    lda #<str19
    sta.z strncmp.s1
    lda #>str19
    sta.z strncmp.s1+1
    jsr strncmp
    // strncmp("qwe","qee", 3)
    // assert_cmp(GREATER_THAN, strncmp("qwe","qee", 3), "qwe>qee strncmp(2)")
    lda.z strncmp.return
    sta.z assert_cmp.actual
    lda #<message9
    sta.z assert_cmp.message
    lda #>message9
    sta.z assert_cmp.message+1
    lda #1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strncmp("aab","aac", 2)
    lda #<2
    sta.z strncmp.n
    lda #>2
    sta.z strncmp.n+1
    lda #<str210
    sta.z strncmp.s2
    lda #>str210
    sta.z strncmp.s2+1
    lda #<str21
    sta.z strncmp.s1
    lda #>str21
    sta.z strncmp.s1+1
    jsr strncmp
    // strncmp("aab","aac", 2)
    // assert_cmp(EQUAL, strncmp("aab","aac", 2), "aab=aac strncmp(2)")
    lda.z strncmp.return
    sta.z assert_cmp.actual
    lda #<message10
    sta.z assert_cmp.message
    lda #>message10
    sta.z assert_cmp.message+1
    lda #0
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strncmp("qwex","qwea", 3)
    lda #<3
    sta.z strncmp.n
    lda #>3
    sta.z strncmp.n+1
    lda #<str211
    sta.z strncmp.s2
    lda #>str211
    sta.z strncmp.s2+1
    lda #<str111
    sta.z strncmp.s1
    lda #>str111
    sta.z strncmp.s1+1
    jsr strncmp
    // strncmp("qwex","qwea", 3)
    // assert_cmp(EQUAL, strncmp("qwex","qwea", 3), "qwex=qwea strncmp(3)")
    lda.z strncmp.return
    sta.z assert_cmp.actual
    lda #<message11
    sta.z assert_cmp.message
    lda #>message11
    sta.z assert_cmp.message+1
    lda #0
    sta.z assert_cmp.expect
    jsr assert_cmp
    // strncmp("aa","aacx", 3)
    lda #<3
    sta.z strncmp.n
    lda #>3
    sta.z strncmp.n+1
    lda #<str212
    sta.z strncmp.s2
    lda #>str212
    sta.z strncmp.s2+1
    lda #<str12
    sta.z strncmp.s1
    lda #>str12
    sta.z strncmp.s1+1
    jsr strncmp
    // strncmp("aa","aacx", 3)
    // assert_cmp(LESS_THAN, strncmp("aa","aacx", 3), "aa<aacx strncmp(3)")
    lda.z strncmp.return
    sta.z assert_cmp.actual
    lda #<message12
    sta.z assert_cmp.message
    lda #>message12
    sta.z assert_cmp.message+1
    lda #-1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // memcmp("aa","aba", 2)
    lda #<2
    sta.z memcmp.n
    lda #>2
    sta.z memcmp.n+1
    lda #<__35
    sta.z memcmp.str2
    lda #>__35
    sta.z memcmp.str2+1
    lda #<str12
    sta.z memcmp.str1
    lda #>str12
    sta.z memcmp.str1+1
    jsr memcmp
    // memcmp("aa","aba", 2)
    // assert_cmp(LESS_THAN, memcmp("aa","aba", 2), "aa<ab memcmp(2)")
    lda.z memcmp.return
    sta.z assert_cmp.actual
    lda #<message13
    sta.z assert_cmp.message
    lda #>message13
    sta.z assert_cmp.message+1
    lda #-1
    sta.z assert_cmp.expect
    jsr assert_cmp
    // memcmp("x","x", 2)
    lda #<2
    sta.z memcmp.n
    lda #>2
    sta.z memcmp.n+1
    lda #<str13
    sta.z memcmp.str2
    lda #>str13
    sta.z memcmp.str2+1
    lda #<str13
    sta.z memcmp.str1
    lda #>str13
    sta.z memcmp.str1+1
    jsr memcmp
    // memcmp("x","x", 2)
    // assert_cmp(EQUAL, memcmp("x","x", 2), "x=x memcmp(2)")
    lda.z memcmp.return
    sta.z assert_cmp.actual
    lda #<message14
    sta.z assert_cmp.message
    lda #>message14
    sta.z assert_cmp.message+1
    lda #0
    sta.z assert_cmp.expect
    jsr assert_cmp
    // memcmp("xy","xz", 1)
    lda #<1
    sta.z memcmp.n
    lda #>1
    sta.z memcmp.n+1
    lda #<__39
    sta.z memcmp.str2
    lda #>__39
    sta.z memcmp.str2+1
    lda #<__38
    sta.z memcmp.str1
    lda #>__38
    sta.z memcmp.str1+1
    jsr memcmp
    // memcmp("xy","xz", 1)
    // assert_cmp(EQUAL, memcmp("xy","xz", 1), "xy=xz memcmp(1)")
    lda.z memcmp.return
    sta.z assert_cmp.actual
    lda #<message15
    sta.z assert_cmp.message
    lda #>message15
    sta.z assert_cmp.message+1
    lda #0
    sta.z assert_cmp.expect
    jsr assert_cmp
    // memcmp("qwez","qwex",4)
    lda #<4
    sta.z memcmp.n
    lda #>4
    sta.z memcmp.n+1
    lda #<str111
    sta.z memcmp.str2
    lda #>str111
    sta.z memcmp.str2+1
    lda #<str14
    sta.z memcmp.str1
    lda #>str14
    sta.z memcmp.str1+1
    jsr memcmp
    // memcmp("qwez","qwex",4)
    // assert_cmp(GREATER_THAN, memcmp("qwez","qwex",4), "qwez>qwex memcmp(4)")
    lda.z memcmp.return
    sta.z assert_cmp.actual
    lda #<message16
    sta.z assert_cmp.message
    lda #>message16
    sta.z assert_cmp.message+1
    lda #1
    sta.z assert_cmp.expect
    jsr assert_cmp
  __b1:
    jmp __b1
  .segment Data
    str1: .text "a"
    .byte 0
    str2: .text "b"
    .byte 0
    message: .text "a<b strcmp()"
    .byte 0
    str11: .text "aaa"
    .byte 0
    str21: .text "aab"
    .byte 0
    message1: .text "aaa<aab strcmp()"
    .byte 0
    str12: .text "aa"
    .byte 0
    message2: .text "aa<aaa strcmp()"
    .byte 0
    str13: .text "x"
    .byte 0
    message3: .text "x=x strcmp()"
    .byte 0
    str14: .text "qwez"
    .byte 0
    message4: .text "qwez=qwez strcmp()"
    .byte 0
    str15: .text "q"
    .byte 0
    str25: .text "k"
    .byte 0
    message5: .text "q>k strcmp()"
    .byte 0
    str16: .text "kkkq"
    .byte 0
    str26: .text "kkkp"
    .byte 0
    message6: .text "kkkq>kkkp strcmp()"
    .byte 0
    str27: .text "kkk"
    .byte 0
    message7: .text "kkkq>kkk strcmp()"
    .byte 0
    str18: .text "aaax"
    .byte 0
    str28: .text "aabx"
    .byte 0
    message8: .text "aaax<aabx strncmp(3)"
    .byte 0
    str19: .text "qwe"
    .byte 0
    str29: .text "qee"
    .byte 0
    message9: .text "qwe>qee strncmp(2)"
    .byte 0
    str210: .text "aac"
    .byte 0
    message10: .text "aab=aac strncmp(2)"
    .byte 0
    str111: .text "qwex"
    .byte 0
    str211: .text "qwea"
    .byte 0
    message11: .text "qwex=qwea strncmp(3)"
    .byte 0
    str212: .text "aacx"
    .byte 0
    message12: .text "aa<aacx strncmp(3)"
    .byte 0
    __35: .text "aba"
    .byte 0
    message13: .text "aa<ab memcmp(2)"
    .byte 0
    message14: .text "x=x memcmp(2)"
    .byte 0
    __38: .text "xy"
    .byte 0
    __39: .text "xz"
    .byte 0
    message15: .text "xy=xz memcmp(1)"
    .byte 0
    message16: .text "qwez>qwex memcmp(4)"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// void gotoxy(char x, __register(X) char y)
gotoxy: {
    .const x = 0
    .label __5 = $1f
    .label __6 = $1a
    .label __7 = $1a
    .label line_offset = $1a
    .label __8 = $1d
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
/// compares the string pointed to, by str1 to the string pointed to by str2.
/// @param str1 This is the first string to be compared.
/// @param str2 This is the second string to be compared.
/// @return if Return value < 0 then it indicates str1 is less than str2.
///         if Return value > 0 then it indicates str2 is less than str1.
///         if Return value = 0 then it indicates str1 is equal to str2.
// __zp(9) int strcmp(const char *str1, const char *str2)
strcmp: {
    .label s1 = $16
    .label s2 = $18
    .label return = 9
  __b1:
    // while(*s1==*s2)
    ldy #0
    lda (s1),y
    cmp (s2),y
    beq __b2
    // *s1-*s2
    lda (s1),y
    sec
    sbc (s2),y
    // return (int)(signed char)(*s1-*s2);
    sta.z return
    ora #$7f
    bmi !+
    tya
  !:
    sta.z return+1
    // }
    rts
  __b2:
    // if(*s1==0)
    ldy #0
    lda (s1),y
    cmp #0
    bne __b4
    tya
    sta.z return
    sta.z return+1
    rts
  __b4:
    // s1++;
    inc.z s1
    bne !+
    inc.z s1+1
  !:
    // s2++;
    inc.z s2
    bne !+
    inc.z s2+1
  !:
    jmp __b1
}
// void assert_cmp(__zp($21) signed char expect, __zp($1c) signed char actual, __zp($16) char *message)
assert_cmp: {
    .label actual = $1c
    .label expect = $21
    .label message = $16
    // case LESS_THAN:
    //             ok = (char)(actual<0);
    //             break;
    lda #-1
    cmp.z expect
    bne !__b4+
    jmp __b4
  !__b4:
    // case EQUAL:
    //             ok = (char)(actual==0);
    //             break;
    lda.z expect
    cmp #0
    bne !__b5+
    jmp __b5
  !__b5:
    // case GREATER_THAN:
    //             ok = (char)(actual>0);
    //             break;
    lda #1
    cmp.z expect
    bne __b3
    // actual>0
    lda.z actual
    sec
    sbc #0
    beq !a+
    bvs !+
    eor #$80
  !:
    asl
    lda #0
    rol
  !a:
    // ok = (char)(actual>0)
    jmp __b7
  __b3:
    lda #0
  __b7:
    // if(ok)
    cmp #0
    bne __b1
    // textcolor(RED)
    lda #RED
    jsr textcolor
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    ldx.z expect
    jsr printf_schar
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    ldx.z actual
    jsr printf_schar
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    jsr printf_string
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // }
    rts
  __b1:
    // textcolor(GREEN)
    lda #GREEN
    jsr textcolor
    // printf("ok! %s\n", message)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // printf("ok! %s\n", message)
    jsr printf_string
    // printf("ok! %s\n", message)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    rts
  __b5:
    // actual==0
    lda.z actual
    eor #0
    beq !+
    lda #1
  !:
    eor #1
    // ok = (char)(actual==0)
    jmp __b7
  __b4:
    // actual<0
    lda.z actual
    sec
    sbc #0
    bvc !+
    eor #$80
  !:
    asl
    lda #0
    rol
    // ok = (char)(actual<0)
    jmp __b7
  .segment Data
    s: .text "ok! "
    .byte 0
    s1: .text @"\n"
    .byte 0
    s2: .text "Assert failed. expected:"
    .byte 0
    s3: .text " actual:"
    .byte 0
    s4: .text ". "
    .byte 0
}
.segment Code
/// Compares at most the first n bytes of str1 and str2.
/// @param str1 This is the first string to be compared.
/// @param str2 This is the second string to be compared.
/// @param The maximum number of characters to be compared.
/// @return if Return value < 0 then it indicates str1 is less than str2.
///         if Return value > 0 then it indicates str2 is less than str1.
///         if Return value = 0 then it indicates str1 is equal to str2.
// __zp($b) int strncmp(const char *str1, const char *str2, __zp($16) unsigned int n)
strncmp: {
    .label s1 = $18
    .label s2 = 9
    .label n = $16
    .label return = $b
  __b1:
    // while(*s1==*s2)
    ldy #0
    lda (s1),y
    cmp (s2),y
    beq __b2
    // *s1-*s2
    lda (s1),y
    sec
    sbc (s2),y
    // return (int)(signed char)(*s1-*s2);
    sta.z return
    ora #$7f
    bmi !+
    tya
  !:
    sta.z return+1
    rts
  __b3:
    lda #<0
    sta.z return
    sta.z return+1
    // }
    rts
  __b2:
    // n--;
    lda.z n
    bne !+
    dec.z n+1
  !:
    dec.z n
    // if(*s1==0 || n==0)
    ldy #0
    lda (s1),y
    cmp #0
    beq __b3
    lda.z n
    ora.z n+1
    beq __b3
    // s1++;
    inc.z s1
    bne !+
    inc.z s1+1
  !:
    // s2++;
    inc.z s2
    bne !+
    inc.z s2+1
  !:
    jmp __b1
}
/// Compares the first n bytes of memory area str1 and memory area str2.
/// @param str1 This is the pointer to a block of memory.
/// @param str2 This is the pointer to a block of memory.
/// @param n This is the number of bytes to be compared.
/// @return if Return value < 0 then it indicates str1 is less than str2.
///         if Return value > 0 then it indicates str2 is less than str1.
///         if Return value = 0 then it indicates str1 is equal to str2.
// __zp(9) int memcmp(__zp($16) const void *str1, __zp($b) const void *str2, __zp($18) unsigned int n)
memcmp: {
    .label n = $18
    .label s1 = $16
    .label s2 = $b
    .label return = 9
    .label str1 = $16
    .label str2 = $b
  __b1:
    // for(char *s1 = str1, *s2 = str2; n!=0; n--,s1++,s2++)
    lda.z n
    ora.z n+1
    bne __b2
    lda #<0
    sta.z return
    sta.z return+1
    // }
    rts
  __b2:
    // if(*s1!=*s2)
    ldy #0
    lda (s1),y
    cmp (s2),y
    beq __b3
    // *s1-*s2
    lda (s1),y
    sec
    sbc (s2),y
    // return (int)(signed char)(*s1-*s2);
    sta.z return
    ora #$7f
    bmi !+
    tya
  !:
    sta.z return+1
    rts
  __b3:
    // for(char *s1 = str1, *s2 = str2; n!=0; n--,s1++,s2++)
    lda.z n
    bne !+
    dec.z n+1
  !:
    dec.z n
    inc.z s1
    bne !+
    inc.z s1+1
  !:
    inc.z s2
    bne !+
    inc.z s2+1
  !:
    jmp __b1
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
    ldx.z conio_textcolor
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
// Set the color for text output. The old color setting is returned.
// char textcolor(__register(A) char color)
textcolor: {
    // conio_textcolor = color
    sta.z conio_textcolor
    // }
    rts
}
/// Print a NUL-terminated string
// void printf_str(__zp($18) void (*putc)(char), __zp(9) const char *s)
printf_str: {
    .label s = 9
    .label putc = $18
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
    jsr icall1
    pla
    jmp __b1
  icall1:
    jmp (putc)
}
// Print a signed char using a specific format
// void printf_schar(void (*putc)(char), __register(X) signed char value, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_schar: {
    // printf_buffer.sign = 0
    // Handle any sign
    lda #0
    sta printf_buffer
    // if(value<0)
    cpx #0
    bmi __b1
    jmp __b2
  __b1:
    // value = -value
    txa
    eor #$ff
    clc
    adc #1
    tax
    // printf_buffer.sign = '-'
    lda #'-'
    sta printf_buffer
  __b2:
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    jsr uctoa
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Print a string value using a specific format
// Handles justification and min length 
// void printf_string(void (*putc)(char), __zp($16) char *str, char format_min_length, char format_justify_left)
printf_string: {
    .label str = $16
    // printf_str(putc, str)
    lda.z str
    sta.z printf_str.s
    lda.z str+1
    sta.z printf_str.s+1
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    jsr printf_str
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(__zp(4) void *destination, __zp(2) void *source, unsigned int num)
memcpy: {
    .label src_end = 6
    .label dst = 4
    .label src = 2
    .label source = 2
    .label destination = 4
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
// void * memset(__zp(2) void *str, __register(X) char c, unsigned int num)
memset: {
    .label end = 4
    .label dst = 2
    .label str = 2
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__register(X) char value, __zp($b) char *buffer, char radix)
uctoa: {
    .label digit_value = 8
    .label buffer = $b
    .label digit = $d
    .label started = $10
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #3-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
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
    // }
    rts
  __b2:
    // unsigned char digit_value = digit_values[digit]
    ldy.z digit
    lda RADIX_DECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    lda.z started
    bne __b5
    cpx.z digit_value
    bcs __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #1
    sta.z started
    jmp __b4
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __register(A) char buffer_sign, char *buffer_digits, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label putc = cputc
    // if(buffer.sign)
    cmp #0
    beq __b2
    // putc(buffer.sign)
    pha
    jsr cputc
    pla
  __b2:
    // printf_str(putc, buffer.digits)
    lda #<putc
    sta.z printf_str.putc
    lda #>putc
    sta.z printf_str.putc+1
    lda #<buffer_digits
    sta.z printf_str.s
    lda #>buffer_digits
    sta.z printf_str.s+1
    jsr printf_str
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
// __register(X) char uctoa_append(__zp($b) char *buffer, __register(X) char value, __zp(8) char sub)
uctoa_append: {
    .label buffer = $b
    .label sub = 8
    ldy #0
  __b1:
    // while (value >= sub)
    cpx.z sub
    bcs __b2
    // *buffer = DIGITS[digit]
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    iny
    // value -= sub
    txa
    sec
    sbc.z sub
    tax
    jmp __b1
}
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
