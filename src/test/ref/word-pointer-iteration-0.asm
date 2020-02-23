// Tests simple word pointer iteration
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label SCREEN = $400+$28*6
    // <*wp
    lda $400+SIZEOF_WORD
    // SCREEN[0] = <*wp
    sta SCREEN
    // >*wp
    lda $400+SIZEOF_WORD+1
    // SCREEN[1] = >*wp
    sta SCREEN+1
    // <*wp
    lda $400+SIZEOF_WORD+SIZEOF_WORD
    // SCREEN[2] = <*wp
    sta SCREEN+2
    // >*wp
    lda $400+SIZEOF_WORD+SIZEOF_WORD+1
    // SCREEN[3] = >*wp
    sta SCREEN+3
    // <*wp
    lda $400+SIZEOF_WORD+SIZEOF_WORD-SIZEOF_WORD
    // SCREEN[4] = <*wp
    sta SCREEN+4
    // >*wp
    lda $400+SIZEOF_WORD+SIZEOF_WORD-SIZEOF_WORD+1
    // SCREEN[5] = >*wp
    sta SCREEN+5
    // }
    rts
}
