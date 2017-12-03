.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const memLo = $fe
  .const memHi = $ff
  .const f_2pi = $e2e5
  .label char_cursor = 5
  .label line_cursor = 3
  hextab: .byte '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
  f_i: .byte 0, 0, 0, 0, 0
  f_127: .byte 0, 0, 0, 0, 0
  jsr main
main: {
    .label _2 = 9
    .label _11 = 9
    .label i = 2
    lda #$7f
    sta setFAC.w
    lda #0
    sta setFAC.w+1
    jsr setFAC
    lda #<f_127
    sta setMEMtoFAC.mem
    lda #>f_127
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #<$400
    sta line_cursor
    lda #>$400
    sta line_cursor+1
    lda #<$400
    sta char_cursor
    lda #>$400
    sta char_cursor+1
    lda #1
    sta i
  b1:
    lda i
    sta _2
    lda #0
    sta _2+1
    jsr setFAC
    lda #<f_2pi
    sta mulFACbyMEM.mem
    lda #>f_2pi
    sta mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    lda #<f_i
    sta setMEMtoFAC.mem
    lda #>f_i
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #$19
    sta setFAC.w
    lda #0
    sta setFAC.w+1
    jsr setFAC
    jsr divMEMbyFAC
    jsr sinFAC
    lda #<f_127
    sta mulFACbyMEM.mem
    lda #>f_127
    sta mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    jsr addMEMtoFAC
    jsr getFAC
    jsr print_word
    jsr print_ln
    inc i
    lda i
    cmp #$1a
    bne b16
    rts
  b16:
    lda print_ln._0
    sta char_cursor
    lda print_ln._0+1
    sta char_cursor+1
    jmp b1
}
print_ln: {
    .label _0 = 3
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
print_word: {
    .label w = 9
    lda w+1
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
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
    tax
    lda hextab,x
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
getFAC: {
    .label w = 9
    .label return = 9
    jsr $b1aa
    sty $fe
    sta $ff
    lda memLo
    sta w
    lda #0
    sta w+1
    lda memHi
    sta return+1
    rts
}
addMEMtoFAC: {
    lda #<f_127
    sta prepareMEM.mem
    lda #>f_127
    sta prepareMEM.mem+1
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $b867
    rts
}
prepareMEM: {
    .label mem = 7
    lda mem
    sta memLo
    lda mem+1
    sta memHi
    rts
}
mulFACbyMEM: {
    .label mem = 7
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $ba28
    rts
}
sinFAC: {
    jsr $e26b
    rts
}
divMEMbyFAC: {
    lda #<f_i
    sta prepareMEM.mem
    lda #>f_i
    sta prepareMEM.mem+1
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $bb0f
    rts
}
setFAC: {
    .label _0 = 7
    .label w = 9
    lda w
    sta _0
    lda w+1
    sta _0+1
    jsr prepareMEM
    ldy $fe
    lda $ff
    jsr $b391
    rts
}
setMEMtoFAC: {
    .label mem = 7
    jsr prepareMEM
    ldx $fe
    ldy $ff
    jsr $bbd4
    rts
}
