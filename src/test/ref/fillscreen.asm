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
    .label SCREEN2 = SCREEN+$fa
    .label SCREEN3 = SCREEN+$1f4
    .label SCREEN4 = SCREEN+$2ee
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
    // for(byte j : 0..249)
    inx
    cpx #$fa
    bne __b1
    // }
    rts
}
