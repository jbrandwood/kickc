// Tests simple word pointer iteration
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label SCREEN = $400+$28*6
    lda $400+SIZEOF_WORD
    sta SCREEN
    lda $400+SIZEOF_WORD+1
    sta SCREEN+1
    lda $400+SIZEOF_WORD+SIZEOF_WORD
    sta SCREEN+2
    lda $400+SIZEOF_WORD+SIZEOF_WORD+1
    sta SCREEN+3
    lda $400+SIZEOF_WORD+SIZEOF_WORD-SIZEOF_WORD
    sta SCREEN+4
    lda $400+SIZEOF_WORD+SIZEOF_WORD-SIZEOF_WORD+1
    sta SCREEN+5
    rts
}
