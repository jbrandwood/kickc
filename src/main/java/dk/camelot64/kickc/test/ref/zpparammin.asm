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
    sty sum.a
    sta sum.c
    jsr sum
    sta $400,y
    tya
    tax
    inx
    tya
    clc
    adc #$2
    sty sum2.a
    sta sum2.c
    jsr sum2
    sta $428,y
    iny
    cpy #$b
    bne b1
    rts
}
sum2: {
    .label a = 2
    .label c = 3
    txa
    clc
    adc a
    clc
    adc c
    rts
}
sum: {
    .label a = 2
    .label c = 3
    txa
    clc
    adc a
    clc
    adc c
    rts
}
