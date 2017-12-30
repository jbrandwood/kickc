.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const memLo = $fe
  .const memHi = $ff
  .label line_cursor = 3
  .label char_cursor = 5
  jsr main
main: {
    .const f_2pi = $e2e5
    .label i = 2
    lda #<$4fb
    sta setFAC.w
    lda #>$4fb
    sta setFAC.w+1
    jsr setFAC
    jsr divFACby10
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
    sta setFAC.w
    lda #0
    sta setFAC.w+1
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
    bne b17
    rts
  b17:
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp b1
    f_i: .byte 0, 0, 0, 0, 0
    f_127: .byte 0, 0, 0, 0, 0
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
print_word: {
    .label w = 7
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
getFAC: {
    .label return = 7
    jsr $b1aa
    sty $fe
    sta $ff
    lda memLo
    sta return
    lda memHi
    sta return+1
    rts
}
addMEMtoFAC: {
    lda #<main.f_127
    sta prepareMEM.mem
    lda #>main.f_127
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
    lda #<main.f_i
    sta prepareMEM.mem
    lda #>main.f_i
    sta prepareMEM.mem+1
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $bb0f
    rts
}
setFAC: {
    .label w = 7
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
divFACby10: {
    jsr $bafe
    rts
}
