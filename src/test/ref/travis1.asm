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
    sta.z i
    tax
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
  b1:
    jsr game_ready
    cmp #0
    bne b3
    jmp b2
  b3:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str_ln.str
    lda #>str
    sta.z print_str_ln.str+1
    jsr print_str_ln
  b2:
    inc.z i
    lda #6
    cmp.z i
    bne b5
    rts
  b5:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp b1
    str: .text "ready!"
    .byte 0
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
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
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
    cmp #0
    bne b2
    rts
  b2:
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
    jmp b1
}
game_ready: {
    cpx #0
    bne b1
    ldx #READY_FRAMES
  b1:
    lda #<str
    sta.z print_str_ln.str
    lda #>str
    sta.z print_str_ln.str+1
    jsr print_str_ln
    dex
    lda #1
    cpx #0
    beq !+
    lda #0
  !:
    rts
    str: .text "ready"
    .byte 0
}
