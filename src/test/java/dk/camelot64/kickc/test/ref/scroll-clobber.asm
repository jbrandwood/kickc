.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  jsr main
main: {
    .label nxt = 2
    ldx #0
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
  b1:
    ldy #0
    lda (nxt),y
    tay
    cpy #'@'
    bne b2
    ldy TEXT
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
  b2:
    inx
    tya
    sta SCREEN,x
    inc nxt
    bne !+
    inc nxt+1
  !:
    jmp b1
}
  TEXT: .text "01234567@"
