// Tests simple word pointer iteration
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400+$28*6
    lda $400+1
    sta SCREEN
    lda $400+1+1
    sta SCREEN+1
    lda $400+1+1
    sta SCREEN+2
    lda $400+1+1+1
    sta SCREEN+3
    rts
}
