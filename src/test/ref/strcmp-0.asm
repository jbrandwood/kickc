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
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// Color Ram
  .label COLORRAM = $d800
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $c
  // The current cursor y-position
  .label conio_cursor_y = $d
  // The current text cursor line start
  .label conio_line_text = $e
  // The current color cursor line start
  .label conio_line_color = $10
  // The current text color
  .label conio_textcolor = $12
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
    // assert_cmp(LESS_THAN, strcmp("a","b"), "a<b")
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
    // assert_cmp(LESS_THAN, strcmp("aaa","aab"), "aaa<aab")
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
    // assert_cmp(LESS_THAN, strcmp("aa","aaa"), "aa<aaa")
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
    // assert_cmp(EQUAL, strcmp("x","x"), "x=x")
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
    // assert_cmp(EQUAL, strcmp("qwez","qwez"), "qwez=qwez")
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
    // assert_cmp(GREATER_THAN, strcmp("q","k"), "q>k")
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
    // assert_cmp(GREATER_THAN, strcmp("kkkq","kkkp"), "kkkq>kkkp")
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
    // assert_cmp(GREATER_THAN, strcmp("kkkq","kkk"), "kkkq>kkk")
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
    // assert_cmp(LESS_THAN, strncmp("aaax","aabx", 3), "aaax<aabx (3)")
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
    // assert_cmp(GREATER_THAN, strncmp("qwe","qee", 3), "qwe>qee (2)")
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
    // assert_cmp(EQUAL, strncmp("aab","aac", 2), "aab=aac (2)")
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
    // assert_cmp(EQUAL, strncmp("qwex","qwea", 3), "qwex=qwea (3)")
    lda.z strncmp.return
    sta.z assert_cmp.actual
    lda #<message11
    sta.z assert_cmp.message
    lda #>message11
    sta.z assert_cmp.message+1
    lda #0
    sta.z assert_cmp.expect
    jsr assert_cmp
  __b1:
    jmp __b1
  .segment Data
    str1: .text "a"
    .byte 0
    str2: .text "b"
    .byte 0
    message: .text "a<b"
    .byte 0
    str11: .text "aaa"
    .byte 0
    str21: .text "aab"
    .byte 0
    message1: .text "aaa<aab"
    .byte 0
    str12: .text "aa"
    .byte 0
    message2: .text "aa<aaa"
    .byte 0
    str13: .text "x"
    .byte 0
    message3: .text "x=x"
    .byte 0
    str14: .text "qwez"
    .byte 0
    message4: .text "qwez=qwez"
    .byte 0
    str15: .text "q"
    .byte 0
    str25: .text "k"
    .byte 0
    message5: .text "q>k"
    .byte 0
    str16: .text "kkkq"
    .byte 0
    str26: .text "kkkp"
    .byte 0
    message6: .text "kkkq>kkkp"
    .byte 0
    str27: .text "kkk"
    .byte 0
    message7: .text "kkkq>kkk"
    .byte 0
    str18: .text "aaax"
    .byte 0
    str28: .text "aabx"
    .byte 0
    message8: .text "aaax<aabx (3)"
    .byte 0
    str19: .text "qwe"
    .byte 0
    str29: .text "qee"
    .byte 0
    message9: .text "qwe>qee (2)"
    .byte 0
    str210: .text "aac"
    .byte 0
    message10: .text "aab=aac (2)"
    .byte 0
    str111: .text "qwex"
    .byte 0
    str211: .text "qwea"
    .byte 0
    message11: .text "qwex=qwea (3)"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .const x = 0
    .label __5 = $17
    .label __6 = $13
    .label __7 = $13
    .label line_offset = $13
    .label __8 = $15
    .label __9 = $13
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
/// compares the string pointed to, by str1 to the string pointed to by str2.
/// @param str1 This is the first string to be compared.
/// @param str2 This is the second string to be compared.
/// @return if Return value < 0 then it indicates str1 is less than str2.
///         if Return value > 0 then it indicates str2 is less than str1.
///         if Return value = 0 then it indicates str1 is equal to str2.
strcmp: {
    .label s1 = 4
    .label s2 = $a
    .label return = $1a
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
// assert_cmp(signed byte zp(2) expect, signed byte zp(3) actual, byte* zp(4) message)
assert_cmp: {
    .label actual = 3
    .label expect = 2
    .label message = 4
    // case LESS_THAN:
    //             BREAK();
    //             ok = (char)(actual<0);
    //             break;
    lda #-1
    cmp.z expect
    bne !BREAK1+
    jmp BREAK1
  !BREAK1:
    // case EQUAL:
    //             ok = (char)(actual==0);
    //             break;
    lda.z expect
    cmp #0
    beq __b4
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
    jmp __b6
  __b3:
    lda #0
  __b6:
    // if(ok)
    cmp #0
    bne __b1
    // textcolor(RED)
    lda #RED
    jsr textcolor
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    ldx.z expect
    jsr printf_schar
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    ldx.z actual
    jsr printf_schar
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    jsr printf_string
    // printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  __b1:
    // textcolor(GREEN)
    lda #GREEN
    jsr textcolor
    // printf("ok! %s\n", message)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("ok! %s\n", message)
    jsr printf_string
    // printf("ok! %s\n", message)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    rts
  __b4:
    // actual==0
    lda.z actual
    eor #0
    beq !+
    lda #1
  !:
    eor #1
    // ok = (char)(actual==0)
    jmp __b6
  BREAK1:
    // kickasm
    .break 
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
    jmp __b6
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
// strncmp(word zp(6) n)
strncmp: {
    .label s1 = $a
    .label s2 = $1a
    .label n = 6
    .label return = $1c
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
// Set the color for text output. The old color setting is returned.
// textcolor(byte register(A) color)
textcolor: {
    // conio_textcolor = color
    sta.z conio_textcolor
    // }
    rts
}
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp(6) s)
cputs: {
    .label s = 6
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
// Print a signed char using a specific format
// printf_schar(signed byte register(X) value)
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
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Print a string value using a specific format
// Handles justification and min length 
// printf_string(byte* zp(4) str)
printf_string: {
    .label str = 4
    // cputs(str)
    lda.z str
    sta.z cputs.s
    lda.z str+1
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($1c) buffer)
uctoa: {
    .label digit_value = $19
    .label buffer = $1c
    .label digit = 8
    .label started = 9
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
// printf_number_buffer(byte register(A) buffer_sign)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // if(buffer.sign)
    cmp #0
    beq __b2
    // cputc(buffer.sign)
    jsr cputc
  __b2:
    // cputs(buffer.digits)
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// uctoa_append(byte* zp($1c) buffer, byte register(X) value, byte zp($19) sub)
uctoa_append: {
    .label buffer = $1c
    .label sub = $19
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
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($1c) destination, void* zp($a) source)
memcpy: {
    .label src_end = $1a
    .label dst = $1c
    .label src = $a
    .label source = $a
    .label destination = $1c
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
// memset(void* zp($a) str, byte register(X) c)
memset: {
    .label end = $1c
    .label dst = $a
    .label str = $a
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
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
