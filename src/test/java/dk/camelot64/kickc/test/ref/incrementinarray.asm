.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label char_cursor = 6
  .label line_cursor = 2
  jsr main
main: {
    jsr print_cls
    ldx #0
    lda #<$400
    sta line_cursor
    lda #>$400
    sta line_cursor+1
    lda #<$400
    sta char_cursor
    lda #>$400
    sta char_cursor+1
  b1:
    jsr print_str
    jsr print_ln
    lda txt+1
    clc
    adc #1
    sta txt+1
    inx
    cpx #$b
    bne b6
    rts
  b6:
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp b1
}
print_ln: {
  b1:
    lda line_cursor
    clc
    adc #$28
    sta line_cursor
    bcc !+
    inc line_cursor+1
  !:
    lda line_cursor+1
    cmp char_cursor+1
    bcc b1
    bne !+
    lda line_cursor
    cmp char_cursor
    bcc b1
  !:
    rts
}
print_str: {
    .label str = 4
    lda #<txt
    sta str
    lda #>txt
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
print_cls: {
    .label sc = 8
    lda #<$400
    sta sc
    lda #>$400
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>$400+$3e8
    bne b1
    lda sc
    cmp #<$400+$3e8
    bne b1
    rts
}
  txt: .text "camelot@"
