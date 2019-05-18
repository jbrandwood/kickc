// Live ranges were not functioning properly, when multiple method calls were chained - each modifying different vars.
// w1 and w2 ended up having the same zero-page register as their live range was not propagated properly
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  .label w1 = 4
  .label w2 = 2
main: {
    .label SCREEN = $400
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
    lda w1
    sta SCREEN
    lda w1+1
    sta SCREEN+1
    lda w2
    sta SCREEN+2*SIZEOF_WORD
    lda w2+1
    sta SCREEN+2*SIZEOF_WORD+1
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
