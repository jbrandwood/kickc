.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .const SCREEN2 = $400+$28
  jsr main
main: {
    ldy #0
  b1:
    tya
    tax
    inx
    tya
    clc
    adc #2
    sta sum.c
    jsr sum
    sta SCREEN,y
    tya
    tax
    inx
    tya
    clc
    adc #2
    sta sum2.c
    jsr sum2
    sta SCREEN2,y
    iny
    cpy #$b
    bne b1
    rts
}
sum2: {
    .label c = 2
    sty $ff
    txa
    clc
    adc $ff
    clc
    adc c
    rts
}
sum: {
    .label c = 2
    sty $ff
    txa
    clc
    adc $ff
    clc
    adc c
    rts
}
