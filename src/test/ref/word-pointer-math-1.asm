// Tests word pointer math - subtracting two word pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label w1 = $1000
    .label w2 = $1140
    .label SCREEN = $400
    .const wd = (w2-w1)/SIZEOF_WORD
    lda #<wd
    sta SCREEN
    lda #>wd
    sta SCREEN+1
    rts
}
