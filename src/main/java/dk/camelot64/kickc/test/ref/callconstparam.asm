  .label screen = 3
  jsr main
main: {
    lda #2
    sta line.x1
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #1
    jsr line
    lda #5
    sta line.x1
    ldx #3
    jsr line
    rts
}
line: {
    .label x1 = 2
  b1:
    txa
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx x1
    bcc b1
    rts
}
