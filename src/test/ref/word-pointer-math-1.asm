// Tests word pointer math - subtracting two word pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label SCREEN = $400
    .label w1 = $1000
    .label w2 = $1140
    .const wd = (w2-w1)/SIZEOF_WORD
    // *SCREEN = wd
    lda #<wd
    sta SCREEN
    lda #>wd
    sta SCREEN+1
    // }
    rts
}
