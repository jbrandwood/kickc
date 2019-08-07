.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 4
  .label print_line_cursor = 2
main: {
    jsr print_str
    jsr print_ln
    rts
    str: .text "hello world!"
    .byte 0
}
// Print a newline
print_ln: {
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
  b1:
    lda #$28
    clc
    adc print_line_cursor
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
// print_str(byte* zeropage(2) str)
print_str: {
    .label str = 2
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<main.str
    sta str
    lda #>main.str
    sta str+1
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
