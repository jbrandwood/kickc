.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  jsr main
main: {
    lda SCREEN
    jsr fillscreen
    rts
}
fillscreen: {
    .const SCREEN2 = SCREEN+$100
    .const SCREEN3 = SCREEN+$200
    .const SCREEN4 = SCREEN+$3e8
    ldx #0
  b1:
    sta SCREEN,x
    sta SCREEN2,x
    sta SCREEN3,x
    sta SCREEN4,x
    inx
    cpx #0
    bne b1
    rts
}
