// A sub-expression that should not be optimized (+1 to a pointer)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    lda SCREEN+1,x
    sta SCREEN,x
    lda SCREEN+$28+1,x
    sta SCREEN+$28,x
    lda SCREEN+$50+1,x
    sta SCREEN+$50,x
    lda SCREEN+$78+1,x
    sta SCREEN+$78,x
    inx
    cpx #$27
    bne b1
    rts
}
