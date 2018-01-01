.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label line_cursor = 3
  .label char_cursor = 7
  jsr main
main: {
    .label a = 2
    jsr print_cls
    lda #<$400
    sta line_cursor
    lda #>$400
    sta line_cursor+1
    lda #<$400
    sta char_cursor
    lda #>$400
    sta char_cursor+1
    lda #0
    sta a
  b1:
    lda #$a
    sec
    sbc a
    tay
    cpy a
    bcc b5
    ldx #'+'
    jmp b2
  b5:
    ldx #'-'
  b2:
    sty printu.b
    lda #'<'
    sta printu.op
    jsr printu
    lda a
    cmp #3
    bcs b6
    ldx #'+'
    jmp b3
  b6:
    ldx #'-'
  b3:
    lda #3
    sta printu.b
    lda #'<'
    sta printu.op
    jsr printu
    lda a
    tay
    cmp cs,y
    bcs b7
    ldx #'+'
    jmp b4
  b7:
    ldx #'-'
  b4:
    ldy a
    lda cs,y
    sta printu.b
    lda #'<'
    sta printu.op
    jsr printu
    jsr print_ln
    inc a
    lda a
    cmp #$b
    bne b14
    rts
  b14:
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp b1
    cs: .byte 0, $14, 4, 9, $b, 4, $d, 8, 4, 6
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
printu: {
    .label a = 2
    .label b = 6
    .label op = 5
    lda #' '
    jsr print_char
    lda a
    sta print_byte.b
    jsr print_byte
    lda op
    jsr print_char
    lda b
    sta print_byte.b
    jsr print_byte
    lda #' '
    jsr print_char
    txa
    jsr print_char
    rts
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
print_byte: {
    .label b = 9
    lda b
    lsr
    lsr
    lsr
    lsr
    tay
    lda hextab,y
    jsr print_char
    lda b
    and #$f
    tay
    lda hextab,y
    jsr print_char
    rts
    hextab: .text "0123456789abcdef"
}
print_cls: {
    .label sc = 3
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
