// Illustrates introducing local scopes inside loops etc
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 2
  .label print_line_cursor = 4
  .label print_line_cursor_12 = 6
main: {
    ldx #0
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
  b1:
    jsr print_ln
    inx
    cpx #6
    bne b7
    ldx #0
  b3:
    jsr print_str_ln
    inx
    cpx #6
    bne b3
    rts
  b7:
    lda print_line_cursor_12
    sta print_line_cursor
    lda print_line_cursor_12+1
    sta print_line_cursor+1
    lda print_line_cursor_12
    sta print_char_cursor
    lda print_line_cursor_12+1
    sta print_char_cursor+1
    jmp b1
    str: .text " xxxxx@"
}
// Print a zero-terminated string followed by a newline
print_str_ln: {
    jsr print_str
    lda print_line_cursor_12
    sta print_line_cursor
    lda print_line_cursor_12+1
    sta print_line_cursor+1
    jsr print_ln
    rts
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor
    sta print_line_cursor_12
    lda #0
    adc print_line_cursor+1
    sta print_line_cursor_12+1
    cmp print_char_cursor+1
    bcc b3
    bne !+
    lda print_line_cursor_12
    cmp print_char_cursor
    bcc b3
  !:
    rts
  b3:
    lda print_line_cursor_12
    sta print_line_cursor
    lda print_line_cursor_12+1
    sta print_line_cursor+1
    jmp b1
}
// Print a zero-terminated string
// print_str(byte* zeropage(4) str)
print_str: {
    .label str = 4
    lda print_line_cursor_12
    sta print_char_cursor
    lda print_line_cursor_12+1
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
