  jsr main
main: {
    lda #$64
    sta $2
  b1:
    lda #$64
    sta $3
  b2:
    jsr nest1
    dec $3
    lda $3
    bne b2
    dec $2
    lda $2
    bne b1
    rts
}
nest1: {
    lda #$64
    sta $4
  b1:
    lda #$64
  b2:
    jsr nest2
    sec
    sbc #$1
    cmp #$0
    bne b2
    dec $4
    lda $4
    bne b1
    rts
}
nest2: {
    ldx #$64
  b1:
    ldy #$64
  b2:
    sty $400
    dey
    cpy #$0
    bne b2
    dex
    cpx #$0
    bne b1
    rts
}
