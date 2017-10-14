  .const SCREEN = $400
  jsr main
main: {
    .label j = 3
    .label i = 2
    lda #$64
    sta i
  b1:
    lda #$64
    sta j
  b2:
    jsr nest1
    dec j
    lda j
    bne b2
    dec i
    lda i
    bne b1
    rts
}
nest1: {
    .label i = 4
    lda #$64
    sta i
  b1:
    lda #$64
  b2:
    jsr nest2
    sec
    sbc #$1
    cmp #$0
    bne b2
    dec i
    lda i
    bne b1
    rts
}
nest2: {
    ldx #$64
  b1:
    ldy #$64
  b2:
    sty SCREEN
    dey
    cpy #$0
    bne b2
    dex
    cpx #$0
    bne b1
    rts
}
