.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label nxt = 2
    ldx #0
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  b1:
    ldy #0
    lda (nxt),y
    tay
    cpy #0
    bne b2
    ldy TEXT
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  b2:
    inx
    tya
    sta SCREEN,x
    inc.z nxt
    bne !+
    inc.z nxt+1
  !:
    jmp b1
}
  TEXT: .text "01234567"
  .byte 0
