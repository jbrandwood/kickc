  jsr main
main: {
    ldy #$0
  b1:
    tya
    tax
    inx
    tya
    clc
    adc #$2
    sta sum.c
    jsr sum
    sta $400,y
    tya
    tax
    inx
    tya
    clc
    adc #$2
    sta sum.c
    jsr sum2
    sta $428,y
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
    adc sum.c
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
