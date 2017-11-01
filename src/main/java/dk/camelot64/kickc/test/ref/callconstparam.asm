  .label screen = 3
  jsr main
main: {
    lda #2
    sta line.x1
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #line.x0
    jsr line
    lda #5
    sta line.x1
    ldx #line.x0_1
    jsr line
    rts
}
line: {
    .const x0 = 1
    .const x0_1 = 3
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
