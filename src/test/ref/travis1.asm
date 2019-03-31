// Adding a missing word-fragment for Travis Fisher
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const READY_FRAMES = 5
  .label print_char_cursor = 7
  .label print_line_cursor = 5
main: {
    .label i = 2
    lda #0
    sta i
    tax
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
  b1:
    jsr game_ready
    cmp #0
    bne b3
  b2:
    inc i
    lda #6
    cmp i
    bne b5
    rts
  b5:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b1
  b3:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str_ln.str
    lda #>str
    sta print_str_ln.str+1
    jsr print_str_ln
    jmp b2
    str: .text "ready!@"
}
// Print a zero-terminated string followed by a newline
// print_str_ln(byte* zeropage(3) str)
print_str_ln: {
    .label str = 3
    jsr print_str
    jsr print_ln
    rts
}
// Print a newline
print_ln: {
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
// print_str(byte* zeropage(3) str)
print_str: {
    .label str = 3
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
game_ready: {
    cpx #0
    bne b1
    ldx #READY_FRAMES
  b1:
    lda #<str
    sta print_str_ln.str
    lda #>str
    sta print_str_ln.str+1
    jsr print_str_ln
    dex
    lda #1
    cpx #0
    beq !+
    lda #0
  !:
    rts
    str: .text "ready@"
}
