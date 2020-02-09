.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 6
  .label print_line_cursor = 2
main: {
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<msg
    sta.z print_str.str
    lda #>msg
    sta.z print_str.str+1
    jsr print_str
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<msg2
    sta.z print_str.str
    lda #>msg2
    sta.z print_str.str+1
    jsr print_str
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<msg3
    sta.z print_str.str
    lda #>msg3
    sta.z print_str.str+1
    jsr print_str
    jsr print_ln
    rts
}
// Print a newline
print_ln: {
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// Print a zero-terminated string
// print_str(byte* zp(4) str)
print_str: {
    .label str = 4
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
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
  msg: .text "hello world! "
  .byte 0
  msg2: .text "hello c64! "
  .byte 0
  msg3: .text "hello 2017! "
  .byte 0
