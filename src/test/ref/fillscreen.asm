.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda SCREEN
    jsr fillscreen
    rts
}
// fillscreen(byte register(A) c)
fillscreen: {
    .label SCREEN2 = SCREEN+$100
    .label SCREEN3 = SCREEN+$200
    .label SCREEN4 = SCREEN+$3e8
    ldx #0
  __b1:
    sta SCREEN,x
    sta SCREEN2,x
    sta SCREEN3,x
    sta SCREEN4,x
    inx
    cpx #0
    bne __b1
    rts
}
