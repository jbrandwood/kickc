// Tests a simple word array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label SCREEN = $400+6*$28
    .label words = $400
    .label w1 = 2
    .label w2 = 4
    lda words+1*SIZEOF_WORD
    sta.z w1
    lda words+1*SIZEOF_WORD+1
    sta.z w1+1
    lda.z w1
    sta SCREEN
    lda.z w1+1
    sta SCREEN+1
    lda words+2*SIZEOF_WORD
    sta.z w2
    lda words+2*SIZEOF_WORD+1
    sta.z w2+1
    lda.z w2
    sta SCREEN+2
    lda.z w2+1
    sta SCREEN+3
    rts
}
