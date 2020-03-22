.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .const GREEN = 5
  .const RED = 2
  .label print_char_cursor = 4
  .label print_line_cursor = 6
main: {
    // print_cls()
    jsr print_cls
    // *BGCOL = GREEN
    lda #GREEN
    sta BGCOL
    // test_bytes()
    jsr test_bytes
    // test_sbytes()
    jsr test_sbytes
    // }
    rts
}
// Test different signed byte constants
test_sbytes: {
    .const bb = 0
    .const bf = $ff&-$7f-$7f
    .const bc = 2
    .const bd = bc-4
    .const be = -bd
    // assert_sbyte("0=0", bb, 0)
    lda #0
    sta.z assert_sbyte.c
    lda #bb
    sta.z assert_sbyte.b
    lda #<msg
    sta.z assert_sbyte.msg
    lda #>msg
    sta.z assert_sbyte.msg+1
    jsr assert_sbyte
    // assert_sbyte("0+2=2", bc, 2)
    lda #2
    sta.z assert_sbyte.c
    lda #bc
    sta.z assert_sbyte.b
    lda #<msg1
    sta.z assert_sbyte.msg
    lda #>msg1
    sta.z assert_sbyte.msg+1
    jsr assert_sbyte
    // assert_sbyte("0+2-4=-2", bd, -2)
    lda #-2
    sta.z assert_sbyte.c
    lda #bd
    sta.z assert_sbyte.b
    lda #<msg2
    sta.z assert_sbyte.msg
    lda #>msg2
    sta.z assert_sbyte.msg+1
    jsr assert_sbyte
    // assert_sbyte("-(0+2-4)=2", be, 2)
    lda #2
    sta.z assert_sbyte.c
    lda #be
    sta.z assert_sbyte.b
    lda #<msg3
    sta.z assert_sbyte.msg
    lda #>msg3
    sta.z assert_sbyte.msg+1
    jsr assert_sbyte
    // assert_sbyte("-127-127=2", bf, 2)
    lda #2
    sta.z assert_sbyte.c
    lda #bf
    sta.z assert_sbyte.b
    lda #<msg4
    sta.z assert_sbyte.msg
    lda #>msg4
    sta.z assert_sbyte.msg+1
    jsr assert_sbyte
    // }
    rts
    msg2: .text "0+2-4=-2"
    .byte 0
    msg3: .text "-(0+2-4)=2"
    .byte 0
    msg4: .text "-127-127=2"
    .byte 0
}
// assert_sbyte(byte* zp(9) msg, signed byte zp(2) b, signed byte zp(3) c)
assert_sbyte: {
    .label msg = 9
    .label b = 2
    .label c = 3
    // print_str(msg)
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str(msg)
    jsr print_str
    // print_str(" ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // if(b!=c)
    lda.z b
    cmp.z c
    bne __b1
    // print_str("ok")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
  __b2:
    // print_ln()
    jsr print_ln
    // }
    rts
  __b1:
    // *BGCOL = RED
    lda #RED
    sta BGCOL
    // print_str("fail!")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    jmp __b2
}
// Print a zero-terminated string
// print_str(byte* zp(9) str)
print_str: {
    .label str = 9
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(print_char_cursor++) = *(str++)
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    // *(print_char_cursor++) = *(str++);
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Test different byte constants
test_bytes: {
    .const bb = 0
    .const bc = 2
    .const bd = bc-4
    // assert_byte("0=0", bb, 0)
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #0
    sta.z assert_byte.c
    ldx #bb
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<msg
    sta.z assert_byte.msg
    lda #>msg
    sta.z assert_byte.msg+1
    jsr assert_byte
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // assert_byte("0+2=2", bc, 2)
    lda #2
    sta.z assert_byte.c
    ldx #bc
    lda #<msg1
    sta.z assert_byte.msg
    lda #>msg1
    sta.z assert_byte.msg+1
    jsr assert_byte
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // assert_byte("0+2-4=254", bd, 254)
    lda #$fe
    sta.z assert_byte.c
    ldx #bd
    lda #<msg2
    sta.z assert_byte.msg
    lda #>msg2
    sta.z assert_byte.msg+1
    jsr assert_byte
    // }
    rts
    msg2: .text "0+2-4=254"
    .byte 0
}
// assert_byte(byte* zp(9) msg, byte register(X) b, byte zp(8) c)
assert_byte: {
    .label msg = 9
    .label c = 8
    // print_str(msg)
    jsr print_str
    // print_str(" ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // if(b!=c)
    cpx.z c
    bne __b1
    // print_str("ok")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
  __b2:
    // print_ln()
    jsr print_ln
    // }
    rts
  __b1:
    // *BGCOL = RED
    lda #RED
    sta BGCOL
    // print_str("fail!")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    jmp __b2
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = $400
    .label end = str+num
    .label dst = 9
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
  msg: .text "0=0"
  .byte 0
  msg1: .text "0+2=2"
  .byte 0
  str: .text " "
  .byte 0
  str1: .text "fail!"
  .byte 0
  str2: .text "ok"
  .byte 0
