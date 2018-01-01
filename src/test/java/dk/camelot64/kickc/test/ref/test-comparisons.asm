.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label line_cursor = 4
  .label char_cursor = 8
  jsr main
main: {
    .label a = 2
    .label i = 3
    jsr print_cls
    lda #<$400
    sta line_cursor
    lda #>$400
    sta line_cursor+1
    lda #0
    sta i
    lda #<$400
    sta char_cursor
    lda #>$400
    sta char_cursor+1
    lda #7
    sta a
  b1:
    lda #$ee
    sec
    sbc a
    tay
    lda a
    sty $ff
    cmp $ff
    bcs b6
    ldx #'+'
    jmp b2
  b6:
    ldx #'-'
  b2:
    sty printu.b
    lda #'<'
    sta printu.op
    jsr printu
    lda a
    cmp #$87
    bcs b7
    ldx #'+'
    jmp b3
  b7:
    ldx #'-'
  b3:
    lda #$87
    sta printu.b
    lda #'<'
    sta printu.op
    jsr printu
    lda a
    ldy i
    cmp cs,y
    bcs b8
    ldx #'+'
    jmp b4
  b8:
    ldx #'-'
  b4:
    ldy i
    lda cs,y
    sta printu.b
    lda #'<'
    sta printu.op
    jsr printu
    lda a
    cmp a
    bcs b9
    ldx #'+'
    jmp b5
  b9:
    ldx #'-'
  b5:
    lda a
    sta printu.b
    lda #'<'
    sta printu.op
    jsr printu
    jsr print_ln
    lda a
    clc
    adc #$10
    sta a
    inc i
    lda i
    cmp #$10
    bne b17
    rts
  b17:
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp b1
    cs: .byte 7, $f7, $17, $e7, $27, $d7, $37, $c7, $47, $b7, $57, $a7, $67, $97, $77, $87
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
    .label b = 7
    .label op = 6
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
    .label b = $a
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
    .label sc = 4
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
