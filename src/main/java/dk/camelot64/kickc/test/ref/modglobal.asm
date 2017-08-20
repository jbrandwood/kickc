  .label cnt3 = 2
  jsr main
main: {
    lda #$0
    sta cnt3
    ldy #$0
    ldx #$0
    jsr inccnt
    sta $400
    inx
    jsr inccnt
    sta $401
    rts
}
inccnt: {
    inx
    iny
    inc cnt3
    txa
    rts
}
