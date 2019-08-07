.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label SCREEN2 = $400+$28
main: {
    .label i = 2
    lda #0
    sta.z i
  b1:
    lda.z i
    clc
    adc #1
    ldx.z i
    inx
    inx
    ldy.z i
    jsr sum
    ldy.z i
    sta SCREEN,y
    tya
    clc
    adc #1
    ldx.z i
    inx
    inx
    jsr sum2
    ldy.z i
    sta SCREEN2,y
    inc.z i
    lda #$b
    cmp.z i
    bne b1
    rts
}
// sum2(byte register(Y) a, byte register(A) b, byte register(X) c)
sum2: {
    sty.z $ff
    clc
    adc.z $ff
    stx.z $ff
    clc
    adc.z $ff
    rts
}
// sum(byte register(Y) a, byte register(A) b, byte register(X) c)
sum: {
    sty.z $ff
    clc
    adc.z $ff
    stx.z $ff
    clc
    adc.z $ff
    rts
}
