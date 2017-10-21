  .const SCREEN = $400
  .const SCROLL = $d016
  TEXT: .text "01234567@"
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
    cmp #'@'
    bne b2
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
    lda TEXT
  b2:
    inx
    sta SCREEN,x
    inc nxt
    bne !+
    inc nxt+1
  !:
    jmp b1
    rts
}
