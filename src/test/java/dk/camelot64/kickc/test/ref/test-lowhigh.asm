.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label line_cursor = 6
  .label char_cursor = 8
  jsr main
main: {
    .label _2 = $a
    .label _5 = $a
    .label _15 = $a
    .label _19 = $a
    .label _23 = $a
    .label _27 = $a
    .label _32 = $a
    .label _33 = $a
    .label dw2 = $c
    .label dw = 2
    jsr print_cls
    lda #<SCREEN
    sta line_cursor
    lda #>SCREEN
    sta line_cursor+1
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    lda #<$12345678
    sta dw
    lda #>$12345678
    sta dw+1
    lda #<$12345678>>$10
    sta dw+2
    lda #>$12345678>>$10
    sta dw+3
  b1:
    lda dw+2
    sta _2
    lda dw+3
    sta _2+1
    clc
    lda _32
    adc #<$1111
    sta _32
    lda _32+1
    adc #>$1111
    sta _32+1
    lda dw
    sta dw2
    lda dw+1
    sta dw2+1
    lda _32
    sta dw2+2
    lda _32+1
    sta dw2+3
    lda dw
    sta _5
    lda dw+1
    sta _5+1
    clc
    lda _33
    adc #<$1111
    sta _33
    lda _33+1
    adc #>$1111
    sta _33+1
    lda _33
    sta dw2
    lda _33+1
    sta dw2+1
    jsr print_dword
    lda #' '
    jsr print_char
    lda dw2+2
    sta print_word.w
    lda dw2+3
    sta print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda dw2
    sta print_word.w
    lda dw2+1
    sta print_word.w+1
    jsr print_word
    lda #' '
    jsr print_char
    lda dw2+2
    sta _15
    lda dw2+3
    sta _15+1
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda dw2+2
    sta _19
    lda dw2+3
    sta _19+1
    lda _19
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda dw2
    sta _23
    lda dw2+1
    sta _23+1
    tax
    jsr print_byte
    lda #' '
    jsr print_char
    lda dw2
    sta _27
    lda dw2+1
    sta _27+1
    lda _27
    tax
    jsr print_byte
    jsr print_ln
    inc dw
    bne !+
    inc dw+1
    bne !+
    inc dw+2
    bne !+
    inc dw+3
  !:
    lda dw+3
    cmp #>$12345690>>$10
    bne b18
    lda dw+2
    cmp #<$12345690>>$10
    bne b18
    lda dw+1
    cmp #>$12345690
    bne b18
    lda dw
    cmp #<$12345690
    bne b18
    rts
  b18:
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
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda hextab,y
    jsr print_char
    txa
    and #$f
    tay
    lda hextab,y
    jsr print_char
    rts
    hextab: .text "0123456789abcdef"
}
print_char: {
    ldy #0
    sta (char_cursor),y
    inc char_cursor
    bne !+
    inc char_cursor+1
  !:
    rts
}
print_word: {
    .label w = $a
    lda w+1
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
    rts
}
print_dword: {
    .label dw = $c
    lda dw+2
    sta print_word.w
    lda dw+3
    sta print_word.w+1
    jsr print_word
    lda dw
    sta print_word.w
    lda dw+1
    sta print_word.w+1
    jsr print_word
    rts
}
print_cls: {
    .label sc = 6
    lda #<SCREEN
    sta sc
    lda #>SCREEN
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
    cmp #>SCREEN+$3e8
    bne b1
    lda sc
    cmp #<SCREEN+$3e8
    bne b1
    rts
}
