.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label SCREEN2 = $400+$28
main: {
    .label i = 2
    lda #0
    sta i
  b1:
    lda i
    clc
    adc #1
    ldx i
    inx
    inx
    ldy i
    jsr sum
    ldy i
    sta SCREEN,y
    tya
    clc
    adc #1
    ldx i
    inx
    inx
    jsr sum2
    ldy i
    sta SCREEN2,y
    inc i
    lda i
    cmp #$b
    bne b1
    rts
}
// sum2(byte register(Y) a, byte register(A) b, byte register(X) c)
sum2: {
    sty $ff
    clc
    adc $ff
    stx $ff
    clc
    adc $ff
    rts
}
// sum(byte register(Y) a, byte register(A) b, byte register(X) c)
sum: {
    sty $ff
    clc
    adc $ff
    stx $ff
    clc
    adc $ff
    rts
}
