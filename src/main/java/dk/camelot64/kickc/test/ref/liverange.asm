  jsr main
main: {
    .label a = 2
    ldx #0
    jsr inc
    clc
    adc #4
    sta a
    jsr inc
    clc
    adc a
    rts
}
inc: {
    txa
    clc
    adc #7
    tax
    txa
    rts
}
