.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .const SCREEN2 = $400+$28
  jsr main
main: {
    ldx #0
  b1:
    txa
    tay
    iny
    txa
    clc
    adc #2
    sta sum.c
    jsr sum
    sta SCREEN,x
    txa
    tay
    iny
    txa
    clc
    adc #2
    sta sum2.c
    jsr sum2
    sta SCREEN2,x
    inx
    cpx #$b
    bne b1
    rts
}
sum2: {
    .label c = 2
    stx $ff
    tya
    clc
    adc $ff
    clc
    adc c
    rts
}
sum: {
    .label c = 2
    stx $ff
    tya
    clc
    adc $ff
    clc
    adc c
    rts
}
