.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label SCREEN2 = $400+$28
  jsr main
main: {
    .label i = 2
    lda #0
    sta i
  b1:
    ldx i
    inx
    ldy i
    iny
    iny
    lda i
    jsr sum
    ldy i
    sta SCREEN,y
    ldx i
    inx
    iny
    iny
    lda i
    jsr sum2
    ldy i
    sta SCREEN2,y
    inc i
    lda i
    cmp #$b
    bne b1
    rts
}
sum2: {
    stx $ff
    clc
    adc $ff
    sty $ff
    clc
    adc $ff
    rts
}
sum: {
    stx $ff
    clc
    adc $ff
    sty $ff
    clc
    adc $ff
    rts
}
