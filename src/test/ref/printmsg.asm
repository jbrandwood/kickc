.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 6
  .label print_line_cursor = 2
main: {
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<msg
    sta print_str.str
    lda #>msg
    sta print_str.str+1
    jsr print_str
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<msg2
    sta print_str.str
    lda #>msg2
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<msg3
    sta print_str.str
    lda #>msg3
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    rts
}
// Print a newline
print_ln: {
  b1:
    lda print_line_cursor
    clc
    adc #$28
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
  !:
    rts
}
// Print a zero-terminated string
// print_str(byte* zeropage(4) str)
print_str: {
    .label str = 4
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
  msg: .text "hello world! @"
  msg2: .text "hello c64! @"
  msg3: .text "hello 2017! @"
