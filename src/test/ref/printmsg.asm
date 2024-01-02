/// @file
/// A lightweight library for printing on the C64.
///
/// Printing with this library is done by calling print_ function for each element
  // Commodore 64 PRG executable file
.file [name="printmsg.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label print_screen = $400
  .label print_char_cursor = 2
  .label print_line_cursor = 6
.segment Code
main: {
    // print_str(msg)
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<msg
    sta.z print_str.str
    lda #>msg
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str(msg2)
    lda #<msg2
    sta.z print_str.str
    lda #>msg2
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str(msg3)
    lda #<msg3
    sta.z print_str.str
    lda #>msg3
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    jsr print_ln
    // }
    rts
}
// Print a zero-terminated string
// void print_str(__zp(4) char *str)
print_str: {
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
    // print_char(*(str++))
    ldy #0
    lda (str),y
    jsr print_char
    // print_char(*(str++));
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + 0x28
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
// Print a single char
// void print_char(__register(A) char ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
.segment Data
  msg: .text "hello world! "
  .byte 0
  msg2: .text "hello c64! "
  .byte 0
  msg3: .text "hello 2017! "
  .byte 0
