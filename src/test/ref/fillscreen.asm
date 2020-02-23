.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // c = (*SCREEN)
    lda SCREEN
    // fillscreen(c)
    jsr fillscreen
    // }
    rts
}
// fillscreen(byte register(A) c)
fillscreen: {
    .label SCREEN2 = SCREEN+$100
    .label SCREEN3 = SCREEN+$200
    .label SCREEN4 = SCREEN+$3e8
    ldx #0
  __b1:
    // SCREEN[j] = c
    sta SCREEN,x
    // SCREEN2[j] = c
    sta SCREEN2,x
    // SCREEN3[j] = c
    sta SCREEN3,x
    // SCREEN4[j] = c
    sta SCREEN4,x
    // for(byte j : 0..255)
    inx
    cpx #0
    bne __b1
    // }
    rts
}
