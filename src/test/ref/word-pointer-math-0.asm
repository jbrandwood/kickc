// Tests simple word pointer math
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label words = $400
    .label SCREEN = $400+6*$28
    .label w1 = 2
    .label w2 = 2
    lda words+1*SIZEOF_WORD
    sta w1
    lda words+1*SIZEOF_WORD+1
    sta w1+1
    lda w1
    sta SCREEN
    lda w1+1
    sta SCREEN+1
    lda words+2*SIZEOF_WORD
    sta w2
    lda words+2*SIZEOF_WORD+1
    sta w2+1
    lda w2
    sta SCREEN+2
    lda w2+1
    sta SCREEN+3
    rts
}
