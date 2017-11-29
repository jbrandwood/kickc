.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label char_cursor = 6
  .label line_cursor = 2
  msg: .text "hello world! @"
  msg2: .text "hello c64! @"
  msg3: .text "hello 2017! @"
  jsr main
main: {
    lda #<$400
    sta char_cursor
    lda #>$400
    sta char_cursor+1
    lda #<msg
    sta print_str.str
    lda #>msg
    sta print_str.str+1
    jsr print_str
    lda #<$400
    sta line_cursor
    lda #>$400
    sta line_cursor+1
    jsr print_ln
    lda print_ln._0
    sta char_cursor
    lda print_ln._0+1
    sta char_cursor+1
    lda #<msg2
    sta print_str.str
    lda #>msg2
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    lda print_ln._0
    sta char_cursor
    lda print_ln._0+1
    sta char_cursor+1
    lda #<msg3
    sta print_str.str
    lda #>msg3
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    rts
}
print_ln: {
    .label _0 = 2
  b1:
    lda _0
    clc
    adc #$28
    sta _0
    bcc !+
    inc _0+1
  !:
    lda _0+1
    cmp char_cursor+1
    bcc b1
    bne !+
    lda _0
    cmp char_cursor
    bcc b1
  !:
    rts
}
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
    sta (char_cursor),y
    inc char_cursor
    bne !+
    inc char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
