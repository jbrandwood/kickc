// Clobber problem in next_char return value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label nxt = 2
main: {
    .label SCREEN = $400
    ldx #0
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
  b1:
    jsr next_char
    tya
    sta SCREEN,x
    inx
    cpx #0
    bne b1
    rts
}
// Find the next char of the text
next_char: {
    ldy #0
    lda (nxt),y
    tay
    cpy #0
    bne b1
    ldy TEXT
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
  b1:
    inc nxt
    bne !+
    inc nxt+1
  !:
    rts
}
  TEXT: .text "cml "
  .byte 0
