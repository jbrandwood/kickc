.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .const SCREEN2 = $400+$28
  jsr main
main: {
    .label i = 2
    lda #0
    sta i
  b1:
    ldy i
    iny
    lda #2
    clc
    adc i
    tax
    lda i
    jsr sum
    ldy i
    sta SCREEN,y
    iny
    lda #2
    clc
    adc i
    tax
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
    sty $ff
    clc
    adc $ff
    stx $ff
    clc
    adc $ff
    rts
}
sum: {
    sty $ff
    clc
    adc $ff
    stx $ff
    clc
    adc $ff
    rts
}
