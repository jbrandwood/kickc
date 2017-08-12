bbegin:
  jsr main
bend:
main: {
  b1_from_main:
    lda #$64
    sta $2
  b1_from_b3:
  b1:
  b2_from_b1:
    lda #$64
    sta $3
  b2_from_b5:
  b2:
    jsr nest1
  b5:
    dec $3
    lda $3
    bne b2_from_b5
  b3:
    dec $2
    lda $2
    bne b1_from_b3
  breturn:
    rts
}
nest1: {
  b1_from_nest1:
    lda #$64
    sta $4
  b1_from_b3:
  b1:
  b2_from_b1:
    lda #$64
  b2_from_b5:
  b2:
    jsr nest2
  b5:
    sec
    sbc #$1
    cmp #$0
    bne b2_from_b5
  b3:
    dec $4
    lda $4
    bne b1_from_b3
  breturn:
    rts
}
nest2: {
  b1_from_nest2:
    ldx #$64
  b1_from_b3:
  b1:
  b2_from_b1:
    ldy #$64
  b2_from_b2:
  b2:
    sty $400
    dey
    cpy #$0
    bne b2_from_b2
  b3:
    dex
    cpx #$0
    bne b1_from_b3
  breturn:
    rts
}
