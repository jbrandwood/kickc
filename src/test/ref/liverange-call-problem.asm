.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label w1 = 4
  .label w2 = 2
main: {
    lda #<0
    sta w1
    sta w1+1
    jsr incw1
    lda #<0
    sta w2
    sta w2+1
    jsr incw2
    jsr incw1
    jsr incw2
    rts
}
incw2: {
    inc w2
    bne !+
    inc w2+1
  !:
    rts
}
incw1: {
    inc w1
    bne !+
    inc w1+1
  !:
    rts
}
